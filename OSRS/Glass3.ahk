#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

CoordMode, Mouse, Screen
CoordMode, Pixel, Screen

;#IfWinActive ahk_exe RuneLite

;=================================================================================================;

RandomBezier(Xf, Yf, O="") {
	MouseGetPos, X0, Y0
    Time := RegExMatch(O,"i)T(\d+)",M)&&(M1>0)? M1: 200
    RO := InStr(O,"RO",0) , RD := InStr(O,"RD",0)
    N:=!RegExMatch(O,"i)P(\d+)(-(\d+))?",M)||(M1<2)? 2: (M1>19)? 19: M1
    If ((M:=(M3!="")? ((M3<2)? 2: ((M3>19)? 19: M3)): ((M1=="")? 5: ""))!="")
        Random, N, %N%, %M%
    OfT:=RegExMatch(O,"i)OT(-?\d+)",M)? M1: 100, OfB:=RegExMatch(O,"i)OB(-?\d+)",M)? M1: 100
    OfL:=RegExMatch(O,"i)OL(-?\d+)",M)? M1: 100, OfR:=RegExMatch(O,"i)OR(-?\d+)",M)? M1: 100
    MouseGetPos, XM, YM
    If ( RO )
        X0 += XM, Y0 += YM
    If ( RD )
        Xf += XM, Yf += YM
    If ( X0 < Xf )
        sX := X0-OfL, bX := Xf+OfR
    Else
        sX := Xf-OfL, bX := X0+OfR
    If ( Y0 < Yf )
        sY := Y0-OfT, bY := Yf+OfB
    Else
        sY := Yf-OfT, bY := Y0+OfB
    Loop, % (--N)-1 {
        Random, X%A_Index%, %sX%, %bX%
        Random, Y%A_Index%, %sY%, %bY%
    }
    X%N% := Xf, Y%N% := Yf, E := ( I := A_TickCount ) + Time
    While ( A_TickCount < E ) {
        U := 1 - (T := (A_TickCount-I)/Time)
        Loop, % N + 1 + (X := Y := 0) {
            Loop, % Idx := A_Index - (F1 := F2 := F3 := 1)
                F2 *= A_Index, F1 *= A_Index
            Loop, % D := N-Idx
                F3 *= A_Index, F1 *= A_Index+Idx
            M:=(F1/(F2*F3))*((T+0.000001)**Idx)*((U-0.000001)**D), X+=M*X%Idx%, Y+=M*Y%Idx%
        }
        MouseMove, %X%, %Y%, 0
        Sleep, 1
    }
    MouseMove, X%N%, Y%N%, 0
    Return N+1
}

;=================================================================================================;

Class ClickBounds {
	; Elements: North, South, West, East
	Static seaweedCoordBounds := [ 283, 298, 818, 843 ]
	Static sandCoordBounds    := [ 283, 298, 869, 886 ]
	Static spellCoordBounds   := [ 812, 828, 1607, 1616 ]
	Static bankerCoordBounds  := [ 425, 552, 664, 687 ]
	Static depositCoordBounds := [ 816, 843, 883, 910 ]

	; Lower and upper bounds for random sleep times
	Static seaweedSleepBounds := [ 97, 143 ]
    Static sandSleepBounds    := [ 97, 143 ]
    Static spellSleepBounds   := [ 313, 420 ]
    Static bankerSleepBounds  := [ 1193, 1677 ]
    Static depositSleepBounds := [ 232, 772 ]

	Static seaweedSpeedBounds := [ 822, 998 ]
    Static sandSpeedBounds    := [ 133, 198 ]
    Static spellSpeedBounds   := [ 1198, 1314 ]
    Static bankerSpeedBounds  := [ 1115, 1569 ]
    Static depositSpeedBounds := [ 714, 812 ]

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

    doClick(clickCoords, sleepFor, optString, numClicks := 1, useShift := False, simpleMove := False) {
		ToolTip % optString, 0, 0
		If(simpleMove == False) {
			RandomBezier(clickCoords[1], clickCoords[2], optString)
		} Else {
			Random, moveSpeed, 5, 15
			MouseMove, clickCoords[1], clickCoords[2], moveSpeed
		}
		
		If(useShift == True) {
			Send {Shift Down}
			;KeyWait, Shift, DL
			Sleep, 150
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
			speeds := This.generateSleeps(This.speedQueue)

			;displayCoords(coords)
			
			Random, points, 3, 4
			;This.doClick(coords[1], sleeps[1], "T"speeds[1]" OT38 OB40 OL40 OR39 P2-"points, 3)
			This.doClick(coords[1], sleeps[1], "T"speeds[1]" P4-7", 3)
			;This.doClick(coords[2], sleeps[2], "T"speeds[2]" OT5 OB5 OL5 OR5 P2-7",, True)
			This.doClick(coords[2], sleeps[2], "T"speeds[2]" P4-7", , True, True)
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
			Random, points, 3, 6
			;This.doClick(coords[3], sleeps[3], "T"speeds[3]" OT47 OB44 OL42 OR43 P2-"points)
			This.doClick(coords[3], sleeps[3], "T"speeds[3]" P4-7")
			Random, points, 3, 6
			;This.doClick(coords[4], sleeps[4], "T"speeds[4]" OT41 OB45 OL48 OR50 P2-"points)
			This.doClick(coords[4], sleeps[4], "T"speeds[4]" P4-7")
			While This.checkColor(This.bankOpenColor) == False {
				If(This.checkColor(This.bankOpenColor) == False) {
					Click
					Random, sleepFor, 445, 690
					Sleep, sleepFor
				}
			}
			Random, sleepFor, 321, 420
			Sleep, sleepFor
			Random, points, 3, 4
			;This.doClick(coords[5], sleeps[5], "t"speeds[5]" OT27 OB24 OL25 OR27 P2-"points)
			This.doClick(coords[5], sleeps[5], "t"speeds[5]" P4-7")
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

F1::cb.doCycle()
F2::Reload
