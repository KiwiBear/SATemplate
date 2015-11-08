/*
	Author: [SA] Duda

	Description:
	Identifies if a position is within a rotatable-rectangle

	Parameter(s):
	_this select 0: ARRAY - Position to test [X,Y]
	_this select 1: ARRAY - Rectangle center position [X,Y]
	_this select 2: NUMBER - Size X (width/2)
	_this select 3: NUMBER - Size Y (height/2)
	_this select 4: NUMBER - Angle of rotation
		
	Returns: 
	BOOL - true if the position is within the rectangle, otherwise false
*/

private ["_position", "_center", "_angle","_sizeX","_sizeY"];

_position = [_this, 0] call BIS_fnc_param;
_center = [_this, 1] call BIS_fnc_param;
_sizeX = [_this, 2, 1] call BIS_fnc_param;
_sizeY = [_this, 3, 1] call BIS_fnc_param;
_angle = [_this, 4, 0] call BIS_fnc_param;

private ["_rotatedPosition"];

_rotatedPosition = [_position, _center, _angle] call SA_fnc_rotatePosition;

"mark_pos" setMarkerPos _rotatedPosition;

[_center, [_sizeX, _sizeY], _rotatedPosition] call BIS_fnc_isInsideArea;
