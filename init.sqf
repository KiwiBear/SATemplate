#include "stages.h"
call compile preprocessFileLineNumbers "gameloop.sqf";
call compile preprocessFileLineNumbers "gamestages.sqf";

// Disable Saving
enableSaving [false, false];

// Wait until player is initialized
if (!isDedicated) then {waitUntil {!isNull player && isPlayer player};};

// INS Revive & SA: AI revive mod
if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};
[] execVM "INS_revive\revive_init.sqf";
[] execVM "SA\scripts\ins_ai_revive_init.sqf";
waitUntil {!isNil "INS_REV_FNCT_init_completed"};

// SA: Player Names & TeamSpeak Voice (Optional)
execVM "SA\scripts\sa_player_names.sqf";

// SA: Fatigue
execVM "SA\scripts\sa_fatigue.sqf";

if( isServer ) then {
	[STG_SERVER_START] spawn GameLoopLocal; 	
};

if( !isDedicated ) then {
	[STG_PLAYER_START] spawn GameLoopLocal; 
};

FUNC_callForExtract = {
	_target = [_this,0] call BIS_fnc_param;
	[group extract_heli, "extract_heli",getPos _target,"GET IN",true, true] call SA_fnc_moveHelicopter;
	[1,false] call SA_fnc_enableCommandRadioTask;
	[2,true] call SA_fnc_enableCommandRadioTask;
};

FUNC_moveSpawnPoint = {
	_target = [_this,0] call BIS_fnc_param;
	_spawnPos = getPos _target;
	_spawnDir = getDir _target;
	front setPos _spawnPos;
	front setDir _spawnDir;
};

FUNC_cancelExtract = {
	[group extract_heli, "extract_heli",getPos extract_heli_pad,"LAND",false, false] call SA_fnc_moveHelicopter;
	[1,true] call SA_fnc_enableCommandRadioTask;
	[2,false] call SA_fnc_enableCommandRadioTask;
};

// Command Radio
[markerPos "command_radio", [[1,"Call for Extract","FUNC_callForExtract",false],[2,"Cancel Extract","FUNC_cancelExtract",false],[3,"Move Spawn Point","FUNC_moveSpawnPoint",false]], false, 1] call SA_fnc_createCommandRadio;
