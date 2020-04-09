#SingleInstance FORCE
;#EscapeChar \
#Persistent
#NoEnv
#Warn

SetTitleMatchMode, RegEx
#IfWinActive, RuneLite

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;=================================================================================================;

RandomBezier(X0, Y0, Xf, Yf, O="") {
    Time := RegExMatch(O, "i)T(\d+)", M) && (M1 > 0) ? M1 : 200
    RO := InStr(O, "RO", 0), RD := InStr(O, "RD", 0)
    N := !RegExMatch(O, "i)P(\d+)(-(\d+))?", M) || (M1 < 2) ? 2 : (M1 > 19) ? 19 : M1
    If((M := (M3 != "") ? ((M3 < 2) ? 2 : ((M3 > 19 ) ? 19 : M3)) : ((M1 == "") ? 5 : "")) != "")
        Random, N, %N%, %M%
    OfT := RegExMatch(O, "i)OT(-?\d+)", M) ? M1 : 100, OfB := RegExMatch(O, "i)OB(-?\d+)", M) ? M1 : 100
    OfL := RegExMatch(O, "i)OL(-?\d+)", M) ? M1 : 100, OfR := RegExMatch(O, "i)OR(-?\d+)", M) ? M1 : 100
    
	MouseGetPos, XM, YM
    
	If(RO)
        X0 += XM, Y0 += YM
    If(RD)
        Xf += XM, Yf += YM
    If(X0 < Xf)
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    
	If(Y0 < Yf)
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
	
    Loop, % (--N) - 1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
	
    X%N% := Xf, Y%N% := Yf, E := (I := A_TickCount) + Time
	
    While(A_TickCount < E) {
        U := 1 - (T := (A_TickCount - I) / Time)
        
		Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N - Idx
                F3 *= A_Index, F1 *= A_Index + Idx
            M := (F1 / (F2 * F3)) * ((T + 0.000001) ** Idx) * ((U - 0.000001) ** D), X += M * X%Idx%, Y += M * Y%Idx%
        }
        
		MouseMove, %X%, %Y%, 0
        
		Sleep, 1
    }
	
    MouseMove, X%N%, Y%N%, 0
    
	Return N + 1
}

;=================================================================================================;

