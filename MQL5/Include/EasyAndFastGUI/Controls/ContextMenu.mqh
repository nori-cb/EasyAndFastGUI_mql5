//+------------------------------------------------------------------+
//|                                                  ContextMenu.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "MenuItem.mqh"
#include "SeparateLine.mqh"
//+------------------------------------------------------------------+
//| Class for creating a context menu                                |
//+------------------------------------------------------------------+
class CContextMenu : public CElement
  {
private:
   //--- Objects for creating a menu item
   CMenuItem         m_items[];
   CSeparateLine     m_sep_line[];
   //--- Pointer to the previous node
   CMenuItem        *m_prev_node;
   //--- Properties of menu items
   int               m_item_y_size;
   //--- Separation line properties
   color             m_sepline_dark_color;
   color             m_sepline_light_color;
   //--- Arrays of the menu item properties:
   //    (1) Text, (2) label of the available item, (3) label of the locked item
   string            m_text[];
   string            m_path_bmp_on[];
   string            m_path_bmp_off[];
   //--- Array of index numbers of menu items after which a separation line is to be set
   int               m_sep_line_index[];
   //--- Attachment side of the context menu
   ENUM_FIX_CONTEXT_MENU m_fix_side;
   //--- The detached context menu mode. This means that there is no attachment to the previous node.
   bool              m_free_context_menu;
   //---
public:
                     CContextMenu(void);
                    ~CContextMenu(void);
   //--- Methods for creating a context menu
   bool              CreateContextMenu(const int x_gap=0,const int y_gap=0);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   bool              CreateSeparateLine(const int item_index,const int line_index);
   //---
public:
   //--- Returns the item pointer from the context menu
   CMenuItem        *GetItemPointer(const uint index);
   CSeparateLine    *GetSeparateLinePointer(const uint index);
   //--- (1) Store and (2) get the pointer of the previous node, (3) set the free context menu mode
   void              PrevNodePointer(CMenuItem &object);
   CMenuItem        *PrevNodePointer(void)                    const { return(m_prev_node);              }
   void              FreeContextMenu(const bool flag)               { m_free_context_menu=flag;         }
   //--- (1) Number of menu items, (2) height
   int               ItemsTotal(void)                         const { return(::ArraySize(m_items));     }
   int               SeparateLinesTotal(void)                 const { return(::ArraySize(m_sep_line));  }
   void              ItemYSize(const int y_size)                    { m_item_y_size=y_size;             }
   //--- (1) Dark and (2) light color of the separation line
   void              SeparateLineDarkColor(const color clr)         { m_sepline_dark_color=clr;         }
   void              SeparateLineLightColor(const color clr)        { m_sepline_light_color=clr;        }
   //--- Setting the context menu attachment mode
   void              FixSide(const ENUM_FIX_CONTEXT_MENU side) { m_fix_side=side; }

   //--- Adds a menu item with specified properties before the creation of the context menu
   void              AddItem(const string text,const string path_bmp_on,const string path_bmp_off,const ENUM_TYPE_MENU_ITEM type);
   //--- Adds a separation line after the specified item before the creation of the context menu
   void              AddSeparateLine(const int item_index);
   //--- Returns description (displayed text)
   string            DescriptionByIndex(const uint index);
   //--- Returns a menu item type
   ENUM_TYPE_MENU_ITEM TypeMenuItemByIndex(const uint index);
   //--- (1) Getting and (2) setting the checkbox state
   bool              CheckBoxStateByIndex(const uint index);
   void              CheckBoxStateByIndex(const uint index,const bool state);
   //--- (1) Returns and (2) sets the id of the radio item by the index
   int               RadioItemIdByIndex(const uint index);
   void              RadioItemIdByIndex(const uint item_index,const int radio_id);
   //--- (1) Returns selected radio item, (2) switches the radio item
   int               SelectedRadioItem(const int radio_id);
   void              SelectedRadioItem(const int radio_index,const int radio_id);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Management
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Condition check for closing all context menus
   void              CheckHideContextMenus(void);
   //--- Condition check for closing all context menus which were open after this one
   void              CheckHideBackContextMenus(void);
   //--- Handling clicking on the item to which this context menu is attached
   bool              OnClickMenuItem(const string pressed_object,const int id,const int index);

   //--- Receiving a message from the menu item for handling
   void              ReceiveMessageFromMenuItem(const int id,const int index_item,const string message_item);
   //--- Getting (1) an identifier and (2) index from the radio item message
   int               RadioIdFromMessage(const string message);
   int               RadioIndexByItemIndex(const int index);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CContextMenu::CContextMenu(void) : m_free_context_menu(false),
                                   m_fix_side(FIX_RIGHT),
                                   m_item_y_size(24),
                                   m_sepline_dark_color(C'160,160,160'),
                                   m_sepline_light_color(clrWhite)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Context menu is a drop-down control
   CElementBase::IsDropdown(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CContextMenu::~CContextMenu(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CContextMenu::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse cursor movement
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if this is a detached context menu
      if(m_free_context_menu)
         return;
      //--- If the context menu is enabled and the left mouse button is pressed
      if(m_mouse.LeftButtonState())
        {
         //--- Check conditions for closing all context menus
         CheckHideContextMenus();
         return;
        }
      //--- Check conditions for closing all context menus which were open after that
      CheckHideBackContextMenus();
      return;
     }
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickMenuItem(sparam,(int)lparam,(int)dparam))
         return;
     }
