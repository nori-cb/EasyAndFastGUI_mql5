//+------------------------------------------------------------------+
//|                                                 WndContainer.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#property strict
#include "Controls\Button.mqh"
#include "Controls\ButtonsGroup.mqh"
#include "Controls\Calendar.mqh"
#include "Controls\CheckBox.mqh"
#include "Controls\ColorButton.mqh"
#include "Controls\ColorPicker.mqh"
#include "Controls\ComboBox.mqh"
#include "Controls\ContextMenu.mqh"
#include "Controls\DropCalendar.mqh"
#include "Controls\FileNavigator.mqh"
#include "Controls\LineGraph.mqh"
#include "Controls\ListView.mqh"
#include "Controls\MenuBar.mqh"
#include "Controls\MenuItem.mqh"
#include "Controls\Picture.mqh"
#include "Controls\PicturesSlider.mqh"
#include "Controls\ProgressBar.mqh"
#include "Controls\SeparateLine.mqh"
#include "Controls\Slider.mqh"
#include "Controls\SplitButton.mqh"
#include "Controls\StandardChart.mqh"
#include "Controls\StatusBar.mqh"
#include "Controls\Table.mqh"
#include "Controls\Tabs.mqh"
#include "Controls\TextBox.mqh"
#include "Controls\TextEdit.mqh"
#include "Controls\TextLabel.mqh"
#include "Controls\TimeEdit.mqh"
#include "Controls\Tooltip.mqh"
#include "Controls\TreeItem.mqh"
#include "Controls\TreeView.mqh"
#include "Controls\Window.mqh"
//--- Reserve size of the arrays
#define RESERVE_SIZE_ARRAY 1000
//+------------------------------------------------------------------+
//| Class for storing all interface objects                          |
//+------------------------------------------------------------------+
class CWndContainer
  {
private:
   //--- Control counter
   int               m_counter_element_id;
   //---
protected:
   //--- Class instance for getting the mouse parameters
   CMouse            m_mouse;
   //--- Window array
   CWindow          *m_windows[];
   //--- Structure of control arrays
   struct WindowElements
     {
      //--- Common array of all controls
      CElement         *m_elements[];
      //--- Array of the main controls
      CElement         *m_main_elements[];
      //--- Timer controls
      CElement         *m_timer_elements[];
      //--- Controls that are currently visible and available
      CElement         *m_available_elements[];
      //--- Controls with auto-resizing along the X axis
      CElement         *m_auto_x_resize_elements[];
      //--- Controls with auto-resizing along the Y axis
      CElement         *m_auto_y_resize_elements[];
      //--- Private arrays of controls:
      CContextMenu     *m_context_menus[];    // Context menus
      CComboBox        *m_combo_boxes[];      // combo boxes
      CSplitButton     *m_split_buttons[];    // Split buttons
      CMenuBar         *m_menu_bars[];        // Main menus
      CMenuItem        *m_menu_items[];       // Menu items
      CElementBase     *m_drop_lists[];       // Drop-down lists
      CElementBase     *m_scrolls[];          // Scrollbars
      CElementBase     *m_tables[];           // Tables
      CTabs            *m_tabs[];             // Tabs
      CSlider          *m_sliders[];          // Sliders
      CCalendar        *m_calendars[];        // Calendars
      CDropCalendar    *m_drop_calendars[];   // Drop-down calendars
      CStandardChart   *m_sub_charts[];       // Subcharts
      CTimeEdit        *m_time_edits[];       // Time controls
      CTextBox         *m_text_boxes[];       // Multiline text boxes
      CTreeView        *m_treeview_lists[];   // Tree views
      CFileNavigator   *m_file_navigators[];  // File navigators
      CTooltip         *m_tooltips[];         // Tooltips
      CPicturesSlider *m_pictures_slider[];  // Picture sliders
     };
   //--- Array of arrays of controls for each window
   WindowElements    m_wnd[];
   //---
protected:
                     CWndContainer(void);
                    ~CWndContainer(void);
   //---
public:
   //--- Number of windows in the interface
   int               WindowsTotal(void) { return(::ArraySize(m_windows)); }
   //--- The number of all controls
   int               ElementsTotal(const int window_index);
   //--- The number of main controls
   int               MainElementsTotal(const int window_index);
   //--- The number of controls with timers
   int               TimerElementsTotal(const int window_index);
   //--- The number of controls with auto-resizing along the X axis
   int               AutoXResizeElementsTotal(const int window_index);
   //--- The number of controls with auto-resizing along the Y axis
   int               AutoYResizeElementsTotal(const int window_index);
   //--- The number of currently available controls
   int               AvailableElementsTotal(const int window_index);
   //--- The number of controls of the specified type
   int               ElementsTotal(const int window_index,const ENUM_ELEMENT_TYPE type);
   //---
protected:
   //--- Adds window pointer to the base of interface controls
   void              AddWindow(CWindow &object);
   //--- Adds pointer to the controls array
   void              AddToElementsArray(const int window_index,CElementBase &object);
   //--- Adds pointer to the array of controls with timers
   void              AddTimerElement(const int window_index,CElement &object);
   //--- Adds pointer to the array of controls with auto-resizing along the X axis
   void              AddAutoXResizeElement(const int window_index,CElement &object);
   //--- Adds pointer to the array of controls with auto-resizing along the Y axis
   void              AddAutoYResizeElement(const int window_index,CElement &object);
   //--- Adds pointer to the array of currently available controls
   void              AddAvailableElement(const int window_index,CElement &object);
   //---
private:
   //--- Increases the array by one element and returns the last index
   template<typename T>
   int               ResizeArray(T &array[]);
   //--- Template method for adding pointers to the array passed by a link
   template<typename T1,typename T2>
   void              AddToPersonalArray(T1 &object,T2 &array[]);
   //---
private:
   //--- Checking for exceeding the array range
   int               CheckOutOfRange(const int window_index);
   //--- Stores the pointers to window objects
   bool              AddWindowElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the context menu controls
   bool              AddContextMenuElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the main menu controls
   bool              AddMenuBarElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the menu item controls
   bool              AddMenuItemElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the status bar controls
   bool              AddStatusBarElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the split button controls
   bool              AddSplitButtonElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the tab group controls
   bool              AddButtonsGroupElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the list view objects
   bool              AddListViewElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the scrollbar objects in the base
   bool              AddScrollElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the drop-down list view controls (combo box)
   bool              AddComboBoxElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the button controls for calling the color picker
   bool              AddColorButtonElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the table controls
   bool              AddTableElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the tabs in the private array
   bool              AddTabsElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the calendar controls
   bool              AddCalendarElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the drop down calendar controls 
   bool              AddDropCalendarElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the color picker controls
   bool              AddColorPickersElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the subchart controls
   bool              AddSubChartsElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the picture slider controls
   bool              AddPicturesSliderElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the Time controls
   bool              AddTimeEditsElements(const int window_index,CElementBase &object);
   //--- Stores pointers to objects of the multiline text box
   bool              AddTextBoxElements(const int window_index,CElementBase &object);
   //--- Stores pointers to objects of the edit box
   bool              AddTextEditElements(const int window_index,CElementBase &object);
   //--- Stores pointers to objects of the slider
   bool              AddSliderElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the tree view controls
   bool              AddTreeViewListsElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the file navigator controls
   bool              AddFileNavigatorElements(const int window_index,CElementBase &object);
   //--- Stores pointers to the tooltip controls
   bool              AddTooltipElements(const int window_index,CElementBase &object);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWndContainer::CWndContainer(void) : m_counter_element_id(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWndContainer::~CWndContainer(void)
  {
  }
//+------------------------------------------------------------------+
//| The number of controls at the specified window index             |
//+------------------------------------------------------------------+
int CWndContainer::ElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| The number of main controls at the specified window index        |
//+------------------------------------------------------------------+
int CWndContainer::MainElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_main_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| The number of controls with timers at the specified window index |
//+------------------------------------------------------------------+
int CWndContainer::TimerElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_timer_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| The number of currently available controls                       |
//+------------------------------------------------------------------+
int CWndContainer::AvailableElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_available_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| No of controls with auto-resizing (X) at specified window index  |
//+------------------------------------------------------------------+
int CWndContainer::AutoXResizeElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_auto_x_resize_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| No of controls with auto-resizing (Y) at specified window index  |
//+------------------------------------------------------------------+
int CWndContainer::AutoYResizeElementsTotal(const int window_index)
  {
   int index=CheckOutOfRange(window_index);
   return((index!=WRONG_VALUE)? ::ArraySize(m_wnd[index].m_auto_y_resize_elements) : WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| No of controls of specified type at the specified window index   |
//+------------------------------------------------------------------+
int CWndContainer::ElementsTotal(const int window_index,const ENUM_ELEMENT_TYPE type)
  {
//--- Checking for exceeding the array range
   int index=CheckOutOfRange(window_index);
   if(index==WRONG_VALUE)
      return(WRONG_VALUE);
//---
   int elements_total=0;
//---
   switch(type)
     {
      case E_CONTEXT_MENU    : elements_total=::ArraySize(m_wnd[index].m_context_menus);   break;
      case E_COMBO_BOX       : elements_total=::ArraySize(m_wnd[index].m_combo_boxes);     break;
      case E_SPLIT_BUTTON    : elements_total=::ArraySize(m_wnd[index].m_split_buttons);   break;
      case E_MENU_BAR        : elements_total=::ArraySize(m_wnd[index].m_menu_bars);       break;
      case E_MENU_ITEM       : elements_total=::ArraySize(m_wnd[index].m_menu_items);      break;
      case E_DROP_LIST       : elements_total=::ArraySize(m_wnd[index].m_drop_lists);      break;
      case E_SCROLL          : elements_total=::ArraySize(m_wnd[index].m_scrolls);         break;
      case E_TABLE           : elements_total=::ArraySize(m_wnd[index].m_tables);          break;
      case E_TABS            : elements_total=::ArraySize(m_wnd[index].m_tabs);            break;
      case E_SLIDER          : elements_total=::ArraySize(m_wnd[index].m_sliders);         break;
      case E_CALENDAR        : elements_total=::ArraySize(m_wnd[index].m_calendars);       break;
      case E_DROP_CALENDAR   : elements_total=::ArraySize(m_wnd[index].m_drop_calendars);  break;
      case E_SUB_CHART       : elements_total=::ArraySize(m_wnd[index].m_sub_charts);      break;
      case E_PICTURES_SLIDER : elements_total=::ArraySize(m_wnd[index].m_pictures_slider); break;
      case E_TIME_EDIT       : elements_total=::ArraySize(m_wnd[index].m_time_edits);      break;
      case E_TEXT_BOX        : elements_total=::ArraySize(m_wnd[index].m_text_boxes);      break;
      case E_TREE_VIEW       : elements_total=::ArraySize(m_wnd[index].m_treeview_lists);  break;
      case E_FILE_NAVIGATOR  : elements_total=::ArraySize(m_wnd[index].m_file_navigators); break;
      case E_TOOLTIP         : elements_total=::ArraySize(m_wnd[index].m_tooltips);        break;
     }
//--- Return the number of controls of the specified type
   return(elements_total);
  }
//+------------------------------------------------------------------+
//| Adds the window pointer to the base of the interface controls    |
//+------------------------------------------------------------------+
void CWndContainer::AddWindow(CWindow &object)
  {
   int windows_total=::ArraySize(m_windows);
//--- If there are no windows yet, reset the counter of controls
   if(windows_total<1)
     {
      m_counter_element_id=0;
      ::Comment("Loading. Please wait...");
     }
//--- Add pointer to the window array
   int new_size=windows_total+1;
   ::ArrayResize(m_wnd,new_size);
   ::ArrayResize(m_windows,new_size);
   m_windows[windows_total]=::GetPointer(object);
//--- Add pointer to the common array of controls
   int last_index=ResizeArray(m_wnd[windows_total].m_elements);
   m_wnd[windows_total].m_elements[last_index]=::GetPointer(object);
//--- Add window button pointers to the base
   AddWindowElements(windows_total,object);
//--- Set identifier and store the id of the last control
   m_windows[windows_total].Id(m_counter_element_id);
   m_windows[windows_total].LastId(m_counter_element_id);
//--- Increase the counter of control identifiers
   m_counter_element_id++;
  }
//+------------------------------------------------------------------+
//| Adds pointer to the controls array                               |
//+------------------------------------------------------------------+
void CWndContainer::AddToElementsArray(const int window_index,CElementBase &object)
  {
   int windows_total=::ArraySize(m_windows);
//--- If the base does not contain any forms for controls
   if(windows_total<1)
     {
      ::Print(__FUNCTION__," > Before creating a control, create a form "
              "and add it to the base using the CWndContainer::AddWindow(CWindow &object) method.");
      return;
     }
//--- If the request is for a non-existent form
   if(window_index>=windows_total)
     {
      ::Print(PREVENTING_OUT_OF_RANGE," window_index: ",window_index,"; windows total: ",windows_total);
      return;
     }
//--- Add to the common array of controls
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=::GetPointer(object);
//--- Add to the array of the main controls
   last_index=ResizeArray(m_wnd[window_index].m_main_elements);
   m_wnd[window_index].m_main_elements[last_index]=::GetPointer(object);
//--- Store the id of the last control in all forms
   for(int w=0; w<windows_total; w++)
      m_windows[w].LastId(m_counter_element_id);
//--- Increase the counter of control identifiers
   m_counter_element_id++;
//--- Stores pointers to the context menu objects
   if(AddContextMenuElements(window_index,object))
      return;
//--- Stores pointers to the main menu objects
   if(AddMenuBarElements(window_index,object))
      return;
//--- Stores pointer to the menu item
   if(AddMenuItemElements(window_index,object))
      return;
//--- Stores pointers to the item objects
   if(AddStatusBarElements(window_index,object))
      return;
//--- Stores pointers to the split button objects 
   if(AddSplitButtonElements(window_index,object))
      return;
//--- Stores pointers to the button group objects
   if(AddButtonsGroupElements(window_index,object))
      return;
//--- Stores pointers to the list view objects in the base
   if(AddListViewElements(window_index,object))
      return;
//--- Stores pointers to the combo box control objects 
   if(AddComboBoxElements(window_index,object))
      return;
//--- Stores pointers to the objects of the button control for calling the color picker
   if(AddColorButtonElements(window_index,object))
      return;
//--- Stores pointers to the table controls
   if(AddTableElements(window_index,object))
      return;
//--- Stores pointers to the tab controls
   if(AddTabsElements(window_index,object))
      return;
//--- Stores pointers to the calendar controls
   if(AddCalendarElements(window_index,object))
      return;
//--- Stores pointers to the drop down calendar controls 
   if(AddDropCalendarElements(window_index,object))
      return;
//--- Stores pointers to the color picker controls
   if(AddColorPickersElements(window_index,object))
      return;
//--- Stores pointers to the subchart controls
   if(AddSubChartsElements(window_index,object))
      return;
//--- Stores pointers to the picture slider controls
   if(AddPicturesSliderElements(window_index,object))
      return;
//--- Stores pointers to the Time controls
   if(AddTimeEditsElements(window_index,object))
      return;
//--- Stores pointers to controls of the multiline text box
   if(AddTextBoxElements(window_index,object))
      return;
//--- Stores pointers to controls of the text edit box
   if(AddTextEditElements(window_index,object))
      return;
//--- Stores pointers to the slider controls
   if(AddSliderElements(window_index,object))
      return;
//--- Stores pointers to the tree view controls
   if(AddTreeViewListsElements(window_index,object))
      return;
//--- Stores pointers to the file navigator controls
   if(AddFileNavigatorElements(window_index,object))
      return;
//--- Stores pointers to the tooltip objects 
   if(AddTooltipElements(window_index,object))
      return;
  }
//+------------------------------------------------------------------+
//| Adds pointer to the array of controls with timers                |
//+------------------------------------------------------------------+
void CWndContainer::AddTimerElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_timer_elements);
   m_wnd[window_index].m_timer_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Adds pointer to the array of controls with auto-resizing (X)     |
//+------------------------------------------------------------------+
void CWndContainer::AddAutoXResizeElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_auto_x_resize_elements);
   m_wnd[window_index].m_auto_x_resize_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Adds pointer to the array of controls with auto-resizing (Y)     |
//+------------------------------------------------------------------+
void CWndContainer::AddAutoYResizeElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_auto_y_resize_elements);
   m_wnd[window_index].m_auto_y_resize_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Adds pointer to the array of available controls                  |
//+------------------------------------------------------------------+
void CWndContainer::AddAvailableElement(const int window_index,CElement &object)
  {
   int last_index=ResizeArray(m_wnd[window_index].m_available_elements);
   m_wnd[window_index].m_available_elements[last_index]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Adjustment of window index in case the range has been exceeded   |
//+------------------------------------------------------------------+
int CWndContainer::CheckOutOfRange(const int window_index)
  {
   int array_size=::ArraySize(m_wnd);
   if(array_size<1)
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//--- Adjustment in case the range has been exceeded
   int index=(window_index>=array_size)? array_size-1 : window_index;
//--- Return the window index
   return(index);
  }
//+------------------------------------------------------------------+
//| Stores the pointers to window objects                            |
//+------------------------------------------------------------------+
bool CWndContainer::AddWindowElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a text edit box
   if(dynamic_cast<CWindow *>(&object)==NULL)
      return(false);
//--- Get the pointer to the control
   CWindow *wnd=::GetPointer(object);
//--- Store the mouse cursor pointer
   object.MousePointer(m_mouse);
//---
   for(int i=0; i<4; i++)
     {
      CButton *ib=NULL;
      //---
      if(i==0)
         ib=wnd.GetCloseButtonPointer();
      else if(i==1)
         ib=wnd.GetFullscreenButtonPointer();
      else if(i==2)
         ib=wnd.GetCollapseButtonPointer();
      else if(i==3)
         ib=wnd.GetTooltipButtonPointer();
      //--- Increasing the controls array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Add the close button to the base
      m_wnd[window_index].m_elements[last_index]=ib;
      //--- Store the mouse cursor pointer
      ib.MousePointer(m_mouse);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the context menu objects                      |
//+------------------------------------------------------------------+
bool CWndContainer::AddContextMenuElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a context menu
   if(dynamic_cast<CContextMenu *>(&object)==NULL)
      return(false);
//--- Get the context menu pointer
   CContextMenu *cm=::GetPointer(object);
//--- Store the pointers to its objects in the base
   int items_total=cm.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Store the pointer in the array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=cm.GetItemPointer(i);
     }
//--- Store the pointers to separation lines
   int lines_total=cm.SeparateLinesTotal();
   for(int i=0; i<lines_total; i++)
     {
      //--- Store the pointer in the array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=cm.GetSeparateLinePointer(i);
     }
//--- Add the pointer to the private array
   AddToPersonalArray(cm,m_wnd[window_index].m_context_menus);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the main menu objects                         |
//+------------------------------------------------------------------+
bool CWndContainer::AddMenuBarElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not the main menu
   if(dynamic_cast<CMenuBar *>(&object)==NULL)
      return(false);
//--- Get the main menu pointer
   CMenuBar *mb=::GetPointer(object);
//--- Store the pointers to its objects in the base
   int items_total=mb.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Store the pointer in the array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=mb.GetItemPointer(i);
     }
//--- Add the pointer to the private array
   AddToPersonalArray(mb,m_wnd[window_index].m_menu_bars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the menu items                                |
//+------------------------------------------------------------------+
bool CWndContainer::AddMenuItemElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a menu item
   if(dynamic_cast<CMenuItem *>(&object)==NULL)
      return(false);
//--- Get the pointer to the menu item
   CMenuItem *mi=::GetPointer(object);
//--- Add the pointer to the private array
   AddToPersonalArray(mi,m_wnd[window_index].m_menu_items);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the split button objects                      |
//+------------------------------------------------------------------+
bool CWndContainer::AddSplitButtonElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a split button
   if(dynamic_cast<CSplitButton *>(&object)==NULL)
      return(false);
//--- Get the split button pointer
   CSplitButton *sb=::GetPointer(object);
//--- 
   for(int i=0; i<3; i++)
     {
      //--- Increasing the controls array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Store the pointer in the array
      if(i==0)
        {
         m_wnd[window_index].m_elements[last_index]=sb.GetButtonPointer();
        }
      else if(i==1)
        {
         m_wnd[window_index].m_elements[last_index]=sb.GetDropButtonPointer();
        }
      else if(i==2)
        {
         CContextMenu *cm=sb.GetContextMenuPointer();
         m_wnd[window_index].m_elements[last_index]=cm;
         //--- Add controls of the context menu
         AddContextMenuElements(window_index,cm);
        }
     }
//--- Add the pointer to the private array
   AddToPersonalArray(sb,m_wnd[window_index].m_split_buttons);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the status bar controls                       |
//+------------------------------------------------------------------+
bool CWndContainer::AddStatusBarElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not an item
   if(dynamic_cast<CStatusBar *>(&object)==NULL)
      return(false);
//--- Get the pointer to the item
   CStatusBar *sb=::GetPointer(object);
//--- Add the items to the base
   int items_total=sb.ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Store the pointer in the array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=sb.GetItemPointer(i);
     }
//--- Store the pointers to separation lines
   int lines_total=sb.SeparateLinesTotal();
   for(int i=0; i<lines_total; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=sb.GetSeparateLinePointer(i);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the button group objects                      |
//+------------------------------------------------------------------+
bool CWndContainer::AddButtonsGroupElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a list view
   if(dynamic_cast<CButtonsGroup *>(&object)==NULL)
      return(false);
//--- Get the list view pointer
   CButtonsGroup *bg=::GetPointer(object);
//--- Add the buttons to the base
   int buttons_total=bg.ButtonsTotal();
   for(int i=0; i<buttons_total; i++)
     {
      //--- Store the pointer in the array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=bg.GetButtonPointer(i);
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the list view objects                         |
//+------------------------------------------------------------------+
bool CWndContainer::AddListViewElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a list view
   if(dynamic_cast<CListView *>(&object)==NULL)
      return(false);
//--- Get the list view pointer
   CListView *lv=::GetPointer(object);
//--- Store pointers to the scrollbar objects
   CScrollV *sv=lv.GetScrollVPointer();
   AddScrollElements(window_index,sv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the scrollbar objects                         |
//+------------------------------------------------------------------+
bool CWndContainer::AddScrollElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a list view
   if(dynamic_cast<CScroll *>(&object)==NULL)
      return(false);
//--- Get the pointer to the scrollbar
   CScroll *sc=::GetPointer(object);
//--- Store the pointer in the array
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=sc;
//---
   for(int i=0; i<2; i++)
     {
      //--- Get the pointer to the scrollbar button
      CButton *ib=(i<1)? sc.GetIncButtonPointer() : sc.GetDecButtonPointer();
      //--- Store the pointer in the array
      last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=ib;
     }
//--- Add the pointer to the private array
   AddToPersonalArray(sc,m_wnd[window_index].m_scrolls);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer to the drop-down list view in a private array |
//+------------------------------------------------------------------+
bool CWndContainer::AddComboBoxElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a combo box
   if(dynamic_cast<CComboBox *>(&object)==NULL)
      return(false);
//--- Get the combo box pointer
   CComboBox *cb=::GetPointer(object);
//---
   for(int i=0; i<2; i++)
     {
      //--- Increasing the controls array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Add the button to the base
      if(i==0)
        {
         m_wnd[window_index].m_elements[last_index]=cb.GetButtonPointer();
        }
      //--- Add the list to the base
      else if(i==1)
        {
         CListView *lv=cb.GetListViewPointer();
         m_wnd[window_index].m_elements[last_index]=lv;
         //--- Store the pointers to the list view objects
         AddListViewElements(window_index,lv);
         //--- Add the pointer to the private array
         AddToPersonalArray(lv,m_wnd[window_index].m_drop_lists);
        }
     }
//--- Add the pointer to the private array
   AddToPersonalArray(cb,m_wnd[window_index].m_combo_boxes);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the color button controls                     |
//+------------------------------------------------------------------+
bool CWndContainer::AddColorButtonElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a combo box
   if(dynamic_cast<CColorButton *>(&object)==NULL)
      return(false);
//--- Get the button pointer
   CColorButton *cb=::GetPointer(object);
//--- Store the pointer in the array
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=cb.GetButtonPointer();
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the table controls                            |
//+------------------------------------------------------------------+
bool CWndContainer::AddTableElements(const int window_index,CElementBase &object)
  {
//--- Leave, if it is not a rendered table
   if(dynamic_cast<CTable *>(&object)==NULL)
      return(false);
//--- Get the pointer to the rendered table
   CTable *tbl=::GetPointer(object);
//---
   for(int i=0; i<2; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Store the pointer in the array
         CScrollV *sv=tbl.GetScrollVPointer();
         m_wnd[window_index].m_elements[last_index]=sv;
         //--- Store pointers to the scrollbar objects
         AddScrollElements(window_index,sv);
         //--- Add the pointer to the private array
         AddToPersonalArray(sv,m_wnd[window_index].m_scrolls);
        }
      else if(i==1)
        {
         //--- Store the pointer in the array
         CScrollH *sh=tbl.GetScrollHPointer();
         m_wnd[window_index].m_elements[last_index]=sh;
         //--- Store pointers to the scrollbar objects
         AddScrollElements(window_index,sh);
         //--- Add the pointer to the private array
         AddToPersonalArray(sh,m_wnd[window_index].m_scrolls);
        }
     }
//--- If there is an edit box
   if(tbl.HasEditElements())
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Store the pointer in the array
      CTextEdit *te=tbl.GetTextEditPointer();
      m_wnd[window_index].m_elements[last_index]=te;
      //--- Store the object pointers
      AddTextEditElements(window_index,te);
     }
//--- If there is a combo box
   if(tbl.HasComboboxElements())
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Store the pointer in the array
      CComboBox *cb=tbl.GetComboboxPointer();
      m_wnd[window_index].m_elements[last_index]=cb;
      //--- Store the object pointers
      AddComboBoxElements(window_index,cb);
     }
//--- Add the pointer to the private array
   AddToPersonalArray(tbl,m_wnd[window_index].m_tables);
   return(true);
  }
//+------------------------------------------------------------------+
//| Store pointers to the tabs in the private array                  |
//+------------------------------------------------------------------+
bool CWndContainer::AddTabsElements(const int window_index,CElementBase &object)
  {
//--- Leave, if these are not tabs
   if(dynamic_cast<CTabs *>(&object)==NULL)
      return(false);
//--- Get the pointer to the Tabs control
   CTabs *tabs=::GetPointer(object);
//--- Store the pointer in the array
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   CButtonsGroup *bg=tabs.GetButtonsGroupPointer();
   m_wnd[window_index].m_elements[last_index]=bg;
//--- Store the pointers to group buttons
   AddButtonsGroupElements(window_index,bg);
//--- Add the pointer to the private array
   AddToPersonalArray(tabs,m_wnd[window_index].m_tabs);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointers to the calendar objects                      |
//+------------------------------------------------------------------+
bool CWndContainer::AddCalendarElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a calendar
   if(dynamic_cast<CCalendar *>(&object)==NULL)
      return(false);
//--- Get the pointer to the Calendar control
   CCalendar *cal=::GetPointer(object);
//---
   for(int i=0; i<6; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      switch(i)
        {
         case 0 :
           {
            m_wnd[window_index].m_elements[last_index]=cal.GetMonthDecPointer();
            break;
           }
         case 1 :
           {
            m_wnd[window_index].m_elements[last_index]=cal.GetMonthIncPointer();
            break;
           }
         case 2 :
           {
            CComboBox *cb=cal.GetComboBoxPointer();
            m_wnd[window_index].m_elements[last_index]=cb;
            //--- Add the combo box controls
            AddComboBoxElements(window_index,cb);
            break;
           }
         case 3 :
           {
            CTextEdit *te=cal.GetSpinEditPointer();
            m_wnd[window_index].m_elements[last_index]=te;
            //--- Add the edit box controls
            AddTextEditElements(window_index,te);
            break;
           }
         case 4 :
           {
            CButtonsGroup *bg=cal.GetDayButtonsPointer();
            m_wnd[window_index].m_elements[last_index]=bg;
            //--- Store the pointers to group buttons
            AddButtonsGroupElements(window_index,bg);
            break;
           }
         case 5 :
           {
            m_wnd[window_index].m_elements[last_index]=cal.GetTodayButtonPointer();
            break;
           }
        }
     }
//--- Add the pointer to the private array
   AddToPersonalArray(cal,m_wnd[window_index].m_calendars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to drop down calendar objects                    |
//+------------------------------------------------------------------+
bool CWndContainer::AddDropCalendarElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a drop-down calendar
   if(dynamic_cast<CDropCalendar *>(&object)==NULL)
      return(false);
//--- Get the pointer to the Drop Down Calendar control
   CDropCalendar *dc=::GetPointer(object);
//---
   for(int i=0; i<3; i++)
     {
      //--- Increasing the controls array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Store the pointer in the array
         CTextEdit *te=dc.GetTextEditPointer();
         m_wnd[window_index].m_elements[last_index]=te;
         //--- Add the calendar controls
         AddTextEditElements(window_index,te);
        }
      else if(i==1)
        {
         m_wnd[window_index].m_elements[last_index]=dc.GetDropButtonPointer();
        }
      else if(i==2)
        {
         //--- Store the pointer in the array
         CCalendar *cal=dc.GetCalendarPointer();
         m_wnd[window_index].m_elements[last_index]=cal;
         //--- Add the calendar controls
         AddCalendarElements(window_index,cal);
        }
     }
//--- Add the pointer to the private array
   AddToPersonalArray(dc,m_wnd[window_index].m_drop_calendars);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the color picker controls                     |
//+------------------------------------------------------------------+
bool CWndContainer::AddColorPickersElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a Leave, if this is not a tree view
   if(dynamic_cast<CColorPicker *>(&object)==NULL)
      return(false);
//--- Get the pointer to the control
   CColorPicker *cp=::GetPointer(object);
//---
   for(int i=0; i<12; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i<1)
        {
         //--- Store the pointer in the array
         CButtonsGroup *bg=cp.GetRadioButtonsPointer();
         m_wnd[window_index].m_elements[last_index]=bg;
         //--- Add the group buttons
         AddButtonsGroupElements(window_index,bg);
        }
      else if(i>0 && i<10)
        {
         //--- Store the pointer in the array
         CTextEdit *se=cp.GetSpinEditPointer(i-1);
         m_wnd[window_index].m_elements[last_index]=se;
         //--- Add the edit box controls
         AddTextEditElements(window_index,se);
        }
      else if(i>9)
        {
         CButton *ib=cp.GetButtonPointer(i-10);
         m_wnd[window_index].m_elements[last_index]=ib;
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer to the subcharts in a private array           |
//+------------------------------------------------------------------+
bool CWndContainer::AddSubChartsElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a standard chart
   if(dynamic_cast<CStandardChart *>(&object)==NULL)
      return(false);
//--- Get the pointer to the standard chart
   CStandardChart *sc=::GetPointer(object);
//--- Add the pointer to the private array
   AddToPersonalArray(sc,m_wnd[window_index].m_sub_charts);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer to the picture sliders in a private array     |
//+------------------------------------------------------------------+
bool CWndContainer::AddPicturesSliderElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a picture slider
   if(dynamic_cast<CPicturesSlider *>(&object)==NULL)
      return(false);
//--- Get the pointer to the picture slider
   CPicturesSlider *ps=::GetPointer(object);
//--- Add the buttons to the base
   int picturs_total=ps.PicturesTotal();
   for(int i=0; i<picturs_total; i++)
     {
      //--- Store the pointer in the array
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      m_wnd[window_index].m_elements[last_index]=ps.GetPicturePointer(i);
     }
//---
   for(int i=0; i<3; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Store the pointer in the array
         CButtonsGroup *bg=ps.GetRadioButtonsPointer();
         m_wnd[window_index].m_elements[last_index]=bg;
         //--- Add the group buttons
         AddButtonsGroupElements(window_index,bg);
        }
      else
        {
         //--- Store the pointer in the array
         CButton *ib=(i<2)? ps.GetLeftArrowPointer() : ps.GetRightArrowPointer();
         m_wnd[window_index].m_elements[last_index]=ib;
        }
     }
//--- Add the pointer to the private array
   AddToPersonalArray(ps,m_wnd[window_index].m_pictures_slider);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the pointer to the Time controls in a private array       |
//+------------------------------------------------------------------+
bool CWndContainer::AddTimeEditsElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a Time control
   if(dynamic_cast<CTimeEdit *>(&object)==NULL)
      return(false);
//--- Get the pointer to the Time control
   CTimeEdit *te=::GetPointer(object);
   for(int i=0; i<2; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Store the pointer in the array
         CTextEdit *se=te.GetMinutesEditPointer();
         m_wnd[window_index].m_elements[last_index]=se;
         //--- Store pointers to objects of the edit box
         AddTextEditElements(window_index,se);
        }
      else
        {
         //--- Store the pointer in the array
         CTextEdit *se=te.GetHoursEditPointer();
         m_wnd[window_index].m_elements[last_index]=se;
         //--- Store pointers to objects of the edit box
         AddTextEditElements(window_index,se);
        }
     }
//--- Add the pointer to the private array
   AddToPersonalArray(te,m_wnd[window_index].m_time_edits);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to objects of the multiline text box             |
//+------------------------------------------------------------------+
bool CWndContainer::AddTextBoxElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a multiline text box
   if(dynamic_cast<CTextBox *>(&object)==NULL)
      return(false);
//--- Get the pointer to the control
   CTextBox *tb=::GetPointer(object);
//--- Add the pointer to the private array
   AddToPersonalArray(tb,m_wnd[window_index].m_text_boxes);
//---
   if(!tb.MultiLineMode())
      return(true);
//---
   for(int i=0; i<2; i++)
     {
      int last_index=ResizeArray(m_wnd[window_index].m_elements);
      //---
      if(i==0)
        {
         //--- Get the scrollbar pointer
         CScrollV *sv=tb.GetScrollVPointer();
         m_wnd[window_index].m_elements[last_index]=sv;
         //--- Store pointers to the scrollbar objects
         AddScrollElements(window_index,sv);
         //--- Add the pointer to the private array
         AddToPersonalArray(sv,m_wnd[window_index].m_scrolls);
        }
      else if(i==1)
        {
         CScrollH *sh=tb.GetScrollHPointer();
         m_wnd[window_index].m_elements[last_index]=sh;
         //--- Store pointers to the scrollbar objects
         AddScrollElements(window_index,sh);
         //--- Add the pointer to the private array
         AddToPersonalArray(sh,m_wnd[window_index].m_scrolls);
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to objects of the edit box                       |
//+------------------------------------------------------------------+
bool CWndContainer::AddTextEditElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a text edit box
   if(dynamic_cast<CTextEdit *>(&object)==NULL)
      return(false);
//--- Get the pointer to the control
   CTextEdit *te=::GetPointer(object);
//--- Increasing the controls array
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
//--- Get the pointer to the edit box
   CTextBox *tb=te.GetTextBoxPointer();
   m_wnd[window_index].m_elements[last_index]=tb;
//--- Add the pointer to the private array
   AddToPersonalArray(tb,m_wnd[window_index].m_text_boxes);
//--- Leave, if the buttons are disabled
   if(!te.SpinEditMode())
      return(true);
//---
   for(int i=0; i<2; i++)
     {
      //--- Increasing the controls array
      last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Add the button to the base
      if(i==0)
         m_wnd[window_index].m_elements[last_index]=te.GetIncButtonPointer();
      else if(i==1)
         m_wnd[window_index].m_elements[last_index]=te.GetDecButtonPointer();
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the slider controls                           |
//+------------------------------------------------------------------+
bool CWndContainer::AddSliderElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a slider
   if(dynamic_cast<CSlider *>(&object)==NULL)
      return(false);
//--- Get the pointer to the control
   CSlider *ns=::GetPointer(object);
//--- Increasing the controls array
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
//--- Get the pointer to the edit box
   CTextEdit *te=ns.GetRightEditPointer();
   m_wnd[window_index].m_elements[last_index]=te;
//--- Stores pointers to controls of the edit box
   AddTextEditElements(window_index,te);
//---
   if(ns.DualSliderMode())
     {
      //--- Increasing the controls array
      last_index=ResizeArray(m_wnd[window_index].m_elements);
      //--- Get the pointer to the edit box
      te=ns.GetLeftEditPointer();
      m_wnd[window_index].m_elements[last_index]=te;
      //--- Stores pointers to controls of the edit box
      AddTextEditElements(window_index,te);
     }
//--- Add the pointer to the private array
   AddToPersonalArray(ns,m_wnd[window_index].m_sliders);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores the tooltip pointer in the private array                  |
//+------------------------------------------------------------------+
bool CWndContainer::AddTooltipElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a tooltip
   if(dynamic_cast<CTooltip *>(&object)==NULL)
      return(false);
//--- Get the tooltip pointer
   CTooltip *t=::GetPointer(object);
//--- Add the pointer to the private array
   AddToPersonalArray(t,m_wnd[window_index].m_tooltips);
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the tree view controls                        |
//+------------------------------------------------------------------+
bool CWndContainer::AddTreeViewListsElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a tree view
   if(dynamic_cast<CTreeView *>(&object)==NULL)
      return(false);
//--- Get the pointer to the Tree View control
   CTreeView *tv=::GetPointer(object);
//--- Add the pointer to the private array
   AddToPersonalArray(tv,m_wnd[window_index].m_treeview_lists);
//--- The last index
   int last_index=0;
//---
   for(int i=0; i<4; i++)
     {
      if(i==3 && !tv.ShowItemContent())
         break;
      //---
      if(i>1)
        {
         last_index=ResizeArray(m_wnd[window_index].m_elements);
        }
      //---
      switch(i)
        {
         case 0 :
           {
            for(int j=0; j<tv.ItemsTotal(); j++)
              {
               last_index=ResizeArray(m_wnd[window_index].m_elements);
               m_wnd[window_index].m_elements[last_index]=tv.ItemPointer(j);
              }
            break;
           }
         case 1 :
           {
            for(int j=0; j<tv.ContentItemsTotal(); j++)
              {
               last_index=ResizeArray(m_wnd[window_index].m_elements);
               m_wnd[window_index].m_elements[last_index]=tv.ContentItemPointer(j);
              }
            break;
           }
         case 2 :
           {
            //--- Add the pointer to the private array
            CScrollV *sv=tv.GetScrollVPointer();
            m_wnd[window_index].m_elements[last_index]=sv;
            AddToPersonalArray(sv,m_wnd[window_index].m_scrolls);
            //--- Store pointers to the scrollbar objects
            AddScrollElements(window_index,sv);
            break;
           }
         case 3 :
           {
            //--- Add the pointer to the private array
            CScrollV *csv=tv.GetContentScrollVPointer();
            m_wnd[window_index].m_elements[last_index]=csv;
            AddToPersonalArray(csv,m_wnd[window_index].m_scrolls);
            //--- Store pointers to the scrollbar objects
            AddScrollElements(window_index,csv);
            break;
           }
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Stores pointers to the file navigator controls                   |
//+------------------------------------------------------------------+
bool CWndContainer::AddFileNavigatorElements(const int window_index,CElementBase &object)
  {
//--- Leave, if this is not a file navigator
   if(dynamic_cast<CFileNavigator *>(&object)==NULL)
      return(false);
//--- Get the pointer to the File Navigator control
   CFileNavigator *fn=::GetPointer(object);
//--- Add the pointer to the private array
   AddToPersonalArray(fn,m_wnd[window_index].m_file_navigators);
//--- Store pointer to the tree view
   int last_index=ResizeArray(m_wnd[window_index].m_elements);
   m_wnd[window_index].m_elements[last_index]=fn.GetTreeViewPointer();
//--- Add tree view controls
   AddTreeViewListsElements(window_index,fn.GetTreeViewPointer());
   return(true);
  }
//+------------------------------------------------------------------+
//| Increases the array by one element and returns the last index    |
//+------------------------------------------------------------------+
template<typename T>
int CWndContainer::ResizeArray(T &array[])
  {
   int size=::ArraySize(array);
   ::ArrayResize(array,size+1,RESERVE_SIZE_ARRAY);
   return(size);
  }
//+------------------------------------------------------------------+
//| Stores the pointer (T1) in the array passed by the link (T2)     |
//+------------------------------------------------------------------+
template<typename T1,typename T2>
void CWndContainer::AddToPersonalArray(T1 &object,T2 &array[])
  {
   int last_index=ResizeArray(array);
   array[last_index]=object;
  }
//+------------------------------------------------------------------+
