/*
	Author: [SA] Duda

	Description:
	Gets all markers contained inside a marker (rectangle only)

	Parameter(s):
	_this select 0: STRING - Name of marker
		
	Returns: 
	ARRAY - An array of all markers contained inside a marker (excluding the marker you specified)
*/

private ["_markerName", "_sizeX", "_sizeY", "_center"];

_markerName = [_this, 0] call BIS_fnc_param;
_sizeX = markerSize _markerName select 0;
_sizeY = markerSize _markerName select 1;
_center = markerPos _markerName;

private ["_allMarkers","_markersWithinMarker"];

_markersWithinMarker = [];
_allMarkers = allMapMarkers;
{
	if( [markerPos _x, _markerName] call SA_fnc_isPositionInsideMarker ) then { 
		//&& _x != _markerName
		_markersWithinMarker = _markersWithinMarker + [_x];
	};
}
forEach _allMarkers;

_markersWithinMarker;
	