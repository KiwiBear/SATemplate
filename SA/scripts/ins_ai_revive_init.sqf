SA_fnc_moveGroupLocal = {
	private ["_target", "_group"];
	_group = [_this,0] call BIS_fnc_param;
	_target = [_this,1] call BIS_fnc_param;
	if(vehicle (leader _group) != (leader _group)) then {
		_group leaveVehicle vehicle (leader _group);
	};
	_group move (getPos _target);
	_group allowFleeing 0;
};

SA_fnc_doReviveLocal = {
	private ["_medic", "_unit"];
	_medic = [_this,0] call BIS_fnc_param;
	_unit = [_this,1] call BIS_fnc_param;
	[_unit,_medic] execVM 'INS_revive\revive\act_revive.sqf'; 
};

SA_fnc_isRevivable = {
	private ["_unit"];
	_unit = [_this,0] call BIS_fnc_param;
	if(	_unit getVariable ["INS_REV_PVAR_is_unconscious",false] && 
		isNil {_unit getVariable "INS_REV_PVAR_who_taking_care_of_injured"} && 
		alive _unit &&
		vehicle _unit == _unit ) then {
		true;
	} else {
		false;
	};
};

SA_fnc_restoreGroupLeaderLocal = {
	private ["_group"];
	_group = [_this,0] call BIS_fnc_param;
	_currentLeader = leader _group;
	_newLeader = _currentLeader;
	_newLeaderId = [_currentLeader] call SA_fnc_getUnitGroupId;
	{
		_id = [_x] call SA_fnc_getUnitGroupId;
		if( (_id < _newLeaderId || !isPlayer _newLeader) && isPlayer _x ) then {
			_newLeader = _x;
			_newLeaderId = _id;
		};
	} forEach (units _group);
	_group selectLeader _newLeader;
	waitUntil { leader _group == _newLeader };
	((units _group)-[_newLeader]) joinSilent _group;
};

SA_fnc_getUnitGroupId = {
	private ["_i", "_unit", "_ret","_group"];
	_ret = false;
	_unit = [_this,0] call BIS_fnc_param;
	_group = group _unit;
	_i = 0;
	while {!_ret AND _i <= 32} do
	{
		_i = _i + 1;
		if (format ["%1",_unit] == format["%1:%2", _group, _i]) then {_ret = true;};
		if (_unit == player) then {if(format ["%1",_unit] == format["%1:%2 (%3)", _group, _i, name _unit]) then {_ret = true;};};
	}; 
	_i
};

if(!isDedicated) then {
	player addEventHandler ["Respawn", {[[group player],"SA_fnc_restoreGroupLeaderLocal",group player] spawn BIS_fnc_MP}];
};

