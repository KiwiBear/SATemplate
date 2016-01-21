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
					(_possibleMedic getVariable ["SA_auto_revive",false] || !isPlayer (leader _possibleMedic) || leader _possibleMedic == _unit ) &&
					((_possibleMedic getVariable ["SA_auto_revive_count",0]) > 0 || !isPlayer (leader _possibleMedic) || leader _possibleMedic == _unit ) &&
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
						_medic setVariable ["original_team", assignedTeam _medic];
						_medic setVariable ["revive_target", _unit];
						_medic setVariable ["start_time_sec", diag_tickTime];
						_medic setVariable ["SA_auto_revive_count", (_medic getVariable ["SA_auto_revive_count",1]) - 1, true];
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
				if( (!isNull _reviveTarget && not ([_reviveTarget] call SA_fnc_isRevivable)) || ( !alive _medic) ) then {
					[_medic] joinSilent (_medic getVariable "original_group");
					[_medic,(_medic getVariable "original_team")] remoteExec ["assignTeam"];
					_medic setVariable ["original_group", nil];
					_medic setVariable ["original_team", nil];
					_medic setVariable ["revive_target",objNull];
					_reviveTarget setVariable ["medic_requested", objNull];
					_medics_to_remove pushBack _medic;
				} else {
					_start_time = _medic getVariable ["start_time_sec", diag_tickTime];
					if( diag_tickTime - _start_time > 60 ) then {
						[_medic] joinSilent (_medic getVariable "original_group");
						[_medic,(_medic getVariable "original_team")] remoteExec ["assignTeam"];
						_medic setVariable ["original_group", nil];
						_medic setVariable ["original_team", nil];
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

if(isServer) then {
	
	[] spawn {
	
		private ["_tempGroup","_tempGroupLeader","_newUnit"];
		private ["_lastLoadOut", "_lastGroup","_unitType","_position","_lastTeam"];
		_tempGroup = createGroup West;
		_tempGroupLeader = _tempGroup createUnit ["LOGIC",[0, 0, 0] , [], 0, ""];
	
		private ["_allFriendlyAiUnits"];
		_allFriendlyAiUnits = [];
		while {true} do {
			
			{
			   if ((side _x) == West && !(isPlayer _x)) then
			   {
					_x setVariable ["SA_Last_Known_Loadout", [_x] call SA_fnc_getLoadout];
					_x setVariable ["SA_Last_Known_Group", _x getVariable ["original_group",group _x]];
					_x setVariable ["SA_Last_Known_Team", _x getVariable ["original_team",assignedTeam _x]];
					_x setVariable ["SA_AI_Revive_Seen", true];
			   };
			   if (isPlayer _x && !(_x getVariable ["SA_AI_Revive_Is_Player",false])) then
			   {
					_x setVariable ["SA_AI_Revive_Is_Player", true];
			   };
			} forEach allUnits;

			{
				if ( !(_x getVariable ["SA_Handling_Revive",false]) && (_x getVariable ["SA_AI_Revive_Seen",false]) && !(_x getVariable ["SA_AI_Revive_Is_Player",false]) ) then {
				
					_x setVariable ["SA_Handling_Revive",true];
					_lastLoadOut = _x getVariable ["SA_Last_Known_Loadout", nil];
					_lastGroup = _x getVariable ["SA_Last_Known_Group", grpNull];
					_lastTeam = _x getVariable ["SA_Last_Known_Team", "MAIN"];
					
					_unitType = (format["%1", typeof _x]);
					_position = [(position _x) select 0, (position _x) select 1];

					deleteVehicle _x;
					
					_newUnit = _tempGroup createUnit [_unitType, _position, [], 0, "CAN_COLLIDE"];
					_newUnit setDir (random floor(random 361));
					
					_newUnitMarker = [position _newUnit, "ColorRed", "AI is down"] call SA_fnc_createDotMarker;
					
					[_newUnit,"AinjPpneMstpSnonWrflDnon"] remoteExec ["switchMove"]; 
					_newUnit disableAI "ANIM"; 
					[_newUnit, false] call INS_REV_FNCT_allowDamage;
					
					if(!isNil "_lastLoadOut") then {
						[_newUnit,_lastLoadOut] call SA_fnc_setLoadout;	
					};
					
					_newUnit setVariable ["SA_Last_Known_Loadout", _lastLoadOut];
					_newUnit setVariable ["SA_Last_Known_Group", _lastGroup];
					_newUnit setVariable ["SA_Last_Known_Team", _lastTeam];
					_newUnit setVariable ["SA_AI_Revive_Seen", true];
					
					_newUnit setVariable ["INS_REV_PVAR_is_unconscious", true, true];
					//_newUnit setVariable ["INS_REV_PVAR_playerSide", _side, true];
					//_newUnit setVariable ["INS_REV_PVAR_playerGroup", _group, true];
					_newUnit setVariable ["INS_REV_PVAR_who_taking_care_of_injured", nil, true];
					_newUnit setVariable ["INS_REV_revived", false, true];
					INS_REV_GVAR_start_unconscious = _newUnit;
					publicVariable "INS_REV_GVAR_start_unconscious";
					["INS_REV_GVAR_start_unconscious", _newUnit] call INS_REV_FNCT_add_actions;
								
					[_newUnit,_lastGroup,_newUnitMarker,_lastTeam] spawn {
						private ["_player", "_condition","_lastGroup","_newUnitMarker","_lastTeam","_isDead","_unconsciousStartTime"];
						_player = _this select 0;
						_lastGroup = _this select 1;
						_newUnitMarker = _this select 2;
						_lastTeam = _this select 3;
						_condition = _player getVariable ["INS_REV_PVAR_is_unconscious",false];
						_unconsciousStartTime = diag_tickTime;
						_isDead = false;
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
							
							sleep 3;
							
							_condition = _player getVariable "INS_REV_PVAR_is_unconscious";
							[_player] call INS_REV_FNCT_prevent_drown;
							
							if(diag_tickTime - _unconsciousStartTime > (60 * ("PARAM_AIReviveLimit" call BIS_fnc_getParamValue))) then {
								_condition = false;
								_isDead = true;
							};
							
						};
						
						sleep 0.2;
						
						if(_isDead) then {
						
							deleteMarker _newUnitMarker;
							_player setVariable ["SA_Handling_Revive", true];
							
							// Remove revive action
							INS_REV_GVAR_end_unconscious = _player;
							publicVariable "INS_REV_GVAR_end_unconscious";		
							["INS_REV_GVAR_end_unconscious", INS_REV_GVAR_end_unconscious] spawn INS_REV_FNCT_remove_actions;
							
							_player enableAI "ANIM";
							
							[_player, true] call INS_REV_FNCT_allowDamage;
							
							_player setDamage 1;
						
						} else {
						
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
							
							[_player] joinSilent _lastGroup;
							[_player,_lastTeam] remoteExec ["assignTeam"];
							
						};
						
					};
					
				};
			} forEach allDeadMen;

			sleep 5;
			
		};
	};
};

SA_fnc_enableAutoRevive = {
	private ["_units","_enabled","_count"];
	_units = param [0,[]];
	_enabled = param [1,false];
	_count = param [2,1];
	{
		if( !isPlayer _x) then {
			_x setVariable ["SA_auto_revive", _enabled, true];
			_x setVariable ["SA_auto_revive_count", _count, true];
		};
	} forEach _units;
};


//SA_CUSTOM_ACTION_MENU_SUBMENU =
//[
//	["Action",true],
//	["Option-1", [2], "", -5, [["expression", "player sidechat ""-1"" "]], "0", "0", "\ca\ui\data\cursor_support_ca"],
//	["Option 0", [3], "", -5, [["expression", "player sidechat "" 0"" "]], "1", "0", "\ca\ui\data\cursor_support_ca"],
//	["Option 1", [4], "", -5, [["expression", "player sidechat "" 1"" "]], "1", "CursorOnGround", "\ca\ui\data\cursor_support_ca"]
//];

SA_CUSTOM_ACTION_MENU = 
[
	// First array: "User menu" This will be displayed under the menu, bool value: has Input Focus or not.
	// Note that as to version Arma2 1.05, if the bool value set to false, Custom Icons will not be displayed.
	["Action",false],
	// Syntax and semantics for following array elements:
	// ["Title_in_menu", [assigned_key], "Submenu_name", CMD, [["expression",script-string]], "isVisible", "isActive" <, optional icon path> ]
	// Title_in_menu: string that will be displayed for the player
	// Assigned_key: 0 - no key, 1 - escape key, 2 - key-1, 3 - key-2, ... , 10 - key-9, 11 - key-0, 12 and up... the whole keyboard
	// Submenu_name: User menu name string (eg "#USER:MY_SUBMENU_NAME" ), "" for script to execute.
	// CMD: (for main menu:) CMD_SEPARATOR -1; CMD_NOTHING -2; CMD_HIDE_MENU -3; CMD_BACK -4; (for custom menu:) CMD_EXECUTE -5
	// script-string: command to be executed on activation. (no arguments passed)
	// isVisible - Boolean 1 or 0 for yes or no, - or optional argument string, eg: "CursorOnGround"
	// isActive - Boolean 1 or 0 for yes or no - if item is not active, it appears gray.
	// optional icon path: The path to the texture of the cursor, that should be used on this menuitem.
	//["Enable Auto Revive", [0], "", -5, [["expression", "[groupSelectedUnits player, true] spawn SA_fnc_enableAutoRevive;"]], "1", "1"],
	["Enable Auto Revive (1 Revive)", [0], "", -5, [["expression", "[groupSelectedUnits player, true, 1] spawn SA_fnc_enableAutoRevive;"]], "1", "1"],
	["Disable Auto Revive", [0], "", -5, [["expression", "[groupSelectedUnits player, false, 0] spawn SA_fnc_enableAutoRevive;"]], "1", "1"],
	["Halo Jump (Without Leader)", [0], "", -5, [["expression", "[halo, groupSelectedUnits player] spawn SA_fnc_haloJumpMap"]], "1", "1"],
	["Form Squad", [0], "", -5, [["expression", "[groupSelectedUnits player] spawn SA_fnc_formNewGroup"]], "1", "1"],
	["Other Actions", [7], "#ACTION", -5, [["expression", "player sidechat ""Submenu"" "]], "1", "1"]
];

[] spawn {
	while {true} do {
		waitUntil { commandingMenu == "RscGroupRootMenu" };
		waitUntil { commandingMenu == "#ACTION" };
		showCommandingMenu "#USER:SA_CUSTOM_ACTION_MENU";
	};
};

[] spawn {
	private ["_selectedGroupUnits","_keyDownHandler"];
	while {true} do {
		waitUntil { commandingMenu == "#USER:SA_CUSTOM_ACTION_MENU" };
		SA_command_actions_backspace_pressed = false;
		SA_command_actions_selected_units = [];
		_keyDownHandler = (finddisplay 46) displayaddeventhandler ["keydown",
			"if( _this select 1 == 14 && commandingMenu == ""#USER:SA_CUSTOM_ACTION_MENU"") then { SA_command_actions_selected_units = groupSelectedUnits player; SA_command_actions_backspace_pressed = true};"];
		waitUntil { commandingMenu == "" };
		(finddisplay 46) displayremoveeventhandler ["keydown",_keyDownHandler];
		if(SA_command_actions_backspace_pressed) then {
			showCommandingMenu "RscGroupRootMenu";
			{
				player groupSelectUnit [_x, true];
			} forEach (SA_command_actions_selected_units);
		};
	};
};
	
	