/*
	@version: 1.7
	@file_name: fn_fetchCfgDetails.sqf
	@file_author: TAW_Tonic
	@file_edit: 8/2/2013
	@file_description: Fetch information about the entities config
	
	USAGE:
	[Classname,Cfg* (Optional)] call VAS_fnc_fetchCfgDetails;
	
	Return:
	0: classname
	1: displayname
	2: picture
	3: scope
	4: type
	5: itemInfo Type (if any, -1 means none)
	6: Cfg Location i.e CfgWeapons
	7: Magazines
	8: Muzzles
	9: Short Description
	10: acc_Pointers
	11: acc_Optics
	12: acc_Muzzles
	13: Base (Superclass)
	14: New compatibleItems Structure
	15: Some bullshit
	16: Under Barrel Items
*/
private["_entity","_cfg","_ret","_type","_acc_u","_acc_p","_acc_o","_slotclasses","_acc_m","_scope","_displayName","_picture","_config","_itemInfo","_muzzles","_magazines","_desc","_base","_AGMItem"];
_entity = [_this,0,"",[""]] call BIS_fnc_param;
_type = -1;
_acc_p = [];
_acc_o = [];
_acc_m = [];
_acc_u = [];
_slotclasses = [];
_scope = 0;
_itemInfo = -1;
_muzzles = [];
_magazines = [];
_AGMItem = false;
if(_entity == "") exitWith {[]};
_cfg = if(isNil {_this select 1}) then
{
	switch (true) do
	{
		case (isClass (configFile >> "CfgMagazines" >> _entity)) : {"CfgMagazines";};
		case (isClass (configFile >> "CfgWeapons" >> _entity)) : {"CfgWeapons";};
		case (isClass (configFile >> "CfgVehicles" >> _entity)) : {"CfgVehicles";};
		case (isClass (configFile >> "CfgGlasses" >> _entity)) : {"CfgGlasses";};
	};
}
	else
{
	_this select 1
};

//Final Check

_ret = [];
if(typeName _cfg != "STRING") exitWith {[]}; //Not a config
if(!isClass (configFile >> _cfg >> _entity)) exitWith {[]};
if(_cfg == "") exitWith {[]}; //Not a config, who is passing bad data?

_config = configFile >> _cfg >> _entity;
_displayName = getText(_config >> "displayName");
_picture = getText(_config >> "picture");
_desc = getText(_config >> "descriptionshort");
_base = inheritsFrom _config;

switch (_cfg) do
{
	case "CfgVehicles":
	{
		_type = getText(_config >> "vehicleClass");
		_scope = getNumber(_config >> "scope");
	};
	
	case "CfgWeapons":
	{
		_scope = getNumber(_config >> "scope");
		_type = getNumber(_config >> "type");
		_desc = getText(_config >> "descriptionshort");
		if(isClass (_config >> "Armory")) then {_AGMItem = true;};
		
		//Compatible attachments
		if(isClass (_config >> "WeaponSlotsInfo")) then {
			
			/*
				This part detects whether or not it is vanilla config structure or class structure.
				
				Pointers
			*/
			if(isArray (_config >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems")) then {
				_acc_p = getArray(_config >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems");
			} else {
				if(isClass (_config >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems")) then {
					{
						if(getNumber _x > 0 && {!((configName _x) in _acc_p)}) then {_acc_p pushBack configName _x;};
					} foreach configProperties [(_config >> "WeaponSlotsInfo" >> "PointerSlot" >> "compatibleItems"), "isNumber _x"];
				};
			};
			//Optics
			if(isArray (_config >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems")) then {
				_acc_o = getArray(_config >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems");
			} else {
				if(isClass (_config >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems")) then {
					{
						if(getNumber _x > 0 && {!((configName _x) in _acc_o)}) then {_acc_o pushBack configName _x;};
					} foreach configProperties [(_config >> "WeaponSlotsInfo" >> "CowsSlot" >> "compatibleItems"), "isNumber _x"];
				};
			};
			//Muzzles
			if(isArray (_config >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems")) then {
				_acc_m = getArray(_config >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems");
			} else {
				if(isClass (_config >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems")) then {
					{
						if(getNumber _x > 0 && {!((configName _x) in _acc_m)}) then {_acc_m pushBack configName _x;};
					} foreach configProperties [(_config >> "WeaponSlotsInfo" >> "MuzzleSlot" >> "compatibleItems"), "isNumber _x"];
				};
			};
			//UnderBarrel / Bipods
			if(isClass (_config >> "WeaponSlotsInfo" >> "UnderBarrelSlot")) then {
				if(isArray (_config >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems")) then {
					_acc_u = getArray(_config >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems");
				} else {
					if(isClass (_config >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems")) then {
						{
							if(getNumber _x > 0 && {!((configName _x) in _acc_u)}) then {_acc_u pushBack configName _x;};
						} foreach configProperties [(_config >> "WeaponSlotsInfo" >> "UnderBarrelSlot" >> "compatibleItems"), "isNumber _x"];
					};
				};
			};
		};
		
		if(isClass (_config >> "ItemInfo")) then {
			_itemInfo = getNumber(_config >> "ItemInfo" >> "Type");
		};
		
		_muzzles = getArray(_config >> "muzzles");
		_magazines = getArray(_config >> "magazines");
		if(!isNil {_muzzles}) then {
			private["_tmp"];
		//	_base = inheritsFrom (configFile >> "CfgWeapons" >> _entity);
			{
				if(_x != "this") then
				{
					_tmp = getArray(_base >> _x >> "magazines");
					{
						_magazines set[count _magazines, _x];
					} foreach (_tmp);
				};
			} foreach _muzzles;
		};
	};
	
	case "CfgMagazines":
	{
		_scope = getNumber(_config >> "scope");
	};
};

_ret = [_entity,_displayName,_picture,_scope,_type,_itemInfo,_cfg,_magazines,_muzzles,_desc,_acc_p,_acc_o,_acc_m,_base,_slotclasses,_AGMItem,_acc_u];
_ret;