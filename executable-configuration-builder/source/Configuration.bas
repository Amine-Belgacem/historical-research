Attribute VB_Name = "Configuration"
Option Explicit

' A data-only format for the offline example. It never edits an executable.
Public Type DisplaySettings
    Title As String
    Message As String
    Theme As String
    ShowTimestamp As Boolean
End Type

Private Const FILE_SIGNATURE As String = "VBCFG001"
Private Const HEADER_BYTES As Long = 12
Private Const MAX_PAYLOAD_BYTES As Long = 1048576
Private Const CONFIG_ERROR As Long = vbObjectError + 1800
Private Const MOVE_REPLACE_EXISTING As Long = 1
Private Const MOVE_WRITE_THROUGH As Long = 8

Private Declare Function GetFullPathName Lib "kernel32" Alias "GetFullPathNameA" (ByVal fileName As String, ByVal bufferSize As Long, ByVal buffer As String, ByVal filePart As Long) As Long
Private Declare Function GetTempFileName Lib "kernel32" Alias "GetTempFileNameA" (ByVal folder As String, ByVal prefix As String, ByVal uniqueNumber As Long, ByVal buffer As String) As Long
Private Declare Function MoveFileEx Lib "kernel32" Alias "MoveFileExA" (ByVal existingName As String, ByVal newName As String, ByVal flags As Long) As Long

Public Sub SetDefaultSettings(ByRef settings As DisplaySettings)
    settings.Title = "Hello from a configuration file"
    settings.Message = "Edit these values in the builder, save the file, then open it in the viewer."
    settings.Theme = "Light"
    settings.ShowTimestamp = True
End Sub

Public Function DefaultConfigurationPath() As String
    If Right$(App.Path, 1) = "\" Then
        DefaultConfigurationPath = App.Path & "demo.cfg"
    Else
        DefaultConfigurationPath = App.Path & "\demo.cfg"
    End If
End Function

Public Sub ValidateSettings(ByRef settings As DisplaySettings)
    If Len(Trim$(settings.Title)) = 0 Or Len(settings.Title) > 80 Then
        Err.Raise CONFIG_ERROR, "Configuration", "Enter a title between 1 and 80 characters."
    End If
    If Len(Trim$(settings.Message)) = 0 Or Len(settings.Message) > 2000 Then
        Err.Raise CONFIG_ERROR, "Configuration", "Enter a message between 1 and 2000 characters."
    End If
    If settings.Theme <> "Light" And settings.Theme <> "Dark" Then
        Err.Raise CONFIG_ERROR, "Configuration", "Choose the Light or Dark theme."
    End If
End Sub

Public Function ConfigurationPath(ByVal fileName As String) As String
    Dim buffer As String
    Dim length As Long
    fileName = Trim$(fileName)
    If InStr(fileName, vbNullChar) > 0 Or LCase$(Right$(fileName, 4)) <> ".cfg" Then
        Err.Raise CONFIG_ERROR, "Configuration", "Use a local configuration filename ending in .cfg."
    End If
    If Left$(fileName, 2) = "\\" Then
        Err.Raise CONFIG_ERROR, "Configuration", "Choose a local folder for this offline example."
    End If
    buffer = String$(260, vbNullChar)
    length = GetFullPathName(fileName, Len(buffer), buffer, 0)
    If length = 0 Or length >= Len(buffer) Then
        Err.Raise CONFIG_ERROR, "Configuration", "The configuration path is invalid or too long."
    End If
    ConfigurationPath = Left$(buffer, length)
End Function

