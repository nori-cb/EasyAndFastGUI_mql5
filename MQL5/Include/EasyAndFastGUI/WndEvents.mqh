//+------------------------------------------------------------------+
//|                                                    WndEvents.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Defines.mqh"
#include "WndContainer.mqh"
//+------------------------------------------------------------------+
//| Class for event handling                                         |
//+------------------------------------------------------------------+
class CWndEvents : public CWndContainer
  {
protected:
   //--- Class instance for managing the chart
   CChart            m_chart;
   //--- Identifier and window number of the chart
   long              m_chart_id;
   int               m_subwin;
   //--- Program name
   string            m_program_name;
   //--- Short name of the indicator
   string            m_indicator_shortname;
   //--- Index of the active window
   int               m_active_window_index;
   //--- Handle of the expert subwindow
   int               m_subwindow_handle;
   //--- Name of the expert subwindow
   string            m_subwindow_shortname;
   //--- The number of subwindows on the chart after setting the expert subwindow
   int               m_subwindows_total;
   //---
private:
   //--- Event parameters
   int               m_id;
   long              m_lparam;
   double            m_dparam;
   string            m_sparam;
   //---
protected:
                     CWndEvents(void);
                    ~CWndEvents(void);
   //--- Virtual chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {}
   //--- Timer
   void              OnTimerEvent(void);
   //---
public:
   //--- Event handlers of the chart
   void              ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //---
private:
   void              ChartEventCustom(void);
   void              ChartEventClick(void);
   void              ChartEventMouseMove(void);
   void              ChartEventObjectClick(void);
   void              ChartEventEndEdit(void);
   void              ChartEventChartChange(void);
   //--- Checking events in controls
   void              CheckElementsEvents(void);

   //--- Identifying the sub-window number
   void              DetermineSubwindow(void);
   //--- Delete the expert subwindow
   void              DeleteExpertSubwindow(void);
   //--- Check and update the expert subwindow number
   void              CheckExpertSubwindowNumber(void);
   //--- Check and update the indicator subwindow number
   void              CheckSubwindowNumber(void);
   //--- Resize the locked main form
   void              ResizeLockedWindow(void);

   //--- Initialization of event parameters
   void              InitChartEventsParams(const int id,const long lparam,const double dparam,const string sparam);
   //--- Moving the window
   void              MovingWindow(const bool moving_mode=false);
   //--- Checking events of all controls by timer
   void              CheckElementsEventsTimer(void);
   //--- Setting the chart state
   void              SetChartState(void);
   //---
protected:
   //--- Removing the interface
   void              Destroy(void);
   //--- Redraw the window
   void              ResetWindow(void);
   //--- Finishing the creation of GUI
   void              CompletedGUI(void);
   
   //--- Update the location of controls
   void              Moving(void);
   //--- Hide all controls
   void              Hide(void);
   //--- Show controls of the specified window
   void              Show(const uint window_index);
   //--- Redraw the controls
   void              Update(const bool redraw=false);
   
   //--- Move the tooltips to the top layer
   void              ResetTooltips(void);
   //--- Shows controls of the selected tabs only
   void              ShowTabElements(const uint window_index);
   //--- Sets the availability states of controls
   void              SetAvailable(const uint window_index,const bool state);

   //--- Generates the array of controls with timers
   void              FormTimerElementsArray(void);
   //--- Generates the array of available controls
   void              FormAvailableElementsArray(void);
   //--- Generates the array of controls with auto-resizing (X)
   void              FormAutoXResizeElementsArray(void);
   //--- Generates the array of controls with auto-resizing (Y)
   void              FormAutoYResizeElementsArray(void);
   //---
private:
   //--- Dragging the form is complete
   bool              OnWindowEndDrag(void);
   //--- Minimizing/maximizing the form
   bool              OnWindowCollapse(void);
   bool              OnWindowExpand(void);
   //--- Handle changing the window sizes
   bool              OnWindowChangeXSize(void);
   bool              OnWindowChangeYSize(void);
   //--- Enable/disable tooltips
   bool              OnWindowTooltips(void);
   //--- Hiding all context menus below the initiating item
   bool              OnHideBackContextMenus(void);
   //--- Hiding all context menus
   bool              OnHideContextMenus(void);
   //--- Opening a dialog window
   bool              OnOpenDialogBox(void);
   //--- Closing a dialog window
   bool              OnCloseDialogBox(void);
   //--- Determine the available controls
   bool              OnSetAvailable(void);
   //--- Determine the locked controls
   bool              OnSetLocked(void);
   //--- Changes in the graphical interface
   bool              OnChangeGUI(void);
   //---
private:
   //--- Returns the index of the activated window
   int               ActivatedWindowIndex(void);
   //--- Returns the index of the activated main menu
   int               ActivatedMenuBarIndex(void);
   //--- Returns the index of the activated menu item
   int               ActivatedMenuItemIndex(void);
   //--- Returns the index of the activated split button
   int               ActivatedSplitButtonIndex(void);
   //--- Returns the index of the activated combo box
   int               ActivatedComboBoxIndex(void);
   //--- Returns the index of the activated drop-down calendar
   int               ActivatedDropCalendarIndex(void);
   //--- Returns the index of the activated scrollbar
   int               ActivatedScrollIndex(void);
   //--- Returns the index of the activated table
   int               ActivatedTableIndex(void);
   //--- Returns the index of the activated slider
   int               ActivatedSliderIndex(void);
   //--- Returns the index of the activated tree view
   int               ActivatedTreeViewIndex(void);
   //--- Returns the index of the activated subchart
   int               ActivatedSubChartIndex(void);

   //--- Checks and makes the context menu available
   void              CheckContextMenu(CMenuItem &object);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndEvents::CWndEvents(void) : m_chart_id(0),
                               m_subwin(0),
                               m_active_window_index(0),
                               m_indicator_shortname(""),
                               m_program_name(PROGRAM_NAME),
                               m_subwindow_handle(INVALID_HANDLE),
                               m_subwindow_shortname(""),
                               m_subwindows_total(1)
  {
//--- Enable the timer
   if(!::MQLInfoInteger(MQL_TESTER))
      ::EventSetMillisecondTimer(TIMER_STEP_MSC);
//--- Get the ID of the current chart
   m_chart.Attach();
//--- Enable tracking of mouse events
   m_chart.EventMouseMove(true);
//--- Disable calling the command line for the Space and Enter keys
   m_chart.SetInteger(CHART_QUICK_NAVIGATION,false);
//--- Identifying the sub-window number
   DetermineSubwindow();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndEvents::~CWndEvents(void)
  {
//--- Delete the timer
   ::EventKillTimer();
//--- Enable management
   m_chart.MouseScroll(true);
   m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,true);
//--- Disable tracking of mouse events
   m_chart.EventMouseMove(false);
//--- Enable calling the command line for the Space and Enter keys
   m_chart.SetInteger(CHART_QUICK_NAVIGATION,true);
//--- Detach from the chart
   m_chart.Detach();
//--- Delete the indicator subwindow
   DeleteExpertSubwindow();
//--- Delete a comment   
   ::Comment("");
  }
//+------------------------------------------------------------------+
//| Initialization of event variables                                |
//+------------------------------------------------------------------+
void CWndEvents::InitChartEventsParams(const int id,const long lparam,const double dparam,const string sparam)
  {
   m_id     =id;
   m_lparam =lparam;
   m_dparam =dparam;
   m_sparam =sparam;
//--- Get the mouse parameters
   m_mouse.OnEvent(id,lparam,dparam,sparam);
  }
//+------------------------------------------------------------------+
//| Program event handling                                           |
//+------------------------------------------------------------------+
void CWndEvents::ChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Leave, if the array is empty
   if(CWndContainer::WindowsTotal()<1)
      return;
//--- Initialization of event parameter fields
   InitChartEventsParams(id,lparam,dparam,sparam);
//--- Custom event
   ChartEventCustom();
//--- Verification of interface control events
   CheckElementsEvents();
//--- Mouse movement event
   ChartEventMouseMove();
//--- Event of changing the chart properties
   ChartEventChartChange();
  }
