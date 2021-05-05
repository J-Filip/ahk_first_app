#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski

; DESCRIPTION : GUI application that aims to help helpdesk agents produce quicker and better reponses.


;variables
inputbox, potpis, Ime i prezime agenta za potpis :		; inputbox for var potpis which contains signature

;vars oslovljavanje
gdine = Poštovani gospodine PREZIME,
gdjo = Poštovana gospođo PREZIME,
pozdrav = Pozdrav,

;vars sadržaj
zahvala = zahvaljujemo na informacijama. Vaš upit je proslijeđen nadležnoj službi.
sve_ostalo = Za sve ostale upite i dalje Vam stojimo na raspolaganju.
ust_kor =
(
Ustanova:
Korisnik:
)
; vars šprance
nejasni_sadrzaj = (zaprimili smo poruku nejasnog sadržaja. Molimo Vas da provjerite jeste li poruku poslali na ispravnu adresu.
U slučaju da imate upit za CARNET-ov helpdesk, molimo da nam ga pošaljete u povratnoj poruci kako bismo bili u mogućnosti pružiti odgovarajuću podršku. )
odgovor_nadlezna = zaprimili smo odgovor nadležne službe.
nedovoljno_info = zbog nedovoljno informacija nismo Vam u mogućnosti pružiti odgovarajuću podršku. 
king_popravak : zaprimili smo odgovor nadležne službe kako je poteškoća s opremom serijskog broja _____ otklonjena. U slučaju daljnjih poteškoća, molimo da nas povratno kontaktirate.
;vars kraj
lp =
(
Lijepi pozdrav,
%potpis%
)

; gui layout
Gui +AlwaysOnTop		;keeps gui on top of other windows
Gui, Font, s19 c60021, bold		;font options
Gui, Add, Text, cblack x15 y15, %potpis% 		;var potpis from inputbox
Gui, Font, s12 c60021, bold
Gui, Add, Text, x30 y80 cblack, Oslovljavanje :
Gui, Font, s11
GUI Add, Radio, x50 gCBClicked Checked vGdin, Gdin.
GUI Add, Radio, gCBClicked vGdji, Gđa
GUI Add, Radio, gCBClicked vTiket, Ticket
Gui, Font, s12 c60021, bold
Gui, Add, Text, x30 cblack, Sadržaj :
Gui, Font, s11
GUI Add, Checkbox,x50 gCBClicked vHvala, Proslijeđeno
GUI Add, Checkbox, gCBClicked vUstKor, Ustanova i korisnik
Gui, Font, s12 c60021, bold
Gui, Add, Text, x30 cblack,  Kraj :
Gui, Font, s11
GUI Add, Checkbox, x50 gCBClicked vOstalo, Za sve ostale...
GUI Add, Checkbox, gCBClicked vLpoz, Lijep pozdrav
GUI Add, Edit, ym  r22 w350 vComposedMail
GUI Add, Button, y+20 gKopira, Kopiraj

Gui, Show, x100 y400 , Mejlomat			; ; GUI heading

;labels
CBClicked:	; when user interacts with control (in this case radio and checkbox) it executes this label 	(g - goto, gosub)
	Gui, submit, NoHide 		; save input from user to each control's associated variable

	Mail := ""	; resets variable to empty
  if Gdin 		; if checked, add var gdine and two linefeeds and store back in var Mail
    Mail .= gdine "`n`n"
  if Gdji
    Mail.= gdjo "`n`n"
  if Tiket {
    Mail.= pozdrav "`n`n"
    GuiControl, Disable, Ostalo 		; disable checkbox Ostalo
    GuiControl, Disable, Hvala
    GuiControl, Enable, Lpoz
    GuiControl, Enable, UstKor
		GuiControl,,Hvala, 0					; put checkbox in unchecked state
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
	Mail .= lp

GuiControl,, ComposedMail, %Mail%			; update edit box content
return			; think of a return as a "go back to where you came from" prompt. In this case, if return is ommited, it will continue to execute next gosub - GuiClose and it will kill app

Kopira: 			; gets edit box content and stores it in variable and then in clipboard
	GuiControlGet, myedit,, ComposedMail
	clipboard = %myedit%
	return

GuiClose: 		; kill app with X button
	ExitApp
