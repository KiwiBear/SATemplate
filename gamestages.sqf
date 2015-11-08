#include "stages.h"

/*  SERVER STAGES */

STAGE("STG_SERVER_START") 
	INIT {
		[STG_SERVER_INIT] call GameLoopLocal; 
	}
	EXEC {
		[STG_SERVER_ARRIVE_AT_ISLAND] spawn GameLoopLocal; 
		[STG_SERVER_HELI_TRANSPORT_BASE] spawn GameLoopLocal; 
		[STG_SERVER_CAMP_DISCOVERY] spawn GameLoopLocal; 
		"leader_area" setMarkerAlpha 0;
	}
STAGE_END

STAGE("STG_SERVER_INIT") 
	INIT {}
	EXEC {

		// Extract Heli
		[extract_heli,true] call SA_fnc_preventDamage;  
		[extract_heli] call SA_fnc_vehicleIgnoreEnemy; 
		[extract_heli] call SA_fnc_removeAllCrewExceptDriver;
		extract_heli enableCopilot false;
		
		// Transport Heli
		[transport_heli,true] call SA_fnc_preventDamage;  
		[transport_heli] call SA_fnc_vehicleIgnoreEnemy; 
		[transport_heli] call SA_fnc_removeAllCrewExceptDriver;
		transport_heli enableCopilot false;
		
		// Create random objective positions
		["camp_objective", "camp_obj_", 30] call SA_fnc_randomlyMoveAllInsideMarker;
		["city_objective", "city_obj_", 24, true] call SA_fnc_randomlyMoveAllInsideMarker;
		["leader_area", 20] call SA_fnc_moveMarkerRandomOffset;
		"leader_wp" setMarkerPos (getMarkerPos "leader_area");
		
		// AI
		["civil_patrol","area_marker"] call SA_fnc_patrolArea;
		["coast_defend","coast_marker"] call SA_fnc_defendArea;
		["city_defend","city_marker"] call SA_fnc_defendArea;
		["city_patrol","city_marker",0,1] call SA_fnc_patrolArea;
		["area_patrol","area_marker",0,1] call SA_fnc_patrolArea;
		["area_defend","area_marker",1,1] call SA_fnc_patrolArea;
	
	}
STAGE_END

STAGE("STG_SERVER_CAMP_DISCOVERY") 
	INIT {
		g_units_at_camp = [];
	}
	EXEC {
		_nearEntitites = [getMarkerPos "camp_wp", 50, {side _x == east}] call SA_fnc_getNearEntities;
		{
			_u = _x;
			_inCamp = false;
			{
				if( _x == _u ) then {
					_inCamp = true;
				};
			}
			forEach g_units_at_camp;	
			if( !_inCamp )  then {
				g_units_at_camp = g_units_at_camp + [_u];
				_pos = [getMarkerPos "camp_wp", 5] call SA_fnc_getPositionInsideCircle;
				_u move _pos;
				[_u] spawn {
					_unit = _this select 0;
					waitUntil { moveToCompleted _unit || moveToFailed _unit };
					_unit action ["SitDown", _unit];
					_unit setBehaviour "SAFE";
					_unit disableAI "ANIM";
					waitUntil { not ( behaviour _unit == "SAFE" ) };
					_unit enableAI "ANIM";
				};
			};
		}
		forEach _nearEntitites;
		sleep 10;
		_returnValue = STG_SERVER_CAMP_DISCOVERY;
	}
STAGE_END

STAGE("STG_SERVER_ARRIVE_AT_ISLAND") 
	INIT {
	}
	EXEC {
		private ["_players_on_island","_spawnPos","_spawnDir"];
		_players_on_island = [{island_heli_pad distance getPos _x < 50}] call SA_fnc_getPlayableUnits;
		if( count _players_on_island > 0) then {
			[STG_PLAYER_ARRIVE_AT_ISLAND] spawn GameLoopGlobal; 
			_spawnPos = getPos island_front;
			_spawnDir = getDir island_front;
			deleteVehicle island_front;
			front setPos _spawnPos;
			front setDir _spawnDir;
			["pvCampTaskAssigned", true] call SA_fnc_setPublicVariable;
			[3,true] call SA_fnc_enableCommandRadioTask;
			_returnValue = STG_SERVER_ARRIVE_AT_CAMP;
		} else {
			_returnValue = STG_SERVER_ARRIVE_AT_ISLAND;
		};
	}
