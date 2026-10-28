Attribute VB_Name = "ViewerMain"
Option Explicit

Public Sub Main()
    Dim fileName As String
    fileName = Trim$(Command$)
    If Len(fileName) >= 2 Then
        If Left$(fileName, 1) = Chr$(34) And Right$(fileName, 1) = Chr$(34) Then
            fileName = Mid$(fileName, 2, Len(fileName) - 2)
        End If
    End If
    frmViewer.Show
    If Len(fileName) > 0 Then frmViewer.OpenConfiguration fileName
End Sub
