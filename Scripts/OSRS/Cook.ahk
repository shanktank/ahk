#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, RegEx
SendMode, Input

;#IfWinActive ^(RuneLite|OpenOSRS)$

F1::moveMouse(findPixelByColor(0xFF00FF)["xy"])
F2::moveMouse(findPixelByColor(0x0000FF)["xy"])

^R::Reload
+^C::ExitApp