STAGE_END

STAGE("STG_SERVER_ARRIVE_AT_CAMP") 
	INIT {
	}
	EXEC {
		private ["_playersAtCamp","_nearEnemyCount","_nearEnemy","_randomPlayerName","_spawnPos","_spawnDir"];
		_playersAtCamp = [{getMarkerPos "camp_wp" distance getPos _x < 5}] call SA_fnc_getPlayableUnits;
		_nearEnemy = [getMarkerPos "camp_wp", 50, {side _x == east}] call SA_fnc_getNearEntities;
		if( count _playersAtCamp > 0 && count _nearEnemy == 0 ) then {
			_randomPlayerName = name (_playersAtCamp select floor( random( (count _playersAtCamp) - 1 ) ));
			[STG_PLAYER_ARRIVE_AT_CAMP,0,[_randomPlayerName]] spawn GameLoopGlobal;
			_spawnPos = getPos camp_front;
			_spawnDir = getDir camp_front;
			deleteVehicle camp_front;
			front setPos _spawnPos;
			front setDir _spawnDir;
			["pvCampTaskComplete", true] call SA_fnc_setPublicVariable;
			["pvLeaderTaskAssigned", true] call SA_fnc_setPublicVariable;
			sleep 30;
			setDate [2014, 1, 7, 9, 0];
			"leader_area" setMarkerAlpha 100;
			_returnValue = STG_SERVER_LEADER_SURRENDER;
		} else {
			_returnValue = STG_SERVER_ARRIVE_AT_CAMP;
		};
	}
STAGE_END

STAGE("STG_SERVER_LEADER_SURRENDER") 
	INIT {
	}
	EXEC {
		private ["_leaderPos","_playersNearLeader","_minDistanceToLeader","_nearEnemy"];
		_leaderPos = getPos rebel_leader;
		_playersNearLeader = [{_leaderPos distance getPos _x < 5}] call SA_fnc_getPlayableUnits;
		_minDistanceToLeader = 30;
		{ _minDistanceToLeader = _minDistanceToLeader min (_leaderPos distance getPos _x) } forEach _playersNearLeader;
		if(count _playersNearLeader > 0) then {
			_nearEnemy = [_leaderPos, _minDistanceToLeader, {side _x == east && _x != rebel_leader}] call SA_fnc_getNearEntities;
			if(count _nearEnemy == 0) then {
				rebel_leader playMove "AmovPercMstpSsurWnonDnon"; 
				rebel_leader disableAI "ANIM";
				[STG_PLAYER_LEADER_SURRENDER] spawn GameLoopGlobal;
				["pvLeaderTaskComplete", true] call SA_fnc_setPublicVariable;
				["pvExtractTaskAssigned", true] call SA_fnc_setPublicVariable;
				sleep 10;
				_bombPos = getPos rebel_leader;
				_bomb="M_Mo_82mm_AT_LG" createVehicle [_bombPos select 0, _bombPos select 1, (_bombPos select 2) + 1];
				_bomb="M_Mo_82mm_AT_LG" createVehicle [_bombPos select 0, _bombPos select 1, (_bombPos select 2) + 1.2];
				_bomb="M_Mo_82mm_AT_LG" createVehicle [_bombPos select 0, _bombPos select 1, (_bombPos select 2) + 1.3];
				_returnValue = STG_SERVER_WAIT_EXTRACT;
			} else {
				_returnValue = STG_SERVER_LEADER_SURRENDER;
			};
		} else {
			_returnValue = STG_SERVER_LEADER_SURRENDER;
		};
	}
STAGE_END

