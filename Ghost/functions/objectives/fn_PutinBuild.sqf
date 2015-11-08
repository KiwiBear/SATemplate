/*
V2.5.7 - By Ghost
fills a random building around a position with all objects listed. best to keep radius small so not many buidlings need to be calculated
*/
if !((call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_radarray","_unitarray","_markunitsarray","_markunits","_mcolor","_msize","_haveguards","_minguards","_maxguards","_sideguards","_rad","_menlist"];

_position_mark = _this select 0;//position
_radarray = _this select 1;//radius array around position and Direction [300,300,53]
_unitarray = _this select 2;//object to be placed in building
_markunitsarray = _this select 3;
	_markunits = _markunitsarray select 0;
	_mcolor = _markunitsarray select 1;
	_msize = _markunitsarray select 2;
_haveguards = _this select 4;//guard array
	_minguards = _haveguards select 0;//how many guards min
	_maxguards = _haveguards select 1;//how many guards max
	_sideguards = _haveguards select 2;//marker size [50,50]
#define aiSkill _this select 5//sets AI accuracy and aiming speed
#define debug _this select 6//set to true for diag_log

//Unit list to randomly select and spawn - Edit as needed
//#include "unit_list.sqf"
_menlist = ghst_specopslist;

//Do not edit below this line unless you know what you are doing//
/////////////////////////////////////////////////////
//get all buildings around position of set radius
if ((_radarray select 0) > (_radarray select 1)) then {_rad = (_radarray select 0);} else {_rad = (_radarray select 1);};

_nearBuildings = _position_mark nearObjects ["HouseBase", _rad];

if (debug) then {diag_log format ["Number of Buildings: %1, Number of units in array: %2, Radius Array: %3, Radius for buildings: %4, Position for Buildings: %5", count _nearBuildings, count _unitarray, _radarray, _rad, _position_mark];};

//Put specified objects in Buildings With Guards
{

	private ["_loop","_p","_selbuild","_position","_positionarray","_pos","_eGrp","_g"];
	
	_loop = true;
	_p = 1;
	while {_loop} do {
		private ["_n","_i","_r"];
		if (count _nearBuildings == 0) exitwith {_loop = false};

		//select random building and remove from list
		_n = count _nearBuildings;
		_i = floor(random _n);
		_selbuild = (_nearBuildings select _i);
		_nearBuildings set [_i,-1];
		_nearBuildings = _nearBuildings - [-1];

		//get positions for selected building
			if !(_selbuild iskindof "Piers_base_F") then {
				_positionarray = [_selbuild] call BIS_fnc_buildingPositions;
			} else {
				_positionarray = [];
			};
		//_positionarray = _selbuild call fnc_ghst_build_positions;

		_r = floor(random count _positionarray);
		_position = _positionarray select _r;
		_positionarray set [_r,-1];
		_positionarray = _positionarray - [-1];
		
		if !(isnil "_position") exitwith {_loop = false};
		
		if (debug) then {_p = _p + 1};
	};
	
	if (debug) then {diag_log format ["Ran Position Loop %1 Times", _p];};
	
	//debug
	if (debug) then {diag_log format ["BUILD POS ARRAY %1 BUILD POS SELECTED %2", _positionarray, _position];};

		if (isNil "_position") then {
			if (debug) then {diag_log format["FAILED TO PLACE OBJECT %1", _x];};
			
			_pos = [_position_mark,_radarray] call fnc_ghst_rand_position;
			
			_x allowdamage false;
			_position = _pos findEmptyPosition[ 0 , 20 , typeof _x];
			_x setPosatl _position;
			_x setFormDir (random 360);
			_x allowdamage true;
			
		} else {
			if (debug) then {diag_log format["PLACED OBJECT %1 POS %2", _x, _position];};
			_x allowdamage false;
				if (_x iskindof "Land_Suitcase_F") then {
					_x setPosatl [(_position select 0), (_position select 1), (_position select 2) + 1.5];//avoid placing under rubble
				} else {
					_x setPosatl [(_position select 0), (_position select 1), (_position select 2) + 0.1];//help avoid colliding with floor
				};
			_x setFormDir (random 360);
			_x allowdamage true;
			
		};		
		
	//create markers for units
	if (_markunits) then {
		private ["_pos","_mark1"];
		_pos = [_position,[_msize select 0,_msize select 1,(random 360)]] call fnc_ghst_rand_position;
		_mark1 = [_pos,_mcolor,"","",_msize,"Ellipse","Border"] call fnc_ghst_mark_point;
			
		[_x,_mark1,_selbuild] spawn {
			private ["_unit","_mark1","_selbuild"];
			_unit = _this select 0;
			_mark1 = _this select 1;
			_selbuild = _this select 2;
			
			while {alive _unit} do {
				if!(isNil "_selbuild") then {
					if (((damage _selbuild) > 0.9) and (_unit iskindof "Land_Suitcase_F")) exitwith {deletevehicle _unit;};
					if (((damage _selbuild) > 0.9) and !(_unit iskindof "Land_Suitcase_F")) exitwith {_unit setdamage 1;};
				};
				sleep 5;
			};
			
			deletemarker _mark1;
		
		};
	};
			
	//Spawn guards
	_eGrp = createGroup _sideguards;
	
		for "_g" from 0 to (_minguards + floor(random(_maxguards - _minguards))) do {
				private ["_r","_position","_mansel","_unit1"];
				if !(isNil "_positionarray") then {
				_r = floor(random count _positionarray);
				_position = _positionarray select _r;
				_positionarray set [_r,-1];
				_positionarray = _positionarray - [-1];
				};
				if !(isNil "_position") then {
					_mansel = _menlist call BIS_fnc_selectRandom;
					_unit1 = [_position,_egrp,_mansel,aiSkill] call fnc_ghst_create_unit;
					_unit1 setPosatl _position;
					_unit1 setFormDir (random 360);
					if ((getposatl _unit1 select 2) > 8) then {
						_unit1 setUnitPos "MIDDLE";
					} else  {
						_unit1 setUnitPos "UP";
					};
					dostop _unit1;
					
					if (debug) then {diag_log format["UNIT PLACED INSIDE BUILD %1", _position];};
				} else {
					private ["_mansel","_position","_pos","_unit1"];
					_mansel = _menlist call BIS_fnc_selectRandom;
					
					_pos = [(getposatl _x),[15,15,(random 360)]] call fnc_ghst_rand_position;
						
					_position = _pos findEmptyPosition[ 0 , 20 , _mansel ];
					_unit1 = [_position,_egrp,_mansel,aiSkill] call fnc_ghst_create_unit;
					//_unit1 setPosatl _position;
					_unit1 setFormDir (random 360);
					dostop _unit1;
					
					if (debug) then {diag_log format["UNIT PLACED AROUND BUILD %1", _position];};
				};
			//sleep 0.03;
		};
	//sleep 1;
} foreach _unitarray;

if (debug) then {diag_log "Objects put in buildings"};