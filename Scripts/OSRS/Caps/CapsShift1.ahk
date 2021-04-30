SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx
SetKeyDelay, 0, 1, Play
SendMode, Play

#IfWinActive (RuneLite|OpenOSRS)( - [a-zA-Z0-9]+)?
#SingleInstance Force
#Persistent
#NoEnv
#Warn

Cap(letter) {
	;;Send {ASC 0151}%letter%
	Send —%letter%
}

+$A::Cap("A")
+$B::Cap("B")
+$C::Cap("C")
+$D::Cap("D")
+$E::Cap("E")
+$F::Cap("F")
+$G::Cap("G")
+$H::Cap("H")
+$I::Cap("I")
+$J::Cap("J")
+$K::Cap("K")
+$L::Cap("L")
+$M::Cap("M")
+$N::Cap("N")
+$O::Cap("O")
+$P::Cap("P")
+$Q::Cap("Q")
+$R::Cap("R")
+$S::Cap("S")
+$T::Cap("T")
+$U::Cap("U")
+$V::Cap("V")
+$W::Cap("W")
+$X::Cap("X")
+$Y::Cap("Y")
+$Z::Cap("Z")