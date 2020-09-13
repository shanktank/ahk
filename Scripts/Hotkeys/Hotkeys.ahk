#SingleInstance Force
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%

; ================================================================================================================================================== ;
; == Globals ======================================================================================================================================= ;
; ================================================================================================================================================== ;

Global Null =
Global WinTenPadding := 8

; ================================================================================================================================================== ;
; == Hotkeys ======================================================================================================================================= ;
; ================================================================================================================================================== ;

; Ctrl + H: Toggle show hidden files
^H::
	If(WinActive("AHK_Class CabinetWClass")) {
		RegPath := "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced"
        RegRead, HiddenStatus, HKEY_CURRENT_USER, %RegPath%, Hidden
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, %RegPath%, Hidden, % HiddenStatus == 1 ? 2 : 1
        Send {F5}
	}
    Return

; Ctrl + Shift + H: Toggle show system files
^+H::
    If(WinActive("AHK_Class CabinetWClass")) {
		RegPath := "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced"
        RegRead, SuperHiddenStatus, HKEY_CURRENT_USER, %RegPath%, ShowSuperHidden
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, %RegPath%, ShowSuperHidden, % SuperHiddenStatus == 0 ? 1 : 0
        Send {F5}
    }
    Return

; Ctrl + Alt + Shift + N: Toggle hidden status of selected files.
^!+N::
	If(WinActive("AHK_Class CabinetWClass")) {
		Send ^c
		ClipWait
		Loop, Parse, Clipboard, \n, \r
			FileSetAttrib, ^H, % A_LoopField
		Send {F5}
	}	
	Return

; ================================================================================================================================================== ;
; == Media ========================================================================================================================================= ;
; ================================================================================================================================================== ;

; Ctrl + Alt + Win + Hotkey: Execute specified shortcut.
^!+Left::Send {Media_Prev}
^!+Right::Send {Media_Next}
^!+Space::Send {Media_Play_Pause}

; ================================================================================================================================================== ;
; == Launchers ===================================================================================================================================== ;
; ================================================================================================================================================== ;

; Ctrl + Alt + Win + Hotkey: Launch specified program.
^!+P::Run putty
^!+U::Run putty -load "super remote"
^!+J::Run putty -load "super local"
^!+O::Run debian
^!+L::Run %A_AppData%/Microsoft/Windows/Start Menu/Programs/Windows PowerShell/PowerShell
^!+H::Run %A_MyDocuments%/Git/ahk/Scripts/Hotkeys/
^!+A::Run %A_MyDocuments%/Git/ahk/Scripts/OSRS/
^!+K::Run %A_MyDocuments%/KeePassX/KeePassX
^!+I::Run firefox -P profile
^!+M::Run firefox -P minimal
^!+S::Run Control mmsys.cpl Sounds

; ================================================================================================================================================== ;
; == Shifters ====================================================================================================================================== ;
; ================================================================================================================================================== ;

; Ctrl + Win + Hotkey: Control cursor as specified.
^#2::
^#Numpad2::PixelStep(+0, +1)
^#4::
^#Numpad4::PixelStep(-1, +0)
^#6::
^#Numpad6::PixelStep(+1, +0)
^#8::
^#Numpad8::PixelStep(+0, -1)
^#5::
^#Numpad5::Click Down
^#0::
^#Numpad0::Click Up

; ================================================================================================================================================== ;
; == Resizers ====================================================================================================================================== ;
; ================================================================================================================================================== ;

; LWin + Subtract: Set dimensions of active window.
<#-::
<#NumpadSub::ResizeWindow()

; ================================================================================================================================================== ;
; == Movers ======================================================================================================================================== ;
; ================================================================================================================================================== ;

; LWin + Hotkey: Move active window as specified.
<#4::
<#Numpad4::
<#NumpadLeft::MoveWindow("Left")
<#6::
<#Numpad6::
<#NumpadRight::MoveWindow("Right")
<#8::
<#Numpad8::
<#NumpadUp::MoveWindow("Up")
<#2::
<#Numpad2::
<#NumpadDown::MoveWindow("Down")
<#5::
<#Numpad5::
<#NumpadClear::MoveWindow("Center")
<#1::
<#Numpad1::
<#NumpadEnd::CornerWindow("BottomLeft")
<#3::
<#Numpad3::
<#NumpadPgDn::CornerWindow("BottomRight")
<#7::
<#Numpad7::
<#NumpadHome::CornerWindow("TopLeft")
<#9::
<#Numpad9::
<#NumpadPgUp::CornerWindow("TopRight")

; ================================================================================================================================================== ;
; == Shifter functions ============================================================================================================================= ;
; ================================================================================================================================================== ;

PixelStep(dx := 0, dy := 0) {
    MouseGetPos, x, y
    MouseMove, x + dx, y + dy
}

; ================================================================================================================================================== ;
; == Resizer functions ============================================================================================================================= ;
; ================================================================================================================================================== ;

