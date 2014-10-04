;|==================================================|;
;|													|;
;|					-= KOMMAND =-					|;
;|													|;
;|	Version:	0.1									|;
;|	Updated:	July 13, 2009						|;
;|	Author:		Kylir Horton						|;
;|	Email:		kylirh+kommand@gmail.com			|;
;|													|;
;|													|;
;|==================================================|;



;|==================================================|;
;|					Startup Code					|;
;|==================================================|;
#UseHook off
; Show the startup message and set variables for use later on.
#SingleInstance, Force
CoordMode, Tooltip, Screen
ShowMessage("KOMMAND", "Welcome to Kommand", "power.png")

SuppressMessages := 1
if ((%computername% = JENIVICE) OR (%computername% = LOTISY))
	StartAdvancedMode(false)
else
	StartNormalMode(false)
SuppressMessages := 0


;|==================================================|;
;|					Helper Functions				|;
;|==================================================|;
StartNormalMode(Silent)
{
	global
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 0
	AdvancedMode := 0
	ViperMode := 0
	SetCapsLockState, Off
	if ((SuppressMessages = 0) && (Silent == false))
		ShowMessage("Normal Mode", "The default keyboard shortcuts are enabled.", "window.png")
	Tooltip
}

StartAdvancedMode(Silent)
{
	global
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 0
	AdvancedMode := 1
	ViperMode := 0
	SetCapsLockState, AlwaysOff
	if ((SuppressMessages = 0) && (Silent == false))
		ShowMessage("Advanced Mode", "Now in advanced mode.", "command.png")
	Tooltip
}

StartViMode(Silent)
{
	global
	RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation, 1
	AdvancedMode := 1
	ViperMode := 1
	SetCapsLockState, AlwaysOff
	if ((SuppressMessages = 0) && (Silent == false))
		ShowMessage("Viper Mode", "VI-like key bindings are enabled.", "vi.png")
	ToolTip, Viper Mode, 5, 5
}

ShowMessage(title, message, icon)
{
	Run C:\Application\AutoHotKey\SnarlCMD.exe snShowMessage 5 "%title%" "%message%" "C:\Application\AutoHotKey\%icon%",,UseErrorLevel
}

RunAndFocus(Command)
{
	Run %Command%,,UseErrorLevel
	WinActivate
	WinActivate
	WinActivate
}


