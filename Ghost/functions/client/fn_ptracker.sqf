/*
V1.2 By: Ghost
Creates markers that stay with the players until nil.
*/
//if (!isserver) exitwith {};

if (true) then {
	/*{
		[[0,0],"ColorBlue",_x] call fnc_ghst_mark_local;
		sleep 0.01;
	} forEach ghst_players;*/
	{
		[[0,0],"ColorGrey",_x] call fnc_ghst_mark_local;
		sleep 0.01;
	} forEach ghst_vehicles;
};

sleep 1;
while {true} do {
	//[] spawn ghstMarkerPlayers;
	[] spawn ghstMarkerVehicles;
	sleep 1;
};