ResizeWindow() {
	Widths  := [ 1024, 1280, 1366 ]
	Heights := [  540,  576,  720 ]

	WinGetPos,,, Width, Height, A

	If(Width == Widths[2] And Height == Heights[2]) {
		WinMove, A,,,, Widths[3], Heights[3]
	} Else If(Width == Widths[1] And Height == Heights[1]) {
		WinMove, A,,,, Widths[2], Heights[2]
	} Else {
		WinMove, A,,,, Widths[1], Heights[1]
	}
}

; ================================================================================================================================================== ;
; == Mover functions =============================================================================================================================== ;
; ================================================================================================================================================== ;

CornerWindow(location) {
    WinGet, maximized, MinMax, A

    If(maximized != 1) {
        SysGet, monCount, MonitorCount
        WinGetPos, winX, winY, winW, winH, A

        curBaseX := winX + winW / 2
        curBaseY := winY + winH / 2
        curMonNo := GetMonitorNumber(curBaseX, curBaseY, winX, winY, monCount)
		curMonWH := GetMonitorWorkArea(curMonNo)

        SysGet, curMon, Monitor, %curMonNo%

		If(location == "TopLeft") {
            newWinX := curMonLeft - WinTenPadding
            newWinY := curMonTop
            If(winX == 0 - WinTenPadding && winY == 0) {
                newWinX += 100 - WinTenPadding
                newWinY += 100
            }
        } Else If(location == "TopRight") {
            newWinX := curMonWH[1] - winW + curMonLeft + WinTenPadding
            newWinY := curMonTop
            If(winX == curMonWH[1] - winW + WinTenPadding && winY == 0) {
                newWinX -= 100 + WinTenPadding
                newWinY += 100
            }
        } Else If(location == "BottomLeft") {
            newWinX := curMonLeft - WinTenPadding
            newWinY := curMonWH[2] - winH + curMonTop + WinTenPadding
            If(winX == 0 - WinTenPadding && winY == curMonWH[2] - winH + WinTenPadding) {
                newWinX += 100 - WinTenPadding
                newWinY -= 100 + WinTenPadding
            }
        } Else If(location == "BottomRight") {
            newWinX := curMonWH[1] - winW + curMonLeft + WinTenPadding
            newWinY := curMonWH[2] - winH + curMonTop + WinTenPadding
            If(winX == curMonWH[1] - winW + WinTenPadding && winY == curMonWH[2] - winH + WinTenPadding) {
                newWinX -= 100 + WinTenPadding
                newWinY -= 100 + WinTenPadding
            }
        }

        WinMove, A,, newWinX, newWinY
    }

    Return
}

MoveWindow(direction) {
    SysGet, monCount, MonitorCount
    WinGet, maximized, MinMax, A
    WinGetPos, winX, winY, winW, winH, A

    curBaseX := winX + winW / 2
    curBaseY := winY + winH / 2
    curMonNo := GetMonitorNumber(curBaseX, curBaseY, winX, winY, monCount)
	curMonWH := GetMonitorWorkArea(curMonNo)

    SysGet, curMon, Monitor, %curMonNo%

	; If centering window, no need to do monitor checks.
	If(direction == "Center") {
		If(maximized != 1) {
			newWinX := (curMonWH[1] - winW) / 2 + curMonLeft
			newWinY := (curMonWH[2] - winH) / 2 + curMonTop

			WinMove, A,, newWinX, newWinY
		}

		Return
	}

    ; Check for monitor in corresponding direction.
    If(direction == "Right") {
        tmpWinX := curBaseX + curMonWH[1]
        tmpWinY := curBaseY
    } Else If(direction == "Left") {
        tmpWinX := curBaseX - curMonWH[1]
        tmpWinY := curBaseY
    } Else If(direction == "Up") {
        tmpWinX := curBaseX
        tmpWinY := curBaseY - curMonWH[2]
    } Else If(direction == "Down") {
        tmpWinX := curBaseX
        tmpWinY := curBaseY + curMonWH[2]
    }

	; Move to new monitor. If not found, re-align in current monitor.
    If(DoesMonitorExist(tmpWinX, tmpWinY, monCount) == True) {
		; Maximized windows are -4X, -4Y of their current monitor. Account for this here.
		If(maximized == 1) {
            winX := winX + 4
            winY := winY + 4
        }

		If(direction == "Right") {
            newBaseX := curBaseX + curMonWH[1]
            newBaseY := curBaseY
        } Else If(direction == "Left") {
            newBaseX := curBaseX - curMonWH[1]
            newBaseY := curBaseY
        } Else If(direction == "Up") {
            newBaseX := curBaseX
            newBaseY := curBaseY - curMonWH[2]
        } Else If(direction == "Down") {
            newBaseX := curBaseX
            newBaseY := curBaseY + curMonWH[2]
        }

		newMonNo := GetMonitorNumber(newBaseX, newBaseY, Null, Null, monCount)
        newWinX  := ReAlignX(newMonNo, curMonWH, direction, winX, winW)
        newWinY  := ReAlignY(curMonNo, newMonNo, curMonWH, direction, winY, winH)

        If(maximized == 1) {
            WinRestore, A
            WinMove, A,, newWinX, newWinY
            WinMaximize, A
        } Else {
            WinMove, A,, newWinX, newWinY
        }
    } Else {
		If(maximized != 1) {
			newWinX := ReAlignX(curMonNo, curMonWH, direction, winX, winW)
			newWinY := ReAlignY(curMonNo, curMonNo, curMonWH, direction, winY, winH)

			WinMove, A,, newWinX, newWinY
		}
    }
}