;|==================================================|;
;|					Window Pad Code					|;
;|==================================================|;
WindowPadMove(P)
{
	StringSplit, P, P, `,, %A_Space%%A_Tab%
	; Params: 1:dirX, 2:dirY, 3:widthFactor, 4:heightFactor, 5:window

	; dirX and dirY are required.
	if P1 is not number
		return
	if P2 is not number
		return
	
	WindowPad_WinExist(P5)

	if !WinExist()
		return

	; Determine width/height factors.
	if (P1 or P2) {	 ; to a side
		widthFactor  := P3+0 ? P3 : (P1 ? 0.5 : 1.0)
		heightFactor := P4+0 ? P4 : (P2 ? 0.5 : 1.0)
	} else {			; to center
		widthFactor  := P3+0 ? P3 : 1.0
		heightFactor := P4+0 ? P4 : 1.0
	}
	
	; Move the window!
	MoveWindowInDirection(P1, P2, widthFactor, heightFactor)
}
return

MaximizeToggle(P)
{
	WindowPad_WinExist(P)
	
	WinGet, state, MinMax
	if state
		WinRestore
	else
		WinMaximize
}

; Does the grunt work of the script.
MoveWindowInDirection(sideX, sideY, widthFactor, heightFactor)
{
	WinGetPos, x, y, w, h
	
	; Determine which monitor contains the center of the window.
	m := GetMonitorAt(x+w/2, y+h/2)
	
	; Get work area of active monitor.
	gosub CalcMonitorStats
	; Calculate possible new position for window.
	gosub CalcNewPosition

	; If the window is already there,
	if (newx "," newy "," neww "," newh) = (x "," y "," w "," h)
	{	; ..move to the next monitor along instead.
	
		if (sideX or sideY)
		{	; Move in the direction of sideX or sideY.
			SysGet, monB, Monitor, %m% ; get bounds of entire monitor (vs. work area)
			x := (sideX=0) ? (x+w/2) : (sideX>0 ? monBRight : monBLeft) + sideX
			y := (sideY=0) ? (y+h/2) : (sideY>0 ? monBBottom : monBTop) + sideY
			newm := GetMonitorAt(x, y, m)
		}
		else
		{	; Move to center (Numpad5)
			newm := m+1
			SysGet, mon, MonitorCount
			if (newm > mon)
				newm := 1
		}
	
		if (newm != m)
		{	m := newm
			; Move to opposite side of monitor (left of a monitor is another monitor's right edge)
			sideX *= -1
			sideY *= -1
			; Get new monitor's work area.
			gosub CalcMonitorStats
		}
		else
		{	; No monitor to move to, alternate size of window instead.
			if sideX
				widthFactor /= 2
			else if sideY
				heightFactor /= 2
			else
				widthFactor *= 1.5
			gosub CalcNewPosition
		}
		
		; Calculate new position for window.
		gosub CalcNewPosition
	}

	; Restore before resizing...
	WinGet, state, MinMax
	if state
		WinRestore

	; Finally, move the window!
	SetWinDelay, 0
	WinMove,,, newx, newy, neww, newh
	
	return

CalcNewPosition:
	; Calculate new size.
	if (IsResizable()) {
		neww := Round(monWidth * widthFactor)
		newh := Round(monHeight * heightFactor)
	} else {
		neww := w
		newh := h
	}
	; Calculate new position.
	newx := Round(monLeft + (sideX+1) * (monWidth  - neww)/2)
	newy := Round(monTop  + (sideY+1) * (monHeight - newh)/2)
	return

CalcMonitorStats:
	; Get work area (excludes taskbar-reserved space.)
	SysGet, mon, MonitorWorkArea, %m%
	monWidth  := monRight - monLeft
	monHeight := monBottom - monTop
	return
}

; Get the index of the monitor containing the specified x and y co-ordinates.
GetMonitorAt(x, y, default=1)
{
	SysGet, m, MonitorCount
	; Iterate through all monitors.
	Loop, %m%
	{	; Check if the window is on this monitor.
		SysGet, Mon, Monitor, %A_Index%
		if (x >= MonLeft && x <= MonRight && y >= MonTop && y <= MonBottom)
			return A_Index
	}

	return default
}

IsResizable()
{
	WinGetClass, Class
	if Class = Chrome_XPFrame
		return true
	WinGet, Style, Style
	return (Style & 0x40000) ; WS_SIZEBOX
}

WindowPad_WinExist(WinTitle)
{
	if WinTitle = P
		return WinPreviouslyActive()
	if WinTitle = M
	{
		MouseGetPos,,, win
		return WinExist("ahk_id " win)
	}
	return WinExist(WinTitle!="" ? WinTitle : "A")
}

; Note: This may not work properly with always-on-top windows. (Needs testing)
WinPreviouslyActive()
{
	active := WinActive("A")
	WinGet, win, List

	; Find the active window.
	; (Might not be win1 if there are always-on-top windows?)
	Loop, %win%
		if (win%A_Index% = active)
		{
			if (A_Index < win)
				N := A_Index+1
			
			; hack for PSPad: +1 seems to get the document (child!) window, so do +2
			ifWinActive, ahk_class TfPSPad
				N += 1
			
			break
		}

	; Use WinExist to set Last Found Window (for consistency with WinActive())
	return WinExist("ahk_id " . win%N%)
}


;
; Switch without moving/resizing (relative to screen)
;
WindowScreenMove(P)
{
	SetWinDelay, 0
	
	StringSplit, P, P, `,, %A_Space%%A_Tab%
	; 1:Next|Prev|Num, 2:Window
	
	WindowPad_WinExist(P2)

	WinGet, state, MinMax
	if state = 1
		WinRestore

	WinGetPos, x, y, w, h
	
	; Determine which monitor contains the center of the window.
	ms := GetMonitorAt(x+w/2, y+h/2)
	
	SysGet, mc, MonitorCount

	; Determine which monitor to move to.
	if P1 in ,N,Next
	{
		md := ms+1
		if (md > mc)
			md := 1
	}
	else if P1 in P,Prev,Previous
	{
		md := ms-1
		if (md < 1)
			md := mc
	}
	else if P1 is integer
		md := P1
	
	if (md=ms or (md+0)="" or md<1 or md>mc)
		return
	
	; Get source and destination work areas (excludes taskbar-reserved space.)
	SysGet, ms, MonitorWorkArea, %ms%
	SysGet, md, MonitorWorkArea, %md%
	msw := msRight - msLeft, msh := msBottom - msTop
	mdw := mdRight - mdLeft, mdh := mdBottom - mdTop
	
	; Calculate new size.
	if (IsResizable()) {
		w *= (mdw/msw)
		h *= (mdh/msh)
	}
	
	; Move window, using resolution difference to scale co-ordinates.
	WinMove,,, mdLeft + (x-msLeft)*(mdw/msw), mdTop + (y-msTop)*(mdh/msh), w, h

	if state = 1
		WinMaximize
}


