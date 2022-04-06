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

;; Config: Highlight Agility Shortcuts disabled
;; Camera facing south, at zenith, full default zoom

;; ============================================================================================================================================================ ;;
;; == Functions =============================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

doChop() {
	ToolTip % "Begin chopping tree...", 0, 0
	tmb := New TileMarkerBounds(0x747068, [ 689, 264 ], [ 807, 118 ], 10)
	tmb.moveMouseAndClick()
	;Sleep, 3000
	ToolTip % "Chopping tree...", 0, 0
	;While(woodcuttingCheck.verifyPixelColor() == False) {
	;	Sleep, 1000
	;}
}

doDrop() {
	Loop {
		;While(invFullCheck.verifyPixelColor() == False) {
		While(InvSlot28Empty.verifyPixelColor() == False) {
			;;dropLogs()
			tmb := New TileMarkerBounds(0x747068, [ 689, 264 ], [ 807, 118 ])
			tmb.moveMouseAndClick()
		}
	}
}

;; TODO: Measure click area bounds of an inventory spot, use ClickAreaBounds.moveMouseAndClick() to empty inventory
;; TODO: Move function to OSRS.ahk
dropAll() {
	delta := 44
	x := 1413
	y := 657
	Loop 4 {
		Loop 7 {
			UIObject.moveMouse([ x, y + A_Index * delta ])
		}
		x := x + delta
	}
}

main() {
	Loop {
		While(InvSlot28Empty.verifyPixelColor()) {
			If(woodcuttingCheck.verifyPixelColor() == False) {
				doChop()
				Sleep, 3000
			}
		}
		MsgBox % "Full!"
		Reload
		;doDrop()
	}
}

;; ============================================================================================================================================================ ;;
;; == Global Variables ======================================================================================================================================== ;;
;; ============================================================================================================================================================ ;;

;; Inv:
;; 1: 1413, 657
;; 4: 1589, 657
;; Total horizontal diff: 176
;; Horizontal diff between slots: 44
;; 25: 1413, 961
;; Total vertical diff: 308
;; Vertical diff between slots: 44

;; NOT: 0xDF0000, [ 34, 69 ]
;; ARE: 0x09DD09, [ 49, 69 ]

Global invFullCheck     := New PixelColorLocation(0xC2A46E, [ 1610, 600 ])
;Global woodcuttingCheck := New PixelColorLocation(0xF20502, [   32,  69 ])
;Global woodcuttingCheck := New PixelColorLocation(0x00CD00, [   47,  69 ])
Global woodcuttingCheck := New PixelColorLocation(0x09DD09, [ 49, 69 ], 10)
;Global woodcuttingCheck := New PixelColorLocation(0xDF0000, [ 34, 69 ], 10)
Global specialCheck     := New PixelColorLocation(0x101010, [ 1455, 215 ])

;; ============================================================================================================================================================ ;;
;; == Hotkeys ================================================================================================================================================= ;;
;; ============================================================================================================================================================ ;;

F1::main()
F2::UIObject.moveMouse(southHoleBounds.generateCoords())
;;F3::UIObject.moveMouse(northHoleBounds.generateCoords(ScreenLowerBounds, ScreenUpperBoundsBig))
;;F4::UIObject.moveMouse(bankChestBounds.generateCoords())
;;F4::UIObject.moveMouse(bankChestBounds.findPixelByColor()["xy"])

#If
^R::Reload
+^C::ExitApp
