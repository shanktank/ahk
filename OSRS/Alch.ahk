#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

Global BREAKOUT := False

Global itemX  := 1604
Global itemY  := 877
Global alchC  := 0x000001
Global itemC1 := 0x09640D
Global itemC2 := 0x234C1B
Global itemC3 := 0x483D09
Global itemC4 := 0x433919

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

checkItem() {
	PixelGetColor, PixelColor, %itemX%, %itemY%, RGB
	If(PixelColor = alchC or PixelColor = itemC1 or PixelColor = itemC2 or PixelColor = itemC3 or PixelColor = itemC4) {
		Return True
	} Else {
		Return False
	}
}

F1::
    BREAKOUT := False
    Loop {
		;If(checkItem() = False)
		;	Return
		Random, sleepy, 223, 427
		If(BREAKOUT = True)
			Return
        Click
        Sleep, sleepy
    }
    Return

PrintScreen::
ScrollLock::
Pause::
	Suspend
	BREAKOUT := True
	Return