//--- Handling the event of pressing a menu item
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_MENU_ITEM)
     {
      //--- Leave, if this is a detached context menu
      if(m_free_context_menu)
         return;
      //---
      int    item_id      =int(lparam);
      int    item_index   =int(dparam);
      string item_message =sparam;
      //--- Receiving a message from the menu item for handling
      ReceiveMessageFromMenuItem(item_id,item_index,item_message);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates a context menu                                           |
//+------------------------------------------------------------------+
bool CContextMenu::CreateContextMenu(const int x_gap=0,const int y_gap=0)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- If this is an attached context menu
   if(!m_free_context_menu)
     {
      //--- Leave, if there is no pointer to the previous node 
      if(::CheckPointer(m_prev_node)==POINTER_INVALID)
        {
         ::Print(__FUNCTION__," > Before creating a context menu it must be passed "
                 "a pointer to the previous node using the CContextMenu::PrevNodePointer(CMenuItem &object) method.");
         return(false);
        }
     }
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Creating a context menu
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CContextMenu::InitializeProperties(const int x_gap,const int y_gap)
  {
//--- Calculation of the context menu height depends on the number of menu items and separation lines
   int items_total =ItemsTotal();
   int sep_y_size  =::ArraySize(m_sep_line)*9;
   m_y_size        =(m_item_y_size*items_total+2)+sep_y_size;
//--- If coordinates have not been specified
   if(!m_free_context_menu && (x_gap==0 || y_gap==0))
     {
      if(m_fix_side==FIX_RIGHT)
        {
         m_x =(m_anchor_right_window_side)? m_prev_node.X()-m_prev_node.XSize()+3 : m_prev_node.X2()-3;
         m_y =(m_anchor_bottom_window_side)? m_prev_node.Y()+1 : m_prev_node.Y()-1;
        }
      else
        {
         m_x =(m_anchor_right_window_side)? m_prev_node.X()-1 : m_prev_node.X()+1;
         m_y =(m_anchor_bottom_window_side)? m_prev_node.Y()-m_prev_node.YSize()+1 : m_prev_node.Y2()-1;
        }
     }
//--- If coordinates are specified
   else
     {
      m_x =CElement::CalculateX(x_gap);
      m_y =CElement::CalculateY(y_gap);
     }
//--- Default background color
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : C'240,240,240';
   m_back_color_hover   =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'51,153,255';
   m_back_color_locked  =(m_back_color_locked!=clrNONE)? m_back_color_locked : clrLightGray;
   m_back_color_pressed =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : C'51,153,255';
   m_border_color       =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
//--- Margins and color of the text label
   m_icon_x_gap         =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 3;
   m_icon_y_gap         =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 3;
   m_label_x_gap        =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 24;
   m_label_y_gap        =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 5;
   m_label_color        =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover  =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrWhite;
//--- Offsets from the extreme point
   CElementBase::XGap(CElement::CalculateXGap(m_x));
   CElementBase::YGap(CElement::CalculateYGap(m_y));
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CContextMenu::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("context_menu");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a list of menu items                                     |
//+------------------------------------------------------------------+
bool CContextMenu::CreateItems(void)
  {
//--- For identification of the location of separation lines
   int s=0;
//--- Coordinates
   int x=1,y=0;
//--- Number of separation lines
   int sep_lines_total=::ArraySize(m_sep_line_index);
//---
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Calculating the Y coordinate
      y=(i>0) ? y+m_item_y_size : 1;
      //--- Store the form pointer
      m_items[i].MainPointer(this);
      //--- If the context menu has an attachment, add the pointer to the previous node
      if(!m_free_context_menu)
         m_items[i].GetPrevNodePointer(m_prev_node);
      //--- set properties
      m_items[i].Index(i);
      m_items[i].TwoState(m_items[i].TypeMenuItem()==MI_HAS_CONTEXT_MENU? true : false);
      m_items[i].XSize(m_x_size-2);
      m_items[i].YSize(m_item_y_size);
      m_items[i].IconXGap(m_icon_x_gap);
      m_items[i].IconYGap(m_icon_y_gap);
      m_items[i].IconFile(m_path_bmp_on[i]);
      m_items[i].IconFileLocked(m_path_bmp_off[i]);
      m_items[i].IconFilePressed(m_path_bmp_on[i]);
      m_items[i].IconFilePressedLocked(m_path_bmp_off[i]);
      m_items[i].BackColor(m_back_color);
      m_items[i].BackColorHover(m_back_color_hover);
      m_items[i].BackColorPressed(m_back_color_hover);
      m_items[i].BorderColor(m_back_color);
      m_items[i].BorderColorHover(m_back_color);
      m_items[i].BorderColorLocked(m_back_color);
      m_items[i].BorderColorPressed(m_back_color);
      m_items[i].LabelXGap(m_label_x_gap);
      m_items[i].LabelYGap(m_label_y_gap);
      m_items[i].LabelColor(m_label_color);
      m_items[i].LabelColorHover(m_label_color_hover);
      m_items[i].LabelColorPressed(m_label_color_hover);
      m_items[i].IsDropdown(m_is_dropdown);
      m_items[i].AnchorRightWindowSide(m_anchor_right_window_side);
      m_items[i].AnchorBottomWindowSide(m_anchor_bottom_window_side);
      //--- Creating a menu item
      if(!m_items[i].CreateMenuItem(m_text[i],x,y))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_items[i]);
      //--- Zero the focus
      CElementBase::MouseFocus(false);
      //--- Move to the following one if all separation lines have been set
      if(s>=sep_lines_total)
         continue;
      //--- If all indices match, then a separation line can be set up after this item
      if(i==m_sep_line_index[s])
        {
         if(!CreateSeparateLine(i,s))
            return(false);
         //--- Adjustment of the Y coordinate for the following item
         y=y+9;
         //--- Increase the counter for separation lines
         s++;
        }
     }
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a separation line                                        |
//+------------------------------------------------------------------+
bool CContextMenu::CreateSeparateLine(const int item_index,const int line_index)
  {
   int x=CElement::CalculateXGap(m_items[item_index].X()+5);
   int y=CElement::CalculateYGap(m_items[item_index].Y2()+2);
//--- Store the form pointer
   m_sep_line[line_index].MainPointer(m_main);
//--- set properties
   m_sep_line[line_index].IsDropdown(m_is_dropdown);
   m_sep_line[line_index].TypeSepLine(H_SEP_LINE);
   m_sep_line[line_index].DarkColor(m_sepline_dark_color);
   m_sep_line[line_index].LightColor(m_sepline_light_color);
   m_sep_line[line_index].AnchorRightWindowSide(m_anchor_right_window_side);
   m_sep_line[line_index].AnchorBottomWindowSide(m_anchor_bottom_window_side);
//--- Creating a separation line
   if(!m_sep_line[line_index].CreateSeparateLine(line_index,x,y,m_x_size-10,2))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_sep_line[line_index]);
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns a menu item pointer by the index                         |
//+------------------------------------------------------------------+
CMenuItem *CContextMenu::GetItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the context menu has at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Returns a pointer to the separation line by index                |
//+------------------------------------------------------------------+
CSeparateLine *CContextMenu::GetSeparateLinePointer(const uint index)
  {
   uint array_size=::ArraySize(m_sep_line);
//--- If there is no item in the context menu, report
   if(array_size<1)
      return(NULL);
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_sep_line[i]));
  }
