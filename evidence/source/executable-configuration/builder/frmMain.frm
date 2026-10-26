VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Compiler"
   ClientHeight    =   5175
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6870
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5175
   ScaleWidth      =   6870
   StartUpPosition =   3  'Windows Default
   Begin VB.TextBox pass 
      Height          =   285
      Left            =   1800
      TabIndex        =   4
      Top             =   1320
      Width           =   2775
   End
   Begin VB.TextBox nom 
      Height          =   285
      Left            =   1800
      TabIndex        =   3
      Top             =   960
      Width           =   2775
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
      Left            =   1800
      MultiLine       =   -1  'True
      TabIndex        =   2
      Text            =   "frmMain.frx":0000
      Top             =   600
      Width           =   2775
   End
   Begin VB.TextBox txtExeFile 
      BeginProperty Font 
         Name            =   "Verdana"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   840
      TabIndex        =   1
      Text            =   "test.exe"
      Top             =   2400
      Width           =   5295
   End
   Begin VB.CommandButton cmdCompile 
      Caption         =   "&Compile"
      Height          =   375
      Left            =   5520
      TabIndex        =   0
      Top             =   4440
      Width           =   1215
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cmdCompile_Click()

    'This is were all the action takes place

    Dim BeginPos As Long            'variable to store the start of data
    Dim PropBag As New PropertyBag  'property bag to store the data
    Dim varTemp As Variant          'for file writing
    
    'Below section loads data into the property bag.
    With PropBag
        
        .WriteProperty "Text", txtText.Text
        .WriteProperty "Text2", nom.Text
       .WriteProperty "Text3", pass.Text
      
        'You may add your own propery using the syntax
        'PropBag.WriteProperty "<property name>",<property value>
        'As you might have noticed, property value can be anything
        'string, picture, or numerical.
    End With
    
    'rdfce.ext is the template we use to create our exe.
    'RDFCE = Renamed Dummy For Creating Executable ;-)
    '(source of that file is included too)
    
    'first copy that file to the user provided file name.
    FileCopy App.Path & "\rdfce.ext", App.Path & "\" & txtExeFile.Text
    
    'now open the file in binary mode
    Open App.Path & "\" & txtExeFile.Text For Binary As #1
        BeginPos = LOF(1)   'the point were we add extra data
                
        varTemp = PropBag.Contents
                
        Seek #1, LOF(1)
        Put #1, , varTemp   'write data
        Put #1, , BeginPos  'write starting point of extra data
    
    Close #1

    MsgBox "Exe File created without a problem", vbInformation, "Compilation Done"
    Exit Sub

End Sub





Private Sub Form_Load()

End Sub
