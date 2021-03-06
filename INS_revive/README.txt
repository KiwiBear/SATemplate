/////////////////////////////////////////////////////////////////////////////////
//
// INS revive script (based on R3F_revive) v0.3.1 by naong
//
/////////////////////////////////////////////////////////////////////////////////
//
// This software is the revive system for ArmA 2, Arma 2 Free, Arma 2 OA, Arma 2 CO, Arma 3
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//	
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
/////////////////////////////////////////////////////////////////////////////////
//
// Features
//
//  - Support Arma 2, Arma 2 OA, Arma 2 CO, Arma 3.
//  - Support dedicated and local server.
//  - Support Co-op and PvP missions.
//  - Support Join-in-progress player.
//  - Support Ace mod (Arma 2 OA, Arma 2 CO).
//  - Support various respawn location (vehicle, static).
//  - Insurgency style dead camera.
//  - Respawn, Revive, Drag body, Cancel actions.
//  - Admin reserved slot.
//  - On JIP Action (Teleport action or Respawn camera).
//  - On respawn, revert loadout.
//  - Implemented Virtual Ammobox System v0.9 (Author : Tonic) (modified some codes).
//    * Fixed load and save functions to aeroson's Loadout functions. (get_loadout 2.6, set_loadout 3.4)
//    * Optimized load and save listbox display function.
//    * Added : Backpack restrict option. (and restricted mortar backpacks)
//    * Changed : When close VAS dialog, automaticaly save loadout for respawn.
//  - Implemented TAW View Distance Dialog.(Author : Tonic)
//  - Implemented Personal UAV.(Author: Thomas Ryan, Tweaked by Rarek)
//  - Implemented Team Killer Lock system v2. (Author : Murcielago)
//  - Vehicle repiar, unflip, push boat actions
//  - Player name tag
//  - Player markers : Server side (Co-Op) or Client side (PvP).
//  - UAV Briefing
//  - Manual NV Goggle sensitivity (Implemented Fixed Range Nightvision add-on 0.7 by sholio)
//  - Squad Management (Author : Xeno)
//  - VTS Simple weapon resting (Author : L etranger)
//  - [VAS] Interface Upgrade 1.0 (Author : GranolaBar & PokerTour)
//
/////////////////////////////////////////////////////////////////////////////////
//
// Credits & Thanks:
//
//  - madbull (R3F revive)
//  - pogoman, Fireball, Kol9yN (Insurgency dead camera)
//  - Tonic (Virtual Ammobox System v0.9, TAW View Distance Dialog)
//  - aeroson (Loadout functions. get_loadout 2.6, set_loadout 3.4)
//  - Thomas Ryan, Rarek (Personal UAV)
//  - Xeno (Domination vehicle repair script, Squad management script)
//  - Murcielago (Team Killer Lock system v2)
//  - sholio (Fixed Range Nightvision add-on 0.7)
//  - Sinky (Mission Settings 1.1)
//  - L etranger (VTS Simple weapon resting release 05)
//  - GranolaBar & PokerTour ([VAS] Interface Upgrade 1.0)
//
/////////////////////////////////////////////////////////////////////////////////
//
// Change Log
//
// v0.3.1 (10-June-2014)
//   - added VTS Simple weapon resting release 05 (Weapon Resting Key : Ctrl + Space).
//   - replaced VAS to [VAS] Interface Upgrade 1.0.
//   - updated aeroson's Loadout function (get_loadout 3.4, set_loadout 4.3)
//   - fixed dialog resource errors.
//
// v0.3.0 (4-October-2013)
//   - updated VAS to version 2.0.
//   - updated aeroson's Loadout function (get_loadout 3.3, set_loadout 4.1)
//   - fixed respawning bug.
//   - added INS_Revive core version.
//
// v0.2.9 (12-September-2013)
//   - added 'On JIP Action - None' item.
//   - updated VAS to version 1.8.
//   - fixed 'Carring Body' action.
//   - minor bug fix.
//
// v0.2.8 (3-August-2013)
//   - updated VAS to version 1.6.
//   - removed debug message.
//
// v0.2.7 (28-July-2013)
//   - fixed 'Respawn Faction' works fine.
//
// v0.2.6 (27-July-2013)
//   - fixed undefined variable errors.
//
// v0.2.5 (27-July-2013)
//   - support Stable Build 0.74.108135.
//   - changed when players are in the vehicle, player marker displays crew counter.
//   - updated VAS to version 1.5.
//   - fixed some bugs.
//
// v0.2.4 (14-July-2013)
//   - added an option 'Only engineer can repair'.
//   - fixed player can repair in underwater.
//   - fixed Independent faction works fine.
//   - improved Push Boat function.
//   - updated VAS to version 1.4.
//
// v0.2.3 (26-June-2013)
//   - added an option 'Display Respawn Locations Marker'.
//   - added an option 'Destroy when base vehicle can't move. (Mobile Respawn)'.
//   - changed repair action will takes longer than before.
//   - updated VAS to version 1.3.
//   - updated aeroson's Loadout function (get_loadout 3.0, set_loadout 3.9)
//
// v0.2.2 (22-June-2013)
//   - support Beta(development) 0.71.106777. do not support alpha version.
//   - fixed VAS error in Beta.
//   - fixed a bug when respawn at the vehile.
//   - changed you can drag the injured while prone.
//
// v0.2.1 (14-June-2013)
//   - fixed a bug when you press [Load On] button in VAS dialog, it removes all respawn event handlers. 
//
// v0.2.0 (12-June-2013)
//   - added an option 'Only squad leader can use the UAV'.
//   - added an option 'Player cannot respawn, if exist enemy units near player (except static BASE)'.
//   - fixed a bug when you change your squad, squad color isn't changed.
//
// v0.1.9 (9-June-2013)
//   - added options each side of delay time in 'config.sqf'.
//   - revert config dialog and uav settings from v0.1.7.
//   - updated VAS to version 1.2.
//   - updated aeroson's Loadout function (get_loadout 2.7, set_loadout 3.7)
//   - changed if you set 'Restore loadout on respawn' value to 'Disable', when you die your ammo count will be saved. And 'Respawn' button will be disabled.
//
// v0.1.8 (19-May-2013)
//   - rolled back to version 0.1.6
//   - added an option 'Allow to Carry Body'.
//   - added an option 'Protect ammobox'.
//   - inherit some options from version 0.1.7. (Squad Management, Push Boat, Flip Vehicle)
//   - fixed a bug if use VAS function in the vehicle, player be force ejected.(removed aeroson's loadout functions from VAS)
//
// v0.1.7 (11-May-2013)
//   - added Xeno's Domination Squad Management script.
//   - added an option 'Player cannot respawn, if exist enemy units near player (Except BASE)'.
//   - added an option 'Push Boat'.
//   - added an option 'Flip Vehicle'.
//   - added an option 'UAV Delay Time'.
//   - added an option 'Enable UAV Setting Dialog'.
//   - added an option 'Allow map click UAV position'.
//   - added an option 'Default altitude'.
//   - added an option 'Default radius of the circular movement'.
//   - changed if you use 'BASE' respawn and 'Life Time' functions, when bleed time out you can't spectate friendly unit.
//
// v0.1.6 (6-May-2013)
//   - added an option 'Life Time for Revive'.
//   - added an option 'Requires Medkit for Revive'.
//   - added an option 'Allow to Load Body (MEDEVAC)'.
//   - added an option 'Restore loadout on respawn'.
//   - fixed a bug when use PvP mode, enemy vehicle marker was visible.
//
// v0.1.5 (27-Apr-2013)
//   - fixed compatibility with Arma 3 dev version.
//   - updated aeroson's Loadout function (get_loadout 2.6)
//
// v0.1.4 (20-Apr-2013)
//   - added an option 'Respawn Locations' ('Base + Alive friendly unit', 'Base', 'Alive friedly unit')
//   - changed to override 'Player Marker Process Method' depend on 'Respawn Faction'.
//
// v0.1.3 (18-Apr-2013)
//   - changed all configurable object value to string value in config.sqf. (It fixes compatibility with Simple Vehicle Respawn Script.)
//
// v0.1.2 (14-Apr-2013) added two option for PvP. The player marker's color depend on squad.
//   - If all players are dead, you can respawn immediately.
//   - If half of players are dead, you can respawn your own body.
//
// v0.1.1 (14-Apr-2013)
//   - added Manual NV Goggle sensitivity function
//
// v0.1.0 (13-Apr-2013)
//   - first public release
//
/////////////////////////////////////////////////////////////////////////////////
//
// Instalation
//
// Copy [INS_revive] folder and 'stringtable.xml' file to your mission folder. And I recommend disable AI.
// You can configure 'config.sqf' and 'config.hpp' file.


