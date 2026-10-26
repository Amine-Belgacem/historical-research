Attribute VB_Name = "modEncryption"
'Used for encrypting the passwords to servers

Public Function EncryptMe(thetext) As String
Dim onoff As Boolean
onoff = False
alldone = ""
sofar = thetext

Do Until Len(sofar) = 0
    blah = Asc(Left(sofar, 1))
    If onoff = False Then
        blah = blah + 1
        onoff = True
    Else
        blah = blah - 1
        onoff = False
    End If
    If blah = 256 Then blah = 0
    If blah = -1 Then blah = 255
    alldone = alldone & Chr(blah)
    sofar = Right(sofar, Len(sofar) - 1)
Loop

EncryptMe = alldone
End Function

'Every first character, it grabs the ASCII value, and adds 1 to it, and every
'second character, it grabs the ASCII value, and takes away 1 from it.

'Works almost the same for the decryption, but the opposite, so every first
'character, it takes away 1, and every second it adds 1.


Public Function DecryptMe(thetext) As String
Dim onoff As Boolean
onoff = False
alldone = ""
sofar = thetext

Do Until Len(sofar) = 0
    blah = Asc(Left(sofar, 1))
    If onoff = False Then
        blah = blah - 1
        onoff = True
    Else
        blah = blah + 1
        onoff = False
    End If
    If blah = 256 Then blah = 0
    If blah = -1 Then blah = 255
    alldone = alldone & Chr(blah)
    sofar = Right(sofar, Len(sofar) - 1)
Loop

DecryptMe = alldone
End Function


