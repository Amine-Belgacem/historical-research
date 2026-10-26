' Historical source excerpt. Not a standalone project.
' Source line ranges and original hashes are recorded in evidence/source-manifest.json.

' Original lines 134-140: TransactionID
Private Function TransactionID() As Double
    If dTransID = 2 ^ 32 - 1 Then
        dTransID = 1
    End If
    TransactionID = dTransID
    dTransID = dTransID + 1
End Function

' Original lines 172-199: sckMain_DataArrival
Private Sub sckMain_DataArrival(ByVal bytesTotal As Long)
    Dim sCommand As String, sData As String, sbuffer As String, sParams() As String
    Dim i As Long
    Do
        Call sckMain.PeekData(sbuffer, vbString, bytesTotal)
        If InStr(1, sbuffer, vbCrLf) = 0 Then
            Exit Sub
        End If
        If InStr(1, sbuffer, " ") Then
            sCommand = Mid$(sbuffer, 1, InStr(1, sbuffer, " ") - 1)
        Else
            sCommand = Mid$(sbuffer, 1, InStr(1, sbuffer, vbCrLf) - 1)
        End If
        If sCommand = "MSG" Or sCommand = "NOT" Then
            i = InStr(1, sbuffer, vbCrLf)
            sParams() = Split(Mid$(sbuffer, 1, i - 1), " ")
            If CLng(Len(Mid$(sbuffer, i + 2))) < CLng(sParams(3)) Then
                Exit Do
            End If
            sData = Mid(GetData(vbNullString, False, i + sParams(3) + 1), i + 2)
        Else
            sData = GetData(sbuffer)
            sParams() = Split(sData, " ")
            sData = vbNullString
        End If
            Call ProcessData(sParams, sData)
    Loop While sckMain.BytesReceived <> 0
End Sub

' Original lines 279-294: GetData
Private Function GetData(sbuffer As String, Optional bTrim As Boolean = True, Optional lLength As Long = 0) As String
    Dim sData As String
    Dim i As Long
    If lLength = 0 Then
        i = InStr(1, sbuffer, vbCrLf, vbTextCompare)
        Call sckMain.GetData(sData, vbString, i + 1)
    Else
        Call sckMain.GetData(sData, vbString, lLength)
    End If
    If bTrim = True Then
        GetData = Mid(sData, 1, Len(sData) - 2)
    Else
        GetData = sData
    End If
    Debug.Print ">>>: " & GetData
End Function
