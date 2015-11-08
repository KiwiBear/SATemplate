//V1.2.3 - By Ghost modified
//Randomly selects and generates objectives. Requires funciton module.

if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_array","_radarray","_numobjs","_campmark","_locselname","_objlist","_commanderlist","_transport_heli_list","_ammobox_list","_ghst_side","_PARAM_AISkill","_o","_random_pos","_buildarray","_curtasks"];

//check to see if there are multiple positions

_position_array = _this select 0;//center position for objectives
_radarray = _this select 1;//radius around center position e.g. [30,40]
_numobjs = _this select 2;//number of random objectives
_campmark = _this select 3;//location where camp site is
_locselname = _this select 4;//name of location

//list of objectives
_objlist = ["leader","rescue","ARTY","ammo","intel","ZSU_AA2","leader2","intel2","rescue2","ZSU_AA","ammo2","intel3","leader3","ammo3","Bombtruck","leader4","ARTY2"];
//["leader","rescue","ARTY","ammo","intel","crash","ZSU_AA2","comtower","leader2","intel2","rescue2","ZSU_AA","tower","ammo2","intel3","leader3","ammo3","Bombtruck","leader4","ARTY2"];

_commanderlist = ghst_commanderlist;
_transport_heli_list = ghst_transport_heli_list;
_ammobox_list = ghst_ammobox_list;
_ghst_side = ghst_side;
_PARAM_AISkill = "PARAM_AISkill" call BIS_fnc_getParamValue;

//empty array for objects to be put into for script later on
ghst_Build_objs = [];

