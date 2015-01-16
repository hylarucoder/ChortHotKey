;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;常用程序启动;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#z::
Clipboard:=GetActiveBrowserURL()
return

;youdao

#a::
 
ShowYoudaoTrans(copySelection())
return

;启动TC
;老板键设置

#w::
openEverything(P_EVERYTHING)
return
#e::
openTc(P_TotalCMD)
return
#q::Run %QQ%

;;run enhanced pro
^+g::run %Go%


^+c::
OpenCmdInCurrent()
return
; 这个必须要在英文环境（win7）或者中文（XP）下才可以正常运作

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;程序启动;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;快速拷贝到onedrive
F1::
Txt2TEMP(onedrive)
CancelToolTip()
return
;;常用程序的设计 win+按键

;;文件管理，窗口管理，功能性管理^+



;近期常用目录
^+1::		ShowDir(F_StudyNow)
^+2::		ShowDir(F_Downloads)
;云端备份目录
^+3::		ShowDir(F_TEMP)
;视频
^+4::		ShowDir(F_DocAndCode)




;
#s::
Run, %P_SublimeText3%
return


;文件夹管理  以今的时间作为命名标准
^+m::
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
^+h::
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

^+e::
If value = 0
value = 1
Else
value = 0
RegWrite, REG_DWORD, HKEY_CURRENT_USER, Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\, HideFileExt, %Value%
send { AppsKey } e
send F5
        ; 点击键盘上的 AppsKey ，弹出右键，选择“刷新(e)” 。
return



;;Alt+1 copy文件名 
!1::
GetFileName()
return

;;alt+2 copy 此文件所在的路径名 
!2:: 
GetFileFolderPath()
return

;;Alt+3 copy 此文件的全路径名 
!3:: 
GetFilePath()
return

;;Alt+4 copy 此文件的全路径名，并对目录分隔符进行转义
!4:: 
GetFilePath4Win()
return

;;alt + 0: Treat selected text as a local path, and select it in Explorer.
!0::
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

$#b::
 SearchInBaidu()
 return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;输入管理;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;blog输入管理    声明 + 日期

:o:sm~::
sendinput ,%T_Claim%
return
:o:tb~::
sendinput ,%T_MarkdownTable%
return
:o:ahk~::
SendInput,%T_ahk%
return
;;android XML快捷输入
;;;;;;;五大布局xml快速输入
:o:~vrl::
Clipboard := vrl
sendinput ,^v{Up}
return
:o:~vll::
Clipboard := vll
sendinput ,^v{Up}
return

:o:~vtl::
Clipboard := vtl
sendinput ,^v{Up}
return

:o:~vfr::
Clipboard := vfr
sendinput ,^v{Up}
return

:o:~vgl::
Clipboard := vgl
sendinput ,^v{Up}
return
;;;;;;;;;;基本的view文件输入
;btn tv 
:o:~vbtn::
Clipboard := vbtn
sendinput ,^v{Left}{Left}{Enter}{Enter}{Up}
return

:o:~vtv::
Clipboard := vtv
sendinput ,^v{Left}{Left}{Enter}{Enter}{Up}
return

:o:~vimgView::
Clipboard := vimgView
sendinput ,^v{Left}{Left}{Enter}{Enter}{Up}
return

:o:~vimgbtn::
Clipboard := vimgbtn
sendinput ,^v{Left}{Left}{Enter}{Enter}{Up}
return

::~date::
getTimeText()
return


;;Gmail地址缩写  常用邮箱以及账号管理
:o:g@::twocucao@gmail.com
:o:~pps::
Clipboard := PPS
SendInput,^v
return

#IfWinActive ahk_class ConsoleWindowClass
^v::
send %Clipboard%
return