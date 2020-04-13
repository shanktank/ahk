#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

Global itemC := 0x09640D
Global itemX := 1604
Global itemY := 877

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

;Gui, -Caption +ToolWindow
;Gui, Color, Red
Gui, +AlwaysOnTop
Gui, Show, w270 h140, Coords and Colors
Gui, Add, Text, x10 y10, X: 
Gui, Add, Text, x10 y25, Y: 
Gui, Add, Text, x10 y40, Fixed color: 
Gui, Add, Text, vMC x10 y55, Moving color: 
Gui, Add, Text, vCC x10 y70, Clicked color: 
Gui, Add, Text, vCX x10 y85, Clicked X: 
Gui, Add, Text, vCY x10 y100, Clicked Y: 
Gui, Add, Text, x10 y115, Color match:
Gui, Add, Text, vX x200 y10 w50, 0
Gui, Add, Text, vY x200 y25 w50, 0
Gui, Add, Text, vC1 x200 y40 w100, 0
Gui, Add, Text, vC2 x200 y55 w100, 0
Gui, Add, Text, vC3 x200 y70 w100, 0
Gui, Add, Text, vC4 x200 y85 w100, 0
Gui, Add, Text, vC5 x200 y100 w100, 0
Gui, Add, Text, vT x200 y115 w100, False

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

SetTimer, WatchCursor, 25
Return

GuiClose:
ExitApp

^LButton::
	MouseGetPos MX, MY
	PixelGetColor, ClickedColor, MX, MY, RGB
	GuiControl,, C3, %ClickedColor%
    GuiControl,, C4, %MX%
	GuiControl,, C5, %MY%
	GuiControl, +c%ClickedColor%, CC
	Return
