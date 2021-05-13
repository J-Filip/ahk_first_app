SetBatchLines, -1
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; chrome i AutoHotkey

; _______________ POS_______________

InputBox, inicijali, UNESI, Unesi inicijale
InputBox, korIme, UNESI, Unesi kor.ime

::fj::fjugkala
::njs::ne javlja se ; štef_ikona

::%inicijali%::%kor.ime%


^CapsLock::
Send, POS@o365.carnet.hr
return

::dtm::
FormatTime, date,, dd.MM.Filip -%A_space%
Send, %date%
return
