/*
	Author: [SA] Duda

	Description:
	Sets time of day

	Parameter(s):
	_this select 0: NUMBER - Hour of day (0=random)
		
	Returns: 
	Nothing
*/
private ["_paramDaytimeHour"];
_paramDaytimeHour = [_this,0] call BIS_fnc_param;
if (_paramDaytimeHour == 0) then {
	setDate [2015 + floor(random 10), floor(random 12)+1, 1, (round(random 24)), (round(random 55))];//(round(random 1440))
} else {
	setDate [2015 + floor(random 10), floor(random 12)+1, 1, _paramDaytimeHour, 0];
};