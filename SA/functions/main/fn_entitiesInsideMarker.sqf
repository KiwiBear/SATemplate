/*
	Author: [SA] Duda

	Description:
	Gets all entities contained inside a marker (rectangle only)

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: ARRAY (OPTIONAL) - Array of entity types ex: ["Man","LandVehicle"]
		If not defined, by default, will find all entity types: ["All"].
		
	Returns: 
	ARRAY - An array of all entities contained inside a marker
*/

private ["_markerName", "_typeList", "_sizeX", "_sizeY", "_center", "_searchRadius"];

_markerName = [_this, 0] call BIS_fnc_param;
_typeList = [_this, 1, ["All"]] call BIS_fnc_param;
_sizeX = markerSize _markerName select 0;
_sizeY = markerSize _markerName select 1;
_center = markerPos _markerName;
_searchRadius = sqrt( _sizeX * _sizeX + _sizeY * _sizeY );

private ["_nearEntities","_entitiesWithinMarker"];

_entitiesWithinMarker = [];
_nearEntities = _center nearEntities [_typeList, _searchRadius];
{
	if( [getPos _x, _markerName] call SA_fnc_isPositionInsideMarker ) then {
		_entitiesWithinMarker = _entitiesWithinMarker + [_x];
	};
}
forEach _nearEntities;

_entitiesWithinMarker;
	