#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; chrome i AutoHotkey
 #Include %A_ScriptDir%\Chrome1.ahk
crm_running()

PageInst:=Chrome.GetPageByURL("https://suitecrm.carnet.hr/index.php?module=Home&action=index") ;uzima otvoreni new tab po imenu

if !IsObject(PageInst) {
    msgbox, Otovori CRM Home i probaj opet.
    ExitApp
}

dashleti_array:= []
dashleti_txt:=" Dashleti: `n "

;PageInst.Evaluate("location.reload()")
PageInst:=Chrome.GetPageByURL("https://suitecrm.carnet.hr/index.php?module=Home&action=index")
dashTab = document.querySelector("#tab0").click()
PageInst.Evaluate(dashTab)
sleep, 2000


/*
js_tabovi =
(
  JSON.stringify(
  [].map.call(document.querySelectorAll(".hidden-xs"), (e) => e.innerText))
)
tabovi := chrome.Jxon_Load(PageInst.Evaluate(js_tabovi).value)
;msgBox, % tabovi[1]
*/
js_dashleti =
(
  JSON.stringify(
  [].map.call(document.querySelectorAll("td.dashlet-title"), (e) => e.innerText))
)
dashleti := chrome.Jxon_Load(PageInst.Evaluate(js_dashleti).value)
;msgBox, % dashleti[1]

js_broj_zahtjeva=
(
  JSON.stringify(
    [].map.call(document.querySelectorAll(".pageNumbers"), (e) => e.innerText.substr(10,).slice(0,-1)))
    )
broj_zahtjeva := chrome.Jxon_Load(PageInst.Evaluate(js_broj_zahtjeva).value)
;msgBox, % broj_zahtjeva[1]
PageInst.Disconnect()
i := 1

; ___ ne radi jer zbraja sve page_numbers na stranici pa bi trebalo stalno refrreshat i navigirat
;______ može se napravit mali gui pa da izaberes iz kojeg taba želiš broj zahtjeva
;broj_dashl = document.querySelectorAll(".pageNumbers").length
;msgBox, % PageInst.Evaluate(broj_dashl).value


while broj_zahtjeva[i] <> ""{
  ;dashleti_array.Push(dashleti[i])
  ;dashleti_array.Push(broj_zahtjeva[i])
  dashleti_array.Push((dashleti[i]),("  -  ")(broj_zahtjeva[i]))
  i+=1
}

;____ probat napravit da ne posta ako nema zahtjeva
/*
  for each, element in dashleti_array {
  if (element = "")
    dashleti_txt.="`n"
  dashleti_txt.=element
    }
    msgBox, % dashleti_txt


; ____ ovo radi, testiram neš drugo
while broj_zahtjeva[i] <> ""{
  ;dashleti_array.Push((dashleti[i]))
  ;dashleti_array.Push((broj_zahtjeva[i]))
  dashleti_array.Push((dashleti[i]),(broj_zahtjeva[i]))
  i+=1
 }
 */


for each, element in dashleti_array {
  ;msgbox, %element%
if (dashleti_txt <> "")
  dashleti_txt.="`n"
dashleti_txt.=element
  }
  clipboard := dashleti_txt
  ;msgBox, % dashleti_txt
ExitApp
