#SingleInstance Force
#NoTrayIcon
CoordMode, ToolTip, Screen
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
BH := 150 ; Bar Height pixels
Time := 1 ; Seconds before bar shows up when holding ctrl

; --- Build GUI Start ---
Gui, Color, Black
Gui +AlwaysOnTop +LastFound
WinSet, Transparent, 220
Gui -Caption -Border +ToolWindow
; --- Build GUI End ---

settimer,refresh,10

refresh:
   old_x := x
   old_y := y
   MouseGetPos, X, Y       ; Get Mouse Position
   if (old_y == Y)
      return
   W = %A_ScreenWidth%      ; --- Calculations Start
   H = %A_ScreenHeight%
   Y1:= Y - (BH/2)
   Y2:= Y + (BH/2)         ; --- Calculations End
   Gui, Show, x0 y0 h%H% w%W% ; Show GUI
   Gui +LastFound
   WinSet, Region, 0-0 %W%-0 %W%-%W% 0-%H% 0-0   0-%Y2% %W%-%Y2% %W%-%Y1% 0-%Y1% 0-%Y2% ; Co-ords for box boundaries
   return


ESC::
   Gui, Hide      ;hide gui when ctrl is let go of
   exitapp
   return