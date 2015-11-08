/*
	File: fn_unitNearVasContainer.sqf
	Author: Duda
	
	Description:
	Return true if the specified unit is within maxDistance of a VAS container (which as been registered via VAS_fnc_registerVasContainer)
	
*/

private ["_unit","_maxDistance","_closestVasContainer"];
_unit = param [0,player];
_maxDistance = param [1,50];
_closestVasContainer = [_unit] call VAS_fnc_closestVasContainer;
if(_closestVasContainer distance _unit <= _maxDistance) then {
	true;
} else {
	false;
};