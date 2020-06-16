#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%

; ================================================================================================================================================== ;
; == Globals ======================================================================================================================================= ;
; ================================================================================================================================================== ;

Global NULL =

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

; Ctrl + Alt + Shift + O: Open Debian terminal.
^!+O::
    Run debian
    Return

; Ctrl + Alt + Shift + P: Launch PuTTY.
^!+P::
    Run putty
    Return

; Ctrl + Alt + Shift + U: Launch SSH session "Super".
^!+U::
    Run putty -load super
    Return

; Ctrl + Alt + Shift + O: Open PowerShell terminal.
^!+L::
    Run "C:/Users/User/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Windows PowerShell/PowerShell"
    Return

; Ctrl + Alt + Shift + I: Open Firefox.
^!+I::
    Run "C:/Program Files/Mozilla Firefox/firefox.exe"
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
    CenterWindow()
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
    WinGetTitle, Window, A
	WinGetPos,,, Width, Height, A

	Widths := [ 1024, 1280, 1366 ]
	Heights := [ 540, 576, 720 ]

	If(Width == Widths[2] And Height == Heights[2]) {
		WinMove, %Window%,,,, Widths[3], Heights[3]
	} Else If(Width == Widths[1] And Height == Heights[1]) {
		WinMove, %Window%,,,, Widths[2], Heights[2]
	} Else {
		WinMove, %Window%,,,, Widths[1], Heights[1]
	}
}

; ================================================================================================================================================== ;
; == Mover functions =============================================================================================================================== ;
; ================================================================================================================================================== ;

CenterWindow() {
    WinGet, mm, MinMax, A

    If(mm != 1) {
        SysGet, monCount, MonitorCount
        WinGetPos, winX, winY, winW, winH, A

        baseX := winX + winW / 2
        baseY := winY + winH / 2
		
        curMonNum := GetMonitorNumber(baseX, baseY, winX, winY, monCount)
        curMonWidth := GetMonitorWorkArea("width", curMonNum)
        curMonHeight := GetMonitorWorkArea("height", curMonNum)
		
        SysGet, curMon, Monitor, %curMonNum%

        newWinX := (curMonWidth - winW) / 2 + curMonLeft
        newWinY := (curMonHeight - winH) / 2 + curMonTop
		
        WinMove, A,, newWinX, newWinY
    }

    Return
}

