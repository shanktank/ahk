#Include _RandomBezier.ahk

#SingleInstance FORCE
;#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetTitleMatchMode, RegEx
SendMode, Input

#IfWinActive ^(RuneLite|OpenOSRS)$

; ================================================================================================================================================== ;
; == Classes ======================================================================================================================================= ;
; ================================================================================================================================================== ;

Class Thing {
	moveMouse(newCoords, optString := "") {
		RandomBezier(newCoords[1], newCoords[2], optString)
	}
	
	doClick(sleepFor := 0, numClicks := 1) {
		Loop, %numClicks% {
			Sleep, generateSleepTime(52, 163)
			Click
		}
		
		If(sleepFor == 0)
			sleepFor := generateSleepTime()
        Sleep, sleepFor
		
		Return This.checkClick()
	}
		
	checkClick() {
		MouseGetPos, X, Y
		PixelGetColor, pixelColor, X, Y, RGB
		
		Return pixelColor == This.RED
	}
	
	moveAndClick(clickCoords, optString := "", sleepFor := 0, numClicks := 1, attemptNo := 1) {
		If(sleepFor == 0)
			sleepFor := generateSleepTime()
		
		mouseSpeed := DecideSpeed(CalculateDistance(clickCoords))
		If(attemptNo > 1)
			mouseSpeed := mouseSpeed / 3
		optString := "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3"
		
		This.moveMouse(clickCoords, optString)
		This.doClick(sleepFor, numClicks)
    }
}

Class Mark Extends Thing {
	Static colour      := 0x0
	Static playRoomXY  := [ ]
	Static minOffsetXY := [ ]
	
	Static RED := 0xFF0000
	
	__New(c, pxy, mxy) {
		This.colour      := c
		This.playRoomXY  := pxy
		This.minOffsetXY := mxy
	}
	
	moveAndClick(optString := "", sleepFor := 0, numClicks := 1) {
		While(This.checkClick() == False) {
			If(A_Index > 10) {
				Return False
			}
		
			Sleep, generateSleepTime(184, 319)
			
			If(sleepFor == 0)
				sleepFor := generateSleepTime()
			Base.moveAndClick(This.generateCoords(), optString, sleepFor, numClicks, A_Index)
		}
		
		Return True
	}
				
	findPixel() {
		Loop, 5 {
			PixelSearch, X, Y, 0, 25, 1350, 850, This.colour, 25, RGB, Fast
			If(ErrorLevel == 0) {
				Return [ X, Y ]
			} Else {
				Sleep, 100
			}
		}
		
		SetFormat, IntegerFast, hex
		MsgBox % "Could not find pixel (" This.colour ")"
		Reload
	}
	
	generateCoords() {
		XY := This.findPixel()
		
		Random, X, XY[1] + This.playRoomXY[1], XY[1] + This.minOffsetXY[1]
		Random, Y, XY[2] + This.playRoomXY[2], XY[2] + This.minOffsetXY[2]
		
		Return [ X, Y ]
	}
}

Class Spot Extends Thing {
	Static colour  := 0x0
	Static fixedXY := [ ]
	
	__New(c, fxy) {
		This.colour  := c
		This.fixedXY := fxy
	}
	
	checkPixelColor() {
		PixelGetColor, pixelColor, This.fixedXY[1], This.fixedXY[2], RGB
		
		Return pixelColor == This.colour
	}
	
	waitForPixel(timeout := 10000, hoverNext := 0) {
		sleepFor := 100
		sleepNum := timeout / sleepFor
		
		Loop, %sleepNum% {
			Sleep, sleepFor
			
			If(This.checkPixelColor()) {
				Return True
			}
		}
		
		Return False
	}
}

Class Area Extends Thing {
	Static lowXY  := [ ]
	Static highXY := [ ]
	
	__New(lxy, hxy) {
		This.lowXY  := lxy
		This.highXY := hxy
	}
	
	generateCoords() {
		Random, X, This.lowXY[1], This.highXY[1]
		Random, Y, This.lowXY[2], This.highXY[2]
		
		Return [ X, Y ]
	}
}

