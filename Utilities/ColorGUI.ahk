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
	winHeight      := 110
	winExtraWidth  := 6
	winExtraHeight := 29
	winTenPadding  := 2
	monWidth       := tmpMonRight - tmpMonLeft
	monHeight      := tmpMonBottom - tmpMonTop
	newWinX        := monWidth - winWidth - winExtraWidth + winTenPadding + curMonLeft
	newWinY        := monHeight - winHeight - winExtraHeight + winTenPadding + curMonTop

	Gui, Add, Text, vMC x10  y05, % "Moving color:"
	Gui, Add, Text,     x10  y25, % "Moving coords:"
	Gui, Add, Text, VCC x10  y47, % "Clicked color:"
	Gui, Add, Text,     x10  y67, % "Clicked coords:"
	Gui, Add, Text, vXY x123 y25 w070, 0
	Gui, Add, Text, vC2 x123 y05 w070, 0
	Gui, Add, Edit, vC3 x123 y45 w070 h18 +Readonly, 0
	Gui, Add, Edit, vC4 x123 y65 w070 h18 +Readonly, 0
	Gui, Add, Edit, vC5 x010 y85 w183 h18 +Readonly, 0
	Gui, Show, w%winWidth% h%winHeight% x%newWinX% y%newWinY%, Colors
	Gui, +AlwaysOnTop

	WinSet, Region, 50-0 W200 H250 E, WinTitle
}

WatchCursor() {
	MouseGetPos, X, Y
	PixelGetColor, MovingColor, %X%, %Y%, RGB
	GuiControl,, XY, %X%\, %Y%
	GuiControl,, C2, %MovingColor%
	GuiControl,, MC, Moving color:
	GuiControl, +c%MovingColor%, MC
}

TraverseArea() {
	ToolTip % "Working...", 0, 0

	colorOut := FileOpen("Colors.txt", "w")
	coordOut := FileOpen("Coords.txt", "w")

	While(UpperXY[2] >= LowerXY[2]++) {
		colorStr := ""
		coordStr := ""

		While(UpperXY[1] >= LowerXY[1] + A_Index - 1) {
			RealLowerXY := [ LowerXY[1] + A_Index - 1, LowerXY[2] - 1 ]
			
			PixelGetColor, AreaPixelColor, RealLowerXY[1], RealLowerXY[2], RGB

			colorStr := colorStr . Format("  {:06}\t\t", AreaPixelColor)
			coordStr := coordStr . Format("[ {1:3d}, {2:3d} ]\t", RealLowerXY*)
		}
		
		;colorStr := SubStr(colorStr, 1, -1) . "\n"
		;coordStr := SubStr(coordStr, 1, -1) . "\n"
		
		colorOut.Write(SubStr(colorStr, 1, -1) . "\n")
		coordOut.Write(SubStr(coordStr, 1, -1) . "\n")
	}
	
	;colorOut.Write(colorStr . "\n" . SubStr(coordStr, 1, -1)), colorOut.Close()
	
	colorOut.Close()
	coordOut.Close()

	ToolTip % "Done", 0, 0
}

Global LowerXY := [ 0, 0 ]
Global UpperXY := [ 0, 0 ]

CreateGUI()

SetTimer, WatchCursor, 25
Return

GuiClose:
	ExitApp

^LButton::
	MouseGetPos, LX, LY
	Global LowerXY := [ LX, LY ]
	Return

^RButton::
	MouseGetPos, UX, UY
	Global UpperXY := [ UX, UY ]
	Return

^+LButton::
	MouseGetPos, MX, MY
	PixelGetColor, ClickedColor, MX, MY, RGB
	GuiControl,, C3, % ClickedColor
	GuiControl,, C4, % MX ", " MY
	GuiControl,, C5, % ClickedColor ", [ " MX ", " MY " ]"
	GuiControl, +c%ClickedColor%, CC
	Clipboard := ClickedColor ", [ " MX ", " MY " ]"
	Return

^+RButton::
	MouseGetPos, MX, MY
	PixelGetColor, PixelColor, MX, MY, RGB
	FileAppend, %PixelColor%\, [ %MX%\, %MY% ]\n, Colors.txt
	Return

^+!LButton::
	TraverseArea()
	Return

+^R::Reload
