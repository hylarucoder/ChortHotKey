#SingleInstance Force
#Persistent
SetBatchLines,-1

Gui +LastFound
shWnd := WinExist()
DllCall( "RegisterShellHookWindow", UInt,shWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )

HookProcAdr := RegisterCallback( "HookProc", "F" )
hWinEventHook := SetWinEventHook( 0x3, 0x3, 0, HookProcAdr, 0, 0, 0 )

; Globals that need to be shared between ShellMessage() and HookProc()
ControlText =
ControlHwnd =
LastCharacter =

OnExit, HandleExit
Return

; See http://www.autohotkey.com/forum/post-123323.html
ShellMessage( wParam,lParam )
{
   global ControlText
   global ControlHwnd
   global LastCharacter

   ; See http://msdn.microsoft.com/en-us/library/ms644989.aspx
   If ( wParam = 1 || wParam = 4 ) ;  HSHELL_WINDOWCREATED := 1 OR HSHELL_WINDOWACTIVATED := 4
   {
       WinGetClass, Class, ahk_id %lParam%
       ; Is this an Explorer window?
       If (Class = "CabinetWClass" OR Class = "ExploreWClass") ; Might need adjustment for Vista/Win7
       {
           ; Do we have a Open/Save control handle available?
           If (ControlHwnd)
           {
               WinGetTitle, ExplorerTitle, ahk_id %lParam%
               If (LastCharacter <> "\")
               {
                   ; Change the path to the Explorer path
                   ControlSetText,, %ExplorerTitle%, ahk_id %ControlHwnd%
                   ControlSend,, {Enter}, ahk_id %ControlHwnd%
                   ; Put the original filename back in the dialog edit control
                   ControlSetText,, %ControlText%, ahk_id %ControlHwnd%
               }
               ; For cases like 7-Zip "Extract" dialog which contain pathnames, not filenames
               else
               {
                   ControlSetText,, %ExplorerTitle%\, ahk_id %ControlHwnd%
               }
               ; If Dialog is gone, reset globals to avoid extra work next time around
               If ErrorLevel
               {
                   ControlText =
                   ControlHwnd =
                   LastCharacter =
                   Exit
               }
           }
       }
   }
}

; See http://www.autohotkey.com/forum/topic35659.html
HookProc( hWinEventHook, Event, hWnd, idObject, idChild, dwEventThread, dwmsEventTime )
{
   global ControlText
   global ControlHwnd
   global LastCharacter

   If Event ; EVENT_SYSTEM_FOREGROUND = 0x3
   {
       ; Windows and dialog boxes need time to "settle". See AHK manual
       Sleep, 120
       WinGetClass, DialogClass, ahk_id %hWnd%
       ; Is this a typical Open/Save dialog box?
       If (DialogClass = "#32770")
       {
           ; Populate globals for use in ShellMessage
           ControlGet, ControlHwnd, Hwnd,, Edit1, ahk_id %hWnd%
           ControlGetText, ControlText, Edit1, ahk_id %hWnd%
           StringRight, LastCharacter, ControlText, 1
       }
   }
}

SetWinEventHook(eventMin, eventMax, hmodWinEventProc, lpfnWinEventProc, idProcess, idThread, dwFlags)
{
   DllCall("CoInitialize", Uint, 0)
   return DllCall("SetWinEventHook"
   , Uint,eventMin
   , Uint,eventMax
   , Uint,hmodWinEventProc
   , Uint,lpfnWinEventProc
   , Uint,idProcess
   , Uint,idThread
   , Uint,dwFlags)
}

UnhookWinEvent()
{
   Global
   DllCall( "UnhookWinEvent", Uint,hWinEventHook )
   DllCall( "GlobalFree", UInt,&HookProcAdr ) ; free up allocated memory for RegisterCallback
}

HandleExit:
UnhookWinEvent()
ExitApp
Return