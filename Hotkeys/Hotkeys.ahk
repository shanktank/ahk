#SingleInstance FORCE
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir %A_ScriptDir%

; ================================================================================================================================================== ;
; == Globals ======================================================================================================================================= ;
; ================================================================================================================================================== ;

;Static Global MONITORS := { "left" : 3, "center" : 2, "right" : 1 }
;GetMonitors()
Global NULL =

; ================================================================================================================================================== ;
; == Hotkeys ======================================================================================================================================= ;
; ================================================================================================================================================== ;

; Ctrl + H: Toggle hidden files
^h::
    #IfWinActive AHK_Class CabinetWClass
        RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, Hidden
        If(HiddenFiles_Status = 2) {
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, Hidden, 1
        } Else {
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, Hidden, 2
		}
        Send {F5}
    #IfWinActive
    Return

; Ctrl + Shift + H: Toggle hidden system files
^+h::
    #IfWinActive AHK_Class CabinetWClass
        RegRead, SuperHidden, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, ShowSuperHidden
        If(SuperHidden = 0) {
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, ShowSuperHidden, 1
        } Else {
            RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced, ShowSuperHidden, 0
		}
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
    Run putty -load super
    Return

; Ctrl + Alt + Shift + O: Launch SSH session "Tiny".
^!+O::
    Run putty -load tiny
    Return

; Ctrl + Alt + Shift + H: Open File Explorer to "Hotkeys" directory.
^!+H::
    ;Run D:\\Documents\\Software\\Applications\\Hotkeys\\
	Run C:\\Users\\User\\Documents\\AHK\\
    Return

; Ctrl + Alt + Shift + A: Open File Explorer to "AHK" directory.
^!+A::
    ;Run D:\\Documents\\Stuff\\AHK\\
    Run Z:\\Documents\\AHK\\
	Return

; Ctrl + Alt + Shift + S: Open sound options
^!+S::
	Run control mmsys.cpl sounds
	Return

; Win + E: Open File Explorer, centered on main monitor
<#E::
	; If there's already an explorer opened to "Computer" or "C:\" then abort
	If(WinExist("AHK_Class CabinetWClass", "Computer")) {
		WinGet, winID, ID, AHK_Class CabinetWClass, Computer
		If(ExplorerCurrentDirectory(winID) == "C:") {
			Return
		}
	}
	; Get current window handle, open file explorer, then wait until former window is not active
	activeWindow := "ahk_id " WinExist("a")
	Run shell:mycomputerfolder
	WinWaitNotActive, %activeWindow%, , 5
	; Scan for desired window
	Loop, 100 {
		; If new window's type is File Explorer and is named "Computer"
		#IfWinActive AHK_Class CabinetWClass && #IfWinActive Computer
			; Get primary monitor dimensions
			SysGet, primaryMonitor, MonitorPrimary
			halfPrimMonW := GetMonitorWorkArea("width", primaryMonitor) / 2
			halfPrimMonH := GetMonitorWorkArea("height", primaryMonitor) / 2
			; Get window dimensions, calculate its new coordinates, move it, then Return
			WinGetActiveStats, Computer, W, H, _, _
			WinMove, , Computer, halfPrimMonW - W / 2, halfPrimMonH - H / 2
			Return
		#IfWinActive
		Sleep, 10
	}
	Return

; ================================================================================================================================================== ;
; == Resizers ====================================================================================================================================== ;
; ================================================================================================================================================== ;

; LWin + Subtract: Set dimensions of active window.
<#-::
<#NumpadSub::
	WinGetTitle, Window, A
	WinMove, %Window%, , , , 1366, 768
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
        
        WinMove, A, , newWinX, newWinY
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
        
        WinMove, A, , newWinX, newWinY
    }
    
    Return
}

