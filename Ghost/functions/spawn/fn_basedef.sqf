//V1.4 by: Ghost
if !((call SA_fnc_isAiServer)) exitwith {};
/*
Spawn AA Defence
ghst_aa = ["spawnmarker","unittype",dir,allowdamage? true/false] execvm "base_AA.sqf";
*/

_spawn_markers = _this select 0;
_aa_type = _this select 1;
_dir = _this select 2;
_damg = _this select 3;

_veh_array = [];
_loop = true;

{

_spawnaa1 = getmarkerpos _x;

_aa1 = createGroup WEST;

_vaa1 = createVehicle [_aa_type,_spawnaa1, [], 0, "NONE"];
_vaa1 setdir _dir;
_vaa1 setposatl _spawnaa1;

if !(_damg) then {
	_vaa1 addEventHandler ["HandleDamage", {}];
	_vaa1 allowDamage false;
};

if ((_vaa1 emptypositions "Commander") > 0) then {
	_aaman1 = _aa1 createUnit ["B_crew_F",_spawnaa1, [], 0, "NONE"];
	_aaman1 moveincommander _vaa1;
};
_aaman2 = _aa1 createUnit ["B_crew_F", _spawnaa1, [], 0, "NONE"];
_aaman2 moveingunner _vaa1;
_vaa1 lock true;

_aa1 setFormDir _dir;

_veh_array = _veh_array + [_vaa1];

} foreach _spawn_markers;

while {_loop} do {
	
	{if (alive _x) then {
	
		_x setfuel 1;
		_x setVehicleAmmo 1;
		} else {
		
		_veh_array = _veh_array - [_x];
		deletevehicle _x;
		
		};
	
	} foreach _veh_array;
	
	if (count _veh_array == 0) exitwith {_loop = false;};
	
	sleep 300;

};

diag_log "BASE DEFENSE SCRIPT END!";

if (true) exitwith {};