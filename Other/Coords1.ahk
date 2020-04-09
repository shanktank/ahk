#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

WatchCursor() {
	MouseGetPos X, Y
	PixelGetColor, FixedColor, %itemX%, %itemY%, RGB
	PixelGetColor, MovingColor, %X%, %Y%, RGB
	GuiControl, , X, %X%
	GuiControl, , Y, %Y%
	GuiControl, , C1, %FixedColor%
	GuiControl, , C2, %MovingColor%
	GuiControl, +c%MovingColor%, MC
    GuiControl, , MC, Moving color:
	Match := "False"
	If(itemC = FixedColor) {
		Match := "True"
	}
	GuiControl, , X, %X%
	GuiControl, , Y, %Y%
	GuiControl, , C1, %FixedColor%
	GuiControl, , C2, %MovingColor%
	GuiControl, , T, %Match%
}

global itemX := 1604
global itemY := 877
global itemC := 0x09640D

;Gui, -Caption +ToolWindow
;Gui, Color, Red
Gui, +AlwaysOnTop
Gui, Show, w270 h110, GUI
Gui, Add, Text, x10 y10, X: 
Gui, Add, Text, x10 y25, Y: 
Gui, Add, Text, x10 y40, Fixed color: 
Gui, Add, Text, vMC x10 y55, Moving color: 
Gui, Add, Text, vCC x10 y70, Clicked color: 
Gui, Add, Text, x10 y85, Color match: 
Gui, Add, Text, vX x200 y10 w50, 0
Gui, Add, Text, vY x200 y25 w50, 0
Gui, Add, Text, vC1 x200 y40 w100, 0
Gui, Add, Text, vC2 x200 y55 w100, 0
Gui, Add, Text, vC3 x200 y70 w100, 0
Gui, Add, Text, vT x200 y85 w100, False
/*
Loop {
	MouseGetPos, X, Y, W
	PixelGetColor, Color, X, Y
	Match = False
	If(itemC = Color) {
		Match = True
	}
	GuiControl, , X, %X%
	GuiControl, , Y, %Y%
	GuiControl, , C, %Color%
	GuiControl, , T, %Match%
	Sleep, 100
}
*/
SetTimer, WatchCursor, 10
Return

^LButton::
	MouseGetPos MX, MY
	PixelGetColor, ClickedColor, MX, MY, RGB
	GuiControl, , C3, %ClickedColor%
	;GuiControl, Color, %ClickedColor%
	;GuiControl, , +c%ClickedColor%, msctls_progress32
	GuiControl, +c%ClickedColor%, CC
    GuiControl,, CC, Clicked color:
	Return

+^X::ExitApp

GuiClose:
ExitApp