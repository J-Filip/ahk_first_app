#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; #NoTrayIcon
#SingleInstance force




; ::::::DZOB::::::::

InputBox, UserInput, Ime agenta, Unesi ime koje koristis kod pisanja komentara., , 280, 160
if ErrorLevel
    MsgBox, CANCEL ? Ziiiiher...
else
    return

::dtm::
FormatTime, date,, d.M.%UserInput% -%A_space%
Send, %date%
return

::njs::ne javlja se ; štef_ikona
return