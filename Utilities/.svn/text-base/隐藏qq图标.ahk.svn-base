;win7适用，隐藏后，好像会有一个空位在时间显示区，
;哪位兄弟真有这个需求的，帮忙折腾下
;对于隐藏，比较好的方法我建议用desktops.exe
DetectHiddenWindows On

f1::  ;隐藏
xx:=TrayIconsAll("qq.exe")
Loop,parse,xx,|
{

    SendMessage, 0x404, %A_LoopField%, 1, ToolbarWindow321, ahk_class Shell_TrayWnd    ; TB_HIDEBUTTON
    SendMessage, 0x404, %A_LoopField%, 1, ToolbarWindow321, ahk_class NotifyIconOverflowWindow    ; TB_HIDEBUTTON
    SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
    SendMessage, 0x1A, 0, 0, , ahk_class NotifyIconOverflowWindow
}
Return

f2::  ;显示
Loop,parse,xx,|
{
    SendMessage, 0x404, %A_LoopField%, 0, ToolbarWindow321, ahk_class Shell_TrayWnd    ; TB_HIDEBUTTON
    SendMessage, 0x404, %A_LoopField%, 0, ToolbarWindow321, ahk_class NotifyIconOverflowWindow    ; TB_HIDEBUTTON
    SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
    SendMessage, 0x1A, 0, 0, , ahk_class NotifyIconOverflowWindow
}
Return
;==============================================
;==============================================
;==============================================


TrayIcons(sExeName = "")
{
    WinGet,    pidTaskbar, PID, ahk_class Shell_TrayWnd
    hProc:=    DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
    pProc:=    DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 32, "Uint", 0x1000, "Uint", 0x4)
    idxTB:=    GetTrayBar()
        SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd    ; TB_BUTTONCOUNT
    Loop,    %ErrorLevel%
    {
        SendMessage, 0x417, A_Index-1, pProc, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd    ; TB_GETBUTTON
        VarSetCapacity(btn,32,0), VarSetCapacity(nfo,32,0)
        DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &btn, "Uint", 32, "Uint", 0)
            iBitmap    := NumGet(btn, 0)
            idn    := NumGet(btn, 4)
            Statyle := NumGet(btn, 8)
        If    dwData    := NumGet(btn,12)
            iString    := NumGet(btn,16)
        Else    dwData    := NumGet(btn,16,"int64"), iString:=NumGet(btn,24,"int64")
        DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 32, "Uint", 0)
        If    NumGet(btn,12)
            hWnd    := NumGet(nfo, 0)
        ,    uID    := NumGet(nfo, 4)
        ,    nMsg    := NumGet(nfo, 8)
        ,    hIcon    := NumGet(nfo,20)
        Else    hWnd    := NumGet(nfo, 0,"int64"), uID:=NumGet(nfo, 8), nMsg:=NumGet(nfo,12)
        WinGet, pid, PID,                  ahk_id %hWnd%
        WinGet, sProcess, ProcessName, ahk_id %hWnd%
        WinGetClass, sClass,              ahk_id %hWnd%
        If !sExeName || (sExeName = sProcess) || (sExeName = pid)
            VarSetCapacity(sTooltip,128), VarSetCapacity(wTooltip,128*2)
        ,    DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128*2, "Uint", 0)
        ,    DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
        ,    sTrayIcons .= idn . "|"
    }
    DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pProc, "Uint", 0, "Uint", 0x8000)
    DllCall("CloseHandle", "Uint", hProc)
    Return    sTrayIcons
}