; ================================================================================================================================================== ;
; == Auxiliary functions =========================================================================================================================== ;
; ================================================================================================================================================== ;

GetMonitorNumber(curBaseX, curBaseY, winX, winY, monCount) {
    Loop %monCount% {
        SysGet, tmpMon, Monitor, %A_Index%
        If(curBaseX >= tmpMonLeft And curBaseX <= tmpMonRight And curBaseY >= tmpMonTop And curBaseY <= tmpMonBottom) {
            Return A_Index
        }
    }

	; If we couldn't find a monitor through the assumed X/Y, check by window X/Y.
	Loop %monCount% {
		SysGet, tmpMon, Monitor, %A_Index%
		If(winX >= tmpMonLeft And winX <= tmpMonRight And winY >= tmpMonTop And winY <= tmpMonBottom) {
			Return A_Index
		}
	}

    Return monCount
}

GetMonitorWorkArea(monToGet) {
    SysGet, tmpMon, MonitorWorkArea, %monToGet%

    Return [ tmpMonRight - tmpMonLeft, tmpMonBottom - tmpMonTop ]
}

DoesMonitorExist(newWinX, newWinY, monCount) {
    Loop %monCount% {
        SysGet, tmpMon, Monitor, %A_Index%
        If(newWinX >= tmpMonLeft And newWinX <= tmpMonRight And newWinY >= tmpMonTop And newWinY <= tmpMonBottom) {
			Return True
        }
    }

    Return False
}

ReAlignX(newMonNo, curMonWH, direction, winX, winW) {
	SysGet, newMon, Monitor, %newMonNo%
	newMonWidth := GetMonitorWorkArea(newMonNo)[1]

	If(direction == "Right") {
		If(winX + winW + curMonWH[1] > newMonRight) {
			newWinX := newMonRight - winW + WinTenPadding
		} Else If(winX + curMonWH[1] < newMonLeft) {
			newWinX := newMonLeft + WinTenPadding
		} Else {
			newWinX := winX + newMonWidth + WinTenPadding
		}
	} Else If(direction == "Left") {
		If(winX - curMonWH[1] < newMonLeft) {
			newWinX := newMonLeft - WinTenPadding
		} Else If(winX + winW - curMonWH[1] > newMonRight) {
			newWinX := newMonRight - winW - WinTenPadding
		} Else {
			newWinX := winX - newMonWidth - WinTenPadding
		}
	} Else If(direction == "Up" Or direction == "Down") {
		If(winX < newMonLeft) {
			newWinX := newMonLeft
		} Else If(winX + winW > newMonWidth + newMonLeft) {
			newWinX := newMonWidth + newMonLeft - winW
		} Else {
			newWinX := winX
		}
	}

	Return newWinX
}

ReAlignY(curMonNo, newMonNo, curMonWH, direction, winY, winH) {
	SysGet, curMon, Monitor, %curMonNo%
	SysGet, newMon, Monitor, %newMonNo%
	newMonHeight := GetMonitorWorkArea(newMonNo)[2]

	If(direction == "Right" Or direction == "Left") {
		If(winY < newMonTop) {
			newWinY := newMonTop
		} Else If(winY + winH > newMonHeight + newMonTop) {
			newWinY := newMonHeight + newMonTop - winH
		} Else {
			newWinY := winY
		}
	} Else If(Direction == "Up") {
		If(winY - curMonWH[2] < newMonTop) {
			newWinY := newMonTop
		} Else If(winY + winH - curMonWH[2] > newMonTop + newMonHeight) {
			newWinY := newMonTop + newMonHeight - winH
		} Else {
			newWinY := winY - newMonHeight
		}
	} Else If(Direction == "Down") {
		bottomPadding := curMonBottom - curMonTop - newMonHeight - WinTenPadding
		If(winY + winH + curMonWH[2] > newMonBottom) {
			newWinY := newMonBottom - winH - bottomPadding
		} Else If(winY + curMonWH[2] < newMonTop) {
			newWinY := newMonTop + bottomPadding
		} Else {
			newWinY := winY + newMonHeight + bottomPadding
		}
	}

	Return newWinY
}