#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

Global BREAKOUT := False

MouseGetPos, sx, sy
SetTimer, CheckCursor, 100
Return

CheckCursor:
MouseGetPos, cx, cy
If(cx != sx or cy != sy) {
	If(cx > (sx+1) or cx < (sx-1) or cy > (sy+1) or cy < (sy-1)) {
		MouseGetPos, sx, sy
		BREAKOUT := True
	}
}
Return

/*
checkItem() {
	PixelGetColor, PixelColor, %itemX%, %itemY%, RGB
	If(PixelColor = alchC or PixelColor = itemC1 or PixelColor = itemC2 or PixelColor = itemC3 or PixelColor = itemC4) {
		Return True
	} Else {
		Return False
	}
	
}
*/

F1::
    BREAKOUT := False
    Loop {
		;;If(checkItem() = False)
		;;	Return
		;;Send, {SPACE}
		Send, {Left Down}
		Random, s1, 213, 483
		Sleep, s1
		Send, {Left Up}
		Send, {Right Down}
		Random, s2, 224, 443
		Sleep, s2
		Send, {Right Up}
		If(BREAKOUT = True)
			Return
		Random, sleepy, 6300, 21300
        Sleep, sleepy
    }
    Return

^R::Reload
+^C::ExitApp
