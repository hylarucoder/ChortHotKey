cando_toXMLStyle:
	Clipboard = %CandySel%
	ClipWait
	StringReplace, Clipboard, Clipboard, =`", `">, All
	StringReplace, Clipboard, Clipboard, android:, <item name`=`", All
	StringReplace, Clipboard, Clipboard, `r`n, </item>`r`n, All
	
	;Clipboard :=<style name = ???>%Clipboard%</style>
	SendInput , ^v
return


cando_YouDaoTrans:
	KeyWord2 = %CandySel%

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