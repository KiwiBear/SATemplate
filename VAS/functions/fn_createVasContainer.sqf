/*
	File: fn_createVasContainer.sqf
	Author: Duda
	
	Description:
	Turns the specified object into a VAS container w/ action to open VAS
	
	Local effect only - must be executed on all clients
	
*/

private ["_vasContainer","_vasContainerMessage"];

_vasContainer = param [0, objNull];
_vasContainerMessage = param [1,"<t color='#ff1111'>Open Virtual Ammobox</t>"];
if(!isNull _vasContainer) then {
	_vasContainer addAction[_vasContainerMessage, {
		[_this select 1,_this select 0] call VAS_fnc_openVAS;
	}]; 
	[_vasContainer] call VAS_fnc_registerVasContainer;
};