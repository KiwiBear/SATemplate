call ghst_fnc_acquirelocations;
call ghst_fnc_unitlist;

private ["_mapSize","_mapCenter","_mapStart"];

_mapSize = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");
_mapCenter = (getmarkerpos "center");
_mapStart = [100,100];
if(floor(random 2) == 0) then {
	_mapStart set [0,_mapSize-100];
};
if(floor(random 2) == 0) then {
	_mapStart set [1,_mapSize-100];
};

[_mapStart,_mapCenter,[10000,10000],600,2,[true,15],[false,"ColorRed"]] spawn ghst_fnc_eair;

_PARAM_AISkill = "PARAM_AISkill" call BIS_fnc_getParamValue;
[[(position base),2000],[500,500],(4 + round(random 2)),[false,"ColorRed"],(_PARAM_AISkill/10)] spawn ghst_fnc_randespawn;

waituntil {! isnil "SHK_Taskmaster_Tasks"};

call ghst_fnc_randomobj;	