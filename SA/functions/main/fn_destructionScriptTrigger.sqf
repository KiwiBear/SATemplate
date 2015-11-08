/*
	Author: [SA] Duda
	
	Description:
	Adds a destruction trigger
	
	Parameters:
		0: ARRAY - Objects to check for destruction
		1: FUNCTION - Action to take on destruction 
		2: BOOLEAN - All objects must be destroyed (default true)

*/
private ["_objects","_function","_allEntities","_destoryAll"];
_objects = [_this,0,[]] call BIS_fnc_param;
_function = [_this,1,{}] call BIS_fnc_param;
_destoryAll = [_this,2,true] call BIS_fnc_param;
[
	{
		private ["_objectsToDestory","_allDestoryed","_oneDestoryed","_destoryAll"];
		_objectsToDestory = [_this,0,[]] call BIS_fnc_param;
		_destoryAll = [_this,1,true] call BIS_fnc_param;
		_allDestoryed = true;
		_oneDestoryed = false;
		{
			if(alive _x) then {
				_allDestoryed = false;
			} else {
				_oneDestoryed = true;
			}
		} forEach _objectsToDestory;
		if(_destoryAll) then {
			_allDestoryed;
		} else {
			_oneDestoryed;
		};
	},
	[_objects, _destoryAll],
	_function,
	5
] call SA_fnc_scriptTrigger;