;
; "Gather" windows on a specific screen.
;
GatherWindows(md=1)
{
	global ProcessGatherExcludeList
	
	SetWinDelay, 0
	
	; List all visible windows.
	WinGet, win, List
	
	; Copy bounds of all monitors to an array.
	SysGet, mc, MonitorCount
	Loop, %mc%
		SysGet, mon%A_Index%, MonitorWorkArea, %A_Index%
	
	if md = M
	{	; Special exception for 'M', since the desktop window
		; spreads across all screens.
		CoordMode, Mouse, Screen
		MouseGetPos, x, y
		md := GetMonitorAt(x, y, 0)
	}
	else if md is not integer
	{	; Support A, P and WinTitle.
		; (Gather at screen containing specified window.)
		WindowPad_WinExist(md)
		WinGetPos, x, y, w, h
		md := GetMonitorAt(x+w/2, y+h/2, 0)
	}
	if (md<1 or md>mc)
		return
	
	; Destination monitor
	mdx := mon%md%Left
	mdy := mon%md%Top
	mdw := mon%md%Right - mdx
	mdh := mon%md%Bottom - mdy
	
	Loop, %win%
	{
		; If this window matches the GatherExclude group, don't touch it.
		if (WinExist("ahk_group GatherExclude ahk_id " . win%A_Index%))
			continue
		
		; Set Last Found Window.
		if (!WinExist("ahk_id " . win%A_Index%))
			continue

		WinGet, procname, ProcessName
		; Check process (program) exclusion list.
		if procname in %ProcessGatherExcludeList%
			continue
		
		WinGetPos, x, y, w, h
		
		; Determine which monitor this window is on.
		xc := x+w/2, yc := y+h/2
		ms := 0
		Loop, %mc%
			if (xc >= mon%A_Index%Left && xc <= mon%A_Index%Right
				&& yc >= mon%A_Index%Top && yc <= mon%A_Index%Bottom)
			{
				ms := A_Index
				break
			}
		; If already on destination monitor, skip this window.
		if (ms = md)
			continue
		
		WinGet, state, MinMax
		if (state = 1) {
			WinRestore
			WinGetPos, x, y, w, h
		}
	
		if ms
		{
			; Source monitor
			msx := mon%ms%Left
			msy := mon%ms%Top
			msw := mon%ms%Right - msx
			msh := mon%ms%Bottom - msy
			
			; If the window is resizable, scale it by the monitors' resolution difference.
			if (IsResizable()) {
				w *= (mdw/msw)
				h *= (mdh/msh)
			}
		
			; Move window, using resolution difference to scale co-ordinates.
			WinMove,,, mdx + (x-msx)*(mdw/msw), mdy + (y-msy)*(mdh/msh), w, h
		}
		else
		{	; Window not on any monitor, move it to center.
			WinMove,,, mdx + (mdw-w)/2, mdy + (mdh-h)/2
		}

		if state = 1
			WinMaximize
	}
}

GetLastMinimizedWindow()
{
	WinGet, w, List

	Loop %w%
	{
		wi := w%A_Index%
		WinGet, m, MinMax, ahk_id %wi%
		if m = -1 ; minimized
		{
			lastFound := wi
			break
		}
	}

	return "ahk_id " . (lastFound ? lastFound : 0)
}


;|==================================================|;
;|					Viper Command Keys				|;
;|==================================================|;
#UseHook on
#Capslock::
	if (AdvancedMode = 0)
		StartAdvancedMode(false)
	else
		StartNormalMode(false)
return

CapsLock::	Send, {Esc}

;CapsLock::
;	if (AdvancedMode = 1)
;	{
;		if (ViperMode = 0)
;			StartViMode(false)
;		else
;			StartAdvancedMode(true)
;	}
;	else
;		SetCapsLockState, % GetKeyState( "CapsLock", "T" ) ? "OFF" : "ON"
;return

Tab::
	if (ViperMode = 1)
		Send, ^{Tab}
	else
		Send, {Tab}
return

+Tab::
	if (ViperMode = 1)
		Send, {Tab}
	else
		Send, +{Tab}
return

a::
	if (ViperMode = 1)
	{
		Send, {End}{Enter}
		StartAdvancedMode(true)
	}
	else
		Send, a
return

+a::
	if (ViperMode = 1)
	{
		Send, {End}
		StartAdvancedMode(true)
	}
	else
		Send, +a
return

c::
	if (ViperMode = 1)
		Send, ^c
	else
		Send, c
return

d::
	if (ViperMode = 1)
		Send,{Delete}
	else
		Send, d
return

+d::
	if (ViperMode = 1)
		Send,{Backspace}
	else
		Send, +d
return

e::
	if (ViperMode = 1)
		Send, {end}{Shift down}{home}{Shift up}{Backspace}
	else
		Send, e
return

+e::
	if (ViperMode = 1)
		Send, {end}{Shift down}{home}{Shift up}{Backspace}{Shift down}{Up}{End}{Shift up}{Backspace}
	else
		Send, +e
return

g::
	if (ViperMode = 1)
		Send, {Home}
	else
		Send, g
return

