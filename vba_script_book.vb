Function getDirectory(path As String) As String
    getDirectory = Left(path, InStrRev(path, Application.PathSeparator))
End Function

Function joinPath(path As String, file As String) As String
    If strEndsWith(path, "\") Then
        Joint_path = path & file
    Else
        Joint_path = path & Application.PathSeparator & file
    End If
    joinPath = Joint_path
End Function

Function strStartsWith(target_str As String, search_str As String) As Boolean
    If Len(search_str) > Len(target_str) Then
        Exit Function
    End If

    If Left(target_str, Len(target_str)) = search_str Then
        strEndsWith = True
    End If
End Function


Function strEndsWith(target_str As String, search_str As String) As Boolean
    If Len(search_str) > Len(target_str) Then
        Exit Function
    End If
    If Right(target_str, Len(target_str)) = search_str Then
        strEndsWith = True
    End If
End Function

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

Function writeTextFile(write_file_path As String, bufContent As String) As String
    Open write_file_path For Output As #2
    Print #2, bufContent
End Function

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

Function isFolderExists(strFolderPath As String) As Boolean
    isFolderExists = ((GetAttr(strFolderPath) And vbDirectory) = vbDirectory)
End Function

Function matchNumberFormFilename(inputString As String, ByRef before As String, ByRef after As String) As Boolean
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

Function alignStringWithZeros(number As Integer, length As Integer) As String
    alignStringWithZeros = String(length + 1 - Len(Str(number)), "0") & Trim(Str(number))
End Function

Sub testStrIsEmpty()
    MsgBox strIsEmpty("")
End Sub

Function strIsEmpty(somestr As String) As Boolean
    strIsEmpty = (Len(somestr) = 0)
End Function

Function assertFileNameInputEmptyError(filenamePattern As String) As Boolean
    If Not strIsEmpty(filenamePattern) Then
        assertFileNameInputEmptyError = True
    End If
End Function

Function getTextBoxObjectInCell(objectName As String, wSheet As Worksheet) As MSForms.TextBox
    Dim fileNameInputBox As MSForms.TextBox
    Set fileNameInputBox = wSheet.OLEObjects(objectName)
    getTextBoxObjectInCell = fileNameInputBox
End Function

Function getTextFromTextBox(testBoxInputBox As MSForms.TextBox) As String
    getTextFromTextBox = testBoxInputBox.Text
End Function

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

Function getSheetObj(sheetName As String) As Worksheet
    getSheetObj = ThisWorkbook.Sheets(sheetName)
End Function

Sub clearColumn(colName As String, Optional ws As Worksheet)
    If ws Then
        ws.Columns(colName).Clear
    Else
        Columns(colName).Clear
    End If
End Sub

Sub fillCellBackground_yellow()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        singleCell.Interior.Color = 65535
    Next
End Sub

Sub fillCellBackGround_gree()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        singleCell.Interior.Color = 5296274
    Next
End Sub

Sub fillCellBackground_blue()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        singleCell.Interior.Color = 13998939
    Next
End Sub

Sub fillCellBackground_red()
    Set selectionArea = Selection()
    For Each singleCell In selectionArea
        selectionArea.Interior.Color = 255
    Next
End Sub

Sub cleanCellBackground()
    Set selectionArea = Selection()
    selectionArea.Interior.ColorIndex = 0
End Sub

Sub cleanCellStyle()
    Set selectionArea = Selection()
    selectionArea.ClearFormats
End Sub

Sub cleanCellLineStyle()
    Set selectionArea = Selection()
    selectionArea.Borders.LineStyle = xlLineStyleNone
End Sub

Sub DrawAdgeLineStyle()
    Set selectionArea = Selection()
    selectionArea.BorderAround LineStyle:=xlContinuous
End Sub

Sub DrawLineStyleThick()
    Set selectionArea = Selection()
    selectionArea.Borders.LineStyle = xlContinuous
    selectionArea.BorderAround LineStyle:=xlContinuous, Weight:=xlThick
End Sub

Sub DrawLineStyle()
    Set selectionArea = Selection()
    selectionArea.Borders.LineStyle = xlContinuous
End Sub

Sub MergeCell()
    Set selectionArea = Selection()
    selectionArea.Merge
End Sub


Sub UnMergeCell()
    Set selectionArea = Selection()
    selectionArea.UnMerge
End Sub


Sub MergeCellByRow()
    Set selectionArea = Selection()
    For Each Row In selectionArea.Rows
        Row.Merge
    Next
End Sub


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
' Shift+Space Ctrl++ insert onw row
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

Sub selectFirstCellInThColumn()
    Set selectionArea = Selection()
    Set firstCell = selectionArea(1)
    Dim Col As Integer, Row As Integer
    Col = firstCell.Column
    Row = Cells(Rows.Count, 1).End(xlUp).Row
    Cells(Row, Col).Select
End Sub

Sub count_yellow()
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

Sub count_Green()
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

Sub count_Blue()
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

Sub count_Red()
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

Sub count_Cell()
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
