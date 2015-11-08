_unit = [_this,0,player] call BIS_fnc_param;
_alt = [_this,1,4000] call BIS_fnc_param;
_position = [_this,2,position _unit] call BIS_fnc_param;
_autoChuteAlt = [_this,3,300] call BIS_fnc_param;
_isNewJump = [_this,4,true] call BIS_fnc_param;

if(_isNewJump) then {
	_unit allowDamage false;
	[_unit] spawn { sleep 1; (_this select 0) allowDamage true;};
};

// Delete parachute if currently attached
if((vehicle _unit) iskindof "ParachuteBase") then {
	_parachute = vehicle _unit;
	if (_parachute != _unit) then {
		deletevehicle _parachute;
	};
} else {
	_unit setpos [_position select 0,_position select 1,_alt];
};

_irs = "NVG_TargetC" createVehicle [0,0,0];
_irs attachTo [_unit, [0,-0.03,0.07], "LeftShoulder"];

//--- Init
_dir = ([[0,0,0],velocity _unit] call bis_fnc_dirto);
_unit setdir _dir;
_unit switchmove "HaloFreeFall_non";

//--- Key controls
if (_unit == player) then {
	//--- PLAYER ------------------------------------------------

	if(_isNewJump) then {
		bis_fnc_halo_has_main = true;
		bis_fnc_halo_has_reserve = true;
		bis_fnc_halo_auto_deploy = true;
	};
	
	_brightness = 0.99;
	_pos = position player;
	_parray = [
	/* 00 */		["\A3\data_f\ParticleEffects\Universal\Universal", 16, 12, 13, 0],
	/* 01 */		"",
	/* 02 */		"Billboard",
	/* 03 */		1,
	/* 04 */		3,
	/* 05 */		[0,0,-200],
	/* 06 */		wind,
	/* 07 */		0,
	/* 08 */		1.275,
	/* 09 */		1,
	/* 10 */		0,
	/* 11 */		[100],
	/* 12 */		[
						[_brightness,_brightness,_brightness,0],
						[_brightness,_brightness,_brightness,0.01],
						[_brightness,_brightness,_brightness,0.10],
						[_brightness,_brightness,_brightness,0]
					],
	/* 13 */		[1000],
	/* 14 */		0,
	/* 15 */		0,
	/* 16 */		"",
	/* 17 */		"",
	/* 18 */		player
	];
	bis_fnc_halo_clouds = "#particlesource" createVehicleLocal _pos;  
	bis_fnc_halo_clouds setParticleParams _parray;
	bis_fnc_halo_clouds setParticleRandom [0, [100, 100, 0], [0, 0, 0], 0, 0, [0, 0, 0, 0], 0, 1];
	bis_fnc_halo_clouds setParticleCircle [00, [00, 00, 00]];
	bis_fnc_halo_clouds setDropInterval (0.4 - (0.3 * overcast));


	//--- Effects
	bis_fnc_halo_ppRadialBlur = ppeffectcreate ["RadialBlur",464];
	bis_fnc_halo_ppRadialBlur ppEffectAdjust [0.01,0.01,0.3,0.3];
	bis_fnc_halo_ppRadialBlur ppEffectCommit 0.01;
	bis_fnc_halo_ppRadialBlur ppEffectEnable true ; 
	bis_fnc_halo_soundLoop = time;
	playsound "BIS_HALO_Flapping";

	bis_fnc_halo_action = _unit addaction ["Open Main Chute",{ if((position player select 2) > 50) then {[_this select 0] spawn SA_fnc_haloJumpOpenChute;}; },[],1,false,true,"","bis_fnc_halo_has_main" ];
	bis_fnc_halo_action2 = _unit addaction ["Open Reserve Chute",{ if((position player select 2) > 50) then {[_this select 0] spawn SA_fnc_haloJumpOpenChute;}; },[],1,false,true,"","!bis_fnc_halo_has_main && bis_fnc_halo_has_reserve"];
	bis_fnc_halo_action3 = _unit addaction [format ["Enable Auto Deploy (%1m)", _autoChuteAlt],{ bis_fnc_halo_auto_deploy = true },[],1,false,true,"","bis_fnc_halo_has_main && !bis_fnc_halo_auto_deploy" ];
	bis_fnc_halo_action4 = _unit addaction [format ["Disable Auto Deploy (%1m)", _autoChuteAlt],{ bis_fnc_halo_auto_deploy = false },[],1,false,true,"","bis_fnc_halo_has_main && bis_fnc_halo_auto_deploy" ];
	
	bis_fnc_halo_forward_pressed = false;
	bis_fnc_halo_backward_pressed = false;
	bis_fnc_halo_up_pressed = false;
	bis_fnc_halo_down_pressed = false;
	
	bis_fnc_halo_keydown = {
		_key = _this select 1;

		//--- Forward
		//if (_key in (actionkeys 'HeliForward')) then {
		if (_key in (actionkeys 'MoveForward')) then {
			if (bis_fnc_halo_vel < +bis_fnc_halo_velLimit) then {bis_fnc_halo_vel = bis_fnc_halo_vel + bis_fnc_halo_velAdd};
			bis_fnc_halo_forward_pressed = true;
		};

		//--- Backward
		//if (_key in (actionkeys 'HeliBack')) then {
		if (_key in (actionkeys 'MoveBack')) then {
			if (bis_fnc_halo_vel > -bis_fnc_halo_velLimit) then {bis_fnc_halo_vel = bis_fnc_halo_vel - bis_fnc_halo_velAdd};
			bis_fnc_halo_backward_pressed = true;
		};

		//--- Left
		//if (_key in (actionkeys 'HeliCyclicLeft')) then {
		if (_key in (actionkeys 'TurnLeft')) then {
			if (bis_fnc_halo_dir > -bis_fnc_halo_dirLimit) then {bis_fnc_halo_dir = bis_fnc_halo_dir - bis_fnc_halo_dirAdd};
		};

		//--- Right
		//if (_key in (actionkeys 'HeliCyclicRight')) then {
		if (_key in (actionkeys 'TurnRight')) then {
			if (bis_fnc_halo_dir < +bis_fnc_halo_dirLimit) then {bis_fnc_halo_dir = bis_fnc_halo_dir + bis_fnc_halo_dirAdd};
		};
		
		if(abs bis_fnc_halo_freefall_vel < bis_fnc_halo_freefallLimit) then {
			//--- Speed Up Freefall
			if (_key == 42) then {
				bis_fnc_halo_freefall_vel = bis_fnc_halo_freefall_vel - bis_fnc_halo_freefallAdd;
				bis_fnc_halo_up_pressed = true;
			};
			
			//--- Slow Down Freefall
			if (_key == 44) then {
				bis_fnc_halo_freefall_vel = bis_fnc_halo_freefall_vel + bis_fnc_halo_freefallAdd;
				bis_fnc_halo_down_pressed = true;
			};
		};
	};
	
	bis_fnc_halo_keyup = {
		_key = _this select 1;

		//--- Forward
		if (_key in (actionkeys 'MoveForward')) then {
			bis_fnc_halo_forward_pressed = false;
		};

		//--- Backward
		if (_key in (actionkeys 'MoveBack')) then {
			bis_fnc_halo_backward_pressed = false;
		};

		//--- Speed Up Freefall
		if (_key == 42) then {
			bis_fnc_halo_up_pressed = false;
		};
		
		//--- Slow Down Freefall
		if (_key == 44) then {
			bis_fnc_halo_down_pressed = false;
		};

	};
	
	bis_fnc_halo_keydown_eh = (finddisplay 46) displayaddeventhandler ["keydown","_this call bis_fnc_halo_keydown;"];
	bis_fnc_halo_keyup_eh = (finddisplay 46) displayaddeventhandler ["keyup","_this call bis_fnc_halo_keyup;"];

	//--- Loop
	bis_fnc_halo_vel = 0;
	bis_fnc_halo_freefall_vel = 0;
	bis_fnc_halo_velLimit = 0.2;
	bis_fnc_halo_velAdd = 0.03;
	bis_fnc_halo_dir = 0;
	bis_fnc_halo_dirLimit = 1;
	bis_fnc_halo_dirAdd = 0.06;
	bis_fnc_halo_freefallAdd = 0.06;
	bis_fnc_halo_freefallLimit = 1;

	_time = time - 0.1;
	_autoDeployChute = false;
	while {alive player && vehicle player == player && !_autoDeployChute} do {

		//--- FPS counter
		_fpsCoef = ((time - _time) * 60) / acctime; //Script is optimized for 60 FPS
		_time = time;

		bis_fnc_halo_velLimit = 0.2 * _fpsCoef;
		bis_fnc_halo_velAdd = 0.03 * _fpsCoef;
		bis_fnc_halo_dirLimit = 1 * _fpsCoef;
		bis_fnc_halo_freefallLimit = 1 * _fpsCoef;
		bis_fnc_halo_dirAdd = 0.06 * _fpsCoef;
		bis_fnc_halo_freefallAdd = 0.06 * _fpsCoef;
		
		if(!bis_fnc_halo_up_pressed && !bis_fnc_halo_down_pressed) then {
			if(bis_fnc_halo_freefall_vel < 0) then {
				bis_fnc_halo_freefall_vel = bis_fnc_halo_freefall_vel + bis_fnc_halo_freefallAdd;
			};
			if(bis_fnc_halo_freefall_vel > 0) then {
				bis_fnc_halo_freefall_vel = bis_fnc_halo_freefall_vel - bis_fnc_halo_freefallAdd;
			};
			if(abs bis_fnc_halo_freefall_vel < bis_fnc_halo_freefallAdd && bis_fnc_halo_freefall_vel != 0) then {
				bis_fnc_halo_freefall_vel = 0;
			};
		};
		
		if(!bis_fnc_halo_forward_pressed && !bis_fnc_halo_backward_pressed) then {
			if(bis_fnc_halo_vel < 0) then {
				bis_fnc_halo_vel = bis_fnc_halo_vel + bis_fnc_halo_dirAdd;
			};
			if(bis_fnc_halo_vel > 0) then {
				bis_fnc_halo_vel = bis_fnc_halo_vel - bis_fnc_halo_dirAdd;
			};
			if(abs bis_fnc_halo_vel < bis_fnc_halo_dirAdd && bis_fnc_halo_vel != 0) then {
				bis_fnc_halo_vel = 0;
			};
		};
		
		//--- Dir
		bis_fnc_halo_dir = bis_fnc_halo_dir * 0.98;
		_dir = direction player + bis_fnc_halo_dir;
		player setdir _dir;

		//--- Velocity
		_vel = velocity player;
		bis_fnc_halo_vel = bis_fnc_halo_vel * 0.96;
		bis_fnc_halo_freefall_vel = bis_fnc_halo_freefall_vel * 0.96;
		_bis_freefall_vel = (_vel select 2);
		if(_bis_freefall_vel <= -63) then {
			_bis_freefall_vel = (-72 max ((_vel select 2) + bis_fnc_halo_freefall_vel)) min -63;
		};
		player setvelocity [
			(_vel select 0) + (sin _dir * bis_fnc_halo_vel),
			(_vel select 1) + (cos _dir * bis_fnc_halo_vel),
			_bis_freefall_vel
		];
		
		//--- Animation system
		_anim = "HaloFreeFall_non";
		_v = bis_fnc_halo_vel;
		_h = bis_fnc_halo_dir;

		_vLimit = 0.1;
		_hLimit = 0.3;
		if ((abs _v) > _vLimit || (abs _h) > _hLimit) then {
			_vAnim = "";
			if (_v > +_vLimit) then {_vAnim = "F"};
			if (_v < -_vLimit) then {_vAnim = "B"};
			_hAnim = "";
			if (_h > +_hLimit) then {_hAnim = "R"};
			if (_h < -_hLimit) then {_hAnim = "L"};
			_anim = "HaloFreeFall_" + _vAnim + _hAnim;
		};

		player playmovenow _anim;

		//--- Sound
		if ((time - bis_fnc_halo_soundLoop) > 4.5) then {
			playsound "BIS_HALO_Flapping";
			bis_fnc_halo_soundLoop = time;
		};

		//--- Effects
		bis_fnc_halo_ppRadialBlur ppEffectAdjust [0.02,0.02,0.3 - (bis_fnc_halo_vel/7)/_fpsCoef,0.3 - (bis_fnc_halo_vel/7)/_fpsCoef];
		bis_fnc_halo_ppRadialBlur ppEffectCommit 0.01;

		if((position player select 2) < _autoChuteAlt && bis_fnc_halo_auto_deploy) then {
			_autoDeployChute = true;
		};

		sleep 0.01;
	};
	
	if (!alive player) then {
		player switchmove "adthppnemstpsraswrfldnon_1";
		player setvelocity [0,0,0];
	};
	
	//--- End
	player removeaction bis_fnc_halo_action;
	player removeaction bis_fnc_halo_action2;
	player removeaction bis_fnc_halo_action3;
	player removeaction bis_fnc_halo_action4;
	(finddisplay 46) displayremoveeventhandler ["keydown",bis_fnc_halo_keydown_eh];
	(finddisplay 46) displayremoveeventhandler ["keyup",bis_fnc_halo_keyup_eh];
	ppeffectdestroy bis_fnc_halo_ppRadialBlur;
	deletevehicle bis_fnc_halo_clouds;

	bis_fnc_halo_clouds = nil;
	bis_fnc_halo_vel = nil;
	bis_fnc_halo_velLimit = nil;
	bis_fnc_halo_velAdd = nil;
	bis_fnc_halo_dir = nil;
	bis_fnc_halo_dirLimit = nil;
	bis_fnc_halo_dirAdd = nil;
	bis_fnc_halo_action = nil;
	bis_fnc_halo_action2 = nil;
	bis_fnc_halo_action3 = nil;
	bis_fnc_halo_action4 = nil;
	bis_fnc_halo_keydown = nil;
	bis_fnc_halo_keydown_eh = nil;
	bis_fnc_halo_keyup_eh = nil;
	
	deleteVehicle _irs;
	
	if(_autoDeployChute && (position player select 2) > 50) then {
		[player] spawn SA_fnc_haloJumpOpenChute;
	};

} else {
	//--- AI ------------------------------------------------
	while {(position _unit select 2) > 100 + (random 100)} do {
		_destination = expecteddestination _unit select 0;
		if ([position _unit select 0,position _unit  select 1,0] distance [_position select 0,_position select 1,0] > 100) then {
			_vel = velocity _unit;
			_dirTo = [[position _unit select 0,position _unit  select 1,0],[_position select 0,_position select 1,0]] call bis_fnc_dirto;
			_unit setdir _dirTo;
			_unit setvelocity [
				(_vel select 0) + (sin _dirTo * 0.2),
				(_vel select 1) + (cos _dirTo * 0.2),
				(_vel select 2)
			];
		};
		sleep 0.01;
	};

	[_unit] spawn SA_fnc_haloJumpOpenChute;
	
	deleteVehicle _irs;
};
