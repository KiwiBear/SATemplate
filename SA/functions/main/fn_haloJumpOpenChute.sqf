private ["_unit","_para","_vel","_cut_chute_action"];
_unit = [_this,0] call BIS_fnc_param;

//titleCut ["", "BLACK IN", 2];

if (_unit == player) then {

	if(bis_fnc_halo_has_main) then {
		_para = "Steerable_Parachute_F" createVehicle position _unit;
		_para setpos position _unit;
		_para setdir direction _unit;
		_vel = velocity _unit;
		_unit moveindriver _para;
		_para lock false;
	};
	
	if(!bis_fnc_halo_has_main && bis_fnc_halo_has_reserve) then {
		_para = "NonSteerable_Parachute_F" createVehicle position _unit;
		_para setpos position _unit;
		_para setdir direction _unit;
		_vel = velocity _unit;
		_unit moveindriver _para;
		_para lock false;
	};

} else {
	_para = "NonSteerable_Parachute_F" createVehicle position _unit;
	_para setpos position _unit;
	_para setdir direction _unit;
	_vel = velocity _unit;
	_unit moveindriver _para;
	_para lock false;
};

//--- Key controls
if (_unit == player && (bis_fnc_halo_has_main || bis_fnc_halo_has_reserve)) then {

	bis_fnc_chute_keydown = {
		_key = _this select 1;
		if (_key == 157 && bis_fnc_halo_has_main) then {
			bis_fnc_chute_cut_pressed = true;
		};
	};
	
	bis_fnc_chute_cut_pressed = false;

	bis_fnc_chute_keydown_eh = (finddisplay 46) displayaddeventhandler ["keydown","_this call bis_fnc_chute_keydown;"];

	_para setvelocity [(_vel select 0),(_vel select 1),(_vel select 2)];

	bis_fnc_halo_DynamicBlur = ppeffectcreate ["DynamicBlur",464];
	bis_fnc_halo_DynamicBlur ppEffectEnable true;
	bis_fnc_halo_DynamicBlur ppEffectAdjust [8.0];
	bis_fnc_halo_DynamicBlur ppEffectCommit 0;
	bis_fnc_halo_DynamicBlur ppEffectAdjust [0.0];
	bis_fnc_halo_DynamicBlur ppEffectCommit 1;

	sleep 4;

	ppeffectdestroy bis_fnc_halo_DynamicBlur;
	
	_mainFail = floor(random 25);
	
	waituntil {(position vehicle player select 2) < 2 || bis_fnc_chute_cut_pressed || (_mainFail == 1 && bis_fnc_halo_has_main)};
	
	(finddisplay 46) displayremoveeventhandler ["keydown",bis_fnc_chute_keydown_eh];
	
	bis_fnc_halo_para_vel = nil;
	bis_fnc_halo_para_velLimit = nil;
	bis_fnc_halo_para_velAdd = nil;
	bis_fnc_halo_para_dir = nil;
	bis_fnc_halo_para_dirLimit = nil;
	bis_fnc_halo_para_dirAdd = nil;
	bis_fnc_halo_para_keydown = nil;
	bis_fnc_halo_para_loop = nil;
	bis_fnc_halo_para_keydown_eh = nil;
	bis_fnc_halo_para_mousemoving_eh = nil;
	bis_fnc_halo_para_mouseholding_eh = nil;
	
	if(bis_fnc_chute_cut_pressed || (_mainFail == 1 && bis_fnc_halo_has_main)) then {
		if(bis_fnc_halo_has_main) then {
			bis_fnc_halo_has_main = false;
			if(_mainFail == 1) then {
				["Warning",["","Main Chute Failure! Pull Reserve!"]] call BIS_fnc_showNotification;
			} else {
				["Warning",["","Main Cut - Pull Reserve!"]] call BIS_fnc_showNotification;
			};
		} else {
			bis_fnc_halo_has_reserve = false;
			["Death",["","Reserve Cut - Goodbye!"]] call BIS_fnc_showNotification;
		};
		[player, (getPos player) select 2, (getPos player), 0, false] spawn SA_fnc_haloJump;
	};
	
};