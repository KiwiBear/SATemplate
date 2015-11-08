//V1.2 Script by: Ghost - calls in a support UGV until dead
//
private ["_spawnmark","_type","_max_num","_delay","_veh_name","_dir","_pos","_chute1","_ugv1_array","_ugv1","_wGrp","_ugv_num"];

_spawnmark = _this select 0;// spawn point where ugv spawns
_type = _this select 1;// type of ugv to spawn i.e. "B_UGV_01_rcws_F"
_max_num = _this select 2;//max number of ugvs allowed per player
_delay = (_this select 3) * 60;// time before ugv support can be called again

_veh_name = (configFile >> "cfgVehicles" >> (_type) >> "displayName") call bis_fnc_getcfgdata;
if (player getVariable "ghst_ugvsup" == _max_num) exitwith {hint format ["%2 support at max number of %1", _max_num, _veh_name];};

openMap true;

hint format ["Left click on the map where you want the %1 to go or press escape to cancel", _veh_name];

mapclick = false;

onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";

waituntil {mapclick or !(visiblemap)};
if (!visibleMap) exitwith {
	hint "UGV Support Ready";
	};
	
_pos = clickpos;

sleep 1;

openMap false;

_dir = [_spawnmark, _pos] call BIS_fnc_dirTo;

_chute1 = createVehicle ["B_Parachute_02_F",[0,0,0], [], 0, "FLY"];
_chute1 setpos [(_pos select 0), (_pos select 1), 150]; 

_ugv1_array = [_spawnmark, _dir, _type, WEST] call BIS_fnc_spawnVehicle;

_ugv1 = _ugv1_array select 0;

createVehicleCrew _ugv1;

_wGrp = (group (crew _ugv1 select 0));

_ugv1 attachTo [_chute1,[0,0,1]];

_ugv_num = player getVariable "ghst_ugvsup";
_ugv_num = _ugv_num + 1;
player setVariable ["ghst_ugvsup", _ugv_num];

waituntil {(getposatl _ugv1 select 2) < 1.5}; 
detach _ugv1;
_ugv1 setpos [getpos _ugv1 select 0,getpos _ugv1 select 1,0];

//connect player to ugv
player connectTerminalToUav _ugv1;

_wGrp setBehaviour "COMBAT";
_wGrp setSpeedMode "Normal";
_wGrp setCombatMode "RED";

_ugv1 sidechat "UGV inbound";

_ugv1 doMove _pos;
/*
_wGrp addwaypoint [_pos, 300];
[_wGrp, 0] setWPPos _pos;
[_wGrp, 0] setWaypointType "LOITER";
*/
While {true} do {
if (!(alive _ugv1) or !(canMove _ugv1)) exitwith {player groupchat format ["Shit we lost %1 support", _veh_name];};
if (fuel _ugv1 < 0.2) then {_ugv1 sidechat "Fuel getting low. Need to refuel soon";};
sleep 10;
};

sleep 30;

{deletevehicle _x} foreach crew _ugv1;
deletevehicle _ugv1;

sleep 20;
deletegroup _wGrp;

sleep _delay;

hint format ["%1 Support Ready", _veh_name];

_ugv_num = player getVariable "ghst_ugvsup";
_ugv_num = _ugv_num - 1;
player setVariable ["ghst_ugvsup", _ugv_num];

if (true) exitwith {};
