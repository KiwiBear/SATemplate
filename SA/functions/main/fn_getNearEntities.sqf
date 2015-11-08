/*
	Author: [SA] Duda
	
	Description:
	Get near entities optionally matching some criteria
	
	Parameters:
		0: ARRAY - Search center position [X,Y]
		1: NUMBER (OPTIONAL) - Search radius in meters (default 50)
		2: FUNCTION (OPTIONAL) - Function to test for criteria (must return true - unit being tested is identified by _x variable) 
			If not defined, all near entities will be returned.
	
	Returns:
	ARRAY - Array of playable units matching some criteria
*/

private ["_position","_radius","_filteredEntities","_function","_allEntities","_allObjects"];
_position = [_this,0] call BIS_fnc_param;
_radius = [_this,1,50] call BIS_fnc_param;
_function = [_this,2,{true}] call BIS_fnc_param;
//_allEntities = _position nearEntities _radius;
_allObjects = nearestObjects [_position, [], _radius];
_filteredEntities = [];
{
	if(alive _x) then {
		if([] call _function) then {
			_filteredEntities = _filteredEntities + [_x];
		};
	};
}	
forEach _allObjects;
_filteredEntities;
