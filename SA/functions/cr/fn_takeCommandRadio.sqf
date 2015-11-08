if(isServer) then {
	private ["_radio","_caller","_currentRadioOwner","_radioMarker"];
	_radio = [_this,0] call BIS_fnc_param;
	_caller = [_this,1] call BIS_fnc_param;
	_radioMarker = _radio getVariable "radio_marker";
	[_radio,_caller] call SA_fnc_setRadioOwner;
	_radio hideObjectGlobal true;
	{
		_x hideObjectGlobal true;
	} forEach attachedObjects _radio;
	_radioMarker setMarkerAlpha 0;
	[[],"SA_fnc_syncCommandRadioTasksLocal",true] spawn BIS_fnc_MP; 
};
