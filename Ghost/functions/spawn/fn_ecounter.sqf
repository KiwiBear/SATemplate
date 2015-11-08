/*V3.5.3 by: Ghost - create enemy convoy for a counter offensive.
ghst_ecounter = [pos,{radius array],spawn radius,enemynum,[markwaypoints(true\false),"ColorRed"],aiskill]  execvm "scripts\ghst_ecounter.sqf";

ex: ghst_ecounter = [[1,2,3],[100,100],10,6,[true,"ColorRed"],0.5]  execvm "scripts\ghst_ecounter.sqf";
*/
if (!(call SA_fnc_isAiServer)) exitwith {};

_position_mark = _this select 0;//objective position
_radarray = _this select 1;//distance from marker center to spawn
	_radx = _radarray select 0;
	_rady = _radarray select 1;
_rad = _this select 2;//radius around marker center for unload point
_enum = _this select 3;//number of vehicles to spawn
_markunitsarray = _this select 4;//markwaypoints
	_markwps = _markunitsarray select 0;
	_mcolor = _markunitsarray select 1;
#define aiSkill _this select 5//sets AI accuracy


{deleteGroup _x} foreach allGroups;

//Enemy vehicle and unit list
//#include "unit_list.sqf"
_menlist = ghst_menlist;
_vehlist = ghst_convoyvehlist;
_ghst_side = ghst_side;
//do not edit this section - Spawns the cars
//
//
//find spawn point outside of objective zone
private ["_loop","_roadssel","_roads","_wpstart"];
_loop = true;
	while {_loop} do {
		_startpos = [(_position_mark select 0) + _radx * sin(random 360),(_position_mark select 1) + _rady * cos(random 360)];
		_roads = (_startpos nearRoads 200);
			if !(isnil "_roads") then {
				if (((_startpos distance _position_mark) > (_radx - 200)) and !(count _roads == 0) and (_startpos distance (position base) > 1500)) exitwith {_loop = false;};
			};
	};
_roadssel = _roads call BIS_fnc_selectRandom;   
_wpstart = getpos _roadssel;

	if (_markwps) then {
		[_wpstart,_mcolor,"Start"] call fnc_ghst_mark_point;
	};

//Spawn
for "_e" from 0 to (_enum)-1 do {

	private ["_wppos","_roadssel","_roads"];
	
	_roads = (_position_mark nearRoads _rad);   
	_roadssel = _roads call BIS_fnc_selectRandom;  
	_wppos = getpos _roadssel;
	_dir = [_wpstart, _wppos] call BIS_fnc_dirTo;

	_veh = _vehlist call BIS_fnc_selectRandom;
	_car1 = createVehicle [_veh,_wpstart, [], 0, "NONE"];
	_car1 setdir _dir;
	//sleep 0.2;
	_eGrp = createGroup _ghst_side;

	_crew = [_car1, _egrp] call BIS_fnc_SpawnCrew;

	_emptyseats = _car1 emptypositions "cargo";
	
		for "_s" from 0 to (_emptyseats)-2 do {
			_mansel = _menlist call BIS_fnc_selectRandom;
			_man = [_wpstart,_egrp,_mansel,aiSkill] call fnc_ghst_create_unit;
			_man assignAsCargo _car1;
			_man moveincargo _car1;
			//sleep 0.01;
		};
	
	//sleep 0.5;

	[_eGrp,_position_mark, _wppos, [_rad,_rad],_markunitsarray,["AWARE", "NORMAL", "WEDGE"]] call fnc_ghst_waypoints_unload;

	//sleep 5;
};