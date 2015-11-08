/*
	Author: [SA] Duda

	Description:
	Finds valid building position and direction(s) inside a marker

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: OBJECT - Object to be placed at the position
	_this select 2: ARRAY (OPTIONAL) - Group placement area [[X,Y],radius]. This is used for group placement so all entities get placed near each other.
	_this select 3: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])

	Returns: 
	ARRAY - A valid building position and direction [[X,Y,Z],DIRECTION] within the marker
*/

scopeName "SA_fnc_findValidBuildingPositionInsideMarker";
private ["_markerName","_objectToBePlaced","_position","_direction","_groupPlacementArea","_avoidMarkerNames"];
_markerName = [_this, 0] call BIS_fnc_param;
_objectToBePlaced = [_this, 1, []] call BIS_fnc_param;
_groupPlacementArea = [_this, 2, []] call BIS_fnc_param;
_avoidMarkerNames = [_this, 3, []] call BIS_fnc_param;
_direction = random 360;
_position = [_markerName,_groupPlacementArea,_avoidMarkerNames] call SA_fnc_findPositionInsideMarker;
private ["_nearHouses","_building","_buildingPositionCount","_buildingPositionIndex","_buildingPosition"];	
for "_i" from 1 to 100 do
{
	_nearHouses = _position nearObjects ["House",35];
	if( count _nearHouses > 0 ) then {
		_building = _nearHouses select floor( random( (count _nearHouses) - 1 ) );		
		_buildingPositionCount = 0;
		while {(_building buildingPos _buildingPositionCount) distance [0,0,0] > 0} do {
			_buildingPositionCount = _buildingPositionCount + 1;
		};
		if( _buildingPositionCount > 0 ) then {
			_buildingPositionIndex = floor( random( _buildingPositionCount ) );
			_buildingPosition = _building buildingPos _buildingPositionIndex;
			if( [_buildingPosition, _markerName] call SA_fnc_isPositionInsideMarker ) then {			
				if([_buildingPosition, _objectToBePlaced] call SA_fnc_isPositionSafe) then {
					_position = _buildingPosition;
					breakTo "SA_fnc_findValidBuildingPositionInsideMarker";
				};
			};
		};
	};
	_position = [_markerName,_groupPlacementArea,_avoidMarkerNames] call SA_fnc_findPositionInsideMarker;
};
[_position,_direction];
