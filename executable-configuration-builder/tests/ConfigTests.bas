Attribute VB_Name = "ConfigTests"
Option Explicit

Private Declare Sub ExitProcess Lib "kernel32" (ByVal exitCode As Long)
Private checks As Long
Private workFolder As String
Private results As String

Public Sub Main()
    Dim logNumber As Integer
    Dim exitCode As Long
    Dim failure As String
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
    TestRoundTrip
    TestValidation
    TestDamagedFiles
    TestForms
    results = results & "PASS: " & CStr(checks) & " checks" & vbCrLf
    GoTo Finished
Failed:
    failure = Err.Description
    results = results & "FAIL after " & CStr(checks) & " checks: " & failure & vbCrLf
    exitCode = 1
Finished:
    On Error Resume Next
    Unload frmBuilder
    Unload frmViewer
    logNumber = FreeFile
    Open App.Path & "\self-test-results.txt" For Output As #logNumber
    Print #logNumber, results;
    Close #logNumber
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

Private Sub TestRoundTrip()
    Dim before As DisplaySettings
    Dim after As DisplaySettings
    Dim fileNumber As Integer
    Dim signature As String * 8
    Dim payloadLength As Long
    Dim fileName As String
    fileName = TestPath("round-trip.cfg")
    SetDefaultSettings before
    before.Title = "Saved " & ChrW(&HE9) & " " & ChrW(&H4F60)
    before.Message = "First line" & vbCrLf & "Quotes: ""hello""; symbols: <>&"
    before.Theme = "Dark"
    before.ShowTimestamp = False
    SaveConfiguration fileName, before
    ReadConfiguration fileName, after
    AssertTrue after.Title = before.Title, "Unicode title round trip"
    AssertTrue after.Message = before.Message, "Multiline message and punctuation round trip"
    AssertTrue after.Theme = "Dark", "Theme round trip"
    AssertTrue after.ShowTimestamp = False, "False Boolean round trip"

    fileNumber = FreeFile
    Open fileName For Binary Access Read As #fileNumber
    Get #fileNumber, , signature
    Get #fileNumber, , payloadLength
    AssertTrue signature = "VBCFG001", "Versioned data-file signature"
    AssertTrue LOF(fileNumber) = 12 + payloadLength, "Header length matches the actual payload"
    Close #fileNumber

    before.Message = String$(2000, "x")
    SaveConfiguration fileName, before
    before.Message = "Short"
    before.ShowTimestamp = True
    SaveConfiguration fileName, before
    ReadConfiguration fileName, after
    AssertTrue after.Message = "Short", "Shorter replacement has no stale data"
    AssertTrue after.ShowTimestamp, "True Boolean round trip"
    AssertTrue Len(Dir$(workFolder & "\vbc*.tmp")) = 0, "Successful saves leave no temporary file"
End Sub

Private Sub ExpectSaveFailure(ByVal fileName As String, ByRef settings As DisplaySettings, ByVal label As String)
    Dim errorNumber As Long
    On Error Resume Next
    SaveConfiguration fileName, settings
    errorNumber = Err.Number
    Err.Clear
    On Error GoTo 0
    AssertTrue errorNumber <> 0, label
End Sub

Private Sub ExpectReadFailure(ByVal fileName As String, ByVal label As String)
    Dim settings As DisplaySettings
    Dim errorNumber As Long
    settings.Title = "Keep the caller's old state"
    On Error Resume Next
    ReadConfiguration fileName, settings
    errorNumber = Err.Number
    Err.Clear
    On Error GoTo 0
    AssertTrue errorNumber <> 0, label
    AssertTrue settings.Title = "Keep the caller's old state", "Failed load leaves caller settings unchanged"
End Sub

Private Sub TestValidation()
    Dim settings As DisplaySettings
    Dim saved As String
    Dim fileName As String
    Dim heldNumber As Integer
    fileName = TestPath("preserve.cfg")
    SetDefaultSettings settings
    SaveConfiguration fileName, settings
    saved = FileBytes(fileName)
    settings.Title = "   "
    ExpectSaveFailure fileName, settings, "Whitespace-only title is rejected"
    AssertTrue FileBytes(fileName) = saved, "Validation failure preserves existing file"
    SetDefaultSettings settings
    settings.Message = ""
    ExpectSaveFailure fileName, settings, "Empty message is rejected"
    settings.Message = String$(2001, "x")
    ExpectSaveFailure fileName, settings, "Overlong message is rejected"
    SetDefaultSettings settings
    settings.Title = String$(81, "x")
    ExpectSaveFailure fileName, settings, "Overlong title is rejected"
    SetDefaultSettings settings
    settings.Theme = "Unknown"
    ExpectSaveFailure fileName, settings, "Unknown theme is rejected"
    SetDefaultSettings settings
    ExpectSaveFailure TestPath("not-an-output.exe"), settings, "Executable output paths are rejected"
    AssertTrue Dir$(TestPath("not-an-output.exe")) = "", "No executable output is created"
    ExpectSaveFailure TestPath("missing\file.cfg"), settings, "Missing output folder is reported"
    ExpectSaveFailure "\\server\share\example.cfg", settings, "UNC network paths are rejected"

    ' Holding the target open forces replacement to fail after temporary-file creation.
    heldNumber = FreeFile
    Open fileName For Binary Access Read Lock Read Write As #heldNumber
    ExpectSaveFailure fileName, settings, "Locked output is reported"
    Close #heldNumber
    AssertTrue FileBytes(fileName) = saved, "Failed replacement preserves the old file"
    AssertTrue Len(Dir$(workFolder & "\vbc*.tmp")) = 0, "Failed replacement cleans up its temporary file"
