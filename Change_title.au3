
Func Test()
	Local $hPCATwin = WinWaitActive("Product Catalog")
	$title = WinGetTitle("[CLASS:SunAwtFrame]");
	 WinSetTitle($hPCATwin, "", "PCAT NSK (UTC+6)")
	;MsgBox(4096, "LINK",$title)
	ConsoleWrite ( $title & @CRLF)
	$handle = WinGetHandle("[CLASS:SunAwtFrame]", "")
	WinClose($handle)

EndFunc

$handle = WinGetHandle("[REGEXPTITLE:(Login.*|Select Reseller Version.*|Product Catalog.*|PCAT.*); REGEXPCLASS:SunAwt(Dialog|Frame)]", "")
If $handle Then
	ConsoleWrite("handle" & @CRLF)
	WinClose($handle)
EndIf
