private ["_pos","_groupHalo","_unit","_haloHeight","_haloAutoDeployHeight"];

_unit = [_this,0] call BIS_fnc_param;
_groupHalo = [_this,1,false] call BIS_fnc_param;
_haloHeight = [_this,1,1000] call BIS_fnc_param;
_haloAutoDeployHeight = [_this,1,100] call BIS_fnc_param;

_unit groupchat "Left click on the map where you want to halo";
openMap true;
mapclick = false;
onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";
waituntil {mapclick or !(visiblemap)};
if !(visibleMap) exitwith {};
_pos = clickpos;
if (_groupHalo) then {
	{
		if(_unit distance _x < 200) then {
			
			
			
		};
	} foreach units (group _unit);
} else {


};