/*V1.2.3 Script By: Ghost attach selected vehicle to helicopter. Check ghst_slingattach.sqf for instructions.
*/

_heli = _this select 0;
_caller = _this select 1;
_id = _this select 2;

if (isnil "ghst_sling_veh") exitwith {hintsilent "No object to sling";};

_veh = ghst_sling_veh;

//if ((speed _heli < 40) and (speed _heli > -40) and (((getposatl _heli select 2) > 10) or ((surfaceIsWater getposasl _heli) and ((getposaslw _heli select 2) > 10)))) then {

_veh_name = getText (configFile >> "cfgVehicles" >> (typeof _veh) >> "displayName");

_veh allowdamage false;

if !(isnil "_id") then {
	_heli removeaction _id;
};
if !(isnil "ghst_slingload") then {
	_heli removeaction ghst_slingload;
};
if !(isnil "ghst_slingdetach") then {
	_heli removeaction ghst_slingdetach;
};
if !(isnil "ghst_slingcancel") then {
	_heli removeaction ghst_slingcancel;
};


slung = true;

if (_heli iskindof "Heli_Light_01_base_F") then {
_veh attachto [_heli,[0,0,-10]];
} else {
_veh attachto [_heli,[0,2,-10]];
};
hintsilent format ["%1 Slung", _veh_name];
	
ghst_slingdetach = _heli addAction ["<t size='1.5' shadow='2' color='#ff0000'>Release Vehicle</t>", "call ghst_fnc_slingdetach", [_veh,_veh_name], 5, true, true, "","alive _target and _this == driver _target and (speed _target < 40) and (speed _target > -40) and (((getposatl _target select 2) < 16 and (getposatl _target select 2) > 10) or ((surfaceIsWater getposasl _target) and ((getposaslw _target select 2) < 16 and (getposaslw _target select 2) > 10)))"];
	
while {alive _heli and slung} do {
	sleep 5;
	};
detach _veh;
_veh allowdamage true;
[] call BIS_fnc_PiP;
closeDialog 0;
deletevehicle ghst_sling_cameratarget;
/*
} else {
hintsilent "Altitude must be between 10-16 \nSpeed must be Under 40km/h";
};
*/