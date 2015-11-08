/*
	Author: [SA] Duda

	Description:
	Get a random position within a marker

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: ARRAY (OPTIONAL) - Placement area [[X,Y],radius]. This is used for group placement so all entities get placed near each other.
	_this select 2: ARRAY (OPTIONAL) - List of marker names positions cannot be inside (default: [])
		
	Returns: 
	ARRAY - A position [X,Y] within the marker
*/

private ["_markerName", "_sizeX", "_sizeY", "_center", "_angle", "_xOffset", "_yOffset","_position","_avoidMarkerNames"];

_markerName = [_this, 0] call BIS_fnc_param;
_placementArea = [_this, 1, []] call BIS_fnc_param;
_avoidMarkerNames = [_this, 2, []] call BIS_fnc_param;
_sizeX = markerSize _markerName select 0;
_sizeY = markerSize _markerName select 1;
_center = markerPos _markerName;
_angle = markerDir _markerName;

if(count _placementArea >= 2) then {
	// Finds a position within a placement area w/in the marker
	scopeName "SA_fnc_findPositionInsideMarker_Area";
	for "_i" from 1 to 20 do
	{
		_position = _placementArea call SA_fnc_getPositionInsideCircle;
		if( [_position, _markerName] call SA_fnc_isPositionInsideMarker) then {
			breakTo "SA_fnc_findPositionInsideMarker_Area";
		};
	};
} else {
	private ["_xOffset", "_yOffset","_nonRotatedPosition","_nonRotatedPosition","_outsideAvoidMarkers"];
	scopeName "SA_fnc_findPositionInsideMarker_Area2";
	for "_i" from 1 to 20 do
	{
		_xOffset = (random (_sizeX * 2)) - _sizeX;
		_yOffset = (random (_sizeY * 2)) - _sizeY;
		_nonRotatedPosition = [(_center select 0) + _xOffset,(_center select 1) + _yOffset];
		_position = [_nonRotatedPosition, _center, -1 * _angle] call SA_fnc_rotatePosition;
		_outsideAvoidMarkers = not ([_position, _avoidMarkerNames] call SA_fnc_isPositionInsideMarker);
		if(_outsideAvoidMarkers) then {
			breakTo "SA_fnc_findPositionInsideMarker_Area2";
		};
	};
	

};

_position;
