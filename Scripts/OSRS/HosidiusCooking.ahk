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

; Camera zoom: 318/1004

Global cookTileBounds := New TileMarkerBounds(BLUE,   [ -5,  0 ], [ -34, 24 ], 25)
Global bankTileBounds := New TileMarkerBounds(PURPLE, [ -8, 10 ], [ -33, 30 ], 25)

Global cookingPrompt  := New PixelColorLocation(0x494539, [  662, 858 ])
Global lastSwordRaw   := New PixelColorLocation(0x946A9C, [ 1587, 959 ])
Global lastSharkRaw   := New PixelColorLocation(0x988E8D, [ 1587, 959 ])

lastFishCooked(fishType) {
	isLastFishRaw := fishType.verifyPixelColor()
}

main() {
	Loop {
		cookTileBounds.moveMouseAndClick()
		cookingPrompt.waitForPixelToBeColor()
		inputKeyAndSleep("{Space}")
		lastSharkRaw.waitForPixelToBeColor(75000, False)
		bankTileBounds.moveMouseAndClick()
		BankOpenCheck.waitForPixelToBeColor()
		DepositAll(False)
		BankSlot1Bounds.moveMouseAndClick()
		inputKeyAndSleep("{Esc}")
	}
}

F1::main()

^R::Reload
+^C::ExitApp
