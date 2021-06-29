#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, RegEx
SendMode, Input

#IfWinActive ^(RuneLite|OpenOSRS)$

Global RunActiveCheck	:= New PixelColorLocation(0xECDA67, [ 1430, 198 ])
Global RunNearFull		:= New PixelColorLocation(0xB49301, [ 1438, 187 ])
Global RunHalfFull		:= New PixelColorLocation(0xB79501, [ 1441, 196 ])
Global RunNearEmpty		:= New PixelColorLocation(0xC39E01, [ 1430, 208 ])

SetTimer, CheckHitpoints, 100
Return

CheckHitpoints:
RCB := RunNearFull.verifyPixelColor()
PixelGetColor, pcg, 1419, 185
SetFormat, IntegerFast, Hex
Running := RunActiveCheck.verifyPixelColor()
If(RunNearFull.verifyPixelColor() == True) {
	ToolTip % "Running: " Running " | High energy | " pcg, 500, 0
} Else If(RunHalfFull.verifyPixelColor() == True) {
	ToolTip % "Running: " Running " | Medium Energy | " pcg, 500, 0
} Else If(RunNearEmpty.verifyPixelColor() == True)  {
	ToolTip % "Running: " Running " | Low energy | " pcg, 500, 0
}
Return

#If
^R::Reload
+^C::ExitApp
