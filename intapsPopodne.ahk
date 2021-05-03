;intapsPopodne poboljšani

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetBatchLines, -1  ; to never sleep (i.e. have the script run at maximum speed).
#SingleInstance, force ; force close open windows and open new
#Include %A_ScriptDir%\Chrome1.ahk   ; Chrome.ahk library included
intapps_running()
PageInst:=Chrome.GetPageByTitle("HD Raspored 2.0") ;uzima otvoreni tab po imenu
/*
if !IsObject(PageInst) {
    msgbox, Please login first. You will be redirected to login page ! PLease Login and try  again.
    new_intapps()
    ExitApp
}
*/
; variables

global smjena2_txt:=""
global secondi2_txt:=""
global dodatni2_txt:=""
global dodatni2_array:=[]
global dodatni2_array_txt:=""


FormatTime, datumForm,, dd		.MM.yyyy     ; get today's date
;msgbox,,, %date%,2    ; msgbox with 2 seconds timer
datumForm := SubStr(datumForm,1,2)
;msgbox,,, %date%,2    ; msgbox with 2 seconds timer

;nputBox, datum_input, UNESI, Unesi datum:    ; alternative solution for user to search other dates

i := 1
j := 2
Loop
{

	datum = i=%i%, document.getElementsByTagName("tr")[i].getElementsByTagName("td")[0].innerText.substr(0,3)

	If !InStr(PageInst.Evaluate(datum).value, datumForm) {      ; iterate until today's date same as date in tr

    i+=1
		j+=1

	}
	Else     ; when dates match
	{
		datumDns = i=%i%, document.getElementsByTagName("tr")[i].getElementsByTagName("td")[0].innerText
		global datumTxt := PageInst.Evaluate(datumDns).value
		;msgBox, %datumTxt%
		;msgBox, % PageInst.Evaluate(datumDns).value

		js_firsti =
	(
	  JSON.stringify(
	    (i=%i%, [].map.call(
	      document.querySelectorAll("tr")[i].querySelectorAll("td.smjena_2"), (e) => e.innerText)))
	)

		global firsti := chrome.Jxon_Load(PageInst.Evaluate(js_firsti).value) ; iz js_firsti smo dobili listu firsti


		js_secondi =
	(
	  JSON.stringify(
	    (i=%i%, [].map.call(
	      document.querySelectorAll("tr")[i].querySelectorAll("td.smjena_2.second"), (e) => e.innerText)))
	)

		global secondi := chrome.Jxon_Load(PageInst.Evaluate(js_secondi).value)


	  js_dodatni =
	(
	  JSON.stringify(
	    (j=%j%, [].map.call(
	      document.querySelectorAll("tr")[j].querySelectorAll("td.dodatnaSmjena"), (e) => e.innerText)))
	)

		global dodatni := chrome.Jxon_Load(PageInst.Evaluate(js_dodatni).value)


		js_dodatni_sati =
	(
	  JSON.stringify(
	    (j=%j%, [].map.call(
	      document.querySelectorAll("tr")[j].querySelectorAll("a"), (e) => e.outerHTML.substr(47,5))))
	 )

		global dodatni_sati := chrome.Jxon_Load(PageInst.Evaluate(js_dodatni_sati).value)

		secondi2_txt.=secondi[1]       ; add first element in array
		secondi2_txt.="`n"             ; add linefeed
		secondi2_txt.=secondi[2]
		;msgBox, %secondi2_txt%

    for each, element in firsti {
      if (StrLen(element) < 3)
        continue
      if (smjena2_txt <> "")  ;Concat is not empty, so add a line feed
         smjena2_txt.="`n"
         smjena2_txt.=element
         ukupnoFirsti+=1
       }
			 ;msgBox, %smjena2_txt%
		break       ; exit loop
	}
}   ; loop end
i := 1

while ( dodatni_sati[i] <> "")   {
  if dodatni_sati[i] >= "14" {
    dodatniPopodne+=1
    dodatni2_array.Push((dodatni[i])(" od ")(dodatni_sati[i]))
  }
	i+=1
}
for each, element in dodatni2_array {
	if (dodatni2_array_txt <> "")
		;msgBox, %element%
		dodatni2_array_txt.="`n"
	dodatni2_array_txt.= element
}
if (dodatni2_array_txt = ""){
	dodatni2_array_txt.= "/"
}
;msgBox, %dodatni2_array_txt%

if (dodatniPopodne = ""){
	global ukupno := (ukupnoFirsti)

}
Else{
	global ukupno := (ukupnoFirsti) + dodatniPopodne
	;msgbox, % ukupno
}

; no 2nd agent class on weekend and holiday (bug in shift schedule)
if (secondi2_txt = "`n"){

  vikend()
}
Else {

  obicna_smjena()
}

obicna_smjena()
{
  ;  msgbox: agents in today schedule (first agent in line is considered 2nd) and put in clipboard
	clipboard := "*POPODNEVNA SMJENA*" datumTxt " `n`n2nd-i su :`n`n"secondi2_txt " `n`nRedovna smjena :`n`n"smjena2_txt  "`n`nDodatni agenti:`n`n " dodatni2_array_txt "`n`nUkupno agenata:  " ukupno
	;msgBox,,Automatska poruka, %clipboard%
}


vikend()
{
	clipboard := "* VIKEND/BLAGDAN JE *`n`n`n2nd ujutro je :   "firsti[1] " `n`nJutarnja redovna smjena :`n`n"smjena2_txt  "`n`nDodatni agenti ujutro:`n`n " dodatni2_array_txt "`n`nUkupno agenata:  "ukupno
	;msgBox,,Automatska poruka, %clipboard%
}

ExitApp

/* open pidign messenger, find one of the 2nd agents and send second_report*/
second_report.=secondi[1]     ; 2nd agent that will recieve the report
Run, pidgin,,Min, PID     ; Run pidgin minimized
WinWait, Buddy List ,,3   ; find windows, wait for it to appear
Send ^m
Sleep, 1000
WinWait, Pidgin ,,3
ControlSend,,%second_report%
Sleep, 1000
ControlSend,, {Down}
ControlSend,, {Enter}
ControlSend,, {Enter}
Sleep, 500
WinWait, %second_report% ,,3    ; find windows, wait for it to appear
ControlSend,, ^+v                   ;press ctrl+shift+V and enter
ControlSend,, {Enter}
Sleep, 500
ExitApp
