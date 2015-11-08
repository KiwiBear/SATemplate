/*
	Author: [SA] Duda
	
	Description:
	Creates a script trigger

	Parameters:
		0: FUNCTION - Trigger condition function
		1: ANY - Condition function params
		2: FUNCTION - Trigger action function
		3: NUMBER (OPTIONAL) - Seconds to sleep between condition checks (Default 2)
*/
_this spawn {
	private ["_condition","_action","_wait","_conditionParams"];
	_condition = [_this,0,{true}] call BIS_fnc_param;
	_conditionParams = [_this,1,[]] call BIS_fnc_param;
	_action = [_this,2,{}] call BIS_fnc_param;
	_wait = [_this,3,2] call BIS_fnc_param;
	while { !(_conditionParams call _condition) } do {
		sleep _wait;
	};
	call _action;
};
