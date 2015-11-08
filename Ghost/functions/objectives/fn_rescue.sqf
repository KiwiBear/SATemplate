//V1.5.8 spawns a unit to be rescued
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_radarray","_campmark","_unit_type","_locselname","_wside","_rnum","_wGrp","_pow","_VarName","_veh_name","_tsk","_taskdesc","_trig2cond","_trig2act","_trg2"];

_position_mark = _this select 0;//position to search buildings around
_radarray = _this select 1;//radius around position to search for buildings
_campmark = _this select 2;//position where camp site is
_unit_type = _this select 3;//unit to be rescued "C_man_p_fugitive_F"
_locselname = _this select 4;//name of location

//create random number
_rnum = str(round (random 999));

//create unit to be rescued
//_wside =  (configFile >> "cfgvehicles" >> (_unit_type) >> "side") call bis_fnc_getcfgdata;
//if (_wside == 1) then {_wside = west;} else {_wside = civilian;};
_wGrp = createGroup CIVILIAN;//_wside;
_pow = [[_position_mark select 0, _position_mark select 1, 0.2],_wGrp,_unit_type,0.8] call fnc_ghst_create_unit;
_pow allowdamage false;
if !(isnil "AGM_Interaction_fnc_setCaptivityStatus") then {
	//FOR AGM Mod
	[_pow, "AGM_Handcuffed", true] call AGM_Interaction_fnc_setCaptivityStatus;
} else {
	_pow setCaptive true;
};
_VarName = ("ghst_pow" + _rnum);
_pow setVehicleVarName _VarName;
//_pow Call Compile Format ["%1=_This ;",_VarName];
missionNamespace setVariable [_VarName,_pow];
publicVariable _VarName;
_veh_name = name _pow;

removeAllAssignedItems _pow;
removeallweapons _pow;
removeHeadgear _pow;
removeBackpack _pow;
_pow setunitpos "UP";
_pow setBehaviour "Careless";
dostop _pow;
//_pow playActionNow "Surrender";
_pow playmove "amovpercmstpsnonwnondnon_amovpercmstpssurwnondnon";
_pow disableAI "MOVE";

//add save action
//[[_pow],"fnc_ghst_hostjoin",true,true] spawn BIS_fnc_MP;
[[_pow,["<t size='1.5' shadow='2' color='#2EFEF7'>Rescue Hostage</t>", "call ghst_fnc_hostjoin", [], 6, true, true, "","(alive _target)"]],"fnc_ghst_addaction",true,true] spawn BIS_fnc_MP;

//send unit to random building
//null0 = [_position_mark,_radarray,[_pow],[false,"ColorGreen",false],[3,6,EAST],((paramsArray select 3)/10),false] execvm "scripts\objectives\ghst_PutinBuild.sqf";
ghst_Build_objs = ghst_Build_objs + [_pow];

//create task
_tsk = "tsk_pow" + _rnum;
//create task
_taskdesc = format ["Rescue the POW %1. He is held up in one of the buildings or around %2. Once located bring him back to base.", _veh_name,_locselname];
[_tsk,format ["Rescue %1 in %2", _veh_name,_locselname], _taskdesc,true,[],"created",_position_mark] call SHK_Taskmaster_add;

/*
//create trigger for man dying
_trig1stat = format ["!(alive %1)", _pow];
_trig1act = format ["['%1','failed'] call SHK_Taskmaster_upd;", _tsk];
_trg1 = createTrigger["EmptyDetector",_position_mark];
_trg1 setTriggerArea[0,0,0,false];
_trg1 setTriggerActivation["NONE","PRESENT",false];
_trg1 setTriggerStatements[_trig1stat, _trig1act, "deleteVehicle thistrigger;"];
*/
//create trigger for save point
_trig2cond = "this and ((getposatl (thislist select 0)) select 2 < 1)";
_trig2act = format ["[%1] joinsilent grpNull; ['%2','succeeded'] call SHK_Taskmaster_upd; if (vehicle %1 != %1) then {unassignVehicle (%1); (%1) action ['EJECT', vehicle %1]; [%1] allowGetin false; dostop %1; %1 setCaptive true;}; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _pow, _tsk];
_trg2 = createTrigger["EmptyDetector", _campmark];
_trg2 setTriggerArea[10,10,0,false];
_trg2 setTriggerActivation["VEHICLE","PRESENT",false];
_trg2 triggerAttachVehicle [_pow];
_trg2 setTriggerStatements[_trig2cond, _trig2act, "deleteVehicle thistrigger;"];

[_pow,_tsk,_trg2] spawn {
	private ["_pow","_tsk","_trg2"];
	_pow = _this select 0;
	_tsk = _this select 1;
	_trg2 = _this select 2;
	
	while {true} do {
		if (triggerActivated _trg2) exitwith {deletevehicle _pow;};
		if (!(triggerActivated _trg2) and !(alive _pow)) exitwith {[_tsk,"failed"] call SHK_Taskmaster_upd; [[playableunits,0,-200],"fnc_ghst_addscore"] spawn BIS_fnc_MP; deletevehicle _pow; deleteVehicle _trg2;};
		sleep 5;
	};
};

