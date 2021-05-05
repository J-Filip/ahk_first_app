
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; chrome i AutoHotkey

#Include %A_ScriptDir%\Chrome1.ahk
crm_running()
getVrijeme()




#Persistent
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
   ;msgBox, % kjuMax[1]

    ;msgBox, % kjuovi[2]

;msgBox, % kjuMax[1]

FormatTime, timeStamp,, HH:mm
;msgBox, % timeStamp


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
if ( e >=vrijeme_input)
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
