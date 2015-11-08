/*
	Author: [SA] Duda

	Description:
	Moves everything insider a marker (rectangle only) to a specified position
	Will maintain the same relative positioning

	Parameter(s):
	_this select 0: STRING - Name of marker
	_this select 1: ARRAY - Position [X,Y]
	_this select 2: BOOLEAN - Building placement (optional, default false)
		
	Returns: 
	Nothing
*/

private ["_markerName", "_position", "_center", "_objectsInMarker", "_objPos", "_offsetX", "_offsetY", "_markersInMarker","_buildingPlacement"];

_markerName = [_this, 0] call BIS_fnc_param;
_position = [_this, 1] call BIS_fnc_param;
_buildingPlacement = [_this, 2, false] call BIS_fnc_param;
_center = markerPos _markerName;

if(_buildingPlacement) then {

	private ["_nearHouses","_building","_buildingPositionCount","_buildingPositionIndex"];	

	_nearHouses = _position nearObjects ["House",35];
	if( count _nearHouses > 0 ) then {
		_building = _nearHouses select floor( random( (count _nearHouses) - 1 ) );		
		_buildingPositionCount = 0;
		while {(_building buildingPos _buildingPositionCount) distance [0,0,0] > 0} do {
			_buildingPositionCount = _buildingPositionCount + 1;
		};
		if( _buildingPositionCount > 0 ) then {
			_buildingPositionIndex = floor( random( _buildingPositionCount ) );
			_position = _building buildingPos _buildingPositionIndex;
		};
	};

};

_objectsInMarker = [_markerName] call SA_fnc_objectsInsideMarker;
{
	_objPos = getPos _x;
	_offsetX = (_objPos select 0) - (_center select 0);
	_offsetY = (_objPos select 1) - (_center select 1);
	
	if(_buildingPlacement) then {
	_offsetX = 0;
	_offsetY = 0;
	};
	
	_x setPos [(_position select 0) + _offsetX, (_position select 1) + _offsetY, _position select 2];
}
forEach _objectsInMarker;

_markersInMarker = [_markerName] call SA_fnc_markersInsideMarker;
{
	_objPos = markerPos _x;
	_offsetX = (_objPos select 0) - (_center select 0);
	_offsetY = (_objPos select 1) - (_center select 1);
	_x setMarkerPos [(_position select 0) + _offsetX, (_position select 1) + _offsetY];
}
forEach _markersInMarker;

_markerName setMarkerAlpha 0;
	