;||=================================||;
;||                                 ||;
;||          -= ChortHotkey =-      ||;
;||                                 ||;
;||=================================||;

;ChortHotkey
;Version:0.3
;LastUpdated:10/5/2014
;author: Micheal Twocucao <twocucao@gmail.com>



;This is the main executable file for this script . all other Files are loaded
 ;from this one and some basic function and global variables are defined;

;Initailze CHK and load custom logic and supporting functions

CHK_Init()

#Include Custom\CHKCustomLogic.ahk
#Include Custom\Constants.ahk
;Initailze the script and load hotkeys;

#Include Scripts\CHKCoreFunctions.ahk
#Include Custom\CHKCustomHotkeys.ahk

Return

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

ShowMessage(title, message, icon)
{
     global
     Run %A_ScriptDir%\Utilities\SnarlCMD.exe snShowMessage 5 "%title%" "%message%" "%A_ScriptDir%\Images\%icon%",,UseErrorLevel
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
	Menu, Tray, Icon,Images\CHK.ico
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
SkSub_EditConfig(inifile,regex="") ;编辑配置文件！
{
	if not fileExist(inifile)      ;动态菜单未必有ini文件存在
		return
	if (regex<>"")  ;如果送了正则表达式进来
	{
		Loop
		{
			FileReadLine, L, %inifile%, %A_Index%
			if ErrorLevel
				break
			if regexmatch(L,regex)
			{
				LineNo:=a_index
				break
			}
		}
	}
	TextEditor:=SkSub_EnvTrans(SkSub_IniRead(GeneralSettings_ini, "General_Settings", "Default_TextEditor"))  ;默认文本编辑器
	TextEditor:=FileExist(TextEditor) ? TextEditor:"notepad.exe"       ;文本编辑器
	SplitPath,TextEditor,,,,namenoext
	LineJumpArgs:=SkSub_IniRead(GeneralSettings_ini, "TextEditor's_CommandLine", namenoext)
	if  (LineJumpArgs="Error" or LineNo="" )
		cmd :=TextEditor " " inifile
	else
	{
		cmd :=TextEditor " " LineJumpArgs
		StringReplace,cmd,cmd,$(FILEPATH),%inifile%
		StringReplace,cmd,cmd,$(LINENUM),%LineNo%
	}
	Run,%cmd%,,UseErrorLevel,TextEditor_PID
	WinActivate ahk_pid %TextEditor_PID%
	return
}

*/
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
Version:0.3
LastUpdated:10/5/2014
author: Micheal Twocucao <twocucao@gmail.com>
)
  Return