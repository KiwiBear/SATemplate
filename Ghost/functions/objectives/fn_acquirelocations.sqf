private["_half","_centerPos","_mrkr","_placesCfg","_namesToKeep","_place","_name","_i","_opname","_position","_PARAM_Kavala","_ghst_Locations"];
//create map center marker
_half = getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize") / 2;
_centerPos = [_half, _half, 0];
_mrkr = createMarker ["CENTER", _centerPos];
_mrkr setMarkerShape "ICON";
_mrkr setMarkerColor "ColorBLUE";
_mrkr setMarkerSize [1, 1];
_mrkr setMarkerType "empty";
_mrkr setMarkerText "CENTER";

ghst_objarray = [];
//ghst_localarray = nearestLocations [(getmarkerpos "center"),["NameLocal"],20000];//local sites
//ghst_marinearray = nearestLocations [(getmarkerpos "center"),["NameMarine"],20000];//marine sites
ghst_milarray = [];

//Get list of military sites, factories, and power plants

_placesCfg = configFile >> "CfgWorlds" >> worldName >> "Names";
_namesToKeep = ["MILITARY","FACTORY","POWER PLANT","GHOST HOTEL"];
for "_i" from 0 to (count _placesCfg)-1 do
{
	_place = _placesCfg select _i;
	_name = toUpper(getText(_place >> "name"));
	_position = getArray (_place >> "position");
	
	if((_name in _namesToKeep) and (_position distance (position base) > 1500)) then {
		_opname = format["%1 %2", _name, _i];
		/*
		_mrkr = createMarker [_opname, _position];
		_mrkr setMarkerShape "ICON";
		_mrkr setMarkerColor "ColorBlack";
		_mrkr setMarkerSize [1, 1];
		_mrkr setMarkerType "mil_flag";
		_mrkr setMarkerText _opname;
		*/
		ghst_milarray = ghst_milarray + [[_position, _opname]];
	};
};

//normal objective areas
_PARAM_Kavala = "PARAM_Kavala" call BIS_fnc_getParamValue;
if (_PARAM_Kavala == 1) then {

	//Kavala Only
	_ghst_Locations = nearestLocations [(getmarkerpos "ghost_city"),["NameCityCapital","NameCity","NameVillage"],300];//"NameCityCapital","NameCity","NameVillage"

	ghst_objarray = ghst_objarray + [(_ghst_Locations select 0)];

} else {
	
	private ["_num_objs","_locselname","_locsel","_idx","_o"];
	
	_num_objs = 1;
	
	//find all locations
	_ghst_Locations = nearestLocations [(getmarkerpos "center"),["NameCityCapital","NameCity","NameVillage"],20000];//"NameCityCapital","NameCity","NameVillage"
	
	//Random number of objectives
	if (_PARAM_Kavala == 0) then {
		_num_objs = ceil(random (count _ghst_Locations))+ 2;
	};
	//Half of Objectives
	if (_PARAM_Kavala == 2) then {
		_num_objs = round((count _ghst_Locations) / 2);
	};
	//ALL objectives
	if (_PARAM_Kavala == 3) then {
		_num_objs = (count _ghst_Locations)-1;
	};

		for "_o" from 0 to _num_objs do {
		
			_idx = floor(random count _ghst_Locations);
			_locsel = _ghst_Locations select _idx;//select random location
			if !(isnil "_locsel") then {
				_locselname = text _locsel;//get name of location
			
				if ((locationPosition _locsel) distance (position base) > 1500 and !(_locselname in ["Sagonisi"])) then {
					ghst_objarray = ghst_objarray + [_locsel];
				};
			};	
			_ghst_Locations set [_idx,-1];
			_ghst_Locations = _ghst_Locations - [-1];
		};
};