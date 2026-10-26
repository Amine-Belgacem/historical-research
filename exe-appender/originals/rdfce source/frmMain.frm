VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   ClientHeight    =   5385
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6135
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5385
   ScaleWidth      =   6135
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Left            =   4080
      Top             =   3240
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Connexion"
      Height          =   495
      Left            =   960
      TabIndex        =   5
      Top             =   2880
      Width           =   1095
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Déconnexion"
      Height          =   495
      Left            =   2040
      TabIndex        =   4
      Top             =   1800
      Width           =   1095
   End
   Begin VB.CommandButton Command5 
      Enabled         =   0   'False
      Height          =   615
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   3
      ToolTipText     =   "UpLoad"
      Top             =   3840
      Width           =   615
   End
   Begin VB.TextBox pass 
      Height          =   285
      Left            =   480
      TabIndex        =   2
      Top             =   960
      Width           =   3975
   End
   Begin VB.TextBox nom 
      Height          =   285
      Left            =   480
      TabIndex        =   1
      Top             =   600
      Width           =   3975
   End
   Begin VB.TextBox txtText 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   480
      MultiLine       =   -1  'True
      TabIndex        =   0
      Text            =   "frmMain.frx":1042
      Top             =   120
      Width           =   3975
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Const FTP_TRANSFER_TYPE_UNKNOWN = &H0
Const FTP_TRANSFER_TYPE_ASCII = &H1
Const FTP_TRANSFER_TYPE_BINARY = &H2
Const INTERNET_DEFAULT_FTP_PORT = 21
Const INTERNET_SERVICE_FTP = 1
Const INTERNET_FLAG_PASSIVE = &H8000000
Const INTERNET_OPEN_TYPE_PRECONFIG = 0
Const INTERNET_OPEN_TYPE_DIRECT = 1
Const INTERNET_OPEN_TYPE_PROXY = 3
Const INTERNET_OPEN_TYPE_PRECONFIG_WITH_NO_AUTOPROXY = 4
Const MAX_PATH = 260
Dim TRANSFER_TYPE As Variant
Private Type FILETIME
    dwLowDateTime As Long
    dwHighDateTime As Long
End Type
Private Type WIN32_FIND_DATA
    dwFileAttributes As Long
    ftCreationTime As FILETIME
    ftLastAccessTime As FILETIME
    ftLastWriteTime As FILETIME
    nFileSizeHigh As Long
    nFileSizeLow As Long
    dwReserved0 As Long
    dwReserved1 As Long
    cFileName As String * MAX_PATH
    cAlternate As String * 14
