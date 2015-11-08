/*V1.2 Script By: Ghost cancels slingload. Check ghst_slingattach.sqf for instructions.
*/

_heli = _this select 0;
_caller = _this select 1;
_id = _this select 2;

if !(isnil "_id") then {
	_heli removeaction _id;
};
if !(isnil "ghst_slingload") then {
	_heli removeaction ghst_slingload;
};
if !(isnil "ghst_slingattach") then {
	_heli removeaction ghst_slingattach;
};
if !(isnil "ghst_slingdetach") then {
	_heli removeaction ghst_slingdetach;
};

slung = true;

hintsilent "Slingload Canceled";

ghst_slingload = _heli addAction ["<t size='1.5' shadow='2' color='#ffff00'>Slingload Vehicle</t>", "call ghst_fnc_slingload", [], 5, false, true, "","alive _target and _this == driver _target"];

[] call BIS_fnc_PiP;
closeDialog 0;
deletevehicle ghst_sling_cameratarget;