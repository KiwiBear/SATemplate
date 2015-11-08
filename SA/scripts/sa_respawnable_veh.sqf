private ["_veh","_includeAmmoBox","_initRespawn"];

_veh = [_this,0] call BIS_fnc_param;
_includeAmmoBox = [_this,1,true] call BIS_fnc_param;
_initRespawn = [_this,2,true] call BIS_fnc_param;

if(_includeAmmoBox) then {
	[_veh] call SA_fnc_makeVirtualAmmo;
};

if(_initRespawn) then {
	if(_includeAmmoBox) then {
		[_veh, 30, 0, 0, FALSE, FALSE, "[this, true, false] execVM ""SA\scripts\sa_respawnable_veh.sqf"""] execVM "SA\scripts\vehicle.sqf"; 
	} else {
		[_veh, 30, 0, 0, FALSE, FALSE, "[this, false, false] execVM ""SA\scripts\sa_respawnable_veh.sqf"""] execVM "SA\scripts\vehicle.sqf";
	};
};
