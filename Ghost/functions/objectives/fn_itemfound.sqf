//removes addaction and deletes object and sets task to complete
//[[_intelobj,["<t size='1.5' shadow='2' color='#2EFEF7'>Grab Intel</t>", "call ghst_fnc_itemfound", _tsk, 6, true, true, "",""]],"fnc_ghst_addaction",true,true] spawn BIS_fnc_MP;
private ["_host","_caller","_id","_tsk"];

_host = _this select 0;
_caller = _this select 1;
_id = _this select 2;
_tsk = _this select 3;

_host removeaction _id;

deletevehicle _host;

_caller sidechat "I found intel";

[[_tsk],"fnc_ghst_tsk_complete",false,false] spawn BIS_fnc_MP;

[[[_caller],5000,100],"fnc_ghst_addscore"] spawn BIS_fnc_MP;