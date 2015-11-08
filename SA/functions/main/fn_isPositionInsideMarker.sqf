/*
	Author: [SA] Duda

	Description:
	Identifies if a position is within a marker. Currently only
	works for rectangle markers. (rectangle only)

	Parameter(s):
	_this select 0: ARRAY - Position to test [X,Y]
	_this select 1: STRING or ARRAY of STRING - Name of marker(s)
		
	Returns: 
	BOOL - true if the position is within at least one of the marker(s), otherwise false
*/

private ["_position", "_markerNames", "_center", "_angle","_sizeX","_sizeY","_insideMarker"];

_position = [_this, 0] call BIS_fnc_param;
_markerNames = [_this, 1] call BIS_fnc_param;
if(typename _markerNames != typename []) then {
	_markerNames = [_markerNames];
};

_insideMarker = false;

scopeName "posInsideMarkerLoop";
{
	_angle = markerDir _x;
	_center = markerPos _x;
	_sizeX = markerSize _x select 0;
	_sizeY = markerSize _x select 1;

	if([_position, _center, _sizeX, _sizeY, _angle] call SA_fnc_positionInsideRectangle) then {
		_insideMarker = true;
		breakTo "posInsideMarkerLoop";
	};
}
forEach _markerNames;

_insideMarker;