#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

WatchCursor() {
	MouseGetPos, X, Y
	PixelGetColor pixelColor, %X%, %Y%, RGB
	ToolTip, %X% %Y% %pixelColor%, X + 15, Y + 15
}

SetTimer, WatchCursor, 10
Return

+^C::ExitApp
