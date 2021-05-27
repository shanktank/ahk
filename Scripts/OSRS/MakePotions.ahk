#Include %A_MyDocuments%/Git/ahk/Libraries/OSRS.ahk

#SingleInstance Force
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

;;=================================================================================================;;

Global iritPot_P				:= New PixelColorLocation(0xA8A8AF, [  449, 157 ])
Global ranarrPot_P				:= New PixelColorLocation(0x8AA88B, [  450, 350 ])
Global eyeOfNewt_P				:= New PixelColorLocation(0xD0CACA, [  511, 150 ])
Global snapeGrass				:= New PixelColorLocation(0x0D874E, [  510, 345 ])
Global verifyItems_P			:= New PixelColorLocation(0xD8D3D3, [ 1530, 821 ])
Global makeSupAtkPrompt_P		:= New PixelColorLocation(0x5C5DE1, [  335, 961 ])
Global makePrayerPrompt_P		:= New PixelColorLocation(0x5CE5B1, [  340, 970 ])
Global slot01Amulet				:= New PixelColorLocation(0x72A64D, [ 1415, 690 ])
Global slotViewer28SnapeGrass	:= New PixelColorLocation(0x0D874E, [ 1603, 608 ])

Global eyeOfNewt_T				:= New TileMarkerBounds([ 503, 158 ], [ 521, 137 ])
Global iritPot_T				:= New TileMarkerBounds([ 439, 165 ], [ 460, 131 ])

Global bankerBounds_B			:= New ClickAreaBounds([ 840, 338 ], [ 904, 197 ])

;;=================================================================================================;;

; ToDO:
;  Functions checkAmulet and getAmulet copied as placeholders and require reworks.
;  Functions doHerblore and doBank require modifications to handle arbitrary potions.
;  Functionality to detect amulet depleted should/needs to be reintroduced.

; ToDO: Placeholder. Rework.
checkAmulet() {
	/*
	ToolTip % "In checkAmulet()...", 0, 0

	checkTimeout := 20000
	sleepTime    := 100
	totalLoops   := checkTimeout / sleepTime

	openEquipmentPane()

	Loop, %totalLoops% {
		;; Return early if finished making potions
		If(verifyPixelColor(slotViewer28SnapeGrass[1], slotViewer28SnapeGrass[2]) == False) {
			ToolTip % "Leaving checkAmulet()...", 0, 0
			Return False
		}

		;; Withdraw new necklace if needed and restart loop
		If(verifyPixelColor(amuletEquipped[1], amuletEquipped[2]) == False) {
			doBank(generateSleepTime(213, 389), True)
			ToolTip % "Leaving checkAmulet()...", 0, 0
			Return True
		}

		Sleep, %sleepTime%
	}
	
	ToolTip % "Leaving checkAmulet()...", 0, 0
	*/
}

; ToDO: Placeholder. Rework.
getAmulet() {
	/*
	If(getAmulet == True) {
		BankSlot3Bounds.moveMouseAndClick()
		inputKeyAndSleep("{Shift Down}", generateSleepTime(473, 655))
		InvSlot1Bounds.moveMouseAndClick(, generateSleepTime(737, 944))
		While(verifyPixelColor(slot01Amulet[1], slot01Amulet[2]))
			doClick(generateSleepTime())
		inputKeyAndSleep("{Shift Up}", generateSleepTime())
	}
	*/
}

; ToDO: Requires modification to handle arbitrary potions.
doHerblore() {
	OpenInventory()

	While(verifyItems_P.waitForPixelToBeColor(2000) == False) {
		If(A_Index > 3) {
			MsgBox % "Can't seem to withdraw the right shit"
			Reload
		} Else {
			doBank()
		}
	}
	
	InvSlot14Bounds.moveMouseAndClick()
	InvSlot15Bounds.moveMouseAndClick()
	
	If(makeSupAtkPrompt_P.waitForPixelToBeColor() == False) {
		MsgBox % "???"
		Reload
	}
	UIObject.inputKeyAndSleep("{Space}", generateSleepTime(243, 557))
	
	bankerBounds_B.moveMouse()
	While(InvSlot28Empty.verifyPixelColor() == False) {
		If(A_Index > 250) {
			Break
		} Else {
			Sleep, 100
		}
	}
	doBank()
}

; ToDO: Requires modification to handle arbitrary potions.
doBank(sleepFor := 0) {
	bankerBounds_B.moveMouseAndClick()
	BankOpenCheck.waitForPixelToBeColor()
	Sleep, generateSleepTime(473, 655)

	DepositAll(False)

	;getAmulet()

	If(BankSlot1Bounds.verifyPixelColor() == False Or BankSlot2Bounds.verifyPixelColor() == False) {
		MsgBox % "Done!"
		Reload
	}

	BankSlot1Bounds.moveMouseAndClick()
	BankSlot2Bounds.moveMouseAndClick()
	If(PixelColorLocation.waitForPixelToBeColor(, False,, 0x2F2B2B) == False) {
		MsgBox % "Remaining reagents not divisible by 14. Terminating."
		Reload
	}

	Send, {Esc}
	BankClosedCheck.waitForPixelToBeColor(, False)
	Sleep, generateSleepTime()

	Sleep, sleepFor
}

main() {
	Loop {
		doHerblore()
	}
}

;;=================================================================================================;;

F1::main()
F2::traceCoordsBounds(bankerBounds_B[1], bankerBounds_B[2])

;;=================================================================================================;;

#If
^R::Reload
+^C::ExitApp
