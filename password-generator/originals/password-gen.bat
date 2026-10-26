@echo off
title Password Generator

color 0c
echo.
echo  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo  ³ ²²²°  ²²°   ²²°   ²²°   ²²°  ²²²° ²° ²° ³
echo  ³ ²²²²° ²²°  ²²²²° ²²²²° ²²²²° ²²²° ²° ²° ³
echo  ³ ²²²²° ²²°  ²²²²° ²²²²° ²²²²° ²²²° ²²°²° ³
echo  ³ ²° ²° ²²°  ²°    ²°    ²° ²° ²°   ²²²²° ³
echo  ³ ²²²²° ²²²° ²²°   ²²°   ²°    ²²°  ²²²²° ³
echo  ³ ²²²° ²° ²°  ²²°   ²²°  ²°²²° ²²°  ²²²²° ³
echo  ³ ²°   ²° ²°   ²²°   ²²° ²° ²° ²²°  ²²²²° ³
echo  ³ ²°   ²²²²°   ²²°   ²²° ²° ²° ²°   ²²°²° ³
echo  ³ ²°   ²° ²°  ²²²°  ²²²° ²²²²° ²²²° ²° ²° ³
echo  ³ ²°   ²° ²° ²²²°  ²²²°   ²²°  ²²²° ²° ²° ³
echo  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo  ³ Password Generator  Written by: SwYaraB ³
echo  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo   [1] Single password generating
echo   [2] Passwords world list generating
echo.

:Menu
set /p Lenght=  - Write the password length: 
if not %Lenght%=='' set Lenght=%Lenght:~0,2%
SET /a param=%Lenght%+0
if %param%==0 echo   The entered value must be a decimal.
if %param%==0 goto Menu
if %Lenght% LSS 4 echo   The Password must contain at least 4 characters.
if %Lenght% LSS 4 goto Menu


