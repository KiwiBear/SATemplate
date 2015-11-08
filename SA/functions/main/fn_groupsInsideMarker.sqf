/*
	Author: [SA] Duda

	Description:
	Gets all groups contained inside a marker (rectangle only)

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: ARRAY (OPTIONAL) - Array of entity types used to find groups ex: ["Man","LandVehicle"]
		If not defined, by default, will find all entity types: ["All"].
		
	Returns: 
	ARRAY - An array of all groups contained inside a marker
*/

private ["_markerName", "_typeList", "_sizeX", "_sizeY", "_center", "_searchRadius"];

_markerName = [_this, 0] call BIS_fnc_param;
_typeList = [_this, 1, ["All"]] call BIS_fnc_param;

private ["_entities","_groupsWithinMarker"];

_groupsWithinMarker = [];
_entities = [_markerName] call SA_fnc_entitiesInsideMarker;
{
	if( !((group _x) in _groupsWithinMarker )) then {
		_groupsWithinMarker = _groupsWithinMarker + [group _x];
	};
}
forEach _entities;

_groupsWithinMarker;
