//  -mod=@TeamSpeakQuery
if(isServer) then {
	[] spawn { 
		_addonVersion = ("TeamSpeakQuery" callExtension "VERSION");
		if(_addonVersion == "1.0") then {
			while {true} do {
				{
					_isSpeaking = ("TeamSpeakQuery" callExtension ("ISTALKING:" + name _x));
					_isCurrentlyTalking = _x getVariable ["sa_is_talking", false];
					if(_isSpeaking == "TRUE") then {
						if(!_isCurrentlyTalking) then {
							_x setVariable ["sa_is_talking", true, true];
						};
					} else {
						if(_isCurrentlyTalking) then {
							_x setVariable ["sa_is_talking", false, true];
						};
					};
				} forEach ([] call SA_fnc_getPlayableUnits);
				sleep 0.5;
			}; 
		};
	};
};
