/*
	Author: [SA] Duda

	Description:
	Randomly moves everything inside a marker to a random position
	specified by other markers. Other markers must follow prefix:
	MarkerNamePrefix[0...n]

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: STRING - Random marker name prefix
	_this select 2: NUMBER - Number of random markers
	_this select 3: BOOLEAN - Building placement (optional, default false)
		
	Returns: 
	Nothing
*/

private ["_markerName", "_randomMarkerNamePrefix", "_markerCount","_randomNumber","_randomMarkerName", "_buildingPlacement"];
_markerName = [_this, 0] call BIS_fnc_param;
_randomMarkerNamePrefix = [_this, 1] call BIS_fnc_param;
_markerCount = [_this, 2] call BIS_fnc_param;
_buildingPlacement = [_this, 3, false] call BIS_fnc_param;
_randomNumber = floor(random _markerCount);
_randomMarkerName = format ["%1%2", _randomMarkerNamePrefix, _randomNumber];
[_markerName, getMarkerPos _randomMarkerName, _buildingPlacement] call SA_fnc_moveAllInsideMarker;
