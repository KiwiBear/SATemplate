/*
V1.3 script by: Ghost - Creates specified aircraft and flys to point on map specified by left click and drops ammo box.
ghst_ammodrop = [player,300,"airtype","objdrop",300,1800] execVM "ghst_ammodrop.sqf";
*/
if (!local player) exitwith {};

_host = _this select 0;
_dir = _this select 1;
_airtype = _this select 2;
_objdrop = _this select 3;
_flyheight = _this select 4;
_delay = (_this select 5) * 60;// time before ammo support can be called again

if (player getVariable "ghst_ammodrop") exitwith {player groupchat "Ammo Drop Busy";};

openMap true;

_host groupchat "Left click on the map where you want Ammo drop";

mapclick = false;

onMapSingleClick "clickpos = _pos; mapclick = true; onMapSingleClick """";true;";

waituntil {mapclick or !(visiblemap)};
if (!visibleMap) exitwith {
	hint "Ammo Drop Ready";
	};
_pos = [clickpos select 0, clickpos select 1, _flyheight];

sleep 1;

openMap false;

//hint format ["%1", _pos];

_airdrop1 = createGroup WEST;

_air1 = createVehicle [_airtype,[0,0,0], [], 0, "FLY"];
_air1 setdir _dir;
_air1 setVelocity [100, 0, 0];
_air1 setpos [getpos _air1 select 0, getpos _air1 select 1, _flyheight];
_crew = [_air1, _airdrop1] call BIS_fnc_SpawnCrew;
sleep 1;
_air1 flyinheight _flyheight;
_air1 setSpeedMode "Normal";

player setVariable ["ghst_ammodrop", true];

_air1 sidechat "I am inbound with your Ammo";

sleep 10;

_air1 setposatl [(_pos select 0), (_pos select 1)-1500, _flyheight];

While {(alive _air1) and (canmove _air1)} do {

_air1 domove _pos;

waituntil {(_air1 distance _pos) < (_flyheight + 100)};

_chute1 = createVehicle ["B_Parachute_02_F",[0,0,0], [], 0, "FLY"];
_chute1 setposatl [(getposatl _air1 select 0) -20, (getposatl _air1 select 1) -20, (getposatl _air1 select 2)]; 

_ghst_drop = createVehicle [_objdrop,[0,0,0], [], 0, "none"];

[[_ghst_drop],"SA_fnc_makeVirtualAmmo"] spawn BIS_fnc_MP;
		
_ghst_drop attachTo [_chute1,[0,0,0]];

_air1 domove [0,0,0];

	[_ghst_drop,_host] spawn {
	
		_crate = _this select 0;
		_host = _this select 1;
		
		waituntil {(getposatl _crate select 2) < 1.5}; 
		//detach _crate;
		_crate setposatl [getposatl _crate select 0,getposatl _crate select 1,0];
		_crate_name = "Ammo Box";//getText (configFile >> "cfgVehicles" >> (_droptype) >> "displayName");
		[_crate, "ColorBlack", _crate_name] spawn ghst_fnc_tracker;
		//_crate call ghst_fnc_magazines;
		_chem = createMine ["placed_chemlight_green", (position _crate), [], 0];
		sleep 3;
		_chem attachto [_crate,[0,0,0.1]];
				
	};

if (true) exitwith {};
};
_air1 sidechat "Ammo drop complete heading home";

sleep 120;

{deletevehicle _x} foreach crew _air1;
deletevehicle _air1;
sleep 5;
deletegroup _airdrop1;

sleep _delay;

hint "Ammo Drop Ready";

player setVariable ["ghst_ammodrop", false];

if (true) exitwith {};