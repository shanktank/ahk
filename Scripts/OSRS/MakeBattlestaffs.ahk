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

Global battlestaff_P			:= New PixelColorLocation(0x967111, [  446, 152 ])
Global battlestaff_P2			:= New PixelColorLocation(0x8E6B10, [  447, 149 ])
Global airOrb_P					:= New PixelColorLocation(0xC6C6CE, [  509, 153 ])
Global verifyItems_P			:= New PixelColorLocation(0xD1D1D7, [ 1584, 969 ])
Global makeAirStaff_P1			:= New PixelColorLocation(0xE1E1E4, [  366, 923 ])
Global makeAirStaff_P2			:= New PixelColorLocation(0xE3E3E5, [  366, 923 ])

Global battlestaff_T			:= New TileMarkerBounds(0x473D30, [ 1477, 820 ])
Global airOrb_T					:= New TileMarkerBounds(0xCECED5, [ 1529, 826 ])

Global bankerBounds_B			:= New ClickAreaBounds([ 725, 281 ], [ 822, 90 ])

;;=================================================================================================;;

; ToDO: Requires modification to handle arbitrary potions.
doCrafting() {
	OpenInventory()

	While(verifyItems_P.waitForPixelToBeColor(2000) == False) {
		If(A_Index > 3) {
			MsgBox % "Can't seem to withdraw the right shit."
			Reload
		} Else {
			doBank()
		}
	}
	
	InvSlot14Bounds.moveMouseAndClick()
	InvSlot15Bounds.moveMouseAndClick()

	If(makeAirStaff_P2.waitForPixelToBeColor() == False) {
		MsgBox % "Crafting operation failed."
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

doBank(sleepFor := 0) {
	bankerBounds_B.moveMouseAndClick()
	BankOpenCheck.waitForPixelToBeColor()
	Sleep, generateSleepTime(473, 655)

	DepositAll(False)

	If(battlestaff_P2.verifyPixelColor() == False) { ;; Or airOrb_P.verifyPixelColor() == False) {
		MsgBox % "Done!"
		Reload
	}
	
	BankSlot1Bounds.moveMouseAndClick()
	BankSlot2Bounds.moveMouseAndClick()
	;If(PixelColorLocation.waitForPixelToBeColor(, False,, 0x2F2B2B) == False) {
	;	MsgBox % "Remaining reagents not divisible by 14. Terminating."
	;	Reload
	;}

	Send, {Esc}
	BankClosedCheck.waitForPixelToBeColor(, False)
	Sleep, generateSleepTime()

	Sleep, sleepFor
}

main() {
	Loop {
		doCrafting()
	}
}

;;=================================================================================================;;

F1::main()
F2::traceCoordsBounds(bankerBounds_B)

;;=================================================================================================;;

#If
^R::Reload
+^C::ExitApp
