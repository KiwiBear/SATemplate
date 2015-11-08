/*
	Author: [SA] Duda

	Description:
	Moves a helicopter to a specified position

	Parameter(s):
	_this select 0: GROUP - Helicopter pilot's group
	_this select 1: STRING - Helicopter object name
	_this select 2: ARRAY - Position in 3D world
	_this select 3: STRING (OPTIONAL) - Must be one of the following:
		"LAND" (complete stop) (Default)
		"GET IN" (hovering very low, for another unit to get in)
		"GET OUT" (hovering low,for another unit to get out)
		"NONE" (cancel a landing)
	_this select 4: BOOL (OPTIONAL) - indicates if a smoke & chemlight marker should be used to 
		mark landing position for the helicopter (Default: false)
	_this select 5: BOOL (OPTIONAL) - indicates if an invisible heli pad should be 
		placed at the supplied position.
		
	Returns: 
	Nothing
*/

private ["_group", "_helicopterObjectName", "_position", "_action", "_marker", "_helipad"];
_group = [_this, 0] call BIS_fnc_param;
_helicopterObjectName = [_this, 1, ""] call BIS_fnc_param;
_position = [_this, 2, [0,0,0]] call BIS_fnc_param;
_action = [_this, 3, "LAND"] call BIS_fnc_param;
_marker = [_this, 4, false] call BIS_fnc_param;
_helipad = [_this, 5, false] call BIS_fnc_param;

// Optionally creates invisible landing pad
if( _helipad ) then {
	"Land_HelipadEmpty_F" createVehicle _position;
};

// Optionally creates smoke and chem light
if( _marker ) then {
	"SmokeShellGreen" createVehicle _position;
	"chemlight_green" createVehicle _position;
};

// Tells helicopter to move to specified position
while {(count (waypoints _group)) > 0} do
 {
  deleteWaypoint ((waypoints _group) select 0);
 };
private ["_wp0"];
_wp0 = _group addWaypoint [_position, 0];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointStatements ["true", _helicopterObjectName + " land '"+_action+"'"];
