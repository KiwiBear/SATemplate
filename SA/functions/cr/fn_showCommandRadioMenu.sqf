private ["_owner","_radio"];
_owner = [_this,0] call BIS_fnc_param;
_radio = [_owner] call SA_fnc_getOwnerRadio;
if( not( isNull _radio ) ) then {
	[[_owner,_radio],"SA_fnc_showCommandRadioMenuLocal",_owner] spawn BIS_fnc_MP; 
};

