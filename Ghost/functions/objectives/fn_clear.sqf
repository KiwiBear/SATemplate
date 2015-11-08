//V1.1 By: Ghost - gives all clear when enemy units are less than 3
if (!(call SA_fnc_isAiServer)) exitwith {};
private ["_position_mark","_radarray","_radx","_rady","_locselname","_side","_rnum","_tsk","_trig1act","_trg1"];

_position_mark = _this select 0;//position to search units around
_radarray = _this select 1;//radius around position to search for units
	_radx = ((_radarray select 0) + 300);//radius x
	_rady = ((_radarray select 1) + 300);//radius y
_locselname = _this select 2;//name of location	
_side = _this select 3;//side of enemy

//create random number
_rnum = str(round (random 999));
//create task
_tsk = "tsk_clear" + _rnum;

//create task
[_tsk,format ["Clear %1", _locselname],format ["Eliminate all enemy presence around %1.", _locselname],true,[],"created",_position_mark] call SHK_Taskmaster_add;

//sleep 60;

//create trigger for no enemy left
_trig1act = format ["['%1','succeeded'] call SHK_Taskmaster_upd; [[playableunits,5000,100],'fnc_ghst_addscore'] spawn BIS_fnc_MP;", _tsk];
_trg1 = createTrigger["EmptyDetector",_position_mark];
_trg1 setTriggerArea[_radx,_rady,0,false];
_trg1 setTriggerActivation[format ["%1", _side],"PRESENT",false];
_trg1 setTriggerStatements["count thislist < 3", _trig1act, "deleteVehicle thistrigger;"];