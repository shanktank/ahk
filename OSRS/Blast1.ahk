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
	Static name := ""
	
	__New(n, w) {
		This.name := n
	}
	
	moveMouse(newCoords, optString := "") {
		RandomBezier(newCoords[1], newCoords[2], optString)
	}
	
	doClick(sleepFor := 200, numClicks := 1) {
		Loop, %numClicks% {
			Sleep, generateSleepTime(52, 163)
			Click
		}
        Sleep, sleepFor
	}
	
	moveAndClick(clickCoords, optString := "", sleepFor := 100, numClicks := 1, attemptNo := 1) {
		mouseSpeed := DecideSpeed(CalculateDistance(clickCoords))
		If(attemptNo > 1)
			mouseSpeed := mouseSpeed / 2
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
	
	__New(n, c, pxy, mxy) {
		Base.__New(n)
		This.colour      := c
		This.playRoomXY  := pxy
		This.minOffsetXY := mxy
	}
	
	moveAndClick(optString := "", sleepFor := 100, numClicks := 1) {
		While(This.checkClick() == False) {
			Sleep, generateSleepTime(184, 319)
			Base.moveAndClick(This.generateCoords(), optString, sleepFor, numClicks, A_Index)
			If(A_Index > 10)
				Return False
		}
		Return True
	}
	
	checkClick() {
		MouseGetPos, X, Y
		PixelGetColor, pixelColor, X, Y, RGB
		Return pixelColor == This.RED
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
	
	__New(n, c, fxy) {
		Base.__New(n)
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
	
	__New(n, lxy, hxy) {
		Base.__New(n)
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
		This.marks["blueMark"]   				:= New Mark("blueMark",   0x0000FF, [  25, 30 ], [  0, 0 ])
		This.marks["purpleMark"] 				:= New Mark("purpleMark", 0xFF00FF, [ -15, 20 ], [  0, 1 ])
		This.marks["greenMark"]  				:= New Mark("greenMark",  0x00FF00, [ -20, 25 ], [ -2, 2 ])
		
		This.spots["inventoryOpen"]				:= New Spot("inventoryOpen",          0x78281F, [ 1210, 1010 ])
		This.spots["stamPotionBuff"]			:= New Spot("stamPotionBuff",         0xA37E4B, [ 1320,  108 ])
		This.spots["firstInvSlotEmpty"]			:= New Spot("firstInvSlotEmpty",      0x3E3529, [ 1420,  680 ])
		This.spots["firstInvSlotAddyBars"]		:= New Spot("firstInvSlotAddyBars",   0x2A352A, [ 1420,  680 ])
		This.spots["firstInvSlotGoldBars"]		:= New Spot("firstInvSlotGoldBars",   0x745E0D, [ 1420,  680 ])
		This.spots["firstInvSlotIceGloves"]		:= New Spot("firstInvSlotIceGloves",  0x6BABBC, [ 1420,  680 ])
		This.spots["firstInvSlotGoldGloves"]	:= New Spot("firstInvSlotGoldGloves", 0xBCAE6B, [ 1420,  680 ])
		This.spots["secondInvSlotEmpty"]		:= New Spot("secondInvSlotEmpty",     0x3E3529, [ 1480,  680 ])
		This.spots["secondInvSlotStam"]			:= New Spot("secondInvSlotStam",      0x977446, [ 1477,  692 ])
		This.spots["secondInvSlotStamEmpty"]	:= New Spot("secondInvSlotStamEmpty", 0x6A6A6D, [ 1478,  692 ])
		This.spots["thirdInvSlotEmpty"]			:= New Spot("thirdInvSlotEmpty",      0x3E3529, [ 1540,  675 ])
		This.spots["thirdInvSlotGoldBar"]		:= New Spot("thirdInvSlotGoldBar",    0xD8B01A, [ 1540,  675 ])
		This.spots["collectAddyBars"]			:= New Spot("collectAddyBars",        0x405140, [  345,  935 ])
		This.spots["collectGoldBars"]			:= New Spot("collectGoldBars",        0xB19015, [  345,  935 ])
		This.spots["bankOpenCheck1"]			:= New Spot("bankOpenCheck1",         0x831F1D, [  800,  800 ])
		This.spots["bankOpenCheck2"]			:= New Spot("bankOpenCheck2",         0x52524D, [  800,  800 ])
		This.spots["goldOresExhustedCheck"]		:= New Spot("goldOresExhustedCheck",  0x937A25, [  707,  343 ])

		This.areas["depositAllBounds"]			:= New Area("depositAllBounds",      [  902, 779 ], [  939, 815 ])
		This.areas["withdrawAddyOreBounds"]		:= New Area("withdrawAddyOreBounds", [  561, 326 ], [  593, 356 ])
		This.areas["withdrawCoalBounds"]		:= New Area("withdrawCoalBounds",    [  625, 326 ], [  657, 357 ])
		This.areas["withdrawGoldOreBounds"]		:= New Area("withdrawGoldOreBounds", [  689, 328 ], [  719, 360 ])
		This.areas["withdrawStamBounds"]		:= New Area("withdrawStamBounds",    [  757, 330 ], [  776, 357 ])
		This.areas["equipGlovesBounds"]			:= New Area("equipGlovesBounds",     [ 1410, 664 ], [ 1435, 689 ])
		This.areas["drinkStamBounds"]			:= New Area("drinkStamBounds",       [ 1463, 665 ], [ 1486, 691 ])
		This.areas["thirdInvSlotBounds"]		:= New Area("thirdInvSlotBounds",    [ 1518, 664 ], [ 1548, 689 ])
		This.areas["purpleHoverBounds"]			:= New Area("purpleHoverBounds",     [  680, 630 ], [  860, 810 ])
		This.areas["greenHoverBounds"]			:= New Area("greenHoverBounds",      [  ], [  ])
	}
}

; ================================================================================================================================================== ;
; == Functions ===================================================================================================================================== ;
; ================================================================================================================================================== ;

generateSleepTime(lowerBound := 109, upperBound := 214) {
	Random, sleepFor, %lowerBound%, %upperBound%
	
	Return sleepFor
}

hoverThing(area) {
	newCoords  := area.generateCoords()
	mouseSpeed := DecideSpeed(CalculateDistance(newCoords))
	optString  := "T"(mouseSpeed)(optStringSuffix)
	
	area.moveMouse(newCoords, optString)
}

drinkStam() {
	If(b.spots["stamPotionBuff"].checkPixelColor() == False) {
		Thing.moveAndClick(b.areas["drinkStamBounds"].generateCoords(),, generateSleepTime())
	}
}

equipGloves(gloves) {
	If(gloves == "gold") {
		If(b.spots["firstInvSlotGoldGloves"].checkPixelColor()) {
			Thing.moveAndClick(b.areas["equipGlovesBounds"].generateCoords(),, generateSleepTime())
		}
	} Else If(gloves == "ice") {
		If(b.spots["firstInvSlotIceGloves"].checkPixelColor()) {
			Thing.moveAndClick(b.areas["equipGlovesBounds"].generateCoords(),, generateSleepTime())
		}
	}
}

putOres() {
	equipGloves("gold")
	b.marks["blueMark"].moveAndClick()
	Sleep, generateSleepTime(212, 419)
	hoverThing(b.areas["purpleHoverBounds"])
	If(b.spots["thirdInvSlotEmpty"].waitForPixel() == False) {
		MsgBox % "Either we're out of money or something fucked up"
		Reload	
	}
}

takeBars() {
	b.marks["purpleMark"].moveAndClick()
	Sleep, generateSleepTime(1987, 2263)
	
	Loop, 5 {
		If(b.spots["collectGoldBars"].waitForPixel(1000) == False) {
			equipGloves("ice")
			b.marks["purpleMark"].moveAndClick()
			Sleep, generateSleepTime(319, 445)
		} Else {
			Send, 1
			hoverThing(b.marks["greenMark"])
			b.spots["thirdInvSlotGoldBar"].waitForPixel()
			Return True
		}
	}
	
	MsgBox % "Unable to take bars"
	Reload
}

openBank() {
	b.marks["greenMark"].moveAndClick()
	If(b.spots["bankOpenCheck1"].waitForPixel(generateSleepTime(4880, 5212)) Or b.spots["bankOpenCheck2"].checkPixelColor()) {
		Return True
	} Else {
		Loop, 3 {
			b.marks["greenMark"].moveAndClick()
			If(b.spots["bankOpenCheck"].waitForPixel(generateSleepTime(879, 1214)) Or b.spots["bankOpenCheck2"].checkPixelColor()) {
				Return True
			}
		}
	}
	
	MsgBox % "Unable to open bank"
	Reload
}

useBank() {
	If(b.spots["goldOresExhustedCheck"].checkPixelColor()) {
		Thing.moveAndClick(b.areas["depositAllBounds"].generateCoords(),, generateSleepTime())
		MsgBox % "No more gold ore. Looks like we're done!"
		Reload
	}

	Thing.moveAndClick(b.areas["thirdInvSlotBounds"].generateCoords(),, generateSleepTime())
	Thing.moveAndClick(b.areas["withdrawGoldOreBounds"].generateCoords(),, generateSleepTime())
	
	If(b.spots["secondInvSlotStamEmpty"].checkPixelColor()) {
		Thing.moveAndClick(b.areas["drinkStamBounds"].generateCoords(),, generateSleepTime())
		Thing.moveAndClick(b.areas["withdrawStamBounds"].generateCoords(),, generateSleepTime())
	}
}

closeBank() {
	Send, {Esc}
	Sleep, generateSleepTime(124, 241)
	
	If(b.spots["inventoryOpen"].checkPixelColor() == False) {
		Send, {Esc}
		Sleep, generateSleepTime()
	}
}

blastGold() {
	Loop {
		;drinkStam()
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

Global optStringSuffix := " OT38 OB40 OL40 OR39 P2-3"
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

#If
^R::Reload
+^C::ExitApp
