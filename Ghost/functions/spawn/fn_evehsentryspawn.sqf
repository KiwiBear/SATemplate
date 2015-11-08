/*
Ver 1.2 - By: Ghost   Randomly creates different types of vehicles to sit on a road or random location.
eveh_sentry_spawn = [[1,1,2] or "marker",[wpradius_X,wpradius_Y] if not a marker,grpnum,east,[true,"ColorRed"],aiaccuracy] execVM "dta\scripts\eveh_sentry_spawn.sqf";
*/
if (!(call SA_fnc_isAiServer)) exitWith {};

_patrol_mark = _this select 0;//position or marker
_radarray = _this select 1;//radius array around position and Direction [300,300,53]
_grpnum = _this select 2;
_sideguards = _this select 3;//side of guards
_markunitsarray = _this select 4;
	_markunits = _markunitsarray select 0;//true to mark units
	_mcolor = _markunitsarray select 1;//marker color
#define aiSkill _this select 5//sets AI accuracy

//Unit list to randomly select and spawn - Edit as needed
//#include "unit_list.sqf"
//_menlist = ghst_crewmenlist;
_vehlist = ghst_patrolvehlist;

//Do not edit below this line unless you know what you are doing//
/////////////////////////////////////////////////////

private ["_rad"],

if ((_radarray select 0) > (_radarray select 1)) then {_rad = (_radarray select 0);} else {_rad = (_radarray select 1);};

//Get array of roads in area
_roads = (_patrol_mark nearRoads _rad);

for "_x" from 0 to (_grpnum)-1 do {

	private ["_pos","_direction"];
	if (count _roads > 0) then {
		_roadssel = _roads call BIS_fnc_selectRandom;
		_roadconto = roadsConnectedTo _roadssel;
		_direction = [_roadssel, _roadconto select 0] call BIS_fnc_DirTo;
		_roads = _roads - [_roadssel];
		_pos =  [(getposatl _roadssel select 0) -5 * sin(random 360),(getposatl _roadssel select 1) -5 * cos(random 360)];

	} else {

		_pos = [_patrol_mark,_radarray] call fnc_ghst_rand_position;
		
		_direction = (_radarray select 2);
	};
		
	_veh = _vehlist call BIS_fnc_selectRandom;
	_armor1 = createVehicle [_veh,_pos, [], 0, "NONE"];
	_armor1 setdir _direction;
	_armor1 setposatl (getposatl _armor1);

	_eGrp = createGroup _sideguards;
	_crew = [_armor1, _eGrp] call BIS_fnc_SpawnCrew;
	
	//set combat mode
	_eGrp setCombatMode "RED";

	//create markers for units
	if (_markunits) then {
		_mtext = format ["Sentry %1",_eGrp];
		[_pos,_mcolor,_mtext] call fnc_ghst_mark_point;
	};
};
	
if (true) exitWith {};