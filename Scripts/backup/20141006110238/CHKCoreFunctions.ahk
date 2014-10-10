

;open the folder

Txt2TEMP(onedrive)
{
    Clipboard = 
    Send , ^c
    ClipWait,2
    FileAppend ,%clipboard%,%A_Desktop%\TEMP\Doc\Text.txt
    FileAppend ,`r`n,%A_Desktop%\TEMP\Doc\Text.txt
    ToolTip ,%Clipboard%
    Return
}

GetFileName()
{
path := CopySelection()
if path = 
    return
SplitPath, path, name 
clipboard = %name%
MouseGetPos,x0
tooltip File name: "%clipboard%" copied.
CancelToolTip()
return 
}


GetFilePath()
{
path := CopySelection()
if path = 
    return
MouseGetPos,x0
clipboard = %path%
tooltip Path: "%clipboard%" copied

CancelToolTip()
return
}

GetFilePath4Win()
{
    path := CopySelection()
    if path = 
        return
    MouseGetPos,x0
    clipboard = "%path%"
    StringReplace, clipboard, clipboard, \, \\, All
    tooltip Text: %clipboard% copied
    CancelToolTip()
    return
}

GetFileFolderPath()
{
    path := CopySelection()
    if path = 
        return
    SplitPath, path, , dir 
    clipboard = %dir%
    MouseGetPos,x0
    tooltip File Location: "%clipboard%" copied.
    CancelToolTip()
    return 

}

 SearchInBaidu()
 {
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
        addr := "http://www.baidu.com/s?wd=" . clip
    }
    else {
        ; Go to it using system's default methods for the address
        ;Tip("Going to " Substr(addr, 1, 25) " ...")
    }

Run %addr%
return
}


;programming
openTc(P_TotalCMD)
{
	IfWinNOTExist ahk_class TTOTAL_CMD
	run, %P_TotalCMD%
	else
	IfWinActive ahk_class TTOTAL_CMD
	WinMinimize
	else WinActivate
	return
}

OpenAHK() 
{
;    Msgbox %SCITE%
    Run %SCITE%
    Sleep 50
    WinActivate, ahk_class PX_WINDOW_CLASS
}


;
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
        Run, cmd /K cd /D "%full_path%"
    }
    else
    {
        Run, cmd /K cd /D "C:\"
    }
}





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
ShowYoudaoTrans(KeyWord2)
{
;youdao翻译_by_sunwind
;作者：sunwind（1576157）
;必须先配置第20/21行参数 APIkey/keyfrom
;KeyWord1=中国
;MsgBox % fanyiapi(KeyWord1)

jsonString:=fanyiapi(KeyWord2)


音标:= json(jsonString, "basic.phonetic")
基本释义:= json(jsonString, "basic.explains")
网络释义:= json(jsonString, "web.value")
 ToolTip, %KeyWord2% %音标%`n`n基本释义`n%基本释义% `n`n网络释义：`n%网络释义%
Sleep,5000
ToolTip
Return
;调用有道API需要配置自己的APIkey！

 /*
    Function: JSON
    
    Parameters:
        js - source
        s - path to element
        v - (optional) value to overwrite
    
    Returns:
        Value of element (prior to change).
    
    License:
        - Version 2.0 by Titan <http://www.autohotkey.net/~Titan/#json>
        - New BSD license terms <http://www.autohotkey.net/~Titan/license.txt>
*/

  ;~ jsonString=
;~ (
;~ {
;~ "translation":["说"],
;~ "basic":{
        ;~ "phonetic":"spi:k",
        ;~ "explains":["vi. 说话；演讲；表明；陈述","vt. 讲话；发言；讲演"]
        ;~ },
;~ "query":"speak",
;~ "errorCode":0,
;~ "web":[
        ;~ {"value":["说","谈话","绅士宝","说话"],"key":"speak"},
        ;~ {"value":["更不用说","更不必说","谈及","讲到"],"key":"speak of"},
        ;~ {"value":["讲日语","说日语"],"key":"speak Japanese"},
        ;~ {"value":["出言不逊","出言无状"],"key":"speak rudely"},
        ;~ {"value":["实话实说","打开天窗说亮话"],"key":"Speak Frankly"},
        ;~ {"value":["拿腔拿调"],"key":"speak affectedly"},
        ;~ {"value":["轻声低语","轻声细语","温柔的倾诉"],"key":"Speak Softly"},
        ;~ {"value":["说法语","讲法语"],"key":"speak French"},
        ;~ {"value":["表示反对","发表抨击","说"],"key":"Speak Against"},
        ;~ {"value":["粉红虞美人","大声说吧"],"key":"Speak Louder"}
        ;~ ]
;~ }
 ;~ )
 
;~ 输出：
;~ speak [spi:k]  
;~ 基本释义
;~ vi. 说话；演讲；表明；陈述
;~ vt. 讲话；发言；讲演
;~ 网络释义
  ;~ 说
  ;~ 谈话
  ;~ 绅士宝
  ;~ 说话
    
  
;~ 短语
;~ speak of 更不用说 ; 更不必说 ; 谈及 ; 讲到
;~ speak Japanese 讲日语 ; 说日语
;~ speak rudely 出言不逊 ; 出言无状 
return
}