End Sub

Private Sub WriteFixture(ByVal fileName As String, ByVal magic As String, ByVal length As Long, ByVal content As String)
    Dim fileNumber As Integer
    Dim signature As String * 8
    signature = magic
    fileNumber = FreeFile
    Open fileName For Output As #fileNumber
    Close #fileNumber
    Open fileName For Binary Access Write As #fileNumber
    Put #fileNumber, , signature
    Put #fileNumber, , length
    Put #fileNumber, , content
    Close #fileNumber
End Sub

Private Sub TestDamagedFiles()
    Dim fileName As String
    Dim fileNumber As Integer
    Dim bag As New PropertyBag
    Dim payload() As Byte
    Dim payloadLength As Long
    Dim signature As String * 8
    fileName = TestPath("damaged.cfg")
    ExpectReadFailure TestPath("absent.cfg"), "Missing input file is reported"
    AssertTrue Dir$(TestPath("absent.cfg")) = "", "Reading a missing file does not create it"
    fileNumber = FreeFile
    Open fileName For Output As #fileNumber
    Close #fileNumber
    ExpectReadFailure fileName, "Empty file is rejected"
    WriteFixture fileName, "BADMAGIC", 1, "x"
    ExpectReadFailure fileName, "Wrong signature is rejected"
    WriteFixture fileName, "VBCFG001", -1, "x"
    ExpectReadFailure fileName, "Negative payload length is rejected"
    WriteFixture fileName, "VBCFG001", 1048577, "x"
    ExpectReadFailure fileName, "Oversized payload length is rejected before allocation"
    WriteFixture fileName, "VBCFG001", 10, "x"
    ExpectReadFailure fileName, "Truncated payload is rejected"
    WriteFixture fileName, "VBCFG001", 1, "extra"
    ExpectReadFailure fileName, "Unexpected trailing data is rejected"
    WriteFixture fileName, "VBCFG001", 4, "junk"
    ExpectReadFailure fileName, "Invalid PropertyBag data is rejected"

    bag.WriteProperty "Title", "Has missing fields"
    payload = bag.Contents
    payloadLength = UBound(payload) - LBound(payload) + 1
    signature = "VBCFG001"
    fileNumber = FreeFile
    Open fileName For Output As #fileNumber
    Close #fileNumber
    Open fileName For Binary Access Write As #fileNumber
    Put #fileNumber, , signature
    Put #fileNumber, , payloadLength
    Put #fileNumber, , payload
    Close #fileNumber
    ExpectReadFailure fileName, "Missing setting properties are rejected"
    Name fileName As TestPath("renamed.cfg")
    AssertTrue Dir$(TestPath("renamed.cfg")) <> "", "Rejected files are closed and can be renamed"
End Sub

Private Sub CheckControlBounds(ByVal window As Form)
    Dim item As Control
    Dim parent As Object
    For Each item In window.Controls
        Set parent = item.Container
        AssertTrue item.Left >= 0 And item.Top >= 0, window.Name & "." & item.Name & " has a visible position"
        AssertTrue item.Left + item.Width <= parent.Width And item.Top + item.Height <= parent.Height, window.Name & "." & item.Name & " fits inside its container"
    Next
End Sub

Private Sub TestForms()
    Dim settings As DisplaySettings
    SetDefaultSettings settings
    settings.Title = "Form integration"
    settings.Message = "Written through the builder; restored through the viewer."
    settings.Theme = "Dark"
    settings.ShowTimestamp = False
    Load frmBuilder
    Load frmViewer
    CheckControlBounds frmBuilder
    CheckControlBounds frmViewer
    frmBuilder.ApplySettings settings
    frmBuilder.txtFileName.Text = TestPath("form.cfg")
    AssertTrue frmBuilder.SaveCurrentFile(), "Builder saves settings through its UI handler"
    AssertTrue frmViewer.OpenConfiguration(TestPath("form.cfg")), "Viewer loads the builder's saved file"
    AssertTrue frmViewer.lblPreviewTitle.Caption = settings.Title, "Viewer restores the title"
    AssertTrue frmViewer.txtPreviewMessage.Text = settings.Message, "Viewer restores the message"
    AssertTrue frmViewer.lblTimestamp.Caption = "", "Timestamp remains hidden when disabled"
    AssertTrue frmViewer.fraPreview.BackColor = RGB(35, 40, 48), "Dark theme reaches the preview"
    settings.Theme = "Light"
    settings.ShowTimestamp = True
    SaveConfiguration TestPath("form.cfg"), settings
    AssertTrue frmViewer.OpenConfiguration(TestPath("form.cfg")), "Viewer reloads updated settings"
    AssertTrue frmViewer.fraPreview.BackColor = vbWhite, "Light theme reaches the preview"
    AssertTrue Len(frmViewer.lblTimestamp.Caption) > 0, "Enabled timestamp is displayed"
    AssertTrue Not frmViewer.OpenConfiguration(TestPath("absent.cfg")), "Viewer reports a failed load"
    AssertTrue frmViewer.txtPreviewMessage.Text = "", "Failed viewer load clears stale content"
    AssertTrue InStr(frmViewer.lblStatus.Caption, "Not loaded:") = 1, "Viewer presents an explanatory error"
    frmBuilder.txtTitle.Text = ""
    AssertTrue Not frmBuilder.SaveCurrentFile(), "Builder blocks invalid form input"
    AssertTrue InStr(frmBuilder.lblStatus.Caption, "Not saved:") = 1, "Builder presents an explanatory error"
End Sub
