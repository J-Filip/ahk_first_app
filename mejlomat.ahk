#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; variables
;inputbox, potpis, Ime i prezime agenta za potpis :		; inputbox for var potpis which contains signature
#Include %A_ScriptDir%\Chrome1.ahk



InputBox, potpis, UNESI, Unesi svoje ime i prezime koje koristiš u potpisu:
if ErrorLevel{
  msgBox, Neš koristit? Pff...
  ExitApp
}
if (potpis = ""){
  potpis = "/POTPIS/"
}


; gui ____________________________________________________
Gui, Font, S9 , Calibri
Gui, color, 90B2EC
Gui, Add, Edit, x10 y20 w100 hwndIme vprezime,
EM_SETCUEBANNER(ime, "Ime ili prezime")
Gui, Add, Edit, x150 y20 w150 hwndUstanova vustanova,
EM_SETCUEBANNER(ustanova, "Ustanova")
Gui, Add, Edit, x150 y40 w150 hwndKorisnik vkorisnik,
EM_SETCUEBANNER(korisnik, "Korisnik")
Gui, Add, Edit, x215 y99 w260 h200 vComposedMail,
Gui, Add, Radio, x32 y89 w100 h20 checked gRadClicked vgdja, Gđa.
Gui, Add, Radio, x32 y109 w100 h20 gRadClicked vgdin, Gdin.
Gui, Add, Radio, x32 y129 w100 h20 gRadClicked vdraga, Draga
Gui, Add, Radio, x32 y149 w100 h20 gRadClicked vdragi, Dragi
Gui, Add, Radio, x133 y139 w70 h20 gRadClicked vtiket, TIKET
Gui, Add, Text, x2 y209 w60 h20 , Sadržaj
Gui, Add, Checkbox, x32 y229 w100 h20 gRadClicked vzahvala, Zahvala
Gui, Add, Checkbox, x133 y229 w80 h30 gRadClicked vustKor, Ustanova i korisnik
Gui, Add, Checkbox, x32 y249 w100 h30 gRadClicked vproslijeđen, Proslijeđen nadležnoj
Gui, Add, Checkbox, x32 y279 w100 h20 gRadClicked vnejasni, Nejasni
Gui, Add, Checkbox, x32 y299 w100 h20 gRadClicked vnedovoljno, Nedovoljno
Gui, Add, Checkbox, x32 y319 w100 h30 gRadClicked vproslijeđenhd, Proslij. HD
Gui, Add, Text, x2 y369 w110 h30 gRadClicked checked 0 vpozdravna, Pozdravna poruka:
Gui, Add, Radio, x32 y390 w100 h30 gRadClicked vzaSveOstale, Za sve ostale
Gui, Add, Radio, x142 y390 w100 h30 gRadClicked vLp, Lp
Gui, Add, Button, x382 y299 w70 h40 gkopira, Kopiraj
Gui, Add, Button, x472 y9 w60 h30 gdashletiButt vsemafor, Dashleti
GUI, Add, Button, x530 y20 w78 h21 ghideContrDash, Hide/Unhide
Gui, Add, Checkbox, x320 y35 w100 h20 gpratiPoziveButt vprati, Prati pozive
Gui, Add, Button, x232 y299 w60 h20 ghasekButt vhasek, Hasek
Gui, Add, Button, x620 y9 w60 h30 grasporedButt, Raspored
Gui, Add, Button, x680 y20 w78 h21 ghideContrRasp, Hide/Unhide
Gui, Add, Text, x2 y69 w110 h20 , Oslovljavanje :
Gui, Add, Text, x2 y450 w450 h40 , ** prije korištenja mogućnosti Prati pozive, Hašek, Dashleti i Raspored, potrebno je SAMO JEDNOM ugasiti ugasiti sve otvorene chrome prozore i otvoriti ih pomoću ovog gumba ili odabirom neke od navedenih mogućnosti. **
Gui, Add, Button, x450 y450 w70 h30 gresetButt, X Reset X
; Generated using SmartGUI Creator 4.0
Gui, Show, , EM_SETCUEBANNER
Gui, +resize MinSize485x440 maxsize780x580
Gui, Show, x127 y87 h500 w780 , Mejlomat

