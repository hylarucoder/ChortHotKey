Windo_网络对时:
   downloaderror=
   gosub 从时间服务器提取文件
   If downloaderror
      {
      MsgBox,,Time Sync,Time sync is not available,2
      ExitApp
      }
   FileReadLine x,%a_temp%\synctime ,2
   VarSetCapacity(T,16,0)
   DllCall("RtlFillMemory",UInt,&T,  UInt,1,UChar,20 SubStr(x,7,2))
   DllCall("RtlFillMemory",UInt,&T+1,UInt,1,UChar,(20 SubStr(x,7,2))>>8)
   DllCall("RtlFillMemory",UInt,&T+2,UInt,1,UChar,SubStr(x,10,2))
   DllCall("RtlFillMemory",UInt,&T+6,UInt,1,UChar,SubStr(x,13,2))
   DllCall("RtlFillMemory",UInt,&T+8,UInt,1,UChar,SubStr(x,16,2))
   DllCall("RtlFillMemory",UInt,&T+10,UInt,1,UChar,SubStr(x,19,2))
   DllCall("RtlFillMemory",UInt,&T+12,UInt,1,UChar,SubStr(x,22,2))
   DllCall("SetSystemTime",Str,T)
   PostMessage 0x1E,,,,ahk_class Shell_TrayWnd
   MsgBox,,Time Sync,网络对时完成！,1
   ExitApp

   从时间服务器提取文件:
   UrldownLoadToFile http://128.138.140.44:13 ,%a_temp%\synctime
   if not errorlevel
   return
   UrldownLoadToFile http://68.216.79.113:13 ,%a_temp%\synctime
   if not errorlevel
   return
   UrldownLoadToFile http://129.6.15.28:13 ,%a_temp%\synctime
   if not errorlevel
   return
   downloaderror:=true
   return