+g::
	if (ViperMode = 1)
		Send, +{Home}
	else
		Send, +g
return

^g::
	if (ViperMode = 1)
		Send, ^{Home}
	else
		Send, ^g
return

^+g::
	if (ViperMode = 1)
		Send, ^+{Home}
	else
		Send, ^+g
return

h::
	if (ViperMode = 1)
		Send, {End}
	else
		Send, h
return

+h::
	if (ViperMode = 1)
		Send, +{End}
	else
		Send, +h
return

^h::
	if (ViperMode = 1)
		Send, ^{End}
	else
		Send, ^h
return

^+h::
	if (ViperMode = 1)
		Send, ^+{End}
	else
		Send, ^+h
return

i::
	if (ViperMode = 1)
		Send,{Up}
	else
		Send, i
return

^i::
	if (ViperMode = 1)
		Send,^{Up}
	else
		Send,^i
return

+i::
	if (ViperMode = 1)
		Send,+{Up}
	else
		Send,+i
return

^+i::
	if (ViperMode = 1)
		Send,^+{Up}
	else
		Send,^+i
return

!i::
	if (ViperMode = 1)
		Send,!{Up}
	else
		Send,!i
return

j::
	if (ViperMode = 1)
		Send,^{Left}
	else
		Send, j
return

^j::
	if (ViperMode = 1)
		Send,{Left}
	else
		Send,^j
return

+j::
	if (ViperMode = 1)
		Send,^+{Left}
	else
		Send,+j
return

^+j::
	if (ViperMode = 1)
		Send,+{Left}
	else
		Send,^+j
return

!j::
	if (ViperMode = 1)
		Send,!{Left}
	else
		Send,!j
return

k::
	if (ViperMode = 1)
		Send,{Down}
	else
		Send, k
return

^k::
	if (ViperMode = 1)
		Send,^{Down}
	else
		Send,^k
return

+k::
	if (ViperMode = 1)
		Send,+{Down}
	else
		Send,+k
return

^+k::
	if (ViperMode = 1)
		Send,^+{Down}
	else
		Send,^+k
return

!k::
	if (ViperMode = 1)
		Send,!{Down}
	else
		Send,!k
return

l::
	if (ViperMode = 1)
		Send,^{Right}
	else
		Send, l
return

^l::
	if (ViperMode = 1)
		Send,{Right}
	else
		Send,^l
return

+l::
	if (ViperMode = 1)
		Send,^+{Right}
	else
		Send,+l
return

^+l::
	if (ViperMode = 1)
		Send,+{Right}
	else
		Send,^+l
return

!l::
	if (ViperMode = 1)
		Send,!{Right}
	else
		Send,!l
return

m::
	if (ViperMode = 1)
		Send, ^{Up}
	else
		Send, m
return

+m::
	if (ViperMode = 1)
		Send, {PgUp}
	else
		Send, +m
return

n::
	if (ViperMode = 1)
		Send, ^{Down}
	else
		Send, n
return

+n::
	if (ViperMode = 1)
		Send, {PgDn}
	else
		Send, +n
return

p::
	if (ViperMode = 1)
	{
		ToolTip, Paste, 5, 5
		ViperMode = 0
		Input, UserInput, B T1 L1,, a,s,d,f
		ViperMode = 1
		
		if ErrorLevel = Max
		{
			ToolTip, Paste from register %UserInput% failed, 5, 5
			return
		}
		
		if ErrorLevel = Timeout
		{
			ToolTip, Paste timeout, 5, 5
			return
		}
		
		if ErrorLevel = NewInput
			return
		
		TempClipboard := ClipboardAll
		
		if UserInput = a
			Clipboard := RegisterA
		else if UserInput = s
			Clipboard := RegisterS
		else if UserInput = d
			Clipboard := RegisterD
		else if UserInput = f
			Clipboard := RegisterF
		
		SendInput, ^v
		Clipboard := TempClipboard
		TempClipboard =
		ToolTip, Pasted register %UserInput%, 5, 5
	}
	else
		Send p
return

+p::
	if (ViperMode = 1)
	{
		ToolTip, Paste, 5, 5
		ViperMode = 0
		Input, UserInput, B T1 L1,, a,s,d,f
		ViperMode = 1
		
		if ErrorLevel = Max
		{
			ToolTip, Paste from register %UserInput% failed, 5, 5
			return
		}
		
		if ErrorLevel = Timeout
		{
			ToolTip, Paste timeout, 5, 5
			return
		}
		
		if ErrorLevel = NewInput
			return
		
		TempClipboard := ClipboardAll
		
		if UserInput = a
			Clipboard := RegisterA
		else if UserInput = s
			Clipboard := RegisterS
		else if UserInput = d
			Clipboard := RegisterD
		else if UserInput = f
			Clipboard := RegisterF
		
		SendInput, ^v
		StringLen, ClipboardLength, Clipboard
		Loop, %ClipboardLength%
		{
			SendInput, {Left}
		}
		Clipboard := TempClipboard
		TempClipboard =
		ToolTip, Pasted register %UserInput%, 5, 5
	}
	else
		Send +p
