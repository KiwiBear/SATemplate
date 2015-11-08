/*
Ver 1 - By: Ghost   Randomly creates different types of boats to patrol area .
_eboatspawn = [[1,1,2] or "marker",[wpradius_X,wpradius_Y,dir],grpnum,EAST,[true,"ColorRed"],aiaccuracy] execVM "scripts\eboatspawn.sqf";
*/
if !((call SA_fnc_isAiServer)) exitWith {};

_position_mark = _this select 0;//position or marker
_radarray = _this select 1;//radius array around position and Direction [300,300,53]
_grpnum = _this select 2;
_sideguards = _this select 3;//side of guards
_markunitsarray = _this select 4;
	_markunits = _markunitsarray select 0;
	_mcolor = _markunitsarray select 1;
#define aiSkill _this select 5//sets AI accuracy and aiming speed

//Unit list to randomly select and spawn - Edit as needed
//#include "unit_list.sqf"
_menlist = ghst_crewmenlist;
_boatlist = ghst_patrolboatlist;

for "_x" from 0 to (_grpnum)-1 do {

	_pos = [_position_mark,_radarray,true] call fnc_ghst_rand_position;

	_veh = _boatlist call BIS_fnc_selectRandom;
	_boat1 = createVehicle [_veh,_pos, [], 0, "NONE"];
	_eGrp = createGroup _sideguards;

	_crew = [_boat1, _eGrp] call BIS_fnc_SpawnCrew;
	
	//set combat mode
	_eGrp setCombatMode "RED";

	[_eGrp,_position_mark,_radarray,_markunitsarray,["SAFE", "NORMAL", "STAG COLUMN"],true] call fnc_ghst_waypoints;
	
	//sleep 2;
	
};

if (true) exitWith {};