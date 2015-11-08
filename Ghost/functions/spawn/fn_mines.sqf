/*V1 - By: Ghost - creates random mines on/near the roads in given radius
ghst_mines = [_locselpos,_rad,_maxmines,_side,_showmarks] execvm "scripts\ghst_mines.sqf";
ghst_mines = [(getmarkerpos "center"),3000,40,EAST,[true,"ColorBlack"]] execvm "scripts\ghst_mines.sqf";
*/
if (!(call SA_fnc_isAiServer)) exitwith {};

_centerposition = _this select 0;//position
_rad = _this select 1;//radius for mines to spawn
_maxmines = _this select 2;//max number of mines to spawn
_side = _this select 3;//side for mines to be known
_markunitsarray = _this select 4;
	_markunits = _markunitsarray select 0;//true to mark units
	_mcolor = _markunitsarray select 1;//marker color

_minelist = ["APERSBoundingMine","APERSBoundingMine","APERSTripMine","APERSBoundingMine"];
//"ATMine","APERSMine","APERSBoundingMine","SLAMDirectionalMine","APERSTripMine"

//Do not edit below this line unless you know what you are doing//
//////////////////////////////////////////////////////

ghst_mine_array = [];

//Get array of roads in area
_roads = (_centerposition nearRoads _rad);

_mines = floor(count _roads / 10);

if (_mines > _maxmines) then {_mines = _maxmines;};

//create empty vehicles
private ["_direction"];
for "_x" from 0 to (_mines) do {

	_roadssel = _roads call BIS_fnc_selectRandom;
	_roadconto = roadsConnectedTo _roadssel;
	_direction = [_roadssel, _roadconto select 0] call BIS_fnc_DirTo;
	_roads = _roads - [_roadssel];
	_pos =  [(getposatl _roadssel select 0)-5 * sin(random 359),(getposatl _roadssel select 1)-5 * cos(random 359)]; 
	_minesel = _minelist call BIS_fnc_selectRandom;
	_mine = createMine [_minesel, _pos, [], 0];
		if (isnil "_direction") then {
			_mine setdir (random 360);
		} else {
			_mine setdir _direction;
		};
	_mine setPosATL [getposatl _mine select 0,getposatl _mine select 1,0];
	_side revealMine _mine;

		//create markers for mines
		if (_markunits) then {
			[_pos,_mcolor,"Mine"] call fnc_ghst_mark_point;
		};	
	
	ghst_mine_array = ghst_mine_array + [_mine];

	//sleep 0.1;

};