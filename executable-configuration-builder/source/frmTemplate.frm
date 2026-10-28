VERSION 5.00
Begin VB.Form frmTemplate
   Tag = "FTPDEMO-TEMPLATE-07A2"
   BorderStyle = 1
   Caption = "Embedded FTP settings - Template"
   ClientWidth = 10080
   ClientHeight = 6180
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
      Caption = "Embedded FTP configuration"
      BackStyle = 0
      ForeColor = &H00B15D20&
   End
   Begin VB.Label lblIntroduction
      Left = 360
      Top = 840
      Width = 9360
      Height = 480
      Caption = "These values are read from this executable itself. This demonstration does not connect or upload."
      BackStyle = 0
   End
   Begin VB.Frame fraSettings
      Caption = "Settings restored from the EXE"
      Left = 360
      Top = 1500
      Width = 9360
      Height = 3300
      BackColor = &H00F8F6F4&
      Begin VB.Label lblHost
         Left = 240
         Top = 360
         Width = 1800
         Height = 255
         Caption = "FTP host"
         BackStyle = 0
      End
      Begin VB.TextBox txtHost
         Left = 240
         Top = 660
         Width = 8760
         Height = 375
         Text = ""
         Locked = -1
         TabIndex = 0
      End
      Begin VB.Label lblUserName
         Left = 240
         Top = 1200
         Width = 1800
         Height = 255
         Caption = "FTP username"
         BackStyle = 0
      End
      Begin VB.TextBox txtUserName
         Left = 240
         Top = 1500
         Width = 8760
         Height = 375
         Text = ""
         Locked = -1
         TabIndex = 1
      End
      Begin VB.Label lblPassword
         Left = 240
         Top = 2040
         Width = 1800
         Height = 255
         Caption = "FTP password"
         BackStyle = 0
      End
      Begin VB.TextBox txtPassword
         Left = 240
         Top = 2340
         Width = 8760
         Height = 375
         Text = ""
         Locked = -1
         PasswordChar = "*"
         TabIndex = 2
      End
      Begin VB.CheckBox chkShowPassword
         Left = 240
         Top = 2850
         Width = 6000
         Height = 315
         Caption = "Show example &password"
         BackColor = &H00F8F6F4&
         TabIndex = 3
      End
   End
   Begin VB.Label lblStatus
      Left = 360
      Top = 5160
      Width = 6840
      Height = 720
      Caption = "Reading settings from this executable..."
      BackStyle = 0
   End
   Begin VB.CommandButton cmdClose
      Left = 7440
      Top = 5280
      Width = 2280
      Height = 480
      Caption = "&Close"
      Cancel = -1
      TabIndex = 4
   End
End
Attribute VB_Name = "frmTemplate"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    Me.Tag = "FTPDEMO-TEMPLATE-07A2"
    lblHeading.Font.Size = 18
    lblHeading.Font.Bold = True
    Call OpenEmbeddedConfiguration(OwnExecutablePath())
End Sub

Public Function OpenEmbeddedConfiguration(ByVal fileName As String) As Boolean
    Dim settings As FtpSettings
    On Error GoTo Failed
    ReadEmbeddedSettings fileName, settings
    txtHost.Text = settings.Host
    txtUserName.Text = settings.UserName
    txtPassword.Text = settings.Password
    chkShowPassword.Value = vbUnchecked
    txtPassword.PasswordChar = "*"
    lblStatus.ForeColor = RGB(25, 110, 55)
    lblStatus.Caption = "Loaded the FTP settings embedded inside the executable. No external configuration file was used."
    OpenEmbeddedConfiguration = True
    Exit Function
Failed:
    txtHost.Text = ""
    txtUserName.Text = ""
    txtPassword.Text = ""
    lblStatus.ForeColor = RGB(170, 35, 35)
    lblStatus.Caption = Err.Description
End Function

Private Sub chkShowPassword_Click()
    If chkShowPassword.Value = vbChecked Then
        txtPassword.PasswordChar = ""
    Else
        txtPassword.PasswordChar = "*"
    End If
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub
