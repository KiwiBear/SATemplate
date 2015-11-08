/*
	Author: [SA] Duda

	Description:
	Adds a droppable EMP to an air vehicle. When the EMP lands, all street lights within x distance will be turned off.

	Parameter(s):
	_this select 0: OBJECT - Air vehicle
	_this select 1: STRING (OPTIONAL) - Name of action (default: Drop EMP)
	_this select 2: NUMBER (OPTIONAL) - Distance of EMP (default: 500 meters)
		
	Returns: 
	Nothing
*/

private ["_object","_action","_distance"];

_object = [_this,0] call BIS_fnc_param;
_action = [_this,1,"Drop EMP"] call BIS_fnc_param;
_distance = [_this,2,500] call BIS_fnc_param;

_object addAction [_action,{ 
	(_this select 3) spawn SA_fnc_dropEMP; 
},[_object, _distance],0,true,true,"","driver  _target == _this && (getPos _target) select 2 > 20"];