fanyiapi(KeyWord)
  {
    APIkey=365203413
    keyfrom=twoucaou888
    KeyWord:=UrlEncode(KeyWord,"UTF-8")
    url:="http://fanyi.youdao.com/fanyiapi.do?keyfrom=" . keyfrom . "&key=" . APIkey . "&type=data&doctype=json&version=1.1&q=" . KeyWord
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", url)
    WebRequest.Send()
    result := WebRequest.ResponseText
    Return result
  }
;Url转码UTF-8
UrlEncode(str, enc="UTF-8")
  {
    hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
    VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
    While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
    encoded .= hex
    Return encoded
  }
  json(ByRef js, s, v = "") {
    j = %js%
    Loop, Parse, s, .
    {
        p = 2
        RegExMatch(A_LoopField, "([+\-]?)([^[]+)((?:\[\d+\])*)", q)
        Loop {
            If (!p := RegExMatch(j, "(?<!\\)(""|')([^\1]+?)(?<!\\)(?-1)\s*:\s*((\{(?:[^{}]++|(?-1))*\})|(\[(?:[^[\]]++|(?-1))*\])|"
                . "(?<!\\)(""|')[^\7]*?(?<!\\)(?-1)|[+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:,|$|\})", x, p))
                Return
            Else If (x2 == q2 or q2 == "*") {
                j = %x3%
                z += p + StrLen(x2) - 2
                If (q3 != "" and InStr(j, "[") == 1) {
                    StringTrimRight, q3, q3, 1
                    Loop, Parse, q3, ], [
                    {
                        z += 1 + RegExMatch(SubStr(j, 2, -1), "^(?:\s*((\[(?:[^[\]]++|(?-1))*\])|(\{(?:[^{\}]++|(?-1))*\})|[^,]*?)\s*(?:,|$)){" . SubStr(A_LoopField, 1) + 1 . "}", x)
                        j = %x1%
                    }
                }
                Break
            }
            Else p += StrLen(x)
        }
    }
    If v !=
    {
        vs = "
        If (RegExMatch(v, "^\s*(?:""|')*\s*([+\-]?\d+(?:\.\d*)?|true|false|null?)\s*(?:""|')*\s*$", vx)
            and (vx1 + 0 or vx1 == 0 or vx1 == "true" or vx1 == "false" or vx1 == "null" or vx1 == "nul"))
            vs := "", v := vx1
        StringReplace, v, v, ", \", All
        js := SubStr(js, 1, z := RegExMatch(js, ":\s*", zx, z) + StrLen(zx) - 1) . vs . v . vs . SubStr(js, z + StrLen(x3) + 1)
    }
    Return, j == "false" ? 0 : j == "true" ? 1 : j == "null" or j == "nul"
        ? "" : SubStr(j, 1, 1) == """" ? SubStr(j, 2, -1) : j
} 