STAGE("STG_SERVER_WAIT_EXTRACT") 
	INIT {
		[1,true] call SA_fnc_enableCommandRadioTask;
	}
	EXEC {
		private ["_playersNearHeli","_playersInHeli"];	
		_playersNearHeli = [{extract_heli distance getPos _x < 300 && not (_x in extract_heli)}] call SA_fnc_getPlayableUnits;
		_playersInHeli = [{_x in extract_heli}] call SA_fnc_getPlayableUnits;
		if( count _playersNearHeli == 0 && count _playersInHeli > 0 ) then {
			[2,false] call SA_fnc_enableCommandRadioTask;
			[group (driver extract_heli), "extract_heli",getPos extract_heli_pad,"LAND",false, false] call SA_fnc_moveHelicopter;
			[STG_PLAYER_EXTRACT_LEAVING] spawn GameLoopGlobal; 
			sleep 50;
			"end1" call BIS_fnc_endMission;
		} else {
			_returnValue = STG_SERVER_WAIT_EXTRACT;
		};
	}
STAGE_END

STAGE("STG_SERVER_HELI_TRANSPORT_BASE") 
	INIT {
		sleep 30;
	}
	EXEC {
		g_heli_landed_at_base = false;
		[group transport_heli, "transport_heli",getPos base_heli_pad,"GET IN",false, false] call SA_fnc_moveHelicopter;
		_returnValue = STG_SERVER_WAIT_HELI_LOAD_BASE;
	}
STAGE_END

STAGE("STG_SERVER_WAIT_HELI_LOAD_BASE") 
	INIT {
		g_command_radio_check = true;
		g_command_radio_check_notify = true;
	}
	EXEC {
		if(g_heli_landed_at_base) then {
		
			private ["_playersNearHeli","_playersInHeli"];
			
			_playersNearHeli = [{transport_heli distance getPos _x < 200 && not (_x in transport_heli)}] call SA_fnc_getPlayableUnits;
			_playersInHeli = [{_x in transport_heli}] call SA_fnc_getPlayableUnits;

			if( count _playersNearHeli == 0 && count _playersInHeli > 0 ) then {
	
	
				if(g_command_radio_check) then {
					
					private ["_playerHasRadio"];
					_playerHasRadio = false;
					{
						if([_x] call SA_fnc_isRadioOwner) then {
							_playerHasRadio = true;
						};
					}
					forEach _playersInHeli;	
					
					if( _playerHasRadio ) then {
						g_command_radio_check = false;
						[[STG_PLAYER_TRANSPORT_LEAVING_BASE],_playersInHeli] spawn GameLoopGlobalUnits; 
						_returnValue = STG_SERVER_HELI_TRANSPORT_ISLAND;
					} else {
						if( g_command_radio_check_notify ) then {
							[[STG_PLAYER_COMMAND_RADIO_NOTIFY],_playersInHeli] spawn GameLoopGlobalUnits; 
							g_command_radio_check_notify = false;
						};
						_returnValue = STG_SERVER_WAIT_HELI_LOAD_BASE;
					};
					
					
				} else {
					[[STG_PLAYER_TRANSPORT_LEAVING_BASE],_playersInHeli] spawn GameLoopGlobalUnits; 
					_returnValue = STG_SERVER_HELI_TRANSPORT_ISLAND;	
				};

			} else {
				_returnValue = STG_SERVER_WAIT_HELI_LOAD_BASE;
			};
		
		} else {
			if( transport_heli distance getPos base_heli_pad < 20 ) then {
				g_heli_landed_at_base = true;
			};
			_returnValue = STG_SERVER_WAIT_HELI_LOAD_BASE;
		};
	}
STAGE_END

STAGE("STG_SERVER_HELI_TRANSPORT_ISLAND") 
	INIT {}
	EXEC {
		g_heli_landed_at_island = false;
		[group transport_heli, "transport_heli",getPos island_heli_pad,"GET OUT",false, false] call SA_fnc_moveHelicopter;
		_returnValue = STG_SERVER_WAIT_HELI_UNLOAD_ISLAND;
	}
STAGE_END

