; 2021 commito stavio u github
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski


;variables
;-------------
gdine = Poštovani gospodine
gdjo = Poštovana gospođo
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
%imeprezime%
)

; gui layout
;------------------
;------------------
Gui +AlwaysOnTop


Gui, Font, s18 c60021, bold
Gui, Add, Text, cblack x20 y20, Mejlomat
Gui, Font, s18 c60021,

Gui, Font, s11
;Gui, Add, Text, x120 y100 cF8F8F9, Oslovljavanje:

;Gui, Add, Edit,x+10 w200 h30 vedit1 gtekst1 , Prezime...
;Gui, Add, Button, x20  gbtn3 , RESET
;Gui, Add, Button,x+80 y+20 w100 h50 gGen_Btn, Kopiraj
;Gui, Add, Edit, vRezEdit1 y+50 ReadOnly, %rez1%
GUI Add, Radio, y+30 gCBClicked Checked vGdin, Gdin.
GUI Add, Radio, gCBClicked vGdji, Gdja.
GUI Add, Radio, gCBClicked vTiket, Ticket
GUI Add, Checkbox, gCBClicked vHvala, Zahvala
GUI Add, Checkbox, gCBClicked vOstalo, Za sve ostalo
GUI Add, Checkbox, gCBClicked vUstKor, Ustanova i korisnik
GUI Add, Checkbox, gCBClicked vLpoz, Lijepi pozdrav


GUI Add, Edit, ym  r20 w300 vComposedMail
GUI Add, Button, y+10 gKopira, Kopiraj
;GUI Add, Picture, w100 h100 vPic1 gSlika, otp.png

GoSub CBClicked

Gui, Color,
Gui, Show, x30 y400 , The Prvi Gui
return


;labels
;------------------
;------------------
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
    GuiControl, Enable, Lp
    GuiControl, Enable, UstKor
  }
  else {
  	GuiControl, Enable, Ostalo
    GuiControl, Enable, Hvala
    GuiControl, Disable, Lp
    GuiControl, Disable, UstKor
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

Kopira:
clipboard = %Mail%
return
