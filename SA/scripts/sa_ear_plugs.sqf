// Adapted from http://www.armaholic.com/page.php?id=26624

SA_Ear_Plug_Action = ["Put On Ear Plugs",{
	private ["_user","_actionId"];
	_user = _this select 1;
	_actionId = _this select 2;
	if (soundVolume > 0.25) then {
		1 fadeSound 0.25;
		_user setUserActionText [_actionId,"Take Off Ear Plugs"]
	} else {
		1 fadeSound 1;
		_user setUserActionText [_actionId,"Put On Ear Plugs"]
	}
},[],-90,false,true];
player addAction SA_Ear_Plug_Action;
player addEventHandler ["Respawn",{
	1 fadeSound 1;
	(_this select 0) addAction SA_Ear_Plug_Action;
}];