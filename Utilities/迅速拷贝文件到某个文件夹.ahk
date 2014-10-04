#NoEnv
#Persistent
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
SendMode Input
tar_folder=c:\照片     ;定义你的目标文件夹
tar_ext=i).(jpg|bmp|jpeg)$    ;定义你的文件类型

StringReplace,f_tar_ext,tar_ext,i).(
StringReplace,f_tar_ext,f_tar_ext,)$

Gui, +AlwaysOnTop -Border
Gui, Font, s13
Gui, Color, Olive
Gui, Add, Pic, x10 y15 icon2, %A_AhkPath%
Gui, Add, Text, x+0 y-10 cwhite w295 h45 gGuiMove +Center, `n快速文件整理框
Gui, Font, s10
Gui, Add, Text, xp y+0 h30 Wp cWhite gGuiMove  vDrop +Center, 拖放文件或文件夹到这里即拷贝到指定文件夹
Gui, Add, Text, xp y+0 h30 Wp cWhite gGuiMove   +Center, 目标类型：%f_tar_ext%
Gui, Add, Text, xp y+0 h30 Wp cWhite gGuiMove   +Center, 目标文件夹：%Tar_folder%
Gui, Show, y0 w355 h115 NoActivate, AHK No Comments
Return
GuiMove:
   PostMessage, 0xA1, 2,,, A
   Return
GuiDropfiles:
   Gui, Color, 88B000
   Gui, -E0x10
   GuiControl, ,Dropped, Please wait . . .
   Loop, Parse, A_GuiEvent, `n, `r
    {
        If (! InStr(FileExist(A_Loopfield), "D"))
        {
            If (! RegExMatch(A_LoopField, tar_ext))
				Continue
            FileCopy,%A_LoopField%,%tar_folder%
        }
        Else
        {
            Loop % A_LoopField "\*.jpg",0,1
            {

				If (! RegExMatch(A_LoopFileFullPath,tar_ext))
					Continue
				FileCopy,%A_LoopFileFullPath%,%tar_folder%
            }
        }
    }
    Gui, Color, Olive
    GuiControl, ,Drop, 拖放文件或文件夹到这里即拷贝到指定文件夹
    Gui, +E0x10
    Return


GuiEscape:
GuiClose:
   ExitApp

