Attribute VB_Name = "ConfigTests"
Option Explicit

Private Declare Sub ExitProcess Lib "kernel32" (ByVal exitCode As Long)
Private checks As Long
Private workFolder As String
Private results As String

Public Sub Main()
    Dim fileNumber As Integer
    Dim exitCode As Long
    Dim folderBase As String
    Dim attempt As Long
    On Error GoTo Failed
    folderBase = App.Path & "\test-" & Format$(Now, "yymmdd-hhnnss")
    workFolder = folderBase
    Do While Len(Dir$(workFolder, vbDirectory)) > 0
        attempt = attempt + 1
        workFolder = folderBase & "-" & CStr(attempt)
    Loop
    MkDir workFolder
    TestEmbeddedRoundTrip
    TestValidation
    TestDamagedExecutables
    TestForms
    CreateSelfReadingExample
    results = results & "PASS: " & CStr(checks) & " checks" & vbCrLf
    GoTo Finished
Failed:
    results = results & "FAIL after " & CStr(checks) & " checks: " & Err.Description & vbCrLf
    exitCode = 1
Finished:
    On Error Resume Next
    Unload frmBuilder
    Unload frmTemplate
    fileNumber = FreeFile
    Open App.Path & "\self-test-results.txt" For Output As #fileNumber
    Print #fileNumber, results;
    Close #fileNumber
    ExitProcess exitCode
End Sub

Private Sub AssertTrue(ByVal condition As Boolean, ByVal description As String)
    If Not condition Then Err.Raise vbObjectError + 1900, "ConfigTests", description
    checks = checks + 1
    results = results & "PASS " & CStr(checks) & ": " & description & vbCrLf
End Sub

Private Function TestPath(ByVal fileName As String) As String
    TestPath = workFolder & "\" & fileName
End Function

Private Function FileBytes(ByVal fileName As String) As String
    Dim fileNumber As Integer
    fileNumber = FreeFile
    Open fileName For Binary Access Read As #fileNumber
    FileBytes = Space$(LOF(fileNumber))
    Get #fileNumber, , FileBytes
    Close #fileNumber
End Function

Private Sub TestEmbeddedRoundTrip()
    Dim before As FtpSettings
    Dim after As FtpSettings
    Dim templateBytes As String
    Dim outputBytes As String
    Dim magic As String * 8
    Dim offset As Long
    Dim length As Long
    Dim fileNumber As Integer
    SetExampleSettings before
    before.UserName = "Demo " & ChrW(&HE9) & " " & ChrW(&H4F60)
    before.Password = "Quotes: ""x"" & symbols <>"
    templateBytes = FileBytes(DemoTemplatePath())
    BuildConfiguredExecutable DemoTemplatePath(), TestPath("round-trip.exe"), before
    ReadEmbeddedSettings TestPath("round-trip.exe"), after
    AssertTrue after.Host = before.Host, "FTP host is embedded and recovered"
    AssertTrue after.UserName = before.UserName, "Unicode FTP username round trip"
    AssertTrue after.Password = before.Password, "FTP password and punctuation round trip"
    outputBytes = FileBytes(TestPath("round-trip.exe"))
    AssertTrue Left$(outputBytes, Len(templateBytes)) = templateBytes, "Every original template byte is preserved"
    AssertTrue FileBytes(DemoTemplatePath()) = templateBytes, "The input template is unchanged"
    fileNumber = FreeFile
    Open TestPath("round-trip.exe") For Binary Access Read As #fileNumber
    Get #fileNumber, LOF(fileNumber) - 15, magic
    Get #fileNumber, , offset
    Get #fileNumber, , length
    AssertTrue magic = "FTPDMO01", "Footer identifies the demo overlay"
    AssertTrue offset = Len(templateBytes), "Footer points immediately after the untouched template"
    AssertTrue LOF(fileNumber) = offset + length + 16, "Payload and footer lengths match the EXE size"
    Close #fileNumber
    before.Password = String$(256, "x")
    BuildConfiguredExecutable DemoTemplatePath(), TestPath("round-trip.exe"), before
    before.Password = "short"
    BuildConfiguredExecutable DemoTemplatePath(), TestPath("round-trip.exe"), before
    ReadEmbeddedSettings TestPath("round-trip.exe"), after
    AssertTrue after.Password = "short", "Shorter replacement has no stale payload"
    AssertTrue Len(Dir$(workFolder & "\ftd*.tmp")) = 0, "Successful builds clean up temporary files"
End Sub

