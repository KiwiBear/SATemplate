/*
	Author: [SA] Duda

	Description:
	Identifies if an array of objects contains only the specified types

	Parameter(s):
	_this select 0: ARRAY - Array of objects
	_this select 1: ARRAY - Object types (ex: ["Man", "LandVehicle"])

	Returns: 
	BOOLEAN - True if the array of objects contains only objects of the specified types
*/

scopeName "SA_fnc_containsOnlySpecifiedTypes";

private ["_objects","_types","_containsOnlySpecifiedTypes","_object","_type"];

_objects = [_this, 0, []] call BIS_fnc_param;
_types = [_this, 1,["All"]] call BIS_fnc_param;
_typesFound = [];

if( count _objects > 0 ) then {
	_containsOnlySpecifiedTypes = true;
} else {
	//  If no objects specified, always return false
	_containsOnlySpecifiedTypes = false;
};

{
	_object = _x;
	_objectMatchesType = false;
	{
		_type = _x;
		if(_object isKindOf _type) then {
			_objectMatchesType = true;
			_typesFound = _typesFound - [_type];
			_typesFound = _typesFound + [_type];
		}
	}
	forEach _types;
	if( !_objectMatchesType ) then {
		_containsOnlySpecifiedTypes = false;
		breakTo "SA_fnc_containsOnlySpecifiedTypes";
	};
}
forEach _objects;

if(_containsOnlySpecifiedTypes && count _typesFound == count _types ) then {
	true;
} else {
	false;
}