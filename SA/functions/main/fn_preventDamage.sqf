/*
	Author: [SA] Duda
	
	Description:
	Prevent damage to an object
	
	aL, eG
	
	Parameters:
		0: OBJECT - Object to allow or prevent damage (must be local to client)
		1: BOOL (OPTIONAL) - true = apply rule to local vehicle crew (if applicable), false = only apply rule to specified object (default false) 
		2: BOOL (OPTIONAL) - true = prevent damage, false = allow damage (default true) 
	
	Returns:
	Nothing
*/

private ["_object","_preventDamage","_applyToUnits"];
_object = [_this,0] call BIS_fnc_param;
_applyToUnits = [_this,1,false] call BIS_fnc_param;
_preventDamage = [_this,2,true] call BIS_fnc_param;
_object allowDamage not(_preventDamage);
if(_applyToUnits) then {
	{
		_x allowDamage not(_preventDamage);
	} forEach (crew _object);
};
