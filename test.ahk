#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; variables
;inputbox, potpis, Ime i prezime agenta za potpis :		; inputbox for var potpis which contains signature
#Include %A_ScriptDir%\Chrome1.ahk

gdineMsg = Poštovani gospodine PREZIME,
gdjoMsg = Poštovana gospođo PREZIME,
pozdravMsg = Pozdrav,

zahvalaMsg = zahvaljujemo na ...
proslijeđenMsg = Vaš upit je proslijeđen ...
nejasniMsg = nejasni upit ...

ustKorMsg = ustanova: `nkorisnik:

zaSveOstaloMsg = Za sve ostale upite...,`n%potpis%
lpMsg = Lijep pozdrav,`n%potpis%

;InputBox, datum, UNESI, Unesi datum:
;raspored := %datum%

Gui, Font, S8 CDefault, Verdana
Gui, Add, Edit, x292 y89 w300 h250 vComposedMail,
Gui, Add, Radio, x32 y89 w100 h30 checked gRadClicked vgdja, Gdja.
Gui, Add, Radio, x32 y119 w100 h30 gRadClicked vgdin, Gdin.
Gui, Add, Radio, x152 y89 w70 h30 gRadClicked vtiket, TIKET
Gui, Add, Text, x2 y199 w110 h20 , Sadržaj
Gui, Add, Checkbox, x32 y229 w100 h30 gRadClicked vzahvala, Zahvala
Gui, Add, Checkbox, x142 y229 w100 h30 gRadClicked vustKor, Ustanova i korisnik
Gui, Add, Checkbox, x32 y259 w100 h30 gRadClicked vproslijeđen, Proslijedjen
Gui, Add, Checkbox, x32 y289 w100 h30 gRadClicked vnejasni, Nejasni
Gui, Add, Text, x2 y339 w110 h30 gRadClicked checked 0 vpozdravna, Pozdravna poruka:
Gui, Add, Radio, x22 y389 w100 h30 gRadClicked vzaSveOstale, Za sve ostale
Gui, Add, Radio, x142 y389 w100 h30 gRadClicked vLp, Lp
Gui, Add, Button, x382 y349 w100 h40 gkopira, Kopiraj
Gui, Add, Button, w100 h40 gsemaforButt  vsemafor, Semafor
Gui, Add, Checkbox,  w110 h20 gpratiPozive vprati , Prati pozive
Gui, Add, Button, x612 y89 w100 h40 ghasekButt vhasek, Hasek
Gui, Add, Button, x612 y139 w100 h40 grasporedButt, Raspored
Gui, Add, Button, x722 y159 w40 h20 ghideContr, Hide
Gui, Add, Text, x2 y69 w110 h20 , Oslovljavanje :


; Generated using SmartGUI Creator 4.0
Gui, Show, x379 y368 h673 w811, New GUI Window
return

; labels
pratiPozive:
{
  Gui, submit, NoHide
  if (prati = 1){
    getpozivi()
    ;msgBox, %eskole_broj_poziva%
    run, crmpozivi.ahk
    ;sleep, 3000
    ;Gui, Add, Text , x622 y189 w120 h350 ,"eskole:" %eskole_broj_poziva%
  }
  if (prati = 0){
    DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
    SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
    WinClose crmpozivi.ahk - AutoHotkey
  }
  return
}



semaforButt:
{
  runwait, crm_PPdashleti_PPizvjestaj.ahk
  izvj := clipboard
  GuiControlGet, semaforText
  if (semaforText = "")
  {
  Gui, Font, S7 CDefault, Verdana
  Gui, Add, Text , x500 y420 w120 h250 vsemaforText, %izvj%
  }Else
  {
    GuiControl,, semaforText, %izvj%
  }
  sleep 1000
  return
}
rasporedButt:
{
  runwait, intaps_jutro.ahk
  rasp := clipboard
  GuiControlGet, raspored
  if (raspored = "")
  {
    Gui, Add, Text, x622 y189 w120 h450 vraspored, %rasp%
  }Else
  {
    GuiControl,, raspored, %clipboard%
  }
  sleep 1000
  return
}


gdaDisable()
{
  GuiControl, Enable, zahvala
  GuiControl, Enable, proslijeđen
  GuiControl, Enable, nejasni
  GuiControl, Enable, zaSveOstale
  GuiControl,, zaSveOstale, 1
  GuiControl,, ustKor, 0
  GuiControl,, lp, 0
  GuiControl, Disable, ustKor
  GuiControl, Disable, lp
}
tiketDisable()
{
  GuiControl,, zahvala, 0
  GuiControl,, proslijeđen, 0
  GuiControl,, nejasni, 0
  GuiControl,, zaSveOstale, 0
  GuiControl,, lp, 1
  GuiControl, Disable, zahvala
  GuiControl, Disable, proslijeđen
  GuiControl, Disable, nejasni
  GuiControl, Disable, zaSveOstale
  GuiControl, Enable, ustKor
  GuiControl, Enable, lp
}

hasekButt:
{
  GuiControlGet, editBox,, ComposedMail
  clipboard = %editBox%
  hasekRunning()
  sleep 2000
  PageInst:= Chrome.GetPageByURL("https://ispravi.me/")
  PageInst.Evaluate("document.querySelector('#textarea').innerText="Chrome.Jxon_Dump(clipboard) )
  return
}
hideContr:
{
  GuiControlGet, raspored
  if (raspored<>"")
    {
      GuiControl,, raspored, -
    }
  if (raspored="-")
    {
      GuiControl,, raspored, %izvj%
    }
}
RadClicked:
Gui, submit, NoHide
mail := ""
; Oslovljavanje
if gdja {
  gdaDisable()
  mail:= gdjoMsg "`n`n"

}
if gdin {
  gdaDisable()
  mail:= gdineMsg "`n`n"
}
if tiket {
  tiketDisable()
  GuiControl,, MyRadio2, 1
  mail:= pozdravMsg "`n`n"
}
; sadrzaj
if zahvala
  {
    mail.= zahvalaMsg "`n`n"
  }
if proslijeđen
  {
    mail.= proslijeđenMsg "`n`n"
  }
if nejasni{
  mail.= nejasniMsg "`n`n"
}
if ustKor{
  mail.= ustKorMsg "`n`n"
}

; pozdravna poruka
if lp {
  mail.= lpMsg "`n`n"

}
else
{
  mail.= zaSveOstaloMsg "`n`n"
}

GuiControl,, ComposedMail, %mail%
return

Kopira: 			; gets edit box content and stores it in variable and then in clipboard
	GuiControlGet, editBox,, ComposedMail
	clipboard = %editBox%
	return

  CloseScript(Name)
  	{
  	DetectHiddenWindows On
  	SetTitleMatchMode RegEx
  	IfWinExist, i)%Name%.* ahk_class AutoHotkey
  		{
  		WinClose
  		WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
  		If ErrorLevel
  			return "Unable to close " . Name
  		else
  			return "Closed " . Name
  		}
  	else
  		return Name . " not found"
  	}
