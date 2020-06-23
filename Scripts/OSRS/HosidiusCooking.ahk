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

Global grillTileBounds    := New TileMarkerBounds(BLUE,   [ -5,  0 ], [ -34, 24 ], 25)
Global bankTileBounds     := New TileMarkerBounds(PURPLE, [ -8, 10 ], [ -33, 30 ], 25)

Global cookingPrompt      := New PixelColorLocation(0xCAB2CF, [  341, 945 ])
Global lastFishNotCooked  := New PixelColorLocation(0x946A9C, [ 1587, 959 ])
Global bankOpenCheck      := New PixelColorLocation(0xB17FBB, [  445, 146 ])

Global withdrawFishBounds := New ClickAreaBounds([ 434, 135 ], [ 462, 168 ])

main() {
	Loop {
		grillTileBounds.moveMouseAndClick()
		cookingPrompt.waitForPixelToBeColor()
		inputKeyAndSleep("{Space}")
		lastFishNotCooked.waitForPixelToBeColor(75000)
		bankTileBounds.moveMouseAndClick()
		bankOpenCheck.waitForPixelToBeColor()
		depositAllBounds.moveMouseAndClick(depositAllBounds.generateCoords())
		moveMouseAndClick(withdrawFishBounds.generateCoords())
		inputKeyAndSleep("{Esc}")
	}
}

F1::main()

^R::Reload
+^C::ExitApp