//+------------------------------------------------------------------+
//| Exchange pointers to menu item and context menu                  |
//+------------------------------------------------------------------+
void CContextMenu::PrevNodePointer(CMenuItem &object)
  {
//--- Store the pointer to the menu item the context menu is attached to
   m_prev_node=::GetPointer(object);
//--- Store the pointer to this context menu
   m_prev_node.GetContextMenuPointer(this);
  }
//+------------------------------------------------------------------+
//| Adds a menu item                                                 |
//+------------------------------------------------------------------+
void CContextMenu::AddItem(const string text,const string path_bmp_on,const string path_bmp_off,const ENUM_TYPE_MENU_ITEM type)
  {
//--- Increase the array size by one element
   int array_size=::ArraySize(m_items);
   ::ArrayResize(m_items,array_size+1);
   ::ArrayResize(m_text,array_size+1);
   ::ArrayResize(m_path_bmp_on,array_size+1);
   ::ArrayResize(m_path_bmp_off,array_size+1);
//--- Store the value of passed parameters
   m_text[array_size]=text;
   m_path_bmp_on[array_size]  =path_bmp_on;
   m_path_bmp_off[array_size] =path_bmp_off;
//--- Setting the type of the menu item
   m_items[array_size].TypeMenuItem(type);
  }
