[markerPos (_this select 0), [[1,"Take High Command","FUNC_takeHC",true,true,false],[2,"Release High Command","FUNC_releaseHC",true,false,true]], false, 1] call SA_fnc_createCommandRadio;

if(isServer) then {
	{ hcRemoveAllGroups (hcLeader _x); } foreach allGroups;
	//high_command_module setvariable ["radios",[1,2,3,4,5,6,7,8,9,0],true];
};

FUNC_takeHC = {
	private ["_owner"];
	_owner = [_this,0] call BIS_fnc_param;
	{ hcRemoveAllGroups (hcLeader _x); } foreach allGroups;
	private ["_linkedLogic","_subordinate","_linkedSubordinate","_group","_groupColor"];
	_linkedLogic = synchronizedObjects high_command_module;
	if (count _linkedLogic > 0) then {
		{
			if (typeof _x == "HighCommandSubordinate") then {
				_subordinate = _x;
				_linkedSubordinate = synchronizedObjects _subordinate;
				{
					if !(_x iskindof "logic") then {
						_group = group _x;
						_groupColor = _subordinate getvariable "color";
						[_owner,"MARTA_REVEAL",[_group],false,true] call BIS_fnc_variableSpaceAdd;
						_owner HCsetgroup [_group,"",_groupColor];
					};
				} foreach (_linkedSubordinate + ([] call SA_fnc_getPlayableUnits));
			};
		} foreach _linkedlogic;
	};
};

FUNC_releaseHC = {
	{ hcRemoveAllGroups (hcLeader _x); } foreach allGroups;
};