Class Blast {
	Static marks := { }
	Static spots := { }
	Static areas := { }
	
	__New() {
		This.marks["blueMark"]   				:= New Mark(0x0000FF, [  25, 30 ], [  0, 0 ])
		This.marks["purpleMark"] 				:= New Mark(0xFF00FF, [ -15, 20 ], [  0, 1 ])
		This.marks["greenMark"]  				:= New Mark(0x00FF00, [ -20, 25 ], [ -2, 2 ])
		
		This.spots["inventoryOpen"]				:= New Spot(0x78281F, [ 1210, 1010 ])
		This.spots["stamPotionBuff1"]			:= New Spot(0xA37E4B, [ 1320,  108 ])
		This.spots["stamPotionBuff2"]			:= New Spot(0xE4733D, [ 1430,  200 ])
		This.spots["firstInvSlotEmpty"]			:= New Spot(0x3E3529, [ 1420,  680 ])
		This.spots["firstInvSlotAddyBars"]		:= New Spot(0x2A352A, [ 1420,  680 ])
		This.spots["firstInvSlotGoldBars"]		:= New Spot(0x745E0D, [ 1420,  680 ])
		This.spots["firstInvSlotIceGloves"]		:= New Spot(0x6BABBC, [ 1420,  680 ])
		This.spots["firstInvSlotGoldGloves"]	:= New Spot(0xBCAE6B, [ 1420,  680 ])
		This.spots["secondInvSlotEmpty"]		:= New Spot(0x3E3529, [ 1480,  680 ])
		This.spots["secondInvSlotStam"]			:= New Spot(0x977446, [ 1477,  692 ])
		This.spots["secondInvSlotStamEmpty"]	:= New Spot(0x6A6A6D, [ 1478,  692 ])
		This.spots["thirdInvSlotEmpty"]			:= New Spot(0x3E3529, [ 1540,  675 ])
		This.spots["thirdInvSlotGoldBar"]		:= New Spot(0xD8B01A, [ 1540,  675 ])
		This.spots["collectAddyBars"]			:= New Spot(0x405140, [  345,  935 ])
		This.spots["collectGoldBars"]			:= New Spot(0xB19015, [  345,  935 ])
		This.spots["bankOpenCheck1"]			:= New Spot(0x831F1D, [  800,  800 ])
		This.spots["bankOpenCheck2"]			:= New Spot(0x52524D, [  800,  800 ])
		This.spots["goldOresExhustedCheck"]		:= New Spot(0x937A25, [  707,  343 ])
		This.spots["moltenBarsCheck"]			:= New Spot(0x0A0907, [  105,  905 ])
		This.spots["noBarsCheck"]				:= New Spot(0x0B0A08, [  175,  905 ])
		
		This.areas["depositAllBounds"]			:= New Area([  902, 779 ], [  939, 815 ])
		This.areas["withdrawAddyOreBounds"]		:= New Area([  561, 326 ], [  593, 356 ])
		This.areas["withdrawCoalBounds"]		:= New Area([  625, 326 ], [  657, 357 ])
		This.areas["withdrawGoldOreBounds"]		:= New Area([  689, 328 ], [  719, 360 ])
		This.areas["withdrawStamBounds"]		:= New Area([  757, 330 ], [  776, 357 ])
		This.areas["equipGlovesBounds"]			:= New Area([ 1410, 664 ], [ 1435, 689 ])
		This.areas["drinkStamBounds"]			:= New Area([ 1463, 665 ], [ 1486, 691 ])
		This.areas["thirdInvSlotBounds"]		:= New Area([ 1518, 664 ], [ 1548, 689 ])
		This.areas["purpleHoverBounds"]			:= New Area([  680, 630 ], [  860, 810 ])
	}
}

; ================================================================================================================================================== ;
; == Functions ===================================================================================================================================== ;
; ================================================================================================================================================== ;

generateSleepTime(lowerBound := 109, upperBound := 214) {
	Random, sleepFor, %lowerBound%, %upperBound%
	
	Return sleepFor
}

earlyMouseMove(thing) {
	newCoords  := thing.generateCoords()
	mouseSpeed := DecideSpeed(CalculateDistance(newCoords))
	optString  := "T"(mouseSpeed)" OT38 OB40 OL40 OR39 P2-3"
	
	thing.moveMouse(newCoords, optString)
}

drinkStam() {
	If(b.spots["stamPotionBuff1"].checkPixelColor() == False && b.spots["stamPotionBuff2"].checkPixelColor() == False) {
		Thing.moveAndClick(b.areas["drinkStamBounds"].generateCoords(),, generateSleepTime())
	}
}

equipGloves(gloves, alreadyThere := False) {
	; If the gloves we want to equip are already equipped (e.g. not in the inventory), return without doing anything.
	If((gloves == "gold" && !b.spots["firstInvSlotGoldGloves"].checkPixelColor()) Or (gloves == "ice" && !b.spots["firstInvSlotIceGloves"].checkPixelColor())) {
		Return
	}

	; If the cursor is already where we need to click, simply click. Otherwise, move and click.
	If(alreadyThere == True) {
		If(Thing.doClick(generateSleepTime()) == False) {
			Thing.moveAndClick(b.areas["equipGlovesBounds"].generateCoords(),, generateSleepTime())
		}
	} Else {
		Thing.moveAndClick(b.areas["equipGlovesBounds"].generateCoords(),, generateSleepTime())
	}
	
	Sleep, generateSleepTime()
}

putOres() {
	equipGloves("gold")
	b.marks["blueMark"].moveAndClick()
	Sleep, generateSleepTime(212, 419)
	earlyMouseMove(b.areas["purpleHoverBounds"])
	
	If(b.spots["thirdInvSlotEmpty"].waitForPixel() == False) {
		MsgBox % "Either we're out of money or something fucked up"
		Reload
	}
}

