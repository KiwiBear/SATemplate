/*
	Author: [SA] Duda

	Description:
	Forms specified units into a new group
	
	Parameter(s):
	_this select 0: ARRAY - [
		UNIT - selected unit, ...
	]

	Returns: 
	Nothing
	
*/

private ["_units","_firstUnit","_firstUnitSide","_group"];
_units = param [0];

if(count _units > 0) then {
	_firstUnit = _units select 0;
	_firstUnitSide = side _firstUnit;
	_group = createGroup _firstUnitSide;
	_units join _group;
	{
		[[_x],true] remoteExec ["orderGetIn",_x];
	} forEach _units;
};