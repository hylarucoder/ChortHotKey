;||=================================||;
;||                                 														  ||;
;||          -= ChortHotkey =-      										  ||;
;||                                 														  ||;
;||=================================||;

;ChortHotkey
;Version:0.4
;LastUpdated:02/21/2015
;author: Micheal Twocucao <twocucao@gmail.com>


CHK_Init()
 ; Show a custom Snarl message.
ShowMessage("ChortHotkey", "Welcome to ChortHotkey By Laocao", "CHK.png")




#Include libs\Constants.ahk
#Include libs\methods.ahk

;;这里仅仅保留最基本的快捷键
;;AHK和其他编程语言不同的地方就在于，一般情况下变成语言很少会对键盘进行编程。那么，最为一名非AHK的程序员，自然仅仅使用AHK当中最强健的快捷键编程。

;;函数分为正常情况下获取数据getXXX setXXX ，文件IO，readFromXXX writeToXXX，鼠标键盘的复制粘贴copyXXX,pasteXXX
;;其他函数，比如程序启动RunXXX， 显示showXXX,隐藏hideXXX.

;;直接粘贴内容或者输入内容不写在methods里面，而是直接用



;;;;;;;;;;;;;;;;;;;;;;;;;;;常量定义
;;;;1.动态 - 输入大量文字
;;;;2.静态输入文字
;;;;3.程序位置


;;快速开启BLog编写
;~ /* ::/hexo::
;~ NOW = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%
;~ RunWait ,gvim
;~ Clipboard = %TEXT_HEXO1% %NOW%`n%TEXT_HEXO2%
;~ ;MsgBox , , , %Clipboard%,3
;~ return */

;;AHK的声明
:://AHK::
Clipboard = %TEXT_AHK%
Send,^v
return
;日期
:://date::
::/dd::
NOW = %A_YYYY%-%A_MM%-%A_DD%
Clipboard = %NOW%
Send,^v
return

:://time::
::/tt::
NOW = %A_Hour%:%A_Min%:%A_Sec%
Clipboard = %NOW%
Send,^v
return

