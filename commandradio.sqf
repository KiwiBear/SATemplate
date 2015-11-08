/*
	Author: [SA] Duda
	
	Description:
	Set public variable
	
	Parameters:
		0: STRING - Public variable name
		1: ANY - Public variable value
	
	Returns:
	ARRAY - Array of playable units matching some criteria
*/
CR_setPublicVariable = {
	private ["_variableName","_variableValue"];
	_variableName = [_this,0] call BIS_fnc_param;
	_variableValue = [_this,1] call BIS_fnc_param;
	missionNamespace setVariable [_variableName,_variableValue];
	publicVariable _variableName;
};

/*
	Author: [SA] Duda
	
	Description:
	Get public variable
	
	Parameters:
		0: STRING - Public variable name
		1: ANY - Default value if not defined
	
	Returns:
	ARRAY - Array of playable units matching some criteria
*/
CR_getPublicVariable = {
	private ["_variableName","_variableValue"];
	_variableName = [_this,0] call BIS_fnc_param;
	_variableValue = [_this,1] call BIS_fnc_param;
	 missionNamespace getVariable [_variableName,_variableValue];
};

CR_createCommandRadio = {
	
	if(isServer) then {
		private ["_radios","_startPos","_tasks","_showArrow"];
		_startPos = [_this,0] call BIS_fnc_param;
		_tasks = [_this,1] call BIS_fnc_param;
		_showArrow = [_this,2,false] call BIS_fnc_param;
		_radioCount = [_this,3,1] call BIS_fnc_param;
		_radios = [];
		_tasks = [[0,"Drop Command Radio","CR_taskDropRadio",true]] + _tasks;
		// Create all of the radios
		for "_i" from 1 to _radioCount do
		{
			private ["_radio"];
			_radio = createVehicle ["Land_PortableLongRangeRadio_F", _startPos, [], 0, "CAN_COLLIDE"];
			_startPos = getPos _radio;
			if(_showArrow) then {
				private ["_startPosArrow","_arrow"];
				_startPosArrow = [_startPos select 0, _startPos select 1, (_startPos select 2) + 0.2];
				_arrow = createVehicle ["Sign_Arrow_Green_F", _startPosArrow, [], 0, "CAN_COLLIDE"];
				_arrow attachTo [_radio];
			};
			[_radio,objNull] call CR_setRadioOwner;
			_radios = _radios + [_radio];
		};
		["pv_cr_radios",_radios] call CR_setPublicVariable;
		["pv_cr_radio_tasks",_tasks] call CR_setPublicVariable;
		[_startPos] spawn CR_commandRadioSyncLoop;
	};
	
	if(!isDedicated) then {
		waitUntil { !isNil "pv_cr_radios" };
		g_my_radio = objNull;
		g_my_radio_tasks = [];
		{
			_x addAction ["Take Command Radio", { 
				private ["_radio","_caller"];
				_radio = _this select 0;
				_caller = _this select 1;
				[[_radio,_caller],"CR_takeCommandRadio",false] spawn BIS_fnc_MP; 
			}];
		} forEach pv_cr_radios;		
	};
		
};

CR_commandRadioSyncLoop = {
	private ["_radios","_startPos","_owner"];
	_startPos = [_this,0] call BIS_fnc_param;
	_radios = ["pv_cr_radios",[]] call CR_getPublicVariable;
	while {true} do {
		{
			_owner = [_x] call CR_getRadioOwner;
			if(!alive _owner) then {
				[_owner] call CR_taskDropRadio;
			};
		} forEach _radios;
		sleep 1;
	};
};

CR_enableCommandRadioTask = {
	private ["_taskId","_enable","_radioTasks","_newRadioTasks"];
	_taskId = [_this,0] call BIS_fnc_param;
	_enable = [_this,1,true] call BIS_fnc_param;
	_newRadioTasks = [];
	if(isServer) then {
		_radioTasks = ["pv_cr_radio_tasks",[]] call CR_getPublicVariable;
		{
			if( _x select 0 == _taskId ) then {
				_newRadioTasks = _newRadioTasks + [[_x select 0, _x select 1, _x select 2, _enable]];
			} else {
				_newRadioTasks = _newRadioTasks + [_x];
			};
		} forEach _radioTasks;
	};
	["pv_cr_radio_tasks",_newRadioTasks] call CR_setPublicVariable;
	[[],"CR_syncCommandRadioTasksLocal",true] spawn BIS_fnc_MP; 
};


CR_takeCommandRadio = {
	if(isServer) then {
		private ["_radio","_caller","_currentRadioOwner"];
		_radio = [_this,0] call BIS_fnc_param;
		_caller = [_this,1] call BIS_fnc_param;
		[_radio,_caller] call CR_setRadioOwner;
		_radio hideObjectGlobal true;
		{
			_x hideObjectGlobal true;
		} forEach attachedObjects _radio;
		[[],"CR_syncCommandRadioTasksLocal",true] spawn BIS_fnc_MP; 
	};
};

