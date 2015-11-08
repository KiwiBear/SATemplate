/*
	Author: [SA] Duda
	
	Description:
	Creates black cut scene with text 
	
	aL, eL
	
	Parameters:
		0: ARRAY - Array of messages to be shown on the screen, one at a time (ex: [["message 1",display time in seconds],["My message to read in 5 seconds",5]])
		1: NUMBER (Optional) - Fade in time (default: 0)
		2: NUMBER (Optional) - Fade 0 time (default: 0)
		
	Returns:
	ARRAY - Array of playable units matching some criteria
*/

scopeName "SA_fnc_createBlackCutScene";

private ["_messages","_fadeIn","_fadeOut","_currentTickSeconds","_doSkip"];
_messages = [_this,0,[]] call BIS_fnc_param;
_fadeIn = [_this,1,0] call BIS_fnc_param;
_fadeOut = [_this,2,0] call BIS_fnc_param;
_doSkip = false;

cutText ["", "BLACK OUT",_fadeIn];
sleep _fadeIn;
player enableSimulation false;
sleep 2;
["<t size='0.6'>Press [space] to skip intro</t>",0.02,0.9,999,2,0,3001] spawn bis_fnc_dynamicText;
{
	[(_x select 0),0,0,(_x select 1),2,0,3000] spawn bis_fnc_dynamicText;
	_currentTickSeconds = diag_tickTime;
	waitUntil {
		if( diag_tickTime >= (_currentTickSeconds + ((_x select 1) + 4)) ) then {
			true;
		} else {
			if( inputAction "Action" > 0 ) then {
				_doSkip = true;
				true;
			} else {
				false;
			};
		}
	};
	if(_doSkip) then {
		breakTo "SA_fnc_createBlackCutScene";
	};
}
forEach _messages;
["",0,0,1,0,0,3001] spawn bis_fnc_dynamicText;
["",0,0,1,0,0,3000] spawn bis_fnc_dynamicText;
if(!_doSkip) then {
	sleep 1;
}
cutText ["", "BLACK IN",_fadeOut];	
cutText ["", "BLACK IN",_fadeOut];	
player enableSimulation true;
sleep _fadeOut;