if(isServer) then {

	SA_fnc_availableAiMedics = {

		private ["_unit", "_group", "_medic_requested","_nearUnits","_availableAiMedicsWithMedkits","_possibleMedic"];
		_unit = [_this,0] call BIS_fnc_param;
		_group = group _unit;
		_availableAiMedics = [];

		{
			{
				_possibleMedic = _x;
				//diag_log format ["Possible Medic: %1, %2, %3, %4", !isPlayer _possibleMedic, alive _possibleMedic, !(_possibleMedic getVariable "INS_REV_PVAR_is_unconscious"), _possibleMedic isKindOf "Man"];
				if( !isPlayer _possibleMedic && 
					alive _possibleMedic &&
					!(_possibleMedic getVariable ["INS_REV_PVAR_is_unconscious",false]) &&
					_possibleMedic isKindOf "Man" ) then {
					
					if( not (_possibleMedic in _availableAiMedics) ) then {				
						if( leader _possibleMedic == _possibleMedic || driver (vehicle _possibleMedic) == _possibleMedic || commander (vehicle _possibleMedic) == _possibleMedic ) then {
							_availableAiMedics = [_availableAiMedics, [_possibleMedic]] call BIS_fnc_arrayPushStack;
						} else {
							_availableAiMedics = [[_possibleMedic], _availableAiMedics] call BIS_fnc_arrayPushStack;
						};
					};
				};
			} forEach (crew _x);
		} forEach ([getPos _unit, 60, {West == side _x}] call SA_fnc_getNearEntities);
		
		if (INS_REV_CFG_require_medkit) then {
			_availableAiMedicsWithMedkits = [];
			{
				private ["_uniformItems","_vestItems","_backpackItems","_itemList"];
				_uniformItems = uniformItems _x;
				_vestItems = vestItems _x;
				_backpackItems = backpackItems _x;
				_itemList = _uniformItems + _vestItems + _backpackItems;
				if ("FirstAidKit" in _itemList) then {
					_availableAiMedicsWithMedkits pushBack _x;
				};
			} forEach _availableAiMedics;
			_availableAiMedicsWithMedkits;
		} else {
			_availableAiMedics;
		};
		
	};

	[] spawn {

		private ["_revivableUnits","_unit","_medic","_unitGroup","_reviveTarget","_all_medics_requested","_medics_to_remove","_newGroup","_medic_requested"];

		_all_medics_requested = [];
		
		while {true} do {

			_revivableUnits = [];
			{
				if([_x] call SA_fnc_isRevivable) then {
					_revivableUnits pushBack _x;
				};
			} forEach allUnits;
			
			//hint format ["%1", _revivableUnits];
		
			{
				_unit = _x;
				
				//diag_log format ["Avail Medics: %1", [_unit] call SA_fnc_availableAiMedics];
				
				{
					_medic = _x;
					if( _medic distance _unit < 50 && 
							[_unit] call SA_fnc_isRevivable && 
							isNull (_medic getVariable ["revive_target",objNull]) &&
							( 
								isNull (_unit getVariable ["medic_requested",objNull]) || 
								!alive (_unit getVariable ["medic_requested",_unit])
							) ) then {
						//diag_log format ["Medic Requested: %1", _medic];
						_unit setVariable ["medic_requested", _medic];
						_medic setVariable ["original_group", group _medic];
						_medic setVariable ["revive_target", _unit];
						_medic setVariable ["start_time_ms", diag_tickTime];
						if(count (units group _medic) > 1) then {
							_newGroup = createGroup (side _medic);
							[_medic] join _newGroup;
						} else {
							_newGroup = group _medic;
						};
						[[_newGroup,_unit],"SA_fnc_moveGroupLocal",_medic] spawn BIS_fnc_MP; 
						_all_medics_requested pushBack _medic;
					};
				} forEach ([_unit] call SA_fnc_availableAiMedics);
				
				_medic_requested = _unit getVariable ["medic_requested",objNull];
				
				if( !isNull _medic_requested && _medic_requested distance _unit < 8 && 
						[_unit] call SA_fnc_isRevivable && alive _medic_requested) then {
					[[_medic_requested,_unit],"SA_fnc_doReviveLocal",_medic_requested] spawn BIS_fnc_MP; 
				};
				
			} forEach _revivableUnits;
			
			_medics_to_remove = [];
			{
				_medic = _x;
				_reviveTarget = _medic getVariable ["revive_target",objNull];
				//diag_log format ["%1, %2, %3, %4", !isNull _reviveTarget,  not ([_reviveTarget] call SA_fnc_isRevivable),  !alive _medic, _medic];
				if( (!isNull _reviveTarget && not ([_reviveTarget] call SA_fnc_isRevivable)) || ( !alive _medic)) then {
					[_medic] joinSilent (_medic getVariable "original_group");
					_medic setVariable ["revive_target",objNull];
					_reviveTarget setVariable ["medic_requested", objNull];
					_medics_to_remove pushBack _medic;
				} else {
					_start_time = _medic getVariable ["start_time_ms", diag_tickTime];
					if( diag_tickTime - _start_time > 60000 ) then {
						[_medic] joinSilent (_medic getVariable "original_group");
						_medic setVariable ["revive_target",objNull];
						_reviveTarget setVariable ["medic_requested", objNull];
						_medics_to_remove pushBack _medic;
					};
				};
			} forEach _all_medics_requested;
			
			if(count _medics_to_remove > 0) then {
				//diag_log format ["Medics Removed: %1", _medics_to_remove];
				_all_medics_requested = _all_medics_requested - _medics_to_remove;
				//diag_log format ["Medics Remaining: %1", _all_medics_requested];
			};
			
			sleep 5;
			
		};

	};

};


