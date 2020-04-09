#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;#IfWinActive ahk_exe RuneLite

;=================================================================================================;

Class ClickBounds {
	; Elements: North, South, West, East
	Static seaweedCoordsBounds := [ 283, 298, 818, 843 ]
	Static sandCoordsBounds    := [ 283, 298, 869, 886 ]
	Static spellCoordsBounds   := [ 812, 828, 1607, 1616 ]
	Static bankerCoordsBounds  := [ 517, 567, 738, 756 ]
	Static depositCoordsBounds := [ 816, 843, 883, 910 ]

	; Lower and upper bounds for random sleep times
	Static seaweedSleepBounds  := [ 97, 143 ]
    Static sandSleepBounds     := [ 97, 143 ]
    Static spellSleepBounds    := [ 3122, 3383 ]
    Static bankerSleepBounds   := [ 1193, 1677 ]
    Static depositSleepBounds  := [ 232, 772 ]

	; Coords and colors
	Static spellBookColor := [ 1417, 1019, 0x75281E ]
	Static spellCastColor := [ 1611, 817, 0xD00C2E ]

	clickQueue := []
    sleepQueue := []

	__New() {
		This.clickQueue := [ This.seaweedCoordsBounds, This.sandCoordsBounds, This.spellCoordsBounds, This.bankerCoordsBounds, This.depositCoordsBounds ]
        This.sleepQueue := [ This.seaweedSleepBounds, This.sandSleepBounds, This.spellSleepBounds, This.bankerSleepBounds, This.depositSleepBounds ]
	}
	
	generateCoords(targets) {
		clickCoords := []
		
		For index, element In targets {
			Random, X, element[3], element[4]
			Random, Y, element[1], element[2]
			clickCoords.Push(Array(X, Y))
		}
		
		Return clickCoords
	}

    generateSleeps(targets) {
		sleepTimes := []
		
		For index, element In targets {
			Random, sleepTime, element[1], element[2]
			sleepTimes.Push(sleepTime)
		}
		
		Return sleepTimes 
    }
	
	checkColor(target) {
		PixelGetColor, pixelColor, target[1], target[2], RGB
		
		Return pixelColor == target[3]
	}

    doClick(clickCoords, sleepFor, numClicks := 1, useShift := False) {
        Random, mouseSpeed, 5, 10
		
        MouseMove, clickCoords[1], clickCoords[2], mouseSpeed
		If(useShift == True) {
			Send {LShift Down}
		}
		Loop %numClicks% {
			Random, preClick, 52, 163
			Sleep, preClick
			Click
		}
		If(useShift == True) {
			Send {LShift Up}
		}
		
        Sleep, sleepFor
    }

    doCycle() {
		Loop {
			coords := This.generateCoords(This.clickQueue)
			sleeps := This.generateSleeps(This.sleepQueue)

			displayCoords(coords)
			Return
			This.doClick(coords[1], sleeps[1], 3)
			This.doClick(coords[2], sleeps[2],, True)
			Send {Esc}
			Random, sleepFor, 618, 872
			Sleep, sleepFor
			If(This.checkColor(This.spellBookColor) == False) {
				Send {F3}
				Random, sleepFor, 243, 364
				Sleep, sleepFor
				If(This.checkColor(This.spellBookColor) == False) {
					Return
				}
			}
			If(This.checkColor(This.spellCastColor) == False) {
				Return
			}
			This.doClick(coords[3], sleeps[3])
			This.doClick(coords[4], sleeps[4])
			This.doClick(coords[5], sleeps[5])
		}
    }
}

;=================================================================================================;

displayCoords(coords) {
    ToolTipText := ""
    
    For index, element in coords {
        ToolTipText := % ToolTipText "\n" element[1] ", " element[2]
    }
    
    StringTrimLeft, ToolTipText, ToolTipText, 1
    
    ToolTip, %ToolTipText%, 0, 0
}

;=================================================================================================;

cb := New ClickBounds()

;=================================================================================================;

F1::
    cb.doCycle()
	Return

F2::
	ExitApp
	Return