//+------------------------------------------------------------------+
//| Verification of the control events                               |
//+------------------------------------------------------------------+
void CWndEvents::CheckElementsEvents(void)
  {
//--- Handling the event of moving the mouse cursor
   if(m_id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the form is in another subwindow of the chart
      if(!m_windows[m_active_window_index].CheckSubwindowNumber())
         return;
      //--- Check only the available controls
      int available_elements_total=CWndContainer::AvailableElementsTotal(m_active_window_index);
      for(int e=0; e<available_elements_total; e++)
        {
         CElement *el=m_wnd[m_active_window_index].m_available_elements[e];
         //--- Checking the focus over controls
         el.CheckMouseFocus();
         //--- Handling the event
         el.OnEvent(m_id,m_lparam,m_dparam,m_sparam);
        }
     }
//--- All events, except the mouse cursor movement
   else
     {
      int elements_total=CWndContainer::ElementsTotal(m_active_window_index);
      for(int e=0; e<elements_total; e++)
        {
         //--- Check only the available controls
         CElement *el=m_wnd[m_active_window_index].m_elements[e];
         if(!el.IsVisible() || !el.IsAvailable() || el.IsLocked())
            continue;
         //--- Handling the event in the control's event handler
         el.OnEvent(m_id,m_lparam,m_dparam,m_sparam);
        }
     }
//--- Forwarding the event to the application file
   OnEvent(m_id,m_lparam,m_dparam,m_sparam);
  }
//+------------------------------------------------------------------+
//| Checking custom events (CHARTEVENT_CUSTOM)                       |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventCustom(void)
  {
//--- If the signal is to determine the available controls
   if(OnSetAvailable())
      return;
//--- If the signal is about the change in the graphical interface
   if(OnChangeGUI())
      return;
//--- If the signal is to determine the locked controls
   if(OnSetLocked())
      return;
//--- If the signal is about the end of dragging the form
   if(OnWindowEndDrag())
      return;
//--- If the signal is to minimize the form
   if(OnWindowCollapse())
      return;
//--- If the signal is to maximize the form
   if(OnWindowExpand())
      return;
//--- If the signal is to resize the controls along the X axis
   if(OnWindowChangeXSize())
      return;
//--- If the signal is to resize the controls along the Y axis
   if(OnWindowChangeYSize())
      return;
//--- If the signal is to enable/disable tooltips
   if(OnWindowTooltips())
      return;
//--- If the signal is for hiding context menus below the initiating item
   if(OnHideBackContextMenus())
      return;
//--- If the signal is for hiding all context menus
   if(OnHideContextMenus())
      return;
//--- If the signal is to open a dialog window
   if(OnOpenDialogBox())
      return;
//--- If the signal is to close a dialog window
   if(OnCloseDialogBox())
      return;
  }
//+------------------------------------------------------------------+
//| CHARTEVENT CLICK event                                           |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventClick(void)
  {
  }
//+------------------------------------------------------------------+
//| CHARTEVENT MOUSE MOVE event                                      |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventMouseMove(void)
  {
//--- Leave, if this is not an event of the cursor displacement
   if(m_id!=CHARTEVENT_MOUSE_MOVE)
      return;
//--- Moving the window
   MovingWindow();
//--- Setting the chart state
   SetChartState();
  }
//+------------------------------------------------------------------+
//| CHARTEVENT OBJECT CLICK event                                    |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventObjectClick(void)
  {
  }
