//V1.1 - By: Ghost - List of different units for spawning scripts
//[side_type] execvm "unit_list.sqf";
private ["_PARAM_JET","_PARAM_Enemy"];

_PARAM_JET = "PARAM_JET" call BIS_fnc_getParamValue;
_PARAM_Enemy = "PARAM_Enemy" call BIS_fnc_getParamValue;
if (_PARAM_Enemy == 2) then {_PARAM_Enemy = floor(random 2);};
switch _PARAM_Enemy do {

case 0: {

	///////////
	//Iranian UNITS
	///////////
	
	ghst_side = east;

	ghst_menlist = ["O_soldier_F","O_Soldier_lite_F","O_soldier_AT_F","O_soldier_GL_F","O_soldier_LAT_F","O_soldier_exp_F","O_soldier_F","O_soldier_AR_F","O_soldier_repair_F","O_soldier_LAT_F","O_soldier_AR_F","O_soldier_M_F","O_soldier_AT_F","O_soldier_AA_F","O_soldier_F","O_soldier_TL_F","O_medic_F","O_soldier_GL_F","O_soldier_F"];

	ghst_diverlist = ["O_diver_f","O_diver_exp_f","O_diver_TL_f","O_diver_f","O_diver_exp_f","O_diver_f"];
	
	ghst_specopslist = ["O_recon_f","O_recon_exp_f","O_recon_f","O_recon_M_f","O_recon_medic_f","O_recon_f","O_recon_exp_f","O_recon_LAT_f","O_recon_TL_f","O_recon_f"];

	ghst_crewmenlist = ["O_crew_F"];
	
	ghst_patrolvehlist = ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_MRAP_02_gmg_F","O_MBT_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F","O_MRAP_02_hmg_F"];

	ghst_convoyvehlist = ["O_Truck_02_transport_F","O_Truck_03_transport_F","O_MRAP_02_gmg_F","O_Truck_02_covered_F","O_MRAP_02_hmg_F","O_MRAP_02_F","O_Truck_02_transport_F","O_MRAP_02_gmg_F","O_APC_Wheeled_02_rcws_F","O_Truck_03_covered_F","O_Truck_02_covered_F","O_MRAP_02_hmg_F","O_MRAP_02_F"];

	ghst_staticlist = ["O_HMG_01_high_F","O_GMG_01_high_F","O_static_AT_F","O_static_AA_F"];
	
	ghst_patrolboatlist = ["O_Boat_Armed_01_hmg_F"];
	
	ghst_transport_heli_list = "O_Heli_Light_02_unarmed_F";
	
	ghst_attack_heli_list = "O_Heli_Attack_02_black_F";
	
	if (_PARAM_JET == 0) then {
	ghst_patrol_air_list = ["O_Plane_CAS_02_F"];
	} else {
	ghst_patrol_air_list = ["JS_JC_SU35","O_Plane_CAS_02_F"];
	};
	
	ghst_commanderlist = ["O_Story_Colonel_F","O_Story_CEO_F","O_officer_F"];
	
	ghst_ammobox_list = "Box_East_Ammo_F";
	
	};

case 1: {

	///////////
	//Greek UNITS
	///////////
	
	ghst_side = independent;

	ghst_menlist = ["I_soldier_F","I_Soldier_lite_F","I_soldier_AT_F","I_soldier_GL_F","I_soldier_LAT_F","I_soldier_exp_F","I_soldier_F","I_soldier_AR_F","I_soldier_repair_F","I_soldier_LAT_F","I_soldier_AR_F","I_soldier_M_F","I_soldier_AT_F","I_soldier_AA_F","I_soldier_F","I_soldier_TL_F","I_medic_F","I_soldier_GL_F","I_soldier_F"];

	ghst_diverlist = ["I_diver_f","I_diver_exp_f","I_diver_TL_f","I_diver_f","I_diver_exp_f","I_diver_f"];
	
	ghst_specopslist = ["I_soldier_F","I_Soldier_lite_F","I_soldier_GL_F","I_soldier_LAT_F","I_soldier_TL_F","I_medic_F","I_soldier_AR_F"];

	ghst_crewmenlist = ["I_crew_F"];
	
	ghst_patrolvehlist = ["I_MRAP_03_gmg_F","I_MRAP_03_hmg_F","I_APC_tracked_03_cannon_F","I_MBT_03_cannon_F","I_APC_Wheeled_03_cannon_F"];

	ghst_convoyvehlist = ["I_Truck_02_transport_F","I_MRAP_03_gmg_F","I_Truck_02_covered_F","I_APC_Wheeled_03_cannon_F","I_Ifrit_F","I_Truck_02_covered_F","I_MRAP_03_hmg_F","I_MRAP_03_F","I_Truck_02_transport_F"];

	ghst_staticlist = ["I_HMG_01_high_F","I_GMG_01_high_F","I_static_AT_F","I_static_AA_F"];
	
	ghst_patrolboatlist = ["I_Boat_Armed_01_minigun_F"];
	
	ghst_transport_heli_list = "I_Heli_Transport_02_F";
	
	ghst_attack_heli_list = "I_Heli_light_03_F";
	
	if (_PARAM_JET == 0) then {
	ghst_patrol_air_list = ["I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F"];
	} else {
	ghst_patrol_air_list = ["JS_JC_SU35","I_Plane_Fighter_03_AA_F","I_Plane_Fighter_03_CAS_F"];
	};
	
	ghst_commanderlist = ["I_officer_F","I_Story_Colonel_F"];
	
	ghst_ammobox_list = "Box_IND_Ammo_F";
	
	};
	
};