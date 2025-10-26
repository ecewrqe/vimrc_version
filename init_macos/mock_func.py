class PseudoDAO:
    def __init__(self, params: Parameters = None, conn = None):
        self.db_name = "mydatabase"
        if not conn:
            params.database_connection_params = {
                "operation_connection_params": {
                    "host": "localhost",
                    "port": 5432,
                    "dbname": "mydatabase",
                    "user": "myuser",
                    "password": "mypassword"
                }
            }
            dsn = params.database_connection_params["operation_connection_params"]
            self.conn = psycopg2.connect(**dsn)
        else:
            self.conn = conn
        self.cursor = self.conn.cursor()
        self.table_name: str

    def clear_data(self, table_name: str):
        pass

    def read_csv(self, filename: str) -> pl.DataFrame:
        """
        first_head: columns
        second_head: type
        third_head: size
        how to read csv with type
        """
        df = pl.read_csv(
            filename,
            separator=",",
            has_header=True,
            null_values=["NULL", "null", "None", "none", ""],
            dtype=pl.Utf8
        )
        return df

    def read_csv_with_types(self, filename: str) -> pl.DataFrame:
        """
        Read CSV with 3-header format:
        - first_head: column names
        - second_head: data types (VARCHAR, CHAR, TIMESTAMP, etc.)
        - third_head: size constraints
        """
        # Read the first 3 lines to get headers
        with open(filename, 'r', encoding='utf-8') as f:
            lines = [f.readline().strip() for _ in range(3)]

        # Parse headers
        columns = [col.strip() for col in lines[0].split(',')]
        types = [typ.strip() for typ in lines[1].split(',')]

        # Create type mapping for polars
        polars_schema = {}
        for i, (col, sql_type) in enumerate(zip(columns, types)):
            if col and sql_type:  # Skip empty columns
                if sql_type.upper() == 'VARCHAR':
                    polars_schema[col] = pl.Utf8
                elif sql_type.upper() == 'CHAR':
                    polars_schema[col] = pl.Utf8
                elif sql_type.upper() == 'TIMESTAMP':
                    polars_schema[col] = pl.Utf8  # Will convert later
                elif sql_type.upper() in ['INT', 'INTEGER']:
                    polars_schema[col] = pl.Int64
                elif sql_type.upper() in ['FLOAT', 'DECIMAL', 'NUMERIC']:
                    polars_schema[col] = pl.Decimal(18, 4)
                elif sql_type.upper() == 'DATE':
                    polars_schema[col] = pl.Utf8  # Will convert later
                else:
                    polars_schema[col] = pl.Utf8  # Default to string

        # # Read data starting from line 4 (skip the 3 header lines)
        df = pl.read_csv(
            filename,
            separator=",",
            has_header=False,
            skip_rows=3,
            new_columns=list(polars_schema.keys()),
            null_values=["NULL", "null", "None", "none", ""],
            schema=polars_schema
        )

        # # # Convert timestamp columns
        timestamp_cols = [col for col, typ in zip(columns, types)
                        if typ.upper() == 'TIMESTAMP' and col in df.columns]
        for col in timestamp_cols:
            df = df.with_columns([
                # YYYY-MM-DDTHH:MM:SS, if contain T
                pl.when(pl.col(col).str.contains("T"))
                .then(pl.col(col).str.strptime(pl.Datetime("us"), format="%Y-%m-%dT%H:%M:%S", strict=False))
                .otherwise(pl.col(col).str.strptime(pl.Datetime("us"), format="%Y-%m-%d %H:%M:%S", strict=False))
                .alias(col)
            ])

        # Convert date columns
        date_cols = [col for col, typ in zip(columns, types)
                    if typ.upper() == 'DATE' and col in df.columns]
        for col in date_cols:
            df = df.with_columns([
                pl.col(col).str.strptime(pl.Date, format="%Y-%m-%d", strict=False)
                .alias(col)
            ])
        self.get_table_name_from_csv(filename)

        return df
    def get_table_name_from_csv(self, file_name: str):
        self.table_name = os.path.basename(file_name).replace(".csv", "")
    def convert_none(self, df: pl.DataFrame):
        df = df.with_columns([
            pl.when(pl.col(col).str.to_lowercase().is_in(["null", "none"]))
                .then(None).otherwise(pl.col(col))
                .alias(col)
            if df.schema[col] == pl.Utf8 else pl.col(col)
            for col in df.columns
        ])
        return df

    def find_file(self, filename: str, search_dir: str):
        for root, _, files in os.walk(search_dir):
            if filename in files:
                return os.path.join(root, filename)

    def read_sql_file(self, sql_file: str, app_mode: bool = True) -> str:
        base_dir = os.environ.get(
            "LAMBDA_TASK_ROOT", os.getcwd()
        )
        sql_file = self.find_file(sql_file, base_dir)
        with open(sql_file, 'r', encoding='utf-8') as file:
            content = file.read()
            return content

    def execute_query(self, query: str, params: dict = {}) -> pl.DataFrame:
        self.cursor.execute(query, params)
        if self.cursor.description is not None:
            results = self.cursor.fetchall()
            return results

    def execute_transaction(self, queries, sql_params = [{}], exec_multi: bool = False) -> list[pl.DataFrame]:
        try:
            results = self._run_queries(self.conn, queries, sql_params, exec_multi)
            return results
        except Exception as e:
            self.rollback_if_open()

    def rollback_if_open(self):
        try:
            connection = self.conn
            if connection and not connection.closed:
                connection.rollback()
        except Exception as e:
            raise e

    def _run_queries(self, connection, queries, sql_params, exec_multi: bool = False):
        query = queries[0]
        query_params = sql_params[0]
        print(query)
        with connection.cursor() as cursor:
            if exec_multi:
                cursor.executemany(query, query_params)
            else:
                cursor.execute(query, query_params)
            if cursor.description:  # If the query returns rows
                rows = cursor.fetchall()
                columns = [desc[0] for desc in cursor.description]

                if not rows:
                    df_pl = pl.DataFrame(schema=columns)
                    return [df_pl]
                rows_str = [[str(value) if value is not None else "" for value in row] for row in rows]

                data = {col: [row[i] for row in rows_str] for i, col in enumerate(columns)}
                columns_mappings = fetch_types(cursor.description)

                df_pl = pl.DataFrame(data)
                df_pl = df_pl.with_columns([
                    pl.col(col).cast(pl.Decimal(18, 4))
                    for col in columns_mappings["float"]
                ]).with_columns([
                    pl.col(col).str.strptime(pl.Date, format="%Y-%m-%d")
                    for col in columns_mappings["date"]
                ]).with_columns([
                    pl.col(col).str.strptime(pl.Time, format="%H:%M:%S")
                    for col in columns_mappings["time"]
                ]).with_columns([
                    pl.col(col).str.strptime(pl.Datetime("us"), format="%Y-%m-%d %H:%M:%S")
                    for col in columns_mappings["datetime"]
                ]).with_columns([
                    pl.col(col).cast(pl.Int64)
                    for col in columns_mappings["int"]
                ])
                return [df_pl]
            else:
                df_pl = pl.DataFrame({
                    "rowcount": [cursor.rowcount]
                })
                return [df_pl]

    def insert_data(self, table_name: str, df: pl.DataFrame, schema: str = "public"):
        columns = df.columns
        insert_params = ', '.join(['%s'] * len(columns))
        data = prepare_data_to_insert(df)
        column_names = ', '.join(columns)
        insert_query = f"""
            INSERT INTO {table_name} ({column_names})
            VALUES ({insert_params})
        """
        result = self.execute_transaction(queries=[insert_query], sql_params=[data], exec_multi=True)
        return result

    def select_all_df(self, table_name, columns={}) -> pl.DataFrame:
        if columns:
            query = f"SELECT {', '.join(columns)} FROM {table_name}"
        else:
            query = f"SELECT * FROM {table_name}"
        df = self.execute_transaction(queries=[query])[0]
        return df

    def write_to_csv(self, df: pl.DataFrame, filename: str):
        df.write_csv(filename)

    def commit(self):
        self.conn.commit()

    def close(self):
        self.conn.commit()
        self.cursor.close()
        self.conn.close()
