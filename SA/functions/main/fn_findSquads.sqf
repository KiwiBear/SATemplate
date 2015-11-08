/*
	Author: [SA] Duda
	
	Description:
	Find all squads in the area
	
	Parameters:
		0: ARRAY - Search center position
		1: NUMBER - Search radius
		2: SIDE - Search side
		3: NUMBER (OPTIONAL) - Squad radius (default 20)
	
	Returns:
	[Squad leader, Array of units in squad, Array of groups in squad]
*/

private ["_searchCenter","_searchDist","_side","_squadRadius"];

_searchCenter = [_this,0] call BIS_fnc_param;
_searchDist = [_this,1] call BIS_fnc_param;
_side = [_this,2] call BIS_fnc_param;
_squadRadius = [_this,3,20] call BIS_fnc_param;

private ["_allEntities","_squads"];

_allEntities = [_searchCenter, _searchDist, {side _x == _side}] call SA_fnc_getNearEntities;

_squads = [];

{
	private ["_unit","_unitPos","_foundSquadIndex","_existingSquad","_group"];

	_unit = _x;
	_unitPos = getPos _unit;
	_foundSquadIndex = -1;
	_group = group _unit;
	
	for "_i" from 0 to (count _squads)-1 do
	{
		scopeName "squadLoop";
		if( _unitPos distance ( getPos ((_squads select _i) select 0) ) < _squadRadius ) then {
			_foundSquadIndex = _i;
			breakOut "squadLoop";
		};
	};
	
	if( _foundSquadIndex == -1 ) then {
		_squads = _squads + [[_unit, [_unit], [_group]]];
	} else {
		_existingSquad = _squads select _foundSquadIndex;
		_newUnits = (_existingSquad select 1) + [_unit];
		_newGroups = ((_existingSquad select 2) - [_group]) + [_group];
		_squads set [_foundSquadIndex,[_existingSquad select 0,_newUnits,_newGroups]];
	};
	
} forEach _allEntities;

_squads;