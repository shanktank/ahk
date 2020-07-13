#SingleInstance FORCE
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
    #IfWinActive AHK_Class CabinetWClass
        RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, Hidden
        If(HiddenFiles_Status = 2)
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, Hidden, 1
        Else
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, Hidden, 2
        Send {F5}
    #IfWinActive
    Return

; Ctrl + Shift + H: Toggle show system files
^+H::
    #IfWinActive AHK_Class CabinetWClass
        RegRead, SuperHidden, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, ShowSuperHidden
        If(SuperHidden = 0)
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, ShowSuperHidden, 1
        Else
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, ShowSuperHidden, 0
        Send {F5}
    #IfWinActive
    Return

; ================================================================================================================================================== ;
; == Launchers ===================================================================================================================================== ;
; ================================================================================================================================================== ;

; Ctrl + Alt + Shift + P: Launch PuTTY.
^!+P::
    Run putty
    Return

; Ctrl + Alt + Shift + U: Launch SSH session "Super".
^!+U::
    Run putty -load "super remote"
    Return

; Ctrl + Alt + Shift + J: Launch SSH session "Super".
^!+J::
    Run putty -load "super local"
    Return

; Ctrl + Alt + Shift + O: Open Debian terminal.
^!+O::
    Run debian
    Return

; Ctrl + Alt + Shift + L: Open PowerShell terminal.
^!+L::
    Run "C:/Users/User/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Windows PowerShell/PowerShell"
    Return

; Ctrl + Alt + Shift + M: Open Firefox.
^!+M::
    Run "C:/Program Files/Mozilla Firefox/firefox.exe"
    Return

; Ctrl + Alt + Shift + K: Open KeePassX.
^!+K::
    Run "C:/Users/User/Documents/KeePassX/KeePassX.exe"
    Return

; Ctrl + Alt + Shift + H: Open File Explorer to "Hotkeys" directory.
^!+H::
    Run "C:/Users/User/Documents/Git/ahk/Scripts/Hotkeys/"
    Return

; Ctrl + Alt + Shift + A: Open File Explorer to "OSRS" AHK directory.
^!+A::
    Run "C:/Users/User/Documents/Git/ahk/Scripts/OSRS/"
    Return

; Ctrl + Alt + Shift + S: Open sound options
^!+S::
    Run Control mmsys.cpl Sounds
    Return

; ================================================================================================================================================== ;
; == Resizers ====================================================================================================================================== ;
; ================================================================================================================================================== ;

; LWin + Subtract: Set dimensions of active window.
<#-::
<#NumpadSub::
	ResizeWindow()
    Return

; ================================================================================================================================================== ;
; == Shifters ====================================================================================================================================== ;
; ================================================================================================================================================== ;

; Ctrl + Win + 5: Left mouse button down.
^#5::
^#Numpad5::
    Click Down
    Return

; Ctrl + Win + 0: Left mouse button up.
^#0::
^#Numpad0::
    Click Up
    Return

; Ctrl + Win + 4: Move cursor left by one pixel.
^#4::
^#Numpad4::
    MouseGetPos, x, y
    MouseMove, x - 1, y
    Return

; Ctrl + Win + 6: Move cursor right by one pixel.
^#6::
^#Numpad6::
    MouseGetPos, x, y
    MouseMove, x + 1, y
    Return

; Ctrl + Win + 2: Move cursor down by one pixel.
^#2::
^#Numpad2::
    MouseGetPos, x, y
    MouseMove, x, y + 1
    Return

; Ctrl + Win + 8: Move cursor up by one pixel.
^#8::
^#Numpad8::
    MouseGetPos, x, y
    MouseMove, x, y - 1
    Return

; ================================================================================================================================================== ;
; == Movers ======================================================================================================================================== ;
; ================================================================================================================================================== ;

; LWin + 4: Move active window one monitor to the left.
<#4::
<#Numpad4::
<#NumpadLeft::
    MoveWindow("Left")
    Return

; LWin + 6: Move active window one monitor to the right.
<#6::
<#Numpad6::
<#NumpadRight::
    MoveWindow("Right")
    Return

; LWin + 8: Move active window one monitor up.
<#8::
<#Numpad8::
<#NumpadUp::
    MoveWindow("Up")
    Return

; LWin + 2: Move active window one monitor down.
<#2::
<#Numpad2::
<#NumpadDown::
    MoveWindow("Down")
    Return

; LWin + 5: Center active window.
<#5::
<#Numpad5::
<#NumpadClear::
    MoveWindow("Center")
    Return

; LWin + 1: Move active window to the bottom-left corner.
<#1::
<#Numpad1::
<#NumpadEnd::
    CornerWindow("BottomLeft")
    Return

; LWin + 3: Move active window to the bottom-right corner.
<#3::
<#Numpad3::
<#NumpadPgDn::
    CornerWindow("BottomRight")
    Return

; LWin + 7: Move active window to the top-left corner.
<#7::
<#Numpad7::
<#NumpadHome::
    CornerWindow("TopLeft")
    Return

; LWin + 9: Move active window to the top-right corner.
<#9::
<#Numpad9::
<#NumpadPgUp::
    CornerWindow("TopRight")
    Return

; ================================================================================================================================================== ;
; == Resizer functions ============================================================================================================================= ;
; ================================================================================================================================================== ;

ResizeWindow() {
	WinGetPos,,, Width, Height, A

	Widths  := [ 1024, 1280, 1366 ]
	Heights := [ 540,   576,  720 ]

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
            newWinX := curMonLeft
            newWinY := curMonTop
            If(winX == 0 && winY == 0) {
                newWinX += 100
                newWinY += 100
            }
        } Else If(location == "TopRight") {
            newWinX := curMonWH[1] - winW + curMonLeft
            newWinY := curMonTop
            If(winX == curMonWH[1] - winW && winY == 0) {
                newWinX -= 100
                newWinY += 100
            }
        } Else If(location == "BottomLeft") {
            newWinX := curMonLeft
            newWinY := curMonWH[2] - winH + curMonTop
            If(winX == 0 && winY == curMonWH[2] - winH) {
                newWinX += 100
                newWinY -= 100
            }
        } Else If(location == "BottomRight") {
            newWinX := curMonWH[1] - winW + curMonLeft
            newWinY := curMonWH[2] - winH + curMonTop
            If(winX == curMonWH[1] - winW && winY == curMonWH[2] - winH) {
                newWinX -= 100
                newWinY -= 100
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

		newMonNo := GetMonitorNumber(newBaseX, newBaseY, NULL, NULL, monCount)
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

	Loop %monCount% { ; If we couldn't find a monitor through the assumed X/Y, check by window X/Y.
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