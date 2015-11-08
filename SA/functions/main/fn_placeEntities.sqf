/*
	Author: [SA] Duda

	Description:
	Places entities within a marker

	Parameter(s):
	_this select 0: STRING - Name of entity marker
	_this select 1: STRING (OPTIONAL) - Name of placement marker (default: _this select 0)
	_this select 2: NUMBER (OPTIONAL) - Odds of building placement (0-1) (default: 0.3)
	_this select 3: NUMBER (OPTIONAL) - Odds of road placement (0-1) (default: 0.6)
	_this select 4: NUMBER (OPTIONAL) - Odds of presence (0-1) (default: 1)
	_this select 5: NUMBER (OPTIONAL) - Group callback function - function to be called once per group, passing group in as first parameter
	_this select 6: NUMBER (OPTIONAL) - Entity callback function - function to be called once per entity, passing entity in as first parameter
	_this select 7: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])
		
	Returns: 
	Nothing
*/

private ["_entitiyMarkerName","_placementMarkerName","_entities","_oddsOfBuilding","_oddsOfRoad","_oddsOfPresense","_groupedEntitites","_groupFunction","_entityFunction","_avoidMarkerNames"];

_entitiyMarkerName = [_this, 0] call BIS_fnc_param;
_placementMarkerName = [_this, 1, _entitiyMarkerName] call BIS_fnc_param;
_oddsOfBuilding = [_this, 2, 0.3] call BIS_fnc_param;
_oddsOfRoad = [_this, 3, 0.6] call BIS_fnc_param;
_oddsOfPresense = [_this, 4, 1] call BIS_fnc_param;
_groupFunction = [_this, 5, {}] call BIS_fnc_param;
_entityFunction = [_this, 6, {}] call BIS_fnc_param;
_avoidMarkerNames = [_this, 7, []] call BIS_fnc_param;
_entities = [_entitiyMarkerName] call SA_fnc_entitiesInsideMarker;	
_groupedEntitites = [_entities] call SA_fnc_groupObjectsByGroup;
_placementMarkerName setMarkerAlpha 0;
_entitiyMarkerName setMarkerAlpha 0;

{
	private ["_entityGroupPosition", "_entityGroup","_entity","_entityGroupPlacementType","_entityPosition","_entityGroupPlacementArea"];
	_entityGroup = _x;		
	_entityGroupPlacementType = [_entityGroup, _oddsOfRoad, _oddsOfBuilding] call SA_fnc_getPlacementType;
	_entityGroupPosition = [_placementMarkerName,_entityGroup select 0,_entityGroupPlacementType, [], _avoidMarkerNames] call SA_fnc_findValidPositionInsideMarker;
	_entity = _entityGroup select 0;
	_entityPosition = _entityGroupPosition;
	
	if( count _entityGroup > 1 ) then {
		{
			if( random(1) < _oddsOfPresense ) then {
				_entity = _x;
				_entity setPos (_entityPosition select 0);
				_entity setDir (_entityPosition select 1);
				[_entity, _entityGroup, _placementMarkerName, _this] call _entityFunction;
				_entityGroupPlacementArea = [_entityPosition select 0,25];
				_entityPosition = [_placementMarkerName,_entity,_entityGroupPlacementType,_entityGroupPlacementArea, _avoidMarkerNames] call SA_fnc_findValidPositionInsideMarker;	
			} else {
				deleteVehicle _entity;
			};
		}
		forEach _entityGroup;
		[group _entity, _entityGroup, _placementMarkerName, _this] call _groupFunction;
	} else {
		if( random(1) < _oddsOfPresense ) then {
			_entity setPos (_entityPosition select 0);
			_entity setDir (_entityPosition select 1);
			[_entity, _entityGroup, _placementMarkerName, _this] call _entityFunction;
			[group _entity, _entityGroup, _placementMarkerName, _this] call _groupFunction;
		} else {
			deleteVehicle _entity;
		};
	};
}
forEach _groupedEntitites;
