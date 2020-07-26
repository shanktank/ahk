SetWorkingDir, %A_ScriptDir%
SetTitleMatchMode, RegEx
SetKeyDelay, 0, 1, Play
StringCaseSense, On
SendMode, Play

;#IfWinActive (RuneLite|OpenOSRS)( - [a-zA-Z0-9]+)?
#SingleInstance Force
#Hotstring r c *
#Persistent
#NoEnv
#Warn

::A::—A
::B::—B
::C::—C
::D::—D
::E::—E
::F::—F
::G::—G
::H::—H
::I::—I
::J::—J
::K::—K
::L::—L
::M::—M
::N::—N
::O::—O
::P::—P
::Q::—Q
::R::—R
::S::—S
::T::—T
::U::—U
::V::—V
::W::—W
::X::—X
::Y::—Y
::Z::—Z

^R::Reload
