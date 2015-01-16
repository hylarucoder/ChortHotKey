;||=================================||;
;||                                 														||;
;||          -= ChortHotkey =-      										||;
;||                                 														||;
;||=================================||;

;ChortHotkey
;Version:0.3
;LastUpdated:10/5/2014
;author: Micheal Twocucao <twocucao@gmail.com>



;This is the main executable file for this script . all other Files are loaded
 ;from this one and some basic function and global variables are defined;

;Initailze CHK and load custom logic and supporting functions

CHK_Init()

#Include ChorthotKeyLibs\WelCome.ahk
#Include ChorthotKeyLibs\Constants.ahk
;Initailze the script and load hotkeys;

#Include ChorthotKeyLibs\CoreMethods.ahk
#Include ChorthotKeyLibs\CustomHotkeys.ahk

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
Version:0.3
LastUpdated:10/5/2014
author: Micheal Twocucao <twocucao@gmail.com>
)
  Return
  
  
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;常用程序启动;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


