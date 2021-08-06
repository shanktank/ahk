#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance FORCE
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

;; ================================================================================================================================================== ;;
;; == Classes ======================================================================================================================================= ;;
;; ================================================================================================================================================== ;;

Class Blast {
	Static marks := { }
	Static spots := { }
	Static areas := { }

	__New() {
		This.marks["blueMark"]   				:= New TileMarkerBounds(BLUE,   [   5, 0 ], [ 10, 5 ], 10)
		This.marks["purpleMark"] 				:= New TileMarkerBounds(PURPLE, [ -22, 3 ], [ -4, 13 ], 25)
		This.marks["greenMark"]  				:= New TileMarkerBounds(GREEN,  [ -20, 6 ], [ -14, 11 ], 10)

		This.spots["stamPotionBuff"]			:= New PixelColorLocation(0xA27E4B, [ 1320,  108 ])
		This.spots["firstInvSlotEmpty"]			:= New PixelColorLocation(0x3E3529, [ 1420,  680 ])
		This.spots["firstInvSlotIceGloves"]		:= New PixelColorLocation(0x6BAABC, [ 1420,  680 ])
		This.spots["firstInvSlotGoldGloves"]	:= New PixelColorLocation(0xBCAD6B, [ 1420,  680 ])
		This.spots["secondInvSlotEmpty"]		:= New PixelColorLocation(0x3E3529, [ 1480,  680 ])
		This.spots["secondInvSlotStam"]			:= New PixelColorLocation(0x977446, [ 1477,  692 ])
		This.spots["secondInvSlotStamEmpty"]	:= New PixelColorLocation(0x6A6A6D, [ 1478,  692 ])
		This.spots["thirdInvSlotEmpty"]			:= New PixelColorLocation(0x3E3529, [ 1540,  675 ])
		This.spots["thirdInvSlotGoldBar"]		:= New PixelColorLocation(0xD8B01A, [ 1540,  675 ])
		This.spots["collectGoldBars"]			:= New PixelColorLocation(0xB19015, [  345,  935 ])
		This.spots["goldOresExhustedCheck"]		:= New PixelColorLocation(0x937A25, [  707,  343 ])
		This.spots["goldBarsReady"]				:= New PixelColorLocation(0xD8B01A, [   40,   75 ])

		This.areas["purpleHoverBounds"]			:= New ClickAreaBounds([ 680, 630 ], [ 860, 810 ])
	}
}

;; ================================================================================================================================================== ;;
;; == Functions ===================================================================================================================================== ;;
;; ================================================================================================================================================== ;;

drinkStam() {
	If(b.spots["stamPotionBuff"].verifyPixelColor() == False) {
		InvSlot2Bounds.moveMouseAndClick()
	}
}

equipGloves(gloves) {
	If(gloves == "gold") {
		If(b.spots["firstInvSlotGoldGloves"].verifyPixelColor()) {
			InvSlot1Bounds.moveMouseAndClick()
		}
	} Else If(gloves == "ice") {
		If(b.spots["firstInvSlotIceGloves"].verifyPixelColor()) {
			InvSlot1Bounds.moveMouseAndClick()
		}
	}
}

putOres() {
	;;equipGloves("gold")
	b.marks["blueMark"].moveMouseAndClick(, generateSleepTime(212, 419))
	b.areas["purpleHoverBounds"].moveMouse()
	If(b.spots["thirdInvSlotEmpty"].waitForPixelToBeColor(10000) == False) {
		MsgBox % "Either we're out of money or something fucked up"
		Reload
	}
}

takeBars() {
	b.marks["purpleMark"].moveMouseAndClick()
	;;InvSlot1Bounds.moveMouse()
	equipGloves("gold")
	;;b.areas["purpleHoverBounds"].moveMouse()
	Sleep, generateSleepTime(1599, 1863)

	/*
	While(b.spots["goldBarsReady"].waitForPixelToBeColor(generateSleepTime(373, 541)) == False) {
		If(A_Index > 5) {
			MsgBox % "Unable to take bars (1)"
			Reload
		}
		b.marks["purpleMark"].moveMouseAndClick(, generateSleepTime(219, 345))
	}
	*/
	b.spots["goldBarsReady"].waitForPixelToBeColor()
	
	equipGloves("ice")
	b.marks["purpleMark"].moveMouse()
	Sleep, generateSleepTime(213, 377)
	b.marks["purpleMark"].moveMouseAndClick(, generateSleepTime(159, 245))
	
	
	While(b.spots["thirdInvSlotGoldBar"].waitForPixelToBeColor(generateSleepTime(273, 341)) == False) {
		If(A_Index > 5) {
			MsgBox % "Unable to take bars (2)"
			Reload
		}
		UIObject.inputKeyAndSleep("{Space}")
	}
}

openBank() {
	b.marks["greenMark"].moveMouseAndClick()
	If(BankOpenCheck.waitForPixelToBeColor(generateSleepTime(4883, 5276))) {
		Return True
	} Else {
		Loop, 3 {
			b.marks["greenMark"].moveMouseAndClick()
			If(BankOpenCheck.waitForPixelToBeColor(generateSleepTime(817, 1142))) {
				Return True
			}
		}
	}

	MsgBox % "Unable to open bank"
	Reload
}

useBank() {
	If(b.spots["goldOresExhustedCheck"].verifyPixelColor()) {
		;;b.areas["depositAllBounds"].moveMouseAndClick()
		MsgBox % "No more gold ore. Looks like we're done!"
		Reload
	}

	InvSlot3Bounds.moveMouseAndClick()
	BankSlot1Bounds.moveMouseAndClick()

	If(b.spots["secondInvSlotStamEmpty"].verifyPixelColor()) {
		InvSlot2Bounds.moveMouseAndClick()
		BankSlot2Bounds.moveMouseAndClick()
	}
}

closeBank() {
	UIObject.inputKeyAndSleep("{Esc}", generateSleepTime(224, 341))
	UIObject.verifyInvIsOpen()
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

F1::blastGold()
F2::
	GXY := b.marks["blueMark"].findPixelByColor()["xy"]
	ToolTip % "Blue", GXY[1], GXY[2]
	Sleep, 1000
	GXY := b.marks["purpleMark"].findPixelByColor()["xy"]
	ToolTip % "Purple", GXY[1], GXY[2]
	Sleep, 1000
	GXY := b.marks["greenMark"].findPixelByColor()["xy"]
	ToolTip % "Green", GXY[1], GXY[2]
	Sleep, 1000
	ToolTip
	Return

; ================================================================================================================================================== ;
; == Controls ====================================================================================================================================== ;
; ================================================================================================================================================== ;

#If
^R::Reload
+^C::ExitApp