TrayIconsOverflow(sExeName = "")
{
    WinGet,    pidTaskbar, PID, ahk_class NotifyIconOverflowWindow
    hProc:=    DllCall("OpenProcess", "Uint", 0x38, "int", 0, "Uint", pidTaskbar)
    pProc:=    DllCall("VirtualAllocEx", "Uint", hProc, "Uint", 0, "Uint", 32, "Uint", 0x1000, "Uint", 0x4)
    idxTB:=    1
        SendMessage, 0x418, 0, 0, ToolbarWindow32%idxTB%, ahk_class NotifyIconOverflowWindow    ; TB_BUTTONCOUNT
    Loop,    %ErrorLevel%
    {
        SendMessage, 0x417, A_Index-1, pProc, ToolbarWindow32%idxTB%, ahk_class NotifyIconOverflowWindow    ; TB_GETBUTTON
        VarSetCapacity(btn,32,0), VarSetCapacity(nfo,32,0)
        DllCall("ReadProcessMemory", "Uint", hProc, "Uint", pProc, "Uint", &btn, "Uint", 32, "Uint", 0)
            iBitmap    := NumGet(btn, 0)
            idn    := NumGet(btn, 4)
            Statyle := NumGet(btn, 8)
        If    dwData    := NumGet(btn,12)
            iString    := NumGet(btn,16)
        Else    dwData    := NumGet(btn,16,"int64"), iString:=NumGet(btn,24,"int64")
        DllCall("ReadProcessMemory", "Uint", hProc, "Uint", dwData, "Uint", &nfo, "Uint", 32, "Uint", 0)
        If    NumGet(btn,12)
            hWnd    := NumGet(nfo, 0)
        ,    uID    := NumGet(nfo, 4)
        ,    nMsg    := NumGet(nfo, 8)
        ,    hIcon    := NumGet(nfo,20)
        Else    hWnd    := NumGet(nfo, 0,"int64"), uID:=NumGet(nfo, 8), nMsg:=NumGet(nfo,12)
        WinGet, pid, PID,                  ahk_id %hWnd%
        WinGet, sProcess, ProcessName, ahk_id %hWnd%
        WinGetClass, sClass,              ahk_id %hWnd%
        If !sExeName || (sExeName = sProcess) || (sExeName = pid)
            VarSetCapacity(sTooltip,128), VarSetCapacity(wTooltip,128*2)
        ,    DllCall("ReadProcessMemory", "Uint", hProc, "Uint", iString, "Uint", &wTooltip, "Uint", 128*2, "Uint", 0)
        ,    DllCall("WideCharToMultiByte", "Uint", 0, "Uint", 0, "str", wTooltip, "int", -1, "str", sTooltip, "int", 128, "Uint", 0, "Uint", 0)
        ,    sTrayIcons .= idn . "|"
    }
    DllCall("VirtualFreeEx", "Uint", hProc, "Uint", pProc, "Uint", 0, "Uint", 0x8000)
    DllCall("CloseHandle", "Uint", hProc)
    Return    sTrayIcons
}

TrayIconsAll(sExeName = "")
{
    return ret:= TrayIcons(sExeName) "`n" TrayIconsOverflow(sExeName)
}


RemoveTrayIcon(hWnd, uID, nMsg = 0, hIcon = 0, nRemove = 2)
{
    NumPut(VarSetCapacity(ni,444,0), ni)
    NumPut(hWnd , ni, 4)
    NumPut(uID  , ni, 8)
    NumPut(1|2|4, ni,12)
    NumPut(nMsg , ni,16)
    NumPut(hIcon, ni,20)
    Return    DllCall("shell32\Shell_NotifyIconA", "Uint", nRemove, "Uint", &ni)
}


HideTrayIcon(idn, bHide = True)
{
    idxTB := GetTrayBar()
    SendMessage, 0x404, idn, bHide, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd    ; TB_HIDEBUTTON
    SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

DeleteTrayIcon(idx)
{
    idxTB := GetTrayBar()
    SendMessage, 0x416, idx - 1, 0, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd    ; TB_DELETEBUTTON
    SendMessage, 0x1A, 0, 0, , ahk_class Shell_TrayWnd
}

MoveTrayIcon(idxOld, idxNew)
{
    idxTB := GetTrayBar()
    SendMessage, 0x452, idxOld - 1, idxNew - 1, ToolbarWindow32%idxTB%, ahk_class Shell_TrayWnd ; TB_MOVEBUTTON
}

GetTrayBar()
{
    ControlGet, hParent, hWnd,, TrayNotifyWnd1  , ahk_class Shell_TrayWnd
    ControlGet, hChild , hWnd,, ToolbarWindow321, ahk_id %hParent%
    Loop
    {
        ControlGet, hWnd, hWnd,, ToolbarWindow32%A_Index%, ahk_class Shell_TrayWnd
        If  Not    hWnd
            Break
        Else If    hWnd = %hChild%
        {
            idxTB := A_Index
            Break
        }
    }
    Return    idxTB
}
