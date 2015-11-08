//V1.3.1 spawns object in random building to be destroyed
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_rad","_objtype","_explodingobj","_locselname","_rnum","_obj","_VarName","_veh_name","_tsk","_tasktopic","_taskdesc","_trig1stat","_trig1act","_trg1"];

_position_mark = _this select 0;//position to search buildings around
_rad = _this select 1;//radius around position to search for buildings
_objtype = _this select 2;//object to spawn ("Box_East_Ammo_F")
_locselname = _this select 3;//name of location
_explodingobj = _this select 4;//creates explosion at object when destroyed (true/false)

//create random number
_rnum = str(round (random 999));

_obj = createVehicle [_objtype,[_position_mark select 0, _position_mark select 1, 0.2], [], 0, "NONE"];
_obj allowdamage false;
_veh_name = (configFile >> "cfgVehicles" >> (_objtype) >> "displayName") call bis_fnc_getcfgdata;
_VarName = ("ghst_obj" + _rnum);
_obj setVehicleVarName _VarName;
//_obj Call Compile Format ["%1=_This;",_VarName];
missionNamespace setVariable [_VarName,_obj];
publicVariable _VarName;

//create task
_tsk = "tsk_obj" + _rnum;
_tasktopic = format ["Locate and Destroy %1 in %2", _veh_name,_locselname];
_taskdesc = format ["Locate and destroy %1 found in a building in %2", _veh_name,_locselname];
[_tsk,_tasktopic,_taskdesc,true,[],"created",_position_mark] call SHK_Taskmaster_add;

//send object to random building
//null0 = [_position_mark,_rad,[_obj],[false,"ColorGreen",false],[3,6,EAST],((paramsArray select 3)/10),false] execvm "scripts\objectives\ghst_PutinBuild.sqf";
ghst_Build_objs = ghst_Build_objs + [_obj];

//create trigger for object being destroyed
_trig1stat = format ["!(alive %1)",_obj];
if (_explodingobj) then {
_trig1act = format ["deletevehicle %2; 'Bo_Mk82' createVehicle (getpos %2); [""%1"",'succeeded'] call SHK_Taskmaster_upd; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _tsk, _obj];
} else {
_trig1act = format ["deletevehicle %2; [""%1"",'succeeded'] call SHK_Taskmaster_upd; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _tsk, _obj];
};
_trg1 = createTrigger["EmptyDetector",_position_mark];
_trg1 setTriggerArea[0,0,0,false];
_trg1 setTriggerActivation["NONE","PRESENT",false];
_trg1 setTriggerStatements[_trig1stat,_trig1act, "deleteVehicle thistrigger;"];
