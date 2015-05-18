/*============================================================================================================
下面是针对candy的MultiFiles的挂接脚本
candyselected就是被candy传送过来的一个文件列表
形如：
C:\Autohotkey_b\Scite_b\api\ahk.api
C:\Autohotkey_b\Scite_b\api\ahk.user.calltips.api

请大家提供一些实用的针对多文件操作的片段
以
multifiles_什么什么功能
命名。谢谢。
*/


Cando_合并文本文件:
	loop, parse, CandySelected, `n,`r
	{
		SplitPath, A_LoopField, , , ext, ,
		IfEqual,ext,txt
		{
			Fileread, text, %A_loopfield%
			all_text=%all_text%%text%`r`n
		}
	}
	FileAppend, %all_text%, c:\11.txt
	Return


/*============================================================================================================
*/

Cando_拷贝多文件:
	loop, parse, CandySelected, `n,`r
	{
	   FileCopy, %A_LoopField%, c:\test
	   if ErrorLevel
			Break
	   Progress, %a_index%, %A_LoopField%, Installing...,adasdf
	   Sleep, 50
	}
	Progress, Off
	Return