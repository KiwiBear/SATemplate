/*
	Author: [SA] Duda
	
	Description:
	Create a task
	
	Parameters:
		0: OBJECT - Unit to add this new task
		1: STRING- Task name
		2: STRING - Task title
		3: STRING - Task description
		4: OBJECT - Task destination description
		5: OBJECT - Task destination
		6: BOOL (OPTIONAL) - Assign task (default: true)
		7: BOOL (OPTIONAL) - Show hint (default: true)
	
	Returns:
	Task
*/

private ["_target","_taskName","_taskTitle","_taskDescription","_taskDestinationDescription","_taskDestination","_taskDestination","_assign","_hint"];
_target = [_this,0] call BIS_fnc_param;
_taskName = [_this,1] call BIS_fnc_param;
_taskTitle = [_this,2] call BIS_fnc_param;
_taskDescription = [_this,3] call BIS_fnc_param;
_taskDestinationDescription = [_this,4] call BIS_fnc_param;
_taskDestination = [_this,5] call BIS_fnc_param;
_assign = [_this,6,true] call BIS_fnc_param;
_hint = [_this,7,true] call BIS_fnc_param;

private ["_task"];
_task = _target createSimpleTask [_taskName];
_task setSimpleTaskDescription [_taskDescription,_taskTitle,_taskDestinationDescription];
_task setSimpleTaskDestination  _taskDestination;
if(_assign) then {
	_task setTaskState "Assigned";
	_target setCurrentTask _task;
	if(_hint) then {
		["TaskAssigned",["",_taskDescription]] call BIS_fnc_showNotification;
	};
} else {
	_task setTaskState "Created";
	if(_hint) then {
		["TaskCreated",["",_taskDescription]] call BIS_fnc_showNotification;
	};
};

_task;
