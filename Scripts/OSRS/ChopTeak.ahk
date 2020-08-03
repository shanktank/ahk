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

; Config: Highlight Agility Shortcuts disabled
; Camera facing south, at zenith, full default zoom

; ============================================================================================================================================================ ;
; == Functions =============================================================================================================================================== ;
; ============================================================================================================================================================ ;

chopTeaks() {
	ToolTip % "Waiting for tree to grow back...", 0, 0
	While(teakStumpCheck.verifyPixelColor()) { ; TODO: Will only work from a particular tile
		Sleep, 1000
	}
	ToolTip % "Begin chopping tree...", 0, 0
	teakTreeBounds.moveMouseAndClick()
	Sleep, 3000
	ToolTip % "Chopping tree...", 0, 0
	While(woodcuttingCheck.verifyPixelColor()) {
		Sleep, 1000
	}
	Sleep, 4000 ; Manually wait for tree to regrow
	ToolTip % "Idle", 0, 0
}

doBank() {
	ToolTip % "Climbing through south hole...", 0, 0
	southHoleBounds.moveMouseAndClick()
	Sleep, 2000
	ToolTip % "Waiting for chest to become visible...", 0, 0
	While(bankChestBounds.findPixelByColor()["rc"] != 0)
		Sleep, 1000
	ToolTip % "Clicking bank...", 0, 0
	UIObject.moveMouseAndClick(bankChestBounds.generateCoords())
	ToolTip % "Waiting for bank to open...", 0, 0
	BankOpenCheck.waitForPixelToBeColor(10000)
	DepositAll()
	UIObject.inputKeyAndSleep("{Esc}", generateSleepTime(437, 670))
	;northHoleBounds.moveMouseAndClick()
	ToolTip % "Climbing through north hole...", 0, 0
	UIObject.moveMouseAndClick(northHoleBounds.generateCoords(ScreenLowerBounds, ScreenUpperBoundsBig))
	Sleep, 5000
	ToolTip % "Waiting for tree click box to become visible...", 0, 0
	While(teakTreeBounds.findPixelByColor()["rc"] != 0)
		Sleep, 1000
	;Sleep, 2000
	;chopTeakBounds.moveMouseAndClick()
	;Sleep, 3000
	ToolTip % "Idle", 0, 0
}

getNests() {

}

main() {
	Loop {
		While(invFullCheck.verifyPixelColor() == False)
			chopTeaks()
		doBank()
	}
}

; ============================================================================================================================================================ ;
; == Global Variables ======================================================================================================================================== ;
; ============================================================================================================================================================ ;

;Global bankChestBounds := New TileMarkerBounds(TEAL, [ -1, 0 ], [ -7, 14 ], 10)
Global bankChestBounds := New TileMarkerBounds(TEAL, [ 2, -17 ], [ 46, 0 ], 10)
;Global teakTreeBounds   := New TileMarkerBounds(PURPLE, [ 533, 271 ], [ 1124, 796 ], 10)
;Global teakTreeBounds  := New TileMarkerBounds(BLUE, [ 5, -5 ], [ 52, -47 ], 10)
Global teakTreeBounds  := New TileMarkerBounds(0x0101E9, [ 5, -5 ], [ 17, -19 ], 10)
;Global teakTreeBounds   := New TileMarkerBounds(0x8AA05B, [ 533, 271 ], [ 1124, 796 ], 10)
;Global teakTreeBounds   := New TileMarkerBounds(0x8AA05B, -1, -1, 10)
;Global climbHoleBounds  := New TileMarkerBounds(0xA5A4A4, -1, -1, 10)
Global southHoleBounds := New TileMarkerBounds(PURPLE, [ -60, 0 ], [ -5, 25 ], 10)
Global northHoleBounds := New TileMarkerBounds(ORANGE, [ 0, 0 ], [ -75, 30 ], 10)

Global bankClickBounds := New ClickAreaBounds([   94, 264 ], [  109, 282 ])
;Global southHoleBounds := New ClickAreaBounds([  813, 394 ], [  868, 436 ])
;Global northHoleBounds := New ClickAreaBounds([ 1474, 830 ], [ 1545, 871 ])
Global chopTeakBounds  := New ClickAreaBounds([  744, 656 ], [  775, 712 ])

Global teakTreeCheck    := New PixelColorLocation(0x8AA05B, [  795, 595 ])
Global teakStumpCheck   := New PixelColorLocation(0x8F7951, [  795, 595 ])
Global invFullCheck     := New PixelColorLocation(0xC2A46E, [ 1610, 600 ])
;Global woodcuttingCheck := New PixelColorLocation(0xF20502, [   32,  69 ])
Global woodcuttingCheck := New PixelColorLocation(0x00CD00, [   47,  69 ])
Global specialCheck     := New PixelColorLocation(0x101010, [ 1455, 215 ])

; ============================================================================================================================================================ ;
; == Hotkeys ================================================================================================================================================= ;
; ============================================================================================================================================================ ;

F1::main()
F2::UIObject.moveMouse(southHoleBounds.generateCoords())
F3::UIObject.moveMouse(northHoleBounds.generateCoords(ScreenLowerBounds, ScreenUpperBoundsBig))
F4::UIObject.moveMouse(bankChestBounds.generateCoords())
;F4::UIObject.moveMouse(bankChestBounds.findPixelByColor()["xy"])

#If
^R::Reload
+^C::ExitApp
