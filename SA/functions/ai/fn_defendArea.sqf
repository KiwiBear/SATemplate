/*
	Author: [SA] Duda

	Description:
	Defend an area with a set of entities

	Parameter(s):
	_this select 0: STRING - Name of entity marker
	_this select 1: STRING (OPTIONAL) - Name of defend marker (default: _this select 0)
	_this select 2: NUMBER (OPTIONAL) - Odds of building placement (0-1) (default: 0.3)
	_this select 3: NUMBER (OPTIONAL) - Odds of road placement (0-1) (default: 0.6)
	_this select 4: NUMBER (OPTIONAL) - Odds of presence (0-1) (default: 1)
	_this select 5: ARRAY (OPTIONAL) - Behaviour - one is picked randomly (default: ["SAFE"])
	_this select 6: ARRAY (OPTIONAL) - Combat mode - one is picked randomly (default: ["RED","YELLOW"])
	_this select 7: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])
		
	Returns: 
	Nothing
*/

private ["_entitiyMarkerName","_defendMarkerName","_entities","_oddsOfBuilding","_oddsOfRoad","_oddsOfPresense","_entityDefendFunction","_behaviors","_combatModes","_avoidMarkerNames","_behavior","_combat"];

_entitiyMarkerName = [_this, 0] call BIS_fnc_param;
_defendMarkerName = [_this, 1, _entitiyMarkerName] call BIS_fnc_param;
_oddsOfBuilding = [_this, 2, 0.3] call BIS_fnc_param;
_oddsOfRoad = [_this, 3, 0.6] call BIS_fnc_param;
_oddsOfPresense = [_this, 4, 1] call BIS_fnc_param;
_behaviors = [_this, 5, ["SAFE"]] call BIS_fnc_param;
_combatModes = [_this, 6, ["RED","YELLOW"]] call BIS_fnc_param;
_avoidMarkerNames = [_this, 7, []] call BIS_fnc_param;
_behavior = (_behaviors select floor( random( (count _behaviors) - 1 ) ));
_combat = (_combatModes select floor( random( (count _combatModes) - 1 ) ));

_entityDefendFunction = {
	private ["_entity"];
	_entity = [_this, 0] call BIS_fnc_param;
	_entity setBehaviour _behavior;
	_entity setCombatMode _combat;
	//[getPos _entity,"ColorRed"] call SA_fnc_createDotMarker;	
};
[_entitiyMarkerName, _defendMarkerName, _oddsOfBuilding, _oddsOfRoad, _oddsOfPresense, {}, _entityDefendFunction,_avoidMarkerNames] call SA_fnc_placeEntities;
