#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;file vim.ahk
;this file must be run as sepparate script (use "Run, vim.ahk")
#NoTrayIcon
SetCapsLockState, AlwaysOff
Suspend, On

#include Lib\Constant.ahk
#include Lib\func.ahk

;Command mode
^[::
	Suspend, Off
	commandkey = %A_ThisHotkey%
	CoordMode, ToolTip, Screen
	ToolTip, 超级程序命令模式, 0, 0
	Keywait, %commandkey%
	if A_ThisHotkey <> %commandkey%
	{
		Gosub Typingmode
	}
return

TypingMode:
	CoordMode, ToolTip, Screen
	ToolTip 正常模式, 0, 0
	Sleep, 4000
	CancelToolTip()
	Suspend, On
return

I::Gosub TypingMode
;web


;app
:o:st::Run %SublimeText3%
:o:qq::Run D:\SCRIPTS\qq.lnk


:o:bd::run www.baidu.com


return





