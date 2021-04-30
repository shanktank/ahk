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

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

main() {
	While(invSlot14Check.waitForPixelToBeColor() And invSlot15Check.waitForPixelToBeColor()) {
		InvSlot14Bounds.moveMouseAndClick()
		InvSlot15Bounds.moveMouseAndClick()
		makeWinePrompt.waitForPixelToBeColor()
		UIObject.inputKeyAndSleep("{Space}")
		UIObject.moveMouse(bankerBounds.generateCoords())
		InvSlot28Empty.waitForPixelToBeColor(20000)
		UIObject.doClick()
		BankOpenCheck.waitForPixelToBeColor()
		DepositAll()
		BankSlot1Bounds.moveMouseAndClick()
		BankSlot2Bounds.moveMouseAndClick()
		UIObject.inputKeyAndSleep("{Esc}")
		UIObject.verifyInvIsOpen()
	}
	
	MsgBox % "Out of reagents."
}

;; ============================================================================================================================================================ ;;
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

;Global makeWinePrompt := New PixelColorLocation(0xA5423C, [ 347, 948 ])
Global makeWinePrompt := New PixelColorLocation(0xA5423C, [ 347, 933 ])
Global bankerBounds   := New ClickAreaBounds([ 842, 176 ], [ 908, 361 ])
Global invSlot14Check := New PixelColorLocation(0x7476CA, [ 1479, 811 ])
Global invSlot15Check := New PixelColorLocation(0x780D5A, [ 1538, 824 ])

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::main()

#If
^R::Reload
+^C::ExitApp