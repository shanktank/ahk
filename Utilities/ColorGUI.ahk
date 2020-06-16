#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SendMode Input

CreateGUI() {
	Global

	SysGet, tmpMon, MonitorWorkArea
	SysGet, curMon, Monitor

	winWidth       := 200
	winHeight      := 85
	winExtraWidth  := 6
	winExtraHeight := 29
	winTenPadding  := 2
	monWidth       := tmpMonRight - tmpMonLeft
	monHeight      := tmpMonBottom - tmpMonTop
	newWinX        := monWidth - winWidth - winExtraWidth + winTenPadding + curMonLeft
	newWinY        := monHeight - winHeight - winExtraHeight + winTenPadding + curMonTop

	Gui, Add, Text,     x10  y10,                   Moving coords:
	Gui, Add, Text, vMC x10  y25,                   Moving color:
	Gui, Add, Text,     x10  y40,                   Clicked coords:
	Gui, Add, Text, VCC x10  y60,                   Clicked color:
	Gui, Add, Text, vXY x123 y10 w70,               0
	Gui, Add, Text, vC2 x123 y25 w70,               0
	Gui, Add, Edit, vC3 x123 y40 w70 h18 +Readonly, 0
	Gui, Add, Edit, vC4 x123 y60 w70 h18 +Readonly, 0
	Gui, Show, w%winWidth% h%winHeight% x%newWinX% y%newWinY%, Colors
	Gui, +AlwaysOnTop

	WinSet, Region, 50-0 W200 H250 E, WinTitle
}

WatchCursor() {
	Loop {
		MouseGetPos, X, Y
		PixelGetColor, MovingColor, %X%, %Y%, RGB
		GuiControl,, XY, %X%\, %Y%
		GuiControl,, C2, %MovingColor%
		GuiControl,, MC, Moving color:
		GuiControl, +c%MovingColor%, MC
		Sleep, 25
	}
}

CreateGUI()
WatchCursor()

GuiClose:
	ExitApp

+^LButton::
	MouseGetPos, MX, MY
	PixelGetColor, ClickedColor, MX, MY, RGB
	GuiControl,, C3, %MX%\, %MY%
    GuiControl,, C4, %ClickedColor%
	GuiControl, +c%ClickedColor%, CC
	Return

+^RButton::
	MouseGetPos, MX, MY
	PixelGetColor, PixelColor, MX, MY, RGB
	FileAppend, %PixelColor%\, [ %MX%\, %MY% ]\n, coords.txt
	Return

+^R::Reload