MoveWindow(direction) {
    SysGet, monCount, MonitorCount
    WinGetPos, winX, winY, winW, winH, A
    WinGet, mm, MinMax, A
    
    baseX := winx + winw / 2
    baseY := winy + winh / 2
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
    
	If(monitorExists = "true") { ; Move to new monitor.
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
		gosub ReAlignX
		gosub ReAlignY
		
		If(mm = 1) {
			WinRestore, A
			WinMove, A,, newWinX, newWinY
			WinMaximize, A
		} Else {
			WinMove, A,, newWinX, newWinY
		}
	} Else If(monitorExists = "false") { ; New monitor not found, re-align in current monitor.
		monForReAlign := curMonNum
		
		gosub ReAlignX
		gosub ReAlignY
		
		WinMove, A,, newWinX, newWinY
	}
    
    Return
    
    ; ReAlignX and ReAlignY work to keep the window in a monitor.
    ReAlignX:
    {
        If(direction = "Right") {
            SysGet, newMon, Monitor, %monForReAlign%
            newMonWidth := GetMonitorWorkArea("width", monForReAlign)
            ; Adjust by setup, not fully tested.
            padding := 0 ; curMonRight - curMonLeft - newMonWidth
            
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
            ; Adjust by setup, not fully tested.
            padding := 0 ; curMonRight - curMonLeft - newMonWidth
            
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

ValidWindow() {
    exclude := ",Start,Program Manager,Sticky Notes,Vol_OSD"
    WinGet, windows, List
    Total := 0
    
    Loop, %windows% {
        id := windows%A_Index%
        
        WinGetTitle, Title, ahk_id %id%
        
        If Title In %exclude%
            continue
        
        WinGet, Min_Max, MinMax, ahk_id %id%
        
        If(Min_Max = 1 || Min_Max = 0)
            Return 1
    }
    
    Return 0
}

GetMonitorNumber(baseX, baseY, winX, winY, monCount) {
    i := 0
    monFound := 0

    Loop %monCount% {
        i := i + 1
        SysGet, tmpMon, Monitor, %i%
        If(baseX >= tmpMonLeft and baseX <= tmpMonRight and baseY >= tmpMonTop and baseY <= tmpMonBottom) {
            monFound := i
        }
    }
    
    ; If we couldn't find a monitor through the assumed X/Y, check by window X/Y.
    If(monFound = 0) {
        i := 0
        Loop %monCount% {   
            i := i + 1
            SysGet, tmpMon, Monitor, %i%
            If(winX >= tmpMonLeft and winX <= tmpMonRight and winY >= tmpMonTop and winY <= tmpMonBottom) {
                monFound := i
            }
        }
    }
    
    Return monFound
}

GetMonitorWorkArea(measurement, monToGet) {
    SysGet, tmpMon, MonitorWorkArea, %monToGet%
    
    If(measurement = "width") {
        tmpMonWidth := tmpMonRight - tmpMonLeft
        Return tmpMonWidth
    } Else If(measurement = "height") {
        tmpMonHeight := tmpMonBottom - tmpMonTop
        Return tmpMonHeight
    }
    
    Return
}

DoesMonitorExist(newWinX, newWinY, monCount) {
    monitorFound = false
    i := 0

    Loop %monCount% {   
        i := i + 1
        SysGet, tmpMon, Monitor, %i%
        If(newWinX >= tmpMonLeft and newWinX <= tmpMonRight and newWinY >= tmpMonTop and newWinY <= tmpMonBottom) {
            monitorFound = true
            Break
        }
    }
    
    Return monitorFound
}

ExplorerCurrentDirectory(winID = "") {
	WinGet, process, processName, % "ahk_id" winID := winID ? winID : WinExist("A")
	WinGetClass winClass, ahk_id %winID%
	If(process = "explorer.exe") {
		If(winClass ~= "(Cabinet|Explore)WClass") {
			For win In ComObjCreate("Shell.Application").Windows {
				If(win.hwnd == winID) {
					path := win.Document.FocusedItem.path
				}
			}
			SplitPath, path,,dir
		}
		Return dir
	}
	Return
}

GetIndex(haystack, needle) {
	If(!IsObject(haystack)) {
		Throw Exception("Bad haystack!", -1, haystack)
	}

    For index, value In haystack {
        If(value = needle) {
            Return index
		}
	}
	
    Return -1
}

JoinArray(arrayToJoin, elementSeparator = " ") {
	joinedString := ""
	
	For elementIndex, arrayElement In arrayToJoin {
		joinedString .= arrayElement . elementSeparator
	}
	
	Return joinedString
}

GetMonitors() {
	CoordMode, ToolTip, Screen
	
	MsgBox % GetMonitorNumber(0, 0, 0, 0, 3)
	Return
	
	SysGet, monCount, MonitorCount
	monLefts := [ ]
	
	monNum := 1
	Loop %monCount% {
		SysGet, Mon, Monitor, %monNum%
		;MsgBox % "MonLeft: " MonLeft
		monLefts.Push(MonLeft)
		monNum := monNum + 1
	}
	;monNum := 1
	;Loop %monCount% {
	;	MsgBox % monLefts[monNum]
	;	monNum := monNum + 1
	;}
	;Return
	monNums := [ ]
	While(monLefts.Length() > 0) {
		minLeft := Min(monLefts*)
		minLeftIndex := GetIndex(monLefts, minLeft)
		;MsgBox % "monLefts.Length(): " monLefts.Length() " -- monLefts[minLeftIndex]: " monLefts[minLeftIndex] " -- minLeftIndex: " minLeftIndex
		monNums.Push(monLefts[minLeftIndex])
		monLefts.Remove(minLeftIndex)
	}
	MsgBox % "monNums.Length(): " monNums.Length()
	monNum := 1
	;Loop %monCount% {
	;	MsgBox % "monNums[monNum]: " monNums[monNum]
	;	monNum := monNum + 1
	;}
	monNumsStr := ""
	delim := " "
	For index, monNum In monNums
		monNumsStr .= delim . monNum
	MsgBox % "monNumsStr: " monNumsStr
	;For monNum in monNums {
	;	MsgBox % "monNum: " monNum
	;}
	Return
	
	;SysGet, Mon1, Monitor, 1
	;SysGet, Mon2, Monitor, 2
	;SysGet, Mon3, Monitor, 3
	;MsgBox, 1: %Mon1Left%   2: %Mon2Left%   3: %Mon3Left%
	
	mons := [ Mon1, Mon2, Mon3 ]
	lefts := [ Mon1Left, Mon2Left, Mon3Left ]
	
	monitors = []
	While(lefts.Length() > 0) { ; or lefts.Count()?
		min1 := Min(lefts*)
		index := GetIndex(lefts, min1)
		monitors.Push(mons[1])
		mons.Delete(1)
		lefts.Delete(1)
	}
	MsgBox, %monitors%
	Return
	
	;If(Mon3Left > 1920)
	;	leftMon := 1
	;Else If(Mon3Left < 0)
	;	leftMon := 3
	;Else
	;	leftMon := 2
	
	;SysGet, primaryMonitor, MonitorPrimary
	;monitors := { "left" : 3, "center" : primaryMonitor, "right" : 1 }
}