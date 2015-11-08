
#define FontHTML "PuristaMedium"

#define ST_LEFT       0
#define ST_CENTER     2

#define CT_STATIC     0
#define CT_BUTTON     1
#define CT_EDIT       2
#define CT_LISTBOX    5


class RscText
{
	type = CT_STATIC;
	style = ST_LEFT;
	idc = -1;
	colorBackground[] = {0, 0, 0, 0};
	colorText[] = {0.2, .2, 0.2, 1};
	font = FontHTML;
	sizeEx = TXTSIZE;
};
class RscButton
{
	type = CT_BUTTON;
	style = ST_CENTER;
	idc = -1;
	font = FontHTML;
	sizeEx = TXTSIZE;
	default = false;
	soundPush[] = {};
	soundClick[] = {};
	soundEscape[] = {};
	soundEnter[] = {};
	colorText[] = {0, 0, 0, 1};
	colorDisabled[] = {};
	colorBackground[] = {0.2, 0.2, 0.2, 0};
	colorBackgroundActive[] = {};
	colorBackgroundDisabled[] = {};
	colorFocused[] = {};
	offsetX = ;
	offsetY = ;
	offsetPressedX = ;
	offsetPressedY = ;
	colorShadow[] = {};
	colorBorder[] = {};
	borderSize = ;
};
class RscEdit
{
	type = CT_EDIT;
	style = ST_CENTER;
	idc = -1;
	font = FontHTML;
	sizeEx = TXTSIZE;
	colorText[] = {0, 0.2, 0.4, 1};
	colorSelection[] = {0, 0.2, 0.4, 1};
	autocomplete = false;
	text = ;
};

class RscLB_C
{
	style = ST_LEFT;
	idc = -1;
	colorSelect[] = {0, 0.2, 0.4, 1};
	colorSelectBackground[] = {0, 0.2, 0.4, 0.1};
	colorText[] = {0.2, .2, 0.2, 1};
	colorBackground[] = {0.4, 0.4, 0.4, 0};
	font = FontHTML;
	sizeEx = TXTSIZE;
	rowHeight = 0.025;
};

class RscListBox : RscLB_C
{
	type = CT_LISTBOX;
	sizeEx = TXTSIZE;
	class ScrollBar {};
	autoScrollRewind = ;
	autoScrollSpeed = ;
	autoScrollDelay = ;
	maxHistoryDelay = ;
};

class Dlg1
{
  idd = DLG1_IDD;
  movingEnable = 1;
  controlsBackground[] = {LIST_BACKGROUND};
  class LIST_BACKGROUND : RscText
  {
    colorBackground[] = {0.8, 0.8, 0.8, 0.5};
    text = ;
  	x = 0.00;
  	y = 0.18;
  	w = 0.25;
  	h = 0.7;
  	moving = 1;
  };
  objects[] = {};
  
  controls[] = {BLLLIST, BLLLABEL, BLLPASTE, CLOSEIT};
  class BLLLIST : RscListBox
  {
  	idc = DLG1_BLLLIST;
  	x = 0.005;
  	y = 0.19;
  	w = 0.23;
  	h = 0.6;
  	sizeEx = TXTSIZE;
		soundSelect[] = {"",0.100000,1};
  	moving = 1;
  };
  class BLLLABEL : RscText
  {
  	idc = DLG1_BLLLABEL;
  	x = 0.00;
  	y = 0.78;
  	w = 0.23;
  	h = 0.06;
  	sizeEx = 0.03;
  	text="Copy data from here:";
  };
  class BLLPASTE : RscEdit
  {
  	idc = DLG1_BLLPASTE;
  	x = 0.005;
  	y = 0.83;
  	w = 0.23;
  	h = __EVAL(TXTSIZE + 0.005);
  };
  class CLOSEIT : RscButton
  {
  	idc = DLG1_CLOSEIT;
  	x = 0.23;
  	y = 0.16;
  	w = 0.02;
  	h = 0.02;
		sizeEx = 0.015;
	 	text = "X";
  	action = closeDialog DLG1_IDD;
  };
};