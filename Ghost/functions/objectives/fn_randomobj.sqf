/*
V1.5 By: Ghost  
selects random obj to spawn. call ghst_fnc_randomobj;
*/
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_ghst_side","_ghst_patrol_air_list","_transport_heli_list","_attack_heli_list","_PARAM_AISkill","_PARAM_Tasks","_PARAM_Kavala","_loop","_locarray","_locselpos","_locselname","_area_size","_helo_area_size","_enemy_house","_enemy_patrols","_enemy_squadsize","_enemy_vehicles"];

//_sizex_inc = _this select 0;//size to increase objective area
//_sizey_inc = _this select 1;//size to increase objective area

if (count ghst_objarray == 0) exitwith {finish = true; publicvariable "finish"; diag_log format ["TASK LOCATIONS END %1", ghst_objarray];};

_ghst_side = ghst_side;
_PARAM_AISkill = "PARAM_AISkill" call BIS_fnc_getParamValue;

//diag_log format ["TASK LOCATIONS %1", ghst_objarray];

_loop = true;
_locarray = [];
While {_loop} do {
	private ["_idx","_locsel"];
	//Select one random location and spawn objective
	_idx = floor(random count ghst_objarray);
	_locsel = ghst_objarray select _idx;
	ghst_objarray set [_idx,-1];
	ghst_objarray = ghst_objarray - [-1];
	_locselname = text _locsel;//get name of location
	_locselpos = locationPosition _locsel;//get position of location
	//_locselsize = size _locsel;//get size of position

	//_loc_sizex = ((_locselsize select 0) * _sizex_inc);//multiply specified amount by x radius
	//_loc_sizey = ((_locselsize select 1) * _sizey_inc);//multiply specified amount by y radius
		if (!(isnil "_locselpos") and !(_locselname in ["Sagonisi"])) exitwith {
			_loop = false;
			_locarray = _locarray + [_locselpos];
		};
};

if (isnil "_locselpos") exitwith {finish = true; publicvariable "finish"; diag_log format ["TASK LOCATIONS END PAST LOOP %1", ghst_objarray];};
/*
//random boat patrol
if (round (random 10) > 5) then {
	[(getmarkerpos "center"),[15000,15000],3,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10)] call ghst_fnc_eboatspawn;
};
*/

_ghst_side = ghst_side;
_area_size = 600;
_helo_area_size = [800,800];
_enemy_house = [45,35];
_enemy_patrols = (3 + round(random 2));
_enemy_squadsize = (3 + round(random 3));
_enemy_vehicles = (3 + round(random 3));

if (count playableunits < 8) then {

	//_enemy_house = [30,20];
	_enemy_patrols = (2 + round(random 2));
	//_enemy_squadsize = (3 + round(random 3));
	_enemy_vehicles = (3 + round(random 2));

};

if ((_locselname == "Kavala") or (_locselname == "Aggelochori")) then {

	//_enemy_house = [50,40];
	//_enemy_patrols = (4 + round(random 2));
	//_enemy_squadsize = (3 + round(random 3));
	//_enemy_vehicles = (3 + round(random 3));

};

//external scripts to spawn enemy around objective
[_locselpos,_area_size,_ghst_side,_enemy_house,[false,"ColorRed"],(_PARAM_AISkill/10),false,false] call ghst_fnc_fillbuild;

[_locselpos,[_area_size,_area_size,(random 360)],_enemy_patrols,_enemy_patrols,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10),false] call ghst_fnc_espawn;

[_locselpos,_area_size,[false,"Colorblack"],_ghst_side,(_PARAM_AISkill/10)] call ghst_fnc_roofmgs2;

[_locselpos,[_area_size,_area_size],_enemy_vehicles,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10)] call ghst_fnc_evehsentryspawn;

//random enemy helo
if (round (random 10) > 5) then {
	_attack_heli_list = ghst_attack_heli_list;
	[_locselpos,_locselpos,_helo_area_size,300,1,[false,20],[false,"ColorRed"],_ghst_side,[_attack_heli_list]] spawn ghst_fnc_eair;
} else {
	//random enemy airplanes
	[_locselpos,_locselpos,[3000,3000],600,1,[false,15],[false,"ColorRed"]] spawn ghst_fnc_eair;
};

[_locselpos,800,18,true,false,WEST] call ghst_fnc_civcars;

[_locselpos,800,15,_ghst_side,[false,"ColorBlack"]] call ghst_fnc_mines;

[_locselpos,800,5,WEST,[false,"ColorRed"]] call ghst_fnc_ieds;

//random objective script
_PARAM_Tasks = "PARAM_Tasks" call BIS_fnc_getParamValue;
[_locarray,[_area_size,_area_size],_PARAM_Tasks,(getmarkerpos "pow_rescue"),_locselname] spawn ghst_fnc_randomobjectives;

//random island patrols and vehicle sentry
//_eveh_sentry_spawn1 = [(getmarkerpos "center"),[1000,2400,35],2,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10)] call ghst_fnc_eveh_sentry_spawn;

//_patrol1 = [(getmarkerpos "center"),[1000,2400,35],5,4,_ghst_side,[false,"ColorRed"],(_PARAM_AISkill/10),false] call ghst_fnc_espawn;

_PARAM_Kavala = "PARAM_Kavala" call BIS_fnc_getParamValue;
if (_PARAM_Kavala == 1) then {
	_transport_heli_list = ghst_transport_heli_list;
	[_locselpos,[_area_size,_area_size],_transport_heli_list,true,[false,"ColorRed"],(_PARAM_AISkill/10)] spawn ghst_fnc_eparadrop;
};