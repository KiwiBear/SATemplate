class EmtpyLine1a
{
	title = ":: Ghost Mission Settings";
	values[]={0,0};
	texts[]={ "",""};
	default = 0;
};
class PARAM_GhostEnabled
{
	title= "    Ghost Missions Enabled?";
	values[]= { 1,2 };
	texts[]= { "True","False" };
	default= 1;
	code = "";
};
class PARAM_AISkill
{
	title= "    AI Accuracy and Speed Skill";
	values[]= { 1,2,3,4,5,6,7,8,9,10 };
	texts[]= { "0.1","0.2","0.3","0.4","0.5","0.6","0.7","0.8","0.9","1.0" };
	default= 5;
	code = "";
};
class PARAM_Tasks
{
	title = "    Number of Tasks:";
	values[] = {8,7,6,5,4,3,2,1};
	texts[] = {"8","7","6","5","4","3","2","1"};
	default = 1;
};
class PARAM_Enemy
{
	title = "    Type of Enemy:";
	values[] = {0};
	texts[] = {"Iranian Army"};
	default = 0;
};
class PARAM_Kavala
{
	title = "    Number of Locations:";
	values[] = {3,1};
	texts[] = {"ALL","Specified"};
	default = 3;
};