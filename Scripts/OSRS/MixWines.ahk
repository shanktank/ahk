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
	While(invSlot14CheckLaptop.waitForPixelToBeColor() And invSlot15CheckLaptop.waitForPixelToBeColor()) {
		InvSlot14Bounds.moveMouseAndClick()
		InvSlot15Bounds.moveMouseAndClick()
		ToolTip % "3", 0, 0
		makeWinePrompt.waitForPixelToBeColor()
		ToolTip % "4", 0, 0
		UIObject.inputKeyAndSleep("{Space}")
		UIObject.moveMouse(bankerBounds.generateCoords())
		InvSlot28Empty.waitForPixelToBeColor(20000)
		UIObject.doClick()
		BankOpenCheck2.waitForPixelToBeColor()
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
Global bankerBounds   := New ClickAreaBounds([ 812, 384 ], [ 922, 126 ])
Global invSlot14CheckDesktop := New PixelColorLocation(0x7C7ED1, [ 1479, 811 ])
Global invSlot14CheckLaptop := New PixelColorLocation(0x7C7ED1, [ 1479, 811 ], 5)
Global invSlot15CheckDesktop := New PixelColorLocation(0x790D5B, [ 1537, 824 ])
Global invSlot15CheckLaptop := New PixelColorLocation(0x7A0D5B, [ 1537, 824 ], 5)

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::main()
F2::UIObject.moveMouse([100, 100])

#If
^R::Reload
+^C::ExitApp