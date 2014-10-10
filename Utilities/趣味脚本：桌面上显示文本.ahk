^#d::
Windo_ShowTextInDesktop:
	Gui +LastFound +OwnDialogs +AlwaysOnTop
	InputBox, Sid_Inputed,ShowTextInDesktop Let's Hoe! , `n`n         在桌面上显示点啥 ,, 285, 175,,,,,
	If ErrorLevel
		Return
	Gui Gui_ShowTextInDesktop: destroy
	Gui Gui_ShowTextInDesktop: color, red
	Gui Gui_ShowTextInDesktop: font, s32 cFF0000, 微软雅黑 bold
	Gui Gui_ShowTextInDesktop: -caption +toolwindow +0x02000000 ; toolwindow stops flicker of icon in taskbar


	Gui Gui_ShowTextInDesktop: add, text, x0 y0 Center  cFFFF80  ,%Sid_Inputed%
	Gui Gui_ShowTextInDesktop: +HwndHw_Gui_ShowTextInDesktop
	Gui Gui_ShowTextInDesktop: show
	winset, transcolor, red, ahk_id %Hw_Gui_ShowTextInDesktop%
	winget hw_desktop,ID,ahk_class Progman
	DllCall("SetParent","uint",Hw_Gui_ShowTextInDesktop,"uint",hw_desktop)
	return

Gui_ShowTextInDesktopGuiClose:
Gui_ShowTextInDesktopGuiEscape:
Windo_ShowTextInDesktop_destroy:
	Gui Gui_ShowTextInDesktop:Destroy
	Return



; http://www.autohotkey.com/community/viewtopic.php?t=7679