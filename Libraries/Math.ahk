#SingleInstance Force
#Persistent
#NoEnv
#Warn

CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SendMode, Input

; Random number generator
Rand(L=0.0, U=1) {
   IfEqual, L,, Random,, % R := U = 1 ? Rand(0, 0xFFFFFFFF) : U
   Else Random, R, L, U
   Return R
}