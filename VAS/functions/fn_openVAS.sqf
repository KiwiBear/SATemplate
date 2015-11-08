/*
	File: fn_openVAS.sqf
	Author: Duda
	
	Description:
	Main function to open the VAS menu. Actions can still rely on the open.sqf file, but this
	function allows you to easily open the menu via a script
	
*/

_this spawn {

	private ["_unitToConfigure","_vasContainer"];
	
	_unitToConfigure = param [0,player];
	_vasContainer = param [1,objNull];

	if(isNil "VAS_init_complete") exitWith {hint "VAS never initialized.\n\nThis means CfgFunctions.hpp was never called via Description.ext";};
	if(!VAS_init_complete && !vas_disableSafetyCheck) exitWith {if((time - VAS_init_timeOnStart) > 25) then {[] call VAS_fnc_mainInit;}; hint "VAS hasn't finished loading yet."};

	[_unitToConfigure] call VAS_fnc_setUnitToConfigure;
	
	//Set up some variables incase a 'limited' weapons/mags/items field is meant for that container (Mainly support for an upcoming feature).
	if(!isNull _vasContainer) then {
		VAS_box_weapons = _vasContainer getVariable "bis_weapons";
		VAS_box_magazines = _vasContainer getVariable "bis_magazines";
		VAS_box_items = _vasContainer getVariable "bis_items";
		VAS_box_backpacks = _vasContainer getVariable "bis_backpacks";
		VAS_box_goggles = _vasContainer getVariable "bis_goggles";
	};
	
	createDialog "VAS_Diag";
	["guns",false] spawn VAS_fnc_mainDisplay; 
	ctrlShow [2507,false];
	ctrlShow [2508,false];
	ctrlShow [2509,false];
	ctrlShow [2850,false];
	ctrlShow [2851,false];
	disableSerialization;

};