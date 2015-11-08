/*
	File: fn_setUnitToConfigure.sqf
	Author: Duda
	
	Description:
	Set the unit whose gear is being configured via VAS. Used when the unit being configured 
	is different than the player (e.g. configuring gear for AI unit)
	
*/
private ["_unit"];
_unit = param [0,player];
missionNamespace setVariable ["VAS_unit_to_configure", _unit];