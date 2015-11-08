/*
	Author: [SA] Duda

	Description:
	Finds a valid position inside a marker

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: OBJECT - Object to be placed at the position
	_this select 2: STRING (OPTIONAL) - Placement type ("Building","Road","Any"). Defaults to "Any"
	_this select 3: ARRAY (OPTIONAL) - Group placement area [[X,Y],radius]. This is used for group placement so all entities get placed near each other.
			Not supported for building placement type.
	_this select 4: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])

	Returns: 
	ARRAY - A valid position and direction within the marker [[X,Y],direction]
*/

private ["_markerName","_objectToBePlaced","_positionAndDirection","_placementType","_groupPlacementArea","_avoidMarkerNames"];
_markerName = [_this, 0] call BIS_fnc_param;
_objectToBePlaced = [_this, 1] call BIS_fnc_param;
_placementType = [_this, 2, "Any"] call BIS_fnc_param;
_groupPlacementArea = [_this, 3, []] call BIS_fnc_param;
_avoidMarkerNames = [_this, 4, []] call BIS_fnc_param;

if( _placementType == "Any" ) then {
	_positionAndDirection = [_markerName, _objectToBePlaced, _groupPlacementArea, _avoidMarkerNames] call SA_fnc_findValidAnyPositionInsideMarker;
};

if( _placementType == "Road" ) then {
	_positionAndDirection = [_markerName, _objectToBePlaced, _groupPlacementArea, _avoidMarkerNames] call SA_fnc_findValidRoadPositionInsideMarker;
};

if( _placementType == "Building" ) then {
	_positionAndDirection = [_markerName, _objectToBePlaced, _groupPlacementArea, _avoidMarkerNames] call SA_fnc_findValidBuildingPositionInsideMarker;
};

_positionAndDirection;
