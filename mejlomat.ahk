#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; variables
;inputbox, potpis, Ime i prezime agenta za potpis :		; inputbox for var potpis which contains signature
#Include %A_ScriptDir%\Chrome1.ahk




;InputBox, datum, UNESI, Unesi datum:
;raspored := %datum%
Gui, Font, S8 CDefault, Verdana
Gui, Add, Edit, x10 y20 w100 hwndIme vprezime,
EM_SETCUEBANNER(ime, "Ime ili prezime")
Gui, Add, Edit, x150 y20 w150 hwndUstanova vustanova,
EM_SETCUEBANNER(ustanova, "Ustanova")
Gui, Add, Edit, x150 y40 w150 hwndKorisnik vkorisnik,
EM_SETCUEBANNER(korisnik, "Korisnik")
Gui, Add, Edit, x232 y99 w220 h200 vComposedMail,
Gui, Add, Radio, x32 y89 w100 h30 checked gRadClicked vgdja, Gdja.
Gui, Add, Radio, x32 y119 w100 h30 gRadClicked vgdin, Gdin.
Gui, Add, Radio, x32 y149 w100 h30 checked gRadClicked vdraga, Draga
Gui, Add, Radio, x32 y179 w100 h20 gRadClicked vdragi, Dragi
Gui, Add, Radio, x152 y139 w70 h30 gRadClicked vtiket, TIKET
Gui, Add, Text, x2 y209 w60 h20 , Sadržaj
Gui, Add, Checkbox, x32 y229 w100 h30 gRadClicked vzahvala, Zahvala
Gui, Add, Checkbox, x142 y259 w80 h30 gRadClicked vustKor, Ustanova i korisnik
Gui, Add, Checkbox, x32 y259 w100 h30 gRadClicked vproslijeđen, Proslijedjen
Gui, Add, Checkbox, x32 y289 w100 h30 gRadClicked vnejasni, Nejasni
Gui, Add, Text, x2 y339 w110 h30 gRadClicked checked 0 vpozdravna, Pozdravna poruka:
Gui, Add, Radio, x32 y360 w100 h30 gRadClicked vzaSveOstale, Za sve ostale
Gui, Add, Radio, x142 y360 w100 h30 gRadClicked vLp, Lp
Gui, Add, Button, x382 y299 w70 h40 gkopira, Kopiraj
Gui, Add, Button, x472 y9 w60 h30 gsemaforButt vsemafor, Dashleti
Gui, Add, Checkbox, x300 y380 w100 h20 gpratiPozive vprati, Prati pozive
Gui, Add, Button, x232 y299 w60 h20 ghasekButt vhasek, Hasek
Gui, Add, Button, x620 y9 w60 h30 grasporedButt, Raspored
Gui, Add, Button, x680 y15 w78 h21 ghideContr, Hide/Unhide
Gui, Add, Text, x2 y69 w110 h20 , Oslovljavanje :
Gui, Add, Text, x2 y435 w450 h40 , ** prije korištenja mogućnosti Prati pozive, Hašek, Dashleti i Raspored, potrebno je SAMO JEDNOM ugasiti ugasiti sve otvorene chrome prozore i otvoriti ih pomoću ovog gumba ili odabirom neke od navedenih mogućnosti. **
; Generated using SmartGUI Creator 4.0
Gui, Show, , EM_SETCUEBANNER
Gui, Show, x127 y87 h500 w750, Mejlomat
Return

GuiClose:
ExitApp

