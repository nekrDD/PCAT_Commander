#include "PCAT_data.au3"
Func Test($oIn)
	Local $oOut = ObjCreate("Scripting.Dictionary")
	$oIn("name") = "Test"
	$oOut("foo") = "boo"
	return $oIn
EndFunc

Local $oTest = ObjCreate("Scripting.Dictionary")
$oTest("name") = "notTest"
Local $oNewOut = Test($oTest)
ConsoleWrite($oNewOut("name"))