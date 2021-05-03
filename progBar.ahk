Gui, Add, Progress, w300 h20 cBlue vMyProgress
gui, show

loop, 10
{
GuiControl,, MyProgress, +10
sleep 50
}
gui, destroy
