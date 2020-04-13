#Include _RandomBezier.ahk

#SingleInstance FORCE
;#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

Class Thing {
	Static name := ""
	
	__New(n, w) {
		This.name := n
	}
	
	moveMouse(clickCoords, optString := "", simpleMove := False) {
		If(simpleMove == False) {
			RandomBezier(clickCoords[1], clickCoords[2], optString)
		} Else {
			Random, moveSpeed, 5, 15
			MouseMove, clickCoords[1], clickCoords[2], moveSpeed
		}
	}
	
	doClick(sleepFor := 200, numClicks := 1, rightClick := False) {
		If(rightClick == True) {
			Click, Right
		} Else {
			Loop %numClicks% {
				Random, preClick, 52, 163
				Sleep, preClick
				Click
			}
		}
        Sleep, sleepFor
	}
	
	moveAndClick(clickCoords, optString := "", simpleMove := False, sleepFor := 100, numClicks := 1, rightClick := False) {
		speed := DecideSpeed(CalculateDistance(clickCoords[1], clickCoords[2]))
		optString := "T"(speed)" OT38 OB40 OL40 OR39 P2-4"
		This.moveMouse(clickCoords, optString, simpleMove)
		This.doClick(sleepFor, numClicks, rightClick)
    }
}

Class Tile Extends Thing {
	Static colour      := 0x0
	Static playRoomXY  := [ ]
	Static minOffsetXY := [ ]
	
	__New(n, c, pxy, mxy) {
		Base.__New(n)
		This.colour      := c
		This.playRoomXY  := pxy
		This.minOffsetXY := mxy
	}
	
	moveAndClick(optString := "", simpleMove := False, sleepFor := 100, numClicks := 1, rightClick := False) {
		While(This.checkClick() == False) {
			If(A_Index > 25)
				Return False
			Sleep, generateRandomSleep(184, 319)
			coords := This.generateCoords()
			speed := DecideSpeed(CalculateDistance(coords[1], coords[2]))
			If(A_Index >= 2)
				speed := speed / 2
			optString := "T"(speed)" OT38 OB40 OL40 OR39 P2-4"
			Base.moveMouse(coords, optString, simpleMove)
			Base.doClick(sleepFor, numClicks, rightClick)
		}
		Return True
	}
	
	checkClick() {
		MouseGetPos, x, y
		PixelGetColor, pixelColor, x, y, RGB
		Return pixelColor == 0xFF0000
	}
				
	findPixel() {
		PixelSearch, x, y, 0, 25, 1350, 850, This.colour, 20, RGB, Fast
		Return [ x, y ]
	}
	
	generateCoords() {
		xy := This.findPixel()
		Random, x, xy[1] + This.playRoomXY[1], xy[1] + This.minOffsetXY[1]
		Random, y, xy[2] + This.playRoomXY[2], xy[2] + This.minOffsetXY[2]
		Return [ x, y ]
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
	
	checkColor() {
		PixelGetColor, pixelColor, This.fixedXY[1], This.fixedXY[2], RGB
		Return pixelColor == This.colour
	}
	
	waitForPixel(timeout := 10000) {
		sleepFor := 100
		sleepNum := timeout / sleepFor
		Loop, %sleepNum% {
			Sleep, sleepFor
			If(This.checkColor()) {
				;MsgBox % "Found the fucking pixel"
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
		Random, x, This.lowXY[1], This.highXY[1]
		Random, y, This.lowXY[2], This.highXY[2]
		Return [ x, y ]
	}
}

Class Blast {
	Static tiles := { }
	Static spots := { }
	Static areas := { }
	
	Static emptyInvSlot := 0x3E3529
	
	Static invSlot1 := [ 1420, 680 ]
	Static invSlot2 := [ 1477, 692 ]
	Static invSlot3 := [ 1540, 675 ]
	
	__New() {
		This.tiles["blueTile"]   				:= New Tile("blueTile",   0x0000FF, [  25, 30 ], [  0, 0 ])
		This.tiles["purpleTile"] 				:= New Tile("purpleTile", 0xFF00FF, [ -15, 20 ], [  0, 1 ])
		This.tiles["greenTile"]  				:= New Tile("greenTile",  0x00FF00, [ -20, 25 ], [ -2, 2 ])
		
		This.spots["inventoryOpen"]				:= New Spot("inventoryOpen",          0x78281F, [ 1210, 1010 ])
		This.spots["firstInvSlotEmpty"]			:= New Spot("firstInvSlotEmpty",      This.emptyInvSlot, This.invSlot1)
		This.spots["firstInvSlotAddyBars"]		:= New Spot("firstInvSlotAddyBars",   0x2A352A, This.invSlot1)
		This.spots["firstInvSlotGoldBars"]		:= New Spot("firstInvSlotGoldBars",   0x745E0D, This.invSlot1) ; ???
		This.spots["firstInvSlotIceGloves"]		:= New Spot("firstInvSlotIceGloves",  0x6BABBC, This.invSlot1)
		This.spots["firstInvSlotGoldGloves"]	:= New Spot("firstInvSlotGoldGloves", 0xBCAE6B, This.invSlot1)
		This.spots["secondInvSlotEmpty"]		:= New Spot("secondInvSlotEmpty",     This.emptyInvSlot, This.invSlot2)
		This.spots["stamPotEmpty"]				:= New Spot("stamPotEmpty",           0x6E6E70, This.invSlot2)
		This.spots["secondInvSlotStam"]			:= New Spot("secondInvSlotStam",      0x977446, This.invSlot2) ; 3-dose color: 0x987446
		This.spots["thirdInvSlotGoldBar"]		:= New Spot("thirdInvSlotGoldBar",    0xD8B01A, This.invSlot3)
		This.spots["thirdInvSlotEmpty"]			:= New Spot("thirdInvSlotEmpty",      This.emptyInvSlot, This.invSlot3)
		This.spots["takeAddyBars"]				:= New Spot("takeAddyBars",           0x405140, [  345, 935 ])
		This.spots["takeGoldBars"]				:= New Spot("takeGoldBars",           0xB19015, [  345, 935 ])
		This.spots["bankOpenCheck"]				:= New Spot("bankOpenCheck",          0x831F1D, [  800, 800 ])
		This.spots["stamPotionBuff"]			:= New Spot("stamPotionBuff",         0xA37E4B, [ 1320, 108 ])

		This.areas["depositAllBounds"]			:= New Area("depositAllBounds",      [  902, 779 ], [  939, 815 ])
		This.areas["withdrawAddyOreBounds"]		:= New Area("withdrawAddyOreBounds", [  561, 326 ], [  593, 356 ])
		This.areas["withdrawCoalBounds"]		:= New Area("withdrawCoalBounds",    [  625, 326 ], [  657, 357 ])
		This.areas["withdrawGoldOreBounds"]		:= New Area("withdrawGoldOreBounds", [  689, 328 ], [  719, 360 ])
		This.areas["withdrawStamBounds"]		:= New Area("withdrawStamBounds",    [  757, 330 ], [  776, 357 ])
		This.areas["equipGlovesBounds"]			:= New Area("equipGlovesBounds",     [ 1410, 664 ], [ 1435, 689 ])
		This.areas["drinkStamBounds"]			:= New Area("drinkStamBounds",       [ 1463, 665 ], [ 1486, 691 ])
		This.areas["thirdInvSlot"]				:= New Area("thirdInvSlot",          [ 1518, 664 ], [ 1548, 689 ])
	}
}

blastAddy() {
	b.tiles["blueTile"].moveAndClick()
	b.spots["firstInvSlotEmpty"].waitForPixel()
	
	b.tiles["purpleTile"].moveAndClick()
	b.spots["takeAddyBars"].waitForPixel()
	Send, 1
	b.spots["firstInvSlotAddyBars"].waitForPixel()
	
	b.tiles["greenTile"].moveAndClick()
	b.spots["bankOpenCheck"].waitForPixel()
	Thing.moveAndClick(b.areas["depositAllBounds"].generateCoords())
	Thing.moveAndClick(b.areas["withdrawAddyOreBounds"].generateCoords())
	Thing.moveAndClick(b.areas["withdrawCoalBounds"].generateCoords(), "", True, 150, 3)
	Send, {Esc}
	Sleep, 375
}

generateRandomSleep(lowerBound := 109, upperBound := 214) {
	Random, sleepFor, %lowerBound%, %upperBound%
	Return sleepFor
}

equipGloves(gloves) {
	If(gloves == "gold") {
		If(b.spots["firstInvSlotGoldGloves"].checkColor()) {
			Thing.moveAndClick(b.areas["equipGlovesBounds"].generateCoords(),,, generateRandomSleep())
		}
	} Else If(gloves == "ice") {
		If(b.spots["firstInvSlotIceGloves"].checkColor()) {
			Thing.moveAndClick(b.areas["equipGlovesBounds"].generateCoords(),,, generateRandomSleep())
		}
	}
}

drinkStam() {
	If(b.spots["stamPotionBuff"].checkColor() == False) {
		Thing.moveAndClick(b.areas["drinkStamBounds"].generateCoords(),,, generateRandomSleep())
	}
}

putOres() {
	equipGloves("gold")
	b.tiles["blueTile"].moveAndClick()
	b.spots["thirdInvSlotEmpty"].waitForPixel()
	;MsgBox % "Done in putOres"
}

takeBars() {
	;MsgBox % "Starting takeBars"
	;b.tiles["purpleTile"].moveAndClick(,, generateRandomSleep(3720, 3967))
	b.tiles["purpleTile"].moveAndClick()
	Sleep, generateRandomSleep(2500, 3000)
	;MsgBox % "Done with moveandClick?"
	
	Loop, 5 {
		If(b.spots["takeGoldBars"].waitForPixel(1000) == False) {
			equipGloves("ice")
			;b.tiles["purpleTile"].moveAndClick(,, generateRandomSleep(717, 789))
			;b.tiles["purpleTile"].moveAndClick(,, generateRandomSleep(250, 350))
			b.tiles["purpleTile"].moveAndClick()
			Sleep, generateRandomSleep(319, 445)
			Continue
		}
		
		Send, 1
		b.spots["thirdInvSlotGoldBar"].waitForPixel()
		
		Return True
	}
	
	MsgBox % "Unable to take bars"
	Reload
}

openBank() {
	Loop, 3 {
		b.tiles["greenTile"].moveAndClick()
		If(b.spots["bankOpenCheck"].waitForPixel(generateRandomSleep(4880, 5212))) {
			;MsgBox % "Bank is open"
			Return True
		}
	}
	
	MsgBox % "Unable to open bank"
	Reload
}

useBank() {
	;MsgBox % "useBank"
	Thing.moveAndClick(b.areas["thirdInvSlot"].generateCoords(),,, generateRandomSleep())
	Thing.moveAndClick(b.areas["withdrawGoldOreBounds"].generateCoords(),,, generateRandomSleep())
	
	If(b.spots["stamPotEmpty"].checkColor()) {
		Thing.moveAndClick(b.areas["drinkStamBounds"].generateCoords(),,, generateRandomSleep())
		Thing.moveAndClick(b.areas["withdrawStamBounds"].generateCoords(),,, generateRandomSleep())
	}
}

closeBank() {
	Send, {Esc}
	Sleep, generateRandomSleep(362, 444)
	
	If(b.spots["inventoryOpen"].checkColor() == False) {
		Send, {Esc}
		Sleep, generateRandomSleep()
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

Global b := New Blast()

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

#If
^R::Reload
+^C::ExitApp
