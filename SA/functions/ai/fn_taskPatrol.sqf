/*
	Author: [SA] Duda
 
	Description:
	Create a random patrol of several waypoints within a marker

	Parameter(s):
	_this select 0: GROUP - Group to assign waypoints
	_this select 1: ARRAY - Array of entities all w/ the specified group
	_this select 2: STRING - Marker name to contain waypoints
	_this select 3: NUMBER (OPTIONAL) - Odds of building placement (0-1) (default: 0.0)
	_this select 4: NUMBER (OPTIONAL) - Odds of road placement (0-1) (default: 0.6)
	_this select 5: ARRAY (OPTIONAL) - Waypoint speeds - one is picked randomly (default: ["NORMAL"])
	_this select 6: ARRAY (OPTIONAL) - Waypoint formations - one is picked randomly (default: ["STAG COLUMN"])
	_this select 7: ARRAY (OPTIONAL) - Waypoint Behaviour - one is picked randomly (default: ["SAFE"])
	_this select 8: ARRAY (OPTIONAL) - Waypoint Combat Mode - one is picked randomly (default: ["YELLOW"])
	_this select 9: ARRAY (OPTIONAL) - List of marker names where entities cannot be placed (default: [])
	
	
	Returns:
	Boolean - success flag
*/

private ["_group","_entityGroup","_patrolMarkerName","_originalPosition","_oddsOfBuilding","_oddsOfRoad","_wpSpeeds","_wpFormations","_wpBehaviors","_wpSpeed","_wpFormation","_wpBehavior", "_wpCombat", "_wpCombats","_avoidMarkerNames"];

_group = [_this, 0] call BIS_fnc_param;
_entityGroup = [_this, 1] call BIS_fnc_param;
_patrolMarkerName = [_this, 2] call BIS_fnc_param;
_oddsOfBuilding = [_this, 3, 0.0] call BIS_fnc_param;
_oddsOfRoad = [_this, 4, 0.6] call BIS_fnc_param;
_wpSpeeds = [_this, 5, ["NORMAL"]] call BIS_fnc_param;
_wpFormations = [_this, 6, ["STAG COLUMN"]] call BIS_fnc_param;
_wpBehaviors = [_this, 7, ["SAFE"]] call BIS_fnc_param;
_wpCombats = [_this, 8, ["YELLOW"]] call BIS_fnc_param;
_avoidMarkerNames = [_this, 9, []] call BIS_fnc_param;
_wpSpeed = (_wpSpeeds select floor( random( (count _wpSpeeds) - 1 ) ));
_wpFormation = (_wpFormations select floor( random( (count _wpSpeeds) - 1 ) ));
_wpBehavior = (_wpBehaviors select floor( random( (count _wpBehaviors) - 1 ) ));
_wpCombat = (_wpCombats select floor( random( (count _wpCombats) - 1 ) ));

_originalPosition = getPos leader _group;
while {(count (waypoints _group)) > 0} do
 {
  deleteWaypoint ((waypoints _group) select 0);
 };

 private ["_entityGroupPlacementType","_nextPosition","_wp"];
 _entityGroupPlacementType = [_entityGroup, _oddsOfRoad, _oddsOfBuilding] call SA_fnc_getPlacementType;
for "_i" from 0 to (2 + (floor (random 3))) do
{
	_nextPosition = [_patrolMarkerName,leader _group,_entityGroupPlacementType,[],_avoidMarkerNames] call SA_fnc_findValidPositionInsideMarker;
	if (_i == 0) then
	{
		_originalPosition = _nextPosition select 0;
		_wp = _group addWaypoint [_nextPosition select 0, 0];
		_wp setWaypointType "MOVE";
		_wp setWaypointCompletionRadius 25;
	};
	_wp = _group addWaypoint [_nextPosition select 0, 0];
	_wp setWaypointType "SAD";
	_wp setWaypointCompletionRadius 25;
	_wp setWaypointSpeed _wpSpeed;
	_wp setWaypointFormation _wpFormation;
	_wp setWaypointBehaviour _wpBehavior;
	_wp setWaypointCombatMode _wpCombat;
	//[_nextPosition select 0,"ColorRed"] call SA_fnc_createDotMarker;
};

//Cycle back to the first position.
private ["_wp"];
_wp = _group addWaypoint [_originalPosition, 0];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius 20;
