/*
	File: fn_registerVasContainer.sqf
	Author: Duda
	
	Description:
	Registers a VAS container so that it can be referenced later. The registered VAS containers 
	are used to detect when you're near a container (which lets you configure your group's units using VAS)
	
	Local effect only - must be executed on all clients
	
*/

private ["_vasContainer","_vasContainers"];
_vasContainer = param [0, objNull];
_vasContainers = missionNamespace getVariable ["VAS_registeredContainers",[]];
if(!isNull _vasContainer) then {
	_vasContainers pushBack _vasContainer;
	missionNamespace setVariable ["VAS_registeredContainers", _vasContainers];
};