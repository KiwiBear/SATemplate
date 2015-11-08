private ["_pos","_groupHalo","_unit","_haloHeight","_haloAutoDeployHeight","_leaderPos","_dest"];

_unit = [_this,0] call BIS_fnc_param;
_groupHalo = [_this,1,false] call BIS_fnc_param;
_haloHeight = [_this,2,4500] call BIS_fnc_param;
_haloAutoDeployHeight = [_this,3,300] call BIS_fnc_param;

_unit groupchat "Left click on the map where you want to halo";
openMap true;
mapclick = false;
onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";
waituntil {mapclick or !(visiblemap)};
if !(visibleMap) exitwith {};
_pos = clickpos;
openMap false;
_leaderPos = position _unit;

[[_unit, _haloHeight, _pos, _haloAutoDeployHeight],"SA_fnc_haloJump",_unit] spawn BIS_fnc_MP;

if (_groupHalo) then {	
	{
		if(_leaderPos distance _x < 200 && _unit != _x) then {
			_dest = [_pos, 70] call SA_fnc_getPositionInsideCircle;
			[[_x, _haloHeight + (random 100), _dest, _haloAutoDeployHeight],"SA_fnc_haloJump",_x] spawn BIS_fnc_MP;
		};
	} foreach units (group _unit);
};