return
;__________________________________________________________
; labels
pratiPozive:
{
  Gui, submit, NoHide
  if (prati = 1){
    getVrijeme()
    run, crmpozivi.ahk
    ;sleep, 3000
    GuiControlGet, crm
    if (crm = "")
    {
      Gui, Add, Text , x300 y400 w80 h50 vcrm, - ako je više od %x% sec
    }Else
    {
      GuiControl,, crm, - ako je više od: %x% sec
    }
  }
  if (prati = 0){
    DetectHiddenWindows On  ; Allows a script's hidden main window to be detected.
    SetTitleMatchMode 2  ; Avoids the need to specify the full path of the file below.
    WinClose crmpozivi.ahk - AutoHotkey
    GuiControlGet, crm
    GuiControl,, crm, ""
    sleep 1000

  }
  return
}
RemoveToolTip:
ToolTip
return

semaforButt:
{
  ToolTip, Dohvaćam dashlete..., 500, 470
  SetTimer, RemoveToolTip, -4000
  runwait, crmDashleti.ahk
  izvj := clipboard
  GuiControlGet, semaforText
  if (semaforText = "")
  {
  Gui, Font, S7 CDefault, Verdana
  Gui, Add, Text , x472 y50 w100 h300 vsemaforText, %izvj%
  }Else
  {
    GuiControl,, semaforText, %izvj%
  }
  sleep 1000
  return
}

rasporedButt:
{
  FormatTime, sati,, HH:mm
  if (sati > 14){
    runwait, intapsPopodne.ahk
  }
  Else{
    runwait, intaps_jutro.ahk
  }
  rasp := clipboard
  GuiControlGet, raspored
  if (raspored = "")
  {
    Gui, Font, S7 CDefault, Verdana
    Gui, Add, Text, x620 y50 w100 h450 vraspored, %rasp%
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
  clipboard := RegExReplace(clipboard,"\R+\R", "`r`n")
  ;msgBox, %clipboard%
  hasekRunning()
  ;sleep 2000
  PageInst:= Chrome.GetPageByURL("https://ispravi.me/")
  PageInst.Evaluate("document.querySelector('#textarea').innerText="Chrome.Jxon_Dump(clipboard) )
  PageInst.Evaluate("document.querySelector('#checkText').click()")
  return
}
hideContr:
{
  GuiControlGet, raspored
  if (raspored<>"-")
    {
      GuiControl,, raspored, -
    }
  else
    {
      GuiControl,, raspored, %rasp%
    }
}

RadClicked:
gdineMsg = Poštovani gospodine %editPrezime%,
gdjoMsg = Poštovana gospođo %editPrezime%,
dragiMsg = Dragi IME,
dragaMsg = Draga IME,
pozdravMsg = Pozdrav,

zahvalaMsg = zahvaljujemo na ...
proslijeđenMsg = Vaš upit je proslijeđen ...
nejasniMsg = nejasni upit ...

ustKorMsg = ustanova:%editUstanova% `nkorisnik:%editKorisnik%

zaSveOstaloMsg = Za sve ostale upite.
lpMsg = Lijep pozdrav,`n%potpis%

Gui, submit, NoHide
GuiControlGet, editPrezime,, prezime
GuiControlGet, editUstanova,, ustanova
GuiControlGet, editKorisnik,, korisnik
mail := ""
; Oslovljavanje
if gdja {
  gdaDisable()
  ;gdjoMsg = Poštovana gospođo %editBox%,
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
if draga {
  gdaDisable()
  mail:= dragaMsg "`n`n"

}
if dragi {
  gdaDisable()
  mail:= dragiMsg "`n`n"
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
  mail.= lpMsg
}
else
{
  mail.= zaSveOstaloMsg
}

GuiControl,, ComposedMail, %mail%
return


Kopira: 			; gets edit box content and stores it in variable and then in clipboard
	GuiControlGet, editBox,, ComposedMail
  clipboard = %editBox%
  clipboard := RegExReplace(clipboard,"\R+\R", "`r`n")
  ;msgBox, %clipboard%
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
    EM_SETCUEBANNER(hWnd, Cue)
    {
        return DllCall("user32.dll\SendMessage", "Ptr", hWnd, "UInt", 0x1501, "Ptr", 1, "Ptr", &Cue, "Ptr")
    }