SA_revive_queue = [];

if(isServer) then {
	
	[] spawn {
	
		private ["_tempGroup","_tempGroupLeader","_newUnit"];
		private ["_lastLoadOut", "_lastGroup","_unitType","_position"];
		_tempGroup = createGroup West;
		_tempGroupLeader = _tempGroup createUnit ["LOGIC",[0, 0, 0] , [], 0, ""];
	
		private ["_allFriendlyAiUnits"];
		_allFriendlyAiUnits = [];
		while {true} do {
			
			{
			   if ((side _x) == West && !(isPlayer _x)) then
			   {
					_x setVariable ["SA_Last_Known_Loadout", [_x] call SA_fnc_getLoadout];
					_x setVariable ["SA_Last_Known_Group", group _x];
					_x setVariable ["SA_AI_Revive_Seen", true];
			   };
			} forEach allUnits;

			{
				if ( !(_x getVariable ["SA_Handling_Revive",false]) && (_x getVariable ["SA_AI_Revive_Seen",false]) ) then {
				
					_x setVariable ["SA_Handling_Revive",true];
					_lastLoadOut = _x getVariable ["SA_Last_Known_Loadout", nil];
					_lastGroup = _x getVariable ["SA_Last_Known_Group", grpNull];
					
					_unitType = (format["%1", typeof _x]);
					_position = [(position _x) select 0, (position _x) select 1];

					deleteVehicle _x;
					
					_newUnit = _tempGroup createUnit [_unitType, _position, [], 0, "CAN_COLLIDE"];
					
					_newUnitMarker = [position _newUnit, "ColorRed", "AI is down"] call SA_fnc_createDotMarker;
					
					[_newUnit,"AinjPpneMstpSnonWrflDnon"] remoteExec ["switchMove"]; 
					_newUnit disableAI "ANIM"; 
					[_newUnit, false] call INS_REV_FNCT_allowDamage;
					
					if(!isNil "_lastLoadOut") then {
						[_newUnit,_lastLoadOut] call SA_fnc_setLoadout;	
					};
					
					_newUnit setVariable ["SA_Last_Known_Loadout", _lastLoadOut];
					_newUnit setVariable ["SA_Last_Known_Group", _lastGroup];
					_newUnit setVariable ["SA_AI_Revive_Seen", true];
					
					_newUnit setVariable ["INS_REV_PVAR_is_unconscious", true, true];
					//_newUnit setVariable ["INS_REV_PVAR_playerSide", _side, true];
					//_newUnit setVariable ["INS_REV_PVAR_playerGroup", _group, true];
					_newUnit setVariable ["INS_REV_PVAR_who_taking_care_of_injured", nil, true];
					_newUnit setVariable ["INS_REV_revived", false, true];
					INS_REV_GVAR_start_unconscious = _newUnit;
					publicVariable "INS_REV_GVAR_start_unconscious";
					["INS_REV_GVAR_start_unconscious", _newUnit] call INS_REV_FNCT_add_actions;
								
					[_newUnit,_lastGroup,_newUnitMarker] spawn {
						private ["_player", "_condition","_lastGroup","_newUnitMarker"];
						_player = _this select 0;
						_lastGroup = _this select 1;
						_newUnitMarker = _this select 2;
						_condition = _player getVariable ["INS_REV_PVAR_is_unconscious",false];
						while {_condition} do
						{
							_who_taking_care_of_injured = _player getVariable "INS_REV_PVAR_who_taking_care_of_injured";
								
							// If somebody is taking care of you
							if !(isNil "_who_taking_care_of_injured") then {
								// If the one who taking care of you is not alive.
								if (isNull _who_taking_care_of_injured || !alive _who_taking_care_of_injured) then	{
									// Reset player's state
									detach _player;
									if !(isNull _who_taking_care_of_injured) then {detach _who_taking_care_of_injured;};
									[_player,"AinjPpneMstpSnonWrflDnon"] remoteExec ["switchMove"]; 
									_player setVariable ["INS_REV_PVAR_who_taking_care_of_injured", nil, true];
								};
							};
							
							// Check MEDEVAC vehicle
							if (INS_REV_CFG_medevac) then {
								if (_player != vehicle _player) then {
									if (alive vehicle _player) then {
										INS_REV_GVAR_is_loaded = true;
										INS_REV_GVAR_loaded_vehicle = vehicle _player;
									} else {
										[] call INS_REV_FNCT_unload;
									};
								};
								
								if (_player == vehicle _player && !isNil "INS_REV_GVAR_is_loaded" && {INS_REV_GVAR_is_loaded}) then {
									[] call INS_REV_FNCT_unload;
								};
							};
							
							// Check Life Time
							if (INS_REV_CFG_life_time > 0) then {
								if (!INS_REV_GVAR_is_lifeTime_over) then {
									private "_lifeTime";
									_lifeTime = round (INS_RES_GVAR_killed_time + INS_REV_CFG_life_time);
									
									if (time > _lifeTime) then {
										INS_REV_GVAR_is_lifeTime_over = true;
										
										// Remove revive action
										INS_REV_GVAR_end_unconscious = _player;
										publicVariable "INS_REV_GVAR_end_unconscious";
										["INS_REV_GVAR_end_unconscious", INS_REV_GVAR_end_unconscious] spawn INS_REV_FNCT_remove_actions;
										
										// Set variable for dead marker
										_player setVariable ["INS_REV_PVAR_is_dead", true, true];
									};
								};
							};
							
							sleep 0.3;
							
							_condition = _player getVariable "INS_REV_PVAR_is_unconscious";
							[_player] call INS_REV_FNCT_prevent_drown;
						};
						
						sleep 0.2;
						
						// Select primary weapon
						_player selectWeapon (primaryWeapon _player);
						
						// Remove revive action
						INS_REV_GVAR_end_unconscious = _player;
						publicVariable "INS_REV_GVAR_end_unconscious";		
						["INS_REV_GVAR_end_unconscious", INS_REV_GVAR_end_unconscious] spawn INS_REV_FNCT_remove_actions;
						
						// Remove unload action
						if (!isNil "INS_REV_GVAR_is_loaded" && {INS_REV_GVAR_is_loaded} && INS_REV_CFG_medevac) then {
							INS_REV_GVAR_del_unload = [INS_REV_GVAR_loaded_vehicle, _player];
							publicVariable "INS_REV_GVAR_del_unload";
							["INS_REV_GVAR_del_unload", INS_REV_GVAR_del_unload] spawn INS_REV_FNCT_remove_unload_action;
							
							INS_REV_GVAR_is_loaded = false;
							INS_REV_GVAR_loaded_vehicle = nil;
						};
						
						[_player, true] call INS_REV_FNCT_allowDamage;

						_player setVariable ["INS_REV_PVAR_isTeleport", false, true];
						_player setVariable ["INS_REV_PVAR_is_dead", false, true];
						
						_player enableAI "ANIM";
						
						[_player,"AmovPercMstpSrasWrflDnon"] remoteExec ["playMove"]; 
						
						deleteMarker _newUnitMarker;
						
						[_player] join _lastGroup;
						
					};
					
				};
			} forEach allDeadMen;

			sleep 5;
			
		};
	};
};