takeBars() {
	b.marks["purpleMark"].moveAndClick()
	earlyMouseMove(b.areas["equipGlovesBounds"])
	Sleep, generateSleepTime(1987, 2163)
	
	Loop, 5 {
		; Check if bars have not yet been smelted
		If(b.spots["noBarsCheck"].checkPixelColor(250)) {
			b.marks["purpleMark"].moveAndClick()
			earlyMouseMove(b.areas["equipGlovesBounds"])
			Sleep generateSleepTime(319, 445)
		}
		; Check if the bars are molten and require Ice Gloves
		If(b.spots["moltenBarsCheck"].checkPixelColor()) {
			equipGloves("ice", (A_Index < 2))
			b.marks["purpleMark"].moveAndClick()
			If(b.spots["collectGoldBars"].waitForPixel(1000)) {
				Send, 1
				earlyMouseMove(b.marks["greenMark"])
				b.spots["thirdInvSlotGoldBar"].waitForPixel()
				Return True
			}
		}
		; Check if the bars are cooled down before we even got to them
		If(b.spots["collectGoldBars"].waitForPixel(250)) {
			Send, 1
			earlyMouseMove(b.marks["greenMark"])
			b.spots["thirdInvSlotGoldBar"].waitForPixel()
			Return True
		}
	}
	
	MsgBox % "Unable to take bars"
	Reload
}

openBank() {
	If(b.marks["greenMark"].doClick() == False) {
		b.marks["greenMark"].moveAndClick()
	}
	
	; Wait ~5 seconds for first attempt to open bank, since it's a bit of a run
	If(b.spots["bankOpenCheck1"].waitForPixel(generateSleepTime(4880, 5212)) Or b.spots["bankOpenCheck2"].checkPixelColor()) {
		Return True
	} Else {
		; We should at least be near the bank by now, so subsequent attempts are afforded less time
		Loop, 3 {
			b.marks["greenMark"].moveAndClick()
			If(b.spots["bankOpenCheck"].waitForPixel(generateSleepTime(879, 1214)) Or b.spots["bankOpenCheck2"].checkPixelColor()) {
				Return True
			}
		}
	}
	
	MsgBox % "Unable to open bank."
	Reload
}

useBank() {
	; Check to see if we're out of ore
	If(b.spots["goldOresExhustedCheck"].checkPixelColor()) {
		Thing.moveAndClick(b.areas["depositAllBounds"].generateCoords(),, generateSleepTime())
		
		MsgBox % "No more ore. Looks like we're done!"
		Reload
	}

	; Deposit bars, withdraw ore
	Thing.moveAndClick(b.areas["thirdInvSlotBounds"].generateCoords(),, generateSleepTime())
	Thing.moveAndClick(b.areas["withdrawGoldOreBounds"].generateCoords(),, generateSleepTime())
	
	; Deposit empty vial, withdraw potion
	If(b.spots["secondInvSlotStamEmpty"].checkPixelColor()) {
		Thing.moveAndClick(b.areas["drinkStamBounds"].generateCoords(),, generateSleepTime())
		Thing.moveAndClick(b.areas["withdrawStamBounds"].generateCoords(),, generateSleepTime())
	}
}

closeBank() {
	Send, {Esc}
	Sleep, generateSleepTime(124, 241)
	
	; Check to see if we somehow closed the inventory while exiting bank
	If(b.spots["inventoryOpen"].checkPixelColor() == False) {
		Send, {Esc}
		Sleep, generateSleepTime()
	}
}

blastGold() {
	Loop {
		drinkStam()
		putOres()
		takeBars()
		openBank()
		useBank()
		closeBank()
	}
}

; ================================================================================================================================================== ;
; == Globals ======================================================================================================================================= ;
; ================================================================================================================================================== ;

Global b := New Blast()

; ================================================================================================================================================== ;
; == HotKeys ======================================================================================================================================= ;
; ================================================================================================================================================== ;

F1::
	blastGold()
	Return

F4::
	PixelSearch, XXX, YYY, 0, 25, 1350, 850, 0x0000FF, 25, RGB, Fast
	ToolTip, Blue, %XXX%, %YYY%
	Sleep, 1000
	PixelSearch, XXX, YYY, 0, 25, 1350, 850, 0xFF00FF, 25, RGB, Fast
	ToolTip, Purple, %XXX%, %YYY%
	Sleep, 1000
	PixelSearch, XXX, YYY, 0, 25, 1350, 850, 0x00FF00, 25, RGB, Fast
	ToolTip, Green, %XXX%, %YYY%
	Return

; ================================================================================================================================================== ;
; == Controls ====================================================================================================================================== ;
; ================================================================================================================================================== ;

^R::Reload
+^C::ExitApp
