/*
	@version: 2.0
	@file_name: fn_mainInit.sqf
	@file_author: TAW_Tonic
	@file_edit: 9/24/2013
	@file_description: Only called once during the initialization of VAS and uses compileFinal on all VAS functions.
*/
[] spawn
{
	if(isNil "VAS_init_complete") then
	{
		private["_handle"];
		VAS_init_timeOnStart = time;
		VAS_init_complete = false;
		_handle = [] execVM "VAS\config.sqf";
		waitUntil {scriptDone _handle;};
		if(isNil "VAS_fnc_buildConfig") exitWith {diag_log "::VAS:: function VAS_fnc_buildConfig is nil"};
		["CfgWeapons"] call VAS_fnc_buildConfig;
		["CfgMagazines"] call VAS_fnc_buildConfig;
		["CfgVehicles"] call VAS_fnc_buildConfig;
		["CfgGlasses"] call VAS_fnc_buildConfig;
		VAS_init_complete = true;
	}
		else
	{
		VAS_init_timeOnStart = time;
		[] call compile PreprocessFileLineNumbers "VAS\config.sqf";
		["CfgWeapons"] call VAS_fnc_buildConfig;
		["CfgMagazines"] call VAS_fnc_buildConfig;
		["CfgVehicles"] call VAS_fnc_buildConfig;
		["CfgGlasses"] call VAS_fnc_buildConfig;
		
		sleep 2.5;
		if(!isNil "vas_r_weapons") then { VAS_init_complete = true; };
	};
	
	waitUntil {!isNull player && player == player};
	if(player diarySubjectExists "VAS")exitwith{};
	player createDiarySubject ["VAS","Virtual Ammobox System (VAS)"];
	player createDiaryRecord["VAS",
		[
			"Virtual Ammobox System (VAS) v2.0",
				"
					Virtual Ammobox System (VAS) is a virtual ammobox inventory system created by Tonic AKA TAW_Tonic. If you have any problems with VAS please report them on the forums.<br/>
					<br/>
					Virtual Ammobox BIS Topic:
					http://forums.bistudio.com/showthread.php?149077-Virtual-Ammobox-System-%28VAS%29
					<br/>
					<br/>
					<p>
					<h1>
					Credits and Thanks:<br/>
					Kronzky - For his string function library<br/>
					SaMatra - For help with UI Resources and Russian Translation<br/>
					Dslyecxi - For his Paper doll giving insight on how to detect item types.<br/>
					Tyrghen on Armaholic - For giving me the tip about CfgFunctions<br/>
					naong - For his code tweaks to the Load / Save display.<br/>
					Coding from armaholic - Translation of VAS from English->German<br/>
					El nabot from Armaholic - Translation of VAS from English->French<br/>
					czesiek77 from Armaholic - Translation of VAS from English->Polish<br/>
					Ficc from BIS Forums - Translation of VAS from English->Portuguese<br/>
					ramius86 on BIS Forums - Translation of VAS from English->Italian<br/>
					RabsRincon on Armaholic - Translation of VAS from English->Spanish<br/>
					Bakarda on BIS/Armaholic - Translation of VAS from English->Czech<br/>
					</p>
					</h1>
				"
		]
	];
	
	// Script to support configuring your group's units using VAS (when you're < 50m from a VAS container)
	if(!isDedicated && vas_group_config) then {
		[] spawn {
		
			private ["_unitsWithActions","_nearVasContainer"];
			_unitsWithActions = [];
			_nearVasContainer = false;
			
			while {true} do { 
			
				if( [player,25] call VAS_fnc_unitNearVasContainer || (_nearVasContainer && [player,50] call VAS_fnc_unitNearVasContainer)) then {

					private ["_unitsRequiringActions","_groupUnits","_unitsToAddAction","_configureGearAction","_unitsToRemoveAction"];
					
					// Find units requiring actions
					_unitsRequiringActions = [];
					_groupUnits = (units group player);
					{
						if(vehicle _x == _x && _x != player && alive _x && _x distance player < 50) then {
							_unitsRequiringActions pushBack _x;
						};
					} forEach _groupUnits;
					
					// Find units needing actions added and add them
					_unitsToAddAction = _unitsRequiringActions - _unitsWithActions;
					{
						_configureGearAction = _x addAction ["Configure Gear (VAS)", { 
							private ["_unit","_closestVasContainer"];
							_unit = param [0];
							_closestVasContainer = [_unit] call VAS_fnc_closestVasContainer;
							[_unit,_closestVasContainer] call VAS_fnc_openVAS;
						}];
						_x setVariable ["VAS_configureGearAction", _configureGearAction];
						_unitsWithActions pushBack _x;
					} forEach _unitsToAddAction;
					
					// Find units needing actions removed and remove them
					_unitsToRemoveAction = _unitsWithActions - _unitsRequiringActions;
					{
						_configureGearAction = _x getVariable ["VAS_configureGearAction", nil];
						if(!isNil "_configureGearAction") then {
							_x removeAction _configureGearAction;
							_x setVariable ["VAS_configureGearAction", nil];
						};
						_unitsWithActions = _unitsWithActions - [_x];
					} forEach _unitsToRemoveAction;
					
					_nearVasContainer = true;
					
				} else {
				
					private ["_configureGearAction"];
					
					// Remove actions from all units with actions
					{
						_configureGearAction = _x getVariable ["VAS_configureGearAction", nil];
						if(!isNil "_configureGearAction") then {
							_x removeAction _configureGearAction;
							_x setVariable ["VAS_configureGearAction", nil];
						};
						_unitsWithActions = _unitsWithActions - [_x];
					} forEach _unitsWithActions;
					
					_nearVasContainer = false;
				
				};
				
				sleep 3;
				
			};
			
		};
	};
};