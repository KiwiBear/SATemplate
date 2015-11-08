/*
	Author: [SA] Duda
	
	Description:
	Make a vehicle ignore enemy
	
	aL, eG
	
	Parameters:
		0: OBJECT - Vehicle (must be local to client)
	
	Returns:
	Nothing
*/

private ["_vehicle"];
_vehicle = [_this,0] call BIS_fnc_param;
_vehicle disableAi "TARGET";
_vehicle disableAi "AUTOTARGET";
_vehicle allowFleeing 0;
_vehicle setBehaviour "CARELESS";
_vehicle setCombatMode "BLUE";
