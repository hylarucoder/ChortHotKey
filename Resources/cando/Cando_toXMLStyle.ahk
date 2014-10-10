cando_toXMLStyle:
	Clipboard = %CandySel%
	ClipWait
	StringReplace, Clipboard, Clipboard, =`", `">, All
	StringReplace, Clipboard, Clipboard, android:, <item name`=`", All
	StringReplace, Clipboard, Clipboard, `r`n, </item>`r`n, All
	
	;Clipboard :=<style name = ???>%Clipboard%</style>
	SendInput , ^v
return
	

	
	