

;2015-1-20 20:17:51
getTimeText()
{
  d = %A_YYYY%-%A_MM%-%A_DD% %A_Hour%:%A_Min%:%A_Sec%
  Send %d%
}

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


;programming
openEverything(P_Everything)
{
	IfWinNOTExist ahk_class EVERYTHING
	run, %P_Everything%
	else
	IfWinActive ahk_class EVERYTHING
	WinMinimize
	else WinActivate
	return
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
        ToolTip,"没有粘贴成功"
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

 ToolTip, %KeyWord2% %音标%`n`n基本释义`n%基本释义% `n`n网络释义：`n%网络释义%,已经保存到桌面上test.txt
 FileAppend ,%KeyWord2% %基本释义%  %网络释义% ,%A_Desktop%\Test.txt

FileAppend ,`r`n,%A_Desktop%\Test.txt
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



; AutoHotkey Version: AutoHotkey 1.1
; Language:           English
; Platform:           Win7 SP1 / Win8.1
; Author:             Antonio Bueno <user atnbueno of Google's popular e-mail service>
; Short description:  Gets the URL of the current (active) browser tab for most modern browsers
; Last Mod:           2014-07-05


GetActiveBrowserURL() {
    WinGetClass, sClass, A
    If sClass In Chrome_WidgetWin_1,Chrome_WidgetWin_0,Maxthon3Cls_MainFrm
        Return GetBrowserURL_ACC(sClass)
    Else
        Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
}

; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518

GetBrowserURL_DDE(sClass) {
    WinGet, sServer, ProcessName, % "ahk_class " sClass
    StringTrimRight, sServer, sServer, 4
    iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
    DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
    hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
    hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
    hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
    hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
    hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
    sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
    DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
    DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
    DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
    DllCall("DdeUnaccessData", "UPtr", hData)
    DllCall("DdeFreeDataHandle", "UPtr", hData)
    DllCall("DdeDisconnect", "UPtr", hConv)
    DllCall("DdeUninitialize", "UPtr", idInst)
    csvWindowInfo := StrGet(&sData, "CP0")
    StringSplit, sWindowInfo, csvWindowInfo, % """"
    Return sWindowInfo2
}

GetBrowserURL_ACC(sClass) {
    global nWindow, accAddressBar
    If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
    {
        nWindow := WinExist("ahk_class " sClass)
        accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
    }
    Try sURL := accAddressBar.accValue(0)
    If (sURL == "") {
        sURL := accAddressBar.accDescription(0) ; Origin Chip support
        If (sURL == "") {
            WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in CoolNovo
            If (nWindows > 1) {
                accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))
                sURL := accAddressBar.accValue(0)
            }
        }
    }
    If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Chromium-based browsers omit "http://"
        sURL := "http://" sURL
    Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
    Try If ((accObj.accName(0) != "") and IsURL(accObj.accValue(0)))
        Return accObj
    Try If ((accObj.accName(0) != "") and IsURL("http://" accObj.accValue(0))) ; Chromium omits "http://"
        Return accObj
    Try If (InStr(accObj.accDescription(0), accObj.accName(0)) and IsURL(accObj.accDescription(0))) ; Origin Chip support
        Return accObj
    For nChild, accChild in Acc_Children(accObj)
        If IsObject(accAddressBar := GetAddressBar(accChild))
            Return accAddressBar
}

IsURL(sURL) {
    Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?:(?<Username>[^:]+)(?::(?<Password>[^@]+))?@)?(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

; The code below is part of the Acc.ahk Standard Library by Sean (updated by jethrow)
; Found at http://autohotkey.com/board/topic/77303-/?p=491516

Acc_Init()
{
    static h
    If Not h
        h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0)
{
    Acc_Init()
    If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
    Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc) {
    Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc) {
    If ComObjType(Acc,"Name") != "IAccessible"
        ErrorLevel := "Invalid IAccessible Object"
    Else {
        Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
        If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
            Loop %cChildren%
                i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
            Return Children.MaxIndex()?Children:
        } Else
            ErrorLevel := "AccessibleChildren DllCall Failed"
    }
}

#If InStr( sURL := GetActiveBrowserURL(), "feedly.com" )
    NumpadDot::send {PgDn}
    ^NumpadDot::send .
    NumpadEnter::send A
    ^NumpadEnter::send {Enter}
    Numpad0::send ^w
    ^Numpad0::send 0
#If