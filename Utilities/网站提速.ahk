if not A_IsAdmin
{
  Run *RunAs "%A_ScriptFullPath%"  ; ��Ҫ v1.0.92.01+
  ExitApp
}

MsgBox, 4148, ��ʾ, �����߽��ر� Flash �� P2P ���ܣ��Ա��ͷ��ϴ�ͨ�������ռ�����Ƶ��վ�����ٶȣ�`r`n`r`n�������ſᡢ�����ա��Ѻ������ӡ������ȼ���������Ƶ��վ��
IfMsgBox, Yes
{
  ;�� 3 ��λ�õ��ض������ļ�д���ض����á�RTMFPP2PDisable=1����Ҳ���ǹر� Flash �� RTMFP Э�飬�� Flash �� P2P ����
  FileRead, OutputVar, %A_WinDir%\system32\Macromed\Flash\mms.cfg
  Loop, Parse, OutputVar, `n, `r
  {
    if (A_LoopField<>"")
      lastline:=A_LoopField
  }
  ;�����ظ�д��ͬ������
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

  MsgBox, 4160, ��ϲ, ��Ƶ��վ���ٳɹ���`r`n`r`n���������õ��ǡ��ѹ�������Ҫ��ѡ�����á�������ҳ�����á�������ʹ��ϵͳ���õ� Flash Player (�����������)��, 10
}
ExitApp