return

r::
	if (ViperMode = 1)
		Send, ^y
	else
		Send, r
return

u::
	if (ViperMode = 1)
		Send, ^z
	else
		Send, u
return

v::
	if (ViperMode = 1)
		Send, ^v
	else
		Send, v
return

+v::
	if (ViperMode = 1)
	{
		SendInput, ^v
		StringLen, ClipboardLength, Clipboard
		Loop, %ClipboardLength%
		{
			SendInput, {Left}
		}
	}
	else
		Send, +v
return

w::
	if (ViperMode = 1)
		Send, ^{Right}{Shift down}^{Left}{Shift up}
	else
		Send, w
return

+w::
	if (ViperMode = 1)
		Send, ^{Left}{Shift down}^{Right}{Shift up}
	else
		Send, +w
return

x::
	if (ViperMode = 1)
		Send, ^x
	else
		Send, x
return

+x::
	if (ViperMode = 1)
		Send, {end}{Shift down}{home}{Shift up}^x{Shift down}{Up}{End}{Shift up}{Backspace}
	else
		Send, +x
return

y::
	if (ViperMode = 1)
	{
		ToolTip, Yank, 5, 5
		ViperMode = 0
		Input, UserInput, B T1 L1,, a,s,d,f
		ViperMode = 1
		
		if ErrorLevel = Max
		{
			ToolTip, Yank to register %UserInput% failed, 5, 5
			return
		}
		
		if ErrorLevel = Timeout
		{
			ToolTip, Yank timeout, 5, 5
			return
		}
		
		if ErrorLevel = NewInput
			return
		
		TempClipboard := ClipboardAll
		Send, ^c
		ClipWait
		
		if UserInput = a
			RegisterA := Clipboard
		else if UserInput = s
			RegisterS := Clipboard
		else if UserInput = d
			RegisterD := Clipboard
		else if UserInput = f
			RegisterF := Clipboard
		
		Clipboard := TempClipboard
		TempClipboard =
		ToolTip, Yanked to %UserInput%, 5, 5
	}
	else
		Send y
return

`;::
	if (ViperMode = 1)
	{
		ViperMode = 0
		Input, UserInput, L3, {enter}
		
		if UserInput = s
		{
			Send, ^s
		}
		else if UserInput = w
		{
			Send, ^+s
		}
		else if UserInput = sq
		{
			Send, ^s
			WinClose, A
		}
		else if UserInput = q
		{
			WinClose, A
		}
		else if UserInput = o
		{
			 Send, ^o
		}
		ViperMode = 1
	}
	else
		Send, `;
return


;|==================================================|;
;|						Arrows						|;
;|==================================================|;
#UseHook off
#Up::
	if (AdvancedMode = 0)
		Run C:\Application\iTunes\PlayPause.vbs,,UseErrorLevel
	else
		MaximizeToggle(A)
return

#+Up::
	if (AdvancedMode = 1)
		WindowPadMove("0, -1,  1.0, 0.5")
return

#!Up::
	if (AdvancedMode = 1)
		WinSet, AlwaysOnTop, Toggle, A
return

#^Up::
	if (AdvancedMode = 1)
		Run C:\Application\iTunes\PlayPause.vbs,,UseErrorLevel
return

#Down::
	if (AdvancedMode = 0)
		Run C:\Application\iTunes\DeleteTrack.js,,UseErrorLevel
	else
		WinMinimize, A
return

#+Down::
	if (AdvancedMode = 1)
		WindowPadMove("0, +1,  1.0, 0.5")
return

#!Down::
	if (AdvancedMode = 1)
	{
		WinSet, AlwaysOnTop, Off, A
		WinSet, Bottom,, A
	}
return

#^Down::
	if (AdvancedMode = 1)
		Run C:\Application\iTunes\DeleteTrack.js,,UseErrorLevel
return

#Left::
	if (AdvancedMode = 0)
		Run C:\Application\iTunes\BackTrack.vbs,,UseErrorLevel
	else
		if WinExist(GetLastMinimizedWindow())
			WinRestore
return

#+Left::
	if (AdvancedMode = 1)
		WindowPadMove("-1,  0,  0.5, 1.0")
return

#!Left::
	if (AdvancedMode = 1)
	{
		WinGet, Transparent, Transparent, A
		if (Transparent = 120)
			WinSet, Transparent, 255, A
		else
			WinSet, Transparent, 120, A
	}
return

#^Left::
	if (AdvancedMode = 1)
		Run C:\Application\iTunes\BackTrack.vbs,,UseErrorLevel
return