Private Sub ExpectBuildFailure(ByVal templateName As String, ByVal outputName As String, ByRef settings As FtpSettings, ByVal label As String)
    Dim number As Long
    On Error Resume Next
    BuildConfiguredExecutable templateName, outputName, settings
    number = Err.Number
    Err.Clear
    On Error GoTo 0
    AssertTrue number <> 0, label
End Sub

Private Sub ExpectReadFailure(ByVal fileName As String, ByVal label As String)
    Dim settings As FtpSettings
    Dim number As Long
    settings.Host = "keep-the-callers-old-state.invalid"
    On Error Resume Next
    ReadEmbeddedSettings fileName, settings
    number = Err.Number
    Err.Clear
    On Error GoTo 0
    AssertTrue number <> 0, label
    AssertTrue settings.Host = "keep-the-callers-old-state.invalid", "Failed read does not partially change caller settings"
End Sub

Private Sub TestValidation()
    Dim settings As FtpSettings
    Dim saved As String
    Dim templateBytes As String
    Dim heldNumber As Integer
    SetExampleSettings settings
    BuildConfiguredExecutable DemoTemplatePath(), TestPath("preserve.exe"), settings
    saved = FileBytes(TestPath("preserve.exe"))
    templateBytes = FileBytes(DemoTemplatePath())
    settings.Host = "   "
    ExpectBuildFailure DemoTemplatePath(), TestPath("preserve.exe"), settings, "Empty host is rejected"
    AssertTrue FileBytes(TestPath("preserve.exe")) = saved, "Validation failure preserves existing output"
    SetExampleSettings settings
    settings.UserName = ""
    ExpectBuildFailure DemoTemplatePath(), TestPath("preserve.exe"), settings, "Empty username is rejected"
    SetExampleSettings settings
    settings.Password = ""
    ExpectBuildFailure DemoTemplatePath(), TestPath("preserve.exe"), settings, "Empty password is rejected"
    settings.Password = String$(257, "x")
    ExpectBuildFailure DemoTemplatePath(), TestPath("preserve.exe"), settings, "Overlong password is rejected"
    SetExampleSettings settings
    settings.Host = "host" & vbNullChar & ".invalid"
    ExpectBuildFailure DemoTemplatePath(), TestPath("preserve.exe"), settings, "Null characters are rejected"
    SetExampleSettings settings
    ExpectBuildFailure DemoTemplatePath(), TestPath("not-an-exe.cfg"), settings, "Sidecar configuration output is rejected"
    AssertTrue Dir$(TestPath("not-an-exe.cfg")) = "", "No cfg file is generated"
    ExpectBuildFailure DemoTemplatePath(), DemoTemplatePath(), settings, "Overwriting the input template is rejected"
    AssertTrue FileBytes(DemoTemplatePath()) = templateBytes, "Input template remains intact after rejected overwrite"
    ExpectBuildFailure TestPath("absent.exe"), TestPath("output.exe"), settings, "Missing template is reported"
    ExpectBuildFailure TestPath("preserve.exe"), TestPath("output.exe"), settings, "Already configured output cannot be reused as the template"
    ExpectBuildFailure DemoTemplatePath(), TestPath("missing\file.exe"), settings, "Missing output folder is reported"
    heldNumber = FreeFile
    Open TestPath("preserve.exe") For Binary Access Read Lock Read Write As #heldNumber
    ExpectBuildFailure DemoTemplatePath(), TestPath("preserve.exe"), settings, "Locked output is reported"
    Close #heldNumber
    AssertTrue FileBytes(TestPath("preserve.exe")) = saved, "Failed replacement preserves the previous EXE"
    AssertTrue Len(Dir$(workFolder & "\ftd*.tmp")) = 0, "Failed replacement removes its temporary file"
End Sub

Private Sub ChangeLong(ByVal fileName As String, ByVal distanceFromEnd As Long, ByVal value As Long)
    Dim fileNumber As Integer
    fileNumber = FreeFile
    Open fileName For Binary Access Write As #fileNumber
    Put #fileNumber, LOF(fileNumber) - distanceFromEnd + 1, value
    Close #fileNumber
End Sub

