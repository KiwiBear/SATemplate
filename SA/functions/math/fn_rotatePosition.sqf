/*
	Author: [SA] Duda

	Description:
	Rotates a position [X,Y] a specified angle around a center position [X,Y]

	Parameter(s):
	_this select 0: ARRAY - Position to be rotated [X,Y]
	_this select 1: ARRAY - Center position to be rotated around [X,Y]
	_this select 2: NUMBER - Angle of rotation
		
	Returns: 
	ARRAY - The rotated position [X,Y]
*/

private ["_position", "_center", "_angle"];
private ["_pX", "_pY", "_cX", "_cY", "_rX", "_rY"];

_position = [_this, 0] call BIS_fnc_param;
_center = [_this, 1] call BIS_fnc_param;
_angle = [_this, 2, 0] call BIS_fnc_param;

_pX = _position select 0;
_pY = _position select 1;
_cX = _center select 0;
_cY = _center select 1;

_rX = _cX+(_pX-_cX)*cos(_angle)-(_pY-_cY)*sin(_angle);
_rY = _cY+(_pX-_cX)*sin(_angle)+(_pY-_cY)*cos(_angle);

[_rX,_rY];
