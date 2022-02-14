#SingleInstance Force
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%

; ================================================================================================================================================== ;
; == Global Variables ============================================================================================================================== ;
; ================================================================================================================================================== ;

Global NULL
Global WIN_TEN_PADDING := 8

; ================================================================================================================================================== ;
; == General Hotkeys =============================================================================================================================== ;
; ================================================================================================================================================== ;

; Ctrl + H: Toggle show hidden files
^H::
	If(WinActive("AHK_Class CabinetWClass")) {
		RegPath := "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced"
        RegRead, HiddenStatus, HKEY_CURRENT_USER, %RegPath%, Hidden
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, %RegPath%, Hidden, % HiddenStatus == 1 ? 2 : 1
		Sleep, 125
        Send {F5}
	}
    Return

; Ctrl + Shift + H: Toggle show system files
^+H::
    If(WinActive("AHK_Class CabinetWClass")) {
		RegPath := "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced"
        RegRead, SuperHiddenStatus, HKEY_CURRENT_USER, %RegPath%, ShowSuperHidden
		RegWrite, REG_DWORD, HKEY_CURRENT_USER, %RegPath%, ShowSuperHidden, % SuperHiddenStatus == 0 ? 1 : 0
        Sleep, 125
		Send, {F5}
    }
    Return

; Ctrl + Alt + Shift + N: Toggle hidden status of selected files.
^!+N::
	If(WinActive("AHK_Class CabinetWClass")) {
		Send ^c
		ClipWait
		Loop, Parse, Clipboard, \n, \r
			FileSetAttrib, ^H, % A_LoopField
		Sleep, 125
		Send {F5}
	}	
	Return

; ================================================================================================================================================== ;
; == Media Controls ================================================================================================================================ ;
; ================================================================================================================================================== ;

; Ctrl + Alt + Shift + Hotkey: Execute specified shortcut.
^!+Left::Send {Media_Prev}
^!+Right::Send {Media_Next}
^!+Space::Send {Media_Play_Pause}

; ================================================================================================================================================== ;
; == Program Launchers ============================================================================================================================= ;
; ================================================================================================================================================== ;

; Ctrl + Alt + Shift + Hotkey: Launch specified program.
^!+L::Run %A_ProgramsCommon%/Windows PowerShell/x64/PowerShell
^!+H::Run %A_MyDocuments%/Git/ahk/Scripts/Hotkeys/
^!+A::Run %A_MyDocuments%/Git/ahk/Scripts/OSRS/
^!+K::Run %A_ProgramFiles%/KeePassXC/KeePassXC
^!+I::Run firefox -P profile
^!+M::Run firefox -P minimal
^!+U::Run putty -load "super local"
^!+J::Run putty -load "super remote"
^!+P::Run putty
^!+O::Run debian
^!+S::Run mmsys.cpl
^!+Z::Run ms-settings:apps-volume

; ================================================================================================================================================== ;
; == Cursor Shifters =============================================================================================================================== ;
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
; == Window Operations ============================================================================================================================= ;
; ================================================================================================================================================== ;

; Ctrl + Alt + Shift + Up/Down: Minimize or restore a window
^#Down::MinimizeWindow()
^#Up::RestoreWindow()

; LWin + Subtract: Set dimensions of active window.
<#-::
<#NumpadSub::ResizeWindow()

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
; == Functions ===================================================================================================================================== ;
; ================================================================================================================================================== ;

; Move cursor by one pixel in direction specified.
PixelStep(dx := 0, dy := 0) {
    MouseGetPos, x, y
    MouseMove, x + dx, y + dy
}

; Minimize active window
MinimizeWindow() {
	Global
	WinGetPos, mwX, mwY, mwW, mwH, A
	WinMinimize, A
	MinmizedWindowPID := WinActive("A")
}

; Restore minimized window
RestoreWindow() {
	Global
	WinRestore, ahk_id %MinmizedWindowPID%
	WinMove, ahk_id %MinmizedWindowPID%,, mwX, mwY, mwW, mwH
}

; Resize active window by cycling through pre-defined dimensions.
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

; Move active window to specified corner of current display.
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
            newWinX := curMonLeft - WIN_TEN_PADDING
            newWinY := curMonTop
            If(winX == 0 - WIN_TEN_PADDING && winY == 0) {
                newWinX += 100 - WIN_TEN_PADDING
                newWinY += 100
            }
        } Else If(location == "TopRight") {
            newWinX := curMonWH[1] - winW + curMonLeft + WIN_TEN_PADDING
            newWinY := curMonTop
            If(winX == curMonWH[1] - winW + WIN_TEN_PADDING && winY == 0) {
                newWinX -= 100 + WIN_TEN_PADDING
                newWinY += 100
            }
        } Else If(location == "BottomLeft") {
            newWinX := curMonLeft - WIN_TEN_PADDING
            newWinY := curMonWH[2] - winH + curMonTop + WIN_TEN_PADDING
            If(winX == 0 - WIN_TEN_PADDING && winY == curMonWH[2] - winH + WIN_TEN_PADDING) {
                newWinX += 100 - WIN_TEN_PADDING
                newWinY -= 100 + WIN_TEN_PADDING
            }
        } Else If(location == "BottomRight") {
            newWinX := curMonWH[1] - winW + curMonLeft + WIN_TEN_PADDING
            newWinY := curMonWH[2] - winH + curMonTop + WIN_TEN_PADDING
            If(winX == curMonWH[1] - winW + WIN_TEN_PADDING && winY == curMonWH[2] - winH + WIN_TEN_PADDING) {
                newWinX -= 100 + WIN_TEN_PADDING
                newWinY -= 100 + WIN_TEN_PADDING
            }
        }

        WinMove, A,, newWinX, newWinY
    }

    Return
}

; Move active window to specified edge of current display.
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
; == Auxiliary Functions =========================================================================================================================== ;
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
			newWinX := newMonRight - winW + WIN_TEN_PADDING
		} Else If(winX + curMonWH[1] < newMonLeft) {
			newWinX := newMonLeft + WIN_TEN_PADDING
		} Else {
			newWinX := winX + newMonWidth + WIN_TEN_PADDING
		}
	} Else If(direction == "Left") {
		If(winX - curMonWH[1] < newMonLeft) {
			newWinX := newMonLeft - WIN_TEN_PADDING
		} Else If(winX + winW - curMonWH[1] > newMonRight) {
			newWinX := newMonRight - winW - WIN_TEN_PADDING
		} Else {
			newWinX := winX - newMonWidth - WIN_TEN_PADDING
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
		bottomPadding := curMonBottom - curMonTop - newMonHeight - WIN_TEN_PADDING
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