Private Sub TestDamagedExecutables()
    Dim settings As FtpSettings
    Dim fileName As String
    Dim fileNumber As Integer
    Dim wrong As String * 8
    SetExampleSettings settings
    ExpectReadFailure TestPath("absent.exe"), "Missing input is reported"
    AssertTrue Dir$(TestPath("absent.exe")) = "", "A missing input is never created"
    ExpectReadFailure DemoTemplatePath(), "Unconfigured template reports missing settings"
    fileName = TestPath("damaged.exe")
    BuildConfiguredExecutable DemoTemplatePath(), fileName, settings
    fileNumber = FreeFile
    Open fileName For Binary Access Write As #fileNumber
    wrong = "BADMAGIC"
    Put #fileNumber, LOF(fileNumber) - 15, wrong
    Close #fileNumber
    ExpectReadFailure fileName, "Corrupted footer marker is rejected"
    BuildConfiguredExecutable DemoTemplatePath(), fileName, settings
    ChangeLong fileName, 8, -1
    ExpectReadFailure fileName, "Negative payload offset is rejected"
    BuildConfiguredExecutable DemoTemplatePath(), fileName, settings
    ChangeLong fileName, 8, FileLen(fileName)
    ExpectReadFailure fileName, "Offset beyond the payload region is rejected"
    BuildConfiguredExecutable DemoTemplatePath(), fileName, settings
    ChangeLong fileName, 4, 1048577
    ExpectReadFailure fileName, "Excessive payload length is rejected before allocation"
    BuildConfiguredExecutable DemoTemplatePath(), fileName, settings
    ChangeLong fileName, 4, 1
    ExpectReadFailure fileName, "Inconsistent payload length is rejected"
    Name fileName As TestPath("renamed.exe")
    AssertTrue Dir$(TestPath("renamed.exe")) <> "", "Rejected EXEs are closed and can be renamed"
End Sub

Private Sub CheckControlBounds(ByVal window As Form)
    Dim item As Control
    Dim parent As Object
    For Each item In window.Controls
        Set parent = item.Container
        AssertTrue item.Left >= 0 And item.Top >= 0, window.Name & "." & item.Name & " has a visible position"
        AssertTrue item.Left + item.Width <= parent.Width And item.Top + item.Height <= parent.Height, window.Name & "." & item.Name & " fits its container"
    Next
End Sub

Private Sub TestForms()
    Dim settings As FtpSettings
    SetExampleSettings settings
    Load frmBuilder
    Load frmTemplate
    CheckControlBounds frmBuilder
    CheckControlBounds frmTemplate
    frmBuilder.ApplySettings settings
    frmBuilder.txtOutput.Text = TestPath("form.exe")
    AssertTrue frmBuilder.BuildCurrentExecutable(), "Builder form creates a configured EXE"
    AssertTrue frmBuilder.VerifyCurrentExecutable(), "Builder verifies its own output without running it"
    AssertTrue frmTemplate.OpenEmbeddedConfiguration(TestPath("form.exe")), "Template form reads the embedded payload"
    AssertTrue frmTemplate.txtHost.Text = settings.Host, "Template displays the embedded host"
    AssertTrue frmTemplate.txtUserName.Text = settings.UserName, "Template displays the embedded username"
    AssertTrue frmTemplate.txtPassword.Text = settings.Password, "Template restores the embedded password"
    AssertTrue frmTemplate.txtPassword.PasswordChar = "*", "Password is masked by default"
    frmTemplate.chkShowPassword.Value = vbChecked
    AssertTrue frmTemplate.txtPassword.PasswordChar = "", "Show-password checkbox works"
    frmTemplate.chkShowPassword.Value = vbUnchecked
    AssertTrue frmTemplate.txtPassword.PasswordChar = "*", "Password masking can be restored"
    AssertTrue Not frmTemplate.OpenEmbeddedConfiguration(TestPath("absent.exe")), "Template presents a failed read"
    AssertTrue frmTemplate.txtPassword.Text = "", "Failed read clears stale fields"
    frmBuilder.txtHost.Text = ""
    AssertTrue Not frmBuilder.BuildCurrentExecutable(), "Builder blocks invalid form input"
    AssertTrue InStr(frmBuilder.lblStatus.Caption, "Not built:") = 1, "Builder shows an explanatory error"
End Sub

Private Sub CreateSelfReadingExample()
    Dim settings As FtpSettings
    settings.Host = "ftp.embedded.invalid"
    settings.UserName = "self-test-user"
    settings.Password = "test-only-secret"
    BuildConfiguredExecutable DemoTemplatePath(), App.Path & "\SelfConfigured.exe", settings
    AssertTrue FileLen(App.Path & "\SelfConfigured.exe") > FileLen(DemoTemplatePath()), "Self-reading EXE is available for the process-level test"
End Sub
