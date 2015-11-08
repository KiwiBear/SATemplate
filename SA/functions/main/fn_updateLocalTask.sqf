/*
	Author: [SA] Duda
	
	Description:
	Update a task
	
	Parameters:
		0: TASK - Simple task to update
		1: STRING - Task state
		2: BOOL (OPTIONAL) - Show hint (default: true)
	
	Returns:
	BOOL
*/

private ["_hint","_task","_state"];
_task = [_this,0] call BIS_fnc_param;
_state = [_this,1] call BIS_fnc_param;
_hint = [_this,2,true] call BIS_fnc_param;
_task setTaskState _state;
if(_hint) then {
	[format ["Task%1",_state],["",(taskDescription _task) select 0]] call BIS_fnc_showNotification;
};