//+------------------------------------------------------------------+
//| Adds a separation line                                           |
//+------------------------------------------------------------------+
void CContextMenu::AddSeparateLine(const int item_index)
  {
//--- Increase the array size by one element
   int array_size=::ArraySize(m_sep_line);
   ::ArrayResize(m_sep_line,array_size+1);
   ::ArrayResize(m_sep_line_index,array_size+1);
//--- Store the index number
   m_sep_line_index[array_size]=item_index;
  }
//+------------------------------------------------------------------+
//| Returns the item name by the index                               |
//+------------------------------------------------------------------+
string CContextMenu::DescriptionByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the context menu has at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the item description
   return(m_items[i].LabelText());
  }
//+------------------------------------------------------------------+
//| Returns the item type by the index                               |
//+------------------------------------------------------------------+
ENUM_TYPE_MENU_ITEM CContextMenu::TypeMenuItemByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the context menu has at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the item type
   return(m_items[i].TypeMenuItem());
  }
//+------------------------------------------------------------------+
//| Returns the checkbox state by the index                          |
//+------------------------------------------------------------------+
bool CContextMenu::CheckBoxStateByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the context menu has at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the item state
   return(m_items[i].CheckBoxState());
  }
//+------------------------------------------------------------------+
//| Sets the checkbox state by the index                             |
//+------------------------------------------------------------------+
void CContextMenu::CheckBoxStateByIndex(const uint index,const bool state)
  {
//--- Checking for exceeding the array range
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      return;
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Set the state
   m_items[i].CheckBoxState(state);
  }
//+------------------------------------------------------------------+
//| Returns the radio item id by the index                           |
//+------------------------------------------------------------------+
int CContextMenu::RadioItemIdByIndex(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the context menu has at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the identifier
   return(m_items[i].RadioButtonID());
  }
//+------------------------------------------------------------------+
//| Sets the radio item id by the index                              |
//+------------------------------------------------------------------+
void CContextMenu::RadioItemIdByIndex(const uint index,const int id)
  {
//--- Checking for exceeding the array range
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      return;
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Set the identifier
   m_items[i].RadioButtonID(id);
  }
//+------------------------------------------------------------------+
//| Returns the radio item index by the id                           |
//+------------------------------------------------------------------+
int CContextMenu::SelectedRadioItem(const int radio_id)
  {
//--- Radio item counter
   int count_radio_id=0;
//--- Iterate over the list of context menu items
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Move to the following if this is not a radio item
      if(m_items[i].TypeMenuItem()!=MI_RADIOBUTTON)
         continue;
      //--- If identifiers match
      if(m_items[i].RadioButtonID()==radio_id)
        {
         //--- If this is an active radio item, leave the loop
         if(m_items[i].RadioButtonState())
            break;
         //--- Increase the counter of radio items
         count_radio_id++;
        }
     }
//--- Return the index
   return(count_radio_id);
  }
