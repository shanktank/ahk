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

Global withdrawFishBounds := New ClickAreaBounds([ 434, 135 ], [ 462, 168 ])

Global grillTileBounds    := New TileMarkerBounds(BLUE,   [ -5,  0 ], [ -34, 24 ], 25)
Global bankTileBounds     := New TileMarkerBounds(PURPLE, [ -8, 10 ], [ -33, 30 ], 25)

Global cookingPrompt      := New PixelColorLocation(0x835C8A, [  341, 945 ])
Global lastFishNotCooked  := New PixelColorLocation(0xBF8BC8, [ 1587, 975 ])
Global bankOpenCheck      := New PixelColorLocation(0x000000, [    0,   0 ])

main() {
	Loop {
		grillTileBounds.moveMouseAndClick()
		cookingPrompt.waitForPixelToBeColor()
		inputKeyAndSleep("{Space}")
		waitForPixelToBeColor(lastFishNotCooked, False)
		bankTileBounds.moveMouseAndClick()
		bankOpenCheck.waitForPixelToBeColor()
		depositAllBounds.moveMouseAndClick()
		withdrawFishBounds.moveMouseAndClick()
		inputKeyAndSleep("{Esc}")
	}
}

F1::main()

^R::Reload
+^C::ExitApp
