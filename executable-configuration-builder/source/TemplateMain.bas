Attribute VB_Name = "TemplateMain"
Option Explicit

Private Declare Sub ExitProcess Lib "kernel32" (ByVal exitCode As Long)

Public Sub Main()
    If LCase$(Trim$(Command$)) = "/verify-self" Then
        VerifyOwnExecutable
    Else
        frmTemplate.Show
    End If
End Sub

Private Sub VerifyOwnExecutable()
    Dim settings As FtpSettings
    Dim fileNumber As Integer
    Dim report As String
    Dim exitCode As Long
    On Error GoTo Failed
    ReadEmbeddedSettings OwnExecutablePath(), settings
    report = "PASS: settings read from own EXE" & vbCrLf
    report = report & "Host=" & settings.Host & vbCrLf
    report = report & "UserName=" & settings.UserName & vbCrLf
    report = report & "PasswordLength=" & CStr(Len(settings.Password)) & vbCrLf
    GoTo Finished
Failed:
    report = "FAIL: " & Err.Description & vbCrLf
    exitCode = 1
Finished:
    On Error Resume Next
    fileNumber = FreeFile
    Open OwnExecutablePath() & ".verification.txt" For Output As #fileNumber
    Print #fileNumber, report;
    Close #fileNumber
    ExitProcess exitCode
End Sub