STAGE("STG_SERVER_WAIT_HELI_UNLOAD_ISLAND") 
	INIT {}
	EXEC {
		
		if(g_heli_landed_at_island) then {

			private ["_playersInHeli"];
			_playersInHeli = [{_x in transport_heli}] call SA_fnc_getPlayableUnits;
			_playersNearHeli = [{transport_heli distance getPos _x < 100}] call SA_fnc_getPlayableUnits;
			if( count _playersInHeli == 0 ) then {
				[[STG_PLAYER_TRANSPORT_LEAVING_ISLAND],_playersNearHeli] spawn GameLoopGlobalUnits; 
				_returnValue = STG_SERVER_HELI_TRANSPORT_BASE;
			} else {
				_returnValue = STG_SERVER_WAIT_HELI_UNLOAD_ISLAND;
			};
		
		} else {
			if( transport_heli distance getPos island_heli_pad < 30 ) then {
				g_heli_landed_at_island = true;
			};
			_returnValue = STG_SERVER_WAIT_HELI_UNLOAD_ISLAND;
		};
		
	}
STAGE_END

/*  PLAYER STAGES */

STAGE("STG_PLAYER_START") 
	INIT {
		
		// Init Local Settings //
		
		waitUntil {!isNull player};
		group obj_commanding_officer setGroupId ["HQ - Commanding Officer"];		
		group transport_heli setGroupId ["HQ - FOB Transport"];		
		group extract_heli setGroupId ["Extract Team"];		
		
		// Assign Tasks for JIP //

		if( ["pvCampTaskAssigned", false] call SA_fnc_getPublicVariable ) then {
			[STG_PLAYER_ASSIGN_CAMP_TASK,0,[true,false]] call GameLoopLocal;
		};
		if( ["pvCampTaskComplete", false] call SA_fnc_getPublicVariable ) then {
			[STG_PLAYER_COMPLETE_CAMP_TASK,0,[false]] call GameLoopLocal;
		};
		if( ["pvLeaderTaskAssigned", false] call SA_fnc_getPublicVariable ) then {
			[STG_PLAYER_ASSIGN_LEADER_TASK,0,[true,false]] call GameLoopLocal;
		};
		if( ["pvLeaderTaskComplete", false] call SA_fnc_getPublicVariable ) then {
			[STG_PLAYER_COMPLETE_LEADER_TASK,0,[false]] call GameLoopLocal;
		};
		if( ["pvExtractTaskAssigned", false] call SA_fnc_getPublicVariable ) then {
			[STG_PLAYER_ASSIGN_EXTRACT_TASK,0,[true,false]] call GameLoopLocal;
		};
		if( ["pvExtractTaskComplete", false] call SA_fnc_getPublicVariable ) then {
			[STG_PLAYER_COMPLETE_EXTRACT_TASK,0,[false]] call GameLoopLocal;
		};
		
		// Start Player Intro Cut Scene //

		[[["<t size='1'>Two months ago, a deadly virus was detected in Stratis's water supply. Stratis has lost almost 10% of its population.</t><br/><br/><img size='6' image='virusintro.jpg'/>",6],
			["<t size='1'>Since the outbreak, the Stratis military has been importing fresh drinking water across the island. However, in the past few weeks, rumours have started to spread across the island.</t>",8],
			["<t size='1'>Locals are starting to think that the Stratis government purposely contaminated the water.</t>",5],
			["<t size='1'>Faster than the disease, violence is spreading across the island.</t>",4],
			["<t size='1'>A village leader has started to organize a violet rebellion against the Stratis government and military. As a result, the Stratis government has evacuated to the nearby island of Stratis.</t><br/><br/><img size='6' image='leaderintro.jpg'/>",10],
			["<t size='1'>You, along with the rest of the Stratis military have been ordered to clean up the mess. A small Stratis recon team has already been deployed 12 hours ago to try and locate the rebel leader.</t>",8],
			["<t size='1'>17:00, Stratis military deployment zone</t>",3]],0,5] call SA_fnc_createBlackCutScene;
	}
	EXEC {
		_returnValue = STG_PLAYER_BASE;
	}
STAGE_END