Class ClickBounds {
	; Elements: North, South, West, East
	Static seaweedCoordBounds := [ 283, 298, 818, 843 ]
	Static sandCoordBounds    := [ 283, 298, 869, 886 ]
	Static spellCoordBounds   := [ 812, 828, 1607, 1616 ]
	;Static bankerCoordBounds  := [ 425, 552, 664, 687 ]
	Static bankerCoordBounds  := [ 406, 672, 470, 543 ]
	Static depositCoordBounds := [ 816, 843, 883, 910 ]

	; Lower and upper bounds for random sleep times
	Static seaweedSleepBounds := [ 97, 143 ]
    Static sandSleepBounds    := [ 172, 239 ]
    Static spellSleepBounds   := [ 123, 321 ]
    Static bankerSleepBounds  := [ 329, 455 ]
    Static depositSleepBounds := [ 232, 278 ]

	Static seaweedSpeedBounds := [ 389, 462 ]
    Static sandSpeedBounds    := [ 201, 286 ]
    Static spellSpeedBounds   := [ 365, 418 ]
    Static bankerSpeedBounds  := [ 417, 501 ]
    Static depositSpeedBounds := [ 275, 369 ]

	; Coords and colors
	Static spellBookColor := [ 1417, 1019, 0x75281E ]
	Static spellCastColor := [ 1611, 817, 0xD00C2E ]
	;Static bankOpenColor  := [ 710, 510, 0x473D32 ]
	Static bankOpenColor  := [ 573, 370, 0x494034 ]

	clickQueue := []
    sleepQueue := []
	speedQueue := []

	__New() {
		This.clickQueue := [ This.seaweedCoordBounds, This.sandCoordBounds, This.spellCoordBounds, This.bankerCoordBounds, This.depositCoordBounds ]
        This.sleepQueue := [ This.seaweedSleepBounds, This.sandSleepBounds, This.spellSleepBounds, This.bankerSleepBounds, This.depositSleepBounds ]
		This.speedQueue := [ This.seaweedSpeedBounds, This.sandSpeedBounds, This.spellSpeedBounds, This.bankerSpeedBounds, This.depositSpeedBounds ]
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
	
	handleDropdown(itemCoords, taskSleep, mouseSpeed) {
		Random, menuCoordsX, 64, 78
		Random, menuCoordsY, -100, 100
		Random, sleepBonus, 10, 25
		Random, speedBonus, 20, 30
		
		This.doClick(Array(itemCoords[1] + menuCoordsY, itemCoords[2] + menuCoordsX), taskSleep + sleepBonus, "T"(mouseSpeed + speedBonus)" OT5 OB5 OL5 OR5 P2-4")
	}
	
	pressAndSleep(lowerBound, upperBound, buttonInput := 0) {
		If(buttonInput)
			Send, {%buttonInput%}
		Random, sleepFor, %lowerBound%, %upperBound%
		Sleep, sleepFor
	}
	
	doClick(clickCoords, sleepFor, optString, numClicks := 1, rightClick := False, simpleMove := False) {
		Random, randomNum, 1, 1000
		If(randomNum == 123) {
			Random, extraSleep, 2143, 7281
			ToolTip, Rando extra sleeping!
			Sleep, extraSleep
			ToolTip
		}
	
		If(simpleMove == False) {
			MouseGetPos, px, py
			RandomBezier(px, py, clickCoords[1], clickCoords[2], optString)
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

    startCycle() {
		Loop {
			; Generate random numbers for our various operations
			coords := This.generateCoords(This.clickQueue)
			sleeps := This.generateSleeps(This.sleepQueue)
			speeds := This.generateSleeps(This.speedQueue)
			
			; Withdraw seaweed and sand buckets
			This.doClick(coords[1], sleeps[1], "T"speeds[1]" OT38 OB40 OL40 OR39 P2-4", 3)
			This.doClick(coords[2], sleeps[2], "T"speeds[2]" OT5 OB5 OL5 OR5 P2-4", , True)
			
			; Offset right click menu to withdraw x because shift click works like shit
			This.handleDropdown(coords[2], sleeps[2], speeds[2])
			
			; Close bank
			This.pressAndSleep(99, 149, "Esc")

			; Check if spell book is open
			While This.checkColor(This.spellBookColor) == False {
				This.pressAndSleep(243, 364, "F3")
				If(A_Index > 5)
					Return
			}
			
			; Check if spell can be case
			If(This.checkColor(This.spellCastColor) == False)
				Return
			
			; Cast Superglass Make then click on banker
			This.doClick(coords[3], sleeps[3], "T"speeds[3]" OT47 OB44 OL42 OR43 P2-4")
			This.doClick(coords[4], sleeps[4], "T"speeds[4]" OT41 OB45 OL48 OR50 P2-4")
			
			; Spam click the banker until the bank is open, and take a short pause before continuing
			While This.checkColor(This.bankOpenColor) == False {
				This.pressAndSleep(169, 232, "Click")
				If(A_Index > 25)
					Return
			}
			This.pressAndSleep(124, 219)
			
			; Deposit all
			This.doClick(coords[5], sleeps[5], "t"speeds[5]" OT27 OB24 OL25 OR27 P2-3")
			Random, 25, 75
			Click
		}
    }
	
	testCoordBounds(coordBounds) {
		MouseMove, coordBounds[3], coordBounds[1], 20
		Sleep, 1000
		MouseMove, coordBounds[4], coordBounds[1], 20
		Sleep, 1000
		MouseMove, coordBounds[3], coordBounds[2], 20
		Sleep, 1000
		MouseMove, coordBounds[4], coordBounds[2], 20
		;Sleep, 1000
		Return
		
		Loop, 10 {
			Random, X, coordBounds[3], coordBounds[4]
			Random, Y, coordBounds[1], coordBounds[2]
			MouseMove, %X%, %Y%
			Sleep, 1000
		}
	}
	
	displayCoords(coords) {
		ToolTipText := ""
		
		For index, element in coords {
			ToolTipText := % ToolTipText "\n" element[1] ", " element[2]
		}
		
		StringTrimLeft, ToolTipText, ToolTipText, 1
		
		ToolTip, %ToolTipText%, 0, 0
	}
}

;=================================================================================================;

cb := New ClickBounds()

;=================================================================================================;

F1::
Ctrl & Alt::
	cb.startCycle()
	Return

F4::
	cb.testCoordBounds(cb.bankerCoordBounds)
	Return

^R::Reload
^C::ExitApp
