/*
	Author: [SA] Duda

	Description:
	Finds a valid position inside a circle

	Parameter(s):
	_this select 0: ARRAY - Center of circle [X,Y]
	_this select 1: NUMBER - Radius of circle
	_this select 2: OBJECT/STRING - Object to be placed at the position, or kind of object
	_this select 3: NUMBER - Size of object to be placed (optional)
	
	Returns: 
	ARRAY - A valid position and direction within the marker [[X,Y],direction]
*/

scopeName "SA_fnc_findValidAnyPositionInsideMarker";
private ["_markerName","_objectToBePlaced","_position","_direction","_groupPlacementArea","_avoidMarkerNames","_sizeOfObject"];
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1] call BIS_fnc_param;
_objectToBePlaced = [_this, 2] call BIS_fnc_param;
_sizeOfObject = [_this, 3, 0] call BIS_fnc_param;
_position = [_center,_radius] call SA_fnc_getPositionInsideCircle;
_direction = random 360;
for "_i" from 1 to 100 do
{
	if([_position, _objectToBePlaced, _sizeOfObject] call SA_fnc_isPositionSafe) then {
		breakTo "SA_fnc_findValidAnyPositionInsideMarker";
	};
	_position = [_center,_radius] call SA_fnc_getPositionInsideCircle;
};

[_position,_direction];