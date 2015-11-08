/*
	File: fn_getUnitToConfigure.sqf
	Author: Duda
	
	Description:
	Get the unit whose gear is being configured via VAS. Typically will return player, but if you're
	configuring another unit's gear (e.g. AI unit) another unit will be returned
	
*/
missionNamespace getVariable ["VAS_unit_to_configure", player];