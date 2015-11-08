/*
V1 By: Ghost  
selects random side obj to spawn. ghst_sideobj = [] call ghst_fnc_sideobj;
*/
if !((call SA_fnc_isAiServer)) exitwith {};
private ["_ghst_side","_ghst_patrol_air_list","_transport_heli_list","_PARAM_AISkill","_rand_num","_locselpos","_locselname","_area_size","_area_size2","_enemy_house","_enemy_patrols","_enemy_squadsize","_enemy_vehicles","_mark1"];

_ghst_side = ghst_side;
_ghst_patrol_air_list = ghst_patrol_air_list;
_transport_heli_list = ghst_transport_heli_list;
_PARAM_AISkill = "PARAM_AISkill" call BIS_fnc_getParamValue;

_ghst_side = ghst_side;
_area_size = 300;
_area_size2 = 500;
_enemy_house = [30,15];
_enemy_patrols = (2 + round(random 2));
_enemy_squadsize = (3 + round(random 3));
_enemy_vehicles = (2 + round(random 2));

_rand_num = round (random 10);

if ((_rand_num > 5) and (count ghst_milarray > 0)) then {
	private ["_idx","_locsel","_buildarray"];
	//Select one random location and spawn objective
	_idx = floor(random count ghst_milarray);
	_locsel = ghst_milarray select _idx;
	ghst_milarray set [_idx,-1];
	ghst_milarray = ghst_milarray - [-1];
	_locselpos = _locsel select 0;//get position of location
	_locselname = _locsel select 1;//get name of location

	[_locselpos,_area_size,_ghst_side,_enemy_house,[false,"ColorRed"],(_PARAM_AISkill/10),false,false] call ghst_fnc_fillbuild;

	//external scripts to spawn enemy around objective
	[_locselpos,[_area_size,_area_size,(random 360)],_enemy_patrols,_enemy_patrols,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10),false] call ghst_fnc_espawn;

	[_locselpos,_area_size,[false,"Colorblack"],_ghst_side,(_PARAM_AISkill/10)] call ghst_fnc_roofmgs;

	[_locselpos,[_area_size,_area_size],_enemy_vehicles,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10)] call ghst_fnc_evehsentryspawn;

	[_locselpos,_area_size2,8,true,false,WEST] call ghst_fnc_civcars;

	[_locselpos,_area_size2,8,_ghst_side,[false,"ColorBlack"]] call ghst_fnc_mines;

	[_locselpos,_area_size2,2,WEST,[false,"ColorRed"]] call ghst_fnc_ieds;

	//Clear Area task
	[_locselpos,[_area_size,_area_size],_locselname,_ghst_side] call ghst_fnc_clear;

	//check for towers around objective area and if so spawn task
	_buildarray = ["Land_TTowerBig_2_F","Land_TTowerBig_1_F","Land_Communication_F","Land_TTowerSmall_1_F"];
	[_locselpos,_area_size2,_buildarray,[200,200],[_enemy_patrols,_enemy_squadsize],_ghst_side,(_PARAM_AISkill/10),[true, _transport_heli_list]] call ghst_fnc_randombuild;
	
	//Create objective area marker
	_mark1 = [_locselpos,"ColorRed","","",[_area_size,_area_size],"Ellipse","Border"] call fnc_ghst_mark_point;

};

if ((_rand_num < 5) and (count ghst_marinearray > 0)) then {
	private ["_idx","_locsel","_wreckarea_size","_wreckarray"];
	//Select one random marine location and spawn objective
	_idx = floor(random count ghst_marinearray);
	_locsel = ghst_marinearray select _idx;
	ghst_marinearray set [_idx,-1];
	ghst_marinearray = ghst_marinearray - [-1];
	_locselname = text _locsel;//get name of location
	_locselpos = locationPosition _locsel;//get position of location
	
	_wreckarea_size = 150;
	_wreckarray = ["Land_UWreck_FishingBoat_F","Land_Wreck_Traw2_F","Land_Wreck_Traw_F","Land_UWreck_MV22_F","Land_UWreck_Heli_Attack_02_F"];//"Land_UWreck_FishingBoat_F","Land_Wreck_Traw2_F","Land_Wreck_Traw_F","Land_UWreck_MV22_F","Land_UWreck_Heli_Attack_02_F"
	//"UWreck_base_F"
	[_locselpos,_wreckarea_size,_wreckarray,[_area_size,_area_size],[4,4],_locselname,_ghst_side,(_PARAM_AISkill/10)] call ghst_fnc_randomwreck;
	
	//Create objective area marker
	_mark1 = [_locselpos,"ColorRed","","",[_wreckarea_size,_wreckarea_size],"Ellipse","Border"] call fnc_ghst_mark_point;

};

if (isnil "_locselpos") exitwith {[[1,1,0],1] call fnc_ghst_full_cleanup;};

[_locselpos,_mark1] spawn {
	private ["_locselpos","_mark1","_curtasks"];
	_locselpos = _this select 0;
	_mark1 = _this select 1;

	//sleep 60;
	//check for all tasks complete and activate end variable.
	_curtasks = [];
	{_curtasks = _curtasks + [(_x select 0)];} foreach SHK_Taskmaster_Tasks;
	
	[(_curtasks select (count _curtasks)-1),"SHK_Taskmaster_setCurrentLocal"] call BIS_fnc_MP;

	While {true} do {
		{if (_x call SHK_Taskmaster_isCompleted) then {_curtasks = _curtasks - [_x];};} foreach _curtasks;
		if (count _curtasks == 0) exitwith {deletemarker _mark1; [_locselpos,1000] call fnc_ghst_full_cleanup;};
		if (count alldead > 30) then {call fnc_ghst_cleanup;};
		sleep 10;
	};
};