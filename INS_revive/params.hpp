// Call defalt value
#include "config.hpp"

class EmtpyLine1 {
	title = ":: Revive Settings";
	values[]={0,0};
	texts[]={ "",""};
	default = 0;
};
class INS_REV_PARAM_allow_revive {
	title="    Allow Revive";
	values[]={ 0,1 };
	default = INS_REV_DEF_allow_revive;
	texts[]={ "Everyone","Medic only"};
};
class INS_REV_PARAM_respawn_delay {
    title="    Player Respawn Delay";
	values[]={30,60,120,240,480};
    default = 120;
    texts[]={"30 Sec","1 Min","2 Min","4 Min","8 Min"};
};
class INS_REV_PARAM_life_time {
    title="    Life Time for Revive";
	values[]={-1,30,60,120,180,300,600};
    default = INS_REV_DEF_life_time;
	texts[]={"Unlimited","30 Sec","1 Min","2 Min","3 Min","5 Min","10 Min"};
};
class INS_REV_PARAM_revive_take_time {
    title="    How long takes time to revive (+-5 sec)";
	values[]={10,15,20,25,30,40,50,60,120};
    default = INS_REV_DEF_revive_take_time;
	texts[]={"10 sec","15 sec","20 Sec","25 Sec","30 Sec","40 Sec","50 Sec","1 Min","2 Min"};
};
class INS_REV_PARAM_require_medkit {
	title="    Requires Medkit for Revive";
	values[]={ 1,0 };
	default = INS_REV_DEF_require_medkit;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_respawn_type {
	title="    Respawn Faction";
	values[]={ 0,1,2 };
	default = INS_REV_DEF_respawn_type;
	texts[]={ "ALL (Co-Op Only)","SIDE (Co-Op, PvP)","GROUP (Co-Op, PvP)"};
};
class INS_REV_PARAM_respawn_location {
	title="    Respawn Location";
	values[]={ 0,1,2 };
	default = INS_REV_DEF_respawn_location;
	texts[]={ "Base + Alive Friendly Unit","Base","Alive Friendly Unit"};
};
class INS_REV_PARAM_displayRespawnLocationMarker {
	title="    Display Respawn Locations Marker";
	values[]={ 1,0 };
	default = INS_REV_DEF_displayRespawnLocationMarker;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_respawnLocationMarkerColor {
	title="     - Marker Color";
	values[]={ 0,1,2,3,4,5,6,7,8,9 };
	default = INS_REV_DEF_respawnLocationMarkerColor;
	texts[]={ "ColorOrange","ColorYellow","ColorGreen","ColorPink","ColorBrown","ColorKhaki","ColorBlue","ColorRed","ColorBlack","ColorWhite" };
};
class INS_REV_PARAM_respawnLocationMarkerType {
	title="     - Marker Type";
	values[]={ 0,1,2,3,4,5,6 };
	default = INS_REV_DEF_respawnLocationMarkerType;
	texts[]={ "mil_marker","mil_flag","mil_dot","mil_box","mil_triangle","mil_destroy","mil_circle" };
};
class INS_REV_PARAM_destroyDamagedVehicle {
	title="    Destroy when base vehicle can't move. (Mobile Respawn)";
	values[]={ 1,0 };
	default = INS_REV_DEF_destroyDamagedVehicle;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_destroyDamagedVehicleDelay {
	title="     - Delay Time";
	values[]={10,15,20,25,30,40,50,60,120,300,600};
	default = INS_REV_DEF_destroyDamagedVehicleDelay;
	texts[]={"10 sec","15 sec","20 Sec","25 Sec","30 Sec","40 Sec","50 Sec","1 Min","2 Min","5 Min", "10 Min"};
};
class INS_REV_PARAM_jip_action {
	title="    On JIP Action";
	values[]={ 0,1,2 };
	default = 0;
	texts[]={ "None","Teleport Action","Dispalay respawn camera"};
};
class INS_REV_PARAM_can_drag_body {
	title="    Allow to Drag Body";
	values[]={ 1,0 };
	default = INS_REV_DEF_can_drag_body;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_can_carry_body {
	title="     - Allow to Carry Body";
	values[]={ 1,0 };
	default = INS_REV_DEF_can_carry_body;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_medevac {
	title="     - Allow to Load Body (MEDEVAC)";
	values[]={ 1,0 };
	default = INS_REV_DEF_medevac;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_can_respawn_player_body { 
	title="    Player can respawn player's own body";
	values[]={ 1,0 };
	default = 1;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_half_dead_repsawn_player_body { 
	title="    Player can respawn player's own body, If half of players are dead";
	values[]={ 1,0 };
	default = 1;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_near_friendly {
	title="    Player can respawn immediately, if there is not exist friendly unit near player";
	values[]={ 1,0 };
	default = 0;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_near_friendly_distance {
	title="     - Friendly unit search distance";
	values[]={ 10,30,50,100,300,500 };
	default = INS_REV_DEF_near_friendly_distance;
	texts[]={ "10m","30m","50m","100m","300m","500m"};
};
class INS_REV_PARAM_near_enemy {
	title="    Player cannot respawn, if exist enemy units near player (except static BASE)";
	values[]={ 1,0 };
	default = 0;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_near_enemy_distance {
	title="     - Enemy unit search distance";
	values[]={ 10,30,50,100,300,500 };
	default = INS_REV_DEF_near_enemy_distance;
	texts[]={ "10m","30m","50m","100m","300m","500m"};
};
class INS_REV_PARAM_all_dead_respawn {
	title="    Player can respawn immediately, if all players are dead";
	values[]={ 1,0 };
	default = INS_REV_DEF_all_dead_respawn;
	texts[]={ "Enabled","Disabled"};
};
class INS_REV_PARAM_loadout_on_respawn {
	title="    Restore loadout on respawn";
	values[]={ 1,0 };
	default = INS_REV_DEF_loadout_on_respawn;
	texts[]={ "Enabled","Disabled"};
};