#Right::
	if (AdvancedMode = 0)
		Run C:\Application\iTunes\Next.vbs,,UseErrorLevel
	else
	{
		WinGetClass, class, A
		if (class = "Notepad++")
			SendInput ^w
		else if (class = "MozillaUIWindowClass")
			SendInput ^w
		else if (class = "wndclass_desked_gsk")
			Send ^{F4}
		else
			WinClose A
	}
return

#+Right::
	if (AdvancedMode = 1)
		WindowPadMove("+1,  0,  0.5, 1.0")
return

#!Right::
	if (AdvancedMode = 1)
		WindowScreenMove(Next)
return

#!^Right::
	if (AdvancedMode = 1)
		Run C:\Application\AutoHotKey\CloseWindows.exe,,UseErrorLevel
return

#^Right::
	if (AdvancedMode = 1)
		Run C:\Application\iTunes\Next.vbs,,UseErrorLevel
return


;|==================================================|;
;|					Special Keys					|;
;|==================================================|;
#UseHook off
#Space::		RunAndFocus("http://docs.google.com/")
#+Space::		RunAndFocus("http://spreadsheets.google.com/ccc?key=pdHfNEZHTShBi8F86ZeoRVA&hl=en")
#!Space::		RunAndFocus("http://spreadsheets.google.com/ccc?key=0AiyaPQOEK_4RdEJmOUF2cDJ0WUdqQ3NUUThtaVl4MHc&hl=en")
#^Space::		RunAndFocus("http://spreadsheets.google.com/ccc?key=0AiyaPQOEK_4RdHZMN0NYcFBxYnM2eFFMYlNxZkozMGc&hl=en")
#Backspace::	Run "C:\Program Files (x86)\Prism\prism.exe" -override "%USERPROFILE%\AppData\Roaming\WebApps\k.rss@prism.app\override.ini" -webapp k.rss@prism.app,,UseErrorLevel
#Enter::		RunAndFocus("http://localhost/Cityworks.WebApp/Login.aspx")
#+Enter::		RunAndFocus("http://localhost/CwPortal/Login.aspx")
#Insert::		RunAndFocus("http://www.rememberthemilk.com/home/kylir/")
#+Insert::		RunAndFocus("C:\Program Files (x86)\MiniTask\MiniTask\MiniTask.exe")
#Delete::		Run "C:\Program Files (x86)\Prism\prism.exe" -override "%USERPROFILE%\AppData\Roaming\WebApps\k.cal@prism.app\override.ini" -webapp k.cal@prism.app,,UseErrorLevel
;#Home::
;#End
#+End::			Run C:\Application\iTunes\RemoveDeadTracks.js,,UseErrorLevel
#!End::			Run C:\Application\iTunes\FindDeadTracks.js,,UseErrorLevel
;#PgUp::
;#PgDn::


;|==================================================|;
;|						Numbers						|;
;|==================================================|;
#UseHook off
#1::		RunAndFocus("C:\Cityworks\Cityworks.WebApp")
#+1::		RunAndFocus("C:\Cityworks")
#2::		RunAndFocus("C:\Azteca")
#3::		RunAndFocus("C:\Vast")
#4::		RunAndFocus("C:\Downloads")
#+4::		RunAndFocus("C:\Files\Public")
#5::		RunAndFocus("C:\Kylir")
#+5::		RunAndFocus(USERPROFILE)
#6::		RunAndFocus("C:\Mindy")
#7::		RunAndFocus("C:\Resources")
#8::		RunAndFocus("C:\Application")
#9::		RunAndFocus("C:\Program Files (x86)")
#+9::		RunAndFocus("C:\Program Files")
#0::		RunAndFocus("Control")
#+0::		RunAndFocus("C:\Windows")


;|==================================================|;
;|						Letters						|;
;|==================================================|;
#UseHook off
#a::		RunAndFocus("C:\Files")
;#b::		Run Highlight System Tray
#c::		RunAndFocus("C:\Program Files (x86)\Adobe\Photoshop CS4\PhotoshopPortable.exe")
;#d::		Run Reveal Desktop
;#e::		Run Computer
#+e::		RunAndFocus("C:\")
;#f::		Run Search
#g::		RunAndFocus("C:\Program Files (x86)\iTunes\iTunes.exe")
#h::		RunAndFocus("C:\Program Files\Windows Media Player\wmplayer.exe /prefetch:1")
#+h::		Run %SystemRoot%\system32\drivers\etc\,,UseErrorLevel ;TODO - Fix this so it uses RunAndFocus.

#i::
	if (ViperMode = 1)
		MaximizeToggle(A)
	else
		RunAndFocus("C:\Windows\system32\inetsrv\iis.msc")
return

$#+i::
	if (ViperMode = 1)
		WindowPadMove("0, -1,  1.0, 0.5")
	else
		Send #+i