:://lastupdate::
::/ll::
txt = "最后修改时间:"
NOW = %txt%  %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec% `n
Clipboard = %NOW%
Send,^v
return

:://mail::
::/mm::
NOW = "twocucao@gmail.com"
Clipboard = %NOW%
Send,^v
return

:://anouncement::
::/aa::
Clipboard = %TEXT_ANOUNCEMENT%
Send,^v
return
::/motto::
Clipboard = %motto%
Send,^v
return

;;;;;;;;;;;;;;;;;;;;;;;;;;;贴心小功能
;有道翻译
; #a::
; ShowYoudaoTrans(copySelection())
; return

#a::
clipboard := CopyToClipboard()
FileAppend ,%clipboard%,%A_Desktop%\Test.txt
FileAppend ,`r`n,%A_Desktop%\Test.txt
return

;快速cmd，其实还有其他方法，比如使用shift+右键选中，比如alt+d 输入cmd 回车，使用第三方软件等等
^+c::
OpenCmdInCurrent()
return



;;;;;;;;;;;;;;;;;;;;;;;;;;;快速开启程序
#e::
open(APP_TotalCMD,"TTOTAL_CMD")
return

#f::
open(App_Everything,"TTOTAL_CMD")
return

#s::
openFile(App_SublimeText3)
return
#v::
openFile(App_GVIM)
return


#q::
run ,%App_QQ%
return


;打开任务管理器
:://t::
if WinExist Windows Task Manager
WinActivate
else
Run taskmgr.exe
return

:://m::
Send twocucao@gmail.com
return


;打开系统属性
:://sys::
Run control sysdm.cpl
return


;;;;;;;;;;;;;;;;;;;;;;;;;;;快速关闭

~LButton & RButton::
        ; 按住不放 A 键再按 B 键的写法是 “A & B”（真的可以这样写哦，真的可以实现这样的快捷键）。“~”在这里是指示原有的左键仍要处理，若不加“~”则左键就失效了。
closeWindow()

return




;;搜索功能

$#G::
SearchInGoogle()
return


$#b::
SearchInBaidu()
return

;;淘宝
!t::
Send ^c
Run http://s.taobao.com/search?q=%clipboard%
return

 /*
╔══════════════════════════════════════╗
<<<<快速导航以及VI中文增强功能>>>>                                                  ║
╚══════════════════════════════════════╝
*/
;中文输入vi的缺点比较明显，就是在输入中文的时候立即切换成英文进行操作


;=====================================================================o
;                       CapsLock Initializer                         ;|
;---------------------------------------------------------------------o
SetCapsLockState, AlwaysOff                                          ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                       CapsLock Switcher:                           ;|
;---------------------------------o-----------------------------------o
;                    CapsLock + ` | {CapsLock}                       ;|
;---------------------------------o-----------------------------------o
CapsLock & `::                                                       ;|
GetKeyState, CapsLockState, CapsLock, T                              ;|
if CapsLockState = D                                                 ;|
	SetCapsLockState, AlwaysOff                                      ;|
else                                                                 ;|
	SetCapsLockState, AlwaysOn                                       ;|
KeyWait, ``                                                          ;|
return                                                               ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                         CapsLock Escaper:                          ;|
;----------------------------------o----------------------------------o
;                        CapsLock  |  {ESC}                          ;|
;----------------------------------o----------------------------------o
CapsLock::Send, {ESC}                                                ;|
;---------------------------------------------------------------------o


;=====================================================================o
;                    CapsLock Direction Navigator                    ;|
;-----------------------------------o---------------------------------o
;                      CapsLock + h |  Left                          ;|
;                      CapsLock + j |  Down                          ;|
;                      CapsLock + k |  Up                            ;|
;                      CapsLock + l |  Right                         ;|
;                      Ctrl, Alt Compatible                          ;|
;-----------------------------------o---------------------------------o
CapsLock & h::                                                       ;|
if GetKeyState("Control") = 0                                        ;|
{                                                                    ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, {Left}                                                 ;|
	else                                                             ;|
		Send, +{Left}                                                ;|
	return                                                           ;|
}                                                                    ;|
else {                                                               ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, ^{Left}                                                ;|
	else                                                             ;|
		Send, +^{Left}                                               ;|
	return                                                           ;|
}                                                                    ;|
return                                                               ;|
;-----------------------------------o                                ;|
CapsLock & j::                                                       ;|
if GetKeyState("Control") = 0                                        ;|
{                                                                    ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, {Down}                                                 ;|
	else                                                             ;|
		Send, +{Down}                                                ;|
	return                                                           ;|
}                                                                    ;|
else {                                                               ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, ^{Down}                                                ;|
	else                                                             ;|
		Send, +^{Down}                                               ;|
	return                                                           ;|
}                                                                    ;|
return                                                               ;|
;-----------------------------------o                                ;|
CapsLock & k::                                                       ;|
if GetKeyState("Control") = 0                                        ;|
{                                                                    ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, {Up}                                                   ;|
	else                                                             ;|
		Send, +{Up}                                                  ;|
	return                                                           ;|
}                                                                    ;|
else {                                                               ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, ^{Up}                                                  ;|
	else                                                             ;|
		Send, +^{Up}                                                 ;|
	return                                                           ;|
}                                                                    ;|
return                                                               ;|
;-----------------------------------o                                ;|
CapsLock & l::                                                       ;|
if GetKeyState("Control") = 0                                        ;|
{                                                                    ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, {Right}                                                ;|
	else                                                             ;|
		Send, +{Right}                                               ;|
	return                                                           ;|
}                                                                    ;|
else {                                                               ;|
	if GetKeyState("alt") = 0                                        ;|
		Send, ^{Right}                                               ;|
	else                                                             ;|
		Send, +^{Right}                                              ;|
	return                                                           ;|
}                                                                    ;|
return                                                               ;|
;---------------------------------------------------------------------o

;=====================================================================o
;                           CapsLock Deletor                         ;|
;-----------------------------------o---------------------------------o
;                               ;|
;-----------------------------------o---------------------------------o                                           ;|
                                         ;|
CapsLock & n:: Send, {BS}
CapsLock & m:: Send, ^{BS}
CapsLock & ,:: Send, ^{Del}
CapsLock & .:: Send, {Del}                                      ;|
;---------------------------------------------------------------------o
CapsLock & a:: Send, {end}
CapsLock & o:: Send, {end}{Enter}


;;CapsLock+1 copy文件名
CapsLock & 1::
GetFileName()
return

;;CapsLock+2 copy 此文件所在的路径名
CapsLock & 2::
GetFileFolderPath()
return

;;CapsLock+3 copy 此文件的全路径名
CapsLock & 3::
GetFilePath()
return

;;CapsLock+4 copy 此文件的全路径名，并对目录分隔符进行转义
CapsLock & 4::
GetFilePath4Win()
return
;;其中5-9

;;;;;;;;;;;;;;;;;;;;;;;;;;;快速打开文件夹

;近期常用目录
CapsLock & 5::		ShowDir(FOLDER_WORKSPACE)
CapsLock & 6::		ShowDir(FOLDER_UNDO)
;云端备份目录
CapsLock & 7::		ShowDir(FOLDER_ONDRIVE)
CapsLock & 8::		ShowDir(FOLDER_BAIDUYUN)
;娱乐
CapsLock & 9::		ShowDir(FOLDER_FUN)
CapsLock & 0::		ShowDir(FOLDER_SYSCONFIG)




CHK_Init()
{
	global
	SetTitleMatchMode, RegEx
	CoordMode, Mouse, Screen
	DetectHiddenWindows, On
	SetScrollLockState, Off
	SetCapsLockState, AlwaysOff
	SendMode Input
	SetWorkingDir, %A_ScriptDir%
	EnvGet, UserProfile, UserProfile
	SkSub_CreatTrayMenu()
	;CHK_Enabled := True;

}



 /*
╔══════════════════════════════════════╗
<<<<托盘菜单处理部分>>>>                                                  ║
╚══════════════════════════════════════╝
*/
SkSub_CreatTrayMenu()
{
	If FileExist("Images\CHK.ico")
    	Menu, Tray, Icon, Images\CHK.ico
	Menu, Tray, Tip, CHK   to save yourtime.
	Menu, Tray, NoStandard
	Menu, tray, add,  ABOUT ME , TrayHandle_About
	Menu, tray, add ; 分隔符
	Menu, tray, add, 编辑热键,TrayHandle_GeneralSettings
	Menu, tray, add, 编辑全局常量,TrayHandle_GeneralSettings
	Menu, tray, add, 编辑全局常量,TrayHandle_GeneralSettings
	Menu, tray, add ; 分隔符
	Menu, tray, add, 重启脚本,TrayHandle_ReLoad
	Menu, tray, add, 退出,TrayHandle_Exit
}

/*
╔══════════════════════════════════════╗
<<<<托盘菜单处理部分>>>>                         ║
╚══════════════════════════════════════╝
*/
TrayHandle_ReLoad:
  Reload
Return
TrayHandle_Exit:
  ExitApp
Return

TrayHandle_GeneralSettings:
    ;SkSub_EditConfig(GeneralSettings_ini,"")
    return

TrayHandle_About:
  MsgBox, , About CHK,
(
ChortHotkey
Version:0.4
LastUpdated:02/21/2015
author: Micheal Twocucao <twocucao@gmail.com>
)
  Return

