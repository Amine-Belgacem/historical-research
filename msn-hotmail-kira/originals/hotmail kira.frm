VERSION 5.00
Object = "{6B7E6392-850A-101B-AFC0-4210102A8DA7}#1.3#0"; "COMCTL32.OCX"
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "MSWINSCK.OCX"
Begin VB.Form frmmain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Hotmail Kira"
   ClientHeight    =   4890
   ClientLeft      =   45
   ClientTop       =   315
   ClientWidth     =   5775
   Icon            =   "hotmail kira.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Picture         =   "hotmail kira.frx":08CA
   ScaleHeight     =   4890
   ScaleMode       =   0  'User
   ScaleWidth      =   5775
   StartUpPosition =   1  'CenterOwner
   Begin VB.CommandButton About 
      Caption         =   "About"
      Height          =   375
      Left            =   4920
      TabIndex        =   7
      Top             =   3480
      Width           =   735
   End
   Begin VB.TextBox Email 
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   405
      Left            =   120
      TabIndex        =   6
      Text            =   "un_email_@hotmail.com"
      Top             =   3480
      Width           =   3015
   End
   Begin VB.TextBox Password 
      Height          =   405
      Left            =   240
      TabIndex        =   4
      Text            =   "me123789v"
      Top             =   5280
      Visible         =   0   'False
      Width           =   3135
   End
   Begin VB.Timer ProgressTimer 
      Interval        =   100
      Left            =   0
      Top             =   2160
   End
   Begin VB.TextBox txtSigninName 
      Height          =   285
      Left            =   3480
      TabIndex        =   3
      Top             =   5040
      Visible         =   0   'False
      Width           =   2295
   End
   Begin VB.TextBox txtPassword 
      Height          =   285
      IMEMode         =   3  'DISABLE
      Left            =   3480
      TabIndex        =   2
      Top             =   5400
      Visible         =   0   'False
      Width           =   2295
   End
   Begin VB.CommandButton Defreez 
      Caption         =   "Defreeze"
      Height          =   375
      Left            =   4080
      TabIndex        =   1
      Top             =   3480
      Width           =   855
   End
   Begin VB.CommandButton Freez 
      Caption         =   "Freeze"
      Height          =   375
      Left            =   3240
      TabIndex        =   0
      Top             =   3480
      Width           =   855
   End
   Begin MSWinsockLib.Winsock sckMain 
      Left            =   5280
      Top             =   2880
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin ComctlLib.ProgressBar ProgressBar1 
      Height          =   375
      Left            =   120
      TabIndex        =   5
      Top             =   4080
      Width           =   5535
      _ExtentX        =   9763
      _ExtentY        =   661
      _Version        =   327682
      Appearance      =   1
   End
   Begin VB.Label Label1 
      BackStyle       =   0  'Transparent
      Caption         =   "Bienvenue dans Hotmail Kira : (by sn1per-wolf - made in TUNISIA - 2006)"
      Height          =   255
      Left            =   120
      TabIndex        =   8
      Top             =   4560
      Width           =   5655
   End
End
Attribute VB_Name = "frmmain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private WithEvents oWinHTTP As WinHttp.WinHttpRequest
Attribute oWinHTTP.VB_VarHelpID = -1
Private bGotAuthRedir As Boolean
Private sChallenge As String
Private sAuthLocation As String
Private dTransID As Double
Private lLsts As Long
Public lLstCount As Long
Public ClientIDNo As String
Private Function TransactionID() As Double
    If dTransID = 2 ^ 32 - 1 Then
        dTransID = 1
    End If
    TransactionID = dTransID
    dTransID = dTransID + 1
End Function
Public Function SignInMSN()
   Set oWinHTTP = New WinHttp.WinHttpRequest
   sckMain.Close
   sckMain.Connect "messenger.hotmail.com", 1863
End Function
Private Sub Freez_Click()
    Label1.Caption = "L'email sera freezer dans environ 2 minute... il faut garder la fenetre ouverte"
    ProgressTimer.Enabled = True
End Sub
Private Sub About_Click()
    frmabout.Show
End Sub
Private Sub Defreez_Click()
    End
End Sub
Private Sub Form_Load()
    ProgressTimer.Enabled = False
End Sub

Private Sub sckMain_Connect()
    Call SendData("VER *%* MSNP9" & vbCrLf)
