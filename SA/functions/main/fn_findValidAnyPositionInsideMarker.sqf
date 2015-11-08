/*
	Author: [SA] Duda

	Description:
	Finds any valid random position inside a marker.

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: OBJECT - Object to be placed at the position
	_this select 2: ARRAY (OPTIONAL) - Group placement area [[X,Y],radius]. This is used for group placement so all entities get placed near each other.
	_this select 3: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])

	Returns: 
	ARRAY - A valid position and direction within the marker [[X,Y],direction]
*/

scopeName "SA_fnc_findValidAnyPositionInsideMarker";
private ["_markerName","_objectToBePlaced","_position","_direction","_groupPlacementArea","_avoidMarkerNames"];
_markerName = [_this, 0] call BIS_fnc_param;
_objectToBePlaced = [_this, 1] call BIS_fnc_param;
_groupPlacementArea = [_this, 2, []] call BIS_fnc_param;
_avoidMarkerNames = [_this, 3, []] call BIS_fnc_param;
_position = [_markerName,_groupPlacementArea,_avoidMarkerNames] call SA_fnc_findPositionInsideMarker;
_direction = random 360;
for "_i" from 1 to 100 do
{
	if([_position, _objectToBePlaced] call SA_fnc_isPositionSafe) then {
		breakTo "SA_fnc_findValidAnyPositionInsideMarker";
	};
	_position = [_markerName,_groupPlacementArea,_avoidMarkerNames] call SA_fnc_findPositionInsideMarker;
};

[_position,_direction];
