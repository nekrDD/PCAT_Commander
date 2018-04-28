Local $oPcatProps = ObjCreate("Scripting.Dictionary")

$oPcatProps("iPID") = '' ; Product Catalog Process ID
$oPcatProps("hConnectURL") = '' ; client.connect.URL request handler
$oPcatProps("bLoginAttempted") = False
$oPcatProps("bSelectVerAttempted") = False
