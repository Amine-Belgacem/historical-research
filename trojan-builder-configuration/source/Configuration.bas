Attribute VB_Name = "Configuration"
Option Explicit

' Builder and template share this EXE-overlay format. No networking is performed.
Public Type FtpSettings
    Host As String
    UserName As String
    Password As String
End Type

Private Const FOOTER_MAGIC As String = "FTPDMO01"
Private Const FOOTER_BYTES As Long = 16
Private Const TEMPLATE_MARKER As String = "FTPDEMO-TEMPLATE-07A2"
Private Const MAX_TEMPLATE_BYTES As Long = 16777216
Private Const MAX_PAYLOAD_BYTES As Long = 1048576
Private Const CONFIG_ERROR As Long = vbObjectError + 1800
Private Const MOVE_REPLACE_EXISTING As Long = 1
Private Const MOVE_WRITE_THROUGH As Long = 8

Private Declare Function GetFullPathName Lib "kernel32" Alias "GetFullPathNameA" (ByVal fileName As String, ByVal bufferSize As Long, ByVal buffer As String, ByVal filePart As Long) As Long
Private Declare Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal folder As String, ByVal prefix As String, ByVal uniqueNumber As Long, ByVal buffer As String) As Long
Private Declare Function MoveFileEx Lib "kernel32" Alias "MoveFileExA" (ByVal existingName As String, ByVal newName As String, ByVal flags As Long) As Long

Public Sub SetExampleSettings(ByRef settings As FtpSettings)
    settings.Host = "ftp.example.invalid"
    settings.UserName = "demo-user"
    settings.Password = "example-password"
End Sub

