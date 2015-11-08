class GHST
{
	tag = "GHST";
	class functions
	{
		file = "Ghost\functions";
		class functions {description = "core functions, called on mission start."; preInit = 1;};
	};
	class objectives
	{
		file = "Ghost\functions\objectives";
		class acquirelocations {description = "get locations on map for objectives and tasks";};
		class randomobj {description = "select random location for main objective area";};
		class rescue {description = "rescue task";};
		class intel {description = "intel task";};
		class randomwreck {description = "random sea wreck task";};
		class randombuild {description = "random building task";};
		class sideobj {description = "random side location objective area";};
		class randomobjectives {description = "selection of random tasks and loop for checking when all tasks are complete";};
		class randomloc {description = "random destroy object placement task";};
		class randomcrash {description = "random crash task";};
		class objinbuild {description = "random object in building to be destroyed task";};
		class assassinate {description = "kill someone task";};
		class hostjoin {description = "part of rescue task so pow will join players group";};
		class itemfound {description = "part of intel task for item found";};
		class clear {description = "clear area task";};
		class putinbuild {description = "for putting all objects specified in buildings and placing random markers";};
	};
	class spawn
	{
		file = "Ghost\functions\spawn";
		class unitlist {description = "list of available enemy units"; preInit = 1;};
		class randespawn {description = "random enemy infantry patrol spawn near random players";};
		class eparadrop {description = "enemy para drop";};
		class ecounter {description = "enemy counter attack";};
		class eair {description = "random enemy air patrol";};
		class mines {description = "random mines";};
		class roofmgs2 {description = "random static weapons in buildings alternate version";};
		class ediverspawn {description = "random enemy diver spawn";};
		class espawn {description = "random enemy infantry patrol spawn at location";};
		class evehsentryspawn {description = "random enemy vehicle spawn near roads if available";};
		class civcars {description = "random civilian cars - vbieds";};
		class ieds {description = "random ieds";};
		class fillbuild {description = "fill random buildings at location with units";};
		class basedef {description = "static base defence vehicles";};
		class eboatspawn {description = "random enemy boat spawn";};
		class evehspawn {description = "random vehicle patrol spawn";};
	};
	class client
	{
		file = "Ghost\functions\client";
		class halo {description = "player halo";};
		class tracker {description = "tracking player spawned vehicles locally";};
		class ptracker {description = "tracking mission vehicles";};
		class ammodrop {description = "player ammo crate call in";};
		class airsupport {description = "player air support call in";};
		class ugvsupport {description = "player ugv call in";};
		class uavsupport {description = "player uav call in";};
		class puavsupport {description = "player AR-2 Darter call in";};
		class reload {description = "repair, rearm, refuel";};
		class playeraddactions {description = "adds various player actions on call";};
		class magazines {description = "compiles all magazines and loads them into cargo";};
		class boatpush {description = "ability to push a boat";};
		class vehicle_actioninit {description = "adds various actions to specified vehicles";};

	};
	class server
	{
		file = "Ghost\functions\server";
		class randweather {description = "random weather to be spawned on server";};
	};
	class sling
	{
		file = "Ghost\functions\sling";
		class slingload {description = "sling load main file";};
		class slingattach {description = "sling attach to";};
		class slingdetach {description = "sling detach from";};
		class slingcancel {description = "sling cancel";};
	};
};