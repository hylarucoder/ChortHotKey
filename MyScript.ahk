;快捷键定制
#include lib\func.ahk
#include lib\Constant.ahk

SetTitleMatchMode, RegEx
CoordMode, Mouse, Screen
DetectHiddenWindows, On
SetScrollLockState, Off
SetCapsLockState, AlwaysOff


If FileExist("lib\OtherRes\pal4.ico")
    Menu, Tray, Icon, lib\OtherRes\pal4.ico

Menu, Tray, Tip, MyScripts

;Command mode



;;输入管理涉及到邮箱账号
;blog输入管理    声明 + 日期

:o:sm~::
sendinput ,%Claim%
return



;;Gmail地址缩写  常用邮箱以及账号管理
:o:g@::twocucao@gmail.com


F1::
fastTxt(onedrive)
CancelToolTip()
return
;;常用程序的设计 win+按键

;;文件管理，窗口管理，功能性管理^+


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Folder Shortcuts ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

#F1::		ShowDir("D:\OneDrive")
#F2::		ShowDir("D:\SCRIPTS")

#F3::       
file := CopySelection()
if file = 
    return
MouseGetPos,x0
SublimeOpen(file,SublimeText3)
return

~Esc::
Keywait, Escape, , t0.5
if errorlevel = 1
return
else
Keywait, Escape, d, t0.1
if errorlevel = 0
{
WinGetActiveTitle, Title
WinClose, %Title%
return
}
return






;;;;;;;;;





;;文章开头
;blog声明

;;run programs ----- code programing chatting browse
#s::Run %SublimeText3%
#q::Run D:\SCRIPTS\qq.lnk
#b::run www.baidu.com



;;run enhanced pro
^+g::run D:\SCRIPTS\go.lnk



;文件夹管理  以今的时间作为命名标准
^+f::
        ; 第一行增加快捷键
Send, ^+n
Sleep, 125
        ; 把暂停时间改小
clipboard = %A_YYYY%-%A_MM%-%A_DD%-%A_Hour%H
        ; 增加上面这句，把当前的系统日期发送到剪贴板
Send, ^v{Enter}
        ; 发送 Ctrl + v 和回车
return

; 显示 / 隐藏 隐藏系统文件：
; 作者： iLEMONed
; http://cn.ilemoned.com/
^!+h::
If value = 1
value = 2
Else
value = 1
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\, Hidden, %Value%
send { AppsKey } e
send F5
return

; 显示 / 隐藏 文件扩展名：
; 作者： iLEMONed
; http://cn.ilemoned.com/

^!+e::
If value = 0
value = 1
Else
value = 0
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\, HideFileExt, %Value%
send { AppsKey } e
send F5
        ; 点击键盘上的 AppsKey ，弹出右键，选择“刷新(e)” 。
return






;;窗口管理
^!F4::
WinGetActiveTitle, Title
WinGet, PID, PID, %Title%
MsgBox, 0x104, Kill "%Title%", which PID is %PID%, `n Continue?
IfMsgBox, No
    return
Process, Close, %PID%
return



;;打开文件的属性窗口
^p::
send ^c 
sleep,100
IfExist, %clipboard%
    Run, properties %clipboard%



;;Alt+1 copy文件名 
!1::
path := CopySelection()
if path = 
    return
SplitPath, path, name 
clipboard = %name%
MouseGetPos,x0
tooltip File name: "%clipboard%" copied.
CancelToolTip()
return 

;;alt+2 copy 此文件所在的路径名 
!2:: 
path := CopySelection()
if path = 
    return
SplitPath, path, , dir 
clipboard = %dir%
MouseGetPos,x0
tooltip File Location: "%clipboard%" copied.
CancelToolTip()
return 

;;Alt+3 copy 此文件的全路径名 
!3:: 
path := CopySelection()
if path = 
    return
MouseGetPos,x0
clipboard = %path%
tooltip Path: "%clipboard%" copied
CancelToolTip()
return

;;Alt+4 copy 此文件的全路径名，并对目录分隔符进行转义
!4:: 
path := CopySelection()
if path = 
    return
MouseGetPos,x0
clipboard = "%path%"
StringReplace, clipboard, clipboard, \, \\, All
tooltip Text: %clipboard% copied
CancelToolTip()
return


;;Ctrl+Alt+O: Treat selected text as a local path, and select it in Explorer.
^!o::
path := CopySelection()
ifExist, %path%
{
	cmd := "explorer.exe /select," path
	Run, %cmd%
}
else
	MsgBox, Please select a path text.
return


$#G::
    ;Tip("Clipping...")  ;; include my mouse-tip library for this https://gist.github.com/2400547
    clip := CopyToClipboard()
    if (!clip) {
        return
    }
    addr := ExtractAddress(clip)
    if (!addr)
    {
        ; Google it
        ;Tip("Searching for [" SubStr(clip, 1, 50) "] ...")
        addr := "http://www.google.com.hk/search?q=" . clip
    }
    else {
        ; Go to it using system's default methods for the address
        ;Tip("Going to " Substr(addr, 1, 25) " ...")
    }

    Run %addr%
    return

;; utility functions




#IfWinActive ahk_class CabinetWClass
; open ‘cmd’ in the current directory
;
^+c::
OpenCmdInCurrent()
return
; 这个必须要在英文环境下才可以正常运作
; Opens the command shell ‘cmd’ in the directory browsed in Explorer.
; Note: expecting to be run when the active window is Explorer.

;;

;;;;; CapsNav ;;;;;;;

+CapsLock::CapsLock

CapsLock & h::CapsNav("Left")
CapsLock & j::CapsNav("Down")
CapsLock & k::CapsNav("Up")
CapsLock & l::CapsNav("Right")

CapsLock & n::CapsNav("Home")
CapsLock & p::CapsNav("End")

CapsLock & o::
CapsLock & .::CapsNav("Right", "!")
CapsLock & m::CapsNav("Left", "!")

CapsLock & u::
CapsLock & `;::
CapsLock & ,::
CapsLock & i::
Return
