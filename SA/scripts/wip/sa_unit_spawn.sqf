/*
	Author: [SA] Duda
	
	Description:
	Get a list of all units from cfgvehicles
	
	Parameters:
	
	Returns:
	ARRAY: [["ClassName","DisplayName"],...]
*/
SA_fnc_unitList = {
	private ["_unitList","_unitNames","_cfgvehicles","_vehicle","_className","_displayName","_side"];
	_unitList = [];
	_unitNames = [];
	_cfgvehicles = configFile >> "cfgvehicles";
	for "_i" from 0 to (count _cfgvehicles)-1 do {
		_vehicle = _cfgvehicles select _i;
		if (isClass _vehicle) then {
			_className = configName(_vehicle);
			_displayName = getText(configFile >> "cfgvehicles" >> _wCName >> "displayName");
			_side = getNumber(configFile >> "cfgvehicles" >> _wCName >> "side");
			if ((_className isKindOf "Man") && (_side == 1) && (_displayName!="")) then {
				if !(_displayName in _unitNames) then {
					_unitList = _unitList + [[_className,_displayName]];
					_unitNames = _unitNames + [_displayName];
				};
			};
		};
	};
	_unitList;
};


