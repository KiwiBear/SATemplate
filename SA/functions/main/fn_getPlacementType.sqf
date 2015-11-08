/*
	Author: [SA] Duda

	Description:
	Get random placement type ("Any", "Building", or "Road"). Depends on the types of objects specified:
	
	Only LandVehicle = Road or Any
	Only LandVehicle & Man = Road or Any
	Only Man (Single) = Building or Any
	Anything else = Any

	Parameter(s):
	_this select 0: ARRAY - Array of objects to be placed
	_this select 1: NUMBER - Odds of road placement (0-1) (default 0.5)
	_this select 2: NUMBER - Odds of building placement (0-1) (default 0.5)

	Returns: 
	STRING - "Any", "Building", or "Road"
*/

private ["_objects","_roadOdds","_buildingOdds","_placementType"];

_objects = [_this, 0, []] call BIS_fnc_param;
_roadOdds = [_this, 1,["0.5"]] call BIS_fnc_param;
_buildingOdds = [_this, 2,["0.5"]] call BIS_fnc_param;
_placementType = "Any";

//Only LandVehicle = Road or Any
//Only LandVehicle & Man = Road or Any
if( [_objects,["LandVehicle"]] call SA_fnc_containsOnlySpecifiedTypes || [_objects,["LandVehicle","Man"]] call SA_fnc_containsOnlySpecifiedTypes ) then {
	if( random(1) < _roadOdds ) then {
		_placementType = "Road";
	};
};

//Only Man (Single) = Building or Any
if( [_objects,["Man"]] call SA_fnc_containsOnlySpecifiedTypes ) then {
	if( random(1) < _buildingOdds && count _objects == 1 ) then {
		_placementType = "Building";
	};
};

_placementType;