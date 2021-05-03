
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; chrome i AutoHotkey

#Include %A_ScriptDir%\Chrome1.ahk
crm_running()



Settimer,tajmer, 10000

tajmer:

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
   ;msgBox, % kjuMax[1]

   if ( kjuMax[2] = 0)
    ;msgBox, % kjuovi[2]

;msgBox, % kjuMax[1]
;msgBox, %vrijeme_input%

FormatTime, timeStamp,, HH:mm

if ( kjuMax[1] = 0) or (kjuMax[2] = 0) or (kjuMax[3] = 0)
{
  SplashTextOn ,200 ,150 , Splash,`n`n%timeStamp% NEMA POZIVA `n`n`n
  WinMove, Splash, , 0, 0
  sleep 1000
  SplashTextOff
  return
}
if ( kjuMax[1] >=vrijeme_input)
{
  SplashTextOn ,300 ,250 , Splash,`n`n%timeStamp% `n`nPOZIV NA ČEKANJU VIŠE OD:`n`n %vrijeme_input% sekundi `n`n`n %kjuovi_txt%
  WinMove, Splash, , 0, 0
  sleep 3000
  SplashTextOff
}
else      ; tu javlja sve izmedju 1 i %vrijeme_input%
{
  SplashTextOn ,300 ,250 , Splash,`n`n%timeStamp% `n`nPOZIV NA ČEKANJU ! `n`n`n %kjuovi_txt%
  WinMove, Splash, , 0, 0
  sleep 3000
  SplashTextOff
}
/*
else if ( kjuMax[1] >= 6000) or (kjuMax[2] >= 6000) or (kjuMax[3] >= 6000)
{
  MsgBox, 36,, Poziv na čekanju više od 10 minuta.`n`n Pošalji u pp-pos grupu na pidginu ? (odaberi Yes ili No),5
    IfMsgBox Yes
    {
      clipboard := "* AUTOMATSKA PORUKA - POZIV NA ČEKANJU VIŠE OD 10 MINUTA *`n`n`nVrijeme objave :" timeStamp  "`n`n" kjuovi_txt
      msgBox, %clipboard%
      posalji()
    }
    else
      Sleep 500
}
*/
return

; open pidign messenger, find PP chat room and send
posalji()
{
  ExitApp
  Run, pidgin,,Min, PID ; Run Notepad minimized.
  WinWait, Buddy List ,,3  ; Wait for it to appear.
  ControlSend,, {down 70}
  Sleep, 500
  ControlSend,, {Enter}
  Sleep, 500
  WinWait, pp-pos ,,3  ; Wait for it to appear.
  ControlSend,, ^+v
  Sleep, 200
}
