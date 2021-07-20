#Include %A_MyDocuments%/Git/ahk/Libraries/RandomBezier.ahk
#Include %A_MyDocuments%/Git/ahk/Libraries/Math.ahk

#SingleInstance Force
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode, Input

; ================================================================================================================================================== ;
; -- Globals --------------------------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

Global CLICK_TYPE				:= "Neither"

Global RED						:= 0xFF0000
Global BLUE						:= 0x0000FF
Global GREEN					:= 0x00FF00
Global YELLOW					:= 0xFFFF00
Global PURPLE					:= 0xFF00FF
Global CYAN						:= 0x00FFFF
Global TEAL						:= 0x008372
Global ORANGE					:= 0xFF9B00
Global ORANGE					:= 0xBC6916
Global HILITE					:= 0xE6CC80

Global ScreenLowerBounds		:= [    0,   50 ]
Global ScreenUpperBounds		:= [ 1350,  850 ]
Global ScreenLowerBoundsBig		:= [    0,   25 ]
Global ScreenUpperBoundsBig		:= [ 1640, 1000 ]
Global ScreenLowerBoundsFull	:= [    0,   25 ]
Global ScreenUpperBoundsFull	:= [ 1640, 1049 ]

Global InvSlot1Bounds			:= New ClickAreaBounds([ 1408, 660 ], [ 1436, 689 ])
Global InvSlot2Bounds			:= New ClickAreaBounds([ 1465, 663 ], [ 1487, 690 ])
Global InvSlot3Bounds			:= New ClickAreaBounds([ 1518, 662 ], [ 1551, 689 ])
Global InvSlot14Bounds			:= New ClickAreaBounds([ 1465, 805 ], [ 1493, 832 ])
Global InvSlot15Bounds			:= New ClickAreaBounds([ 1518, 805 ], [ 1549, 835 ])
Global BankSlot1Bounds			:= New ClickAreaBounds([  439, 135 ], [  464, 166 ])
Global BankSlot2Bounds			:= New ClickAreaBounds([  498, 137 ], [  529, 169 ])
Global BankSlot3Bounds			:= New ClickAreaBounds([  566, 138 ], [  590, 165 ])
Global DepositAllBounds			:= New ClickAreaBounds([  903, 776 ], [  938, 815 ])

Global LowHealthCheck			:= New PixelColorLocation(0x8A0703, [ 1404,  114 ])
Global MidHealthCheck			:= New PixelColorLocation(0x9C0704, [ 1400,  109 ])
Global HighHealthCheck			:= New PixelColorLocation(0x9C0704, [ 1413,   97 ])
Global OptsOpenCheck			:= New PixelColorLocation(0x6B241B, [ 1525, 1015 ])
Global InvOpenCheck				:= New PixelColorLocation(0x75281E, [ 1211, 1009 ])
Global BankOpenCheck			:= New PixelColorLocation(0xFC9620, [  406,   57 ])
Global BankOpenCheck2			:= New PixelColorLocation(0x000001, [  977,   48 ], 5)
Global BankClosedCheck			:= New PixelColorLocation(0x827563, [ 1220, 1013 ])
Global InvSlot28Empty			:= New PixelColorLocation(0x3E3529, [ 1593,  967 ])
Global LevelUpGeneric			:= New PixelColorLocation(0x2723EB, [  472,  974 ])
Global LevelUpHerblore			:= New PixelColorLocation(0x094809, [   74,  922 ])

; ================================================================================================================================================== ;
; -- Data Classes ---------------------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;

; TODO: Standardize multi-clickers into classes
; TODO: Make mouseSpeedDivisor, hoverNext, shadeTolerance global variables
; TODO: Rename UIObject to OSRSlib, PixelColorLocation to PixelColorCoords
; TODO: Make standard "IsUIElementOpen" to reduce repetition