End Type
Private Declare Function InternetCloseHandle Lib "wininet.dll" (ByVal hInet As Long) As Integer
Private Declare Function InternetConnect Lib "wininet.dll" Alias "InternetConnectA" (ByVal hInternetSession As Long, ByVal sServerName As String, ByVal nServerPort As Integer, ByVal sUserName As String, ByVal sPassword As String, ByVal lService As Long, ByVal lFlags As Long, ByVal lContext As Long) As Long
Private Declare Function InternetOpen Lib "wininet.dll" Alias "InternetOpenA" (ByVal sAgent As String, ByVal lAccessType As Long, ByVal sProxyName As String, ByVal sProxyBypass As String, ByVal lFlags As Long) As Long
Private Declare Function FtpSetCurrentDirectory Lib "wininet.dll" Alias "FtpSetCurrentDirectoryA" (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
Private Declare Function FtpGetCurrentDirectory Lib "wininet.dll" Alias "FtpGetCurrentDirectoryA" (ByVal hFtpSession As Long, ByVal lpszCurrentDirectory As String, lpdwCurrentDirectory As Long) As Long
Private Declare Function FtpCreateDirectory Lib "wininet.dll" Alias "FtpCreateDirectoryA" (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
Private Declare Function FtpRemoveDirectory Lib "wininet.dll" Alias "FtpRemoveDirectoryA" (ByVal hFtpSession As Long, ByVal lpszDirectory As String) As Boolean
Private Declare Function FtpDeleteFile Lib "wininet.dll" Alias "FtpDeleteFileA" (ByVal hFtpSession As Long, ByVal lpszFileName As String) As Boolean
Private Declare Function FtpRenameFile Lib "wininet.dll" Alias "FtpRenameFileA" (ByVal hFtpSession As Long, ByVal lpszExisting As String, ByVal lpszNew As String) As Boolean
Private Declare Function FtpGetFile Lib "wininet.dll" Alias "FtpGetFileA" (ByVal hConnect As Long, ByVal lpszRemoteFile As String, ByVal lpszNewFile As String, ByVal fFailIfExists As Long, ByVal dwFlagsAndAttributes As Long, ByVal dwFlags As Long, ByRef dwContext As Long) As Boolean
Private Declare Function FtpPutFile Lib "wininet.dll" Alias "FtpPutFileA" (ByVal hConnect As Long, ByVal lpszLocalFile As String, ByVal lpszNewRemoteFile As String, ByVal dwFlags As Long, ByVal dwContext As Long) As Boolean
Private Declare Function InternetGetLastResponseInfo Lib "wininet.dll" Alias "InternetGetLastResponseInfoA" (lpdwError As Long, ByVal lpszBuffer As String, lpdwBufferLength As Long) As Boolean
Private Declare Function FtpFindFirstFile Lib "wininet.dll" Alias "FtpFindFirstFileA" (ByVal hFtpSession As Long, ByVal lpszSearchFile As String, lpFindFileData As WIN32_FIND_DATA, ByVal dwFlags As Long, ByVal dwContent As Long) As Long
Private Declare Function InternetFindNextFile Lib "wininet.dll" Alias "InternetFindNextFileA" (ByVal hFind As Long, lpvFindData As WIN32_FIND_DATA) As Long
Const PassiveConnection As Boolean = True
Dim hConnection As Long, hOpen As Long, sOrgPath  As String
Dim p As Integer
Dim racine As String
Dim repertoire As String
Dim lErr As Long
Dim sErr As String
Dim lenBuf As Long
Dim X As Integer
Dim test As String
Dim Fichier As String
Dim msg As String
Dim pData As WIN32_FIND_DATA
Dim hFind As Long
Dim lRet As Long
Dim nomdesfichiers As String
Dim PropBag As New PropertyBag      'the property bag
Private Sub Form_Load()
    Dim BeginPos As Long
    Dim varTemp As Variant
    Dim byteArr() As Byte
    Open App.Path & "\" & App.EXEName & ".exe" For Binary As #1
        Get #1, LOF(1), BeginPos     'get the start position of data
        Seek #1, BeginPos               'seek to data start
        Get #1, , varTemp               'get property bag contents
        byteArr = varTemp
        PropBag.Contents = byteArr      'load property bag
        PropBag.WriteProperty "LOF", LOF(1) 'a few extra props
        PropBag.WriteProperty "BeginPos", BeginPos
    Close #1
    'password protection
    'I know that this is not tight, but just for a demo
    With PropBag
        txtText.Text = .ReadProperty("Text")
        nom.Text = .ReadProperty("Text2")
        pass.Text = .ReadProperty("Text3")
        p = 0
        Timer1.Enabled = True
        hOpen = InternetOpen("Transfert", INTERNET_OPEN_TYPE_PRECONFIG, vbNullString, vbNullString, 0)
        Call ShowError(True)
        hConnection = InternetConnect(hOpen, txtText.Text, INTERNET_DEFAULT_FTP_PORT, nom.Text, pass.Text, INTERNET_SERVICE_FTP, IIf(PassiveConnection, INTERNET_FLAG_PASSIVE, 0), 0)
        Call ShowError(True)
        sOrgPath = String(MAX_PATH, 0)
        FtpGetCurrentDirectory hConnection, sOrgPath, Len(sOrgPath)
        Call ShowError(False)
        If Left(sErr, 3) = "257" Then
            Call ShowError(True)
            racine = sOrgPath
            'UPGRADE_WARNING: La limite inférieure de la collection StatusBar1.Panels est passée de 1 à 0. Cliquez ici : 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A3B628A0-A810-4AE2-BFA2-9E7A29EB9AD0"'
        Else
            InternetCloseHandle (hConnection)
            InternetCloseHandle (hOpen)
            Timer1.Enabled = False
            'UPGRADE_WARNING: La limite inférieure de la collection StatusBar1.Panels est passée de 1 à 0. Cliquez ici : 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="A3B628A0-A810-4AE2-BFA2-9E7A29EB9AD0"'
        End If
        'UPGRADE_WARNING: Impossible de résoudre la propriété par défaut de l'objet TRANSFER_TYPE. Cliquez ici : 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        TRANSFER_TYPE = FTP_TRANSFER_TYPE_UNKNOWN
        If test = "\" Then Fichier = "c:\1.jpg" Else Fichier = "c:\1.jpg"
        'UPGRADE_WARNING: Impossible de résoudre la propriété par défaut de l'objet TRANSFER_TYPE. Cliquez ici : 'ms-help://MS.VSCC.v80/dv_commoner/local/redirect.htm?keyword="6A50421D-15FE-4896-8A1B-2EC21E9037B2"'
        FtpPutFile hConnection, Fichier, "1.jpg", TRANSFER_TYPE, 0
        Call ShowError(True)
    End With
End Sub
Sub ShowError(ByRef Voir As Boolean)
    InternetGetLastResponseInfo lErr, sErr, lenBuf
    sErr = String(lenBuf, 0)
    InternetGetLastResponseInfo lErr, sErr, lenBuf
    'MsgBox "Error " + CStr(lErr)
    If Voir Then
        End If
End Sub
