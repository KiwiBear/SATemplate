#include "macro.sqf"
/*
	@version: 2.0
	@file_name: fn_saveGear.sqf
	@file_author: TAW_Tonic
	@file_edit: 9/24/2013
	@file_description: Save to profileNamespace in old VAS format
*/
private["_title","_slot","_primary,_launcher","_handgun","_magazines","_uniform","_vest","_backpack","_items","_primitems","_secitems","_handgunitems","_uitems","_vitems","_bitems","_curWep","_unitToConfigure"];
_title = ctrlText VAS_save_text;
_slot = lbCurSel VAS_save_list;
if(_slot == -1) exitWith {hint localize"STR_VAS_Prompt_slotSelFail"};

_unitToConfigure = [] call VAS_fnc_getUnitToConfigure;

//Old format / code
_primary = primaryWeapon _unitToConfigure;
_launcher = secondaryWeapon _unitToConfigure;
_handgun = handGunWeapon _unitToConfigure;
_magazines = [];
_uniform = uniform _unitToConfigure;
_vest = vest _unitToConfigure;
_backpack = backpack _unitToConfigure;
_items = assignedItems _unitToConfigure;
_primitems = primaryWeaponItems _unitToConfigure;
_secitems = secondaryWeaponItems _unitToConfigure;
_handgunitems = handGunItems _unitToConfigure;
_uitems = [];
_vitems = [];
_bitems = [];
if(_uniform != "") then {{_uitems set[count _uitems,_x];} foreach (uniformItems _unitToConfigure);};
if(_vest != "") then {{_vitems set[count _vitems,_x];} foreach (vestItems _unitToConfigure);};
if(_backpack != "") then {{_bitems set[count _bitems,_x];} foreach (backPackItems _unitToConfigure);};

if(goggles _unitToConfigure != "") then { _items set[count _items, goggles _unitToConfigure]; };
if(headgear _unitToConfigure != "") then { _items set[count _items, headgear _unitToConfigure]; };
if(count (primaryWeaponMagazine _unitToConfigure) > 0) then
{
	{
		_magazines set[count _magazines,_x];
	} foreach (primaryWeaponMagazine _unitToConfigure);
};

if(count (secondaryWeaponMagazine _unitToConfigure) > 0) then
{
	{
		_magazines set[count _magazines,_x];
	} foreach (secondaryWeaponMagazine _unitToConfigure);
};

if(count (handgunMagazine _unitToConfigure) > 0) then
{
	{
		_magazines set[count _magazines,_x];
	} foreach (handgunMagazine _unitToConfigure);
};

//Hard code for Laser Desigantor batteries
_curWep = currentWeapon _unitToConfigure;
if("Laserdesignator" in assignedItems _unitToConfigure) then
{
	_unitToConfigure selectWeapon "Laserdesignator";
	if(currentMagazine _unitToConfigure != "") then {_magazines set[count _magazines,(currentMagazine _unitToConfigure)];};
};

_unitToConfigure selectWeapon _curWep;

if(vas_disableLoadSave) then
{
	missionNamespace setVariable[format["vas_gear_new_%1",_slot],[_title,_primary,_launcher,_handgun,_magazines,_uniform,_vest,_backpack,_items,_primitems,_secitems,_handgunitems,_uitems,_vitems,_bitems]];
}
	else
{
	profileNameSpace setVariable[format["vas_gear_new_%1",_slot],[_title,_primary,_launcher,_handgun,_magazines,_uniform,_vest,_backpack,_items,_primitems,_secitems,_handgunitems,_uitems,_vitems,_bitems]];
	saveProfileNamespace;
};

[0,true] spawn VAS_fnc_SaveLoad;