return

$#!i::
	if (ViperMode = 1)
		WinSet, AlwaysOnTop, Toggle, A
	else
		Send #!i
return

$#^i::
	if (ViperMode = 1)
		Run C:\Application\iTunes\PlayPause.vbs,,UseErrorLevel
	else
		Send #^i
return

#j::
	if (ViperMode = 1)
	{
		if WinExist(GetLastMinimizedWindow())
			WinRestore
	}
	else
		RunAndFocus("C:\Junk")
return

#+j::
	if (ViperMode = 1)
		WindowPadMove("-1,  0,  0.5, 1.0")
	else
		RunAndFocus("C:\Junk\Projects")
return

$#!j::
	if (ViperMode = 1)
	{
		WinGet, Transparent, Transparent, A
		if (Transparent = 120)
			WinSet, Transparent, 255, A
		else
			WinSet, Transparent, 120, A
	}
	else
		Send #!j
return

$#^j::
	if (ViperMode = 1)
		Run C:\Application\iTunes\BackTrack.vbs,,UseErrorLevel
	else
		Send #^j
return

$#k::
	if (ViperMode = 1)
		WinMinimize, A
	else
		Send #k
return

$#+k::
	if (ViperMode = 1)
		WindowPadMove("0, +1,  1.0, 0.5")
	else
		Send #+k
return

$#!k::
	if (ViperMode = 1)
	{
		WinSet, AlwaysOnTop, Off, A
		WinSet, Bottom,, A
	}
	else
		Send #!k
return

$#^k::
	if (ViperMode = 1)
		Run C:\Application\iTunes\DeleteTrack.js,,UseErrorLevel
	else
		Send #^k
return

#l::
	if (ViperMode = 1)
	{
		WinGetClass, class, A
		if (class = "Notepad++")
			SendInput ^w
		else if (class = "MozillaUIWindowClass")
			SendInput ^w
		else if (class = "wndclass_desked_gsk")
			Send ^{F4}
		else
			WinClose A
	}
	else
	{
		sleep 1000
		SendMessage, 0x112, 0xF170, 2,, Program Manager
		;Run rundll32.exe user32.dll LockWorkStation, C:\Windows\System32,,UseErrorLevel ; Not needed because #l already locks the machine.
	}
return

$#+l::
	if (ViperMode = 1)
		WindowPadMove("+1,  0,  0.5, 1.0")
	else
		Send #+l
return

$#!l::
	if (ViperMode = 1)
		WindowScreenMove(Next)
	else
		Send #!l
return

$#!^l::
	if (ViperMode = 1)
		Run C:\Application\AutoHotKey\CloseWindows.exe,,UseErrorLevel
	else
		Send #!^l
return

$#^l::
	if (ViperMode = 1)
		Run C:\Application\iTunes\Next.vbs,,UseErrorLevel
	else
		Send #^l
return

#m::		Run C:\Program Files (x86)\BasiliskII\BasiliskII.exe, C:\Program Files (x86)\BasiliskII,,UseErrorLevel
#+m::		Run C:\Program Files (x86)\BasiliskII\BasiliskIIGUI.exe, C:\Program Files (x86)\BasiliskII,,UseErrorLevel
#!m::		RunAndFocus("C:\Program Files (x86)\DOSBox-0.72\dosbox.exe -conf C:\Application\Games\dosbox.conf")
#!^m::		Run, nomousy.exe /hide

#n::
	if WinExist("ahk_class Vim")
		WinActivate
	else
		RunAndFocus("C:\Vim\vim72\gvim.exe")
return

#+n::		RunAndFocus("C:\Junk\Notes")
#!n::		RunAndFocus("C:\Program Files (x86)\Notepad++\notepad++.exe")
#o::		RunAndFocus("C:\Videos")
#p::		RunAndFocus("C:\Pictures")

#q::
	if WinExist("ahk_class CalcFrame")
		WinActivate
	else
		RunAndFocus("C:\Windows\system32\calc.exe")
return

;#r::		Run "Open Run" dialog
#+r::		RunAndFocus("regedit")
#s::		RunAndFocus("explorer.exe ftp://www.kylirhorton.com")
#+s::		RunAndFocus("C:\Program Files (x86)\Allway Sync\Bin\syncappw.exe")
#!s::		Run %USERPROFILE%\AppData\Local\Microsoft\Live Mesh\Bin\Servicing\0.9.4014.7\MoeMonitor.exe,,UseErrorLevel ;TODO - Fix this so it uses RunAndFocus.
#t::		RunAndFocus("C:\Windows\system32\mstsc.exe")