STAGE("STG_PLAYER_BASE") 
	INIT {
		g_reported_in = false;
		g_helicopter_landed = false;
		[STG_PLAYER_ASSIGN_REPORT_IN_TASK] call GameLoopLocal;
	}
	EXEC {

		// Add task if helicopter lands
		if(!g_helicopter_landed) then {
			if( transport_heli distance getPos base_heli_pad < 20 ) then {
				if(g_reported_in) then {
					obj_commanding_officer sideChat "Transportation is here. Get on board soldier and I'll brief you on the way.";
				};
				[STG_PLAYER_ASSIGN_GET_IN_TASK] call GameLoopLocal;
				g_helicopter_landed = true;
			};
		};
	
		// Check to see if the player has just reported in
		if(!g_reported_in) then {
			if( player distance getPos obj_commanding_officer < 4 ) then {
				// Check in with player
				if(["pvCampTaskAssigned", false] call SA_fnc_getPublicVariable) then {
					obj_commanding_officer sideChat "You're late soldier! Were you sleeping!? The team has already been deployed. You need to meet up with them!";
				} else {
					obj_commanding_officer sideChat "Thanks for joining us soldier! We just got reports in from our recon team. They've located the leader. We need to move in and take him alive.";
					sleep 10;
					obj_commanding_officer sideChat "Before you head out, make sure someone takes the command radio to my left on the ground. You'll need it to call for extract.";
				};
				sleep 7;
				if(g_helicopter_landed) then {
					obj_commanding_officer sideChat "FOB transportation is already here. Get on board, I'll brief you on the way.";
				} else {
					obj_commanding_officer sideChat "FOB transportation is inbound. I'll brief you on the way.";
				};
				[STG_PLAYER_COMPLETE_REPORT_IN_TASK] call GameLoopLocal;
				g_reported_in = true;
			};
		};
		
		// Wait for player to board the helicopter
		if(player in transport_heli) then {
			if( taskState g_report_in_task != "Succeeded" ) then {
				[STG_PLAYER_CANCEL_REPORT_IN_TASK] call GameLoopLocal;
			};
			[STG_PLAYER_COMPLETE_GET_IN_TASK] call GameLoopLocal;
			transport_heli sideChat "Welcome aboard. We'll be moving out out shortly.";
		} else {
			_returnValue = STG_PLAYER_BASE;
		};
		
	}
STAGE_END

STAGE("STG_PLAYER_INTRO") 
	INIT {
		g_player_seen_intro = false;
	}
	EXEC {
		if( !g_player_seen_intro ) then {
			g_player_seen_intro = true;
			0 fademusic 1;
			playmusic "LeadTrack01_F_EPA";
			sleep 8;
			sleep 2;
			 ["<t size='1.3'>" + "SA Presents" + "</t>",0.02,0.3,3,2,0,3011] spawn bis_fnc_dynamicText;
			sleep 12;
			 ["<t size='1.6'>" + "Operation Water Fire" + "</t>",0.02,0.3,3,2,0,3012] spawn bis_fnc_dynamicText;
			 sleep 12;
			obj_commanding_officer sideChat "Alright soldiers, listen up!";
			sleep 4;
			obj_commanding_officer sideChat "We heard from our recon team an hour ago that they've spotted the rebel leader near Air Station Mike. However, we've since lost contact with recon.";
			sleep 7;
			obj_commanding_officer sideChat "First, I need you to locate recon's camp and join up with them. They will provide you with the latest intel.";
			sleep 7;
			obj_commanding_officer sideChat "Second, you need to locate, capture alive and extract the rebel leader.";
			sleep 7;
			obj_commanding_officer sideChat "Your team leader will be able to call in for extract once you have the rebel leader in custody.";
			sleep 7;
			obj_commanding_officer sideChat "Be careful out there team. Rebel forces are spread across the island and will attack on sight. We don't have reports of hard targets, but stay alert and stay safe.";
			sleep 10;
			obj_commanding_officer sideChat "Once you arrive at the FOB, gear up and move out. There are boats waiting at the shore.";
		};
	}
