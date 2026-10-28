VERSION 5.00
Begin VB.Form frmBuilder
   BorderStyle = 1
   Caption = "Trojan Builder Configuration - Builder"
   ClientWidth = 10080
   ClientHeight = 7860
   MaxButton = 0
   MinButton = -1
   StartUpPosition = 2
   BackColor = &H00F8F6F4&
   BeginProperty Font
      Name = "Tahoma"
      Size = 9
      Charset = 0
      Weight = 400
      Underline = 0
      Italic = 0
      Strikethrough = 0
   EndProperty
   Begin VB.Label lblHeading
      Left = 360
      Top = 240
      Width = 9360
      Height = 420
      Caption = "FTP configuration builder"
      BackStyle = 0
      ForeColor = &H00B15D20&
   End
   Begin VB.Label lblIntroduction
      Left = 360
      Top = 840
      Width = 9360
      Height = 480
      Caption = "Embed example FTP settings into a copy of TrojanConfigTemplate.exe. The output reads them from its own EXE."
      BackStyle = 0
   End
   Begin VB.Frame fraSettings
      Caption = "1. FTP settings to embed"
      Left = 360
      Top = 1500
      Width = 9360
      Height = 3000
      BackColor = &H00F8F6F4&
      Begin VB.Label lblHost
         Left = 240
         Top = 360
         Width = 1800
         Height = 255
         Caption = "FTP &host"
         BackStyle = 0
      End
      Begin VB.TextBox txtHost
         Left = 240
         Top = 660
         Width = 8760
         Height = 375
         Text = ""
         MaxLength = 253
         TabIndex = 0
      End
      Begin VB.Label lblUserName
         Left = 240
         Top = 1200
         Width = 1800
         Height = 255
         Caption = "FTP &username"
         BackStyle = 0
      End
      Begin VB.TextBox txtUserName
         Left = 240
         Top = 1500
         Width = 8760
         Height = 375
         Text = ""
         MaxLength = 128
         TabIndex = 1
      End
      Begin VB.Label lblPassword
         Left = 240
         Top = 2040
         Width = 1800
         Height = 255
         Caption = "FTP &password"
         BackStyle = 0
      End
      Begin VB.TextBox txtPassword
         Left = 240
         Top = 2340
         Width = 8760
         Height = 375
         Text = ""
         MaxLength = 256
         PasswordChar = "*"
         TabIndex = 2
      End
   End
   Begin VB.Frame fraOutput
      Caption = "2. Configured executable (.exe)"
      Left = 360
      Top = 4800
      Width = 9360
      Height = 1080
      BackColor = &H00F8F6F4&
      Begin VB.TextBox txtOutput
         Left = 240
         Top = 420
         Width = 8760
         Height = 375
         Text = ""
         TabIndex = 3
      End
   End
   Begin VB.CommandButton cmdBuild
      Left = 360
      Top = 6240
      Width = 2340
      Height = 480
      Caption = "&Build EXE"
      Default = -1
      TabIndex = 4
   End
   Begin VB.CommandButton cmdVerify
      Left = 2880
      Top = 6240
      Width = 2340
      Height = 480
      Caption = "&Verify EXE"
      TabIndex = 5
   End
   Begin VB.CommandButton cmdDefaults
      Left = 5400
      Top = 6240
      Width = 1980
      Height = 480
      Caption = "Reset &example"
      TabIndex = 6
   End
   Begin VB.CommandButton cmdClose
      Left = 7560
      Top = 6240
      Width = 2160
      Height = 480
      Caption = "&Close"
      Cancel = -1
      TabIndex = 7
   End
   Begin VB.Label lblStatus
      Left = 360
      Top = 7020
      Width = 9360
      Height = 540
      Caption = "Ready. The template displays settings without making an FTP connection."
      BackStyle = 0
   End
End
Attribute VB_Name = "frmBuilder"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Dim settings As FtpSettings
    lblHeading.Font.Size = 18
    lblHeading.Font.Bold = True
    SetExampleSettings settings
    ApplySettings settings
    txtOutput.Text = DefaultOutputPath()
End Sub

Friend Sub ApplySettings(ByRef settings As FtpSettings)
    txtHost.Text = settings.Host
    txtUserName.Text = settings.UserName
    txtPassword.Text = settings.Password
End Sub

Public Function BuildCurrentExecutable() As Boolean
    Dim settings As FtpSettings
    On Error GoTo Failed
    settings.Host = txtHost.Text
    settings.UserName = txtUserName.Text
    settings.Password = txtPassword.Text
    BuildConfiguredExecutable DemoTemplatePath(), txtOutput.Text, settings
    txtOutput.Text = ExecutablePath(txtOutput.Text)
    lblStatus.ForeColor = RGB(25, 110, 55)
    lblStatus.Caption = "Built successfully. Open the output EXE to display its embedded FTP settings."
    BuildCurrentExecutable = True
    Exit Function
Failed:
    lblStatus.ForeColor = RGB(170, 35, 35)
    lblStatus.Caption = "Not built: " & Err.Description
End Function

Public Function VerifyCurrentExecutable() As Boolean
    Dim settings As FtpSettings
    On Error GoTo Failed
    ReadEmbeddedSettings txtOutput.Text, settings
    lblStatus.ForeColor = RGB(25, 110, 55)
    lblStatus.Caption = "Verified embedded settings for " & settings.UserName & " at " & settings.Host & "."
    VerifyCurrentExecutable = True
    Exit Function
Failed:
    lblStatus.ForeColor = RGB(170, 35, 35)
    lblStatus.Caption = "Not verified: " & Err.Description
End Function

Private Sub cmdBuild_Click()
    Call BuildCurrentExecutable
End Sub

Private Sub cmdVerify_Click()
    Call VerifyCurrentExecutable
End Sub

Private Sub cmdDefaults_Click()
    Dim settings As FtpSettings
    SetExampleSettings settings
    ApplySettings settings
    lblStatus.ForeColor = vbWindowText
    lblStatus.Caption = "Example settings restored. Build a new EXE to embed them."
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub
