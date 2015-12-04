SA_fnc_findNearUnits = {
	private ["_position","_radius","_side","_nearUnits"];
	_position = param [0];
	_radius = param [1];
	_side = param [2];
	_nearUnits = [];
	{
		if( side _x == _side && _position distance _x <= _radius ) then {
			_nearUnits pushBack _x;
		};
	} forEach allUnits;
	_nearUnits;
};

SA_fnc_findNearEnemy = {
	private ["_unitOrGroup","_radius","_cacheForSeconds","_nearUnits","_refreshCache","_lastCached"];
	_unitOrGroup = param [0];
	_radius = param [1];
	_cacheForSeconds = param [2,0];
	_refreshCache = true;
	_nearUnits = [];
	if(_cacheForSeconds > 0) then {
		_lastCached = _unitOrGroup getVariable ["SA_fnc_findNearEnemy_lastCached",0];
		if(diag_tickTime - _lastCached <= _cacheForSeconds) then {
			_nearUnits = _unitOrGroup getVariable ["SA_fnc_findNearEnemy_nearUnits",[]];	
			_refreshCache = false;
		};
	};
	if(_refreshCache) then {
		if(side _unitOrGroup == EAST) then {
			_nearUnits = [position leader _unitOrGroup, _radius, WEST] call SA_fnc_findNearUnits;
		};
		if(side _unitOrGroup == WEST) then {
			_nearUnits = [position leader _unitOrGroup, _radius, EAST] call SA_fnc_findNearUnits;
		};
		if(_cacheForSeconds > 0) then {
			_unitOrGroup setVariable ["SA_fnc_findNearEnemy_nearUnits",_nearUnits];	
			_unitOrGroup setVariable ["SA_fnc_findNearEnemy_lastCached",diag_tickTime];
		};
	};
	_nearUnits;
};

SA_fnc_smartGroupAi = {
	private ["_group","_nearEnemy","_expectedPosition","_actualPosition","_knowsAboutRating","_maxKnowsAboutRating","_distance"];
	_group = param [0];
	while {local leader _group} do {
		_nearEnemy = [_group, 1000, 60] call SA_fnc_findNearEnemy;
		_maxKnowsAboutRating = 0;
		{
			_expectedPosition = ((leader _group) getHideFrom _x);
			_expectedPosition set [2,0];
			_actualPosition = (aimPos _x);
			_actualPosition set [2,0];	
			_knowsAboutRating = (leader _group) knowsAbout _x;
			if((_expectedPosition distance _actualPosition) > 5) then {
				_knowsAboutRating = _knowsAboutRating / 4;
			};
			
			_distance = _x distance (leader _group);
			_distance = (_distance - 50) max 0;
			_distance = _distance min 600;
			_distanceFactor = 1 - (_distance / 550);
			_knowsAboutRating = _knowsAboutRating * _distanceFactor;
			
			if(_knowsAboutRating > _maxKnowsAboutRating) then {
				_maxKnowsAboutRating = _knowsAboutRating;
			};
		} forEach _nearEnemy;
		
		_bestAimingSkill = round ((_maxKnowsAboutRating / 4) * 30) / 100;
		
		//hint format ["Max KA: %2, Best: %1", _bestAimingSkill,_maxKnowsAboutRating];
		
		{
			_currentAimingSkill = _x getVariable ["SA_fnc_smartGroupAi_currentAimSkill",-1];
			if(_currentAimingSkill != _bestAimingSkill) then {
				_x setskill ["aimingAccuracy",_bestAimingSkill];
				_x setVariable ["SA_fnc_smartGroupAi_currentAimSkill",_bestAimingSkill];
				//hint format ["Setting %1 skill to %2 (Max KA: %3)", _x, _bestAimingSkill,_maxKnowsAboutRating];
			};
		} forEach units _group;
		
		sleep 10;
		
	};
};

if(isServer) then {
	private ["_assignedOwner","_actualOwner"];
	while {true} do {
		{
			if(side _x == EAST) then {
				_assignedOwner = _x getVariable ["SA_assigned_owner",-1];
				_actualOwner = owner (leader _x);
				//hint format ["%1, %2", _assignedOwner, _actualOwner];
				if(_assignedOwner != _actualOwner) then {
					_x setVariable ["SA_assigned_owner",_actualOwner];
					[_x] remoteExec ["SA_fnc_smartGroupAi",_actualOwner];
				};
			};
		} forEach allGroups;
		sleep 20;
	};
};