Public Function OwnExecutablePath() As String
    OwnExecutablePath = App.Path & IIf(Right$(App.Path, 1) = "\", "", "\") & App.EXEName & ".exe"
End Function

Public Function DemoTemplatePath() As String
    DemoTemplatePath = App.Path & IIf(Right$(App.Path, 1) = "\", "", "\") & "TrojanConfigTemplate.exe"
End Function

Public Function DefaultOutputPath() As String
    DefaultOutputPath = App.Path & IIf(Right$(App.Path, 1) = "\", "", "\") & "ConfiguredExample.exe"
End Function

Public Sub ValidateSettings(ByRef settings As FtpSettings)
    ValidateField settings.Host, "FTP host", 253
    ValidateField settings.UserName, "FTP username", 128
    ValidateField settings.Password, "FTP password", 256
End Sub

Private Sub ValidateField(ByVal value As String, ByVal label As String, ByVal maximum As Long)
    If Len(Trim$(value)) = 0 Or Len(value) > maximum Then
        Err.Raise CONFIG_ERROR, "Configuration", label & " must contain 1 to " & maximum & " characters."
    End If
    If InStr(value, vbNullChar) > 0 Or InStr(value, vbCr) > 0 Or InStr(value, vbLf) > 0 Then
        Err.Raise CONFIG_ERROR, "Configuration", label & " cannot contain line breaks or null characters."
    End If
End Sub

Public Function ExecutablePath(ByVal fileName As String) As String
    Dim buffer As String
    Dim length As Long
    fileName = Trim$(fileName)
    If InStr(fileName, vbNullChar) > 0 Or LCase$(Right$(fileName, 4)) <> ".exe" Then
        Err.Raise CONFIG_ERROR, "Configuration", "Choose a local executable filename ending in .exe."
    End If
    If Left$(fileName, 2) = "\\" Then
        Err.Raise CONFIG_ERROR, "Configuration", "Choose a local folder for this demonstration."
    End If
    buffer = String$(260, vbNullChar)
    length = GetFullPathName(fileName, Len(buffer), buffer, 0)
    If length = 0 Or length >= Len(buffer) Then
        Err.Raise CONFIG_ERROR, "Configuration", "The executable path is invalid or too long."
    End If
    ExecutablePath = Left$(buffer, length)
End Function

Private Sub CheckPeHeader(ByVal fileNumber As Integer)
    Dim dosSignature As String * 2
    Dim peSignature As String * 4
    Dim peOffset As Long
    If LOF(fileNumber) < 64 Then Err.Raise CONFIG_ERROR, , "The file is not a Windows executable."
    Get #fileNumber, 1, dosSignature
    Get #fileNumber, 61, peOffset
    If dosSignature <> "MZ" Or peOffset < 64 Or peOffset > LOF(fileNumber) - 24 Then
        Err.Raise CONFIG_ERROR, , "The executable header is invalid."
    End If
    Get #fileNumber, peOffset + 1, peSignature
    If peSignature <> "PE" & vbNullChar & vbNullChar Then
        Err.Raise CONFIG_ERROR, , "The PE signature is missing."
    End If
End Sub

Private Function CheckDemoTemplate(ByVal fileName As String) As Long
    Dim fileNumber As Integer
    Dim fileOpen As Boolean
    Dim image As String
    Dim wideMarker As String
    Dim footer As String * 8
    Dim index As Long
    Dim savedNumber As Long
    Dim savedDescription As String
    On Error GoTo Failed
    If FileLen(fileName) > MAX_TEMPLATE_BYTES Then Err.Raise CONFIG_ERROR, , "The demo template is too large."
    fileNumber = FreeFile
    Open fileName For Binary Access Read Lock Write As #fileNumber
    fileOpen = True
    CheckPeHeader fileNumber
    image = Space$(LOF(fileNumber))
    Get #fileNumber, 1, image
    For index = 1 To Len(TEMPLATE_MARKER)
        wideMarker = wideMarker & Mid$(TEMPLATE_MARKER, index, 1) & vbNullChar
    Next
    If InStr(image, TEMPLATE_MARKER) = 0 And InStr(image, wideMarker) = 0 Then
        Err.Raise CONFIG_ERROR, , "Use TrojanConfigTemplate.exe built from this example's Template.vbp project."
    End If
    Get #fileNumber, LOF(fileNumber) - FOOTER_BYTES + 1, footer
    If footer = FOOTER_MAGIC Then Err.Raise CONFIG_ERROR, , "Use the unconfigured template, not an already configured output."
    CheckDemoTemplate = LOF(fileNumber)
    Close #fileNumber
    Exit Function
Failed:
    savedNumber = Err.Number
    savedDescription = Err.Description
    On Error Resume Next
    If fileOpen Then Close #fileNumber
    On Error GoTo 0
    Err.Raise savedNumber, "CheckDemoTemplate", savedDescription
End Function

Public Sub BuildConfiguredExecutable(ByVal templateName As String, ByVal outputName As String, ByRef settings As FtpSettings)
    Dim bag As New PropertyBag
    Dim payload() As Byte
    Dim payloadLength As Long
    Dim payloadOffset As Long
    Dim magic As String * 8
    Dim fileNumber As Integer
    Dim fileOpen As Boolean
    Dim temporaryName As String
    Dim temporaryBuffer As String
    Dim folder As String
    Dim savedNumber As Long
    Dim savedDescription As String
    On Error GoTo BuildFailed

    ValidateSettings settings
    templateName = ExecutablePath(templateName)
    outputName = ExecutablePath(outputName)
    If StrComp(templateName, outputName, vbTextCompare) = 0 Then
        Err.Raise CONFIG_ERROR, , "Choose an output filename different from the template."
    End If
    payloadOffset = CheckDemoTemplate(templateName)
    bag.WriteProperty "FtpHost", settings.Host
    bag.WriteProperty "FtpUserName", settings.UserName
    bag.WriteProperty "FtpPassword", settings.Password
    payload = bag.Contents
    payloadLength = UBound(payload) - LBound(payload) + 1
    magic = FOOTER_MAGIC

    folder = Left$(outputName, InStrRev(outputName, "\"))
    temporaryBuffer = String$(260, vbNullChar)
    If GetTempFileName(folder, "ftd", 0, temporaryBuffer) = 0 Then
        Err.Raise CONFIG_ERROR, , "Cannot create a temporary file. Check the output folder and write permission."
    End If
    temporaryName = Left$(temporaryBuffer, InStr(temporaryBuffer, vbNullChar) - 1)
    FileCopy templateName, temporaryName
    fileNumber = FreeFile
    Open temporaryName For Binary Access Write Lock Read Write As #fileNumber
    fileOpen = True
    ' VB positions start at 1. Append after the last existing byte.
    Seek #fileNumber, LOF(fileNumber) + 1
    Put #fileNumber, , payload
    Put #fileNumber, , magic
    Put #fileNumber, , payloadOffset
    Put #fileNumber, , payloadLength
    Close #fileNumber
    fileOpen = False
    If MoveFileEx(temporaryName, outputName, MOVE_REPLACE_EXISTING Or MOVE_WRITE_THROUGH) = 0 Then
        Err.Raise CONFIG_ERROR, , "Cannot replace the output. Close any program holding it open."
    End If
    Exit Sub
BuildFailed:
    savedNumber = Err.Number
    savedDescription = Err.Description
    On Error Resume Next
    If fileOpen Then Close #fileNumber
    If Len(temporaryName) > 0 Then Kill temporaryName
    On Error GoTo 0
    Err.Raise savedNumber, "BuildConfiguredExecutable", savedDescription
End Sub

Public Sub ReadEmbeddedSettings(ByVal fileName As String, ByRef settings As FtpSettings)
    Dim bag As New PropertyBag
    Dim loaded As FtpSettings
    Dim payload() As Byte
    Dim payloadLength As Long
    Dim payloadOffset As Long
    Dim magic As String * 8
    Dim fileNumber As Integer
    Dim fileOpen As Boolean
    Dim savedNumber As Long
    Dim savedDescription As String
    On Error GoTo ReadFailed
    fileName = ExecutablePath(fileName)
    If FileLen(fileName) < 64 + FOOTER_BYTES Then Err.Raise CONFIG_ERROR, , "The executable is incomplete."
    fileNumber = FreeFile
    Open fileName For Binary Access Read Lock Write As #fileNumber
    fileOpen = True
    CheckPeHeader fileNumber
    Get #fileNumber, LOF(fileNumber) - FOOTER_BYTES + 1, magic
    Get #fileNumber, , payloadOffset
    Get #fileNumber, , payloadLength
    If magic <> FOOTER_MAGIC Then
        Err.Raise CONFIG_ERROR, , "No embedded demo settings were found. Use the builder to configure the template first."
    End If
    If payloadLength < 1 Or payloadLength > MAX_PAYLOAD_BYTES Then
        Err.Raise CONFIG_ERROR, , "The embedded settings length is invalid."
    End If
    If payloadOffset < 64 Or payloadOffset > LOF(fileNumber) - FOOTER_BYTES Then
        Err.Raise CONFIG_ERROR, , "The embedded settings offset is invalid."
    End If
    If payloadLength <> LOF(fileNumber) - FOOTER_BYTES - payloadOffset Then
        Err.Raise CONFIG_ERROR, , "The embedded settings do not match the executable length."
    End If
    ReDim payload(0 To payloadLength - 1)
    Get #fileNumber, payloadOffset + 1, payload
    Close #fileNumber
    fileOpen = False
    bag.Contents = payload
    loaded.Host = ReadTextProperty(bag, "FtpHost")
    loaded.UserName = ReadTextProperty(bag, "FtpUserName")
    loaded.Password = ReadTextProperty(bag, "FtpPassword")
    ValidateSettings loaded
    settings = loaded
    Exit Sub
ReadFailed:
    savedNumber = Err.Number
    savedDescription = Err.Description
    On Error Resume Next
    If fileOpen Then Close #fileNumber
    On Error GoTo 0
    Err.Raise savedNumber, "ReadEmbeddedSettings", savedDescription
End Sub

Private Function ReadTextProperty(ByVal bag As PropertyBag, ByVal propertyName As String) As String
    Dim value As Variant
    value = bag.ReadProperty(propertyName, Empty)
    If VarType(value) <> vbString Then Err.Raise CONFIG_ERROR, , "The " & propertyName & " setting must be text."
    ReadTextProperty = value
End Function
