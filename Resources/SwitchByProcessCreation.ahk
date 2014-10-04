;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template script (you can customize this template by editing "ShellNew\Template.ahk" in your Windows folder)
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#n::   ; Hotkey Windows Key+N
   WinGet, Wins, List
   Loop, % 0 Wins`, Wins := ""
      Wins .= InTaskbar(win:=Wins%A_Index%) ? win "`n" : ""
   Sort, Wins, FSortByCreationTime
   Loop, Parse, Wins, `n
      GroupAdd, Wins, ahk_id %A_LoopField%
   GroupActivate, Wins
return

SortByCreationTime(hwnd1, hwnd2){
   time1 := CreationTime(hwnd1), time2 := CreationTime(hwnd2)
   Return time1>time2 ? -1 : time1<time2
}

CreationTime(hwnd){
   DllCall("GetWindowThreadProcessId","UInt", hwnd, "UIntP", pid)
   If proc := DllCall("OpenProcess", "UInt", 0x400|0x10, "Int", 0, "UInt", pid){
      DllCall("GetProcessTimes", "UInt", proc, "Int64P", CreationTime, "Int64P", _, "Int64P", _, "Int64P", _)
      Return CreationTime, DllCall("CloseHandle", "UInt", proc)
   }
}

InTaskbar(id){   ; Checks if there's a taskbar button for window or not
   ; static WS_EX_TOOLWINDOW := 0x80, WS_EX_APPWINDOW := 0x40000, GW_OWNER := 4
   WinGet, ExStyle, ExStyle, ahk_id %id%
   If (ExStyle & 0x80) or (!(ExStyle & 0x40000) and DllCall("GetWindow", "UInt", id, "UInt", 4))
      Return 0
   Return 1
}

