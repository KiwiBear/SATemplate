/*
	Author: [SA] Duda
	
	Description:
	Remove all crew from vehicle except driver. Does not remove player units.
	
	aG, eG
	
	Parameters:
		0: OBJECT - Vehicle
	
	Returns:
	Nothing
*/

private ["_vehicle"];
_vehicle = [_this,0] call BIS_fnc_param;
{
	if(driver _vehicle != _x && !isPlayer _x) then {
		[_x] join grpNull;  
		deleteVehicle _x;
	};
} forEach (crew _vehicle);
