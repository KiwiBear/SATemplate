/*
	Author: [SA] Duda
	
	Description:
	Determines if the caller is the AI server
	
	Returns:
	BOOL
*/
private ["_isAiServer"];
_isAiServer = false;
if("PARAM_HeadlessClientEnabled" call BIS_fnc_getParamValue == 1) then {
	if !(isServer or hasInterface) then {
		_isAiServer = true;
	};
} else {
	if(isServer) then {
		_isAiServer = true;
	};
};
_isAiServer;