ghst_c4_array = [];
player addAction ["<t size='1.5' shadow='2' color='#FEE093'>Attach C4</t> <img size='2' shadow='2' image='\A3\Weapons_F\Data\UI\gear_c4_charge_small_CA.paa'/>", {
player playActionNow "PutDown";
_explosive = ["DemoCharge_Remote_Ammo_Scripted","DemoCharge_Remote_Mag"] call fnc_ghst_bombplace;
if (isnull _explosive) exitwith {hint "Cannot Attach Charge";};
_cn = count ghst_c4_array;
ghst_c4_array set [_cn, _explosive];
player addAction [format ["<t size='1.5' shadow='2' color='#B22222'>Detonate C4 #%1</t> <img size='3' shadow='2' image='\A3\Weapons_F\Data\UI\gear_c4_charge_small_CA.paa'/>", _cn + 1], {
	_array = _this select 3;
		_explosive = _array select 0;
		_cn = _array select 1;
	player removeAction (_this select 2);
		if !(isnull _explosive) then {
			detach _explosive;
			_explosive setDamage 1;
			ghst_c4_array set [_cn, -1];
			ghst_c4_array = ghst_c4_array - [-1];
		} else {
			ghst_c4_array = ghst_c4_array - [objnull];
		};
}, [_explosive,_cn], 5, false, true, "","vehicle _this == _target"];
}, [], 1, false, true, "","'DemoCharge_Remote_Mag' in magazines _target and vehicle _this == _target"];

ghst_satchel_array = [];
player addAction ["<t size='1.5' shadow='2' color='#FEE093'>Attach Satchel</t> <img size='2' shadow='2' image='\A3\Weapons_f\data\UI\gear_satchel_CA.paa'/>", {
player playActionNow "PutDown";
_explosive = ["SatchelCharge_Remote_Ammo_Scripted","SatchelCharge_Remote_Mag"] call fnc_ghst_bombplace;
if (isnull _explosive) exitwith {hint "Cannot Attach Charge";};
_sn = count ghst_satchel_array;
ghst_satchel_array set [_sn, _explosive];
player addAction [format ["<t size='1.5' shadow='2' color='#B22222'>Detonate Satchel #%1</t> <img size='3' shadow='2' image='\A3\Weapons_f\data\UI\gear_satchel_CA.paa'/>", _sn + 1], {
	_array = _this select 3;
		_explosive = _array select 0;
		_sn = _array select 1;
	player removeAction (_this select 2);
		if !(isnull _explosive) then {
			detach _explosive;
			_explosive setDamage 1;
			ghst_satchel_array set [_sn, -1];
			ghst_satchel_array = ghst_satchel_array - [-1];
		} else {
			ghst_satchel_array = ghst_satchel_array - [objnull];
		};
}, [_explosive,_sn], 5, false, true, "","vehicle _this == _target"];
}, [], 1, false, true, "","'SatchelCharge_Remote_Mag' in magazines _target and vehicle _this == _target"];

player addAction["<t size='1.5' shadow='2' color='#ffa200'>Virtual Ammobox</t>", "VAS\open.sqf", [], 1, false, true, "","alive _target and (getposatl player distance getposatl base) < 150"];

//this addaction ["Open Virtual Arsenal", { ["Open",true] call BIS_fnc_arsenal; }];  
player addaction ["<t size='1.5' shadow='2' color='#ffffff'>Open Virtual Arsenal</t>", { ["Open",true] call BIS_fnc_arsenal; }, [], 1, false, true, "","alive _target and (getposatl player distance getposatl base) < 150"];