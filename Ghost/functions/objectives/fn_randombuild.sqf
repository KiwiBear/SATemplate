//V1.4 By: Ghost
//Selects random building type for destroy obj
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_rad","_objarray","_patrol_rad","_patrol_num","_patrol_group","_patrol_sqd","_sideguards","_enemyreinf_array","_enemyreinf","_enemyreinf_airtype","_rnum","_tsk","_menlist","_staticlist","_selbuild","_nearBuildings","_b","_objtype","_buildpos","_build_name","_eGrp","_g","_tasktopic","_taskdesc","_trig1stat","_trig1act","_trg1","_trig2cond","_trig2act","_trg2"];

_position_mark = _this select 0;//position for center pos
_rad = _this select 1;//radius around position to search for buildings
_objarray = _this select 2;//objects to place somewhere randomly e.g. "Land_TTowerBig_2_F"
_patrol_rad = _this select 3;//patrol max distance
_patrol_num = _this select 4;//patrol number [number of patrols, number in group]
	_patrol_group = _patrol_num select 0;//number of patrols
	_patrol_sqd = _patrol_num select 1;//number of units in each patrol
_sideguards = _this select 5;//side of enemy
#define aiSkill _this select 6//sets AI accuracy and aiming speed
_enemyreinf_array = _this select 7;//enemy reinforcements array.
	_enemyreinf = _enemyreinf_array select 0;//true to have enemy reinforcements come in.
	_enemyreinf_airtype = _enemyreinf_array select 1;//air type: 'O_Heli_Attack_02_F'


//create random number and add to task
_rnum = str(round (random 999));

_tsk = "ghst_build" + _rnum;

//Unit list to randomly select and spawn - Edit as needed
//#include "unit_list.sqf"
_menlist = ghst_menlist;
_staticlist = ghst_staticlist;

//_obj = _objarray call BIS_fnc_selectRandom;

//get all buildings around position of set radius
_nearBuildings = nearestObjects [(_position_mark), _objarray, _rad];

for "_b" from 0 to (count _nearBuildings)-1 do {
	private ["_idx"];
	_idx = floor(random count _nearBuildings);
	_selbuild = _nearBuildings select _idx;//select random building

	if (alive _selbuild) exitwith {};
		
	_nearBuildings set [_idx,-1];
	_nearBuildings = _nearBuildings - [-1];
	
};

if (isnil "_selbuild") exitwith {};//{diag_log "GHST_RANDOMBUILD NO BUILDINGS FOUND";};

_objtype = typeof _selbuild;

_buildpos = getposatl _selbuild;

_build_name = (configFile >> "cfgVehicles" >> (_objtype) >> "displayName") call bis_fnc_getcfgdata;

	//create units as guards
	_eGrp = createGroup _sideguards;
	for "_g" from 0 to ceil(random 5)+2 do {
		private ["_temppos","_mansel","_gp1","_unit1","_gunsel","_gun1"];
		_temppos = [_buildpos,[20,20,(random 360)]] call fnc_ghst_rand_position;
		_mansel = _menlist call BIS_fnc_selectRandom;
		_gp1 = _temppos findEmptyPosition[ 0 , 20 , _mansel ];
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
	
//create random patrols
[_buildpos,_patrol_rad,_patrol_group,_patrol_sqd,_sideguards,[false,"ColorRed"],aiSkill,false] call ghst_fnc_espawn;

//create task
_tasktopic = format ["Destroy %1", _build_name];
_taskdesc = format ["Locate %1 and blow it up.", _build_name];
[_tsk,_tasktopic,_taskdesc,true,[],"created",_buildpos] call SHK_Taskmaster_add;

//create trigger for build destruction
_trig1stat = format ["(damage (%1 nearestObject '%2')) >= 0.5",_buildpos,_objtype];
_trig1act = format ["(%2 nearestObject '%3') setdamage 1; [""%1"",'succeeded'] call SHK_Taskmaster_upd; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _tsk, _buildpos, _objtype];
_trg1 = createTrigger["EmptyDetector",_buildpos];
_trg1 setTriggerArea[_patrol_rad,0,false];
_trg1 setTriggerActivation["NONE","PRESENT",false];
_trg1 setTriggerStatements[_trig1stat,_trig1act, "deleteVehicle thistrigger;"];

	if (_enemyreinf) then {
		//create trigger for reinforcements
		_trig2cond = format ["%1", _sideguards];
		_trig2act = format ["[%1,%2,'%3',false,[false,'ColorRed'],%4] spawn ghst_fnc_eparadrop;", _buildpos, _patrol_rad, _enemyreinf_airtype, aiSkill];
		_trg2 = createTrigger["EmptyDetector",_buildpos];
		_trg2 setTriggerArea[(_patrol_rad select 0),(_patrol_rad select 1),0,false];
		_trg2 setTriggerActivation[_trig2cond,"PRESENT",false];
		_trg2 setTriggerStatements["count thislist < 8",_trig2act, "deleteVehicle thistrigger;"];
	};