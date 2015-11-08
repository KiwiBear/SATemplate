if(!isDedicated) then {

	[] spawn {
		while {true} do {
			player setVariable ["sa_players_with_names", [{_x distance player < 300 && _x != player}] call SA_fnc_getPlayableUnits];
			sleep 15;
		};
	};

	addMissionEventHandler ["Draw3D", {
		{
			if(alive _x) then {
				_isCurrentlyTalking = _x getVariable ["sa_is_talking", false];
				if(_isCurrentlyTalking) then {
					drawIcon3D [
						"\A3\ui_f\data\gui\Rsc\RscDisplayArsenal\voice_ca.paa",
						[1,0,0,0.5],
						[
							(getPosATLVisual _x) select 0,
							(getPosATLVisual _x) select 1, 
							(((visiblePositionASL _x) select 2) min ((getPosATLVisual _x) select 2)) + 2.5
						],
						1,
						1,
						0,
						(name _x),
						0,
						0.03, 
						"PuristaLight"
					];
				} else {
					drawIcon3D [
						"",
						[1,1,1,0.5],
						[
							(getPosATLVisual _x) select 0,
							(getPosATLVisual _x) select 1, 
							(((visiblePositionASL _x) select 2) min ((getPosATLVisual _x) select 2)) + 2.5
						],
						0,
						0,
						0,
						(name _x),
						0,
						0.03, 
						"PuristaLight"
					];
				};
			};
		} forEach (player getVariable ["sa_players_with_names",[]]);
	}];
};