Class UIObject {
	moveMouse(moveCoords, mouseSpeedDivisor := 2.5) {
		Local mouseSpeed := DecideSpeed(CalculateDistance(moveCoords), mouseSpeedDivisor)
		RandomBezier(moveCoords[1], moveCoords[2], "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3")
	}
	
	moveMouse2(invokingObject, mouseSpeedDivisor := 2.5) {
		Local moveCoords := invokingObject.generateCoords()
		Local mouseSpeed := DecideSpeed(CalculateDistance(moveCoords), mouseSpeedDivisor)
		RandomBezier(moveCoords[1], moveCoords[2], "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3")
	}
	
	moveMouseRelative(deltaX, deltaY, mouseSpeedDivisor := 2.5) {
		MouseGetPos, X, Y
		This.moveMouse([ X + deltaX, Y + deltaY ], mouseSpeedDivisor)
	}

	doClick(sleepFor := 0, actionType := "Neither", mouseButton := "Left") {
		Sleep, generateSleepTime(52, 163)
		MouseClick, %mouseButton%
		clickRC := verifyClick(actionType)
		Sleep, sleepFor
		Return clickRC
	}

	moveMouseAndClick(clickCoords, mouseSpeedDivisor := 2.5, sleepFor := 0, actionType := "Neither", rightClick := False) {
		If(sleepFor == 0)
			sleepFor := generateSleepTime(274, 342)

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
	
	verifyOptsIsOpen() {
		If(OptsOpenCheck.verifyPixelColor() == False) {
			Base.inputKeyAndSleep("F5")
			If(InvOpenCheck.verifyPixelColor() == False) {
				MsgBox % "Can't detect inventory?"
				Reload
			}
		}
	}
}

Class PixelScanArea Extends UIObject {
	Static pixelColor		:= 0x000000
	Static lowerBounds		:= [ 0, 0 ]
	Static upperBounds		:= [ 0, 0 ]
	Static shadeTolerance	:= 0

	__New(pixelColor, lowerBounds, upperBounds) {
		This.pixelColor  := pixelColor
		This.lowerBounds := lowerBounds
		This.upperBounds := upperBounds
	}
	
	scanAreaForPixelColor() {
		PixelSearch, X, Y, This.lowerBounds[1], This.lowerBounds[2], This.upperBounds[1], This.upperBounds[2], This.pixelColor, This.shadeTolerance, Fast RGB
		Return { xy : [ X, Y ], rc : ErrorLevel }
		;Return ErrorLevel
	}
}

Class PixelColorLocation Extends UIObject {
	Static pixelColor		:= 0x000000
	Static pixelCoords		:= [ 0, 0 ]
	Static shadeTolerance	:= 0

	__New(pixelColor, pixelCoords, shadeTolerance := 0) {
		This.pixelColor 	:= pixelColor
		This.pixelCoords 	:= pixelCoords
		This.shadeTolerance	:= shadeTolerance
	}

	verifyPixelColor(pixelColorCheck := -1, shadeTolerance := 0) {
		If(pixelColorCheck == -1) {
			pixelColorCheck := This.pixelColor
		}
		
		;PixelGetColor, pixelColor2, This.pixelCoords[1], This.pixelCoords[2], RGB
		PixelSearch, __, __, This.pixelCoords[1] - 1, This.pixelCoords[2] - 1, This.pixelCoords[1] + 1, This.pixelCoords[2] + 1, This.pixelColor, This.shadeTolerance, Fast RGB
		;Return pixelColorCheck == pixelColor2
		Return ErrorLevel == 0
	}

	waitForPixelToBeColor(timeout := 5000, checkIf := True, hoverNext := 0, pixelColorCheck := -1, shadeTolerance := 0) {
		If(pixelColorCheck == -1) {
			pixelColorCheck := This.pixelColor
		}

		sleepFor := 25
		sleepNum := timeout / sleepFor

		Loop, %sleepNum% {
			Sleep, sleepFor
			If(This.verifyPixelColor(pixelColorCheck) == checkIf) {
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

	moveMouse(mouseSpeedDivisor := 2.5) {
		Base.moveMouse2(This, mouseSpeedDivisor := 2.5)
	}

	moveMouseAndClick(mouseSpeedDivisor := 2.5, sleepFor := 0, actionType := "Neither", rightClick := False) {
		Return Base.moveMouseAndClick(This.generateCoords(), mouseSpeedDivisor, sleepFor, actionType, rightClick)
	}

	generateCoords() {
		Return [ Rand(This.lowerBounds[1], This.upperBounds[1]), Rand(This.lowerBounds[2], This.upperBounds[2]) ]
	}
}

Class TileMarkerBounds Extends UIObject {
	Static pixelColor     := 0x000000
	Static minOffset      := [ 0, 0 ]
	Static maxOffset      := [ 0, 0 ]
	Static shadeTolerance := 0

	__New(pixelColor, minOffset, maxOffset, shadeTolerance := 10) {
		This.pixelColor     := pixelColor
		This.minOffset      := minOffset
		This.maxOffset      := maxOffset
		This.shadeTolerance := shadeTolerance
	}

	moveMouse(mouseSpeedDivisor := 2.5) {
		Base.moveMouse2(This, mouseSpeedDivisor)
	}
	
	moveMouseAndClick(mouseSpeedDivisor := 2.5, sleepFor := 10) {
		OpRC := False
		
		While(OpRC == False) {
			If(A_Index > 10)
				Return False
			If(A_Index == 2)
				mouseSpeedDivisor := mouseSpeedDivisor - 1

			Sleep, generateSleepTime(134, 219)
			OpRC := Base.moveMouseAndClick(This.generateCoords(), mouseSpeedDivisor, sleepFor, "Interact")
		}

		Return True
	}

	findPixelByColor(lowerBounds := -1, upperBounds := -1) {
		If(lowerBounds == -1)
			lowerBounds := ScreenLowerBounds
		If(upperBounds == -1)
			upperBounds := ScreenUpperBounds

		Loop, 5 {
			PixelSearch, localX, localY, lowerBounds[1], lowerBounds[2], upperBounds[1], upperBounds[2], This.pixelColor, This.shadeTolerance, Fast RGB
			If(ErrorLevel == 0) {
				Return { xy : [ localX, localY ], rc : ErrorLevel } ; just do break instead?
			} Else {
				Sleep, 100
			}
		}

		Return { xy : [ X, Y ], rc : ErrorLevel }
	}

	proximitySearch(lowerBounds := -1, upperBounds := -1) {
		If(lowerBounds == -1)
			lowerBounds := ScreenLowerBounds
		If(upperBounds == -1)
			upperBounds := ScreenUpperBounds

		centerXY := [ 830, 535 ]
		maxXY := [ 1640, 1050 ]
		increments := [ 20, 10 ]
		
		Loop {
			proximity := [ increments[1] * A_Index, increments[2] * A_Index ]

			If(centerXY[1] + proximity[1] > maxXY[1] Or centerXY[2] + proximity[2] > maxXY[2]) {
				Return { xy : [ 0, 0 ], rc : ErrorLevel }
			}

			PixelSearch, X, Y, centerXY[1] - proximity[1], centerXY[2] - proximity[2], centerXY[1] + proximity[1], centerXY[2] + proximity[2], This.pixelColor, This.shadeTolerance, Fast RGB
			If(ErrorLevel == 0) {
				Return { xy : [ X, Y ], rc : ErrorLevel }
			} Else {
				Sleep, 100
			}
		}
	}

	generateCoords(lowerBounds := -1, upperBounds := -1) {
		If(lowerBounds == -1)
			lowerBounds := ScreenLowerBounds
		If(upperBounds == -1)
			upperBounds := ScreenUpperBounds
	
		LocalXY := This.findPixelByColor(lowerBounds, upperBounds)

		If(LocalXY["rc"] != 0) {
			SetFormat, IntegerFast, Hex
			MsgBox % "Could not find pixel (" This.pixelColor ")"
			Reload
		}
		
		Random, X, LocalXY["xy"][1] + This.minOffset[1], LocalXY["xy"][1] + This.maxOffset[1]
		Random, Y, LocalXY["xy"][2] + This.minOffset[2], LocalXY["xy"][2] + This.maxOffset[2]

		Return [ X, Y ]
	}
}



DepositAll(randomMethod := False) {
	;Random, randInt1, 1, 10000
	;Random, randInt2, 1, 10000
	
	(randomMethod == True And Rand(1, 10000) <= 2342) ? InvSlot1Bounds.moveMouseAndClick() : DepositAllBounds.moveMouseAndClick()
	UIObject.doClick()
	If(Rand(1, 10000) >= 4329)
		UIObject.doClick()
	
	Sleep, generateSleepTime(212, 357)
}

; Turns out this shit is in UIObject already. Change MakePotions to not use it then remove.
OpenInventory() {
	If(InvOpenCheck.verifyPixelColor() == False) {
		UIObject.inputKeyAndSleep("{Esc}", generateSleepTime())
	}
}

Error() {

}




; ================================================================================================================================================== ;
; -------------------------------------------------------------------------------------------------------------------------------------------------- ;
; -- Legacy Code ----------------------------------------------------------------------------------------------------------------------------------- ;
; -------------------------------------------------------------------------------------------------------------------------------------------------- ;
; ================================================================================================================================================== ;





; ================================================================================================================================================== ;
; -- Pixel Color Finders and Validators ------------------------------------------------------------------------------------------------------------ ;
; ================================================================================================================================================== ;

verifyPixelColor(pixelColor, xy) {
	PixelGetColor, pc, xy[1], xy[2], Fast RGB
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
		lowerBounds := ScreenLowerBounds
	If(upperBounds == -1)
		upperBounds := ScreenUpperBounds

	PixelSearch, X, Y, lowerBounds[1], lowerBounds[2], upperBounds[1], upperBounds[2], pixelColor, shadeTolerance, Fast RGB

	Return { xy : [ X, Y ], rc : ErrorLevel }
}

findPixelByColorX(pixelColor, lowerBounds := 0, upperBounds := 0, tries := 10, shadeTolerance := 10) {
	If(lowerBounds == 0)
		lowerBounds := ScreenLowerBounds
	If(upperBounds == 0)
		upperBounds := ScreenUpperBounds

	Loop, %tries% {
		PixelSearch, X, Y, lowerBounds[1], lowerBounds[2], upperBounds[1], upperBounds[2], pixelColor, shadeTolerance, Fast RGB
		If(ErrorLevel == 0 || A_Index == tries) {
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
			Return { xy : [ coordX, coordY ], rc : ErrorLevel }
		waveLength += 25
		PixelSearch, coordX, coordY, startingPointX - waveLength, startingPointY - waveLength, startingPointX + waveLength, startingPointY + waveLength, pixelColor, shadeTolerance, Fast RGB
		Sleep, 100
	}

	Return { xy : [ X, Y ], rc : ErrorLevel }
}

proximitySearch(pixelColor, lowerBounds := -1, upperBounds := -1, shadeTolerance := 10) {
	If(lowerBounds == -1)
		lowerBounds := ScreenLowerBounds
	If(upperBounds == -1)
		upperBounds := ScreenUpperBounds

	centerXY := [ 830, 535 ]
	maxXY := [ 1640, 1050 ]
	increments := [ 20, 10 ]
	
	Loop {
		proximity := [ increments[1] * A_Index, increments[2] * A_Index ]

		If(centerXY[1] + proximity[1] > maxXY[1] Or centerXY[2] + proximity[2] > maxXY[2]) {
			Return { xy : [ 0, 0 ], rc : ErrorLevel }
		}

		PixelSearch, X, Y, centerXY[1] - proximity[1], centerXY[2] - proximity[2], centerXY[1] + proximity[1], centerXY[2] + proximity[2], pixelColor, shadeTolerance, Fast RGB
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
	If(actionType == "Neither" And CLICK_TYPE == "Neither") {
		Return True
	}

	MouseGetPos, X, Y
	pixelColor := actionType == "Walk" Or CLICK_TYPE == "Walk" ? 0xFFFF00 : 0xFF0000

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
	;Random, sleepFor, %lowerBound%, %upperBound%
	Return Rand(lowerBound, upperBound)
}

generateCoords(lowerBounds, upperBounds) {
	;Random, X, lowerBounds[1], upperBounds[1]
	;Random, Y, lowerBounds[2], upperBounds[2]
	Return [ Rand(lowerBounds[1], upperBounds[1]), Rand(lowerBounds[2], upperBounds[2]) ]
}

generateCoordsWithOffsets(lowerBounds, upperBounds, offsetRangeX, offsetRangeY) {
	Global XY := generateCoords(lowerBounds, upperBounds)
	;Random, OX, offsetRangeX[1], offsetRangeX[2]
	;Random, OY, offsetRangeY[1], offsetRangeY[2]
	Return [ XY[1] + Rand(offsetRangeX[1], offsetRangeX[2]), XY[2] + Rand(offsetRangeY[1], offsetRangeY[2]) ]
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
	clickRC := verifyClick(actionType)
	If(clickRC == True) {
		If(sleepFor == 0)
			sleepFor := generateSleepTime()
		Sleep, sleepFor
	}
	Return clickRC
}

moveMouseAndClick(clickCoords, mouseSpeedDivisor := 2.5, sleepFor := 0, actionType := "Neither", rightClick := False) {
	If(sleepFor == 0)
		sleepFor := generateSleepTime()
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

traceCoordsBounds(bounds) {
	Local lb1 := bounds.lowerBounds[1], Local lb2 := bounds.lowerBounds[2], Local ub1 := bounds.upperBounds[1], Local ub2 := bounds.upperBounds[2]
	Local Corners := [ [ lb1, lb2 ], [ ub1, lb2 ], [ ub1, ub2 ], [ lb1, ub2 ], [ lb1, lb2 ] ]

	For _, Element In Corners {
		;MsgBox % Element[1][1] ", " Element[2][1]
		MouseMove, Element[1], Element[2]
		Sleep, 500
	}
}

;SetFormat, IntegerFast, Hex