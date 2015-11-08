/*
	Author: [SA] Duda
	
	Description:
	Creates a radar
	
	Parameters:
		0: ARRAY - Radar center position
		1: NUMBER - Radar distance
		2: NUMBER - Radar min height
		3: NUMBER - Radar max height
		4: SCRIPT - Script to check for unit detection
		5: SCRIPT - Script to call if unit detected
		6: NUMBER (OPTIONAL) - Seconds between radar scans (default 20)
	
	Returns:
	BOOL
*/
_this spawn {

	private ["_radarCenter","_radarDist","_radarMinHeight","_radarMaxHeight","_radarDetectionCheckScript","_radarDetectionActionScript","_radarInterval"];
	
	_radarCenter = [_this,0] call BIS_fnc_param;
	_radarDist = [_this,1] call BIS_fnc_param;
	_radarMinHeight = [_this,2] call BIS_fnc_param;
	_radarMaxHeight = [_this,3] call BIS_fnc_param;
	_radarDetectionCheckScript = [_this,4, {true}] call BIS_fnc_param;
	_radarDetectionActionScript = [_this,5, {true}] call BIS_fnc_param;
	_radarInterval = [_this,6,20] call BIS_fnc_param;

	private ["_nearEntities","_entityHeight","_doCheck"];
	
	_doCheck = true;
	
	while {_doCheck} do {

		_nearEntities = [_radarCenter, _radarDist] call SA_fnc_getNearEntities;
		{
			_entityHeight = (getPosASL _x) select 2;
			if(_entityHeight >= _radarMinHeight && _entityHeight <= _radarMaxHeight) then {
				if([] call _radarDetectionCheckScript && _doCheck) then {
					_doCheck = [] call _radarDetectionActionScript;
				};
			};
		}	
		forEach _nearEntities;
		
		sleep _radarInterval;

	};
	
};