#+t::
	if (%computername% = JENIVICE) ;Open Retwoner.
		RunAndFocus("https://secure.logmein.com/mycomputers_connect.asp?lang=en&shortcut=aehkr97xnqjdx5b8v79kbo4bimewa0hjxj53uc3fmpckfogp35pe8s4iyf9e77h08bvp37k93a9j6cc75476ap14hp9kdpx8kx0dc184pksdsgyhsnajgg4eqf78i8x4")
	else if (%computername% = LOTISY OR %computername% = RETWONER) ;Open Jenivice.
		RunAndFocus("https://secure.logmein.com/mycomputers_connect.asp?lang=en&shortcut=dx1bst0hvyxba52tq8unfram0z0ozujzstj1oi0kx860ey9ewe7v5i6dbwbgcbso17sy3w3onmgkqqvyz88qp7o9d04guq9q7i0cs9beem6diqmtlip82v798u2hfjyu")
return

#!t::		RunAndFocus("https://secure.logmein.com/computers.asp")
#u::		RunAndFocus("C:\Program Files (x86)\uTorrent\uTorrent.exe")

#v::
	if WinExist("ahk_class wndclass_desked_gsk")
		WinActivate
	else
		RunAndFocus("C:\Program Files (x86)\Microsoft Visual Studio 9.0\Common7\IDE\devenv.exe")
return

#+v::
	if WinExist("ahk_class SWT_Window0")
		WinActivate
	else
		RunAndFocus("C:\Program Files (x86)\Eclipse\eclipse.exe")
return

#!v::		RunAndFocus("C:\Program Files (x86)\Adobe\Dreamweaver CS4\DreamweaverPortable.exe")
#^v::		RunAndFocus("C:\Program Files (x86)\Vim\vim72\gvim.exe")

#w::
	WinGetClass, class, A
	if (class = "CabinetWClass")
	{
		RegRead, HiddenFiles_Status, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden
		if HiddenFiles_Status = 2 
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 1
		else 
			RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced, Hidden, 2
		WinGetClass, eh_Class,A
		if (eh_Class = "#32770" OR A_OSVersion = "WIN_VISTA")
			SendInput, {F5}
		else
			PostMessage, 0×111, 28931,,, A
	}
return

#x::		Run "C:\Program Files (x86)\Prism\prism.exe" -override "%USERPROFILE%\AppData\Roaming\WebApps\k.mail@prism.app\override.ini" -webapp k.mail@prism.app,,UseErrorLevel
#+x::		RunAndFocus("C:\Program Files (x86)\Microsoft Office\Office12\OUTLOOK.EXE /recycle")
#y::		RunAndFocus("C:\Program Files (x86)\Yahoo!\Widgets\YahooWidgets.exe")

#z::
	if WinExist("ahk_class MozillaUIWindowClass")
		WinActivate
	else
		RunAndFocus("C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
return

#+z::
	if WinExist("ahk_class MozillaUIWindowClass")
		WinActivate
	else
		RunAndFocus("C:\Program Files (x86)\Mozilla Firefox\firefox.exe --profilemanager")
return

#!z::		RunAndFocus("C:\Program Files (x86)\Mozilla Firefox\newInstance.bat")


;|==================================================|;
;|					Function Keys					|;
;|==================================================|;
#UseHook off
#F1::		RunAndFocus("C:\Program Files (x86)\Pidgin\pidgin.exe")
#+F1::		Run %USERPROFILE%\AppData\Local\Google\Chrome\Application\chrome.exe,,UseErrorLevel ;TODO - Fix this so it uses RunAndFocus.
#!F1::		RunAndFocus("C:\Program Files (x86)\Trillian\Addons\TrillKey\TrillKey.exe launch togglebuddy")
#F2::		RunAndFocus("C:\Program Files (x86)\Internet Explorer\iexplore.exe")
#F3::		RunAndFocus("C:\Program Files (x86)\Safari\Safari.exe")
#F4::		RunAndFocus("C:\Program Files (x86)\Opera\Opera.exe")
#F5::		RunAndFocus("C:\Program Files (x86)\Microsoft Office\Office12\WINWORD.EXE")
#F6::		RunAndFocus("C:\Program Files (x86)\Microsoft Office\Office12\EXCEL.EXE")
#F7::		RunAndFocus("C:\Program Files (x86)\Microsoft Office\Office12\POWERPNT.EXE")
#F8::		RunAndFocus("C:\Program Files (x86)\Microsoft Office\Office12\ONENOTE.EXE")
#F9::		RunAndFocus("C:\Program Files (x86)\Adobe\Illustrator CS3\Illustrator.exe")
#F10::		RunAndFocus("C:\Program Files (x86)\Adobe\Adobe InDesign CS2\InDesign.exe")
#F11::		RunAndFocus("C:\Program Files (x86)\NexusFont\NexusFont.exe")
#F12::		RunAndFocus("C:\Program Files (x86)\Notepad++\notepad++.exe ""C:\Application\AutoHotKey\AutoHotKey.ahk""")
#+F12::		Reload