echo.
echo  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo  ³²²²²²²²²²²² Filter Settings ²²²²²²²²²²²²²³
echo  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo  ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
echo  ³ n, Generate Numbers Only(123)           ³
echo  ³ u, Generate Uper case strings Only(ABC) ³
echo  ³ l, Generate Lower case strings Only(abc)³
echo  ³ s, Generate Symbols Only(@#?)           ³
echo  ³ To Mix between filters tape Command "+" ³
echo  ³ Command . ex:U+n+S                      ³
echo  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
echo.
set Incorrect_Filter=false
:Filter_Rule
if %Incorrect_Filter%==true echo   You have entered incorrect filter settings.
set /p Filter=  - Write the filter settings: 
if not %Filter%=='' set Filter=%Filter:~0,7%

Rem **************************
Rem One Character Verification
Rem **************************
:One_character_Verification
if %Filter%==s  goto Enable_Symb_One_character
if %Filter%==n  goto Enable_Num_One_character
if %Filter%==l  goto Enable_LowSTR_One_character
if %Filter%==u  goto Enable_UpSTR_One_character
Rem **************************
goto Two_character_Verification
Rem **************************
:Enable_Symb_One_character
Set Enable_Symb=true
Set Enable_Num=false
Set Enable_LowSTR=false
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_Num_One_character
Set Enable_Symb=false
Set Enable_Num=true
Set Enable_LowSTR=false
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_LowSTR_One_character
Set Enable_Symb=false
Set Enable_Num=false
Set Enable_LowSTR=true
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_UpSTR_One_character
Set Enable_Symb=false
Set Enable_Num=false
Set Enable_LowSTR=false
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
Rem  End
Rem **************************



Rem **************************
Rem Two Character Verification
Rem **************************
:Two_character_Verification
if %Filter%==n+s goto Enable_SymbNum_Two_character
if %Filter%==s+n goto Enable_SymbNum_Two_character
if %Filter%==u+l goto Enable_UpLowSTR_Two_character
if %Filter%==l+u goto Enable_UpLowSTR_Two_character
if %Filter%==n+l goto Enable_NumLowSTR_Two_character
if %Filter%==l+n goto Enable_NumLowSTR_Two_character
if %Filter%==n+u goto Enable_NumUpSTR_Two_character
if %Filter%==u+n goto Enable_NumUpSTR_Two_character
if %Filter%==s+l goto Enable_SymbLowSTR_Two_character
if %Filter%==l+s goto Enable_SymbLowSTR_Two_character
if %Filter%==s+u goto Enable_SymbUpSTR_Two_character
if %Filter%==u+s goto Enable_SymbUpSTR_Two_character
Rem **************************
goto Three_character_Verification
Rem **************************
:Enable_SymbNum_Two_character
Set Enable_Symb=true
Set Enable_Num=true
Set Enable_LowSTR=false
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_UpLowSTR_Two_character
Set Enable_Symb=false
Set Enable_Num=false
Set Enable_LowSTR=true
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
:Enable_NumLowSTR_Two_character
Set Enable_Symb=false
Set Enable_Num=true
Set Enable_LowSTR=true
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_NumUpSTR_Two_character
Set Enable_Symb=false
Set Enable_Num=true
Set Enable_LowSTR=false
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
:Enable_SymbLowSTR_Two_character
Set Enable_Symb=true
Set Enable_Num=false
Set Enable_LowSTR=true
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_SymbUpSTR_Two_character
Set Enable_Symb=true
Set Enable_Num=false
Set Enable_LowSTR=false
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
Rem  End
Rem **************************



Rem **************************
Rem Three Character Verification
Rem **************************
:Three_character_Verification
if %Filter%==n+s+l goto Enable_SymbNumLow_Two_character
if %Filter%==n+l+s goto Enable_SymbNumLow_Two_character
if %Filter%==s+n+l goto Enable_SymbNumLow_Two_character
if %Filter%==s+l+n goto Enable_SymbNumLow_Two_character
if %Filter%==l+n+s goto Enable_SymbNumLow_Two_character
if %Filter%==l+s+n goto Enable_SymbNumLow_Two_character
Rem **************************
if %Filter%==n+s+u goto Enable_SymbNumUp_Two_character
if %Filter%==n+u+s goto Enable_SymbNumUp_Two_character
if %Filter%==s+n+u goto Enable_SymbNumUp_Two_character
if %Filter%==s+u+n goto Enable_SymbNumUp_Two_character
if %Filter%==u+s+n goto Enable_SymbNumUp_Two_character
if %Filter%==u+n+s goto Enable_SymbNumUp_Two_character
Rem **************************
if %Filter%==n+u+l goto Enable_LowNumUp_Two_character
if %Filter%==n+l+u goto Enable_LowNumUp_Two_character
if %Filter%==u+l+n goto Enable_LowNumUp_Two_character
if %Filter%==u+n+l goto Enable_LowNumUp_Two_character
if %Filter%==l+n+u goto Enable_LowNumUp_Two_character
if %Filter%==l+u+n goto Enable_LowNumUp_Two_character
Rem **************************
if %Filter%==s+l+u goto Enable_SymbLowUp_Two_character
if %Filter%==s+u+u goto Enable_SymbLowUp_Two_character
if %Filter%==l+s+u goto Enable_SymbLowUp_Two_character
if %Filter%==l+u+s goto Enable_SymbLowUp_Two_character
if %Filter%==u+s+l goto Enable_SymbLowUp_Two_character
if %Filter%==u+l+s goto Enable_SymbLowUp_Two_character
Rem **************************
goto Four_character_Verification
Rem **************************
:Enable_SymbNumLow_Two_character
Set Enable_Symb=true
Set Enable_Num=true
Set Enable_LowSTR=true
Set Enable_UpSTR=false
goto Principal_Loop
Rem **************************
:Enable_SymbNumUp_Two_character
Set Enable_Symb=true
Set Enable_Num=true
Set Enable_LowSTR=false
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
:Enable_LowNumUp_Two_character
Set Enable_Symb=false
Set Enable_Num=true
Set Enable_LowSTR=true
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
:Enable_SymbLowUp_Two_character
Set Enable_Symb=true
Set Enable_Num=false
Set Enable_LowSTR=true
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
Rem  End
Rem **************************



Rem **************************
Rem Four Character Verification
Rem **************************
:Four_character_Verification
if %Filter%==n+s+l+u goto Enable_SymbNumLowUP_Two_character
if %Filter%==n+s+u+l goto Enable_SymbNumLowUP_Two_character
if %Filter%==n+l+u+s goto Enable_SymbNumLowUP_Two_character
if %Filter%==n+l+s+u goto Enable_SymbNumLowUP_Two_character
if %Filter%==n+u+s+l goto Enable_SymbNumLowUP_Two_character
if %Filter%==n+u+l+s goto Enable_SymbNumLowUP_Two_character
Rem **************************
if %Filter%==s+l+u+n goto Enable_SymbNumLowUP_Two_character
if %Filter%==s+l+n+u goto Enable_SymbNumLowUP_Two_character
if %Filter%==s+u+n+l goto Enable_SymbNumLowUP_Two_character
if %Filter%==s+u+l+n goto Enable_SymbNumLowUP_Two_character
if %Filter%==s+n+l+u goto Enable_SymbNumLowUP_Two_character
if %Filter%==s+n+u+l goto Enable_SymbNumLowUP_Two_character
Rem **************************
if %Filter%==l+u+n+s goto Enable_SymbNumLowUP_Two_character
if %Filter%==l+u+s+n goto Enable_SymbNumLowUP_Two_character
if %Filter%==l+n+s+u goto Enable_SymbNumLowUP_Two_character
if %Filter%==l+n+u+s goto Enable_SymbNumLowUP_Two_character
if %Filter%==l+s+u+n goto Enable_SymbNumLowUP_Two_character
if %Filter%==l+s+n+u goto Enable_SymbNumLowUP_Two_character
 Rem **************************
if %Filter%==u+n+s+l goto Enable_SymbNumLowUP_Two_character
if %Filter%==u+n+l+s goto Enable_SymbNumLowUP_Two_character
if %Filter%==u+s+l+n goto Enable_SymbNumLowUP_Two_character
if %Filter%==u+s+n+l goto Enable_SymbNumLowUP_Two_character
if %Filter%==u+l+n+s goto Enable_SymbNumLowUP_Two_character
if %Filter%==u+l+s+n goto Enable_SymbNumLowUP_Two_character
Rem **************************
set Incorrect_Filter=true
goto :Filter_Rule
Rem **************************
:Enable_SymbNumLowUP_Two_character
Set Enable_Symb=true
Set Enable_Num=true
Set Enable_LowSTR=true
Set Enable_UpSTR=true
goto Principal_Loop
Rem **************************
Rem  End
Rem **************************


Set /a Gen_Timer=0
:Principal_Loop
set /p Gen_Num=  - Write how many passwords to generate: 
if not %Gen_Num%=='' set Gen_Num=%Gen_Num:~0,3%
SET /a param=%Gen_Num%+0
if %param%==0 echo   The entered value must be a decimal.
if %param%==0 goto :Principal_Loop
echo   Generating....
goto :Under_Principal_Loop


:Under_Principal_Loop

Set /a Timer=0
Set Pass_string=
Set /a Loop0_Timer=0
Set /a Loop1_Timer=0
Set /a Loop2_Timer=0
Set /a Loop3_Timer=0

:Writing_Loop
Set /a Random_number=%random%%%4
IF %Random_number%==0 Goto Loop0
IF %Random_number%==1 Goto Loop1
IF %Random_number%==2 Goto Loop2
IF %Random_number%==3 Goto Loop3

:Loop0
if %Enable_Num%==false goto Cancel_Num
Set /a Num_val=%random%%%9
Set Pass_string=%Pass_string%%Num_val%
Set /a Timer=%Timer%+1
Set /a Loop0_Timer=%Loop0_Timer%+1
if %Timer%==%Lenght% Goto Billing_Loop
if not %Timer%==%Lenght% Goto Writing_Loop
:Cancel_Num
Set /a Loop0_Timer=1
goto Writing_Loop


:Loop1
if %Enable_LowSTR%==false goto Cancel_LowSTR
Set /a Str_val=%random%%%25
if %Str_val%==0 set Str_val=a
if %Str_val%==1 set Str_val=b
if %Str_val%==2 set Str_val=c
if %Str_val%==3 set Str_val=d
if %Str_val%==4 set Str_val=e
if %Str_val%==5 set Str_val=f
if %Str_val%==6 set Str_val=g
if %Str_val%==7 set Str_val=h
if %Str_val%==8 set Str_val=i
if %Str_val%==9 set Str_val=j
if %Str_val%==10 set Str_val=k
if %Str_val%==11 set Str_val=l
if %Str_val%==12 set Str_val=m
if %Str_val%==13 set Str_val=n
if %Str_val%==14 set Str_val=o
if %Str_val%==15 set Str_val=p
if %Str_val%==16 set Str_val=q
if %Str_val%==17 set Str_val=r
if %Str_val%==18 set Str_val=s
if %Str_val%==19 set Str_val=t
if %Str_val%==20 set Str_val=u
if %Str_val%==21 set Str_val=v
if %Str_val%==22 set Str_val=w
if %Str_val%==23 set Str_val=x
if %Str_val%==24 set Str_val=y
if %Str_val%==25 set Str_val=z
Set Pass_string=%Pass_string%%Str_val%
Set /a Timer=%Timer%+1
Set /a Loop1_Timer=%Loop1_Timer%+1
if %Timer%==%Lenght% Goto Billing_Loop
if not %Timer%==%Lenght% Goto Writing_Loop
:Cancel_LowSTR
Set /a Loop1_Timer=1
goto Writing_Loop

:Loop2
if %Enable_UpSTR%==false goto Cancel_UpSTR
Set /a UPStr_val=%random%%%25
if %UPStr_val%==0 set UPStr_val=A
if %UPStr_val%==1 set UPStr_val=B
if %UPStr_val%==2 set UPStr_val=C
if %UPStr_val%==3 set UPStr_val=D
if %UPStr_val%==4 set UPStr_val=E
if %UPStr_val%==5 set UPStr_val=F
if %UPStr_val%==6 set UPStr_val=G
if %UPStr_val%==7 set UPStr_val=H
if %UPStr_val%==8 set UPStr_val=I
if %UPStr_val%==9 set UPStr_val=J
if %UPStr_val%==10 set UPStr_val=K
if %UPStr_val%==11 set UPStr_val=L
if %UPStr_val%==12 set UPStr_val=M
if %UPStr_val%==13 set UPStr_val=N
if %UPStr_val%==14 set UPStr_val=O
if %UPStr_val%==15 set UPStr_val=P
if %UPStr_val%==16 set UPStr_val=Q
if %UPStr_val%==17 set UPStr_val=R
if %UPStr_val%==18 set UPStr_val=S
if %UPStr_val%==19 set UPStr_val=T
if %UPStr_val%==20 set UPStr_val=U
if %UPStr_val%==21 set UPStr_val=V
if %UPStr_val%==22 set UPStr_val=W
if %UPStr_val%==23 set UPStr_val=X
if %UPStr_val%==24 set UPStr_val=Y
if %UPStr_val%==25 set UPStr_val=Z
Set Pass_string=%Pass_string%%UPStr_val%
Set /a Timer=%Timer%+1
Set /a Loop2_Timer=%Loop2_Timer%+1
if %Timer%==%Lenght% Goto Billing_Loop
if not %Timer%==%Lenght% Goto Writing_Loop
:Cancel_UpSTR
Set /a Loop2_Timer=1
goto Writing_Loop

:Loop3
if %Enable_Symb%==false goto Cancel_Symb
Set /a Symb_val=%random%%%9
if %Symb_val%==0 set Symb_val=@
if %Symb_val%==1 set Symb_val=$
if %Symb_val%==2 set Symb_val=£
if %Symb_val%==3 set Symb_val=¤
if %Symb_val%==4 set Symb_val=µ
if %Symb_val%==5 set Symb_val=§
if %Symb_val%==6 set Symb_val=#
if %Symb_val%==7 set Symb_val=?
if %Symb_val%==8 set Symb_val=[
Set Pass_string=%Pass_string%%Symb_val%
Set /a Timer=%Timer%+1
Set /a Loop3_Timer=%Loop3_Timer%+1
if %Timer%==%Lenght% Goto Billing_Loop
if not %Timer%==%Lenght% Goto Writing_Loop
:Cancel_Symb
Set /a Loop3_Timer=1
goto Writing_Loop

:Billing_Loop
if %Loop0_Timer%==0 Goto Under_Principal_Loop
if %Loop1_Timer%==0 Goto Under_Principal_Loop
if %Loop2_Timer%==0 Goto Under_Principal_Loop
if %Loop3_Timer%==0 Goto Under_Principal_Loop
Set /a Gen_Timer=%Gen_Timer%+1
echo %Pass_string%>>Password_Temp.txt
if %Gen_Timer%==%Gen_Num% echo   Finished.
if %Gen_Timer%==%Gen_Num% goto Opening
goto Under_Principal_Loop

:Opening
set /p Opening=  - View the password with Notepad (y,n): 
if not %Opening%=='' set Opening=%Opening:~0,1%
if %Opening%==y goto Final0
if %Opening%==n goto Final
echo   Invalid entered value.
goto Opening
:Final0
Start Password_Temp.txt
:Final
echo.

pause