Public Sub SaveConfiguration(ByVal fileName As String, ByRef settings As DisplaySettings)
    Dim bag As New PropertyBag
    Dim payload() As Byte
    Dim payloadLength As Long
    Dim signature As String * 8
    Dim fileNumber As Integer
    Dim fileOpen As Boolean
    Dim temporaryName As String
    Dim temporaryBuffer As String
    Dim folder As String
    Dim savedNumber As Long
    Dim savedDescription As String
    On Error GoTo SaveFailed

    ValidateSettings settings
    fileName = ConfigurationPath(fileName)
    bag.WriteProperty "Title", settings.Title
    bag.WriteProperty "Message", settings.Message
    bag.WriteProperty "Theme", settings.Theme
    bag.WriteProperty "ShowTimestamp", settings.ShowTimestamp
    payload = bag.Contents
    payloadLength = UBound(payload) - LBound(payload) + 1
    signature = FILE_SIGNATURE

    ' Finish a separate file before replacing an existing saved configuration.
    folder = Left$(fileName, InStrRev(fileName, "\"))
    temporaryBuffer = String$(260, vbNullChar)
    If GetTempFileName(folder, "vbc", 0, temporaryBuffer) = 0 Then
        Err.Raise CONFIG_ERROR, "Configuration", "Cannot create a temporary file. Check the folder and write permission."
    End If
    temporaryName = Left$(temporaryBuffer, InStr(temporaryBuffer, vbNullChar) - 1)
    fileNumber = FreeFile
    Open temporaryName For Binary Access Write Lock Read Write As #fileNumber
    fileOpen = True
    Put #fileNumber, , signature
    Put #fileNumber, , payloadLength
    Put #fileNumber, , payload
    Close #fileNumber
    fileOpen = False

    If MoveFileEx(temporaryName, fileName, MOVE_REPLACE_EXISTING Or MOVE_WRITE_THROUGH) = 0 Then
        Err.Raise CONFIG_ERROR, "Configuration", "Cannot replace the configuration file. Close any program holding it open."
    End If
    Exit Sub

SaveFailed:
    savedNumber = Err.Number
    savedDescription = Err.Description
    On Error Resume Next
    If fileOpen Then Close #fileNumber
    If Len(temporaryName) > 0 Then Kill temporaryName
    On Error GoTo 0
    Err.Raise savedNumber, "SaveConfiguration", savedDescription
End Sub

Public Sub ReadConfiguration(ByVal fileName As String, ByRef settings As DisplaySettings)
    Dim bag As New PropertyBag
    Dim loaded As DisplaySettings
    Dim payload() As Byte
    Dim payloadLength As Long
    Dim signature As String * 8
    Dim fileNumber As Integer
    Dim fileOpen As Boolean
    Dim fileSize As Long
    Dim timestampValue As Variant
    Dim savedNumber As Long
    Dim savedDescription As String
    On Error GoTo ReadFailed

    fileName = ConfigurationPath(fileName)
    ' FileLen fails for a missing file; the reader must never create one.
    fileSize = FileLen(fileName)
    If fileSize < HEADER_BYTES Then
        Err.Raise CONFIG_ERROR, "Configuration", "The configuration header is incomplete."
    End If
    fileNumber = FreeFile
    Open fileName For Binary Access Read Lock Write As #fileNumber
    fileOpen = True
    Get #fileNumber, , signature
    Get #fileNumber, , payloadLength
    If signature <> FILE_SIGNATURE Then
        Err.Raise CONFIG_ERROR, "Configuration", "This is not a version 1 configuration file."
    End If
    If payloadLength < 1 Or payloadLength > MAX_PAYLOAD_BYTES Then
        Err.Raise CONFIG_ERROR, "Configuration", "The configuration payload length is invalid."
    End If
    If LOF(fileNumber) <> HEADER_BYTES + payloadLength Then
        Err.Raise CONFIG_ERROR, "Configuration", "The configuration length does not match its header."
    End If
    ReDim payload(0 To payloadLength - 1)
    Get #fileNumber, , payload
    Close #fileNumber
    fileOpen = False

    bag.Contents = payload
    loaded.Title = ReadTextProperty(bag, "Title")
    loaded.Message = ReadTextProperty(bag, "Message")
    loaded.Theme = ReadTextProperty(bag, "Theme")
    timestampValue = bag.ReadProperty("ShowTimestamp", Empty)
    If VarType(timestampValue) <> vbBoolean Then
        Err.Raise CONFIG_ERROR, "Configuration", "The ShowTimestamp setting must be Boolean."
    End If
    loaded.ShowTimestamp = timestampValue
    ValidateSettings loaded
    settings = loaded
    Exit Sub

ReadFailed:
    savedNumber = Err.Number
    savedDescription = Err.Description
    On Error Resume Next
    If fileOpen Then Close #fileNumber
    On Error GoTo 0
    Err.Raise savedNumber, "ReadConfiguration", savedDescription
End Sub

Private Function ReadTextProperty(ByVal bag As PropertyBag, ByVal propertyName As String) As String
    Dim value As Variant
    value = bag.ReadProperty(propertyName, Empty)
    If VarType(value) <> vbString Then
        Err.Raise CONFIG_ERROR, "Configuration", "The " & propertyName & " setting must be text."
    End If
    ReadTextProperty = value
End Function
