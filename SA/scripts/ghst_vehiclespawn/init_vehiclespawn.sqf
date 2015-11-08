private ["_type","_spawnBoard"];

_type = [_this,0] call BIS_fnc_param;
_spawnBoard = [_this,1] call BIS_fnc_param;

if(isNil "ghst_vehiclespawnlists_loaded") then {
	ghst_local_vehicles = [];
	_vehlist = execvm "SA\scripts\ghst_vehiclespawn\vehiclelist.sqf";
	_airlist = execvm "SA\scripts\ghst_vehiclespawn\aircraftlist.sqf";
	_boatlist = execvm "SA\scripts\ghst_vehiclespawn\boatlist.sqf";
	ghst_vehiclespawnlists_loaded = true;
};

if(_type == "ground") then {
	_spawnBoard addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Vehicle</t> <img size='4' color='#FFA000' shadow='2' image='\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa'/>", "SA\scripts\ghst_vehiclespawn\ghst_spawnveh.sqf", ["veh_spawn",45], 6, true, true, "","alive _target"];
	_spawnBoard setObjectTexture [0, "\A3\armor_f_gamma\MBT_01\Data\UI\Slammer_M2A1_Base_ca.paa"];
};

if(_type == "air") then {
	_spawnBoard addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Aircraft</t> <img size='4' color='#FFA000' shadow='2' image='\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa'/>", "SA\scripts\ghst_vehiclespawn\ghst_spawnair.sqf", ["air_spawn",135], 6, true, true, "","alive _target"];
	_spawnBoard setObjectTexture [0, "\A3\Air_F_EPC\Plane_CAS_01\Data\UI\Plane_CAS_01_CA.paa"];
};

if(_type == "sea") then {
	_spawnBoard addAction ["<t size='1.5' shadow='2' color='#FFA000'>Spawn Boat</t> <img size='4' color='#FFA000' shadow='2' image='\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa'/>", "SA\scripts\ghst_vehiclespawn\ghst_spawnboat.sqf", ["boat_spawn",166], 6, true, true, "","alive _target"];
	_spawnBoard setObjectTexture [0, "\A3\boat_f_beta\SDV_01\data\ui\portrait_SDV_ca.paa"];
};