End Sub
Public Sub SendData(Data As String)
    Data = Replace(Data, "*%*", TransactionID)
    Call sckMain.SendData(Data)
    If Mid(Data, Len(Data) - 1) = vbCrLf Then
        Debug.Print ("<<<: " & Mid(Data, 1, Len(Data) - 2))
    Else
        Debug.Print ("<<<: " & Data)
    End If
End Sub
Private Sub sckMain_DataArrival(ByVal bytesTotal As Long)
    Dim sCommand As String, sData As String, sbuffer As String, sParams() As String
    Dim i As Long
    Do
        Call sckMain.PeekData(sbuffer, vbString, bytesTotal)
        If InStr(1, sbuffer, vbCrLf) = 0 Then
            Exit Sub
        End If
        If InStr(1, sbuffer, " ") Then
            sCommand = Mid$(sbuffer, 1, InStr(1, sbuffer, " ") - 1)
        Else
            sCommand = Mid$(sbuffer, 1, InStr(1, sbuffer, vbCrLf) - 1)
        End If
        If sCommand = "MSG" Or sCommand = "NOT" Then
            i = InStr(1, sbuffer, vbCrLf)
            sParams() = Split(Mid$(sbuffer, 1, i - 1), " ")
            If CLng(Len(Mid$(sbuffer, i + 2))) < CLng(sParams(3)) Then
                Exit Do
            End If
            sData = Mid(GetData(vbNullString, False, i + sParams(3) + 1), i + 2)
        Else
            sData = GetData(sbuffer)
            sParams() = Split(sData, " ")
            sData = vbNullString
        End If
            Call ProcessData(sParams, sData)
    Loop While sckMain.BytesReceived <> 0
End Sub
Private Sub ProcessData(sParams() As String, sPayload As String)
    Dim sSubParams() As String
    Select Case sParams(0)
        Case "VER"
            Call SendData("CVR 2 0x0409 winnt 5.1 i386 MSNMSGR 6.0.0254 MSMSGS " & txtSigninName.Text & vbCrLf)
        Case "CVR"
            Call SendData("USR 3 TWN I " & txtSigninName.Text & vbCrLf)
        Case "XFR"
            If sParams(2) = "NS" Then
                sSubParams() = Split(sParams(3), ":")
                Call sckMain.Close
                Call sckMain.Connect(sSubParams(0), sSubParams(1))
            Else
                sSubParams() = Split(sParams(3), ":")
                For Each frm In Forms
                    If InStr(1, frm.Caption, "<" & BuddyConnect & ">") Then
                        With frm
                            .sckMSG.Tag = "USR *%* " & txtSigninName.Text & " " & sParams(5)
                            .sckMSG.Close
                            .sckMSG.Connect sSubParams(0), sSubParams(1)
                            .WindowState = vbNormal
                            .Caption = BuddyConName & " - <" & BuddyConnect & ">"
                            .Visible = True
                            .BudEmail = BuddyConnect
                            .BudName = BuddyConName
                            Exit Sub
                        End With
                    End If
                Next frm
                Load sChat
                With sChat
                    .sckMSG.Tag = "USR *%* " & txtSigninName.Text & " " & sParams(5)
                    .sckMSG.Close
                    .sckMSG.Connect sSubParams(0), sSubParams(1)
                    .WindowState = vbNormal
                    .Caption = BuddyConName & " - <" & BuddyConnect & ">"
                    .Visible = True
                    .BudEmail = BuddyConnect
                    .BudName = BuddyConName
                    .lstParticipants.AddItem BuddyConnect
                End With
            End If
        Case "USR"
            If sParams(2) = "OK" Then
                Call SendData("SYN *%* 0" & vbCrLf)
            ElseIf sParams(2) = "TWN" Then
                sChallenge = sParams(4)
                oWinHTTP.Option(WinHttpRequestOption_EnableRedirects) = False
                If Not bGotAuthRedir Then
                    Call oWinHTTP.Open("GET", "https://nexus.passport.com/rdr/pprdr.asp", True)
                    Call oWinHTTP.Send
                Else
                    Call oWinHTTP.Open("GET", sAuthLocation, True)
                    Call oWinHTTP.SetRequestHeader("Authorization", "Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in=" & Replace(txtSigninName.Text, "@", "%40") & ",pwd=" & txtPassword.Text & "," & sParams(4))
                    Call oWinHTTP.Send
                End If
            End If
        Case "SYN"
        Case "CHL"
            Call SendData("QRY *%* PROD0038W!61ZTF9 32" & vbCrLf _
            & MD5(sParams(2) & "VT6PX?UQTM4WM%YR"))
        Case "LSG"
        Case "LST"
            thegroup = "lst_0"
            If UBound(sParams) = 4 Then
                thelistor = Split(sParams(4), ",")
                thegroup = "list_" & thelistor(0)
            End If
        Case "ILN"
        Case "NLN"
        Case "FLN"
        Case "REA"
        Case "CHG"
        Case "RNG"
            sNewS = Split(sParams(2), ":")
        Case "OUT"
            If sParams(1) = "OTH" Then MsgBox "You have been signed out because you signed in from another location."
    End Select
