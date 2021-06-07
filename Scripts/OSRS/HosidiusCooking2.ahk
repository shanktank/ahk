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

; 479/1004

Global ovenTileBounds := New PixelScanArea(0xFF00FF, [ 901, 167 ], [ 1010, 64 ], 25)
Global bankTileBounds := New PixelScanArea(0x702119, [ 671, 700 ], [ 964, 928 ], 25)

Global cookingPrompt  := New PixelColorLocation(0x2C7E53, [ 321, 971 ])
Global lastSwordRaw   := New PixelColorLocation(0x946A9C, [ 1587, 959 ])
Global lastSharkRaw   := New PixelColorLocation(0x988E8D, [ 1587, 959 ])
Global lastAnglerRaw  := New PixelColorLocation(0x4F552F, [ 1598, 962 ])

main() {
	Loop {
		/*
		If(lastAnglerRaw.verifyPixelColor()) {
			Sleep, 250
			Continue
		}
		*/
		ClayOvenClickArea := generateCoords([ 928, 157 ], [ 972, 103 ])
		BankClickArea := generateCoords([ 673, 959 ], [ 716, 913 ])
		moveMouseAndClick(ClayOvenClickArea)
		cookingPrompt.waitForPixelToBeColor()
		UIObject.inputKeyAndSleep("{Space}")
		lastAnglerRaw.waitForPixelToBeColor(75000, False)
		moveMouseAndClick(BankClickArea)
		BankOpenCheck2.waitForPixelToBeColor()
		DepositAll(False)
		BankSlot1Bounds.moveMouseAndClick()
		UIObject.inputKeyAndSleep("{Esc}")
	}
}

F1::main()

^R::Reload
+^C::ExitApp
