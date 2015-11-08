//V1.4.1 By: Ghost - spawns Commander to be killed
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_radarray","_menlist","_side","_locselname","_rnum","_eGrp","_mansel","_leader","_VarName","_veh_name","_tsk","_tasktopic","_taskdesc","_trig1stat","_trig1act","_trg1"];

_position_mark = _this select 0;//position to search buildings around
_radarray = _this select 1;//radius around position to search for buildings
_menlist = _this select 2;//type of units to spawn in array ["O_Story_Colonel_F","O_Story_CEO_F","O_officer_F"]
_locselname = _this select 3;//name of location
_side = _this select 4;//side of enemy

//create random number
_rnum = str(round (random 999));

//create Commander
_eGrp = createGroup _side;
_mansel = _menlist call BIS_fnc_selectRandom;
_leader = [[_position_mark select 0, _position_mark select 1, 0.2],_egrp,_mansel,0.8] call fnc_ghst_create_unit;
_leader setunitpos "UP";
_leader allowFleeing 0;
_VarName = ("ghst_Commander" + _rnum);
_leader setVehicleVarName _VarName;
//_leader Call Compile Format ["%1=_This ;",_VarName];
missionNamespace setVariable [_VarName,_leader];
publicVariable _VarName;
_veh_name = name _leader;

//Add custom gear
if (isnil (primaryWeapon _leader)) then {
	_leader addMagazine ["150Rnd_762x51_Box_Tracer",4];
	_leader addWeapon "LMG_Zafir_F";
	_leader selectWeapon "LMG_Zafir_F";
};


//send unit to random building
//null0 = [_position_mark,_radarray,[_leader],[false,"ColorGreen",false],[3,6,EAST],((paramsArray select 3)/10),false] execvm "scripts\objectives\ghst_PutinBuild.sqf";
ghst_Build_objs = ghst_Build_objs + [_leader];

//create task
_tsk = "tsk_Commander" + _rnum;
_tasktopic = format ["Kill Commander %1 in %2", _veh_name,_locselname];
_taskdesc = format ["Enemy Commander %1 is in %2 and he must be eliminated.", _veh_name,_locselname];
[_tsk,_tasktopic,_taskdesc,true,[],"created",_position_mark] call SHK_Taskmaster_add;

//create trigger for man dying
_trig1stat = format ["!(alive %1)",_leader];
_trig1act = format ["[""%1"",'succeeded'] call SHK_Taskmaster_upd; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _tsk];
_trg1 = createTrigger["EmptyDetector",_position_mark];
_trg1 setTriggerArea[0,0,0,false];
_trg1 setTriggerActivation["NONE","PRESENT",false];
_trg1 setTriggerStatements[_trig1stat,_trig1act, "deleteVehicle thistrigger;"];