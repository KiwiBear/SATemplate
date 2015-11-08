/*
	Author: [SA] Duda

	Description:
	Gets a random position within a circle

	Parameter(s):
	_this select 0: ARRAY - Center of circle [X,Y]
	_this select 1: NUMBER (OPTIONAL) - Radius of circle (default 50)
		
	Returns: 
	ARRAY - a random position inside the specified circle [X,Y]
	
*/

private ["_center","_position","_radius","_xValue","_yValue","_r","_a"];
//http://mathworld.wolfram.com/DiskPointPicking.html
_center = [_this, 0] call BIS_fnc_param;
_radius = [_this, 1, 50] call BIS_fnc_param;
_r = random(1);
_a = random(360);
_xValue = sqrt(_r) * _radius * cos(_a);
_yValue = sqrt(_r) * _radius * sin(_a);
[_xValue+(_center select 0),_yValue+(_center select 1)];
