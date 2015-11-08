/*
	Author: [SA] Duda

	Description:
	Groups an array of objects into groups based on their group. If an object doesn't
	have a group, they are considered to be in a group of 1.

	Parameter(s):
	_this select 0: ARRAY - Array of objects to be grouped
		
	Returns: 
	ARRAY - An array of grouped objects [[Object,Object,...],[Object],[Object,Object],...]
*/

private ["_objectsToGroup", "_groupedObjects"];

_objectsToGroup = [_this, 0, []] call BIS_fnc_param;
_groupedObjects = [];

{
	private ["_group","_foundIndex","_foundGroupArray"];
	
	_group = group _x;
	_foundIndex = -1;
	_foundGroupArray = [];
	
	for "_i" from 0 to (count _groupedObjects)-1 do
	{
		scopeName "groupedObjectLoop";
		private ["_groupedObjectsGroup"];
		_groupedObjectsGroup = group ((_groupedObjects select _i) select 0);
		if( _group == _groupedObjectsGroup) then {
			_foundIndex = _i;
			_foundGroupArray = _groupedObjects select _i;
			breakOut "groupedObjectLoop";
		};
	};
	
	if( _foundIndex == -1 ) then {
		_groupedObjects = _groupedObjects + [[_x]];
	} else {
		_groupedObjects set [_foundIndex,_foundGroupArray+[_x]];
	};
}
forEach _objectsToGroup;

_groupedObjects;