//+------------------------------------------------------------------+
//| CHARTEVENT OBJECT ENDEDIT event                                  |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventEndEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| CHARTEVENT CHART CHANGE event                                    |
//+------------------------------------------------------------------+
void CWndEvents::ChartEventChartChange(void)
  {
//--- Event of changing the chart properties
   if(m_id!=CHARTEVENT_CHART_CHANGE)
      return;
//--- Check and update the expert subwindow number
   CheckExpertSubwindowNumber();
//--- Check and update the indicator subwindow number
   CheckSubwindowNumber();
//--- Moving the window
   MovingWindow(true);
//--- Resize the locked main window
   ResizeLockedWindow();
//--- Redraw chart
   m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CWndEvents::OnTimerEvent(void)
  {
//--- Leave, if mouse cursor is at rest (difference between call is >300 ms) and the left mouse button is released
   if(m_mouse.GapBetweenCalls()>300 && !m_mouse.LeftButtonState())
     {
      int text_boxes_total=CWndContainer::ElementsTotal(m_active_window_index,E_TEXT_BOX);
      for(int e=0; e<text_boxes_total; e++)
         m_wnd[m_active_window_index].m_text_boxes[e].OnEventTimer();
      //---
      return;
     }
//--- Leave, if the array is empty  
   if(CWndContainer::WindowsTotal()<1)
      return;
//--- Checking events of all controls by timer
   CheckElementsEventsTimer();
//--- Redraw the chart, if the window is in movement mode
   if(m_windows[m_active_window_index].ClampingAreaMouse()==PRESSED_INSIDE_HEADER)
      m_chart.Redraw();
  }
//+------------------------------------------------------------------+
//| Event of the end of dragging the form                            |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowEndDrag(void)
  {
//--- If the signal is to minimize the form
   if(m_id!=CHARTEVENT_CUSTOM+ON_WINDOW_DRAG_END)
      return(false);
//--- If the window identifier and the sub-window number match
   if(m_lparam==m_windows[0].Id() && (int)m_dparam==m_subwin)
     {
      //--- Set the mode of displaying in all main controls
      int main_total=MainElementsTotal(m_active_window_index);
      for(int e=0; e<main_total; e++)
        {
         CElement *el=m_wnd[m_active_window_index].m_main_elements[e];
         el.Moving(false);
        }
     }
//--- Update location of all controls
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Form minimization event                                          |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowCollapse(void)
  {
//--- If the signal is to minimize the form
   if(m_id!=CHARTEVENT_CUSTOM+ON_WINDOW_COLLAPSE)
      return(false);
//--- If the window identifier and the sub-window number match
   if(m_lparam==m_windows[0].Id() && (int)m_dparam==m_subwin)
     {
      int elements_total=CWndContainer::ElementsTotal(0);
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_wnd[0].m_elements[e];
         //--- Hide all controls except the form
         if(el.Id()>0)
            el.Hide();
        }
      //--- Reset the form colors
      m_windows[0].ResetColors();
     }
//--- Update location of all controls
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Form maximization event                                          |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowExpand(void)
  {
//--- If the signal is to "Maximize the form"
   if(m_id!=CHARTEVENT_CUSTOM+ON_WINDOW_EXPAND)
      return(false);
//--- Index of the active window
   int awi=m_active_window_index;
//--- If the window identifier and the sub-window number match
   if(m_lparam!=m_windows[awi].Id() || (int)m_dparam!=m_subwin)
      return(true);
//--- Change the height of the window if the mode is enabled
   if(m_windows[awi].AutoYResizeMode())
       m_windows[awi].ChangeWindowHeight(m_chart.HeightInPixels(m_subwin)-3);
//---
   int y_resize_total=CWndContainer::AutoYResizeElementsTotal(awi);
   for(int e=0; e<y_resize_total; e++)
     {
      CElement *el=m_wnd[awi].m_auto_y_resize_elements[e];
      //--- If the mode is enabled, adjust the height
      if(el.AutoYResizeMode())
        {
         el.ChangeHeightByBottomWindowSide();
         el.Update();
        }
     }
//--- Display the controls
   Show(awi);
//--- Show controls of the selected tabs only
   ShowTabElements(awi);
//--- Update to display all changes
   int elements_total=CWndContainer::ElementsTotal(awi);
   for(int e=0; e<elements_total; e++)
     {
      CElement *el=m_wnd[awi].m_elements[e];
      if(el.IsVisible())
         el.Update();
     }
//--- Update location of all controls
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of resizing controls along the X axis                      |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowChangeXSize(void)
  {
//--- If the signal is to "Resize the controls"
   if(m_id!=CHARTEVENT_CUSTOM+ON_WINDOW_CHANGE_XSIZE)
      return(false);
//--- Leave, if window identifiers do not match
   if(m_lparam!=m_windows[m_active_window_index].Id())
      return(true);
//--- Update the position of controls
   Moving();
//--- Update the window
   m_windows[m_active_window_index].Update();
//--- Change the width
   int x_resize_total=CWndContainer::AutoXResizeElementsTotal(m_active_window_index);
   for(int e=0; e<x_resize_total; e++)
     {
      CElement *el=m_wnd[m_active_window_index].m_auto_x_resize_elements[e];
      el.ChangeWidthByRightWindowSide();
      el.Update();
     }
//--- Update to display all changes in the tree views
   int treeviews_total=ElementsTotal(m_active_window_index,E_TREE_VIEW);
   for(int t=0; t<treeviews_total; t++)
     {
      CTreeView *tv=m_wnd[m_active_window_index].m_treeview_lists[t];
      tv.RedrawContentList();
      tv.UpdateContentList();
     }
//--- Update the position of controls
   Moving();
//--- Update location of all controls
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of resizing controls along the Y axis                      |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowChangeYSize(void)
  {
//--- If the signal is to "Resize the controls"
   if(m_id!=CHARTEVENT_CUSTOM+ON_WINDOW_CHANGE_YSIZE)
      return(false);
//--- Leave, if window identifiers do not match
   if(m_lparam!=m_windows[m_active_window_index].Id())
      return(true);
//--- Update the position of controls
   Moving();
//--- Update the window
   m_windows[m_active_window_index].Update();
//--- Change the height
   int y_resize_total=CWndContainer::AutoYResizeElementsTotal(m_active_window_index);
   for(int e=0; e<y_resize_total; e++)
     {
      CElement *el=m_wnd[m_active_window_index].m_auto_y_resize_elements[e];
      el.ChangeHeightByBottomWindowSide();
      el.Update();
     }
//--- Update the position of controls
   Moving();
//--- Update location of all controls
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of enabling/disabling the tooltips                         |
//+------------------------------------------------------------------+
bool CWndEvents::OnWindowTooltips(void)
  {
//--- If the signal is to "Enable/disable tooltips"
   if(m_id!=CHARTEVENT_CUSTOM+ON_WINDOW_TOOLTIPS)
      return(false);
//--- Leave, if window identifiers do not match
   if(m_lparam!=m_windows[0].Id())
      return(true);
//--- Synchronize the tooltips mode across all windows
   int windows_total=WindowsTotal();
   for(int w=0; w<windows_total; w++)
     {
      bool state=m_windows[0].TooltipButtonState();
      m_windows[w].IsTooltip(state);
      //--- Show tooltips in the buttons of windows
      int elements_total=m_windows[w].ElementsTotal();
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_windows[w].Element(e);
         el.ShowTooltip(state);
        }
      //--- Set the mode of displaying in all main controls
      int main_total=MainElementsTotal(w);
      for(int e=0; e<main_total; e++)
        {
         CElement *el=m_wnd[w].m_main_elements[e];
         el.ShowTooltip(state);
        }
     }
//--- Move tooltips to the top layer
   ResetTooltips();
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of hiding the context menus below the initiating item      |
//+------------------------------------------------------------------+
bool CWndEvents::OnHideBackContextMenus(void)
  {
//--- If the signal is for hiding context menus below the initiating item
   if(m_id!=CHARTEVENT_CUSTOM+ON_HIDE_BACK_CONTEXTMENUS)
      return(false);
//--- Iterate over all menus from the last called
   int awi=m_active_window_index;
   int context_menus_total=CWndContainer::ElementsTotal(awi,E_CONTEXT_MENU);
   for(int i=context_menus_total-1; i>=0; i--)
     {
      //--- Pointers to the context menu and its previous node
      CContextMenu *cm=m_wnd[awi].m_context_menus[i];
      CMenuItem    *mi=cm.PrevNodePointer();
      //--- If there is nothing after that point, then...
      if(::CheckPointer(mi)==POINTER_INVALID)
         continue;
      //--- If made it to the signal initiating item, then...
      if(mi.Id()==m_lparam)
        {
         //--- ...if its context menu has no focus, hide it
         if(!cm.MouseFocus())
           {
            cm.Hide();
            mi.IsPressed(false);
            mi.Update(true);
           }
         //--- Stop the loop
         break;
        }
      else
        {
         cm.Hide();
         mi.IsPressed(false);
         mi.Update(true);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of hiding all context menus                                |
//+------------------------------------------------------------------+
bool CWndEvents::OnHideContextMenus(void)
  {
//--- If the signal is for hiding all context menus
   if(m_id!=CHARTEVENT_CUSTOM+ON_HIDE_CONTEXTMENUS)
      return(false);
//--- Hide all context menus
   int awi=m_active_window_index;
   int cm_total=CWndContainer::ElementsTotal(awi,E_CONTEXT_MENU);
   for(int i=0; i<cm_total; i++)
     {
      m_wnd[awi].m_context_menus[i].Hide();
      //---
      if(CheckPointer(m_wnd[awi].m_context_menus[i].PrevNodePointer())!=POINTER_INVALID)
        {
         CMenuItem *mi=m_wnd[awi].m_context_menus[i].PrevNodePointer();
         mi.IsPressed(false);
         mi.Update(true);
        }
     }
//--- Disable main menus
   int menu_bars_total=CWndContainer::ElementsTotal(awi,E_MENU_BAR);
   for(int i=0; i<menu_bars_total; i++)
      m_wnd[awi].m_menu_bars[i].State(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of opening a dialog box                                    |
//+------------------------------------------------------------------+
bool CWndEvents::OnOpenDialogBox(void)
  {
//--- If the signal is to open a dialog window
   if(m_id!=CHARTEVENT_CUSTOM+ON_OPEN_DIALOG_BOX)
      return(false);
//--- Leave, if the message is from another program
   if(m_sparam!=m_program_name)
      return(true);
//--- Iterate over the window array
   int window_total=CWndContainer::WindowsTotal();
   for(int w=0; w<window_total; w++)
     {
      //--- If it is identifier of open window
      if(m_windows[w].Id()==m_lparam)
        {
         //--- Store the index of the window in the form from which the form was brought up
         m_windows[w].PrevActiveWindowIndex(m_active_window_index);
         //--- Activate the form
         m_windows[w].State(true);
         //--- Restore priorities of the left mouse click to the form objects
         m_windows[w].SetZorders();
         //--- Store the index of the activated window
         m_active_window_index=w;
         //--- Show the window
         Show(m_active_window_index);
        }
      //--- Other forms will be locked until the activated window is closed
      else
        {
         //--- Lock the form
         m_windows[w].State(false);
         //--- Zero priorities of the left mouse click for the form controls
         int elements_total=CWndContainer::ElementsTotal(w);
         for(int e=0; e<elements_total; e++)
            m_wnd[w].m_elements[e].ResetZorders();
        }
     }
//--- Hiding tooltips in the previous window
   int prev_window_index=m_windows[m_active_window_index].PrevActiveWindowIndex();
   int tooltips_total=CWndContainer::ElementsTotal(prev_window_index,E_TOOLTIP);
   for(int t=0; t<tooltips_total; t++)
      m_wnd[prev_window_index].m_tooltips[t].FadeOutTooltip();
//--- Show controls of the selected tabs only
   ShowTabElements(m_active_window_index);
//--- Generates the array of visible and at the same time available controls
   FormAvailableElementsArray();
//--- Move tooltips to the top layer
   ResetTooltips();
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of closing a dialog box                                    |
//+------------------------------------------------------------------+
bool CWndEvents::OnCloseDialogBox(void)
  {
//--- If the signal is to close a dialog window
   if(m_id!=CHARTEVENT_CUSTOM+ON_CLOSE_DIALOG_BOX)
      return(false);
//--- Iterate over the window array
   int window_total=CWndContainer::WindowsTotal();
   for(int w=0; w<window_total; w++)
     {
      //--- If it is identifier of open window
      if(m_windows[w].Id()==m_lparam)
        {
         //--- Lock the form
         m_windows[w].State(false);
         //--- Hide the form
         int elements_total=CWndContainer::ElementsTotal(w);
         for(int e=0; e<elements_total; e++)
            m_wnd[w].m_elements[e].Hide();
         //--- Activate the previous form
         m_windows[int(m_dparam)].State(true);
         //--- Redrawing the chart
         m_chart.Redraw();
         break;
        }
     }
//--- Setting the index of the previous window
   m_active_window_index=int(m_dparam);
//--- Restoring priorities of the left mouse click to the activated window
   int elements_total=CWndContainer::ElementsTotal(m_active_window_index);
   for(int e=0; e<elements_total; e++)
      m_wnd[m_active_window_index].m_elements[e].SetZorders();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Event for determining the available controls                     |
//+------------------------------------------------------------------+
bool CWndEvents::OnSetAvailable(void)
  {
//--- If the signal is about changing the availability of controls
   if(m_id!=CHARTEVENT_CUSTOM+ON_SET_AVAILABLE)
      return(false);
//--- Signal to set/restore
   bool is_restore=(bool)m_dparam;
//--- Determine the active controls
   int ww_index =ActivatedWindowIndex();
   int mb_index =ActivatedMenuBarIndex();
   int mi_index =ActivatedMenuItemIndex();
   int sb_index =ActivatedSplitButtonIndex();
   int cb_index =ActivatedComboBoxIndex();
   int dc_index =ActivatedDropCalendarIndex();
   int sc_index =ActivatedScrollIndex();
   int tl_index =ActivatedTableIndex();
   int sd_index =ActivatedSliderIndex();
   int tv_index =ActivatedTreeViewIndex();
   int ch_index =ActivatedSubChartIndex();
//--- If the signal is to determine the available controls, disable access first 
   if(!is_restore)
      SetAvailable(m_active_window_index,false);
//--- Restore only if there are no activated items
   else
     {
      if(ww_index==WRONG_VALUE && mb_index==WRONG_VALUE && mi_index==WRONG_VALUE && 
         sb_index==WRONG_VALUE && dc_index==WRONG_VALUE && cb_index==WRONG_VALUE && 
         sc_index==WRONG_VALUE && tl_index==WRONG_VALUE && sd_index==WRONG_VALUE && 
         tv_index==WRONG_VALUE && ch_index==WRONG_VALUE)
        {
         SetAvailable(m_active_window_index,true);
         return(true);
        }
     }
//--- If (1) the signal is to determine the available controls or (2) to restore the drop-down calendar
   if(!is_restore || (is_restore && dc_index!=WRONG_VALUE))
     {
      CElement *el=NULL;
      //--- Window
      if(ww_index!=WRONG_VALUE)
        { el=m_windows[m_active_window_index];                        }
      //--- Main menu
      else if(mb_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_menu_bars[mb_index];      }
      //--- Menu item
      else if(mi_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_menu_items[mi_index];     }
      //--- Split button
      else if(sb_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_split_buttons[sb_index];  }
      //--- Drop-down calendar without a drop-down list
      else if(dc_index!=WRONG_VALUE && cb_index==WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_drop_calendars[dc_index]; }
      //--- Drop-down list
      else if(cb_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_combo_boxes[cb_index];    }
      //--- Scrollbar
      else if(sc_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_scrolls[sc_index];        }
      //--- Table
      else if(tl_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_tables[tl_index];         }
      //--- Slider
      else if(sd_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_sliders[sd_index];        }
      //--- Tree view
      else if(tv_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_treeview_lists[tv_index]; }
      //--- Subchart
      else if(ch_index!=WRONG_VALUE)
        { el=m_wnd[m_active_window_index].m_sub_charts[ch_index];     }
      //--- Leave, if the control pointer is not received
      if(::CheckPointer(el)==POINTER_INVALID)
         {
          return(true);
         }
      //--- Block for the main menu
      if(mb_index!=WRONG_VALUE)
        {
         //--- Make the main menu and its visible context menus available
         el.IsAvailable(true);
         //--- 
         CMenuBar *mb=dynamic_cast<CMenuBar*>(el);
         int items_total=mb.ItemsTotal();
         for(int i=0; i<items_total; i++)
           {
            CMenuItem *mi=mb.GetItemPointer(i);
            mi.IsAvailable(true);
            //--- Checks and makes the context menu available
            CheckContextMenu(mi);
           }
        }
      //--- Block for the menu item
      if(mi_index!=WRONG_VALUE)
        {
         CMenuItem *mi=dynamic_cast<CMenuItem*>(el);
         mi.IsAvailable(true);
         //--- Checks and makes the context menu available
         CheckContextMenu(mi);
        }
      //--- Block for the scrollbar
      else if(sc_index!=WRONG_VALUE)
        {
         //--- Make available starting from the main node
         el.MainPointer().IsAvailable(true);
        }
      //--- Block for the tree view
      else if(tv_index!=WRONG_VALUE)
        {
         //--- Lock all controls except the main control
         CTreeView *tv=dynamic_cast<CTreeView*>(el);
         tv.IsAvailable(true,true);
         int total=tv.ElementsTotal();
         for(int i=0; i<total; i++)
            tv.Element(i).IsAvailable(false);
        }
      else
        {
         //--- Make the control available
         el.IsAvailable(true);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| ON_SET_LOCKED event                                              |
//+------------------------------------------------------------------+
bool CWndEvents::OnSetLocked(void)
  {
//--- If the signal is to lock controls
   if(m_id!=CHARTEVENT_CUSTOM+ON_SET_LOCKED)
      return(false);
//---
   bool find_flag=false;
//---
   int elements_total=CWndContainer::MainElementsTotal(m_active_window_index);
   for(int e=0; e<elements_total; e++)
     {
      CElement *el=m_wnd[m_active_window_index].m_main_elements[e];
      //---
      if(m_lparam!=el.Id())
        {
         if(find_flag)
            break;
         //---        
         continue;
        }
      //--- 
      find_flag=true;
      //---
      int total=el.ElementsTotal();
      for(int i=0; i<total; i++)
         el.Element(i).Update(true);
      //---
      el.Update(true);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Event of changes in the graphical interface                      |
//+------------------------------------------------------------------+
bool CWndEvents::OnChangeGUI(void)
  {
//--- If the signal is about the change in the graphical interface
   if(m_id!=CHARTEVENT_CUSTOM+ON_CHANGE_GUI)
      return(false);
//--- Generates the array of visible and at the same time available controls
   FormAvailableElementsArray();
//--- Move tooltips to the top layer
   ResetTooltips();
//--- Redraw the chart
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated window                        |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedWindowIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=WindowsTotal();
   for(int i=0; i<total; i++)
     {
      if(m_windows[i].ResizeState())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated main menu                     |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedMenuBarIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_MENU_BAR);
   for(int i=0; i<total; i++)
     {
      CMenuBar *el=m_wnd[m_active_window_index].m_menu_bars[i];
      if(el.State())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated menu item                     |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedMenuItemIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_MENU_ITEM);
   for(int i=0; i<total; i++)
     {
      CMenuItem *el=m_wnd[m_active_window_index].m_menu_items[i];
      if(el.GetContextMenuPointer().IsVisible())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated split button                  |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedSplitButtonIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_SPLIT_BUTTON);
   for(int i=0; i<total; i++)
     {
      CSplitButton *el=m_wnd[m_active_window_index].m_split_buttons[i];
      if(el.GetContextMenuPointer().IsVisible())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated combo box                     |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedComboBoxIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_COMBO_BOX);
   for(int i=0; i<total; i++)
     {
      CComboBox *el=m_wnd[m_active_window_index].m_combo_boxes[i];
      if(el.GetListViewPointer().IsVisible())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated drop-down calendar            |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedDropCalendarIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_DROP_CALENDAR);
   for(int i=0; i<total; i++)
     {
      CDropCalendar *el=m_wnd[m_active_window_index].m_drop_calendars[i];
      if(el.GetCalendarPointer().IsVisible())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated scrollbar                     |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedScrollIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_SCROLL);
   for(int i=0; i<total; i++)
     {
      CScroll *el=m_wnd[m_active_window_index].m_scrolls[i];
      if(el.State())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated table                         |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedTableIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_TABLE);
   for(int i=0; i<total; i++)
     {
      CTable *el=m_wnd[m_active_window_index].m_tables[i];
      if(el.ColumnResizeControl())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated slider                        |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedSliderIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_SLIDER);
   for(int i=0; i<total; i++)
     {
      CSlider *el=m_wnd[m_active_window_index].m_sliders[i];
      if(el.State())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated tree view                     |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedTreeViewIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_TREE_VIEW);
   for(int i=0; i<total; i++)
     {
      CTreeView *el=m_wnd[m_active_window_index].m_treeview_lists[i];
      //--- Go to the next, if the tabs mode is enabled
      if(el.TabItemsMode())
         continue;
      //--- If in the process of changing the width of lists 
      if(el.GetMousePointer().State())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the activated subchart                      |
//+------------------------------------------------------------------+
int CWndEvents::ActivatedSubChartIndex(void)
  {
   int index=WRONG_VALUE;
//---
   int total=ElementsTotal(m_active_window_index,E_SUB_CHART);
   for(int i=0; i<total; i++)
     {
      CStandardChart *el=m_wnd[m_active_window_index].m_sub_charts[i];
      if(el.GetMousePointer().IsVisible())
        {
         index=i;
         break;
        }
     }
   return(index);
  }
//+------------------------------------------------------------------+
//| Recursively check and make the context menus available           |
//+------------------------------------------------------------------+
void CWndEvents::CheckContextMenu(CMenuItem &object)
  {
//--- Getting the context menu pointer
   CContextMenu *cm=object.GetContextMenuPointer();
//--- Leave, if there is no context menu in the item
   if(::CheckPointer(cm)==POINTER_INVALID)
      return;
//--- Leave, if there is a context menu, but it is hidden
   if(!cm.IsVisible())
      return;
//--- Set the available control signs
   cm.IsAvailable(true);
//---
   int items_total=cm.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Set the available control signs
      CMenuItem *mi=cm.GetItemPointer(i);
      mi.IsAvailable(true);
      //--- Check if this item has a context menu
      CheckContextMenu(mi);
     }
  }
//+------------------------------------------------------------------+
//| Moving the window                                                |
//+------------------------------------------------------------------+
void CWndEvents::MovingWindow(const bool moving_mode=false)
  {
//--- If the management is delegated to the window, identify its location
   if(!moving_mode)
      if(m_windows[m_active_window_index].ClampingAreaMouse()!=PRESSED_INSIDE_HEADER)
         return;
//--- Moving the window
   int x =m_windows[m_active_window_index].X();
   int y =m_windows[m_active_window_index].Y();
   m_windows[m_active_window_index].Moving(x,y);
//--- Moving controls
   int main_total=MainElementsTotal(m_active_window_index);
   for(int e=0; e<main_total; e++)
     {
      CElement *el=m_wnd[m_active_window_index].m_main_elements[e];
      el.Moving();
     }
  }
//+------------------------------------------------------------------+
//| Checking all control events by the timer                         |
//+------------------------------------------------------------------+
void CWndEvents::CheckElementsEventsTimer(void)
  {
   int awi=m_active_window_index;
   int timer_elements_total=CWndContainer::TimerElementsTotal(awi);
   for(int e=0; e<timer_elements_total; e++)
     {
      CElement *el=m_wnd[awi].m_timer_elements[e];
      if(el.IsVisible())
         el.OnEventTimer();
     }
  }
//+------------------------------------------------------------------+
//| Identifying the sub-window number                                |
//+------------------------------------------------------------------+
void CWndEvents::DetermineSubwindow(void)
  {
//--- Leave, if the program type is "Script"
   if(PROGRAM_TYPE==PROGRAM_SCRIPT)
      return;
//--- Reset the last error
   ::ResetLastError();
//--- If the program type is "Expert"
   if(PROGRAM_TYPE==PROGRAM_EXPERT)
     {
      //--- Leave, if the graphical interface of the expert is required in the main window
      if(!EXPERT_IN_SUBWINDOW)
         return;
      //--- Get the handle of the placeholder indicator (empty subwindow)
      m_subwindow_handle=iCustom(::Symbol(),::Period(),"::Indicators\\SubWindow.ex5");
      //--- If there is no such indicator, report the error to the log
      if(m_subwindow_handle==INVALID_HANDLE)
         ::Print(__FUNCTION__," > Error getting the indicator handle in the directory ::Indicators\\SubWindow.ex5 !");
      //--- If the handle is obtained, then the indicator exists, included in the application as a resource,
      //    and this means that the graphical interface of the application must be placed in the subwindow.
      else
        {
         //--- Get the number of subwindows on the chart
         int subwindows_total=(int)::ChartGetInteger(m_chart_id,CHART_WINDOWS_TOTAL);
         //--- Set the subwindow for the graphical interface of the expert
         if(::ChartIndicatorAdd(m_chart_id,subwindows_total,m_subwindow_handle))
           {
            //--- Store the subwindow number and the current number of subwindows on the chart
            m_subwin           =subwindows_total;
            m_subwindows_total =subwindows_total+1;
            //--- Get and store the short name of the expert subwindow
            m_subwindow_shortname=::ChartIndicatorName(m_chart_id,m_subwin,0);
           }
         //--- If the subwindow was not set
         else
            ::Print(__FUNCTION__," > Error setting the expert subwindow! Error code: ",::GetLastError());
        }
      //---
      return;
     }
//--- Identifying the number of the indicator window
   m_subwin=::ChartWindowFind();
//--- Leave, if failed to identify the number
   if(m_subwin<0)
     {
      ::Print(__FUNCTION__," > Error when identifying the sub-window number: ",::GetLastError());
      return;
     }
//--- If this is not the main window of the chart
   if(m_subwin>0)
     {
      //--- Get the common number of indicators in the specified sub-window
      int total=::ChartIndicatorsTotal(m_chart_id,m_subwin);
      //--- Get the short name of the last indicator in the list
      string indicator_name=::ChartIndicatorName(m_chart_id,m_subwin,total-1);
      //--- If the sub-window already contains the indicator, remove the program from the chart
      if(total!=1)
        {
         ::Print(__FUNCTION__," > This window already contains an indicator.");
         ::ChartIndicatorDelete(m_chart_id,m_subwin,indicator_name);
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| Delete the expert subwindow                                      |
//+------------------------------------------------------------------+
void CWndEvents::DeleteExpertSubwindow(void)
  {
//--- Leave, if this is not expert
   if(PROGRAM_TYPE!=PROGRAM_EXPERT)
      return;
//--- Leave, if the handle is invalid
   if(m_subwindow_handle==INVALID_HANDLE)
      return;
//--- Get the number of windows on the chart
   int windows_total=(int)::ChartGetInteger(m_chart_id,CHART_WINDOWS_TOTAL);
//--- find the expert subwindow
   for(int w=0; w<windows_total; w++)
     {
      //--- Get the short name of the expert subwindow (the SubWindow.ex5 indicator)
      string indicator_name=::ChartIndicatorName(m_chart_id,w,0);
      //--- Go to the next, if this is not the expert subwindow
      if(indicator_name!=m_subwindow_shortname || w!=m_subwin)
         continue;
      //--- Delete the expert subwindow
      if(!::ChartIndicatorDelete(m_chart_id,m_subwin,indicator_name))
         ::Print(__FUNCTION__," > Error deleting the expert subwindow! Error code: ",::GetLastError());
     }
  }
//+------------------------------------------------------------------+
//| Check and update the expert subwindow number                     |
//+------------------------------------------------------------------+
void CWndEvents::CheckExpertSubwindowNumber(void)
  {
//--- Leave, if (1) this in not an expert or (2) the graphical interface of the expert in the main window
   if(PROGRAM_TYPE!=PROGRAM_EXPERT || !EXPERT_IN_SUBWINDOW)
      return;
//--- Get the number of subwindows on the chart
   int subwindows_total=(int)::ChartGetInteger(m_chart_id,CHART_WINDOWS_TOTAL);
//--- Leave, if the number of subwindows and the number of indicators have not changed
   if(subwindows_total==m_subwindows_total)
      return;
//--- Store the current number of subwindows
   m_subwindows_total=subwindows_total;
//--- For checking if expert subwindow is present
   bool is_subwindow=false;
//--- find the expert subwindow
   for(int sw=0; sw<subwindows_total; sw++)
     {
      //--- Stop the cycle, if the expert subwindow has been found
      if(is_subwindow)
         break;
      //--- The number of indicators in this window/subwindow
      int indicators_total=::ChartIndicatorsTotal(m_chart_id,sw);
      //--- Iterate over all indicators in the window 
      for(int i=0; i<indicators_total; i++)
        {
         //--- Get the short name of the indicator
         string indicator_name=::ChartIndicatorName(m_chart_id,sw,i);
         //--- If this is not the expert subwindow, go to the next
         if(indicator_name!=m_subwindow_shortname)
            continue;
         //--- Mark that expert has a subwindow
         is_subwindow=true;
         //--- If the subwindow number has changed, then 
         //    it is necessary to store the new number in all controls of the main form
         if(sw!=m_subwin)
           {
            //--- Store the subwindow number
            m_subwin=sw;
            //--- Store it in all the controls of the main form of the interface
            int elements_total=CWndContainer::ElementsTotal(0);
            for(int e=0; e<elements_total; e++)
               m_wnd[0].m_elements[e].SubwindowNumber(m_subwin);
           }
         //---
         break;
        }
     }
//--- If the expert subwindow was not found, remove the expert
   if(!is_subwindow)
     {
      ::Print(__FUNCTION__," > Deleting expert subwindow causes the expert to be removed!");
      //--- Removing the EA from the chart
      ::ExpertRemove();
     }
  }
//+------------------------------------------------------------------+
//| Verifying and updating the number of the program window          |
//+------------------------------------------------------------------+
void CWndEvents::CheckSubwindowNumber(void)
  {
//--- Leave, if this is not indicator
   if(PROGRAM_TYPE!=PROGRAM_INDICATOR)
      return;
//--- If the program in the sub-window and numbers do not match
   if(m_subwin!=0 && m_subwin!=::ChartWindowFind())
     {
      //--- Identify the sub-window number
      DetermineSubwindow();
      //--- Store in all controls
      int windows_total=CWndContainer::WindowsTotal();
      for(int w=0; w<windows_total; w++)
        {
         int elements_total=CWndContainer::ElementsTotal(w);
         for(int e=0; e<elements_total; e++)
            m_wnd[w].m_elements[e].SubwindowNumber(m_subwin);
        }
     }
  }
//+------------------------------------------------------------------+
//| Resize the locked main window                                    |
//+------------------------------------------------------------------+
void CWndEvents::ResizeLockedWindow(void)
  {
//--- Store in all controls
   int windows_total=CWndContainer::WindowsTotal();
//--- Leave, if the interface has not been created
   if(windows_total<1)
      return;
//--- Resize all controls of the locked form, if one the modes is enabled
   if(m_windows[0].IsLocked() && (m_windows[0].AutoXResizeMode() || m_windows[0].AutoXResizeMode()))
     {
      int elements_total=CWndContainer::ElementsTotal(0);
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_wnd[0].m_elements[e];
         //--- If this is a form
         if(dynamic_cast<CWindow*>(el)!=NULL)
           {
            el.OnEvent(m_id,m_lparam,m_dparam,m_sparam);
            continue;
           }
         //--- Resize all controls with this mode enabled
         if(el.AutoXResizeMode())
            el.ChangeWidthByRightWindowSide();
         //--- Resize all controls with this mode enabled
         if(el.AutoYResizeMode())
            el.ChangeHeightByBottomWindowSide();
         //--- Update the position of objects
         el.Moving();
        }
      //--- Update (store) the chart properties of other forms
      for(int w=1; w<windows_total; w++)
         m_windows[w].SetWindowProperties();
      //--- Redraw the activated window
      ResetWindow();
      //--- Update
      Update();
     }
  }
//+------------------------------------------------------------------+
//| Redraw the window                                                |
//+------------------------------------------------------------------+
void CWndEvents::ResetWindow(void)
  {
//--- Leave, if there is no window yet
   if(CWndContainer::WindowsTotal()<1)
      return;
//--- Redraw the window and its controls
   m_windows[m_active_window_index].Reset();
   int elements_total=CWndContainer::ElementsTotal(m_active_window_index);
   for(int e=0; e<elements_total; e++)
     {
      CElement *el=m_wnd[m_active_window_index].m_elements[e];
      if(el.IsVisible())
         el.Reset();
     }
//--- Show controls of the selected tabs only
   ShowTabElements(m_active_window_index);
  }
//+------------------------------------------------------------------+
//| Removing all objects                                             |
//+------------------------------------------------------------------+
void CWndEvents::Destroy(void)
  {
//--- Set the index of the main window
   m_active_window_index=0;
//--- Get the number of windows
   int window_total=CWndContainer::WindowsTotal();
//--- Iterate over the window array
   for(int w=0; w<window_total; w++)
     {
      //--- Activate the main window
      if(m_windows[w].WindowType()==W_MAIN)
         m_windows[w].State(true);
      //--- Lock dialog windows
      else
         m_windows[w].State(false);
     }
//--- Empty control arrays
   for(int w=0; w<window_total; w++)
     {
      int elements_total=CWndContainer::ElementsTotal(w);
      for(int e=0; e<elements_total; e++)
        {
         //--- If the pointer is invalid, move to the next
         if(::CheckPointer(m_wnd[w].m_elements[e])==POINTER_INVALID)
            continue;
         //--- Delete control objects
         m_wnd[w].m_elements[e].Delete();
        }
      //--- Empty control arrays
      ::ArrayFree(m_wnd[w].m_elements);
      ::ArrayFree(m_wnd[w].m_main_elements);
      ::ArrayFree(m_wnd[w].m_timer_elements);
      ::ArrayFree(m_wnd[w].m_auto_x_resize_elements);
      ::ArrayFree(m_wnd[w].m_auto_y_resize_elements);
      ::ArrayFree(m_wnd[w].m_available_elements);
      ::ArrayFree(m_wnd[w].m_menu_bars);
      ::ArrayFree(m_wnd[w].m_menu_items);
      ::ArrayFree(m_wnd[w].m_context_menus);
      ::ArrayFree(m_wnd[w].m_combo_boxes);
      ::ArrayFree(m_wnd[w].m_split_buttons);
      ::ArrayFree(m_wnd[w].m_drop_lists);
      ::ArrayFree(m_wnd[w].m_scrolls);
      ::ArrayFree(m_wnd[w].m_tables);
      ::ArrayFree(m_wnd[w].m_tabs);
      ::ArrayFree(m_wnd[w].m_calendars);
      ::ArrayFree(m_wnd[w].m_drop_calendars);
      ::ArrayFree(m_wnd[w].m_sub_charts);
      ::ArrayFree(m_wnd[w].m_pictures_slider);
      ::ArrayFree(m_wnd[w].m_time_edits);
      ::ArrayFree(m_wnd[w].m_text_boxes);
      ::ArrayFree(m_wnd[w].m_tooltips);
      ::ArrayFree(m_wnd[w].m_treeview_lists);
      ::ArrayFree(m_wnd[w].m_file_navigators);
     }
//--- Empty form arrays
   ::ArrayFree(m_wnd);
   ::ArrayFree(m_windows);
  }
//+------------------------------------------------------------------+
//| Finishing the creation of GUI                                    |
//+------------------------------------------------------------------+
void CWndEvents::CompletedGUI(void)
  {
//--- Leave, if there is no window yet
   int windows_total=CWndContainer::WindowsTotal();
   if(windows_total<1)
      return;
//--- Show the comment informing the user
   ::Comment("Update. Please wait...");
//--- Hide the controls
   Hide();
//--- Draw the controls
   Update(true);
//--- Show the controls of the activated window
   Show(m_active_window_index);
//--- Generate the array of controls with timers
   FormTimerElementsArray();
//--- Generates the array of visible and at the same time available controls
   FormAvailableElementsArray();
//--- Generate the arrays of controls with auto-resizing
   FormAutoXResizeElementsArray();
   FormAutoYResizeElementsArray();
//--- Redraw the chart
   m_chart.Redraw();
//--- Clear the comment
   ::Comment("");
  }
//+------------------------------------------------------------------+
//| Moving controls                                                  |
//+------------------------------------------------------------------+
void CWndEvents::Moving(void)
  {
//--- Update the position of controls
   int main_total=MainElementsTotal(m_active_window_index);
   for(int e=0; e<main_total; e++)
     {
      CElement *el=m_wnd[m_active_window_index].m_main_elements[e];
      el.Moving(false);
     }
  }
//+------------------------------------------------------------------+
//| Hide the controls                                                |
//+------------------------------------------------------------------+
void CWndEvents::Hide(void)
  {
   int windows_total=CWndContainer::WindowsTotal();
   for(int w=0; w<windows_total; w++)
     {
      m_windows[w].Hide();
      int main_total=MainElementsTotal(w);
      for(int e=0; e<main_total; e++)
        {
         CElement *el=m_wnd[w].m_main_elements[e];
         el.Hide();
        }
     }
  }
//+------------------------------------------------------------------+
//| Show controls of the specified window                            |
//+------------------------------------------------------------------+
void CWndEvents::Show(const uint window_index)
  {
//--- Show controls of the specified window
   m_windows[window_index].Show();
//--- If the window is not minimized
   if(!m_windows[window_index].IsMinimized())
     {
      int main_total=MainElementsTotal(window_index);
      for(int e=0; e<main_total; e++)
        {
         CElement *el=m_wnd[window_index].m_main_elements[e];
         //--- Show the control, if it is (1) not drop-down and (2) its main control is not tab
         if(!el.IsDropdown() && dynamic_cast<CTabs*>(el.MainPointer())==NULL)
            el.Show();
        }
      //--- Show controls of the selected tabs only
      ShowTabElements(window_index);
     }
  }
//+------------------------------------------------------------------+
//| Redraw the controls                                              |
//+------------------------------------------------------------------+
void CWndEvents::Update(const bool redraw=false)
  {
   int windows_total=CWndContainer::WindowsTotal();
   for(int w=0; w<windows_total; w++)
     {
      //--- Redraw the controls
      int elements_total=CWndContainer::ElementsTotal(w);
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_wnd[w].m_elements[e];
         el.Update(redraw);
        }
     }
  }
//+------------------------------------------------------------------+
//| Move the tooltips to the top layer                               |
//+------------------------------------------------------------------+
void CWndEvents::ResetTooltips(void)
  {
//--- Move tooltips to the top layer
   int window_total=CWndContainer::WindowsTotal();
   for(int w=0; w<window_total; w++)
     {
      int tooltips_total=CWndContainer::ElementsTotal(w,E_TOOLTIP);
      for(int t=0; t<tooltips_total; t++)
         m_wnd[w].m_tooltips[t].Reset();
     }
  }
//+------------------------------------------------------------------+
//| Sets the availability states of controls                         |
//+------------------------------------------------------------------+
void CWndEvents::SetAvailable(const uint window_index,const bool state)
  {
//--- Get the number of the main controls
   int main_total=MainElementsTotal(window_index);
//--- If it is necessary to make the controls unavailable
   if(!state)
     {
      m_windows[window_index].IsAvailable(state);
      for(int e=0; e<main_total; e++)
        {
         CElement *el=m_wnd[window_index].m_main_elements[e];
         el.IsAvailable(state);
        }
     }
   else
     {
      m_windows[window_index].IsAvailable(state);
      for(int e=0; e<main_total; e++)
        {
         CElement *el=m_wnd[window_index].m_main_elements[e];
         //--- If it is a tree view
         if(dynamic_cast<CTreeView*>(el)!=NULL)
           {
            CTreeView *tv=dynamic_cast<CTreeView*>(el);
            tv.IsAvailable(true);
            continue;
           }
         //--- If it is a file navigator
         if(dynamic_cast<CFileNavigator*>(el)!=NULL)
           {
            CFileNavigator *fn =dynamic_cast<CFileNavigator*>(el);
            CTreeView      *tv =fn.GetTreeViewPointer();
            fn.IsAvailable(state);
            tv.IsAvailable(state);
            continue;
           }
         //--- Make the control available
         el.IsAvailable(state);
        }
     }
  }
//+------------------------------------------------------------------+
//| Shows controls of the selected tabs only                         |
//+------------------------------------------------------------------+
void CWndEvents::ShowTabElements(const uint window_index)
  {
//--- Simple tabs
   int tabs_total=CWndContainer::ElementsTotal(window_index,E_TABS);
   for(int t=0; t<tabs_total; t++)
     {
      CTabs *el=m_wnd[window_index].m_tabs[t];
      if(el.IsVisible())
         el.ShowTabElements();
     }
//--- Tree view tabs
   int treeview_total=CWndContainer::ElementsTotal(window_index,E_TREE_VIEW);
   for(int tv=0; tv<treeview_total; tv++)
      m_wnd[window_index].m_treeview_lists[tv].ShowTabElements();
  }
//+------------------------------------------------------------------+
//| Generates the array of controls with timers                      |
//+------------------------------------------------------------------+
void CWndEvents::FormTimerElementsArray(void)
  {
   int windows_total=CWndContainer::WindowsTotal();
   for(int w=0; w<windows_total; w++)
     {
      int elements_total=CWndContainer::ElementsTotal(w);
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_wnd[w].m_elements[e];
         //---
         if(dynamic_cast<CCalendar    *>(el)!=NULL ||
            dynamic_cast<CColorPicker *>(el)!=NULL ||
            dynamic_cast<CListView    *>(el)!=NULL ||
            dynamic_cast<CTable       *>(el)!=NULL ||
            dynamic_cast<CTextBox     *>(el)!=NULL ||
            dynamic_cast<CTextEdit    *>(el)!=NULL ||
            dynamic_cast<CTreeView    *>(el)!=NULL)
           {
            CWndContainer::AddTimerElement(w,el);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Generates the array of available controls                        |
//+------------------------------------------------------------------+
void CWndEvents::FormAvailableElementsArray(void)
  {
//--- Window index
   int awi=m_active_window_index;
//--- The total number of controls
   int elements_total=CWndContainer::ElementsTotal(awi);
//--- Clear the array
   ::ArrayFree(m_wnd[awi].m_available_elements);
//---
   for(int e=0; e<elements_total; e++)
     {
      CElement *el=m_wnd[awi].m_elements[e];
      //--- Add only the controls that are visible and available for processing
      if(!el.IsVisible() || !el.IsAvailable() || el.IsLocked())
         continue;
      //--- Exclude the controls that do not require handling the mouseover events
      if(dynamic_cast<CButtonsGroup   *>(el)==NULL &&
         dynamic_cast<CFileNavigator  *>(el)==NULL &&
         dynamic_cast<CLineGraph      *>(el)==NULL &&
         dynamic_cast<CPicture        *>(el)==NULL &&
         dynamic_cast<CPicturesSlider *>(el)==NULL &&
         dynamic_cast<CProgressBar    *>(el)==NULL &&
         dynamic_cast<CSeparateLine   *>(el)==NULL &&
         dynamic_cast<CStatusBar      *>(el)==NULL &&
         dynamic_cast<CTabs           *>(el)==NULL &&
         dynamic_cast<CTextLabel      *>(el)==NULL)
        {
         AddAvailableElement(awi,el);
        }
     }
  }
//+------------------------------------------------------------------+
//| Generates the array of controls with auto-resizing (X)           |
//+------------------------------------------------------------------+
void CWndEvents::FormAutoXResizeElementsArray(void)
  {
   int windows_total=CWndContainer::WindowsTotal();
   for(int w=0; w<windows_total; w++)
     {
      int elements_total=CWndContainer::ElementsTotal(w);
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_wnd[w].m_elements[e];
         //--- Add only the controls with the auto-resizing mode enabled
         if(!el.AutoXResizeMode())
            continue;
         //---
         if(dynamic_cast<CButton        *>(el)!=NULL ||
            dynamic_cast<CFileNavigator *>(el)!=NULL ||
            dynamic_cast<CLineGraph     *>(el)!=NULL ||
            dynamic_cast<CListView      *>(el)!=NULL ||
            dynamic_cast<CMenuBar       *>(el)!=NULL ||
            dynamic_cast<CProgressBar   *>(el)!=NULL ||
            dynamic_cast<CStandardChart *>(el)!=NULL ||
            dynamic_cast<CStatusBar     *>(el)!=NULL ||
            dynamic_cast<CTable         *>(el)!=NULL ||
            dynamic_cast<CTabs          *>(el)!=NULL ||
            dynamic_cast<CTextBox       *>(el)!=NULL ||
            dynamic_cast<CTextEdit      *>(el)!=NULL ||
            dynamic_cast<CTreeView      *>(el)!=NULL)
           {
            CWndContainer::AddAutoXResizeElement(w,el);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Generates the array of controls with auto-resizing (Y)           |
//+------------------------------------------------------------------+
void CWndEvents::FormAutoYResizeElementsArray(void)
  {
   int windows_total=CWndContainer::WindowsTotal();
   for(int w=0; w<windows_total; w++)
     {
      int elements_total=CWndContainer::ElementsTotal(w);
      for(int e=0; e<elements_total; e++)
        {
         CElement *el=m_wnd[w].m_elements[e];
         //--- Add only the controls with the auto-resizing mode enabled
         if(!el.AutoYResizeMode())
            continue;
         //---
         if(dynamic_cast<CLineGraph     *>(el)!=NULL ||
            dynamic_cast<CListView      *>(el)!=NULL ||
            dynamic_cast<CStandardChart *>(el)!=NULL ||
            dynamic_cast<CTable         *>(el)!=NULL ||
            dynamic_cast<CTabs          *>(el)!=NULL ||
            dynamic_cast<CTextBox       *>(el)!=NULL)
           {
            CWndContainer::AddAutoYResizeElement(w,el);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Sets the state of the chart                                      |
//+------------------------------------------------------------------+
void CWndEvents::SetChartState(void)
  {
   int awi=m_active_window_index;
//--- For identifying the event when management has to be disabled
   bool condition=false;
//--- Check windows
   int windows_total=CWndContainer::WindowsTotal();
   for(int i=0; i<windows_total; i++)
     {
      //--- Move to the following form if this one is hidden

      if(!m_windows[i].IsVisible())
         continue;
      //--- Check conditions in the internal handler of the form
      m_windows[i].OnEvent(m_id,m_lparam,m_dparam,m_sparam);
      //--- If there is a focus, register this
      if(m_windows[i].MouseFocus())
         condition=true;
     }
//--- Check the focus of the drop-down lists
   if(!condition)
     {
      //--- Get the total of the drop-down list views
      int drop_lists_total=CWndContainer::ElementsTotal(awi,E_DROP_LIST);
      for(int i=0; i<drop_lists_total; i++)
        {
         //--- Get the pointer to the drop-down list view
         CListView *lv=m_wnd[awi].m_drop_lists[i];
         //--- If the list view is activated (visible)
         if(lv.IsVisible())
           {
            //--- Check the focus over the list view and the state of its scrollbar
            if(m_wnd[awi].m_drop_lists[i].MouseFocus() || lv.ScrollState())
              {
               condition=true;
               break;
              }
           }
        }
     }
//--- Check the focus of the drop-down calendars
   if(!condition)
     {
      int drop_calendars_total=CWndContainer::ElementsTotal(awi,E_DROP_CALENDAR);
      for(int i=0; i<drop_calendars_total; i++)
        {
         if(m_wnd[awi].m_drop_calendars[i].GetCalendarPointer().MouseFocus())
           {
            condition=true;
            break;
           }
        }
     }
//--- Check the focus of the context menus
   if(!condition)
     {
      //--- Check the total of drop-down context menus
      int context_menus_total=CWndContainer::ElementsTotal(awi,E_CONTEXT_MENU);
      for(int i=0; i<context_menus_total; i++)
        {
         //--- If the focus is over the context menu
         if(m_wnd[awi].m_context_menus[i].MouseFocus())
           {
            condition=true;
            break;
           }
        }
     }
//--- Check the state of a scrollbar
   if(!condition)
     {
      int scrolls_total=CWndContainer::ElementsTotal(awi,E_SCROLL);
      for(int i=0; i<scrolls_total; i++)
        {
         if(((CScroll*)m_wnd[awi].m_scrolls[i]).State())
           {
            condition=true;
            break;
           }
        }
     }
//--- Set the state of a chart in all forms
   for(int i=0; i<windows_total; i++)
      m_windows[i].CustomEventChartState(condition);
  }
//+------------------------------------------------------------------+
