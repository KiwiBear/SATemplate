private ["_pos","_groupHalo","_unit","_haloHeight","_haloAutoDeployHeight","_leaderPos","_dest"];

_haloMap = [_this,0] call BIS_fnc_param;
_units = [_this,1,[]] call BIS_fnc_param;
_groupHalo = [_this,2,false] call BIS_fnc_param;
_haloHeight = [_this,3,4500] call BIS_fnc_param;
_haloAutoDeployHeight = [_this,4,300] call BIS_fnc_param;

if (typeName _units != "ARRAY") then {
	_units = [_units];
};

if (_groupHalo) then {	
	if(player distance _haloMap > 200) exitwith {
		player groupchat "You're too far away from the halo board to group halo!";
	};
};

player groupchat "Left click on the map where you want to halo";
openMap true;
mapclick = false;
onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";
waituntil {mapclick or !(visiblemap)};
if !(visibleMap) exitwith {};
_pos = clickpos;
openMap false;

if (_groupHalo) then {	
	_leaderPos = position player;
	[[player, _haloHeight, _pos, _haloAutoDeployHeight],"SA_fnc_haloJump",player] spawn BIS_fnc_MP;
	{
		if(_leaderPos distance _x < 200 && player != _x) then {
			_dest = [_pos, 70] call SA_fnc_getPositionInsideCircle;
			[[_x, _haloHeight + (random 100), _dest, _haloAutoDeployHeight],"SA_fnc_haloJump",_x] spawn BIS_fnc_MP;
		};
	} foreach units (group player);
} else {
	{
		if(_x distance _haloMap > 200) then {
			player groupchat format ["Cannot halo jump %1 - they're more than 200m away from the halo board",name _x];
		} else {
			_dest = [_pos, 70] call SA_fnc_getPositionInsideCircle;
			[[_x, _haloHeight + (random 100), _dest, _haloAutoDeployHeight],"SA_fnc_haloJump",_x] spawn BIS_fnc_MP;
		};
	} foreach _units;
};