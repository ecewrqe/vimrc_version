import polars as pl

from mock_func import PseudoDAO


class DataFrameCollections:
    def __init__(self, df_pl: pl.DataFrame):
        self.df_pl = df_pl
        self._dao: PseudoDAO = None

    @property
    def dao(self) -> PseudoDAO:
        return self._dao

    @dao.setter
    def dao(self, value: PseudoDAO):
        self._dao = value

    def fw2_get_untrt_proc_tgt_data(self, target_store_code: str, sub_df_pl) -> pl.DataFrame:
        print(sub_df_pl)
        result = self.dao.insert_data(self.dao.table_name, sub_df_pl)
        self.dao.commit()
        print(result)

        df_pl = sub_df_pl.select(["store_code", "intnl_if_file_name", "process_situation_status"])
        df_pl_new = df_pl.filter(
            (pl.col("store_code") == target_store_code)
            & (pl.col("process_situation_status") == "0")
        ).select(["store_code", "intnl_if_file_name"])
        return df_pl_new

    def pl_read_each_case(self):
        df_pl_ut = self.df_pl.group_by("UT").agg(
        ).with_columns([
            pl.col("UT").str.split("-").list.get(-1).alias("UT_number")
        ]).sort("UT_number")
        for ut in df_pl_ut["UT"]:
            df_pl_ut_case = self.df_pl.filter(pl.col("UT") == ut)
            yield df_pl_ut_case.drop("UT"), ut

    def pl_filter_ut(self, ut_case_name: str) -> pl.DataFrame:
        df_pl_ut_case = self.df_pl.filter(pl.col("UT") == ut_case_name)
        return df_pl_ut_case.drop("UT")
