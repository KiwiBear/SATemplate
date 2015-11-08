_vehicleList = [];
_namelist = [];

_cfgvehicles = configFile >> "cfgvehicles";

_PARAM_JET = "PARAM_JET" call BIS_fnc_getParamValue;
_PARAM_MH47E = "PARAM_MH47E" call BIS_fnc_getParamValue;

for "_i" from 0 to (count _cfgvehicles)-1 do {
	_vehicle = _cfgvehicles select _i;
	if (isClass _vehicle) then {
		_wCName = configName(_vehicle);
		_wDName = getText(configFile >> "cfgvehicles" >> _wCName >> "displayName");
		_wModel = getText(configFile >> "cfgvehicles" >> _wCName >> "model");
		_wType = getNumber(configFile >> "cfgvehicles" >> _wCName >> "type");
		_wside = getnumber(configFile >> "cfgvehicles" >> _wCName >> "side");
		_wscope = getnumber(configFile >> "cfgvehicles" >> _wCName >> "scope");
		_wfaction = getText(configFile >> "cfgvehicles" >> _wCName >> "faction");
		_wPic =  getText(configFile >> "cfgvehicles" >> _wCName >> "picture");
		_wDesc = getText(configFile >> "cfgvehicles" >> _wCName >> "Library" >> "libTextDesc");	

		if (((_wCName iskindof "Helicopter_Base_F") or (_wCName iskindof "Plane_Base_F")) && ((_wside == 1) or (_wside == 2)) && (_wscope == 2) && ((_wfaction == "BLU_F") or (_wfaction == "IND_F")) && (_wDName!="") && !(_wCName iskindof "ParachuteBase") && !(_wCName iskindof "UAV_01_base_F") && (_wModel!="") && (_wpic!="")) then {
			/*
			if (_wfaction == "USMC") then {
				_wDName = _wDName + " USMC";
			};
			if (_wfaction == "BIS_US") then {
				_wDName = _wDName + " US ARMY";
			};
			if (_wCName iskindof "AH64D_Sidewinders") then {
				_wDName = _wDName + " Sidewinders";
			};
			*/
			if !(_wDName in _namelist) then {
				_vehicleList = _vehicleList + [[_wCName,_wDName,_wPic,_wDesc]];
				_namelist = _namelist + [_wDName];
			};
		};
		//Spawn JS JC FA18 mod jets if selected
		if ((_PARAM_JET == 1) and ((_wCName iskindof "JS_JC_FA18E") or (_wCName iskindof "JS_JC_FA18F"))) then {
			if !(_wDName in _namelist) then {
				_vehicleList = _vehicleList + [[_wCName,_wDName,_wPic,_wDesc]];
				_namelist = _namelist + [_wDName];
			};
		};
		//Spawn Koyo MH47E mod if selected
		if ((_PARAM_MH47E == 1) and ((_wCName iskindof "kyo_MH47E_HC") or (_wCName iskindof "kyo_MH47E_base")) && !(_wCName iskindof "kyo_CH47_HC3")) then {
			if !(_wDName in _namelist) then {
				_vehicleList = _vehicleList + [[_wCName,_wDName,_wPic,_wDesc]];
				_namelist = _namelist + [_wDName];
			};
		};
	};
	/*if (_i % 10==0) then {
		hintsilent format["Loading Vehicle List... (%1)",count _vehicleList];
		sleep .0001;
};*/
};
hint "";
_namelist=nil;

ghst_aircraftlist = _vehicleList;

//publicvariable "ghst_aircraftlist";

//hint "aircraft list ready";
/*
for "_x" from 0 to (count _vehiclelist)-1 do {

diag_log format ["%1",_vehicleList select _x];

};
*/