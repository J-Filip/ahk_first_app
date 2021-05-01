
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; chrome i AutoHotkey
#Include %A_ScriptDir%\Chrome1.ahk
crm_running()

PageInst:=Chrome.GetPageByTitle("CARNET CRM") ;uzima otvoreni new tab po imenu

;msgBox, pocetak

Settimer,tajmer, 10000

tajmer:

FormatTime, date,, HH:mm
js_eskole = document.querySelector("#pbxis_queue_eSkole > span:nth-child(6)").innerText.substr(10)
js_szz = document.querySelector("#pbxis_queue_eSkole > span:nth-child(6)").innerText.substr(10)
js_eskole_broj_poziva = document.querySelector("#pbxis_queue_eSkole > span:nth-child(5)").innerText.substr(9)
js_szz_broj_poziva = document.querySelector("#pbxis_queue_SkolaZaZivot > span:nth-child(5)").innerText.substr(9)

eskole_poziv:= PageInst.Evaluate(js_eskole).value
szz_poziv := PageInst.Evaluate(js_szz).value
eskole_broj_poziva:= PageInst.Evaluate(js_eskole_broj_poziva).value
szz_broj_poziva := PageInst.Evaluate(js_szz_broj_poziva).value

;msgBox, %eskole_broj_poziva%

; it should be other way around so that likelier statemnts are first to run
if ( eskole_poziv >= 120) or (szz_poziv >= 120)
{
  SplashTextOn,,, A MsgBox is about to appear.
  Sleep 3000
  SplashTextOff
  MsgBox, 36,, Pošalji u pp-pos grupu na pidginu ? (odaberi Yes ili No)
    IfMsgBox Yes
    {
      clipboard := "* OVO JE AUTOMATSKA PORUKA - POZIV NA ČEKANJU *`n`n`nVrijeme objave :" date  "`n`n e-Škole vrijeme na čekanju : " eskole_poziv " `n e-Škole broj poziva na čekanju : "eskole_broj_poziva
      msgBox, %clipboard%
      posalji()
    }
    else
      Sleep 200
}
else if ( eskole_poziv >= 60) or (szz_poziv >= 60)
{
  SplashTextOn,,, A MsgBox is about to appear.
  Sleep 2000
  SplashTextOff
  MsgBox, 36,, Pošalji u pp-pos grupu na pidginu ? (odaberi Yes ili No)
    IfMsgBox Yes
    {
      clipboard := "* OVO JE AUTOMATSKA PORUKA - POZIV NA ČEKANJU *`n`n`nVrijeme objave :" date  "`n`n e-Škole vrijeme na čekanju : " eskole_poziv " `n e-Škole broj poziva na čekanju : "eskole_broj_poziva
      msgBox, %clipboard%
      posalji()
      sleep 30000
    }
    else
      Sleep 200
}
else if ( eskole_poziv > 0) or (szz_poziv > 0)
{
  SplashTextOn,,, A MsgBox is about to appear.
  Sleep 2000
  SplashTextOff
  MsgBox, 36,, Pošalji u pp-pos grupu na pidginu ? (odaberi Yes ili No)
    IfMsgBox Yes
    {
      clipboard := "* OVO JE AUTOMATSKA PORUKA - POZIV NA ČEKANJU *`n`n`nVrijeme objave :" date  "`n`n e-Škole vrijeme na čekanju : " eskole_poziv " `n e-Škole broj poziva na čekanju : "eskole_broj_poziva
      msgBox, %clipboard%
      posalji()
      sleep 30000
    }
    else
      Sleep 200
}
else ; tu su pozivi između 0 i 1 minute
{
  SplashTextOn ,200 ,150 , Splash,%date% NEMA POZIVA `n`n`n SZZ vrijeme na čekanju: %szz_poziv% `n SZZ broj poziva na čekanju: %szz_broj_poziva% `n`n e-Škole vrijeme na čekanju: %eskole_poziv% `n e-Škole broj poziva na čekanju: %eskole_broj_poziva%
  WinMove, Splash, , 1380, 810
  Sleep 2000
  SplashTextOff
 }


return

; open pidign messenger, find PP chat room and send
posalji()
{
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
