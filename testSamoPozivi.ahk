#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; variables
;inputbox, potpis, Ime i prezime agenta za potpis :		; inputbox for var potpis which contains signature
#Include %A_ScriptDir%\Chrome1.ahk

/*
trebam procs kroz sve kju max -

*/
; gui ____________________________________________________
Gui, Font, S9 , Calibri
Gui, color, 90B2EC
Gui, Add, Checkbox, x320 y35 w100 h20 gpratiPoziveButt vprati, Prati pozive

; Generated using SmartGUI Creator 4.0
Gui, Show, , EM_SETCUEBANNER
Gui, +resize MinSize485x440 maxsize780x580
Gui, Show, x127 y87 h500 w780 , Mejlomat

Return

GuiClose:
ExitApp

;__________________________________________________________
; labels
pratiPoziveButt:
  {
    Gui, submit, NoHide
    if (prati = 1){
    crm_running()
    getVrijeme()
    SplashTextOn ,50 ,250 , Splash, Spojen
    sleep 500
    SplashTextOff
    GuiControlGet, crm
    if (crm = "")
    {
      Gui, Add, Text , x320 y55 w80 h40 vcrm, - ako je više od %vrijemeUnos% sec
    }Else
    {
      GuiControl,, crm, - ako je više od: %vrijemeUnos% sec
    }
    ;msgBox, % vrijemeUnos
    Settimer,tajmer, 15000
    ;msgBox, iniciro tajmer
    return
    ;msgBox, stala skripta
    tajmer:
    ;msgBox, početo tajmer

    kjuovi = []
    kjuMax = []
    ukupnoPoz = ""
    kjuMaxZbroj = 0
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
       try
       {
         PageInst.Disconnect()
      } catch e {
        msgBox, nije diskonekto
      }

    sleep 500
    FormatTime, timeStamp,, HH:mm
    for each, e in kjuMax{
      if (e > "0"){
        kjuMaxZbroj += e
      }
    }
    ;_______________________ conditions for splashtext
    if ( %kjuMaxZbroj% = 0 )
    {
      SplashTextOn ,200 ,250 , Splash,`n`n%timeStamp% NEMA POZIVA `n`n`n | Pratim svakih %vrijemeUnos% sekundi | %kjuovi_txt%
      WinMove, Splash, , 0, 0
      sleep 50
      SplashTextOff
      Return
    }
    else if ( %kjuMaxZbroj% >= vrijemeUnos)
    {
      msgBox, poziv
      SplashTextOn ,800 ,400 , Splash,`n`n%timeStamp% `n`nPOZIV NA ČEKANJU VIŠE OD:`n`n %vrijemeUnos% sekundi `n`n`n %kjuovi_txt%
      ;WinMove, Splash, , 0, 0
      sleep 6000
      SplashTextOff
      Return
    }
    else      ; tu javlja sve izmedju 1 i %vrijeme_input%
    {
      SplashTextOn ,800 ,400 , Splash,`n`n%timeStamp% `n`nPOZIV NA ČEKANJU ! `n`n`n %kjuovi_txt%
      ;WinMove, Splash, , 0, 0
      sleep 6000
      SplashTextOff
      Return
     }

  }
  if (prati = 0){
    GuiControl,, crm, ""
    SplashTextOn ,200 ,100 , Splash,`n`n Praćenje poziva isključeno !`n`n
  	sleep 1000
  	SplashTextOff
    SetTimer, tajmer, Off
    PageInst.Disconnect()
    sleep 200
    return
  }
}
