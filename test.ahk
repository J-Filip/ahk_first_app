SetBatchLines, -1
#SingleInstance, force ; gasi otvoreni windows i pokreće novi automtatski
; chrome i AutoHotkey

GuiControl, show, prezime
GuiControlGet, editBox,, ComposedMail, Mejlomat
clipboard = %editBox%
msgBox, % editBox
 x  = %editbox%
return
