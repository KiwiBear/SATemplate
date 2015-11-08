if(!isDedicated) then {

	[] spawn {

		while {true} do {
			_allAiUnits = [getPos player, 30, {alive _x}] call SA_fnc_getNearEntities;
			{
				if( side player == side _x && alive _x && group _x != group player && leader player == player && _x isKindOf "Man" && vehicle _x == _x && (leader _x != _x || count (units group _x) == 1) ) then {
					if(isNil {_x getVariable "sa_join_squad_action_id"}) then {
						_actionId = _x addAction ["Join My Squad", { 
							if(isNil {(_this select 0) getVariable "sa_original_group"}) then {
								(_this select 0) setVariable ["sa_original_group",group (_this select 0)];
							};
							[_this select 0] join player; 
							(_this select 0) removeAction (_this select 2);
							(_this select 0) setVariable ["sa_join_squad_action_id",nil];
						}, nil, 0, false];
						_x setVariable ["sa_join_squad_action_id",_actionId];
					};
				} else {
					if(!isNil {_x getVariable "sa_join_squad_action_id"}) then {
						_x removeAction (_x getVariable "sa_join_squad_action_id");
						_x setVariable ["sa_join_squad_action_id",nil];
					};
				};
				
				if( side player == side _x && alive _x && group _x == group player && leader player == player && _x isKindOf "Man" && vehicle _x == _x && _x != player ) then {
					if(isNil {_x getVariable "sa_leave_squad_action_id"}) then {
						_actionId = _x addAction ["Leave My Squad", { 
							if(!isNil {(_this select 0) getVariable "sa_original_group"}) then {
								[_this select 0] join ((_this select 0) getVariable "sa_original_group"); 
								(_this select 0) setVariable ["sa_original_group",nil];
							} else {
								[_this select 0] join grpNull; 
							};
							(_this select 0) removeAction (_this select 2);
							(_this select 0) setVariable ["sa_leave_squad_action_id",nil];
						}, nil, 0, false];
						_x setVariable ["sa_leave_squad_action_id",_actionId];
					};
				} else {
					if(!isNil {_x getVariable "sa_leave_squad_action_id"}) then {
						_x removeAction (_x getVariable "sa_leave_squad_action_id");
						_x setVariable ["sa_leave_squad_action_id",nil];
					};
				};
				
			} forEach _allAiUnits;
			sleep 10;
		};

	};

};
