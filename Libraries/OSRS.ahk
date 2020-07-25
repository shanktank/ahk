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
; -- Globals --------------------------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

Global RED    := 0xFF0000
Global BLUE   := 0x0000FF
Global GREEN  := 0x00FF00
Global YELLOW := 0xFFFF00
Global PURPLE := 0xFF00FF
Global CYAN   := 0x00FFFF

Global InvSlot1Bounds   := New ClickAreaBounds([ 1408, 660 ], [ 1436, 689 ])
Global InvSlot14Bounds  := New ClickAreaBounds([ 1465, 805 ], [ 1493, 832 ])
Global InvSlot15Bounds  := New ClickAreaBounds([ 1518, 805 ], [ 1549, 835 ])
Global BankSlot1Bounds  := New ClickAreaBounds([  439, 135 ], [  464, 166 ])
Global BankSlot2Bounds  := New ClickAreaBounds([  498, 137 ], [  529, 169 ])
Global DepositAllBounds := New ClickAreaBounds([  903, 776 ], [  938, 815 ])

Global InvOpenCheck := New PixelColorLocation(0x75281E, [ 1211, 1009 ])

; ================================================================================================================================================== ;
; -- Data Classes ---------------------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

Class UIObject {
	moveMouse(moveCoords, mouseSpeedDivisor := 2.5) {
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

	moveMouseAndClick(clickCoords, mouseSpeedDivisor := 2.5, sleepFor := 0, actionType := "Neither", rightClick := False) {
		If(sleepFor == 0)
			sleepFor := generateSleepTime(174, 242)

		This.moveMouse(clickCoords, mouseSpeedDivisor)
		Return This.doClick(sleepFor, actionType, rightClick)
	}

	inputKeyAndSleep(inputKey, sleepFor := 0) {
		If(sleepFor == 0)
			sleepFor := generateSleepTime()

		Sleep, generateSleepTime()
		Send, %inputKey%
		Sleep, sleepFor
	}

	verifyInvIsOpen() {
		If(InvOpenCheck.verifyPixelColor() == False) {
			Base.inputKeyAndSleep("{Esc}")
			If(InvOpenCheck.verifyPixelColor() == False) {
				MsgBox % "Can't detect inventory?"
				Reload
			}
		}
	}
}

Class PixelColorLocation Extends UIObject {
	Static pixelColor  := 0x000000
	Static pixelCoords := [ 0, 0 ]

	__New(pixelColor, pixelCoords) {
		This.pixelColor  := pixelColor
		This.pixelCoords := pixelCoords
	}

	verifyPixelColor() {
		PixelGetColor, pixelColor, This.pixelCoords[1], This.pixelCoords[2], RGB
		Return pixelColor == This.pixelColor
	}

	waitForPixelToBeColor(timeout := 5000, checkIf := True, hoverNext := 0) {
		sleepFor := 25
		sleepNum := timeout / sleepFor

		Loop, %sleepNum% {
			Sleep, sleepFor
			If(This.verifyPixelColor() == checkIf) {
				Return True
			}
		}

		Return False
	}
}

Class ClickAreaBounds Extends UIObject {
	Static lowerBounds := [ 0, 0 ]
	Static upperBounds := [ 0, 0 ]

	__New(lowerBounds, upperBounds) {
		This.lowerBounds := lowerBounds
		This.upperBounds := upperBounds
	}

	moveMouseAndClick(mouseSpeedDivisor := 2.5, sleepFor := 0, actionType := "Neither", rightClick := False) {
		Return Base.moveMouseAndClick(This.generateCoords(), mouseSpeedDivisor, sleepFor, actionType, rightClick)
	}

	generateCoords() {
		Random, X, This.lowerBounds[1], This.upperBounds[1]
		Random, Y, This.lowerBounds[2], This.upperBounds[2]
		Return [ X, Y ]
	}
}

Class TileMarkerBounds Extends UIObject {
	Static pixelColor     := 0x000000
	Static minOffset      := [ 0, 0 ]
	Static maxOffset      := [ 0, 0 ]
	Static shadeTolerance := 0

	__New(pixelColor, minOffset, maxOffset, shadeTolerance) {
		This.pixelColor     := pixelColor
		This.minOffset      := minOffset
		This.maxOffset      := maxOffset
		This.shadeTolerance := shadeTolerance
	}

	moveMouseAndClick(mouseSpeedDivisor := 2.5, sleepFor := 100) {
		While(This.verifyClick() == False) {
			If(A_Index > 10)
				Return False
			If(A_Index == 2)
				mouseSpeedDivisor := mouseSpeedDivisor / 2

			Sleep, generateSleepTime(184, 319)
			Base.moveMouseAndClick(This.generateCoords(), mouseSpeedDivisor, sleepFor)
		}

		Return True
	}

	verifyClick() {
		MouseGetPos, X, Y
		PixelGetColor, pixelColor, X, Y, RGB
		Return pixelColor == RED
	}

	findPixelByColor(lowerBounds := -1, upperBounds := -1) {
		If(lowerBounds == -1)
			lowerBounds := [ 0, 25 ]
		If(upperBounds == -1)
			upperBounds := [ 1350, 850 ]

		Loop, 5 {
			PixelSearch, X, Y, lowerBounds[1], lowerBounds[2], upperBounds[1], upperBounds[2], This.pixelColor, This.shadeTolerance, RGB, Fast
			If(ErrorLevel == 0) {
				Return { xy : [ X, Y ], rc : ErrorLevel } ; just do break instead?
			} Else {
				Sleep, 100
			}
		}

		Return { xy : [ X, Y ], rc : ErrorLevel }
	}

	proximitySearch(lowerBounds := -1, upperBounds := -1) {
		If(lowerBounds == -1)
			lowerBounds := [ 0, 25 ]
		If(upperBounds == -1)
			upperBounds := [ 1350, 850 ]

		centerXY := [ 830, 535 ]
		maxXY := [ 1640, 1050 ]
		increments := [ 20, 10 ]
		
		Loop {
			proximity := [ increments[1] * A_Index, increments[2] * A_Index ]

			If(centerXY[1] + proximity[1] > maxXY[1] Or centerXY[2] + proximity[2] > maxXY[2]) {
				Return { xy : [ 0, 0 ], rc : ErrorLevel }
			}

			PixelSearch, X, Y, centerXY[1] - proximity[1], centerXY[2] - proximity[2], centerXY[1] + proximity[1], centerXY[2] + proximity[2], This.pixelColor, This.shadeTolerance, RGB, Fast
			If(ErrorLevel == 0) {
				Return { xy : [ X, Y ], rc : ErrorLevel }
			} Else {
				Sleep, 100
			}
		}
	}

	generateCoords() {
		XY := This.findPixelByColor()

		If(XY["rc"] != 0) {
			SetFormat, IntegerFast, Hex
			MsgBox % "Could not find pixel (" This.pixelColor ")"
			Reload
		}

		Random, X, XY["xy"][1] + This.minOffset[1], XY["xy"][1] + This.maxOffset[1]
		Random, Y, XY["xy"][2] + This.minOffset[2], XY["xy"][2] + This.maxOffset[2]

		Return [ X, Y ]
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

findPixelByColor(pixelColor, lowerBounds := -1, upperBounds := -1, shadeTolerance := 10) {
	If(lowerBounds == -1)
		lowerBounds := [ 0, 25 ]
	If(upperBounds == -1)
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

findPixelByColorWaveSearch(pixelColor, lowerBounds := -1, upperBounds := -1, shadeTolerance := 10) {
	startingPointX := 960
	startingPointY := 540

	waveLength := 0

	ErrorLevel := -1
	While(ErrorLevel != 0) {
		If(A_Index > 25)
			Return { xy : [ X, Y ], rc : ErrorLevel }
		waveLength += 25
		PixelSearch, X, Y, startingPointX - waveLength, startingPointY - waveLength, startingPointX + waveLength, startingPointY + waveLength, pixelColor, shadeTolerance, RGB, Fast
		Sleep, 100
	}

	Return { xy : [ X, Y ], rc : ErrorLevel }
}

proximitySearch(pixelColor, lowerBounds := -1, upperBounds := -1, shadeTolerance := 10) {
	If(lowerBounds == -1)
		lowerBounds := [ 0, 25 ]
	If(upperBounds == -1)
		upperBounds := [ 1350, 850 ]

	centerXY := [ 830, 535 ]
	maxXY := [ 1640, 1050 ]
	increments := [ 20, 10 ]
	
	Loop {
		proximity := [ increments[1] * A_Index, increments[2] * A_Index ]

		If(centerXY[1] + proximity[1] > maxXY[1] Or centerXY[2] + proximity[2] > maxXY[2]) {
			Return { xy : [ 0, 0 ], rc : ErrorLevel }
		}

		PixelSearch, X, Y, centerXY[1] - proximity[1], centerXY[2] - proximity[2], centerXY[1] + proximity[1], centerXY[2] + proximity[2], pixelColor, shadeTolerance, RGB, Fast
		If(ErrorLevel == 0) {
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

	Loop, 20 {
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

moveMouse(moveCoords, mouseSpeedDivisor := 2.5) {
	mouseSpeed := DecideSpeed(CalculateDistance(moveCoords), mouseSpeedDivisor)
	RandomBezier(moveCoords[1], moveCoords[2], "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3")
}

doClick(sleepFor := 0, actionType := "Neither", mouseButton := "Left") {
	Sleep, generateSleepTime(52, 163)
	MouseClick, %mouseButton%
	rc := verifyClick(actionType)
	If(rc == True)
		Sleep, sleepFor
	Return rc
}

moveMouseAndClick(clickCoords, mouseSpeedDivisor := 2.5, sleepFor := 0, actionType := "Neither", rightClick := False) {
	If(sleepFor == 0)
		sleepFor := generateSleepTime(174, 242)
	moveMouse(clickCoords, mouseSpeedDivisor)
	Return doClick(sleepFor, actionType, rightClick)
}

openDropdownMenu() {
	; NYI
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