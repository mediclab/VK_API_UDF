#include "../API/VK_API.au3"
#include <Array.au3>

Global $sSt, $sFriends, $iID = 2672631

$aA = _VK_SignIn($iID, 8192+8+2+4+1024+65536+262144)
;$Array =    _VK_getProfiles($aA, "1,2,62690309,phoenix84,so_fever,")
$Resp = _VK_audioGet($aA,1)

;ConsoleWrite($Resp & @error)
_ArrayDisplay($Resp)