CR_setRadioOwner = {
	private ["_radio","_owner","_radioOwners","_index","_foundIndex"];
	_radio = [_this,0] call BIS_fnc_param;
	_owner = [_this,1] call BIS_fnc_param;
	_radioOwners = [] call CR_getRadioOwners;
	_index = 0;
	_foundIndex = false;
	scopeName "arraySearchLoop";
	{
		if( _x select 0 == _radio ) then {
			_foundIndex = true;
			breakTo "arraySearchLoop";
		};
		_index = _index + 1;
	} forEach _radioOwners;
	if( _foundIndex ) then {
		_radioOwners set [_index,[_radio,_owner]];
	} else {
		_radioOwners = _radioOwners + [[_radio,_owner]];
	};
	["pv_cr_radio_owners",_radioOwners] call CR_setPublicVariable;	
};

CR_getRadioOwner = {
	private ["_radio","_radioOwners","_foundOwner"];
	_radio = [_this,0] call BIS_fnc_param;
	_radioOwners = [] call CR_getRadioOwners;
	_foundOwner = objNull;
	{
		if( _x select 0 == _radio ) then {
			_foundOwner = _x select 1;
		};
	} forEach _radioOwners;
	_foundOwner;
};

CR_getRadioOwners = {
	["pv_cr_radio_owners",[]] call CR_getPublicVariable;
};

CR_getOwnerRadio = {
	private ["_owner","_radioOwners","_foundRadio"];
	_owner = [_this,0] call BIS_fnc_param;
	_radioOwners = [] call CR_getRadioOwners;
	_foundRadio = objNull;
	{
		if( _x select 1 == _owner ) then {
			_foundRadio = _x select 0;
		};
	} forEach _radioOwners;
	_foundRadio;
};

CR_isRadioOwner = {
	private ["_owner","_isOwner"];
	_owner = [_this,0] call BIS_fnc_param;
	_radioOwners = [] call CR_getRadioOwners;
	_isOwner = false;
	{
		if( _x select 1 == _owner ) then {
			_isOwner = true;
		};
	} forEach _radioOwners;
	_isOwner;
};

CR_taskDropRadio = {
	private ["_owner","_radio"];
	_owner = [_this,0] call BIS_fnc_param;
	_radio = [_owner] call CR_getOwnerRadio;
	if( not( isNull _radio ) ) then {
		_radio setPos (getPos _owner);
		_radio hideObjectGlobal false;
		{
			_x hideObjectGlobal false;
		} forEach attachedObjects _radio;
		[_radio,objNull] call CR_setRadioOwner;
	};
	[[],"CR_syncCommandRadioTasksLocal",true] spawn BIS_fnc_MP; 
};

CR_syncCommandRadioTasksLocal = {
	if(!isNil "g_my_radio_tasks") then {
		if( [player] call CR_isRadioOwner ) then {
			// Sync tasks
			private ["_radioTasks","_radioTaskId","_radioTaskName","_radioTaskFunction","_radioTaskEnabled","_playerAction","_playerHasAction","_playerActionIndex"];
			_radioTasks = ["pv_cr_radio_tasks",[]] call CR_getPublicVariable;
			{
				_radioTaskId = [_x,0] call BIS_fnc_param;
				_radioTaskName = [_x,1] call BIS_fnc_param;
				_radioTaskFunction = [_x,2] call BIS_fnc_param;
				_radioTaskEnabled = [_x,3,true] call BIS_fnc_param;
				_playerAction = [];
				_playerHasAction = false;
				_playerActionIndex = 0;
				
				// Determine if the player already has the task
				scopeName "arraySearchLoop";
				{
					if( (_x select 0) == _radioTaskId ) then {
						_playerAction = _x;
						_playerHasAction = true;
						breakTo "arraySearchLoop";
					};
					_playerActionIndex = _playerActionIndex + 1;
				} forEach g_my_radio_tasks;			
				
				// Task enabled and player doesn't have it
				if(not(_playerHasAction) && _radioTaskEnabled) then {
					// Add action
					_actionId = player addAction [_radioTaskName, {
						private ["_player","_functionName"];
						_functionName = (_this select 3) select 0;
						_player = (_this select 3) select 1;
						[[_player],_functionName,false] spawn BIS_fnc_MP; 
					}, [_radioTaskFunction,player]];
					// Add to task array
					g_my_radio_tasks = g_my_radio_tasks + [[_radioTaskId, _actionId]];
				};
				
				// Task disabled and player has it
				if(_playerHasAction && not(_radioTaskEnabled)) then {
					// Remove action
					player removeAction (_playerAction select 1);
					// Remove from task array
					g_my_radio_tasks set [_playerActionIndex,-1];
					g_my_radio_tasks = g_my_radio_tasks - [-1];
				};
				
			} forEach _radioTasks;
		} else {
			// Remove all tasks - player has no radio
			{
				player removeAction (_x select 1);
			} forEach g_my_radio_tasks;
			g_my_radio_tasks = [];
		};
	};
};

/*
[getPos player, [[1,"Call for Extract","CR_taskDropRadio",false]], true, 5] call CR_createCommandRadio;


[] spawn {
	sleep 20;
	[1] call CR_enableCommandRadioTask;
};*/