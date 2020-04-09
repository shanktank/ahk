#SingleInstance FORCE
#Persistent
#NoEnv
#Warn
#EscapeChar \

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
CoordMode, ToolTip, Screen
SendMode Input

WatchCursor() {
	MouseGetPos, X, Y
	PixelGetColor PC, %X%, %Y%, RGB
	ToolTip, %X% %Y% %PC%, X + 15, Y + 15
	;ToolTip, %X% %Y%, X + 15, Y + 15
}

SetTimer, WatchCursor, 10
Return

^LButton::
	MouseGetPos, MX, MY
	PixelGetColor, PixelColor, %MX%, %MY%, RGB
	FileAppend, %PixelColor% (%MX%\, %MY%)\n, coords.txt
	Return

+^X::ExitApp