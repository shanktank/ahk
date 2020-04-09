#Include _RandomBezier.ahk

#SingleInstance FORCE
;#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode Input

Class Blast {
	; Color, X play room, Y play room, X min offset, Y min offset
	Static blue   := [ 0x0000FF,  25, 30,  0, 0 ]
	Static purple := [ 0xFF00FF, -24, 30,  0, 1 ]
	Static green  := [ 0x00FF00, -20, 25, -2, 2 ]

	Static firstInvSpaceEmpty := [ 1420, 680, 0x3E3529 ]
	Static firstInvSpaceAddy  := [ 1420, 680, 0x2A352A ]
	Static takeAdamantBars    := [  345, 935, 0x405140 ]
	Static bankOpenCheck      := [  800, 800, 0x831F1D ]
	
	; Low X, low Y, high X, high Y
	Static depositAllBounds   := [ 902, 779, 939, 815 ]
	Static withdrawOreBounds  := [ 561, 326, 593, 356 ]
	Static withdrawCoalBounds := [ 625, 326, 657, 357 ]

	findPixel(pixelColor) {
		PixelSearch, OX, OY, 0, 25, 1350, 850, %pixelColor%, 15, RGB, Fast
		Return [ OX, OY ]
	}
	
	waitForPixel(pixelInfo) {
		pixelColor := 0x0
		While(pixelColor != pixelInfo[3]) {
			PixelGetColor, pixelColor, pixelInfo[1], pixelInfo[2], RGB
			Sleep, 250
		}
	}
	
	generateCoordsDynamic(xy, play) {
		Random, x, xy[1] + play[4], xy[1] + play[2]
		Random, y, xy[2] + play[5], xy[2] + play[3]
		Return [ x, y ]
	}
	
	generateCoordsStatic(bounds) {
		Random, x, bounds[1], bounds[3]
		Random, y, bounds[2], bounds[4]
		Return [ x, y ]
	}
	
	moveMouse(clickCoords, optString := "", simpleMove := False) {
		If(simpleMove == False) {
			RandomBezier(clickCoords[1], clickCoords[2], optString)
		} Else {
			Random, moveSpeed, 5, 15
			MouseMove, clickCoords[1], clickCoords[2], moveSpeed
		}
	}
	
	doClick(sleepFor := 200, numClicks := 1, rightClick := False) {
		If(rightClick == True) {
			Click, Right
		} Else {
			Loop %numClicks% {
				Random, preClick, 52, 163
				Sleep, preClick
				Click
			}
		}
        Sleep, sleepFor
	}
	
	checkClick() {
		MouseGetPos, x, y
		PixelGetColor, pixelColor, x, y, RGB
		Return pixelColor == 0xFF0000
	}
	
	moveAndClick2(colorInfo, optString := "", simpleMove := False, sleepFor := 200, numClicks := 1, rightClick := False) {
		While(This.checkClick() == False) {
			Sleep, 250
			XY := This.findPixel(colorInfo[1])
			CC := This.generateCoordsDynamic(XY, colorInfo)
			This.moveMouse(CC, optString, simpleMove)
			This.doClick(sleepFor, numClicks, rightClick)
		}
	}
	
	moveAndClick(clickCoords, optString := "", simpleMove := False, sleepFor := 200, numClicks := 1, rightClick := False) {
		;Random, randomNum, 1, 1000
		;If(randomNum == 123) {
		;	Random, extraSleep, 2143, 7281
		;	ToolTip, Rando extra sleeping!
		;	Sleep, extraSleep
		;	ToolTip
		;}
	
		If(simpleMove == False) {
			RandomBezier(clickCoords[1], clickCoords[2], optString)
		} Else {
			Random, moveSpeed, 5, 15
			MouseMove, clickCoords[1], clickCoords[2], moveSpeed
		}
		
		If(rightClick == True) {
			Click, Right
		} Else {
			Loop %numClicks% {
				Random, preClick, 52, 163
				Sleep, preClick
				Click
			}
		}
		
        Sleep, sleepFor
    }
}

b := New Blast()

F1::
	Loop, 2 {
		b.moveAndClick2(b.blue)
		b.waitForPixel(b.firstInvSpaceEmpty)
		
		b.moveAndClick2(b.purple)
		b.waitForPixel(b.takeAdamantBars)
		Send, 1
		b.waitForPixel(b.firstInvSpaceAddy)
		
		b.moveAndClick2(b.green)
		b.waitForPixel(b.bankOpenCheck)
		
		b.moveAndClick(b.generateCoordsStatic(b.depositAllBounds))
		b.moveAndClick(b.generateCoordsStatic(b.withdrawOreBounds))
		b.moveAndClick(b.generateCoordsStatic(b.withdrawCoalBounds), "", True, 150, 3)
		Send, {Esc}
		Sleep, 250
	}
	
	Return

^R::Reload
^C::ExitApp
