cando_toXMLStyle:
	Clipboard = %CandySel%
	SetKeyDelay ,100
	SendInput,^c
	ClipWait
	Clipboard = %Clipboard%
	StringReplace, Clipboard, Clipboard, =`", `">, All
	StringReplace, Clipboard, Clipboard, android:, <item name`=`", All
	StringReplace, Clipboard, Clipboard, `r`n, </item>`r`n, All
	
	;Clipboard :=<style name = ???>%Clipboard%</style>
	SendInput , ^v
return
	
	
	

	
	