;||=================================||;
;||                                 ||;
;||          -= KOMMAND =-          ||;
;||                                 ||;
;||=================================||;

;
; Kommand.ahk
; Version: 0.3
; Last Updated: 11/5/2009
; Author: Kylir Horton <kylirh@gmail.com>
; Website: http://www.kylirhorton.com/kommand
;
; This is the main executable file for Kommand. All other files are loaded from this one and some basic functions and global variables are defined.
;

#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance, Force ; Make sure there is only one instance of Kommand running at a time.
#WinActivateForce ; Forces windows to appear when they're called.

; Initialize Kommand and load custom logic and supporting functions.
KMD_Init()
#Include Custom\CustomLogic.ahk
#Include Scripts\WindowPad.ahk

; Initialize the script and load hotkeys.
KMD_ComponentInit(false)
#Include Scripts\CoreHotkeys.ahk
#Include Custom\CustomHotkeys.ahk
return

KMD_Init()
{
     global ;set global variables
     SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
     SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.
     SetTitleMatchMode, 2
     Gui +LastFound

     ; Set the initial variables.
     EnvGet, UserProfile, USERPROFILE
     KMD_Enabled := true
     KMD_InsertMode := false
     KMD_KommandMode := false
     KMD_ViperMode := false
     KMD_Silent := false
     KMD_InitialMode := 2
     KMD_LastMode := 0
     KMD_FocusNewWindow := false
     KMD_Silent = false ; Turn on Snarl messages. and 

     ; Set a listener to detect new windows. This is used by the FocusAndRun function to ensure created windows are activated and brought to the top.
     hWnd := WinExist()
     DllCall("RegisterShellHookWindow", UInt, hWnd)
     MsgNum := DllCall("RegisterWindowMessage", Str, "SHELLHOOK")
     OnMessage(MsgNum, "ShellMessage")
}

KMD_ComponentInit(silent)
{
     global
     if (KMD_Enabled == true)
     {
          SetCapsLockState, Off
          KMD_LastMode := 0

          if (KMD_InitialMode == 1)
               KMD_StartInsertMode(silent)
          else if (KMD_InitialMode == 2)
               KMD_StartKommandMode(silent)
          else if (KMD_InitialMode == 3)
               KMD_StartViperMode(silent)
          else
               KMD_StartViperMode(silent)
     }
}

KMD_StartInsertMode(silent)
{
     global
     if (KMD_Enabled == true)
     {
          KMD_InsertMode := true
          KMD_KommandMode := false
          KMD_ViperMode := false
          Menu, Tray, Icon, %A_ScriptDir%\Images\Insert.ico, 0, 1
          ;if ((KMD_Silent == false) && (silent == false))
               ShowMessage("Insert Mode", "Keystrokes are now passed through.", "Insert.png")
     }
}

KMD_StartKommandMode(silent)
{
     global
     if (KMD_Enabled == true)
     {
          KMD_InsertMode := false
          KMD_KommandMode := true
          KMD_ViperMode := false
          Menu, Tray, Icon, %A_ScriptDir%\Images\Kommand.ico, 0, 1
          ;if ((KMD_Silent == false) && (silent == false))
               ShowMessage("Kommand Mode", "Window management keybindings are enabled.", "Kommand.png")
     }
}

KMD_StartViperMode(silent)
{
     global
     if (KMD_Enabled == true)
     {
          KMD_InsertMode := false
          KMD_KommandMode := false
          KMD_ViperMode := true
          Menu, Tray, Icon, %A_ScriptDir%\Images\Viper.ico, 0, 1
          ;if ((KMD_Silent == false) && (silent == false))
          {
               ShowMessage("Viper Mode", "Some Vi keybindings are enabled.", "Viper.png")
               
          }
     }
}

KMD_Disable(silent)
{
     global
     if (KMD_Enabled == true)
     {
          KMD_Enabled := false
          KMD_InsertMode := false
          KMD_KommandMode := false
          KMD_ViperMode := false
          Menu, Tray, Icon, %A_ScriptDir%\Images\Disabled.ico, 0, 1
          ;if ((KMD_Silent == false) && (silent == false))
               ShowMessage("Disabled", "Kommand is now disabled.", "Disabled.png")
     }
}

KMD_Enable(silent)
{
     global
     if (KMD_Enabled == false)
     {
          KMD_Enabled := true
          KMD_ComponentInit(silent)
     }
}

ShowMessage(title, message, icon)
{
     global
     Run %A_ScriptDir%\Utilities\SnarlCMD.exe snShowMessage 5 "%title%" "%message%" "%A_ScriptDir%\Images\%icon%",,UseErrorLevel
}

Start(command, mode = 0)
{
     global
     KMD_FocusNewWindow := true
     Run %command%,,UseErrorLevel
     
     if (A_LastError == 0)
     {
          if (mode == 1)
               KMD_StartInsertMode(true)
          else if (mode == 2)
               KMD_StartKommandMode(true)
          else if (mode == 3)
               KMD_StartViperMode(true)
     }
}

ShellMessage(wParam, lParam)
{
     global
     if ((wParam == 1) && (KMD_FocusNewWindow == true) && (A_LastError == 0))
     {
          WinActivate, ahk_id %lParam%
          KMD_FocusNewWindow := false
     }
}
