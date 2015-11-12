// Disable Saving
enableSaving [false, false];

// Wait until player is initialized
if (!isDedicated) then {waitUntil {!isNull player && isPlayer player};};

// IgiLoad
_igiload = execVM "IgiLoad\IgiLoadInit.sqf";

// INS Revive & SA: AI revive mod
if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};
[] execVM "INS_revive\revive_init.sqf";
[] execVM "SA\scripts\ins_ai_revive_init.sqf";
waitUntil {!isNil "INS_REV_FNCT_init_completed"};

// SA: Ropes
[] execVM "SA\scripts\sa_ropes.sqf";

// SA: Command Radio - High Command
["command_radio"] execVM "SA\scripts\sa_command_radio_hc.sqf";

// SA: Squad Join
[] execVM "SA\scripts\sa_squad_join.sqf";

// SA: Halo
halo addAction ["<t size='1.5' shadow='2' color='#00ffff'>HALO</t> <img size='2' color='#00ffff' shadow='2' image='\A3\Air_F_Beta\Parachute_01\Data\UI\Portrait_Parachute_01_CA.paa'/>", { [halo, _this select 1] spawn SA_fnc_haloJumpMap }, [], 5, true, true, "","alive _target"];
halo addAction ["<t size='1.5' shadow='2' color='#00ffff'>SQUAD HALO</t> <img size='2' color='#00ffff' shadow='2' image='\A3\Air_F_Beta\Parachute_01\Data\UI\Portrait_Parachute_01_CA.paa'/>", { [halo, _this select 1, true] spawn SA_fnc_haloJumpMap }, [], 5, true, true, "","alive _target && leader _this == _this && (count units group _this) > 1"];

// AI Cache
//if (isServer) then {[2000,-1,false,2000,2000,2000] execVM "zbe_cache\main.sqf";};

// Time of day & weather
if(isServer) then {["paramDaytimeHour" call BIS_fnc_getParamValue] call SA_fnc_timeOfDay;};
[] spawn SA_fnc_randweather;

// Task Management
execVM "SA\scripts\shk_taskmaster.sqf";

// Ghost Missions
if((call SA_fnc_isAiServer) && "PARAM_GhostEnabled" call BIS_fnc_getParamValue == 1) then {execVM "Ghost\initGhost.sqf"};

// Ghost Vehicle Spawn
["ground",vehspawn] execVM "SA\scripts\ghst_vehiclespawn\init_vehiclespawn.sqf";
["air",airspawn] execVM "SA\scripts\ghst_vehiclespawn\init_vehiclespawn.sqf";
["sea",boatspawn] execVM "SA\scripts\ghst_vehiclespawn\init_vehiclespawn.sqf";

// SA: TeamSpeak Addon (Server Only, Optional)
execVM "SA\scripts\sa_teamspeak_addon.sqf";

// SA: Player Names & TeamSpeak Voice (Optional)
execVM "SA\scripts\sa_player_names.sqf";

// SA: Fatigue
execVM "SA\scripts\sa_fatigue.sqf";

// Civilian Occupation System (COS) v0.5
if("PARAM_COS" call BIS_fnc_getParamValue == 1) then {execVM "cos\cosInit.sqf";};

// Add changes below this line //
