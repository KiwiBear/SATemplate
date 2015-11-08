/*
	Author: [SA] Duda

	Description:
	Drops an EMP from an air vehicle. When the EMP lands, all street lights within x distance will be turned off.

	Parameter(s):
	_this select 0: OBJECT - Air vehicle
	_this select 2: NUMBER (OPTIONAL) - Distance of EMP (default: 500 meters)
		
	Returns: 
	Nothing
*/

private ["_object","_distance","_pos","_cargo","_chute"];

_object = [_this,0] call BIS_fnc_param;
_distance = [_this,1,500] call BIS_fnc_param;
_pos = position _object;
_cargoPos = [_pos select 0, _pos select 1, (_pos select 2) - 5];
_cargo = createVehicle ["Land_WaterBarrel_F", _cargoPos, [], 0, "CAN_COLLIDE"];
_cargo setVelocity (velocity _object);
while { getPos _cargo distance getPos _object < 30 } do
{
	sleep 0.5;
};
_chute = createVehicle ["B_Parachute_02_F", getPos _cargo, [], 0, "CAN_COLLIDE"];
_cargo attachTo [_chute];

while { ((getPos _cargo) select 2) > 2 } do
{
	sleep 1;
};

[_cargo, "SA\sounds\emp.ogg", _distance * 2] call SA_fnc_play3dSound;

sleep 1;

{
	_x setHit ["light_1_hitpoint", 0.97];
	_x setHit ["light_2_hitpoint", 0.97];
	_x setHit ["light_3_hitpoint", 0.97];
	_x setHit ["light_4_hitpoint", 0.97];
} forEach nearestObjects [_cargo, [
	"Lamps_base_F",
	"PowerLines_base_F",
	"PowerLines_Small_base_F"
], _distance];