CornerWindow(location) {
    WinGet, mm, MinMax, A

    If(mm != 1) {
        SysGet, monCount, MonitorCount
        WinGetPos, winX, winY, winW, winH, A

        baseX := winX + winW / 2
        baseY := winY + winH / 2
		
        curMonNum := GetMonitorNumber(baseX, baseY, winX, winY, monCount)
        curMonWidth := GetMonitorWorkArea("width", curMonNum)
        curMonHeight := GetMonitorWorkArea("height", curMonNum)
		
        SysGet, curMon, Monitor, %curMonNum%

        If(location = "TopLeft") {
            newWinX := curMonLeft
            newWinY := curMonTop
            If(winX = 0 && winY = 0) {
                newWinX += 100
                newWinY += 100
            }
        } Else If(location = "TopRight") {
            newWinX := curMonWidth - winW + curMonLeft
            newWinY := curMonTop
            If(winX = curMonWidth - winW && winY = 0) {
                newWinX -= 100
                newWinY += 100
            }
        } Else If(location = "BottomLeft") {
            newWinX := curMonLeft
            newWinY := curMonHeight - winH + curMonTop
            If(winX = 0 && winY = curMonHeight - winH) {
                newWinX += 100
                newWinY -= 100
            }
        } Else If(location = "BottomRight") {
            newWinX := curMonWidth - winW + curMonLeft
            newWinY := curMonHeight - winH + curMonTop
            If(winX = curMonWidth - winW && winY = curMonHeight - winH) {
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
    WinGetPos, winX, winY, winW, winH, A
    WinGet, mm, MinMax, A

    baseX := winX + winW / 2
    baseY := winY + winH / 2
	
    curMonNum := GetMonitorNumber(baseX, baseY, winX, winY, monCount)
    curMonWidth := GetMonitorWorkArea("width", curMonNum)
    curMonHeight := GetMonitorWorkArea("height", curMonNum)
	
    SysGet, curMon, Monitor, %curMonNum%

    ; Check for monitor in corresponding direction.
    If(direction = "Right") {
        tmpWinX := baseX + curMonWidth
        tmpWinY := baseY
    } Else If(direction = "Left") {
        tmpWinX := baseX - curMonWidth
        tmpWinY := baseY
    } Else If(direction = "Up") {
        tmpWinX := baseX
        tmpWinY := baseY - curMonHeight
    } Else If(direction = "Down") {
        tmpWinX := baseX
        tmpWinY := baseY + curMonHeight
    }
	
    monitorExists := DoesMonitorExist(tmpWinX, tmpWinY, monCount)
    If(monitorExists == True) { ; Move to new monitor.
        If(mm = 1) { ; Maximized windows are -4x + -4y of their current monitor. Account for this here.
            winX := winX + 4
            winY := winY + 4
        } If(direction = "Right") {
            newBaseX := baseX + curMonWidth
            newBaseY := baseY
            monForReAlign := GetMonitorNumber(newBaseX, newBaseY, NULL, NULL, monCount)
        } Else If(direction = "Left") {
            newBaseX := baseX - curMonWidth
            newBaseY := baseY
            monForReAlign := GetMonitorNumber(newBaseX, newBaseY, NULL, NULL, monCount)
        } Else If(direction = "Up") {
            newBaseX := baseX
            newBaseY := baseY - curMonHeight
            monForReAlign := GetMonitorNumber(newBaseX, newBaseY, NULL, NULL, monCount)
        } Else If(direction = "Down") {
            newBaseX := baseX
            newBaseY := baseY + curMonHeight
            monForReAlign := GetMonitorNumber(newBaseX, newBaseY, NULL, NULL, monCount)
        }

        Gosub ReAlignX
        Gosub ReAlignY

        If(mm = 1) {
            WinRestore, A
            WinMove, A,, newWinX, newWinY
            WinMaximize, A
        } Else {
            WinMove, A,, newWinX, newWinY
        }
    } Else If(monitorExists == False) { ; New monitor not found, re-align in current monitor.
        monForReAlign := curMonNum

        Gosub ReAlignX
        Gosub ReAlignY

        WinMove, A,, newWinX, newWinY
    }

    Return

    ; ReAlignX and ReAlignY work to keep the window in a monitor.

    ReAlignX:
    {
        If(direction = "Right") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonWidth := GetMonitorWorkArea("width", monForReAlign)
            padding := 0 ; curMonRight - curMonLeft - newMonWidth ; Adjust by setup, not fully tested.

            If((winX + winW + curMonWidth) > newMonRight) {
                newWinX := (newMonRight - winW) + padding
            } Else If((winX + curMonWidth) < newMonLeft) {
                newWinX := newMonLeft + padding
            } Else {
                newWinX := (winX + newMonWidth) + padding
            }
        } Else If(direction = "Left") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonWidth := GetMonitorWorkArea("width", monForReAlign)
            padding := 0 ; curMonRight - curMonLeft - newMonWidth ; Adjust by setup, not fully tested.

            If((winX - curMonWidth) < newMonLeft) {
                newWinX := newMonLeft - padding
            } Else If((winX + winW - curMonWidth) > newMonRight) {
                newWinX := (newMonRight - winW) - padding
            } Else {
                newWinX := (winX - newMonWidth) - padding
            }
        } Else If(direction = "Up" or direction = "Down") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonWidth := GetMonitorWorkArea("width", monForReAlign)

            If(winX < newMonLeft) {
                newWinX := newMonLeft
            } Else If((winX + winW) > (newMonWidth + newMonLeft)) {
                newWinX := (newMonWidth + newMonLeft) - winW
            } Else {
                newWinX := winX
            }
        }
		
        Return
    }

    ReAlignY:
    {
        If(direction = "Right" or direction = "Left") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonHeight := GetMonitorWorkArea("height", monForReAlign)

            If(winY < newMonTop) {
                newWinY := newMonTop
            } Else If((winY + winH) > (newMonHeight + newMonTop)) {
                newWinY := (newMonHeight + newMonTop) - winH
            } Else {
                newWinY := winY
            }
        } Else If(Direction = "Up") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonHeight := GetMonitorWorkArea("height", monForReAlign)
            ; Adjust by setup, not fully tested.
            padding := 0 ; curMonBottom - curMonTop - newMonHeight

            If((winY - curMonHeight) < newMonTop) {
                newWinY := newMonTop + padding
            } Else If((winY + winH - curMonHeight) > (newMonTop + newMonHeight)) {
                newWinY := ((newMonTop + newMonHeight) - winH) - padding
            } Else {
                newWinY := (winY - newMonHeight) - padding
            }
        } Else If(Direction = "Down") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonHeight := GetMonitorWorkArea("height", monForReAlign)
            padding := curMonBottom - curMonTop - newMonHeight

            If((winY + winH + curMonHeight) > newMonBottom) {
                newWinY := (newMonBottom - winH) - padding
            } Else If((winY + curMonHeight) < newMonTop) {
                newWinY := newMonTop + padding
            } Else {
                newWinY := (winY + newMonHeight)  + padding
            }
        }
		
        Return
    }
}

; ================================================================================================================================================== ;
; == Auxiliary functions =========================================================================================================================== ;
; ================================================================================================================================================== ;

GetMonitorNumber(baseX, baseY, winX, winY, monCount) {
    Loop %monCount% {
        SysGet, tmpMon, Monitor, %A_Index%
        If(baseX >= tmpMonLeft And baseX <= tmpMonRight And baseY >= tmpMonTop And baseY <= tmpMonBottom) {
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

GetMonitorWorkArea(measurement, monToGet) {
    SysGet, tmpMon, MonitorWorkArea, %monToGet%
    If(measurement = "width") {
        Return tmpMonRight - tmpMonLeft
    } Else If(measurement = "height") {
        Return tmpMonBottom - tmpMonTop
    }
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
