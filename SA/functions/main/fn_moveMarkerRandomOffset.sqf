/*
	Author: [SA] Duda

	Description:
	Move marker a random direction and random distance

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: NUMBER - Max Distance
		
	Returns: 
	Nothing
*/

private ["_markerName", "_distance", "_center"];
_markerName = [_this, 0] call BIS_fnc_param;
_distance = [_this, 1] call BIS_fnc_param;
_center = markerPos _markerName;
_markerName setMarkerPos ([_center, _distance] call SA_fnc_getPositionInsideCircle);
