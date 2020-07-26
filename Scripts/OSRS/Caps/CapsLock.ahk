SetWorkingDir, %A_ScriptDir%
SetStoreCapsLockMode, Off
SetTitleMatchMode, RegEx
SetKeyDelay, 0, 1, Play
SendMode, Play

#IfWinActive (RuneLite|OpenOSRS)( - [a-zA-Z0-9]+)?
#SingleInstance Force
#Persistent
#NoEnv
#Warn

Cap(letter) {
	If(GetKeyState("CapsLock", "T")) {
		;Send {ASC 0151}%letter%
		
		;Send {—}%letter%
		
		Send {Raw}—
		Send %letter%
	} Else {
		Send %letter%
	}
}

$A::Cap("a")
$B::Cap("b")
$C::Cap("c")
$D::Cap("d")
$E::Cap("e")
$F::Cap("f")
$G::Cap("g")
$H::Cap("h")
$I::Cap("i")
$J::Cap("j")
$K::Cap("k")
$L::Cap("l")
$M::Cap("m")
$N::Cap("n")
$O::Cap("o")
$P::Cap("p")
$Q::Cap("q")
$R::Cap("r")
$S::Cap("s")
$T::Cap("t")
$U::Cap("u")
$V::Cap("v")
$W::Cap("w")
$X::Cap("x")
$Y::Cap("y")
$Z::Cap("z")
