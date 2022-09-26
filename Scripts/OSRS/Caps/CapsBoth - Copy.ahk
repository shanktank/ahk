#SingleInstance Force
#EscapeChar \
#Persistent
#NoEnv
#Warn

SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx
SetKeyDelay, 0, 1, Play
SendMode, Play

;; TODO: Try Send()
;; TODO: Try Send {Blind}
;; TODO: Try SetStoreCapslockMode, Off
;; TODO: Try https://www.autohotkey.com/docs/commands/Hotkey.htm
;; TODO: Try https://autohotkey.com/board/topic/81090-applying-same-function-over-a-group-of-hotstrings/

^!+R::Reload
Pause::
	Suspend
	contents := A_IsSuspended ? "Disabled" : "Enabled"
	width := GetCenter(contents)
	ToolTip, %contents%, width, 1
	Return

#IfWinActive (RuneLite|OpenOSRS)( - [a-zA-Z0-9]+)?

GetCenter(contents) {
	ToolTip, %contents%, 0, 0
	WinGet, hWnd, ID, AHK_Class tooltips_class32
	WinGetPos,,, vPosW, vPosH, AHK_ID %hWnd%
	Return (A_ScreenWidth - vPosW - SidePanelWidth) / 2
}

Cap(letter) {
	If(GetKeyState("CapsLock", "T")) {
		Send %letter%{ASC 0151}
	} Else {
		StringLower, letter, letter
		Send %letter%
	}
}

;; Center with SideBar expanded: 820px
Global SidePanelWidth := 278

Pause::PrintScreen
^-::Send {ASC 0151}

$A::Cap("A")
$B::Cap("B")
$C::Cap("C")
$D::Cap("D")
$E::Cap("E")
$F::Cap("F")
$G::Cap("G")
$H::Cap("H")
$I::Cap("I")
$J::Cap("J")
$K::Cap("K")
$L::Cap("L")
$M::Cap("M")
$N::Cap("N")
$O::Cap("O")
$P::Cap("P")
$Q::Cap("Q")
$R::Cap("R")
$S::Cap("S")
$T::Cap("T")
$U::Cap("U")
$V::Cap("V")
$W::Cap("W")
$X::Cap("X")
$Y::Cap("Y")
$Z::Cap("Z")