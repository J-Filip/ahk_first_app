#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski

; DESCRIPTION : GUI application that aims to help helpdesk agents produce quicker and better reponses.


;variables
;inputbox for variable potpis which contains signature
inputbox, potpis, Ime i prezime za potpis :

gdine = Poštovani gospodine PREZIME,
gdjo = Poštovana gospođo PREZIME,
pozdrav = Pozdrav,

zahvala = zahvaljujemo na informacijama. Vaš upit je proslijeđen nadležnoj službi.
sve_ostalo = Za sve ostale upite i dalje Vam stojimo na raspolaganju.
ust_kor =
(
Ustanova:
Korisnik:
)
lp =
(
Lijepi pozdrav,
%potpis%
)

; gui layout
Gui +AlwaysOnTop
Gui, Font, s19 c60021, bold
Gui, Add, Text, cblack x15 y15, Mejlomat

Gui, Font, s12 c60021, bold
Gui, Add, Text, x30 y80 cblack, Oslovljavanje :

Gui, Font, s11
;Gui, Add, Edit,x+10 w200 h30 vedit1 gtekst1 , Prezime...
;Gui, Add, Button, x20  gbtn3 , RESET
;Gui, Add, Button,x+80 y+20 w100 h50 gGen_Btn, Kopiraj
;Gui, Add, Edit, vRezEdit1 y+50 ReadOnly, %rez1%
GUI Add, Radio, x50 gCBClicked Checked vGdin, Gdin.
GUI Add, Radio, gCBClicked vGdji, Gđa
GUI Add, Radio, gCBClicked vTiket, Ticket

Gui, Font, s12 c60021, bold
Gui, Add, Text, x30 cblack, Sadržaj :

Gui, Font, s11
GUI Add, Checkbox,x50 gCBClicked vUstKor, Ustanova i korisnik
GUI Add, Checkbox, gCBClicked vHvala, Zahvala

Gui, Font, s12 c60021, bold
Gui, Add, Text, x30 cblack,  Kraj :

Gui, Font, s11
GUI Add, Checkbox, x50 gCBClicked vOstalo, Za sve ostalo
GUI Add, Checkbox, gCBClicked vLpoz, Lp

GUI Add, Edit, ym  r22 w350 vComposedMail
GUI Add, Button, y+20 gKopira, Kopiraj
;GUI Add, Picture, w100 h100 vPic1 gSlika, otp.png

GoSub CBClicked

; GUI heading
Gui, Show, x100 y400 , The Prvi Gui
return


;labels
GuiClose:
	ExitApp
	return


/*Slika:
GuiControl,,Pic1, image002.png
Loop
  {
    LM:=GetKeyState("LButton")
    if(LM=False)
      break
 }
GuiControl,,Pic1, otp.png
return
*/

CBClicked:
Gui submit, NoHide

	Mail := ""	; Resetira varijablu u ništa
  if Gdin
    Mail .= gdine "`n`n"
  if Gdji
    Mail.= gdjo "`n`n"
  if Tiket {
    Mail.= pozdrav "`n`n"
    GuiControl, Disable, Ostalo
    GuiControl, Disable, Hvala
    GuiControl, Enable, Lpoz
    GuiControl, Enable, UstKor
		GuiControl,,Hvala, 0
		GuiControl,,Ostalo, 0

  }
  else {
  	GuiControl, Enable, Ostalo
    GuiControl, Enable, Hvala
    GuiControl, Disable, Lpoz
    GuiControl, Disable, UstKor
		GuiControl,,UstKor, 0
		GuiControl,,Lpoz, 0
}
if Hvala
	Mail .= zahvala "`n`n"
if Ostalo
	Mail .= sve_ostalo "`n`n"
if UstKor
	Mail .= ust_kor "`n`n"
if Lpoz
	Mail .= lp "`n`n"

Mail := RTrim(Mail, "`n")	; Remove the linefeeds at the end.
GuiControl,, ComposedMail, %Mail%	; Update the contents of the Edit control.
return

; gets editbox content and stores it in variable and then in clipboard
Kopira:
GuiControlGet, myedit,, ComposedMail
clipboard = %myedit%
return
