private ["_pos","_unit"];

_unit = [_this,0] call BIS_fnc_param;

_unit groupchat "Left click on the map where you want to move";
openMap true;
mapclick = false;
onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";
waituntil {mapclick or !(visiblemap)};
if !(visibleMap) exitwith {};
_pos = clickpos;
openMap false;
_unit setPos _pos;