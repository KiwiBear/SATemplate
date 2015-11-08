#define NAMESPACE missionNamespace

#define STAGE(stageName) \
NAMESPACE setVariable [stageName, { \
	private ["_returnValue","_hasInitExecuted"]; \
	_returnValue = nil; \
	_hasInitExecuted = NAMESPACE getVariable [(stageName + "Init"),false]; \
	NAMESPACE setVariable [(stageName + "Init"),true]; \
	if( !_hasInitExecuted ) then 

#define INIT 

#define EXEC ; if(true) then

#define STAGE_END ; if(!isNil "_returnValue") then {_returnValue}; } ]; 