F9::
	Send, ^c
	ClipWait,2
	If ErrorLevel                          ;如果粘贴板里面没有内容，则判断是否有窗口定义
		Return

	Youdao_keyword=%Clipboard%
	Youdao_译文:=YouDaoApi(Youdao_keyword)
	Youdao_音标:= json(Youdao_译文, "basic.phonetic")
	Youdao_基本释义:= json(Youdao_译文, "basic.explains")
	Youdao_网络释义:= json(Youdao_译文, "web.value")
	If Youdao_基本释义<>
	{
		Gui Gui_youdao_danci:add,Edit,x10 y10  w300 h100,%Youdao_音标%
		Gui Gui_youdao_danci:add,Edit,x10 y120 w300 h100,%Youdao_基本释义%
		Gui Gui_youdao_danci:add,Edit,x10 y230 w300 h100,%Youdao_网络释义%
	}
	Else
	{
		Youdao_音标:=RegExReplace(Youdao_译文,"m)({""translation""\:\["")|(""\],""query""\:.*)")
		Gui Gui_youdao_danci:add,Edit,x10 y10  w300 h300,%Youdao_音标%
	}

	Gui Gui_youdao_danci:show,,有道网络翻译
	Return
Gui_youdao_danciGuiClose:
Gui_youdao_danciGuiEscape:
	Gui Gui_youdao_danci:destroy
	Return




YouDaoApi(KeyWord)
{
    KeyWord:=Sub_UrlEncode(KeyWord,"utf-8")
	url:="http://fanyi.youdao.com/fanyiapi.do?keyfrom=xxxxxxxx&key=1360116736&type=data&doctype=json&version=1.1&q=" . KeyWord
    WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    WebRequest.Open("GET", url)
    WebRequest.Send()
    result := WebRequest.ResponseText
    Return result
}


json(ByRef js, s, v = "")
{
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


Sub_UrlEncode(str, enc="UTF-8")
{
   hex := "00", func := "msvcrt\" . (A_IsUnicode ? "swprintf" : "sprintf")
   VarSetCapacity(buff, size:=StrPut(str, enc)), StrPut(str, &buff, enc)
   While (code := NumGet(buff, A_Index - 1, "UChar")) && DllCall(func, "Str", hex, "Str", "%%%02X", "UChar", code, "Cdecl")
   encoded .= hex
   Return encoded
}