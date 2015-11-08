/*
	@version: 1.3
	@file_name: fn_fetchPlayerGear.sqf
	@file_author: TAW_Tonic
	@file_edit: 7/9/2013
	@file_description: Retrieves players current gear and returns it.
*/
private["_ret","_curWep","_unitToConfigure"];
_ret = [];

_unitToConfigure = [] call VAS_fnc_getUnitToConfigure;

//Fetch Weapons
if(primaryWeapon _unitToConfigure != "") then {_ret set[count _ret,primaryWeapon _unitToConfigure];};
if(secondaryWeapon _unitToConfigure != "") then {_ret set[count _ret,secondaryWeapon _unitToConfigure];};
if(handgunWeapon _unitToConfigure != "") then {_ret set[count _ret,handgunWeapon _unitToConfigure];};

//Fetch Current Magazines
if(count (primaryWeaponMagazine _unitToConfigure) > 0) then
{
	{
		_ret set[count _ret,_x];
	} foreach (primaryWeaponMagazine _unitToConfigure);
};

if(count (secondaryWeaponMagazine _unitToConfigure) > 0) then
{
	{
		_ret set[count _ret,_x];
	} foreach (secondaryWeaponMagazine _unitToConfigure);
};

if(count (handgunMagazine _unitToConfigure) > 0) then
{
	{
		_ret set[count _ret,_x];
	} foreach (handgunMagazine _unitToConfigure);
};

//Hard code for Laser Desigantor batteries
_curWep = currentWeapon _unitToConfigure;

if("Laserdesignator" in assignedItems _unitToConfigure) then
{
	_unitToConfigure selectWeapon "Laserdesignator";
	if(currentMagazine _unitToConfigure != "") then {_ret set[count _ret,(currentMagazine _unitToConfigure)];};
};

_unitToConfigure selectWeapon _curWep;

//Fetch rest of misc information.
if(uniform _unitToConfigure != "") then 
{
	_ret set[count _ret, uniform _unitToConfigure]; //Get uniform
	{_ret set[count _ret,_x];} foreach (uniformItems _unitToConfigure); //Get uniform items
};	

if(vest _unitToConfigure != "") then 
{
	_ret set[count _ret, vest _unitToConfigure]; //Get vest
	{_ret set[count _ret,_x];} foreach (vestItems _unitToConfigure); //Get vest items
};

if(backpack _unitToConfigure != "") then 
{
	_ret set[count _ret,backpack _unitToConfigure]; //Get Backpack
	{_ret set[count _ret,_x];} foreach (backpackItems _unitToConfigure); //Get Backpack Items
};

if(count (assignedItems _unitToConfigure) > 0) then 
{
	{
		_ret set[count _ret,_x];
	} foreach (assignedItems _unitToConfigure);
};

if(headGear _unitToConfigure != "") then
{
	_ret set[count _ret,headGear _unitToConfigure];
};

if(goggles _unitToConfigure != "") then
{
	_ret set[count _ret, goggles _unitToConfigure];
};

//Fetch Primary weapon attachments
if(primaryWeapon _unitToConfigure != "") then
{
	{
		if(((primaryWeaponItems _unitToConfigure) select _x) != "") then
		{
			_ret set[count _ret,((primaryWeaponItems _unitToConfigure) select _x)];
		};
	} foreach [0,1,2];
};

if(handgunWeapon _unitToConfigure != "") then
{
	{
		if(((handgunItems _unitToConfigure) select _x) != "") then
		{
			_ret set[count _ret,((handgunItems _unitToConfigure) select _x)];
		};
	} foreach [0,1,2];
};

//Fetch secondary weapon attachments (placeholder)

_ret; //Return!