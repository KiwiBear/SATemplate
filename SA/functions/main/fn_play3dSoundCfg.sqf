/*
	Author: [SA] Duda

	Description:
	Plays a 3d sound from local mission CfgSounds class

	Parameter(s):
	_this select 0: OBJECT - object to emit sound
	_this select 1: STRING - class name
	_this select 2: NUMBER (OPTIONAL) - Distance of sound (default: 1000 meters)
		
	Returns: 
	Nothing
*/
private ["_object","_distance","_className","_fileName","_volume","_freq","_config","_resolveMissionPath","_fileNameArray"];
_object = [_this,0] call BIS_fnc_param;
_className = [_this,1] call BIS_fnc_param;
_distance = [_this,2,1000] call BIS_fnc_param;
_config = getArray ( missionConfigFile / "CfgSounds" / _className / "sound" );
if(count _config > 0) then {
	_fileName = _config select 0;
	_volume = _config select 1;
	_freq = _config select 2;
	[_object, _fileName, _distance, _volume, _freq] call SA_fnc_play3dSound;
};