End Sub
Private Function GetData(sbuffer As String, Optional bTrim As Boolean = True, Optional lLength As Long = 0) As String
    Dim sData As String
    Dim i As Long
    If lLength = 0 Then
        i = InStr(1, sbuffer, vbCrLf, vbTextCompare)
        Call sckMain.GetData(sData, vbString, i + 1)
    Else
        Call sckMain.GetData(sData, vbString, lLength)
    End If
    If bTrim = True Then
        GetData = Mid(sData, 1, Len(sData) - 2)
    Else
        GetData = sData
    End If
    Debug.Print ">>>: " & GetData
End Function

Private Sub sckMain_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    MsgBox Description
End Sub
Private Sub oWinHTTP_OnResponseFinished()
    Dim i As Integer
    If Not bGotAuthRedir Then
        i = InStr(1, oWinHTTP.GetResponseHeader("PassportURLs"), "DALogin")
        sAuthLocation = "https://" & Mid$(oWinHTTP.GetResponseHeader("PassportURLs"), i + 8, InStr(i + 1, oWinHTTP.GetResponseHeader("PassportURLs"), ",") - i - 8)
        bGotAuthRedir = True
        Call oWinHTTP.Open("GET", sAuthLocation, True)
        Call oWinHTTP.SetRequestHeader("Authorization", "Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in=" & Replace(txtSigninName.Text, "@", "%40") & ",pwd=" & txtPassword.Text & "," & sChallenge)
        Call oWinHTTP.Send
    Else
        If IsHeader("Authentication-Info") Then
            If InStr(1, oWinHTTP.GetResponseHeader("Authentication-Info"), "Passport1.4 da-status=redir") Then
                Call oWinHTTP.Open("GET", oWinHTTP.GetResponseHeader("Location"), True)
                Call oWinHTTP.SetRequestHeader("Authorization", "Passport1.4 OrgVerb=GET,OrgURL=http%3A%2F%2Fmessenger%2Emsn%2Ecom,sign-in=" & Replace(txtSigninName.Text, "@", "%40") & ",pwd=" & txtPassword.Text & "," & sChallenge)
                Call oWinHTTP.Send
            ElseIf InStr(1, oWinHTTP.GetResponseHeader("Authentication-Info"), "Passport1.4 da-status=success") Then
                i = InStr(1, oWinHTTP.GetResponseHeader("Authentication-Info"), "'")
                Call SendData("USR 4 TWN S " & Mid$(oWinHTTP.GetResponseHeader("Authentication-Info"), i + 1, InStrRev(oWinHTTP.GetResponseHeader("Authentication-Info"), "'") - i - 1) & vbCrLf)
            End If
        ElseIf IsHeader("WWW-Authenticate") Then
            If InStr(1, oWinHTTP.GetResponseHeader("WWW-Authenticate"), "Passport1.4 da-status=failed") Then
            End If
        End If
    End If
End Sub
Private Function IsHeader(sHeaderName As String) As Boolean
On Error Resume Next
Dim sValue As String
    sValue = oWinHTTP.GetResponseHeader(sHeaderName)
    If Err.Number = 0 Then
        IsHeader = True
    End If
End Function
Private Sub ProgressTimer_Timer()
    ProgressBar1.Visible = True
    ProgressBar1.Object = ProgressBar1.Object + 2
    If ProgressBar1.Object = 100 Then
        ProgressBar1.Object = 0
        frmmain.txtSigninName.Text = Email.Text
        frmmain.txtPassword.Text = Password.Text
    If Not frmmain.txtPassword.Text = "" Then LoggedIn = True: frmmain.Show: frmmain.SignInMSN
    End If
End Sub

