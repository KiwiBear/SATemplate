/*
	Author: [SA] Duda

	Description:
	Finds valid road position and direction(s) inside a marker

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: OBJECT - Object to be placed at the position
	_this select 2: ARRAY (OPTIONAL) - Group placement area [[X,Y],radius]. This is used for group placement so all entities get placed near each other.
	_this select 3: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])

	Returns: 
	ARRAY - A valid road position and direction [[X,Y],DIRECTION] within the marker
*/

scopeName "SA_fnc_findValidRoadPositionInsideMarker";
private ["_markerName","_objectToBePlaced","_position","_direction","_groupPlacementArea","_avoidMarkerNames"];

_markerName = [_this, 0] call BIS_fnc_param;
_objectToBePlaced = [_this, 1, []] call BIS_fnc_param;
_groupPlacementArea = [_this, 2, []] call BIS_fnc_param;
_avoidMarkerNames = [_this, 3, []] call BIS_fnc_param;
_direction = random 360;
_position = [_markerName,_groupPlacementArea,_avoidMarkerNames] call SA_fnc_findPositionInsideMarker;

private ["_roads","_roadSegment","_roadPosition","_roadConnectedTo","_connectedRoad","_roadDir"];	
for "_i" from 1 to 100 do
{
	_roads = _position nearRoads 100;
	if( count _roads > 0 ) then {
		_roadSegment = _roads select floor( random( (count _roads) - 1 ) );
		_roadPosition = getPos _roadSegment;
		if([_roadPosition, _objectToBePlaced] call SA_fnc_isPositionSafe && not ([_roadPosition, _avoidMarkerNames] call SA_fnc_isPositionInsideMarker)) then {
			_position = _roadPosition;
			_roadConnectedTo = roadsConnectedTo _roadSegment;
			if( count _roadConnectedTo > 0 ) then {
				_connectedRoad = _roadConnectedTo select 0;
				_direction = [_roadSegment, _connectedRoad] call BIS_fnc_DirTo;
			};
			breakTo "SA_fnc_findValidRoadPositionInsideMarker";
		};
	};
	_position = [_markerName,_groupPlacementArea,_avoidMarkerNames] call SA_fnc_findPositionInsideMarker;
};

[_position,_direction];