//+------------------------------------------------------------------+
//| Switches the radio item by the index and id                      |
//+------------------------------------------------------------------+
void CContextMenu::SelectedRadioItem(const int radio_index,const int radio_id)
  {
//--- Radio item counter
   int count_radio_id=0;
//--- Iterate over the list of context menu items
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Move to the following if this is not a radio item
      if(m_items[i].TypeMenuItem()!=MI_RADIOBUTTON)
         continue;
      //--- If identifiers match
      if(m_items[i].RadioButtonID()==radio_id)
        {
         //--- Switch the radio item
         if(count_radio_id==radio_index)
            m_items[i].RadioButtonState(true);
         else
            m_items[i].RadioButtonState(false);
         //--- Increase the counter of radio items
         count_radio_id++;
        }
     }
  }
//+------------------------------------------------------------------+
//| Shows a context menu                                             |
//+------------------------------------------------------------------+
void CContextMenu::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Assign the status of a visible control
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving();
//--- Show the object
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Show the menu items
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Show();
//--- Show the separation line
   int sep_total=::ArraySize(m_sep_line);
   for(int i=0; i<sep_total; i++)
      m_sep_line[i].Show();
//--- Register the state in the previous node
   if(!m_free_context_menu)
      m_prev_node.IsPressed(true);
  }
