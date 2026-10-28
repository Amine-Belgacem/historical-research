VERSION 5.00
Begin VB.Form frmViewer
   BorderStyle = 1
   Caption = "Local configuration - Viewer"
   ClientWidth = 10080
   ClientHeight = 7320
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
      Caption = "Configuration viewer"
      BackStyle = 0
      ForeColor = &H00B15D20&
   End
   Begin VB.Label lblIntroduction
      Left = 360
      Top = 840
      Width = 9360
      Height = 420
      Caption = "Load a .cfg file created by the builder. The saved settings control the preview below."
      BackStyle = 0
   End
   Begin VB.Label lblFileName
      Left = 360
      Top = 1500
      Width = 9360
      Height = 255
      Caption = "&Configuration file"
      BackStyle = 0
   End
   Begin VB.TextBox txtFileName
      Left = 360
      Top = 1800
      Width = 6840
      Height = 375
      Text = ""
      TabIndex = 0
   End
   Begin VB.CommandButton cmdLoad
      Left = 7440
      Top = 1770
      Width = 2280
      Height = 450
      Caption = "&Load configuration"
      Default = -1
      TabIndex = 1
   End
   Begin VB.Frame fraPreview
      Caption = "Saved display settings"
      Left = 360
      Top = 2520
      Width = 9360
      Height = 3540
      BackColor = &H00F8F6F4&
      Begin VB.Label lblPreviewTitle
         Left = 300
         Top = 480
         Width = 8700
         Height = 720
         Caption = "No configuration loaded"
         BackStyle = 0
      End
      Begin VB.TextBox txtPreviewMessage
         Left = 300
         Top = 1440
         Width = 8700
         Height = 1320
         Text = "Choose a file above to display its settings."
         MultiLine = -1
         ScrollBars = 2
         Locked = -1
         BorderStyle = 0
         TabIndex = 2
      End
      Begin VB.Label lblTimestamp
         Left = 300
         Top = 3000
         Width = 8700
         Height = 270
         Caption = ""
         BackStyle = 0
      End
   End
   Begin VB.Label lblStatus
      Left = 360
      Top = 6360
      Width = 6840
      Height = 660
      Caption = "Ready. Load a configuration file."
      BackStyle = 0
   End
   Begin VB.CommandButton cmdClose
      Left = 7440
      Top = 6420
      Width = 2280
      Height = 480
      Caption = "&Close"
      Cancel = -1
      TabIndex = 3
   End
End
Attribute VB_Name = "frmViewer"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
    lblHeading.Font.Size = 18
    lblHeading.Font.Bold = True
    lblPreviewTitle.Font.Size = 16
    lblPreviewTitle.Font.Bold = True
    txtPreviewMessage.Font.Size = 11
    txtFileName.Text = DefaultConfigurationPath()
End Sub

Public Function OpenConfiguration(ByVal fileName As String) As Boolean
    Dim settings As DisplaySettings
    On Error GoTo LoadFailed
    ' Loading first ensures Form_Load cannot reset the restored controls.
    Load Me
    ReadConfiguration fileName, settings
    txtFileName.Text = ConfigurationPath(fileName)
    RenderSettings settings
    lblStatus.ForeColor = RGB(25, 110, 55)
    lblStatus.Caption = "Loaded successfully. The preview uses the values saved in this file."
    OpenConfiguration = True
    Exit Function
LoadFailed:
    lblPreviewTitle.Caption = "No configuration loaded"
    txtPreviewMessage.Text = ""
    lblTimestamp.Caption = ""
    lblStatus.ForeColor = RGB(170, 35, 35)
    lblStatus.Caption = "Not loaded: " & Err.Description
End Function

Private Sub RenderSettings(ByRef settings As DisplaySettings)
    Dim background As Long
    Dim foreground As Long
    If settings.Theme = "Dark" Then
        background = RGB(35, 40, 48)
        foreground = RGB(245, 247, 250)
    Else
        background = vbWhite
        foreground = RGB(35, 40, 48)
    End If
    fraPreview.BackColor = background
    fraPreview.ForeColor = foreground
    lblPreviewTitle.ForeColor = foreground
    txtPreviewMessage.BackColor = background
    txtPreviewMessage.ForeColor = foreground
    lblTimestamp.ForeColor = foreground
    lblPreviewTitle.Caption = settings.Title
    txtPreviewMessage.Text = settings.Message
    If settings.ShowTimestamp Then
        lblTimestamp.Caption = Format$(Now, "yyyy-mm-dd hh:nn:ss")
    Else
        lblTimestamp.Caption = ""
    End If
End Sub

Private Sub cmdLoad_Click()
    Call OpenConfiguration(txtFileName.Text)
End Sub

Private Sub cmdClose_Click()
    Unload Me
End Sub
