//V1.3 Script by: Ghost - calls in a support aircraft until fuel is low or out of ammo then leaves
//
private ["_spawnmark","_type","_tos","_radaltarray","_rad","_flyheight","_delay","_markunitsarray","_markunits","_mcolor","_supportvar","_veh_name","_dir","_pos","_chute1","_air1_array","_air1","_wGrp"];

_spawnmark = _this select 0;// spawn point where aircraft spawns and deletes
_type = _this select 1;// type of air to spawn i.e. "B_Heli_Attack_01_F" or "B_Plane_CAS_01_F"
_tos = (_this select 2) * 60;// time on station
_radaltarray = _this select 3;// radius and altitude array
	_rad = _radaltarray select 0;// radius aircraft will search
	_flyheight = _radaltarray select 1;// altitude aircraft will fly
_delay = (_this select 4) * 60;// time before air support can be called again
_markunitsarray = _this select 5;//marks waypoints of aircraft
	_markunits = _markunitsarray select 0;
	_mcolor = _markunitsarray select 1;
_supportvar = _this select 6;//variable in string format to check if support is available or not

_veh_name = (configFile >> "cfgVehicles" >> (_type) >> "displayName") call bis_fnc_getcfgdata;
if (player getVariable _supportvar) exitwith {hint format ["%1 Support Busy", _veh_name];};

openMap true;

hint format ["Left click on the map where you want the %1 to go or press escape to cancel", _veh_name];

mapclick = false;

onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";

waituntil {mapclick or !(visiblemap)};
if (!visibleMap) exitwith {
	hint "Air Support Ready";
	};
	
_pos = [clickpos select 0, clickpos select 1, _flyheight];

sleep 1;

openMap false;

_wGrp = createGroup WEST;
_dir = [_spawnmark, _pos] call BIS_fnc_dirTo;

_air1_array = [_spawnmark, _dir, _type, _wGrp] call BIS_fnc_spawnVehicle;
_air1 = _air1_array select 0;
_air1 setposatl [getposatl _air1 select 0, getposatl _air1 select 1, _flyheight];
_air1 setVelocity [55 * (sin _dir), 55 * (cos _dir), 0];

player setVariable [_supportvar, true];

sleep 1;

_air1 flyinheight _flyheight;
_air1 setSpeedMode "Normal";
//set combat mode
_wGrp setCombatMode "RED";

_air1 sidechat "I am inbound";

[_wGrp,_pos, [_rad,_rad],_markunitsarray,["COMBAT", "NORMAL", "WEDGE"]] call fnc_ghst_waypoints;
	
_t = time;//current time

While {time < (_t + _tos) and (fuel _air1 > 0.25)} do {
if (!(alive _air1) or !(canMove _air1)) exitwith {player groupchat "Shit we lost air support";};
if !(someAmmo _air1) exitwith {player groupchat "Out of ammo";};
sleep 10;
};

if ((alive _air1) and (canMove _air1)) then {

_wGrp addwaypoint [_spawnmark, 0];
[_wGrp, 4] setWPPos _spawnmark;
[_wGrp, 4] setWaypointType "MOVE";
[_wGrp, 4] setWaypointBehaviour "CARELESS";
_wGrp setCurrentWaypoint [_wGrp, 4];
		if (_markunits) then {
		_mtext = format ["%1 Waypoint %2",_wGrp, _w];
		[_spawnmark,_mcolor,_mtext] call fnc_ghst_mark_point;
		};

_air1 sidechat "Need to resupply heading home";

waituntil {((getpos _air1) distance _spawnmark) < (_flyheight * 2)};
{deletevehicle _x} foreach crew _air1;
deletevehicle _air1;

} else {

{deletevehicle _x} foreach crew _air1;
//deletevehicle _air1;

};
sleep 20;
deletegroup _wGrp;

sleep _delay;

hint format ["%1 Support Ready", _veh_name];

player setVariable [_supportvar, false];

if (true) exitwith {};
