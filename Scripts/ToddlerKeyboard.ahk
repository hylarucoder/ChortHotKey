;
; ToddlerKeyboard.ahk
; Version: 1.0
; Last Updated: 6/29/2007
; Author: bobbo
; Website: http://www.autohotkey.com/forum/topic20601.html
;
; Prevents key presses to most keys other than A-F and 0-9. Useful to prevent children's games from losing window focus. Also only sends key press once if held down.
; Slightly modified for Kommand.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Special Keys ==================================================== ;
Menu, Tray, Icon, %A_ScriptDir%\..\Images\Toddler.ico, 0, 1
#UseHook on
Browser_Home::
Browser_Search::
Launch_Mail::
return

Launch_App2::
     WinClose A
     ExitApp
return
#UseHook off

RButton::LButton
MButton::LButton

; Disabled Keys =================================================== ;
Tab::
Escape::
Backspace::

Delete::
Insert::
Home::
End::
PgUp::
PgDn::

ScrollLock::
CapsLock::
NumLock::

F1::
F2::
F3::
F4::
F5::
F6::
F7::
F8::
F9::
F10::
F11::
F12::
F13::
F14::
F15::
F16::
F17::
F18::
F19::
F20::
F21::
F22::
F23::
F24::

AppsKey::

LWin::
RWin::

LControl::
RControl::
LShift::
RShift::
LAlt::
RAlt::

PrintScreen::
CtrlBreak::
Pause::
Break::

Help::
Sleep::

Browser_Back::
Browser_Forward::
Browser_Refresh::
Browser_Stop::
Browser_Favorites::
Volume_Mute::
Volume_Down::
Volume_Up::
Media_Next::
Media_Prev::
Media_Stop::
Media_Play_Pause::
Launch_Media::
Launch_App1::

; Do nothing and effectively disable the key.
Send {Space}
return

; Allowed Keys ==================================================== ;
; Let these through unaffected, to allow for certain game control.
;Up::
;Down::
;Left::
;Right::
;Space::
;Enter::

Numpad0::
NumpadIns::
Numpad1::
NumpadEnd::
Numpad2::
NumpadDown::
Numpad3::
NumpadPgDn::
Numpad4::
NumpadLeft::
Numpad5::
NumpadClear::
Numpad6::
NumpadRight::
Numpad7::
NumpadHome::
Numpad8::
NumpadUp:
Numpad9::
NumpadPgUp::
NumpadDot::
NumpadDel::
NumpadDiv::
NumpadMult::
NumpadAdd::
NumpadSub::
NumpadEnter::

; Only send the key press through once if held down continually (Use curly brackets to send these keys).
if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > 500)
{
   Hotkey, %A_ThisHotkey%, Off
   Send, {%A_ThisHotkey%}
   Hotkey, %A_ThisHotkey%, On
}
return

a::
b::
c::
d::
e::
f::
g::
h::
i::
j::
k::
l::
m::
n::
o::
p::
q::
r::
s::
t::
u::
v::
w::
x::
y::
z::

0::
1::
2::
3::
4::
5::
6::
7::
8::
9::

; Only send the key press through once if held down continually (Send the literal keys).
if (A_PriorHotkey <> A_ThisHotkey or A_TimeSincePriorHotkey > 500)
{
   Hotkey, %A_ThisHotkey%, Off
   Send, %A_ThisHotkey%
   Hotkey, %A_ThisHotkey%, On
}
return
