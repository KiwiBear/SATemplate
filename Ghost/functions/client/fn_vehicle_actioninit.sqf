//Automatically adds various actions to specified vehicles
private ["_PARAM_RAVLIFTER"];

ghst_sling_Array = [];
ghst_Supported_Vehicles_All = ["B_Heli_Light_01_F","B_Heli_Light_01_armed_F","O_Heli_Light_02_F","O_Heli_Light_02_unarmed_F","B_Heli_Transport_01_F","B_Heli_Transport_01_camo_F","I_Heli_Transport_02_F","
I_Heli_light_03_F","I_Heli_light_03_unarmed_F"];
ghst_boat_Array = [];
ghst_Supported_Vehicles_Boat = ["B_Boat_Transport_01_F","B_Lifeboat","B_Boat_Armed_01_minigun_F","I_Boat_Transport_01_F","I_Boat_Armed_01_minigun_F","O_Boat_Transport_01_F","O_Lifeboat","O_Boat_Armed_01_minigun_F"];
ghst_AmmoBoxes_Array = [];
ghst_Supported_AmmoBoxes = ["Box_NATO_AmmoVeh_F"];

//use ghst_slingload if raven lifter mod is not used
_PARAM_RAVLIFTER = "PARAM_RAVLIFTER" call BIS_fnc_getParamValue;

while {true} do 
{
	{
		if (!(_x in vehicles) and (_PARAM_RAVLIFTER == 0)) then
		{
			ghst_sling_Array = ghst_sling_Array - [_x];
		};
	} forEach (ghst_sling_Array);
	
	{
		if !(_x in vehicles) then
		{
			ghst_boat_Array = ghst_boat_Array - [_x];
		};
	} forEach (ghst_boat_Array);
	
	{
		if !(_x in vehicles) then
		{
			ghst_AmmoBoxes_Array = ghst_AmmoBoxes_Array - [_x];
		};
	} forEach (ghst_AmmoBoxes_Array);
	
	{
		if (((typeOf _x) in (ghst_Supported_Vehicles_All)) and (_PARAM_RAVLIFTER == 0) and !(_x in ghst_sling_Array)) then
		{
			ghst_sling_Array = ghst_sling_Array + [_x];
			_x addAction ["<t size='1.5' shadow='2' color=""#ffff00"">Slingload Vehicle</t>", "call ghst_fnc_slingload", [], 1, false, true, "","alive _target and _this == driver _target"];
		};
		if (((typeOf _x) in (ghst_Supported_Vehicles_Boat)) and !(_x in ghst_boat_Array)) then
		{
			ghst_boat_Array = ghst_boat_Array + [_x];
			_x addAction ["<t size='1.5' shadow='2' color=""#FF9900"">Push Boat</t>", "call ghst_fnc_BoatPush", [], 1, false, true, "", "_this distance _target < 8 and !(_this in _target)"];  
		};
		if (((typeOf _x) in (ghst_Supported_AmmoBoxes)) and !(_x in ghst_AmmoBoxes_Array)) then
		{
			ghst_AmmoBoxes_Array = ghst_AmmoBoxes_Array + [_x];
			_x addaction ["<t size='1.5' shadow='2' color='#ffffff'>Open Virtual Arsenal</t>", { ["Open",true] call BIS_fnc_arsenal; }, [], 1, false, true, "","alive _target"];
			_x addAction["<t size='1.5' shadow='2' color='#ffa200'>Virtual Ammobox</t>", "VAS\open.sqf", [], 1, false, true, "","alive _target"];
		};
		
	} forEach (vehicles);
	
	sleep 30;
	
};