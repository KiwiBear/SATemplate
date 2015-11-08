/*
	Author: [SA] Duda
	
	Description:
	Removes night vision and adds a light (forced on)
	
	aG, eG
	
	Parameters:
		0: OBJECT - Unit
	
	Returns:
	Nothing
*/
private ["_unit"];
_unit = [_this,0] call BIS_fnc_param;
_unit unassignItem "NVGoggles"; 
_unit removeItem "NVGoggles";
_unit unassignItem "NVGoggles_OPFOR"; 
_unit removeItem "NVGoggles_OPFOR"; 
_unit unassignItem "NVGoggles_INDEP"; 
_unit removeItem "NVGoggles_INDEP"; 
_unit removePrimaryWeaponItem "acc_pointer_IR"; 
_unit addPrimaryWeaponItem "acc_flashlight";  
_unit enableGunLights "forceon";