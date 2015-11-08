/*
	Author: [SA] Duda
	
	Description:
	Gets squad knows about value (average of all units in squad)
	
	Parameters:
		0: SQUAD - Squad 1
		1: SQUAD - Squad 2
	
	Returns:
	0 to 4 depending on how much squad 1 knows about squad 2
*/

private ["_squad1","_squad2","_s1Unit","_katotal","_count"];

_squad1 = [_this,0] call BIS_fnc_param;
_squad2 = [_this,1] call BIS_fnc_param;

_squad1Units = _squad1 select 1;
_squad2Units = _squad2 select 1;

_count = 0;
_katotal = 0;

{
	_s1Unit = _x;
	{
		_count = _count + 1;
		_katotal = _katotal + (_s1Unit knowsAbout _x);
	} foreach _squad2Units;	
} foreach _squad1Units;

if(_count > 0) then {
	_katotal = _katotal / _count;
};

_katotal;