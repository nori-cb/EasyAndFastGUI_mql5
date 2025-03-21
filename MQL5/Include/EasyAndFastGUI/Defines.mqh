//+------------------------------------------------------------------+
//|                                                      Defines.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
//--- "Expert in subwindow" mode
#define EXPERT_IN_SUBWINDOW false
//--- Class name
#define CLASS_NAME ::StringSubstr(__FUNCTION__,0,::StringFind(__FUNCTION__,"::"))
//--- Program name
#define PROGRAM_NAME ::MQLInfoString(MQL_PROGRAM_NAME)
//--- Program type
#define PROGRAM_TYPE (ENUM_PROGRAM_TYPE)::MQLInfoInteger(MQL_PROGRAM_TYPE)
//--- Prevention of exceeding the range
#define PREVENTING_OUT_OF_RANGE __FUNCTION__," > Prevention of exceeding the array size."

//--- Timer step (milliseconds)
#define TIMER_STEP_MSC (16)
//--- Delay before enabling the fast forward of the counter (milliseconds)
#define SPIN_DELAY_MSC (-450)
//--- Space character
#define SPACE          (" ")

//--- To present any names in string format
#define TO_STRING(A) #A
//--- Print the event data
#define PRINT_EVENT(SID,ID,L,D,S) \
::Print(__FUNCTION__," > id: ",TO_STRING(SID)," (",ID,"); lparam: ",L,"; dparam: ",D,"; sparam: ",S);

//--- Event identifiers
#define ON_WINDOW_EXPAND            (1)  // Maximizing the form
#define ON_WINDOW_COLLAPSE          (2)  // Minimizing the form
#define ON_WINDOW_CHANGE_XSIZE      (3)  // Resizing the window along the X axis
#define ON_WINDOW_CHANGE_YSIZE      (4)  // Resizing the window along the Y axis
#define ON_WINDOW_TOOLTIPS          (5)  // Clicking the Tooltips button
//---
#define ON_CLICK_LABEL              (6)  // Clicking a text label
#define ON_CLICK_BUTTON             (7)  // Clicking a button
#define ON_CLICK_MENU_ITEM          (8)  // Clicking a menu item
#define ON_CLICK_CONTEXTMENU_ITEM   (9)  // Clicking a menu item in a context menu
#define ON_CLICK_FREEMENU_ITEM      (10) // Clicking an item of a detached context menu
#define ON_CLICK_CHECKBOX           (11) // Clicking a checkbox
#define ON_CLICK_GROUP_BUTTON       (12) // Clicking a button in a group
#define ON_CLICK_ELEMENT            (13) // Clicking a control
#define ON_CLICK_TAB                (14) // Switching tabs
#define ON_CLICK_SUB_CHART          (15) // Clicking a subchart
#define ON_CLICK_INC                (16) // Changing the counter up
#define ON_CLICK_DEC                (17) // Changing the counter down
#define ON_CLICK_COMBOBOX_BUTTON    (18) // Clicking a combo box button
#define ON_CLICK_LIST_ITEM          (19) // Selecting an item the list view
#define ON_CLICK_COMBOBOX_ITEM      (20) // Selecting an item in the combo box list
#define ON_CLICK_TEXT_BOX           (21) // Activating the text edit box
//---
#define ON_DOUBLE_CLICK             (22) // Left mouse button double click
#define ON_END_EDIT                 (23) // Finishing editing of the value in the edit
//---
#define ON_OPEN_DIALOG_BOX          (24) // Event of opening a dialog box
#define ON_CLOSE_DIALOG_BOX         (25) // Event of closing a dialog box
#define ON_HIDE_CONTEXTMENUS        (26) // Hide all context menus
#define ON_HIDE_BACK_CONTEXTMENUS   (27) // Hide context menus below the current menu item
//---
#define ON_CHANGE_GUI               (28) // Graphical interface has changed
#define ON_CHANGE_DATE              (29) // Changing the date in the calendar
#define ON_CHANGE_COLOR             (30) // Changing the color using the color picker
#define ON_CHANGE_TREE_PATH         (31) // The path in the tree view has changed
#define ON_CHANGE_MOUSE_LEFT_BUTTON (32) // Changing the state of the left mouse button
//---
#define ON_SORT_DATA                (33) // Sorting the data
#define ON_MOUSE_BLUR               (34) // Mouse cursor left the area of the control
#define ON_MOUSE_FOCUS              (35) // Mouse cursor entered the area of the control
#define ON_REDRAW_ELEMENT           (36) // Redrawing control
#define ON_MOVE_TEXT_CURSOR         (37) // Moving the text cursor
#define ON_SUBWINDOW_CHANGE_HEIGHT  (38) // Changing the subwindow height
//---
#define ON_SET_AVAILABLE            (39) // Set available items
#define ON_SET_LOCKED               (40) // Set locked items
//---
#define ON_WINDOW_DRAG_END          (41) // Dragging the form is complete
//+------------------------------------------------------------------+
