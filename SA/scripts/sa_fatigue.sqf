if(!isDedicated) then {

	if(alive player and ("PARAM_Fatigue" call BIS_fnc_getParamValue == 0)) then {
		player enableFatigue false;
	};

	player addEventHandler ["Respawn", {
		if(alive player and ("PARAM_Fatigue" call BIS_fnc_getParamValue == 0)) then {
			player enableFatigue false;
		};
	}];
	
};