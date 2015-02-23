#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;;;;;;1.热键触发命令Run

//可以执行path变量中的exe lnk文件（不需要后缀）
#1::Run notepad
#2::Run notepad test.file

//可以执行 网页
#j::Run www.jandan.net

;;;2.热字符串触发命令
::/mail::gmail@gmail.com

::/gs::
clipboard = 煎蛋娱乐有限公司
    ;把文字发送到剪贴板（Clipboard）
Send ^v
    ;Send 也是很常用的命令，表示向当前程序发送按键，根据上一篇快餐店文章我们可以推断，这句命令是向当前程序发送 Ctrl + V（粘贴的快捷键）。也就是把已经发送剪贴板的文字粘贴出来。
return

::/dd::
d = %A_YYYY%-%A_MM%-%A_DD%
    ;获得系统时间比如今天的时间：2007-10-21。如果需要“年”的话请替换上面的“-”。
clipboard = %d%
    ;把 d 的值发送到剪贴板，变量是不用声明的，想引用变量的值，就在变量的前后加“%”。第二行的变量是 AHK 自带的变量。
Send ^v
return


;;;;;;timer  sleep 计时器

#t::
InputBox, time, 煎蛋牌泡面专用计时器, 请输入一个时间（单位是秒）
        ; 弹出一个输入框，标题是“煎蛋牌泡面专用计时器”，内容是“请输入一个时间（单位是秒）”
time := time*1000
        ; 如果一个变量要做计算的话，一定要像这样写，和平常的算式相比，多了一个冒号。sleep 的时间是按照千分之一秒算的，这里乘以 1000 就变成秒了。
Sleep,%time%
MsgBox 水开拉
return


;;;;;

~LButton & RButton::
        ; 按住不放 A 键再按 B 键的写法是 “A & B”（真的可以这样写哦，真的可以实现这样的快捷键）。“~”在这里是指示原有的左键仍要处理，若不加“~”则左键就失效了。
WinGetClass, class, A
        ; 这个语句是专门对付 Gtalk 的。获得当前活动窗口（最后的 A 参数就是代表当前活动窗口）的类（class）名，并赋值给 class。类名这个词好专业啊。GTalk 的聊天窗口的标题是没有规律的，但它们都是同一类，其类名都是 Chat View。用比喻来说，我们都是同一个“类”，我们都是人类，人这个类又可以细分为很多“类”。
IfInString, class, Chat
        ; 判断 class 中是否含有 chat
{
send !{F4}
return
        ; 有的话，说明很可能（99.9%）是 Gtalk 的聊天窗口啦，发送 Alt + F4 关闭聊天窗口。并且结束脚本。
}
WinGetActiveTitle, Title
        ; 获取当前活动窗口的标题，赋值给 Title
IfInString, Title, Firefox
        ; 判断 Title 中是否含有 Firefox ，无论我们打开什么网页，这个是永远不变的，你也可以试试用类名来判断。文末会介绍怎么获得一个窗口的类名。
{
send ^w
return
}
IfInString, Title, AutoHotkey
{
send {esc}
return
}
else
        ; 这个 else 是多余的，历史遗留问题。orz
WinClose, %Title%
return



;;静止
; Disable Alt+Tab

!Tab::Return

; Disable Windows Key + Tab

#Tab::Return

; Disable Left Windows Key

LWin::Return

; Disable Right Windows Key

RWin::Return
;这样的话就不会按错导致全屏退出了，但是如果游戏具有反作弊软件可能会有误判

#3
lx := A_ScreenWidth - 110
ly := 60
Gui, +AlwaysOnTop +ToolWindow -caption
;Gui, Add, Text, x1 y25 w35,
Gui, Show,NoActivate W37 H37 X%lx% Y%ly% ,
gosub,color
return
color:
loop
{
MouseGetPos, x, y
PixelGetColor, c, %x%, %y%, RGB
StringRight c,c,6
if c <> %c2%
{
c2 = %c%
Gui, color, %c%
; GUICONTROL,,Static1,%c%
traytip,,WIN+C复制 `n %c%
}
SLEEP,50
}
return
#c::
clipboard = %c%
return
;http://hi.baidu.com/helfee/blog/item/29150ff3a34d02c80a46e0c2.html
;作者：helfee