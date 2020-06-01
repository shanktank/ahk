#Include %A_MyDocuments%/Git/ahk/Libraries/RandomBezier.ahk

#SingleInstance FORCE
#Persistent
#NoEnv
#Warn

CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, RegEx
SendMode, Input

; ================================================================================================================================================== ;
; -- Data Classes ---------------------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

Class PixelColorLocation {
	pixelColor  := 0x000000
	pixelCoords := [ 0, 0 ]

	__New(p, c) {
		This.pixelColor  := p
		This.pixelCoords := c
	}
}

Class ClickAreaBounds {
	lowerBounds := [ 0, 0 ]
	upperBounds := [ 0, 0 ]

	__New(l, u) {
		This.lowerBounds := l
		This.upperBounds := u
	}
}

; ================================================================================================================================================== ;
; -- Pixel Color Finders and Validators ------------------------------------------------------------------------------------------------------------ ;
; ================================================================================================================================================== ;

verifyPixelColor(pixelColor, xy) {
	PixelGetColor, pc, xy[1], xy[2], RGB
	Return pc == pixelColor
}

waitForPixelToBeColor(pixelColor, xy, timeout := 5000, hoverNext := 0) {
	sleepFor := 25
	sleepNum := timeout / sleepFor

	Loop, %sleepNum% {
		Sleep, sleepFor
		If(verifyPixelColor(pixelColor, xy)) {
			Return True
		}
	}

	Return False
}

waitForPixelToNotBeColor(pixelColor, xy, timeout := 5000, hoverNext := 0) {
	sleepFor := 25
	sleepNum := timeout / sleepFor

	Loop, %sleepNum% {
		Sleep, sleepFor
		If(verifyPixelColor(pixelColor, xy) == False) {
			Return True
		}
	}

	Return False
}

findPixelByColor(pixelColor, lowerBounds := 0, upperBounds := 0, shadeTolerance := 10) {
	If(lowerBounds == 0)
		lowerBounds := [ 0, 25 ]
	If(upperBounds == 0)
		upperBounds := [ 1350, 850 ]

	PixelSearch, X, Y, lowerBounds[1], lowerBounds[2], upperBounds[1], upperBounds[2], pixelColor, shadeTolerance, RGB, Fast

	Return { xy : [ X, Y ], rc : ErrorLevel }
}

findPixelByColorX(pixelColor, lowerBounds := 0, upperBounds := 0, tries := 10, shadeTolerance := 10) {
	If(lowerBounds == 0)
		lowerBounds := [ 0, 25 ]
	If(upperBounds == 0)
		upperBounds := [ 1350, 850 ]

	Loop, %tries% {
		PixelSearch, X, Y, lowerBounds[1], lowerBounds[2], upperBounds[1], upperBounds[2], pixelColor, shadeTolerance, RGB, Fast
		If(ErrorLeveL == 0 || A_Index == tries) {
			Return { xy : [ X, Y ], rc : ErrorLevel }
		} Else {
			Sleep, 100
		}
	}
}

checkIfHoveringAction() {
	MouseGetPos, X, Y
	Return verifyPixelColor(0x433A32, [ X, Y + 35 ])
}

verifyClick(actionType := "Interact") {
	If(actionType == "Neither") {
		Return True
	}

	MouseGetPos, X, Y
	pixelColor := actionType == "Walk" ? 0xFFFF00 : 0xFF0000

	Loop, 25 {
		If(verifyPixelColor(pixelColor, [ X, Y ])) {
			Return True
		}
		Sleep, 5
	}

	Return False
}

; ================================================================================================================================================== ;
; -- Random Value Generators ----------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

generateSleepTime(lowerBound := 109, upperBound := 214) {
	Random, sleepFor, %lowerBound%, %upperBound%
	Return sleepFor
}

generateCoords(lowerBounds, upperBounds) {
	Random, X, lowerBounds[1], upperBounds[1]
	Random, Y, lowerBounds[2], upperBounds[2]
	Return [ X, Y ]
}

generateCoordsWithOffsets(lowerBounds, upperBounds, offsetRangeX, offsetRangeY) {
	XY := generateCoords(lowerBounds, upperBounds)
	Random, OX, offsetRangeX[1], offsetRangeX[2]
	Random, OY, offsetRangeY[1], offsetRangeY[2]
	Return [ XY[1] + OX, XY[2] + OY ]
}

; ================================================================================================================================================== ;
; -- Input Operations ------------------------------------------------------------------------------------------------------------------------------ ;
; ================================================================================================================================================== ;

moveMouse(moveCoords, mouseSpeedDivisor := 3) {
	mouseSpeed := DecideSpeed(CalculateDistance(moveCoords), mouseSpeedDivisor)
	RandomBezier(moveCoords[1], moveCoords[2], "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3")
}

doClick(sleepFor := 0, actionType := "Neither", mouseButton := "Left") {
	Sleep, generateSleepTime(52, 163)
	MouseClick, %mouseButton%
	rc := verifyClick(actionType)
	Sleep, sleepFor
	Return rc
}

moveMouseAndClick(clickCoords, mouseSpeedDivisor := 3, sleepFor := 0, actionType := "Neither", rightClick := False) {
	If(sleepFor == 0)
		sleepFor := generateSleepTime(174, 242)
	moveMouse(clickCoords, mouseSpeedDivisor)
	Return doClick(sleepFor, actionType, rightClick)
}

handleDropdownMenu() {
	; NYI
}

inputKeyAndSleep(inputKey, sleepFor := 0) {
	Send, %inputKey%
	Sleep, sleepFor
}

; ================================================================================================================================================== ;
; -- Debugging and Testing Tools ------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

traceCoordsBounds(lb, ub) {
	Corners := [ [ lb[1], lb[2] ], [ ub[1], lb[2] ], [ ub[1], ub[2] ], [ lb[1], ub[2] ], [ lb[1], lb[2] ] ]

	For _, Element In Corners {
		MouseMove, Element[1], Element[2]
		Sleep, 500
	}
}

;SetFormat, IntegerFast, Hex