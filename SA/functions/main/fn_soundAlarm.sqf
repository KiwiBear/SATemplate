/*
	Author: [SA] Duda

	Description:
	Sounds an alarm from a specific object source

	Parameter(s):
	_this select 0: OBJECT - object to emit sound
	_this select 1: NUMBER (OPTIONAL) - Number of alarms (default: 4)
	_this select 2: NUMBER (OPTIONAL) - Distance of alarm (default: 1000 meters)
		
	Returns: 
	Nothing
*/
private ["_object","_alarms","_distance"];
_object = [_this,0] call BIS_fnc_param;
_alarms = [_this,1,4] call BIS_fnc_param;
_distance = [_this,2,1000] call BIS_fnc_param;
for "_i" from 1 to _alarms do
{
	[_object, "SA\sounds\alarm.ogg", _distance] call SA_fnc_play3dSound;
	sleep 12;
};
