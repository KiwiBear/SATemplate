/*
	Author: [SA] Duda
	
	Description:
	Get playable units optionally matching some criteria
	
	Parameters:
		0: FUNCTION (OPTIONAL) - Function to test for criteria (must return true - unit being tested is identified by _x variable) 
			If not defined, all playable units will be returned.
	
	Returns:
	ARRAY - Array of playable units matching some criteria
*/

private ["_function","_allUnits","_filteredUnits"];
_function = [_this,0,{true}] call BIS_fnc_param;
_filteredUnits = [];
if(isMultiplayer) then {
	_allUnits = playableUnits;
} else {
	_allUnits = [player];
};
{
	if([] call _function) then {
		_filteredUnits = _filteredUnits + [_x];
	};
}	
forEach _allUnits;
_filteredUnits;