////////////////////////
// In your init.sqf put:
////////////////////////
// JIP Check (This code should be placed first line of init.sqf file)
if (!isServer && isNull player) then {isJIP=true;} else {isJIP=false;};
 
// Wait until player is initialized
if (!isDedicated) then {waitUntil {!isNull player && isPlayer player};};
 
// INS_revive initialize
[] execVM "INS_revive\revive_init.sqf";
////////////////////////////////////////////////////////////////////////


////////////////////////
// In your description.ext put:
////////////////////////
Respawn = "INSTANT";
RespawnDelay = 5;
DisabledAI = true;
 
//// Respawn Script - Start ////
#include "INS_revive\description.hpp"
//// Respawn Script - End   ////
 
class Params
{
  //// Respawn Script - Start ////
  #include "INS_revive\params.hpp"
  //// Respawn Script - End   ////
};
 
class RscTitles
{
  //// Respawn Script - Start ////
  #include "INS_revive\rsctitles.hpp"
  //// Respawn Script - End   ////
};

class cfgFunctions {
  //// Respawn Script - Start ////
  #include "INS_revive\cfgfunctions.hpp"
  //// Respawn Script - End   ////
};

class CfgSounds {
	//// Respawn Script - Start ////
	#include "INS_revive\cfgsounds.hpp"
	//// Respawn Script - End ////
}
////////////////////////////////////////////////////////////////////////