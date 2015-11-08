/*
	Author: [SA] Duda

	Description:
	Plays a 3d sound from a specific object source

	Parameter(s):
	_this select 0: OBJECT - object to emit sound
	_this select 1: STRING - file
	_this select 2: NUMBER (OPTIONAL) - Distance of sound (default: 1000 meters)
	_this select 3: NUMBER (OPTIONAL) - Volume (default: 1)
	_this select 4: NUMBER (OPTIONAL) - Freq (default: 1)
	_this select 5: BOOLEAN (OPTIONAL) - Resolve mission path (default: true)
		
	Returns: 
	Nothing
*/
private ["_object","_distance","_rootPath","_file"];
_object = [_this,0] call BIS_fnc_param;
_file = [_this,1] call BIS_fnc_param;
_distance = [_this,2,1000] call BIS_fnc_param;
_volume = [_this,3,1] call BIS_fnc_param;
_freq = [_this,4,1] call BIS_fnc_param;
_resolvePath = [_this,5,true] call BIS_fnc_param;
if(_resolvePath) then {
	_rootPath = call {
		private "_arr";
		_arr = toArray __FILE__;
		_arr resize (count _arr - 36);
		toString _arr
	};
} else {
	_rootPath = "";
};
//hint ("playing sound: " + _rootPath + _file);
playSound3D [_rootPath + _file, _object, false, getPosASL _object, _volume, _freq, _distance ];