Return

GuiClose:
ExitApp

return
;__________________________________________________________
; labels
pratiPoziveButt:
  {
    Gui, submit, NoHide
    if (prati = 1){
    crm_running()
    getVrijeme()
    GuiControlGet, crm
    if (crm = "")
    {
      Gui, Add, Text , x320 y55 w80 h40 vcrm, - ako je više od %vrijemeUnos% sec
    }Else
    {
      GuiControl,, crm, - ako je više od: %vrijemeUnos% sec
    }
    ;msgBox, % vrijemeUnos
    Settimer,tajmer, 7000
    return
    msgBox, stala skripta
    tajmer:


    PageInst.Disconnect()
    kjuovi = []
    kjuMax = []
    timeStamp = ""

    PageInst:=Chrome.GetPageByTitle("CARNET CRM") ;uzima otvoreni new tab po imenu

    js_kjuovi =
    (
      JSON.stringify(
      [].map.call(document.querySelectorAll("#pbxis-queues li"), (e) => e.innerText))
    )
    kjuovi := chrome.Jxon_Load(PageInst.Evaluate(js_kjuovi).value)
    ;kju1 .= kjuovi[1]
    ;msgBox, % kjuovi[1]
    kjuovi_txt = ""
    for each, element in kjuovi {
      if (kjuovi_txt <> "")  ;Concat is not empty, so add a line feed
         kjuovi_txt.="`n"
         kjuovi_txt.=element
       }
       ;msgBox, % kjuovi_txt

       js_kjuMax =
       (
         JSON.stringify(
         [].map.call(document.querySelectorAll("#pbxis-queues li > span:nth-child(6)"), (e) => e.innerText.substr(10)))
       )
       kjuMax := chrome.Jxon_Load(PageInst.Evaluate(js_kjuMax).value)
    FormatTime, timeStamp,, HH:mm
    for each, e in kjuMax{
      ;msgBox, % e
    if ( e = 0 )
    {
      SplashTextOn ,200 ,150 , Splash,`n`n%timeStamp% NEMA POZIVA `n`n`n | Pratim svakih %vrijemeUnos% sekundi |
      WinMove, Splash, , 0, 0
      sleep 500
      SplashTextOff
      Return
    }
    if ( e >=vrijemeUnos)
    {
      msgBox, poziv
      SplashTextOn ,800 ,400 , Splash,`n`n%timeStamp% `n`nPOZIV NA ČEKANJU VIŠE OD:`n`n %vrijemeUnos% sekundi `n`n`n %kjuovi_txt%
      ;WinMove, Splash, , 0, 0
      sleep 3000
      SplashTextOff
      Return
    }
    else      ; tu javlja sve izmedju 1 i %vrijeme_input%
    {
      SplashTextOn ,800 ,400 , Splash,`n`n%timeStamp% `n`nPOZIV NA ČEKANJU ! `n`n`n %kjuovi_txt%
      ;WinMove, Splash, , 0, 0
      sleep 3000
      SplashTextOff
      Return
     }
    }
    return
  }
  if (prati = 0){
    GuiControl,, crm, ""
    SplashTextOn ,200 ,100 , Splash,`n`n Praćenje poziva isključeno !`n`n
  	sleep 1000
  	SplashTextOff
    SetTimer, tajmer, Off
  }
  return
}

resetButt:
{
  ugasiUpali("chrome.exe")
}

/*
pratiPozive:
{
  Gui, submit, NoHide
  if (prati = 1){
    run, crmpozivi.ahk
    ;vrijeme := clipboard
    GuiControlGet, crm
    if (crm = "")
    {
      Gui, Add, Text , x320 y50 w80 h40 vcrm, - ako je više od %clipboard% sec
    }Else
    {
      GuiControl,, crm, - ako je više od: %clipboard% sec
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
*/

dashletiButt:
{
  runwait, crmDashleti.ahk
  izvj := clipboard
  GuiControlGet, semaforText
  if (semaforText = "")
  {
  Gui, Font, S7 CDefault, Verdana
  Gui, Add, Text , x490 y65 w110 h300 vsemaforText, %izvj%
  }
  Else
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
  }
  Else
  {
    GuiControl,, raspored, %rasp%
  }
  sleep 1000
  return
}


hideContrDash:
{
  GuiControlGet, semaforText
  if (semaforText<>"-")
  {
    GuiControl,, semaforText, -
  }
  else
  {
    GuiControl,, semaforText, %izvj%
  }
  return
}
hideContrRasp:
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
  return
}

hasekButt:
{
  PageInst.Disconnect()
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

Kopira: 	; gets edit box content and stores it in variable and then in clipboard
{

	GuiControlGet, editBox,, ComposedMail
  clipboard = %editBox%
  clipboard := RegExReplace(clipboard,"\R+\R", "`r`n")
  SplashTextOn ,350 ,350 ,Splash,  %clipboard%
  sleep 1000
  SplashTextOff
	return
}

gdaDisable()
{
  GuiControl, Enable, zahvala
  GuiControl, Enable, proslijeđen
  GuiControl, Enable, nejasni
  GuiControl, Enable, zaSveOstale
  GuiControl, Enable, nedovoljno
  GuiControl, Enable, proslijeđenhd

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
  GuiControl,, nedovoljno, 0
  GuiControl,, proslijeđenhd, 0

  GuiControl,, lp, 1
  GuiControl, Disable, zahvala
  GuiControl, Disable, proslijeđen
  GuiControl, Disable, nejasni
  GuiControl, Disable, zaSveOstale
  GuiControl, Disable, nedovoljno
  GuiControl, Disable, proslijeđenhd

  GuiControl, Enable, ustKor
  GuiControl, Enable, lp
}

RadClicked:
; variables
gdineMsg = Poštovani gospodine %editPrezime%,
gdjoMsg = Poštovana gospođo %editPrezime%,
dragiMsg = Dragi %editPrezime%,
dragaMsg = Draga %editPrezime%,
pozdravMsg = Pozdrav,

zahvalaMsg = zahvaljujemo na poslanim informacijama. Iste su proslijeđene nadležnoj službi. Po primitku odgovora povratno ćemo Vas kontaktirati u najkraćem mogućem vremenu.
proslijeđenMsg = Vaš upit je proslijeđen nadležnoj službi. Po primitku odgovora ćemo Vas povratno kontaktirati.
nejasniMsg = zaprimili smo poruku nejasnog sadržaja. Molimo Vas da provjerite jeste li poruku poslali na ispravnu adresu.
proslijeđenHdMsg = Vaš upit proslijeđen je odgovarajućoj službi - CARNET podršci za krajnje korisnike na elektroničku adresu helpdesk@carnet.hr. Molimo Vas za strpljenje do pristizanja odgovora. Molimo Vas da ubuduće sve slične upite šaljete izravno na navedenu adresu. Ako je poruka ipak namijenjena CARNET-u, u povratnoj poruci potrebno nam je poslati detaljniji upit kako bismo mogli pružiti odgovarajuću podršku.
nedovoljnoMsg = zbog nedovoljno informacija nismo Vam u mogućnosti pružiti odgovarajuću podršku. Molimo Vas da nam u povratnoj poruci
ustKorMsg = ustanova:%editUstanova% `nkorisnik:%editKorisnik%
zaSveOstaloMsg = Za sve ostale upite stojimo Vam na raspolaganju,`n%potpis%
lpMsg = Lijep pozdrav,`n%potpis%

Gui, submit, NoHide
GuiControlGet, editPrezime,, prezime
GuiControlGet, editUstanova,, ustanova
GuiControlGet, editKorisnik,, korisnik
;_____slaganje maila
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
if nedovoljno{
  mail.= nedovoljnoMsg "`n`n"
}
if proslijeđenhd{
  mail.= proslijeđenHdMsg "`n`n"
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



; koristio za zatvorit druge skripte
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
