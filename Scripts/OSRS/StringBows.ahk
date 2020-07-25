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

; ============================================================================================================================================================ ;
; == Functions =============================================================================================================================================== ;
; ============================================================================================================================================================ ;

main() {
	While(bankSlot1Color.verifyPixelColor()) {
		BankSlot1Bounds.moveMouseAndClick()
		BankSlot2Bounds.moveMouseAndClick()
		UIObject.inputKeyAndSleep("{Esc}")
		UIObject.verifyInvIsOpen()
		InvSlot14Bounds.moveMouseAndClick()
		InvSlot15Bounds.moveMouseAndClick()
		stringPrompt.waitForPixelToBeColor()
		UIObject.inputKeyAndSleep("{Space}")
		UIObject.moveMouse(bankerBounds.generateCoords())
		invSlot14Color.waitForPixelToBeColor(20000)
		;bankerBounds.moveMouseAndClick()
		Click
		bankOpenCheck.waitForPixelToBeColor()
		Random, num, 1, 100
		If(num >= 38) {
			DepositAllBounds.moveMouseAndClick()
		} Else {
			InvSlot1Bounds.moveMouseAndClick()
		}
	}
}

; ============================================================================================================================================================ ;
; == Global Variables ======================================================================================================================================== ;
; ============================================================================================================================================================ ;

Global invSlot14Color := New PixelColorLocation(0x686161, [ 1467, 809 ])
Global invSlot28Color := New PixelColorLocation(0x3E3529, [ 1601, 969 ])
Global bankerBounds := New ClickAreaBounds([ 837, 120 ], [ 939, 464 ])
Global bankOpenCheck := New PixelColorLocation(0x8D8D98, [ 496, 91 ])
Global bankSlot1Color := New PixelColorLocation(0x8F7D11, [ 452, 148 ])
Global stringPrompt := New PixelColorLocation(0x80700D, [ 329, 920 ])

; ============================================================================================================================================================ ;
; == Hotkeys ================================================================================================================================================= ;
; ============================================================================================================================================================ ;

F1::main()

#If
^R::Reload
+^C::ExitApp