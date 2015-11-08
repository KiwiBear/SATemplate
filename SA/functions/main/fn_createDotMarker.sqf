/*
	Author: [SA] Duda

	Description:
	Creates a dot marker as a specified position

	Parameter(s):
	_this select 0: ARRAY - position [X,Y]
	_this select 1: STRING (OPTIONAL) - Name of marker color (default: "Default")
	_this select 1: STRING (OPTIONAL) - Marker text (default: "")
	
	Returns: 
	The marker
*/

private ["_markerPosition","_markerColor","_markerName","_markerText"];
if( isNil "createDotMarker_id" ) then {
	createDotMarker_id = 0;
} else {		
	createDotMarker_id = createDotMarker_id + 1;
};
_markerPosition = [_this, 0] call BIS_fnc_param;
_markerColor = [_this, 1, "Default"] call BIS_fnc_param;
_markerText = [_this, 2, ""] call BIS_fnc_param;
_markerName = format ["createDotMarker_%1", createDotMarker_id];
_markerName = createMarker [_markerName,_markerPosition];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "mil_dot";
_markerName setMarkerColor _markerColor;
_markerName setMarkerText _markerText;
_markerName;