//+------------------------------------------------------------------+
//| Hides a context menu                                             |
//+------------------------------------------------------------------+
void CContextMenu::Hide(void)
  {
//--- Leave, if the control is hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide the object
   m_canvas.Timeframes(OBJ_NO_PERIODS);
//--- Hide the menu items
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Hide();
//--- Hide the separation line
   int sep_total=::ArraySize(m_sep_line);
   for(int i=0; i<sep_total; i++)
      m_sep_line[i].Hide();
//--- Zero the focus
   CElementBase::MouseFocus(false);
//--- Assign the status of a hidden control
   CElementBase::IsVisible(false);
//--- Register the state in the previous node
   if(!m_free_context_menu)
      m_prev_node.IsPressed(false);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CContextMenu::Delete(void)
  {
//--- Removing objects  
   m_canvas.Delete();
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Delete();
//--- Removing separation lines
   int sep_total=::ArraySize(m_sep_line);
   for(int i=0; i<sep_total; i++)
      m_sep_line[i].Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_items);
   ::ArrayFree(m_sep_line);
   ::ArrayFree(m_sep_line_index);
   ::ArrayFree(m_text);
   ::ArrayFree(m_path_bmp_on);
   ::ArrayFree(m_path_bmp_off);
//--- Emptying the arrays of controls and objects
   CElement::FreeElementsArray();
//--- Initializing of variables by default values
   CElementBase::MouseFocus(false);
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Checking conditions for closing all context menus                |
//+------------------------------------------------------------------+
void CContextMenu::CheckHideContextMenus(void)
  {
//--- Leave, if (1) the cursor is in the context menu area or (2) in the previous node area
   if(CElementBase::MouseFocus() || m_prev_node.MouseFocus())
      return;
//--- Leave, if the cursor is in the context menu area or in the previous node area
//    ... a check is required if there are open context menus which were activated from this one
//--- For that iterate over the list of this context menu ...
//    ... for identification if there is a menu item containing a context menu
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- If there is such an item, check if its context menu is open.
      //    It this is open, do not send a signal for closing all context menus from this element as...
      //    ... it is possible that the cursor is in the area of the following one and this has to be checked.
      if(m_items[i].TypeMenuItem()==MI_HAS_CONTEXT_MENU)
         if(m_items[i].GetContextMenuPointer().IsVisible())
            return;
     }
//--- Release the button of the previous node
   m_prev_node.IsPressed(false);
   m_prev_node.Update(true);
//--- Send a signal to hide all context menus
   ::EventChartCustom(m_chart_id,ON_HIDE_CONTEXTMENUS,0,0,"");
//--- Message to restore the available controls
   
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Checking conditions for closing all context menus,               |
//| which were open after that                                       |
//+------------------------------------------------------------------+
void CContextMenu::CheckHideBackContextMenus(void)
  {
//--- Iterate over all menu items
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- If (1) the item contains a context menu and (2) it is enabled
      if(m_items[i].TypeMenuItem()==MI_HAS_CONTEXT_MENU && m_items[i].IsPressed())
        {
         //--- If the focus is in the context menu but not in this item
         if(CElementBase::MouseFocus() && !m_items[i].MouseFocus())
           {
            //--- Send a signal for hiding all context menus which were open after this one
            ::EventChartCustom(m_chart_id,ON_HIDE_BACK_CONTEXTMENUS,CElementBase::Id(),0,"");
            //--- Message to restore the available controls
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
            //--- Send a message about the change in the graphical interface
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Handling clicking on the menu item                               |
//+------------------------------------------------------------------+
bool CContextMenu::OnClickMenuItem(const string pressed_object,const int id,const int index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,"menu_item")<0)
      return(false);
//--- Leave, if (1) this context menu has a previous node and (2) is already open
   if(!m_free_context_menu && CElementBase::IsVisible())
      return(true);
//--- If this is a detached context menu
   if(m_free_context_menu)
     {
      //--- Find in a loop the menu item which was pressed
      int total=ItemsTotal();
      for(int i=0; i<total; i++)
        {
         if(i!=index)
            continue;
         //--- Send a message about it
         ::EventChartCustom(m_chart_id,ON_CLICK_FREEMENU_ITEM,CElementBase::Id(),i,DescriptionByIndex(i));
         break;
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Receiving a message from the menu item for handling              |
//+------------------------------------------------------------------+
void CContextMenu::ReceiveMessageFromMenuItem(const int id,const int index_item,const string message_item)
  {
//--- If (1) there is no sign of this program or (2) the identifiers do not match
   if(::StringFind(message_item,CElementBase::ProgramName(),0)<0 || id!=CElementBase::Id())
      return;
//--- If clicking was on the radio item
   if(::StringFind(message_item,"radioitem",0)>-1)
     {
      //--- Get the radio item id from the passed message
      int radio_id=RadioIdFromMessage(message_item);
      //--- Get the radio item index by the general index
      int radio_index=RadioIndexByItemIndex(index_item);
      //--- Switch the radio item
      SelectedRadioItem(radio_index,radio_id);
     }
//--- Hide the context menu
   Hide();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_CONTEXTMENU_ITEM,id,index_item,DescriptionByIndex(index_item));
//--- Send a signal to hide all context menus
   ::EventChartCustom(m_chart_id,ON_HIDE_CONTEXTMENUS,0,0,"");
//--- Message to restore the available controls
   
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Extracts the identifier from the message for the radio item      |
//+------------------------------------------------------------------+
int CContextMenu::RadioIdFromMessage(const string message)
  {
   ushort u_sep=0;
   string result[];
   int    array_size=0;
//--- Get the code of the separator
   u_sep=::StringGetCharacter("_",0);
//--- Split the string
   ::StringSplit(message,u_sep,result);
   array_size=::ArraySize(result);
//--- If the message structure differs from the expected one
   if(array_size!=3)
     {
      ::Print(__FUNCTION__," > Wrong structure in the message for the radio item! message: ",message);
      return(WRONG_VALUE);
     }
//--- Prevention of exceeding the array size
   if(array_size<3)
     {
      ::Print(PREVENTING_OUT_OF_RANGE);
      return(WRONG_VALUE);
     }
//--- Return the radio item id
   return((int)result[2]);
  }
//+------------------------------------------------------------------+
//| Returns the radio item index by the general index                |
//+------------------------------------------------------------------+
int CContextMenu::RadioIndexByItemIndex(const int index)
  {
   int radio_index=0;
//--- Get the radio item id by the general index
   int radio_id=RadioItemIdByIndex(index);
//--- Item counter from the required group
   int count_radio_id=0;
//--- Iterate over the list
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- If this is not a radio item, move to the next one
      if(m_items[i].TypeMenuItem()!=MI_RADIOBUTTON)
         continue;
      //--- If identifiers match
      if(m_items[i].RadioButtonID()==radio_id)
        {
         //--- If the indices match 
         //    store the current counter value and complete the loop
         if(m_items[i].Index()==index)
           {
            radio_index=count_radio_id;
            break;
           }
         //--- Increase the counter
         count_radio_id++;
        }
     }
//--- Return the index
   return(radio_index);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CContextMenu::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
  }
//+------------------------------------------------------------------+
