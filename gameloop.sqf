/*
	Author: [SA] Duda

	Description:
	Starts a game loop on the local client

	Parameter(s):
	_this select 0: FUNC - Game loop stage function to execute
	_this select 1: INT (OPTIONAL) - Seconds to sleep between stage executes (Default: 3)
		
	Returns: 
	Nothing
*/
GameLoopLocal = {
	private ["_gameStage","_loopSleep","_params"];
	_gameStage = [_this, 0] call BIS_fnc_param;
	_loopSleep = [_this, 1, 3] call BIS_fnc_param;
	_parms = [_this, 2, []] call BIS_fnc_param;
	while { !isNil "_gameStage" } do {
		_gameStage = _parms call _gameStage;
		sleep _loopSleep;
	};
};

/*
	Author: [SA] Duda

	Description:
	Starts a game loop on all clients

	Parameter(s):
	_this select 0: FUNC - Game loop stage function to execute
	_this select 1: INT (OPTIONAL) - Seconds to sleep between stage executes (Default: 3)
		
	Returns: 
	Nothing
*/
GameLoopGlobal = {
	[_this,"GameLoopLocal",true] spawn BIS_fnc_MP; 
};

/*
	Author: [SA] Duda

	Description:
	Starts a game loop on specific game clients identified by their playable units

	Parameter(s):
	_this select 0 select 0: FUNC - Game loop stage function to execute
	_this select 0 select 1: INT (OPTIONAL) - Seconds to sleep between stage executes (Default: 3)
	_this select 1: ARRAY (OPTIONAL) - Array of playable units
	
	Returns: 
	Nothing
*/
GameLoopGlobalUnits = {
	private ["_units"];
	_units = [_this, 1, [] call SA_fnc_getPlayableUnits] call BIS_fnc_param;
	[_this select 0,"GameLoopLocal",_units] spawn BIS_fnc_MP; 
};