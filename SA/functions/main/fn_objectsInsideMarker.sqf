/*
	Author: [SA] Duda

	Description:
	Gets all objects contained inside a marker (rectangle only)

	Parameter(s):
	_this select 0: STRING - Name of marker
		
	Returns: 
	ARRAY - An array of all objects contained inside a marker
*/

private ["_markerName", "_sizeX", "_sizeY", "_center", "_searchRadius"];

_markerName = [_this, 0] call BIS_fnc_param;
_sizeX = markerSize _markerName select 0;
_sizeY = markerSize _markerName select 1;
_center = markerPos _markerName;
_searchRadius = sqrt( _sizeX * _sizeX + _sizeY * _sizeY );

private ["_nearObjects","_objectsWithinMarker"];

_objectsWithinMarker = [];
_nearObjects = _center nearObjects _searchRadius;
{
	if( [getPos _x, _markerName] call SA_fnc_isPositionInsideMarker ) then {
		_objectsWithinMarker = _objectsWithinMarker + [_x];
	};
}
forEach _nearObjects;

_objectsWithinMarker;
