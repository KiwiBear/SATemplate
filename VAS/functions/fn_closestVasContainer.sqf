/*
	File: fn_openVAS.sqf
	Author: Duda
	
	Description:
	Get the VAS container closest to the specified unit (which as been registered via VAS_fnc_registerVasContainer)
	
*/

private ["_unit","_vasContainers","_closestDistance","_closestContainer","_distance"];
_unit = param [0,player];
_vasContainers = [] call VAS_fnc_getVasContainers;
_closestDistance = 0;
_closestContainer = objNull;
{
	if(isNull _closestContainer) then {
		_closestContainer = _x;
		_closestDistance = _x distance _unit;
	} else {
		_distance = _x distance _unit;
		if(_distance < _closestDistance) then {
			_closestContainer = _x;
			_closestDistance = _x distance _unit;
		};
	};
} forEach _vasContainers;
_closestContainer;