STAGE_END

STAGE("STG_PLAYER_ARRIVE_AT_ISLAND") 
	INIT {
		[STG_PLAYER_ASSIGN_CAMP_TASK] call GameLoopLocal;
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_ARRIVE_AT_CAMP") 
	INIT {
		_randomPlayerName = [_this, 0, "you"] call BIS_fnc_param;
		[STG_PLAYER_COMPLETE_CAMP_TASK] call GameLoopLocal;
		sleep 5;
		player sideChat "HQ, this is alpha, we've secured the camp, but the recon team is down. Awaiting orders.";
		sleep 7;
		obj_commanding_officer sideChat "Copy that alpha. We're sending in UAV surveillance to try and gather additional intel. Hold your current position.";
		sleep 7;
		[[["<t size='1'>Your team sets up defences around the camp and awaits further orders from HQ.</t>",6],
			["<t size='1'>Unfortunately, " + _randomPlayerName + " forgot the marshmallows.</t>",4],
			["<t size='1'>09:00, Recon Camp</t>",6]],5,5] spawn SA_fnc_createBlackCutScene;
		sleep 5;
		setDate [2014, 1, 7, 9, 0];
		sleep 35;
		obj_commanding_officer sideChat "Rise and shine! I've marked on your map in red the suspected area of the rebel leader. Take him alive and then have your team lead call for extract.";
		sleep 10;
		[STG_PLAYER_ASSIGN_LEADER_TASK] call GameLoopLocal;
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_LEADER_SURRENDER") 
	INIT {
		[STG_PLAYER_COMPLETE_LEADER_TASK] call GameLoopLocal;
		["Warning",["","He's got a bomb. Get back!!"]] call BIS_fnc_showNotification;
		sleep 20;
		player sideChat "HQ, this is alpha, the rebel leader had a bomb. We had to back off. The rebel leader is down.";
		sleep 10;
		obj_commanding_officer sideChat "Damn it, he must have known we were coming. We need to get you out of there. Leave him behind.";
		sleep 10;
		obj_commanding_officer sideChat "Find a safe heli landing position and call in for extract asap.";
		sleep 10;
		[STG_PLAYER_ASSIGN_EXTRACT_TASK] call GameLoopLocal;
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_COMMAND_RADIO_NOTIFY") 
	INIT {}
	EXEC {
		obj_commanding_officer sideChat "Someone needs to take the command radio before you leave. It's on the ground next to me.";
	}
STAGE_END

STAGE("STG_PLAYER_TRANSPORT_LEAVING_BASE") 
	INIT {
		[STG_PLAYER_INTRO] spawn GameLoopLocal; 
	}
	EXEC {
		transport_heli sideChat "All aboard. We're moving out to the FOB.";
	}
STAGE_END

STAGE("STG_PLAYER_TRANSPORT_LEAVING_ISLAND") 
	INIT {}
	EXEC {
		transport_heli sideChat "Transport heading back to base. Stay safe soldiers!";
	}
STAGE_END

STAGE("STG_PLAYER_EXTRACT_LEAVING") 
	INIT {}
	EXEC {
		if( not ( isNil "g_extract_cancel_id" ) ) then {
			player removeAction g_extract_cancel_id;		
		};
		extract_heli sideChat "Hold on, we're moving out!";
		sleep 10;
		[STG_PLAYER_COMPLETE_EXTRACT_TASK] call GameLoopLocal;
		sleep 20;
		[[["<t size='1'>To be continued...</t>",60]],10,5] spawn SA_fnc_createBlackCutScene;
	}
STAGE_END

STAGE("STG_PLAYER_ASSIGN_CAMP_TASK") 
	INIT {
		private ["_showHint", "_assignTask"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		_assignTask = [_this, 1, true] call BIS_fnc_param;
		if( isNil "g_get_to_camp_task" ) then {
			g_get_to_camp_task = [player, "RECON_CAMP", "Reach Recon Camp", "Reach and Secure Recon Team's Camp", "Recon's Camp",getMarkerPos "camp_wp", _assignTask, _showHint] call SA_fnc_createLocalTask;
		};
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_COMPLETE_CAMP_TASK") 
	INIT {}
	EXEC {
		private ["_showHint"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		if( !isNil "g_get_to_camp_task" ) then {
			[g_get_to_camp_task, "Succeeded", _showHint] call SA_fnc_updateLocalTask;
		};
	}
STAGE_END

STAGE("STG_PLAYER_ASSIGN_LEADER_TASK") 
	INIT {
		private ["_showHint", "_assignTask"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		_assignTask = [_this, 1, true] call BIS_fnc_param;
		if( isNil "g_detain_leader" ) then {
			g_detain_leader = [player, "DETAIN_LOADER", "Detain Rebel Leader", "Locate and detain the rebel leader in Air Station", "Last Known Position",getMarkerPos "leader_wp", _assignTask, _showHint] call SA_fnc_createLocalTask;
		};
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_COMPLETE_LEADER_TASK") 
	INIT {}
	EXEC {
		private ["_showHint"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		if( !isNil "g_detain_leader" ) then {
			[g_detain_leader, "Succeeded", _showHint] call SA_fnc_updateLocalTask;
		};
	}
STAGE_END

STAGE("STG_PLAYER_ASSIGN_REPORT_IN_TASK") 
	INIT {
		private ["_showHint", "_assignTask"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		_assignTask = [_this, 1, true] call BIS_fnc_param;
		if( isNil "g_report_in_task" ) then {
			g_report_in_task = [player, "REPORT_IN", "Report In", "Report in with commanding officer", "Commanding Officer",getPos obj_commanding_officer, _assignTask, _showHint] call SA_fnc_createLocalTask;
		};
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_COMPLETE_REPORT_IN_TASK") 
	INIT {}
	EXEC {
		private ["_showHint"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		if( !isNil "g_report_in_task" ) then {
			[g_report_in_task, "Succeeded", _showHint] call SA_fnc_updateLocalTask;
		};
	}
STAGE_END

STAGE("STG_PLAYER_CANCEL_REPORT_IN_TASK") 
	INIT {}
	EXEC {
		private ["_showHint"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		if( !isNil "g_report_in_task" ) then {
			[g_report_in_task, "Canceled", _showHint] call SA_fnc_updateLocalTask;
		};
	}
STAGE_END

STAGE("STG_PLAYER_ASSIGN_GET_IN_TASK") 
	INIT {
		private ["_showHint", "_assignTask"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		_assignTask = [_this, 1, true] call BIS_fnc_param;
		if( isNil "g_get_in_task" ) then {
			g_get_in_task = [player, "GET_IN", "Board Helicopter", "Board the FOB transport helicopter", "Transport Helicopter",getPos base_heli_pad, _assignTask, _showHint] call SA_fnc_createLocalTask;
		};
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_COMPLETE_GET_IN_TASK") 
	INIT {}
	EXEC {
		private ["_showHint"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		if( !isNil "g_get_in_task" ) then {
			[g_get_in_task, "Succeeded", _showHint] call SA_fnc_updateLocalTask;
		};
	}
STAGE_END

STAGE("STG_PLAYER_ASSIGN_EXTRACT_TASK") 
	INIT {
		private ["_showHint", "_assignTask"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		_assignTask = [_this, 1, true] call BIS_fnc_param;
		if( isNil "g_extract_task" ) then {
			g_extract_task = [player, "EXTRACT", "Extract", "Leave the rebel leader behind and call for extract.", "Extract",getMarkerPos "leader_wp", _assignTask, _showHint] call SA_fnc_createLocalTask;
		};
	}
	EXEC {}
STAGE_END

STAGE("STG_PLAYER_COMPLETE_EXTRACT_TASK") 
	INIT {}
	EXEC {
		private ["_showHint"];
		_showHint = [_this, 0, true] call BIS_fnc_param;
		if( !isNil "g_extract_task" ) then {
			[g_extract_task, "Succeeded", _showHint] call SA_fnc_updateLocalTask;
		};
	}
STAGE_END