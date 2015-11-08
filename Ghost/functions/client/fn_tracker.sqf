/*
V1.3 By: Ghost
Creates a marker that stays with a vehicle until its dead. ghst_tracker = [vehname, "color"] spawn ghst_fnc_tracker.sqf";
*/
if !(local player) exitwith {};
_veh = _this select 0;
_mcolor = _this select 1;
_veh_name = _this select 2;

//_vehtype = typeof _veh;
_vehpos = getpos _veh;

_mtext = format ["%1", _veh_name];
_markname = "ghst_mark" + (name player) + str (random 999);

_mark1 = [_vehpos,"ColorGrey",_markname,_mtext] call fnc_ghst_mark_local;

sleep 1;
while {alive _veh} do {
	_mark1 setmarkerposlocal (getpos _veh);
	if (isnil "_veh") exitwith {};
	sleep 1;
};
deletemarkerlocal _mark1;