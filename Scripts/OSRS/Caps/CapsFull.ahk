SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx
SetKeyDelay, 0, 1, Play
SendMode, Play

#IfWinActive (RuneLite|OpenOSRS)( - [a-zA-Z0-9]+)?
#SingleInstance Force
#Persistent
#NoEnv
#Warn

; TODO; Try Send()
; TODO: Try Send {Blind}
; TODO: Try SetStoreCapslockMode, Off
; TODO: Try https://www.autohotkey.com/docs/commands/Hotkey.htm
; TODO: Try https://autohotkey.com/board/topic/81090-applying-same-function-over-a-group-of-hotstrings/

Cap(letter) {
	If(GetKeyState("CapsLock", "T")) {
		Send {ASC 0151}%letter%
	} Else {
		StringLower, letter, letter
		Send %letter%
	}
}

ShiftCap(letter) {
	Send {ASC 0151}%letter%
}

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
+$A::ShiftCap("A")
+$B::ShiftCap("B")
+$C::ShiftCap("C")
+$D::ShiftCap("D")
+$E::ShiftCap("E")
+$F::ShiftCap("F")
+$G::ShiftCap("G")
+$H::ShiftCap("H")
+$I::ShiftCap("I")
+$J::ShiftCap("J")
+$K::ShiftCap("K")
+$L::ShiftCap("L")
+$M::ShiftCap("M")
+$N::ShiftCap("N")
+$O::ShiftCap("O")
+$P::ShiftCap("P")
+$Q::ShiftCap("Q")
+$R::ShiftCap("R")
+$S::ShiftCap("S")
+$T::ShiftCap("T")
+$U::ShiftCap("U")
+$V::ShiftCap("V")
+$W::ShiftCap("W")
+$X::ShiftCap("X")
+$Y::ShiftCap("Y")
+$Z::ShiftCap("Z")