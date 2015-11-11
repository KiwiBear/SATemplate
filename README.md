Currently in v2.1.3 (Altis):

Squad Halo (Only available to squad leader. Squad members w/in 200 meters of SL will be included in the HALO jump) (SA Created)

Individual Halo (SA Created)

  Halo at 4.5k, auto open at 300m

  Use shift and z to sleep up and slow down decent

  Right control to cut main chute

  Main chute can fail

  Disable auto deploy via action menu

HC Command Radio (SA Created)
INS Revive
INS AI Revive (SA Created)
Igiload
Heli Cargo Ropes (SA Created)
Heli Cargo Ropes for Heavy Lifting  (SA Created) (For Mohawk and Huron only) 
Squad Join/Leave (SA Created)
Vehicle Spawning (Ground, Air, Sea)
Vehicle Repair Pads
Virtual Ammo & Virtual Arsenal 
SA Billboard (SA Created)
Custom/random weather & time (SA Created)
Ghost missions
Vehicle respawn for helis at base
Player names above head
COS - Civilian Occupation System
  Can be disabled via mission param
Support system
  Heli transport (for SL and HC only)
  Ammo drop (for SL and HC only)
  CAS (Heli) (for JTAC and HC only)
  CAS (Bomb run) (for JTAC and HC only)
  Artillery (for JTAC and HC only), Disabled by default
Headless client support

Bugs

AI “Join My Squad”>transported>“Leave Squad”>”Join My Squad”>positioned>”Leave Squad” - squad members run away or get in a helicopter and sit so they cannot be re-recruited.  Happened while recruiting a bunch of AI, dropping them at FOB and disbanding. Then flying back and getting more AI and moving them to the FOB and disbanding.  Problem occurs after the first group is recruited and released a second time. (Chewie)  SEE: https://youtu.be/KyFp94xJixQ
AI numerous times are moved from my squad position back to base or at least distance from me. Especially when vehicle is hit with them in. (reported by Thomas)
Mohawk exploding when pilot get in it out in field. (reported by Thomas + Chewie)
Couple times can't find the command radio. Not marked on map. (reported by Thomas)
  Couldn’t find it when it was dropped 2nd time
SL lost SL position w/o dying even though they were in position #1 (reported by Thomas)

New Feature Ideas:

Move Chute functions to the top of  the scroll list for HALO jumping so space-bar will deploy main and reserve.  *note also “Cut Chute” as right cntrl can result in accidentally cutting your chute while trying to enable GPS while in parachute glide w/ r-cntrl+m (Chewie)
Unit markers on map (SA Created)
Preset Custom Load out kits – for SA members only (I have a sample… just scripting on the character editor)  (SA Created)
SA Patch for on Uniforms (for members only – investigating)  (SA Created)
  https://community.bistudio.com/wiki/BIS_fnc_setUnitInsignia
Squad teleport to port (SA Created)
Earplugs; making it easier to hear coms over vehicle and gunfire noise. (Chewie)  -simplest example I have seen elsewhere I THINK is basically a mapped key [del] that toggles the games sfx volume down a certain % and puts a little message on screen saying “Your Earplugs are In/Out”.  More advanced examples I have seen involve actually having to have the earplugs in your inventory to use it.
Towing (ie: re-positioning a plane on the runway because they don’t reverse, moving H-Barriers on the ground) (Chewie)
Helo Fuel/Engine damage - A reasonable way to recover a helicopter that has taken engine damage and lost all of its fuel; examples range from a slower drain rate, jerry cans/barrels, a smaller fuel truck or some kind of portable fueling system,etc. (Chewie)

Release Notes

v1.3:
New Features:
Improved HALO functionality
Bug Fixes:
Ammo drop contains no ammo - should contain virtual ammo box 
Fatigue turns on on revive 
Player names say “Error: No Unit” when they die 
When over water, the player names are too high.
HC loses sync when player(s) die 

v1.3.1:
Bug Fixes:
Ghost rand enemy spawn was not working

v1.4:
New Features:
COS - Civilian Occupation System
Can be disabled via param
Fast ropes added back to mission - should be fixed now.
Improved Halo
Can enable/disable auto-deploy (enabled by default)
Autodeploy changed to 300m
Can’t open chute under 50m
Bug Fixes:
Enemy AI don’t use parachutes (chutes deploy, but all empty). They wait till heli lands.
Cut chute makes player take no damage - can cause player to hit ground w/o dying.

v1.4.1:
Bug Fixes:
COS - Civilian Occupation System bug fix - failed to sometimes find connecting roads
Player dies “twice” when crashing in heli. Likely also fixes:
JT left game came back in different role, we had 2 JT in squad. One the real, the other AI. (reported by Thomas)

v1.4.4
improved ghost ai skill setting (not all ai skills were being set properly). AI should be more difficult now.
setup default params so most settings can be left as-is when starting mission
player names are now visible up to 1k (vs 500m)
ropes improvements / bug fixes:
vehicle "sliding" has been fixed when attached to ropes
vehicle mass issue has been fixed (where mass doesn't get restored)
ropes now cannot be attached to objects that are too far away (longer than rope length)

v1.5
Improved support system. The following supports are now available and can be enabled/disabled via mission params. Cooldown time can also be changed via params. Ghost supports have been removed from the template.
Heli transport (for SL and HC only)
Ammo drop (for SL and HC only)
CAS (Heli) (for JTAC and HC only)
CAS (Bomb run) (for JTAC and HC only)
Artillery (for JTAC and HC only), Disabled by default

v1.5.1
Support system bug fix - players were not getting supports when JIP

v1.6
Server performance improvement: support for headless client

V2.1.3
AI Revive
Decreased size of Ghost search markers
