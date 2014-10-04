if not A_IsAdmin
{
  Run *RunAs "%A_ScriptFullPath%"  ; 需要 v1.0.92.01+
  ExitApp
}

MsgBox, 4148, 提示, 本工具将关闭 Flash 的 P2P 功能，以便释放上传通道，最终加速视频网站播放速度！`r`n`r`n适用于优酷、爱奇艺、搜狐、乐视、土豆等几乎所有视频网站。
IfMsgBox, Yes
{
  ;对 3 个位置的特定配置文件写入特定配置“RTMFPP2PDisable=1”，也就是关闭 Flash 的 RTMFP 协议，即 Flash 的 P2P 功能
  FileRead, OutputVar, %A_WinDir%\system32\Macromed\Flash\mms.cfg
  Loop, Parse, OutputVar, `n, `r
  {
    if (A_LoopField<>"")
      lastline:=A_LoopField
  }
  ;避免重复写入同条配置
  if (InStr(lastline,"RTMFPP2PDisable=1")=0)
    FileAppend, RTMFPP2PDisable=1`r`n, %A_WinDir%\system32\Macromed\Flash\mms.cfg
  OutputVar:="",lastline:=""

  FileRead, OutputVar, %A_WinDir%\syswow64\Macromed\Flash\mms.cfg
  Loop, Parse, OutputVar, `n, `r
  {
    if (A_LoopField<>"")
      lastline:=A_LoopField
  }
  if (InStr(lastline,"RTMFPP2PDisable=1")=0)
    FileAppend, RTMFPP2PDisable=1`r`n, %A_WinDir%\syswow64\Macromed\Flash\mms.cfg
  OutputVar:="",lastline:=""

  FileRead, OutputVar, %A_WinDir%\system32\mms.cfg
  Loop, Parse, OutputVar, `n, `r
  {
    if (A_LoopField<>"")
      lastline:=A_LoopField
  }
  if (InStr(lastline,"RTMFPP2PDisable=1")=0)
    FileAppend, RTMFPP2PDisable=1`r`n, %A_WinDir%\system32\mms.cfg
  OutputVar:="",lastline:=""

  MsgBox, 4160, 恭喜, 视频网站提速成功！`r`n`r`n如果浏览器用的是“搜狗”，需要勾选“设置”——“页面设置”——“使用系统公用的 Flash Player (需重启浏览器)”, 10
}
ExitApp