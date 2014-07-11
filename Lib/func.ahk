;open the foldere

fastTxt(onedrive)
{
    Clipboard = 
    Send , ^c
    ClipWait,2
    FileAppend ,%clipboard%,%onedrive%\TEMP\Test.txt
    FileAppend ,`r`n,%onedrive%\TEMP\Test.txt
    ToolTip ,%Clipboard%
    Return
}
ShowDir(path)
{
	ifExist, %path%
	{
		Run,explore %path%
	}
	else
		MsgBox, Please select a path text.
	return
}
;复制选中部分
CopySelection()
{
    clipboard =
    send ^c 
    ClipWait, 1
    if ErrorLevel
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        return
    }
    return clipboard
}
;
CancelToolTip()
{
	loop
	{
	    MouseGetPos,x1 ;鼠标挪动取消提示框
	    if x1!=%x0%
	    { 
	        tooltip
	        break
	    }
	}
}

;; Safely copies-to-clipboard, restoring clipboard's original value after
;; Returns the captured clip text, or "" if unsuccessful after 4 seconds
CopyToClipboard()
{
    ; Wait for modifier keys to be released before we send ^C
    KeyWait LWin
    KeyWait Alt
    KeyWait Shift
    KeyWait Ctrl

    ; Capture to clipboard, then restore clipboard's value from before capture
    ExistingClipboard := ClipboardAll
    Clipboard =
    SendInput ^{Insert}
    ClipWait, 4
    NewClipboard := Clipboard
    Clipboard := ExistingClipboard
    if (ErrorLevel)
    {
        MsgBox, The attempt to copy text onto the clipboard failed.
        ;Tip("The attempt to copy text onto the clipboard failed.")
        return ""
    }
    return NewClipboard
}


;; Extracts an address from anywhere in str.
;; Recognized addresses include URLs, email addresses, domain names, Windows local paths, and Windows UNC paths.
ExtractAddress(str)
{
    if (RegExMatch(str, "S)((http|https|ftp|mailto:)://[\S]+)", match))
        return match1
    if (RegExMatch(str, "S)(\w+@[\w.]+\.(com|net|org|gov|cc|edu|info))", match))
        return "mailto:" . match1
    if (RegExMatch(str, "S)(www\.\S+)", match))
        return "http://" . match1
    if (RegExMatch(str, "S)(\w+\.(com|net|org|gov|cc|edu|info))", match))
        return "http://" . match1
    if (RegExMatch(str, "S)([a-zA-Z]:[\\/][\\/\-_.,\d\w\s]+)", match))
        return match1
    if (RegExMatch(str, "S)(\\\\[\w\-]+\\.+)", match))
        return match1
    return ""
}


;
OpenCmdInCurrent()
{
    ; This is required to get the full path of the file from the address bar
    WinGetText, full_path, A
    ; Split on newline (`n)
    StringSplit, word_array, full_path, `n
    ; Take the first element from the array
    full_path = %word_array1%
    ; strip to bare address
    full_path := RegExReplace(full_path, "Address: ", "")
    ; Just in case – remove all carriage returns (`r)
    StringReplace, full_path, full_path, `r, , all

    IfInString full_path, \
    {
        Run, cmd /K cd /D "%full_path%""
    }
    else
    {
        Run, cmd /K cd /D "C:\"
    }
}


CapsNav(action, initmod = "", mod = "+")
{
	If ! GetKeyState("alt")
		Send % initmod "{" action "}"
	Else
		Send % mod . initmod "{" action "}"
	SetCapsLockState, AlwaysOff
}

SublimeOpen(file,SublimeText3) ; Refocuses Sublime if file is opened while focused
{
;    Msgbox %SublimeText3%
    Run %SublimeText3% %file%
    Sleep 50
    WinActivate, ahk_class PX_WINDOW_CLASS
}