//V1.3.6 By: Ghost
//spawns object in a random location
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_radarray","_obj","_usenet","_locselname","_markunitsarray","_markunits","_mcolor","_msize","_sideguards","_rnum","_tsk","_menlist","_staticlist","_spawnpos","_temppos","_veh","_veh_name","_VarName","_vehpos","_vehnet","_pos","_mark1","_eGrp","_g","_tasktopic","_taskdesc","_trig1stat","_trig1act","_trg1"];

_position_mark = _this select 0;//position for center pos
_radarray = _this select 1;//radius around position to search for a position
_obj = _this select 2;//object to place somewhere randomly e.g. "O_MBT_02_arty_F"
_usenet = _this select 3;//true/false to use camo net over target
#define aiSkill _this select 4//sets AI accuracy
_locselname = _this select 5;//name of location
_markunitsarray = _this select 6;//put marker on map for task
	_markunits = _markunitsarray select 0;
	_mcolor = _markunitsarray select 1;
	_msize = _markunitsarray select 2;
_sideguards = _this select 7;//side of enemy

//create random number and add to task
_rnum = str(round (random 999));

_tsk = "ghst_randloc" + _rnum;

//Unit list to randomly select and spawn - Edit as needed
//#include "unit_list.sqf"
_menlist = ghst_menlist;
_staticlist = ghst_staticlist;

_spawnpos = [];
while {count _spawnpos < 2} do {
	_temppos = [_position_mark,[_radarray select 0, _radarray select 1, (random 360)]] call fnc_ghst_rand_position;
	_spawnpos = _temppos findEmptyPosition[ 10 , 100 , _obj ];
};

//create cache
_veh = createVehicle [_obj,_spawnpos, [], 0, "NONE"];
_veh lock true;
_veh_name = (configFile >> "cfgVehicles" >> (_obj) >> "displayName") call bis_fnc_getcfgdata;
//_veh_pic =  (configFile >> "cfgvehicles" >> (_obj) >> "picture") call bis_fnc_getcfgdata;
_VarName = ("ghst_" + _obj + _rnum);
_veh setVehicleVarName _VarName;
//_veh Call Compile Format ["%1=_This ;",_VarName];
missionNamespace setVariable [_VarName,_veh];
publicVariable _VarName;
_vehpos = (getposatl _veh);
_veh setdir (random 360);
_veh setposatl _vehpos;

//spawn camo net over cache
	if (_usenet) then {
		_vehnet = createVehicle ["CamoNet_OPFOR_big_F",_vehpos, [], 0, "CAN_COLLIDE"];
		_vehnet allowdamage false;
		_vehnet setdir (getdir _veh) - 180;
		_vehnet setposatl _vehpos;
		_vehnet setVectorUP (surfaceNormal [_vehpos select 0,_vehpos select 1]);
		_vehnet allowdamage true;
	};
	
	//create markers for units
	if (_markunits) then {
		_pos = [_vehpos,[_msize select 0,_msize select 1,(random 360)]] call fnc_ghst_rand_position;
		_mark1 = [_pos,_mcolor,"","",_msize,"Ellipse","Border"] call fnc_ghst_mark_point;
			
		_nul = [_veh,_mark1] spawn {
			private ["_unit","_mark1"];
			_unit = _this select 0;
			_mark1 = _this select 1;
			
			while {alive _unit} do {
				sleep 5;
			};
			
			deletemarker _mark1;
		
		};
	};

	//create units as guards
	_eGrp = createGroup _sideguards;
	for "_g" from 0 to ceil(random 5)+2 do {
		private ["_temppos","_mansel","_gp1","_unit1","_gun1"];
		_temppos = [_vehpos,[15,15,(random 360)]] call fnc_ghst_rand_position;
		_mansel = _menlist call BIS_fnc_selectRandom;
		_gp1 = _temppos findEmptyPosition[ 0 , 15 , _mansel ];
		_unit1 = [_gp1,_egrp,_mansel,aiSkill] call fnc_ghst_create_unit;
			if ((round (random 10)) > 7) then {
				_gunsel = _staticlist call BIS_fnc_selectRandom;
				_gun1 = createVehicle [_gunsel,_gp1, [], 0, "NONE"];
				_unit1 assignasgunner _gun1;
				_unit1 moveingunner _gun1;
			};
		_unit1 setpos _gp1;
		_unit1 setFormDir (random 359);
		_unit1 setUnitPos "UP";
		dostop _unit1;
		sleep 0.03;
	};
	
	

//create task
_tasktopic = format ["Destroy %1 in %2", _veh_name,_locselname];
//_taskdesc = format ["Locate the enemy %1 in %2 and blow it up. <br/><img image='%3' widwidth='64' height='64'/>", _veh_name,_locselname,_veh_pic];
_taskdesc = format ["Locate the enemy %1 in %2 and blow it up.", _veh_name,_locselname];
//["tsk_cache","Destroy Cache","Locate the enemy cache and blow it up.",true,[],"created",_position_mark] call SHK_Taskmaster_add;
[_tsk,_tasktopic,_taskdesc,true,[],"created",_pos] call SHK_Taskmaster_add;

//create trigger for cache destruction
//_trig1stat = format ["!(alive %1)",_veh];
_trig1stat = format ["damage %1 > 0.6",_veh];
//_trig1act = format ["[""%1"",'succeeded'] call SHK_Taskmaster_upd;", _tsk];
_trig1act = format ["%2 setdamage 1; [""%1"",'succeeded'] call SHK_Taskmaster_upd; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _tsk, _veh];
_trg1 = createTrigger["EmptyDetector",_pos];
_trg1 setTriggerArea[_radarray,0,false];
_trg1 setTriggerActivation["NONE","PRESENT",false];
_trg1 setTriggerStatements[_trig1stat,_trig1act, "deleteVehicle thistrigger;"];