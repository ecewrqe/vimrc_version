Function getDirectory(path As String) As String
    getDirectory = Left(path, InStrRev(path, Application.PathSeparator))
End Function

' join path
Function joinPath(path As String, file As String) As String
    If strEndsWith(path, "\") Then
        Joint_path = path & file
    Else
        Joint_path = path & Application.PathSeparator & file
    End If
    joinPath = Joint_path
End Function

' Check if a string ends with a specific substring
Function strEndsWith(target_str As String, search_str As String) As Boolean
    If Len(search_str) > Len(target_str) Then
        Exit Function
    End If
    If Right(target_str, Len(target_str)) = search_str Then
        strEndsWith = True
    End If
End Function

' Read text file
Function readTextFile(read_file_path As String) As String
    Dim buf As String
    Dim bufLine As String
    Open read_file_path For Input As #1
    Do Until EOF(1)
        Line Input #1, bufLine
        buf = buf & bufLine
    Loop
    Close #1
    readTextFile = buf
End Function

' Write text file
Function writeTextFile(write_file_path As String, bufContent As String) As String
    Open write_file_path For Output As #2
    Print #2, bufContent
End Function

' Read and write text file
Function readWriteTextFile(read_file_path As String, write_file_path As String) As String
    Dim buf As String
    Open read_file_path For Input As #1
    Open write_file_path For Output As #2
    Do Until EOF(1)
        Line Input #1, buf
        Print #2, buf
    Loop
    Close #1
    Close #2
End Function

' Check if a folder exists
Function isFolderExists(strFolderPath As String) As Boolean
    isFolderExists = ((GetAttr(strFolderPath) And vbDirectory) = vbDirectory)
End Function

' Check number contained in filename
Function matchNumberFromFilename(inputString As String, ByRef before As String, ByRef after As String) As Boolean
    'Microsoft VBScript Regular Expressions 5.5
    Dim regex As New RegExp
    Dim matches As MatchCollection
    Dim m As Match
    regex.Pattern = "(\D*)\d+(\D*)"
    regex.Global = False
    Set matches = regex.Execute(inputString)
    For Each m In matches
        before = m.SubMatches(0)
        after = m.SubMatches(1)
        MatchNumberFromFilename = True
    Next
End Function

Function callErrorMsg(job As String, message As String) As Integer
    IntRes = MsgBox(job & "処理でエラーが発生しました: " & Chr(13) & Chr(10) & Chr(13) & Chr(10) & _
                    "エラー内容: " & message & Err.Description, vbOKOnly + vbCritical)
End Function

Function isIncludeSharpCh(inputString As String, ByRef figure As Integer, _
            Optional ByRef otherString As String = "", _
            Optional ByRef beforeString As String = "", _
            Optional ByRef afterString As String = "") As Boolean
    Dim i As Integer
    Dim char As String, figureCount As Integer
    char = "#"
    figureCount = 0
    If InStr(inputString, char) = 0 Then
        figure = 0
        isIncludeSharpCh = False
        Exit Function
    End If
    beforeString = Mid(inputString, 1, InStr(inputString, char) - 1)
    For i = InStr(inputString, i, 1) To Len(inputString)
        If Mid(inputString, i, 1) <> char Then
            Exit For
        End If
        figureCount = figureCount + 1
    Next i
    afterString = Mid(inputString, i, Len(inputString))
    otherString = beforeString & afterString
    figure = figureCount
    isIncludeSharpCh = True
End Function

' Check if a file name contains illegal characters
Function isIllegalFileName(inputString As String) As Boolean
    Dim invalidChar As String
    invalidChars = "\/:*?""<>"
    Dim i As Integer
    For i = 1 To Len(invalidChars)
        If InStr(inputString, Mid(invalidChars, i, 1)) > 0 Then
            isIllegalFileName = True
            Exit Function
        End If
    Next
    isIllegalFileName = False
End Function

' Align a number with leading zeros
' Example: alignStringWithZeros(5, 3) returns "005"
Function alignStringWithZeros(number As Integer, length As Integer) As String
    alignStringWithZeros = String(length + 1 - Len(Str(number)), "0") & Trim(Str(number))
End Function

Sub testStrIsEmpty()
    MsgBox strIsEmpty("")
End Sub

' Check if a string is empty
Function strIsEmpty(somestr As String) As Boolean
    strIsEmpty = (Len(somestr) = 0)
End Function

' Check if a file name input is empty
Function assertFileNameInputEmptyError(filenamePattern As String) As Boolean
    If Not strIsEmpty(filenamePattern) Then
        assertFileNameInputEmptyError = True
    End If
End Function

' Get a TextBox object in a specific cell
Function getTextBoxObjectInCell(objectName As String, wSheet As Worksheet) As MSForms.TextBox
    Dim fileNameInputBox As MSForms.TextBox
    Set fileNameInputBox = wSheet.OLEObjects(objectName)
    getTextBoxObjectInCell = fileNameInputBox
End Function

' Get text from a TextBox
Function getTextFromTextBox(testBoxInputBox As MSForms.TextBox) As String
    getTextFromTextBox = testBoxInputBox.Text
End Function

' Get the directory of a file path
Function openFilenameDialog(Optional filter As String = "テキストファイル.*.txt") As String
    Dim Target As String
    Target = Application.GetOpenFilename(filter)
    If Target = "False" Then Exit Function
    openFilenameDialog = Target
End Function

Function toNum(myStr As String) As Integer
    toNum = Val(myStr)
End Function

Function toStr(number As Integer) As String
    toStr = Str(number)
End Function

' Get a Worksheet object by name
Function getSheetObj(sheetName As String) As Worksheet
    getSheetObj = ThisWorkbook.Sheets(sheetName)
End Function

' Clear a specific column in the active worksheet or a specified worksheet
Sub clearColumn(colName As String, Optional ws As Worksheet)
    If ws Then
        ws.Columns(colName).Clear
    Else
        Columns(colName).Clear
    End If
End Sub

' Fill cell background colors to yellow
Sub fillCellBackground_yellow()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        singleCell.Interior.Color = 65535
    Next
End Sub


' Fill cell background colors to green
Sub fillCellBackGround_green()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        singleCell.Interior.Color = 5296274
    Next
End Sub

' Fill cell background colors to blue
Sub fillCellBackground_blue()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        singleCell.Interior.Color = 13998939
    Next
End Sub

' Fill cell background colors to red
Sub fillCellBackground_red()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        selectionArea.Interior.Color = 255
    Next
End Sub

' Clear cell background colors
Sub cleanCellBackground()
    Set selectionArea = Selection()
    selectionArea.Interior.ColorIndex = 0
End Sub

' Clear cell formats
Sub cleanCellStyle()
    Set selectionArea = Selection()
    selectionArea.ClearFormats
End Sub

' Clear cell line styles
Sub cleanCellLineStyle()
    Set selectionArea = Selection()
    selectionArea.Borders.LineStyle = xlLineStyleNone
End Sub

' Draw a thick edge line style selected area
Sub DrawEdgeLineStyle()
    Set selectionArea = Selection()
    selectionArea.BorderAround LineStyle:=xlContinuous
End Sub

' Draw a thick line style selected area
Sub DrawLineStyleThick()
    Set selectionArea = Selection()
    selectionArea.Borders.LineStyle = xlContinuous
    selectionArea.BorderAround LineStyle:=xlContinuous, Weight:=xlThick
End Sub

' Draw a thick edge line style
Sub DrawLineStyle()
    Set selectionArea = Selection()
    selectionArea.Borders.LineStyle = xlContinuous
End Sub

' Merge selected cells
Sub MergeCell()
    Set selectionArea = Selection()
    selectionArea.Merge
End Sub

' Unmerge selected cells
Sub UnMergeCell()
    Set selectionArea = Selection()
    selectionArea.UnMerge
End Sub

' Merge cells by row
Sub MergeCellByRow()
    Set selectionArea = Selection()
    For Each Row In selectionArea.Rows
        Row.Merge
    Next
End Sub

'' Replace "M" in selected cells with a specified month number
Sub MonthStrReplace()
    Set selectionArea = Selection()
    Dim Month As Integer

    Month = InputBox("月", Default:=-1)
    If Month <> -1 Then
        For Each singleCell In selectionArea
            singleCell.Value = Replace(singleCell.Value, "M", Month)
        Next
    End If
End Sub

' Replace a specified string in selected cells
Function StrReplace()
    Set selectionArea = Selection()
    Dim before As String, after As String

    before = "A"
    after = "B"
    For Each singleCell In selectionArea
        singleCell.Value = Replace(singleCell.Value, before, after)
    Next
End Function

' Ctrl+Home Select A1 Cell
' Ctrl+Space Select one column
' Shift+Space Select one row
' Ctrl+- delete cells
' Ctrl+Space Ctrl+- delete one column
' Shift+Space Ctrl+- delete one row
' Ctrl++ insert cells
' Ctrl+Space Ctrl++ insert one column
' Shift+Space Ctrl++ insert one row

' Ctrl+Home Select A1 Cell
Sub SelectBeginColumn()
    Set selectionArea = Selection()
    Set firstCell = selectionArea(1)
    Dim Col As Integer, Row As Integer

    Col = firstCell.Column
    Row = 1
    Cells(Row, Col).Select

End Sub

' Shift+Space
Sub SelectRowInSelectedColumn()
    Set selectionArea = Selection()
    Set firstCell = selectionArea(1)
    Dim Col As Integer, Row As Integer
    Col = firstCell.Column
    Row = InputBox("行", Default:=1)
    Cells(Row, Col).Select
End Sub

' select First Cell in the selected column
Sub selectFirstCellInTheColumn()
    Set selectionArea = Selection()
    Set firstCell = selectionArea(1)
    Dim Col As Integer, Row As Integer
    Col = firstCell.Column
    Row = Cells(Rows.Count, 1).End(xlUp).Row
    Cells(Row, Col).Select
End Sub

' count yellow cells in the selected area
Sub count_yellow_cells()
    Set selectionArea = Selection()
    Dim cell_count As Integer
    Dim singleCellRange As Range
    Dim Count As Integer
    cell_count = 0
    For Each singleCell In selectionArea
        If singleCell.Interior.Color = 65535 Then
            If Range(singleCell.Address).MergeArea.Address Like singleCell.Address & "*" Then
                cell_count = cell_count + 1
            End If
        End If
    Next
    MsgBox cell_count
End Sub

Sub count_green_cells()
    Set selectionArea = Selection()
    Dim cell_count As Integer
    Dim singleCellRange As Range
    Dim Count As Integer
    cell_count = 0
    For Each singleCell In selectionArea
        If singleCell.Interior.Color = 5296274 Then
            If Range(singleCell.Address).MergeArea.Address Like singleCell.Address & "*" Then
                cell_count = cell_count + 1
            End If
        End If
    Next
    MsgBox cell_count
End Sub

Sub count_blue_cells()
    Set selectionArea = Selection()
    Dim cell_count As Integer
    Dim singleCellRange As Range
    Dim Count As Integer
    cell_count = 0
    For Each singleCell In selectionArea
        If singleCell.Interior.Color = 13998939 Then
            If Range(singleCell.Address).MergeArea.Address Like singleCell.Address & "*" Then
                cell_count = cell_count + 1
            End If
        End If
    Next
    MsgBox cell_count
End Sub

Sub count_red_cells()
    Set selectionArea = Selection()
    Dim cell_count As Integer
    Dim singleCellRange As Range
    Dim Count As Integer
    cell_count = 0
    For Each singleCell In selectionArea
        If singleCell.Interior.Color = 255 Then
            If Range(singleCell.Address).MergeArea.Address Like singleCell.Address & "*" Then
                cell_count = cell_count + 1
            End If
        End If
    Next
    MsgBox cell_count
End Sub

Sub count_cell()
    Set selectionArea = Selection()
    Dim cell_count As Integer
    Dim singleCellRange As Range
    Dim Count As Integer
    cell_count = 0
    For Each singleCell In selectionArea
        If Range(singleCell.Address).MergeArea.Address Like singleCell.Address & "*" Then
            cell_count = cell_count + 1
        End If
    Next
    MsgBox cell_count
End Sub

' Save each sheet to CSV
Sub SaveEachSheetToCSV()
    Dim csvFile As String
    Dim i As Integer, j As Integer, ws_count As Integer, start As Integer, FileNumber As Integer
    Dim LR As Integer, LC As Integer
    Dim ws As Worksheet
    Dim cell_content As String

    ws_count = ThisWorkbook.Worksheets.Count

    For start = 1 To ws_count
        Set ws = ThisWorkbook.Worksheets(start)
        FileNumber = FreeFile

        LR = ws.Cells(Rows.Count, 1).End(xlUp).Row
        LC = ws.Cells(1, Columns.Count).End(xlToLeft).Column
        csvFile = ThisWorkbook.path & "\" & ws.Name & ".csv"

        Line = ""
        MsgBox csvFile & "," & LR & "/" & LC
        Open csvFile For Output As #FileNumber
        For i = 1 To LR
            For j = 1 To LC
                cell_content = ws.Cells(i, j).Value
                If Len(Trim(cell_content)) > 0 Then
                    If j <> LC Then
                        Line = Line & cell_content & ","
                    Else
                        Line = Line & cell_content & vbCr
                    End If
                End If
            Next
        Next
        Print #FileNumber, Line
        Close #FileNumber
Continue:
    Next
End Sub

' Save each sheet to CSV with UTF-8 encoding
Sub SaveEachSheetToCSV_utf8()
    Dim csvFile As String
    Dim i As Integer, j As Integer, ws_count As Integer, start As Integer, FileNumber As Integer
    Dim LR As Integer, LC As Integer
    Dim ws As Worksheet
    Dim cell_content As String
    ws_count = ThisWorkbook.Worksheets.Count
    For start = 1 To ws_count
        Set ws = ThisWorkbook.Worksheets(start)
        FileNumber = FreeFile
        LR = ws.Cells(Rows.Count, 1).End(xlUp).Row
        LC = ws.Cells(1, Columns.Count).End(xlToLeft).Column
        csvFile = ThisWorkbook.path & "\" & ws.Name & ".csv"
        Line = ""
        MsgBox csvFile & "," & LR & "/" & LC
        Set Stream = CreateObject("ADODB.Stream")
        Stream.Charset = "UTF-8"
        Stream.Type = 2
        Stream.Open
        For i = 1 To LR
            For j = 1 To LC
                cell_content = ws.Cells(i, j).Value
                If Len(Trim(cell_content)) > 0 Then
                    If j <> LC Then
                        Stream.WriteText cell_content & ","
                    Else
                        Stream.WriteText cell_content, adWriteLine
                    End If
                End If
            Next
        Next
        Stream.SaveToFile csvFile, adSaveCreateOverWrite
        Stream.Close
        Set Stream = Nothing
Continue:
    Next
End Sub


' 空白削除
Function drop_space(original As String) As String
    drop_space = Replace(original, " ", "")
    drop_space = Replace(drop_space, vbTab, "")
    drop_space = Replace(drop_space, "　", "")
End Function

' 空白を含むかどうか
Function isIncludeSpace(original As String) As Boolean
    isIncludeSpace = (InStr(original, " ") > 0) Or _
                        (InStr(original, vbTab) > 0) Or _
                        (InStr(original, "　") > 0)
End Function

' 文字列の先頭が特定の文字列で始まるかどうか
Function strStartsWith(target_str As String, search_str As String) As Boolean
    If Len(search_str) > Len(target_str) Then
        strStartsWith = False
        Exit Function
    End If
    if Left(target_str, Len(search_str)) = search_str Then
        strStartsWith = True
    Else
        strStartsWith = False
    End If
End Function

' 文字列に全角文字が含まれているかどうか
Function isContainsZenkaku(original As String) As Boolean
    Dim i As Long, ch As String
    Dim code As Long

    For i = 1 To Len(original)
        ch = Mid(original, i, 1)
        code = AscW(ch)
        If code >= &HFF01 And code <= &HFF60 Then
            isContainsZenkaku = True
            Exit Function
        ElseIf code >= &H3000 And code <= &H303F Then
            isContainsZenkaku = True
            Exit Function
        End If
    Next i
    isContainsZenkaku = False
End Function

' 文字列を大文字に変換
Function toUpperCase(original As String) As String
    toUpperCase = UCase(original)
End Function

' 文字列を小文字に変換
Function toLowerCase(original As String) As String
    toLowerCase = LCase(original)
End Function

' ログ出力, メッセージとログファイルパスを受け取る
Sub Writelog(message As String, Optional logFilePath As String = "")
    Dim stream As Object
    Dim logPath As String

    If logFilePath = "" Then
        logPath = ThisWorkbook.Path & "\" & LOG_FILE_NAME
    Else
        logPath = logFilePath
    End If

    Set stream = CreateObject("ADODB.Stream")
    With stream
        .Charset = "utf-8"
        .Open
        If Dir(logPath) <> "" Then
            .LoadFromFile logPath
            .Position = .Size
        End IF
        .WriteText Format(Now, "yyyy-mm-dd hh:mm:dd") & " - " & message & vbCrLf
        .SaveToFile logPath, 2
        .Close
    End With
    Set stream = Nothing
End Sub

' SQLデータ型かどうかを判定
Function isSqlDataType(dataType As String) As Boolean
    Dim sqlDataTypes As Variant
    sqlDataTypes = Array("bigint", "boolean", "bytea", "character", "date", "double precision", _
                            "integer", "json", "jsonb", "numeric", "real", "smallint", _
                            "text", "char", "varchar", "nchar", "nvarchar", "ntext", "bit", "varbinary", "image", "bigserial", "timestamp")

    isSqlDataType = (UBound(Filter(sqlDataTypes, dataType)) >= 0)
End Function

' ディレクトリの内容を削除
Sub ClearDirectoryContents(folderPath As String)
    Dim fso As Object
    Dim folder As Object
    Dim file As Object
    Dim subfolder As Object

    Set fso = CreateObject("Scripting.FileSystemObject")
    If fso.FolderExists(folderPath) Then
        Set folder = fso.GetFolder(folderPath)
        For Each file In folder.Files
            file.Delete True
        Next file

        For Each subfolder In folder.SubFolders
            subfolder.Delete True
        Next subfolder
    Else
        MsgBox "Folder does not exist: " & folderPath
    End If
End Sub

' ディレクトリが存在しない場合は作成
Sub CreateFolderIfNotExists(folderPath As String)
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")

    If Not fso.FolderExists(folderPath) Then
        fso.CreateFolder folderPath
    End If
End Sub

' テキストファイルをクリア
Sub ClearTextFile(logFileName As String)
    Dim fileNum As Integer
    fileNum = FreeFile
    Open logFileName For Output As #fileNum
    Close #fileNum
End Sub

' ログファイルの絶対パスを取得
Function getAbsoluteLogFile(logFileName As String) As String
    getAbsoluteLogFile = ThisWorkbook.Path & "\" & logFileName
End Function