//select specified number of random objectives
for "_o" from 1 to (_numobjs) do {
	private ["_idx","_r","_objsel","_idx"];
	//select a position
		_idx = floor(random count _position_array);
		_random_pos = _position_array select _idx;
		//_position_array set [_idx,-1];
		//_position_array = _position_array - [-1];

	//select random objective from list
	_r =  floor(random count _objlist);
	_objsel = _objlist select _r;
	//_objsel = _objlist call BIS_fnc_selectRandom;
	_objlist = _objlist - [_objsel];
	switch (_objsel) do
		{   
			case "leader":
			{
			[_random_pos,_radarray,_commanderlist,_locselname,_ghst_side] call ghst_fnc_assassinate;
			};
			case "leader2":
			{
			[_random_pos,_radarray,_commanderlist,_locselname,_ghst_side] call ghst_fnc_assassinate;
			};
			case "leader3":
			{
			[_random_pos,_radarray,_commanderlist,_locselname,_ghst_side] call ghst_fnc_assassinate;
			};
			case "leader4":
			{
			[_random_pos,_radarray,_commanderlist,_locselname,_ghst_side] call ghst_fnc_assassinate;
			};
			case "intel":
			{
			[_random_pos,_radarray,_locselname] call ghst_fnc_intel;
			};
			case "intel2":
			{
			[_random_pos,_radarray,_locselname] call ghst_fnc_intel;
			};
			case "intel3":
			{
			[_random_pos,_radarray,_locselname] call ghst_fnc_intel;
			};
			//not used
			case "clear":
			{
			[_random_pos,_radarray,_locselname,_ghst_side] call ghst_fnc_clear;
			};
			case "rescue":
			{
			private ["_powarray","_powsel"];
			_powarray = ["C_scientist_F","B_Helipilot_F","B_officer_F","B_Pilot_F"];//"C_scientist_F","B_Helipilot_F","B_officer_F"
			_powsel = _powarray call BIS_fnc_selectRandom;
			[_random_pos,_radarray,_campmark,_powsel,_locselname] call ghst_fnc_rescue;
			};
			case "rescue2":
			{
			private ["_powarray","_powsel"];
			_powarray = ["C_journalist_F","B_Helipilot_F","B_officer_F","B_Pilot_F"];//"C_journalist_F","B_Helipilot_F","B_officer_F"
			_powsel = _powarray call BIS_fnc_selectRandom;
			[_random_pos,_radarray,_campmark,_powsel,_locselname] call ghst_fnc_rescue;
			};
			case "crash":
			{
			private ["_crasharray","_crashsel"];
			_crasharray = ["Land_Wreck_Heli_Attack_01_F","Land_Wreck_Plane_Transport_01_F"];
			_crashsel = _crasharray call BIS_fnc_selectRandom;
			[_random_pos,_radarray,_crashsel,[15,15],(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomcrash;
			};
			case "tower":
			{
			private ["_buildarray"];
			_buildarray = ["Land_TTowerBig_2_F","Land_TTowerBig_1_F","Land_Communication_F","Land_TTowerSmall_1_F"];
			[_random_pos,1000,_buildarray,[200,200],[2,3],_ghst_side,(_PARAM_AISkill/10),[true, _transport_heli_list]] spawn ghst_fnc_randombuild;
			};
			case "ammo":
			{
			[_random_pos,_radarray,_ammobox_list,_locselname,true] call ghst_fnc_objinbuild;
			};
			case "ammo2":
			{
			[_random_pos,_radarray,_ammobox_list,_locselname,true] call ghst_fnc_objinbuild;
			};
			case "ammo3":
			{
			[_random_pos,_radarray,_ammobox_list,_locselname,true] call ghst_fnc_objinbuild;
			};
			//not used
			case "seawreck":
			{
			private ["_wreckarray"];
			_wreckarray = ["Land_UWreck_FishingBoat_F","Land_Wreck_Traw2_F","Land_Wreck_Traw_F","Land_UWreck_MV22_F","Land_UWreck_Heli_Attack_02_F"];//"Land_UWreck_FishingBoat_F","Land_Wreck_Traw2_F","Land_Wreck_Traw_F","Land_UWreck_MV22_F","Land_UWreck_Heli_Attack_02_F"
			//"UWreck_base_F"
			[(getmarkerpos "center"),11000,_wreckarray,[100,100],[3,2],_ghst_side,(_PARAM_AISkill/10)] call ghst_fnc_randomwreck;
			};
			case "ZSU_AA":
			{
			[_random_pos,_radarray,"O_APC_Tracked_02_AA_F",true,(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomloc;
			};
			case "ZSU_AA2":
			{
			[_random_pos,_radarray,"O_APC_Tracked_02_AA_F",true,(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomloc;
			};
			case "ARTY":
			{
			[_random_pos,_radarray,"O_MBT_02_arty_F",true,(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomloc;
			};
			case "ARTY2":
			{
			[_random_pos,_radarray,"O_MBT_02_arty_F",true,(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomloc;
			};
			case "comtower":
			{
			private ["_towers","_towersel"];
			_towers = ["Land_Communication_F","Land_TTowerSmall_1_F"];
			_towersel = _towers call BIS_fnc_selectRandom;
			[_random_pos,_radarray,_towersel,true,(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomloc;
			};
			case "Bombtruck":
			{
			private ["_devices","_devicesel"];
			_devices = ["O_Truck_03_device_F","Land_Device_assembled_F","Land_Device_disassembled_F"];
			_devicesel = _devices call BIS_fnc_selectRandom;
			[_random_pos,_radarray,_devicesel,true,(_PARAM_AISkill/10),_locselname,[true,"ColorRed",[200,200]],_ghst_side] call ghst_fnc_randomloc;
			};
		};
	sleep 3;
};

//check for towers around objective area and if so spawn task
_buildarray = ["Land_TTowerBig_2_F","Land_TTowerBig_1_F","Land_Communication_F","Land_TTowerSmall_2_F","Land_dp_transformer_F","Land_TTowerSmall_1_F"];
[_random_pos,1000,_buildarray,[200,200],[2,3],_ghst_side,(_PARAM_AISkill/10),[true, _transport_heli_list]] call ghst_fnc_randombuild;

sleep 5;
//send all objects to buildings that are in array ghst_Build_objs
[_random_pos,_radarray,ghst_Build_objs,[true,"ColorRed",[50,50]],[3,7,_ghst_side],(_PARAM_AISkill/10),false] spawn ghst_fnc_PutinBuild;

//sleep 60;
//check for all tasks complete and activate end variable.
_curtasks = [];
{_curtasks = _curtasks + [(_x select 0)];} foreach SHK_Taskmaster_Tasks;

if !((_curtasks select (count _curtasks)-1) call SHK_Taskmaster_isCompleted) then {
	[(_curtasks select (count _curtasks)-1),"SHK_Taskmaster_setCurrentLocal"] call BIS_fnc_MP;
};

While {true} do {
	private ["_randnum"];
	{if (_x call SHK_Taskmaster_isCompleted) then {_curtasks = _curtasks - [_x];};} foreach _curtasks;
	if (count _curtasks == 0) exitwith {[_random_pos,1000] spawn fnc_ghst_full_cleanup;};
	if (count alldead > 50) then {call fnc_ghst_cleanup;};
	_randnum = (random 10);
	sleep 10;
	if ((_ghst_side countSide allunits < 35) and (_randnum > 8) and (count _curtasks > 0)) then {[_random_pos,_radarray,_transport_heli_list,false,[false,"ColorRed"],(_PARAM_AISkill/10)] spawn ghst_fnc_eparadrop;
	};
	if ((_ghst_side countSide allunits < 35) and (_randnum < 4) and (count _curtasks > 0)) then {[_random_pos,[2000,2000],(_radarray select 0),(1 + (ROUND (random 2))),[false,"ColorRed"],(_PARAM_AISkill/10)] spawn ghst_fnc_ecounter;
	};
	sleep 10;
};