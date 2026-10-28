VERSION 5.00
Begin VB.Form frmBuilder
   BorderStyle = 1
   Caption = "Local configuration - Builder"
   ClientWidth = 10080
   ClientHeight = 8460
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
      Caption = "Configuration builder"
      BackStyle = 0
      ForeColor = &H00B15D20&
   End
   Begin VB.Label lblIntroduction
      Left = 360
      Top = 840
      Width = 9360
      Height = 480
      Caption = "Create a local settings file, then load it in the viewer to see the values restored."
      BackStyle = 0
   End
   Begin VB.Frame fraSettings
      Caption = "1. Choose what the viewer displays"
      Left = 360
      Top = 1500
      Width = 9360
      Height = 3780
      BackColor = &H00F8F6F4&
      Begin VB.Label lblTitle
         Left = 240
         Top = 360
         Width = 8700
         Height = 255
         Caption = "&Title"
         BackStyle = 0
      End
      Begin VB.TextBox txtTitle
         Left = 240
         Top = 660
         Width = 8760
         Height = 375
         Text = ""
         MaxLength = 80
         TabIndex = 0
      End
      Begin VB.Label lblMessage
         Left = 240
         Top = 1200
         Width = 8700
         Height = 255
         Caption = "&Message"
         BackStyle = 0
      End
      Begin VB.TextBox txtMessage
         Left = 240
         Top = 1500
         Width = 8760
         Height = 1200
         Text = ""
         MultiLine = -1
         ScrollBars = 2
         MaxLength = 2000
         TabIndex = 1
      End
      Begin VB.Label lblTheme
         Left = 240
         Top = 2850
         Width = 2400
         Height = 255
         Caption = "T&heme"
         BackStyle = 0
      End
      Begin VB.ComboBox cboTheme
         Left = 240
         Top = 3180
         Width = 2640
         Height = 315
         Style = 2
         TabIndex = 2
      End
      Begin VB.CheckBox chkTimestamp
         Left = 3600
         Top = 3180
         Width = 5100
         Height = 315
         Caption = "Show the current &date and time"
         BackColor = &H00F8F6F4&
         TabIndex = 3
      End
   End
   Begin VB.Frame fraFile
      Caption = "2. Save a configuration file (.cfg)"
      Left = 360
      Top = 5520
      Width = 9360
      Height = 1080
      BackColor = &H00F8F6F4&
      Begin VB.TextBox txtFileName
         Left = 240
         Top = 420
         Width = 8760
         Height = 375
         Text = ""
         TabIndex = 4
      End
   End
   Begin VB.CommandButton cmdSave
      Left = 360
      Top = 6960
      Width = 2340
      Height = 480
      Caption = "&Save configuration"
      Default = -1
      TabIndex = 5
   End
   Begin VB.CommandButton cmdView
      Left = 2880
      Top = 6960
      Width = 2340
      Height = 480
      Caption = "&View saved file"
      TabIndex = 6
   End
   Begin VB.CommandButton cmdDefaults
      Left = 5400
      Top = 6960
      Width = 1980
      Height = 480
      Caption = "Reset &defaults"
      TabIndex = 7
   End
   Begin VB.CommandButton cmdClose
      Left = 7560
      Top = 6960
      Width = 2160
      Height = 480
      Caption = "&Close"
      Cancel = -1
      TabIndex = 8
   End
   Begin VB.Label lblStatus
      Left = 360
      Top = 7740
      Width = 9360
      Height = 420
      Caption = "Ready. Edit the settings and save a .cfg file."
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
    Dim settings As DisplaySettings
    lblHeading.Font.Size = 18
    lblHeading.Font.Bold = True
    cboTheme.AddItem "Light"
    cboTheme.AddItem "Dark"
    SetDefaultSettings settings
    ApplySettings settings
    txtFileName.Text = DefaultConfigurationPath()
End Sub

Friend Sub ApplySettings(ByRef settings As DisplaySettings)
    txtTitle.Text = settings.Title
    txtMessage.Text = settings.Message
    If settings.Theme = "Dark" Then
        cboTheme.ListIndex = 1
    Else
        cboTheme.ListIndex = 0
    End If
    If settings.ShowTimestamp Then
        chkTimestamp.Value = vbChecked
    Else
        chkTimestamp.Value = vbUnchecked
    End If
End Sub

Private Sub ReadFormSettings(ByRef settings As DisplaySettings)
    settings.Title = txtTitle.Text
    settings.Message = txtMessage.Text
    settings.Theme = cboTheme.Text
    settings.ShowTimestamp = (chkTimestamp.Value = vbChecked)
End Sub

Public Function SaveCurrentFile() As Boolean
    Dim settings As DisplaySettings
    On Error GoTo SaveFailed
    ReadFormSettings settings
    SaveConfiguration txtFileName.Text, settings
    txtFileName.Text = ConfigurationPath(txtFileName.Text)
    lblStatus.ForeColor = RGB(25, 110, 55)
    lblStatus.Caption = "Saved. Choose 'View saved file' to read the configuration back."
    SaveCurrentFile = True
    Exit Function
SaveFailed:
    lblStatus.ForeColor = RGB(170, 35, 35)
    lblStatus.Caption = "Not saved: " & Err.Description
End Function

Private Sub cmdSave_Click()
    Call SaveCurrentFile
End Sub

Private Sub cmdView_Click()
    If frmViewer.OpenConfiguration(txtFileName.Text) Then
        frmViewer.Show
    Else
        lblStatus.ForeColor = RGB(170, 35, 35)
        lblStatus.Caption = frmViewer.lblStatus.Caption
    End If
End Sub

Private Sub cmdDefaults_Click()
    Dim settings As DisplaySettings
    SetDefaultSettings settings
    ApplySettings settings
    lblStatus.ForeColor = vbWindowText
    lblStatus.Caption = "Defaults restored in the form. Save to update the file."
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub
