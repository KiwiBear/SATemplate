//V2.4 Spawns mgs on top of random number of buildings of a certain type. Requires 1 EAST unit placed on map.
//Issues - units may hang over edges depending on which way they are aiming.
//ghst_roofmgs = [(getmarkerpos "marker"),1000(radius),[true,"ColorRed"],EAST,aiaccuracy] execvm "ghst_roofmgs.sqf";

if !((call SA_fnc_isAiServer)) exitwith {};

private ["_b","_s","_r","_m"];

_marker = _this select 0;
_rad = _this select 1;
_markunitsarray = _this select 2;
	_markunits = _markunitsarray select 0;
	_mcolor = _markunitsarray select 1;
_side = _this select 3;//side of static weapons
#define aiSkill _this select 4//sets AI accuracy

//Unit list to randomly select and spawn - Edit as needed
//#include "unit_list.sqf"
_menlist = ghst_menlist;
_gunlist = ghst_staticlist;

//Do not edit below this line unless you know what you are doing//
/////////////////////////////////////////////////////
//House list with coordinates
_Buildings = [["Land_i_Addon_03_V1_F",[0,3]],["Land_Unfinished_Building_02_F",[1,3,5,7]],["Land_CarService_F",[5]],["Land_WIP_F",[2,20,22]],["Land_Offices_01_V1_F",[27,29]],["Land_Hospital_side2_F",[2,3,4,5]]];//,["Land_Pier_F",[3,5,7,12,13,14]]

for "_b" from 0 to (floor(random count _Buildings)) do {
	_r =  floor(random count _Buildings);
	_buildsel = _Buildings select _r;
	_Buildings set [_r,-1];
	_Buildings = _Buildings - [-1];
	_nearBuildings = _marker nearObjects [(_buildsel select 0), _rad];
	_grp = createGroup _side;
		for "_s" from 0 to (count _nearBuildings / 10) do {
			private ["_r"];
			_r =  floor(random count _nearBuildings);
			_build = _nearBuildings select _r;
			_nearBuildings set [_r,-1];
			_nearBuildings = _nearBuildings - [-1];
				if (!isNil "_build") then {
					_buildposarray = (_buildsel select 1);
					_ranbuildpos = _buildposarray select (floor(random count _buildposarray));
					_buildpos = _build buildingpos _ranbuildpos;
					//Spawn MG at set random DIR
					_gunsel = _gunlist call BIS_fnc_selectRandom;
					_mgun = createVehicle [_gunsel, (_buildpos), [], 0, "NONE"];
					_mgun setdir (random 360);
					_mgun setposatl _buildpos;
					//spawn Unit for MG
					_mansel = _menlist call BIS_fnc_selectRandom;
					_mgman = [(getpos _build),_grp,_mansel,aiSkill] call fnc_ghst_create_unit;
					_mgman moveingunner _mgun;
					_mgman setFormDir (random 360);
						//put marker on spawned mg
						if (_markunits) then {
							_veh_name = getText (configFile >> "cfgVehicles" >> (_gunsel) >> "displayName");
							[(getposatl _mgman),_mcolor,_veh_name] call fnc_ghst_mark_point;
						};
				};
			//sleep 0.2;
		};
	//sleep 0.2;
};