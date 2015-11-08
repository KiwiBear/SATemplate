/*
	Author: [SA] Duda
	
	Description:
	Update a task
	
	Parameters:
		0: OBJECT - Object to add virtual ammo to
	
	Returns:
	BOOL
*/

private ["_obj"];
_obj = [_this,0] call BIS_fnc_param;
[_obj] call VAS_fnc_createVasContainer;
_obj addaction ["<t color='#ff1111'>Open Virtual Arsenal</t>", { ["Open",true] call BIS_fnc_arsenal; }];