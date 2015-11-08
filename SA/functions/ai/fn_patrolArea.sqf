/*
	Author: [SA] Duda

	Description:
	Patrol an area with a set of entities

	Parameter(s):
	_this select 0: STRING - Name of entity marker
	_this select 1: STRING (OPTIONAL) - Name of defend marker (default: _this select 0)
	_this select 2: NUMBER (OPTIONAL) - Odds of building placement (0-1) (default: 0.3)
	_this select 3: NUMBER (OPTIONAL) - Odds of road placement (0-1) (default: 0.6)
	_this select 4: NUMBER (OPTIONAL) - Odds of presence (0-1) (default: 1)
	_this select 5: ARRAY (OPTIONAL) - Waypoint speeds - one is picked randomly (default: ["NORMAL","LIMITED"])
	_this select 6: ARRAY (OPTIONAL) - Waypoint formations - one is picked randomly (default: ["STAG COLUMN","COLUMN","WEDGE"])
	_this select 7: ARRAY (OPTIONAL) - Waypoint Behaviour - one is picked randomly (default: ["SAFE"])
	_this select 8: ARRAY (OPTIONAL) - Waypoint combat mode - one is picked randomly (default: ["RED","YELLOW"])
	_this select 9: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])
		
	Returns: 
	Nothing
*/

private ["_entitiyMarkerName","_defendMarkerName","_entities","_oddsOfBuilding","_oddsOfRoad","_oddsOfPresense","_groupPatrolFunction","_wpSpeeds","_wpFormations","_wpBehaviors","_wpCombatModes","_avoidMarkerNames"];

_entitiyMarkerName = [_this, 0] call BIS_fnc_param;
_defendMarkerName = [_this, 1, _entitiyMarkerName] call BIS_fnc_param;
_oddsOfBuilding = [_this, 2, 0.3] call BIS_fnc_param;
_oddsOfRoad = [_this, 3, 0.6] call BIS_fnc_param;
_oddsOfPresense = [_this, 4, 1] call BIS_fnc_param;
_wpSpeeds = [_this, 5, ["NORMAL","LIMITED"]] call BIS_fnc_param;
_wpFormations = [_this, 6, ["STAG COLUMN","COLUMN","WEDGE"]] call BIS_fnc_param;
_wpBehaviors = [_this, 7, ["SAFE"]] call BIS_fnc_param;
_wpCombatModes = [_this, 8, ["RED","YELLOW"]] call BIS_fnc_param;
_avoidMarkerNames = [_this, 9, []] call BIS_fnc_param;

_groupPatrolFunction = {
	private ["_group","_markerName","_entityGroup","_placementParams","_oddsOfBuilding","_oddsOfRoad"];
	_group = [_this, 0] call BIS_fnc_param;
	_entityGroup = [_this, 1] call BIS_fnc_param;
	_markerName = [_this, 2] call BIS_fnc_param;
	_placementParams = [_this, 3] call BIS_fnc_param;
	_oddsOfBuilding = [_placementParams, 2] call BIS_fnc_param;
	_oddsOfRoad = [_placementParams, 3] call BIS_fnc_param;
	//[getPos (_entityGroup select 0)] call SA_fnc_createDotMarker;
	[_group, _entityGroup, _markerName, _oddsOfBuilding, _oddsOfRoad,_wpSpeeds,_wpFormations,_wpBehaviors,_wpCombatModes,_avoidMarkerNames] call SA_fnc_taskPatrol;
};
[_entitiyMarkerName, _defendMarkerName, _oddsOfBuilding, _oddsOfRoad, _oddsOfPresense, _groupPatrolFunction, {}, _avoidMarkerNames] call SA_fnc_placeEntities;
