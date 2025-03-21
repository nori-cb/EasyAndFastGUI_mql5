//+------------------------------------------------------------------+
//|                                                     ListView.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Scrolls.mqh"
//+------------------------------------------------------------------+
//| Class for creating a list view                                   |
//+------------------------------------------------------------------+
class CListView : public CElement
  {
private:
   //--- Objects for creating the list view
   CRectCanvas       m_listview;
   CScrollV          m_scrollv;
   //--- Array of list view item properties
   struct LVItemOptions
     {
      int               m_y;     // Y coordinate of the top edge of the row
      int               m_y2;    // Y coordinate of the bottom edge of the row
      string            m_value; // Item text
      bool              m_state; // State of the checkbox
     };
   LVItemOptions     m_items[];
   //--- Size of the list view and its visible part
   int               m_items_total;
   //--- Total size and size of the visible part of the list view
   int               m_list_y_size;
   int               m_list_visible_y_size;
   //--- Total offset of the list view
   int               m_y_offset;
   //--- Size of the items along the Y axis
   int               m_item_y_size;
   //--- (1) Index and (2) the text of the highlighted item
   int               m_selected_item;
   string            m_selected_item_text;
   //--- Index of the previous selected item
   int               m_prev_selected_item;
   //--- To determine the row focus
   int               m_item_index_focus;
   //--- To determine the moment of mouse cursor transition from one row to another
   int               m_prev_item_index_focus;
   //--- Mode of list view with a checkbox
   bool              m_checkbox_mode;
   //--- For calculation of the boundaries of the visible area of the text box
   int               m_y_limit;
   int               m_y2_limit;
   //--- Mode of highlighting when the cursor is hovering over
   bool              m_lights_hover;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //--- For determining the indexes of the visible part of the list view
   int               m_visible_list_from_index;
   int               m_visible_list_to_index;
   //---
public:
                     CListView(void);
                    ~CListView(void);
   //--- Methods for creating the list view
   bool              CreateListView(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateList(void);
   bool              CreateScrollV(void);
   //---
public:
   //--- Returns the pointer to the scrollbar
   CScrollV         *GetScrollVPointer(void) { return(::GetPointer(m_scrollv)); }
   //--- (1) Item height, returns (2) the size of the list view and (3) its visible part
   void              ItemYSize(const int y_size)                         { m_item_y_size=y_size;         }
   int               ItemsTotal(void)                              const { return(::ArraySize(m_items)); }
   int               VisibleItemsTotal(void);
   //--- (1) State of the scrollbar, (2) mode of highlighting items when hovering, (3) mode of list view with a checkbox
   bool              ScrollState(void)                             const { return(m_scrollv.State());    }
   void              LightsHover(const bool state)                       { m_lights_hover=state;         }
   void              CheckBoxMode(const bool state)                      { m_checkbox_mode=state;        }
   //--- Returns (1) the index and (2) the text in the highlighted item in the list view
   int               SelectedItemIndex(void)                       const { return(m_selected_item);      }
   string            SelectedItemText(void)                        const { return(m_selected_item_text); }
   //--- Setting icons for the button in the pressed state (available/locked)
   void              IconFilePressed(const string file_path);
   void              IconFilePressedLocked(const string file_path);
   //--- (1) Setting the value, (2) selecting the item
   void              SetValue(const uint item_index,const string value,const bool redraw=false);
   void              SelectItem(const uint item_index,const bool redraw=false);
   //--- Set the size of (1) the list view and (2) its visible part
   void              ListSize(const int items_total);
   //--- Rebuilding the list
   void              Rebuilding(const int items_total,const bool redraw=false);
   //--- Add item to the list
   void              AddItem(const int item_index,const string value="",const bool redraw=false);
   //--- Deletes an item from the list view
   void              DeleteItem(const int item_index,const bool redraw=false);
   //--- Clears the list (deletes all items)
   void              Clear(const bool redraw=false);
   //--- Scrolling the list
   void              Scrolling(const int pos=WRONG_VALUE);
   //--- Resizing
   void              ChangeSize(const uint x_size,const uint y_size);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Moving the control
   virtual void      Moving(const bool only_visible=true);
   //--- Management
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- (1) Setting, (2) resetting priorities of the left mouse click
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Draws the control
   virtual void      Draw(void);
   //--- Updating the control
   virtual void      Update(const bool redraw=false);
   //---
private:
   //--- Handling the pressing on the list view item
   bool              OnClickList(const string pressed_object);
   //--- Returns the index of the clicked item
   int               PressedItemIndex(void);

   //--- Changing the color of list view items when the cursor is hovering over them
   void              ChangeItemsColor(void);
   //--- Checking the focus of list view items when the cursor is hovering
   int               CheckItemFocus(void);
   //--- Shift the list view relative to the position of scrollbar
   void              ShiftData(void);
   //--- Fast forward of the list view
   void              FastSwitching(void);

   //--- Calculates the size of the list view
   void              CalculateListYSize(void);
   //--- Change the main size of the control
   void              ChangeMainSize(const int x_size,const int y_size);
   //--- Resize the text box
   void              ChangeListSize(void);
   //--- Resize the scrollbars
   void              ChangeScrollsSize(void);

   //--- Recalculate with consideration of the recent changes and resize the list view
   void              RecalculateAndResizeList(const bool redraw=false);
   //--- Initialize the specified item with the default values
   void              ItemInitialize(const uint item_index);
   //--- Makes a copy of the specified item (source) to a new location (dest.)
   void              ItemCopy(const uint item_dest,const uint item_source);

   //--- Calculation of the Y coordinate of the item
   int               CalculationItemY(const int item_index=0);
   //--- Calculating the width of items
   int               CalculationItemsWidth(void);
   //--- Calculation of the text box boundaries along the Y axis
   void              CalculateYBoundaries(void);
   //--- Adjusting the vertical scrollbar
   void              CorrectingVerticalScrollThumb(void);
   //--- Calculation of the Y position of the scrollbar
   int               CalculateScrollPosY(const bool to_down=false);
   //--- Calculation of the Y coordinate of the scrollbar at the top/bottom edge of the list view
   int               CalculateScrollThumbY(void);
   int               CalculateScrollThumbY2(void);
   //--- Determining the indexes of the visible part of the list view
   void              VisibleListIndexes(void);

   //--- Draws the list view
   virtual void      DrawList(const bool only_visible=false);
   //--- Draws the frame
   virtual void      DrawBorder(void);
   //--- Draws the images of items
   virtual void      DrawImages(void);
   //--- Draws the image
   virtual void      DrawImage(void);
   //--- Draws the text of items
   virtual void      DrawText(void);

   //--- Redraws the specified list view item
   void              RedrawItem(const int item_index);
   //--- Redraws the list view items according to the specified mode
   void              RedrawItemsByMode(const bool is_selected_row=false);
   //--- Returns the current background color of the item
   uint              ItemColorCurrent(const int item_index,const bool is_item_focus);
   //--- Returns the color of the item text
   uint              TextColor(const int item_index);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Change the height at the bottom edge of the window
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CListView::CListView(void) : m_item_y_size(18),
                             m_lights_hover(false),
                             m_items_total(0),
                             m_y_offset(0),
                             m_checkbox_mode(false),
                             m_selected_item(WRONG_VALUE),
                             m_selected_item_text(""),
                             m_prev_selected_item(WRONG_VALUE),
                             m_item_index_focus(WRONG_VALUE),
                             m_prev_item_index_focus(WRONG_VALUE),
                             m_visible_list_from_index(WRONG_VALUE),
                             m_visible_list_to_index(WRONG_VALUE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Set the size of the list view and its visible part
   ListSize(m_items_total);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CListView::~CListView(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CListView::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Move the list if the management of the slider is enabled
      if(m_scrollv.ScrollBarControl())
        {
         //--- Update the list view and the scrollbar
         ShiftData();
         m_scrollv.Update(true);
         return;
        }
      //--- Reset the color
      if(!CElementBase::MouseFocus())
        {
         if(m_prev_item_index_focus==WRONG_VALUE)
            return;
         //--- Remove the focus
         m_canvas.MouseFocus(false);
         //--- Changes the color of the list view items when the cursor is hovering over it
         ChangeItemsColor();
         return;
        }
      //--- Checking the focus over the list view
      m_canvas.MouseFocus(m_mouse.X()>m_canvas.X() && m_mouse.X()<X2()-m_scrollv.ScrollWidth() && 
                          m_mouse.Y()>m_canvas.Y() && m_mouse.Y()<m_canvas.Y2());
      //--- Changes the color of the list view items when the cursor is hovering over it
      ChangeItemsColor();
      return;
     }
//--- Handling the pressing on objects
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- If the list view was clicked
      if(OnClickList(sparam))
         return;
     }
//--- Handling the click on the scrollbar buttons 
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- If the pressing was on the buttons of the scrollbar
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Moves the list along the scrollbar
         ShiftData();
         m_scrollv.Update(true);
         return;
        }
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CListView::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Creates the list view                                            |
//+------------------------------------------------------------------+
bool CListView::CreateListView(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Calculate the size of the list view
   CalculateListYSize();
//--- Create the list view
   if(!CreateCanvas())
      return(false);
   if(!CreateList())
      return(false);
   if(!CreateScrollV())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CListView::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x             =CElement::CalculateX(x_gap);
   m_y             =CElement::CalculateY(y_gap);
   m_x_size        =(m_x_size<0 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size        =(m_y_size<0 || m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
   m_selected_item =(m_selected_item==WRONG_VALUE && !m_checkbox_mode) ? 0 : m_selected_item;
//--- Colors of the items in different states
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_back_color_hover    =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'229,243,255';
   m_back_color_pressed  =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : C'51,153,255';
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrBlack;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrWhite;
   m_border_color        =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
//--- Offsets for images and text from the cell edges
   m_icon_x_gap  =(m_icon_x_gap>0)? m_icon_x_gap : 7;
   m_icon_y_gap  =(m_icon_y_gap>0)? m_icon_y_gap : 4;
   m_label_x_gap =(m_label_x_gap>0)? m_label_x_gap : 5;
   m_label_y_gap =(m_label_y_gap>0)? m_label_y_gap : 4;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Create the list view background                                  |
//+------------------------------------------------------------------+
bool CListView::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("listview");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp"
//---
bool CListView::CreateList(void)
  {
//--- Forming the object name
   string name=CElementBase::ProgramName()+"_"+"listview_array"+"_"+(string)CElementBase::Id();
//--- Size
   int x_size=m_x_size-2;
//--- Coordinates
   int x =m_x+1;
   int y =m_y+1;
//--- Creating an object
   ::ResetLastError();
   if(!m_listview.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,x_size,m_list_y_size,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Failed to create a canvas for drawing the list view: ",::GetLastError());
      return(false);
     }
//--- Get the pointer to the base class
   CChartObject *chart=::GetPointer(m_listview);
//--- Attach to the chart
   if(!chart.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- Properties
   m_listview.Z_Order(m_zorder+1);
   m_listview.Tooltip("\n");
//--- If a list view with checkboxes is required
   if(m_checkbox_mode)
     {
      IconFile("Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp");
      IconFileLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp");
      IconFilePressed("Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp");
      IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp");
     }
//--- Coordinates
   m_listview.X(x);
   m_listview.Y(y);
//--- Store the size
   m_listview.XSize(x_size);
   m_listview.YSize(m_list_y_size);
   m_listview.Resize(x_size,m_list_y_size);
//--- Margins from the edge of the panel
   m_listview.XGap(CElement::CalculateXGap(x));
   m_listview.YGap(CElement::CalculateYGap(y));
//--- Set the size of the visible area
   m_listview.SetInteger(OBJPROP_XSIZE,x_size);
   m_listview.SetInteger(OBJPROP_YSIZE,m_list_visible_y_size);
//--- Set the frame offset within the image along the X and Y axes
   m_listview.SetInteger(OBJPROP_XOFFSET,0);
   m_listview.SetInteger(OBJPROP_YOFFSET,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the vertical scrollbar                                   |
//+------------------------------------------------------------------+
bool CListView::CreateScrollV(void)
  {
//--- Store the pointer to the main control
   m_scrollv.MainPointer(this);
//--- Coordinates
   int x=16,y=1;
//--- Properties
   m_scrollv.XSize(15);
   m_scrollv.YSize(CElementBase::YSize()-2);
   m_scrollv.IsDropdown(CElementBase::IsDropdown());
   m_scrollv.AnchorRightWindowSide(true);
//--- Calculate the number of steps for offset
   uint items_total         =ItemsTotal();
   uint visible_items_total =VisibleItemsTotal();
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(x,y,items_total,visible_items_total))
      return(false);
//--- Hide the scrollbar, if the visible part is larger than the size of the list view
   if(m_list_visible_y_size>m_list_y_size)
      m_scrollv.Hide();
//--- Add the control to the array
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Highlights selected item                                         |
//+------------------------------------------------------------------+
void CListView::SelectItem(const uint item_index,const bool redraw=false)
  {
//--- Leave, if there are no items in the list view
   if(ItemsTotal()<1)
      return;
//--- Adjustment in case the range has been exceeded
   int checked_index=(item_index>=(uint)m_items_total)? m_items_total-1 :(int)item_index;
//--- If it is a list view with checkboxes
   if(m_checkbox_mode)
     {
      m_selected_item      =WRONG_VALUE;
      m_selected_item_text ="";
      //--- Set the opposite value to the checkbox
      m_items[checked_index].m_state=!m_items[checked_index].m_state;
      //--- Redraw the item if specified
      if(redraw)
         RedrawItem(item_index);
      //---
      return;
     }
//--- Store the index and text of the selected item
   m_selected_item      =checked_index;
   m_selected_item_text =m_items[m_selected_item].m_value;
//--- Redraw the list view, if specified
   if(redraw)
      Update(true);
  }
//+------------------------------------------------------------------+
//| Returns the number of visible items                              |
//+------------------------------------------------------------------+
int CListView::VisibleItemsTotal(void)
  {
   double visible_items_total =m_list_visible_y_size/m_item_y_size;
   double check_y_size        =visible_items_total*m_item_y_size;
//---
   visible_items_total=(check_y_size<m_list_visible_y_size+(m_y_offset*2)+1)? visible_items_total : visible_items_total;
   return((int)visible_items_total);
  }
//+------------------------------------------------------------------+
//| Setting the icon for the pressed state (available)               |
//+------------------------------------------------------------------+
void CListView::IconFilePressed(const string file_path)
  {
//--- Leave, if the mode of list view with a checkbox is disabled
   if(!m_checkbox_mode)
      return;
//--- Add an area for the image if it does not exist already
   while(!CElement::CheckOutOfRange(0,2))
      AddImage(0,"");
//--- Set the icon
   CElement::SetImage(0,2,file_path);
  }
//+------------------------------------------------------------------+
//| Setting the icon for the pressed state (locked)                  |
//+------------------------------------------------------------------+
void CListView::IconFilePressedLocked(const string file_path)
  {
//--- Leave, if the mode of list view with a checkbox is disabled
   if(!m_checkbox_mode)
      return;
//--- Add an area for the image if it does not exist already
   while(!CElement::CheckOutOfRange(0,3))
      AddImage(0,"");
//--- Set the icon
   CElement::SetImage(0,3,file_path);
  }
//+------------------------------------------------------------------+
//| Set the value in the list view at the specified index            |
//+------------------------------------------------------------------+
void CListView::SetValue(const uint item_index,const string value,const bool redraw=false)
  {
   uint array_size=ItemsTotal();
//--- If there is no item in the list view, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the list has at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(item_index>=array_size)? array_size-1 : item_index;
//--- Store the value in the list view
   m_items[i].m_value=value;
//--- Redraw the item if specified
   if(redraw)
      RedrawItem(item_index);
  }
//+------------------------------------------------------------------+
//| Sets the size of the list view                                   |
//+------------------------------------------------------------------+
void CListView::ListSize(const int items_total)
  {
//--- No point to make a list view shorter than two items
   m_items_total=(items_total<1) ? 0 : items_total;
   ::ArrayResize(m_items,m_items_total);
//--- Initialize the items with the default values
   for(int i=0; i<m_items_total; i++)
      ItemInitialize(i);
  }
//+------------------------------------------------------------------+
//| Rebuilding the list                                              |
//+------------------------------------------------------------------+
void CListView::Rebuilding(const int items_total,const bool redraw=false)
  {
//--- Set zero size
   ListSize(items_total);
//--- Calculate and resize the list view
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Add item to the list                                             |
//+------------------------------------------------------------------+
void CListView::AddItem(const int item_index,const string value="",const bool redraw=false)
  {
//--- Reserve count
   int reserve=100;
//--- Increase the array size by one element
   int array_size=ItemsTotal();
   m_items_total=array_size+1;
   ::ArrayResize(m_items,m_items_total,reserve);
//--- Adjustment of the index in case the range has been exceeded
   int checked_item_index=(item_index>=m_items_total)? m_items_total-1 : item_index;
//--- Shift other items (starting from the end of the array to the index of the added item)
   for(int i=array_size; i>=checked_item_index; i--)
     {
      //--- Initialize the new item with the default values
      if(i==checked_item_index)
        {
         ItemInitialize(i);
         m_items[i].m_value=value;
         continue;
        }
      //--- Index of the previous item
      uint prev_i=i-1;
      //--- Move the data from the previous item to the current item
      ItemCopy(i,prev_i);
     }
//--- Calculate and resize the list view
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Removes an item from the list view                               |
//+------------------------------------------------------------------+
void CListView::DeleteItem(const int item_index,const bool redraw=false)
  {
//--- Increase the array size by one element
   int array_size=ItemsTotal();
//--- Adjustment of the index in case the range has been exceeded
   int checked_item_index=(item_index>=m_items_total)? m_items_total-1 : item_index;
//--- Shift other items (starting from the specified index to the last item)
   for(int i=checked_item_index; i<array_size-1; i++)
     {
      //--- Index of the next item
      uint next_i=i+1;
      //--- Move the data from the next item to the current item
      ItemCopy(i,next_i);
     }
//--- Decrease the items array size by one element
   m_items_total=array_size-1;
   ::ArrayResize(m_items,m_items_total);
//--- Calculate and resize the list view
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Clears the list (deletes all items)                              |
//+------------------------------------------------------------------+
void CListView::Clear(const bool redraw=false)
  {
//--- Set zero size
   ListSize(0);
//--- Calculate and resize the list view
   RecalculateAndResizeList(redraw);
  }
//+------------------------------------------------------------------+
//| Scrolling the list                                               |
//+------------------------------------------------------------------+
void CListView::Scrolling(const int pos=WRONG_VALUE)
  {
//--- Leave, if the scrollbar is not required
   if(m_list_y_size<=m_list_visible_y_size)
      return;
//--- To determine the position of the thumb
   int index=0;
//--- Index of the last position
   int last_pos_index=m_list_y_size-m_list_visible_y_size;
//--- Adjustment in case the range has been exceeded
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Move the scrollbar thumb
   m_scrollv.MovingThumb(index);
//--- Move the list
   ShiftData();
  }
//+------------------------------------------------------------------+
//| Resize                                                           |
//+------------------------------------------------------------------+
void CListView::ChangeSize(const uint x_size,const uint y_size)
  {
//--- Set the new size
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
  }
//+------------------------------------------------------------------+
//| Changing color of the list view item when the cursor is hovering |
//+------------------------------------------------------------------+
void CListView::ChangeItemsColor(void)
  {
//--- Leave, if the highlighting of the item when the cursor is hovering over it is disabled or the scrollbar is active
   if(!m_lights_hover || m_scrollv.State())
      return;
//--- Leave, if it is not a drop-down control and the form is locked
   if(!CElementBase::IsDropdown() && m_main.IsLocked())
      return;
//--- If not in focus
   if(!m_canvas.MouseFocus())
     {
      //--- If not yet indicated that not in focus
      if(m_prev_item_index_focus!=WRONG_VALUE)
        {
         m_item_index_focus=WRONG_VALUE;
         //--- Change the color
         RedrawItemsByMode();
         //--- Reset the focus
         m_prev_item_index_focus=WRONG_VALUE;
        }
     }
//--- If in focus
   else
     {
      //--- Check the focus on the rows
      if(m_item_index_focus==WRONG_VALUE)
        {
         //--- Get the index of the row with the focus
         m_item_index_focus=CheckItemFocus();
         //--- Change the row color
         RedrawItemsByMode();
         //--- Store as the previous index in focus
         m_prev_item_index_focus=m_item_index_focus;
         return;
        }
      //--- Get the relative Y coordinate below the mouse cursor
      int y=m_mouse.RelativeY(m_listview);
      //--- Verifying the focus
      bool condition=(y>m_items[m_item_index_focus].m_y && y<=m_items[m_item_index_focus].m_y2);
      //--- If the focus changed
      if(!condition)
        {
         //--- Get the index of the row with the focus
         m_item_index_focus=CheckItemFocus();
         //--- Leave, if left the list view area
         if(m_item_index_focus<0)
            return;
         //--- Change the row color
         RedrawItemsByMode();
         //--- Store as the previous index in focus
         m_prev_item_index_focus=m_item_index_focus;
        }
     }
  }
//+------------------------------------------------------------------+
//| Check the focus of list view items when the cursor is hovering   |
//+------------------------------------------------------------------+
int CListView::CheckItemFocus(void)
  {
   int item_index_focus=WRONG_VALUE;
//--- Get the relative Y coordinate below the mouse cursor
   int y=m_mouse.RelativeY(m_listview);
///--- Get the indexes of the local area of the table
   VisibleListIndexes();
//--- Search for focus
   for(int i=m_visible_list_from_index; i<m_visible_list_to_index; i++)
     {
      //--- If the row focus changed
      if(y>m_items[i].m_y && y<=m_items[i].m_y2)
        {
         item_index_focus=(int)i;
         break;
        }
     }
//--- Return the index of the row with the focus
   return(item_index_focus);
  }
//+------------------------------------------------------------------+
//| Shift the list view relative to the position of scrollbar        |
//+------------------------------------------------------------------+
void CListView::ShiftData(void)
  {
//--- Store the shifting limitation
   int shift_y2_limit=m_list_y_size-m_list_visible_y_size;
//--- Get the current position of the scrollbar slider
   int v_offset=(m_scrollv.CurrentPos()*m_item_y_size);
//--- Calculate the offsets for shifting
   int y_offset=(v_offset<m_y_offset)? 0 :(v_offset>=shift_y2_limit-(m_y_offset*2+1))? shift_y2_limit : v_offset;
//--- The first position, if there is no scrollbar
   long y=(!m_scrollv.IsVisible())? 0 : y_offset;
//--- Shift the data
   m_listview.SetInteger(OBJPROP_YOFFSET,y);
  }
//+------------------------------------------------------------------+
//| Moving the control                                               |
//+------------------------------------------------------------------+
void CListView::Moving(const bool only_visible=true)
  {
//--- Leave, if the control is hidden
   if(only_visible)
      if(!CElementBase::IsVisible())
         return;
//--- If the anchored to the right
   if(m_anchor_right_window_side)
     {
      //--- Storing coordinates in the control fields
      CElementBase::X(m_main.X2()-XGap());
      //--- Storing coordinates in the fields of the objects
      m_listview.X(m_main.X2()-m_listview.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_listview.X(m_main.X()+m_listview.XGap());
     }
//--- If the anchored to the bottom
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_listview.Y(m_main.Y2()-m_listview.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_listview.Y(m_main.Y()+m_listview.YGap());
     }
//--- Updating coordinates of graphical objects
   m_listview.X_Distance(m_listview.X());
   m_listview.Y_Distance(m_listview.Y());
//--- Update the position of objects
   CElement::Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Show the list view                                               |
//+------------------------------------------------------------------+
void CListView::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Display the control
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
   m_listview.Timeframes(OBJ_ALL_PERIODS);
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving();
//--- Show the scrollbar
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
  }
//+------------------------------------------------------------------+
//| Hide the list view                                               |
//+------------------------------------------------------------------+
void CListView::Hide(void)
  {
   if(!CElementBase::IsVisible())
      return;
//--- Hide the control
   m_canvas.Timeframes(OBJ_NO_PERIODS);
   m_listview.Timeframes(OBJ_NO_PERIODS);
//--- Hide the scrollbar
   m_scrollv.Hide();
//--- Visible state
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CListView::Delete(void)
  {
   CElement::Delete();
   m_listview.Destroy();
//--- Free the array
   ::ArrayFree(m_items);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CListView::SetZorders(void)
  {
   CElement::SetZorders();
   m_listview.Z_Order(m_zorder+1);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CListView::ResetZorders(void)
  {
   CElement::ResetZorders();
   m_listview.Z_Order(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CListView::Draw(void)
  {
   DrawList();
  }
//+------------------------------------------------------------------+
//| Updating the control                                             |
//+------------------------------------------------------------------+
void CListView::Update(const bool redraw=false)
  {
//--- Redraw the table, if specified
   if(redraw)
     {
      //--- Calculate the sizes
      CalculateListYSize();
      //--- Set the new size
      ChangeListSize();
      //--- Draw
      Draw();
      //--- Apply
      m_canvas.Update();
      m_listview.Update();
      return;
     }
//--- Apply
   m_canvas.Update();
   m_listview.Update();
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the list view item                      |
//+------------------------------------------------------------------+
bool CListView::OnClickList(const string pressed_object)
  {
//--- Leave, if (1) the list view is not in focus or (2) the scrollbar is active
   if(!CElementBase::MouseFocus() || m_scrollv.State())
      return(false);
//--- Leave, if (1) it has a different object name or (2) the list view is empty
   if(m_listview.Name()!=pressed_object || ItemsTotal()<1)
      return(false);
//--- Determine the clicked item
   int index=PressedItemIndex();
//--- If the list view does not have checkboxes
   if(!m_checkbox_mode)
     {
      //--- Adjust the vertical scrollbar
      CorrectingVerticalScrollThumb();
      //--- Change the color of the item
      RedrawItemsByMode(true);
     }
   else
     {
      //--- Change the checkbox state for the opposite
      m_items[index].m_state=!m_items[index].m_state;
      //--- Update the list
      RedrawItem(index);
     }
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_LIST_ITEM,CElementBase::Id(),m_selected_item,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns the index of the clicked item                            |
//+------------------------------------------------------------------+
int CListView::PressedItemIndex(void)
  {
   int index=0;
//--- Get the relative Y coordinate below the mouse cursor
   int y=m_mouse.RelativeY(m_listview);
//--- Determine the clicked row
   for(int i=0; i<m_items_total; i++)
     {
      //--- If the click was not on this line, go to the next
      if(!(y>=m_items[i].m_y && y<=m_items[i].m_y2))
         continue;
      //--- Store the index
      index=i;
      //--- If the list view does not have checkboxes
      if(!m_checkbox_mode)
        {
         //--- Store the row index and the row of the first cell
         m_prev_selected_item =(m_selected_item==WRONG_VALUE)? index : m_selected_item;
         m_selected_item      =index;
         m_selected_item_text =m_items[index].m_value;
        }
      break;
     }
//--- Return the index
   return(index);
  }
//+------------------------------------------------------------------+
//| Fast forward of the list view                                    |
//+------------------------------------------------------------------+
void CListView::FastSwitching(void)
  {
//--- Leave, if there is no focus on the list view
   if(!CElementBase::MouseFocus())
      return;
//--- Return counter to initial value if the mouse button is released
   if(!m_mouse.LeftButtonState())
      m_timer_counter=SPIN_DELAY_MSC;
//--- If the mouse button is pressed
   else
     {
      //--- Increase counter to the specified interval
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Exit if below zero
      if(m_timer_counter<0)
         return;
      //--- Scrolling flag
      bool scroll_v=false;
      //--- If scrolling up
      if(m_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollInc((uint)Id(),0);
         scroll_v=true;
        }
      //--- If scrolling down
      else if(m_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollDec((uint)Id(),1);
         scroll_v=true;
        }
      //--- Leave, if the buttons are not pressed
      if(!scroll_v)
         return;
      //--- Update the list
      ShiftData();
      m_scrollv.Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Calculate the full list view size along the Y axis               |
//+------------------------------------------------------------------+
void CListView::CalculateListYSize(void)
  {
//--- Calculate the total height of the table
   int y_size    =(m_item_y_size*m_items_total)+(m_y_offset*2)+1;
   m_list_y_size =(y_size<=m_y_size)? m_y_size-2 : y_size;
//--- Set the frame height to display a fragment of the image (visible part of the table)
   m_list_visible_y_size=m_y_size-2;
//--- Adjust the size of the visible area along the Y axis
   m_list_visible_y_size=(m_list_visible_y_size>=m_list_y_size)? m_list_y_size : m_list_visible_y_size;
//--- Calculating coordinates
   for(int i=0; i<m_items_total; i++)
     {
      //--- Calculate the Y coordinates
      m_items[i].m_y  =(i<1)? m_y_offset : m_items[i-1].m_y2;
      m_items[i].m_y2 =m_items[i].m_y+m_item_y_size;
     }
  }
//+------------------------------------------------------------------+
//| Change the main size of the control                              |
//+------------------------------------------------------------------+
void CListView::ChangeMainSize(const int x_size,const int y_size)
  {
//--- Set the new size
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
  }
//+------------------------------------------------------------------+
//| Resize the text box                                              |
//+------------------------------------------------------------------+
void CListView::ChangeListSize(void)
  {
   int x_size=m_x_size-2;
//--- Resize the table
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
   m_listview.XSize(x_size);
   m_listview.YSize(m_list_y_size);
   m_listview.Resize(x_size,m_list_y_size);
//--- Set the size of the visible area
   m_listview.SetInteger(OBJPROP_XSIZE,x_size);
   m_listview.SetInteger(OBJPROP_YSIZE,m_list_visible_y_size);
//--- Resize the scrollbars
   ChangeScrollsSize();
//--- Adjust the data
   ShiftData();
  }
//+------------------------------------------------------------------+
//| Resize the scrollbars                                            |
//+------------------------------------------------------------------+
void CListView::ChangeScrollsSize(void)
  {
//--- Calculate the number of steps for offset
   uint y_size_total         =ItemsTotal();
   uint visible_y_size_total =VisibleItemsTotal();
//--- Calculate the sizes of the scrollbars
   m_scrollv.Reinit(y_size_total,visible_y_size_total);
//--- Set the new size
   m_scrollv.ChangeYSize(CElementBase::YSize()-2);
//--- If the vertical scrollbar is not required
   if(!m_scrollv.IsScroll())
     {
      //--- Hide the vertical scrollbar
      m_scrollv.Hide();
     }
   else
     {
      //--- Show the vertical scrollbar
      if(CElementBase::IsVisible())
         m_scrollv.Show();
     }
  }
//+------------------------------------------------------------------+
//| Calculate with consideration of recent changes and resize list   |
//+------------------------------------------------------------------+
void CListView::RecalculateAndResizeList(const bool redraw=false)
  {
//--- Calculate the size of the list view
   CalculateListYSize();
//--- Set the new size
   ChangeListSize();
//--- Update
   Update(redraw);
  }
//+------------------------------------------------------------------+
//| Initialize the specified item with the default values            |
//+------------------------------------------------------------------+
void CListView::ItemInitialize(const uint item_index)
  {
   m_items[item_index].m_y     =0;
   m_items[item_index].m_y2    =0;
   m_items[item_index].m_value ="";
   m_items[item_index].m_state =false;
  }
//+------------------------------------------------------------------+
//| Make a copy of specified item (source) to a new location (dest.) |
//+------------------------------------------------------------------+
void CListView::ItemCopy(const uint item_dest,const uint item_source)
  {
   m_items[item_dest].m_value =m_items[item_source].m_value;
   m_items[item_dest].m_state =m_items[item_source].m_state;
  }
//+------------------------------------------------------------------+
//| Calculating the width of items                                   |
//+------------------------------------------------------------------+
int CListView::CalculationItemsWidth(void)
  {
   return((m_scrollv.IsScroll()) ? CElementBase::XSize()-m_scrollv.ScrollWidth()-3 : CElementBase::XSize()-3);
  }
//+------------------------------------------------------------------+
//| Calculation of the control boundaries along the Y axis           |
//+------------------------------------------------------------------+
void CListView::CalculateYBoundaries(void)
  {
//--- Leave, if there is no scrollbar
   if(!m_scrollv.IsVisible())
      return;
//--- Get the Y coordinate and offset along the Y axis
   int y       =(int)m_listview.GetInteger(OBJPROP_YDISTANCE);
   int yoffset =(int)m_listview.GetInteger(OBJPROP_YOFFSET);
//--- Calculate the boundaries of the visible portion of the text box
   m_y_limit  =(y+yoffset)-y;
   m_y2_limit =(y+yoffset+m_y_size)-y;
  }
//+------------------------------------------------------------------+
//| Adjusting the vertical scrollbar                                 |
//+------------------------------------------------------------------+
void CListView::CorrectingVerticalScrollThumb(void)
  {
//--- Get the boundaries of the visible portion of the text box
   CalculateYBoundaries();
//--- If the text cursor leaves the visible part upwards
   if(m_items[m_selected_item].m_y<=m_y_limit)
     {
      Scrolling(CalculateScrollPosY());
     }
//--- If the text cursor leaves the visible part downwards
   else if(m_items[m_selected_item].m_y2>=m_y2_limit)
     {
      Scrolling(CalculateScrollPosY(true));
     }
  }
//+------------------------------------------------------------------+
//| Calculate the Y position of the scrollbar                        |
//+------------------------------------------------------------------+
int CListView::CalculateScrollPosY(const bool to_down=false)
  {
   int    calc_y      =(!to_down)? CalculateScrollThumbY() : CalculateScrollThumbY2();
   double pos_y_value =(calc_y-::fmod((double)calc_y,(double)m_item_y_size))/m_item_y_size+((!to_down)? 0 : 1);
//---
   return((int)pos_y_value);
  }
//+------------------------------------------------------------------+
//| Calculate Y coordinate of scrollbar at the top of list view      |
//+------------------------------------------------------------------+
int CListView::CalculateScrollThumbY(void)
  {
   return(m_items[m_selected_item].m_y-m_y_offset);
  }
//+------------------------------------------------------------------+
//| Calculate Y coordinate of scrollbar at the bottom of list view   |
//+------------------------------------------------------------------+
int CListView::CalculateScrollThumbY2(void)
  {
//--- Calculate and return the value
   return(m_items[m_selected_item].m_y-m_y_size+m_item_y_size);
  }
//+------------------------------------------------------------------+
//| Determining the indexes of the visible part of the list view     |
//+------------------------------------------------------------------+
void CListView::VisibleListIndexes(void)
  {
//--- Determine the boundaries taking the offset of the visible part of the table into account
   int yoffset1 =(int)m_listview.GetInteger(OBJPROP_YOFFSET);
   int yoffset2 =yoffset1+m_list_visible_y_size;
//--- Determine the first and the last indexes of the visible part of the table
   m_visible_list_from_index =int(double(yoffset1/m_item_y_size));
   m_visible_list_to_index   =int(double(yoffset2/m_item_y_size));
//--- Increase the lower index by one, if not out of range
   m_visible_list_to_index=(m_visible_list_to_index+1>m_items_total)? m_items_total : m_visible_list_to_index+1;
  }
//+------------------------------------------------------------------+
//| Draws the list view                                              |
//+------------------------------------------------------------------+
void CListView::DrawList(const bool only_visible=false)
  {
//--- If not indicated to redraw only the visible part of the list view
   if(!only_visible)
     {
      //--- Set the row indexes of the entire list view from the beginning to the end
      m_visible_list_from_index =0;
      m_visible_list_to_index   =m_items_total;
     }
//--- Get the row indexes of the visible part of the list view
   else
      VisibleListIndexes();
//--- Draw the background
   DrawBackground();
   m_listview.Erase(::ColorToARGB(m_back_color,m_alpha));
//--- Draw the images
   DrawImages();
//--- Draw text
   DrawText();
//--- Draw frame
   DrawBorder();
  }
//+------------------------------------------------------------------+
//| Draws the frame of the Text box                                  |
//+------------------------------------------------------------------+
void CListView::DrawBorder(void)
  {
//--- Get the offset along the X axis
   int x_offset =(int)m_canvas.GetInteger(OBJPROP_XOFFSET);
   int y_offset =(int)m_canvas.GetInteger(OBJPROP_YOFFSET);
//--- Boundaries
   int x_size =m_canvas.X_Size();
   int y_size =m_canvas.Y_Size();
//--- Coordinates
   int x1 =x_offset;
   int y1 =y_offset;
   int x2 =x_offset+x_size;
   int y2 =y_offset+y_size;
//--- Draw a rectangle without fill
   m_canvas.Rectangle(x1,y1,x2-1,y2-1,::ColorToARGB(m_border_color));
  }
//+------------------------------------------------------------------+
//| Draws the images                                                 |
//+------------------------------------------------------------------+
void CListView::DrawImages(void)
  {
//--- Leave, if the checkboxes are disabled
   if(!m_checkbox_mode)
      return;
//--- Draw the checkboxes in items
   for(int i=m_visible_list_from_index; i<m_visible_list_to_index; i++)
     {
      //--- Calculating coordinates
      m_images_group[0].m_y_gap=m_items[i].m_y+m_icon_y_gap;
      //--- Set the corresponding icon
      CElement::ChangeImage(0,(m_items[i].m_state)? 2 : 0);
      CListView::DrawImage();
     }
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CListView::DrawImage(void)
  {
//--- Index of the image
   int i=SelectedImage();
//--- If there are no images
   if(i==WRONG_VALUE)
      return;
//--- Coordinates
   int x =m_images_group[0].m_x_gap;
   int y =m_images_group[0].m_y_gap;
//--- Size
   uint height =m_images_group[0].m_image[i].Height();
   uint width  =m_images_group[0].m_image[i].Width();
//--- Draw
   for(uint ly=0,p=0; ly<height; ly++)
     {
      for(uint lx=0; lx<width; lx++,p++)
        {
         //--- If there is no color, go to the next pixel
         if(m_images_group[0].m_image[i].Data(p)<1)
            continue;
         //--- Get the color of the lower layer (cell background) and color of the specified pixel of the icon
         uint background  =::ColorToARGB(m_listview.PixelGet(x+lx,y+ly));
         uint pixel_color =m_images_group[0].m_image[i].Data(p);
         //--- Blend the colors
         uint foreground=::ColorToARGB(m_clr.BlendColors(background,pixel_color));
         //--- Draw the pixel of the overlay icon
         m_listview.PixelSet(x+lx,y+ly,foreground);
        }
     }
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CListView::DrawText(void)
  {
//--- To calculate the coordinates and offsets
   int x=0,y=0;
//--- Font properties
   m_listview.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Rows
   for(int i=m_visible_list_from_index; i<m_visible_list_to_index; i++)
     {
      //--- Draw the row background
      int x1 =0;
      int x2 =CalculationItemsWidth();
      int y1 =m_items[i].m_y;
      int y2 =m_items[i].m_y2;
      //---
      if(i==m_selected_item)
        {
         m_listview.FillRectangle(x1,y1,x2,y2,ItemColorCurrent(i,false));
         m_listview.Rectangle(x1,y1,x2,y2,::ColorToARGB(m_back_color,m_alpha));
        }
      //--- Draw text
      x =m_label_x_gap;
      y =m_items[i].m_y+m_label_y_gap;
      m_listview.TextOut(x,y,m_items[i].m_value,TextColor(i),TA_LEFT|TA_TOP);
     }
  }
//+------------------------------------------------------------------+
//| Redraws the specified list view item                             |
//+------------------------------------------------------------------+
void CListView::RedrawItem(const int item_index)
  {
//--- Coordinates
   int x1 =0;
   int x2 =CalculationItemsWidth();
   int y1 =m_items[item_index].m_y;
   int y2 =m_items[item_index].m_y2;
//--- To calculate the coordinates
   int x=0,y=0;
//--- To check the focus
   bool is_item_focus=false;
//--- If the row highlighting mode is enabled
   if(m_lights_hover)
     {
      //--- (1) Get the relative Y coordinate of the mouse cursor and (2) the focus on the specified table row
      y=m_mouse.RelativeY(m_listview);
      is_item_focus=(y>m_items[item_index].m_y && y<=m_items[item_index].m_y2);
     }
//--- Draw the item
   m_listview.FillRectangle(x1,y1,x2,y2,ItemColorCurrent(item_index,is_item_focus));
//--- Draw frame
   m_listview.Rectangle(x1,y1,x2,y2,::ColorToARGB(m_back_color,m_alpha));
//--- Draw the icons if it is a list view with checkboxes
   if(m_checkbox_mode)
     {
      //--- Calculating coordinates
      m_images_group[0].m_y_gap=m_items[item_index].m_y+m_icon_y_gap;
      //--- Set the corresponding icon
      CElement::ChangeImage(0,(m_items[item_index].m_state)? 2 : 0);
      CListView::DrawImage();
     }
//--- Draw text
   x1 =m_label_x_gap;
   y1 =m_items[item_index].m_y+m_label_y_gap;
   m_listview.TextOut(x1,y1,m_items[item_index].m_value,TextColor(item_index),TA_LEFT|TA_TOP);
//--- Update the canvas
   m_listview.Update();
  }
//+------------------------------------------------------------------+
//| Redraws the list view items according to the specified mode      |
//+------------------------------------------------------------------+
void CListView::RedrawItemsByMode(const bool is_selected_item=false)
  {
//--- The current and the previous row indexes
   int item_index      =WRONG_VALUE;
   int prev_item_index =WRONG_VALUE;
//--- Initialization of the row indexes relative to the specified mode
   if(is_selected_item)
     {
      item_index      =m_selected_item;
      prev_item_index =m_prev_selected_item;
     }
   else
     {
      item_index      =m_item_index_focus;
      prev_item_index =m_prev_item_index_focus;
     }
//--- Leave, if the indexes are not defined
   if(prev_item_index==WRONG_VALUE && item_index==WRONG_VALUE)
      return;
//--- Number of items to draw
   uint items_total=(item_index!=WRONG_VALUE && prev_item_index!=WRONG_VALUE && item_index!=prev_item_index)? 2 : 1;
//--- Coordinates
   int x1=0;
   int x2=CalculationItemsWidth();
   int y1[2]={0},y2[2]={0};
//--- Array for values in a certain sequence
   int indexes[2];
//--- If (1) the mouse cursor moved down or if (2) entering for the first time
   if(item_index>m_prev_item_index_focus || item_index==WRONG_VALUE)
     {
      indexes[0]=(item_index==WRONG_VALUE || prev_item_index!=WRONG_VALUE)? prev_item_index : item_index;
      indexes[1]=item_index;
     }
//--- If the mouse cursor moved up
   else
     {
      indexes[0]=item_index;
      indexes[1]=prev_item_index;
     }
//--- Draw the background of items
   for(uint i=0; i<items_total; i++)
     {
      //--- Calculate the coordinates of the upper and lower boundaries of the row
      y1[i] =m_items[indexes[i]].m_y;
      y2[i] =m_items[indexes[i]].m_y2;
      //--- Determine the focus on the row with respect to the highlighting mode
      bool is_item_focus=false;
      if(!m_lights_hover)
         is_item_focus=(indexes[i]==item_index && item_index!=WRONG_VALUE);
      else
         is_item_focus=(item_index==WRONG_VALUE)?(indexes[i]==prev_item_index) :(indexes[i]==item_index);
      //--- Draw the item
      m_listview.FillRectangle(x1,y1[i],x2,y2[i],ItemColorCurrent(indexes[i],is_item_focus));
      //--- Draw frame
      m_listview.Rectangle(x1,y1[i],x2,y2[i],::ColorToARGB(m_back_color,m_alpha));
     }
//--- Draw the icons if it is a list view with checkboxes
   if(m_checkbox_mode)
     {
      for(uint i=0; i<items_total; i++)
        {
         //--- Calculating coordinates
         m_images_group[0].m_y_gap=m_items[indexes[i]].m_y+m_icon_y_gap;
         //--- Set the corresponding icon
         CElement::ChangeImage(0,(m_items[indexes[i]].m_state)? 2 : 0);
         CListView::DrawImage();
        }
     }
//--- To calculate the coordinates
   int x=0,y=0;
//--- Get the X coordinate of the text
   x=m_label_x_gap;
//--- Draw the text
   for(uint i=0; i<items_total; i++)
     {
      //--- (1) Calculate the coordinate and (2) draw the text
      y=m_items[indexes[i]].m_y+m_label_y_gap;
      m_listview.TextOut(x,y,m_items[indexes[i]].m_value,TextColor(indexes[i]),TA_TOP|TA_LEFT);
     }
//--- Apply
   m_listview.Update();
  }
//+------------------------------------------------------------------+
//| Returns the current background color of the item                 |
//+------------------------------------------------------------------+
uint CListView::ItemColorCurrent(const int item_index,const bool is_item_focus)
  {
//--- If the row is selected
   if(item_index==m_selected_item)
      return(::ColorToARGB(m_back_color_pressed,m_alpha));
//--- Color of the item
   uint clr=m_back_color;
//--- If (1) not in focus or (2) the form is locked
   bool condition=(!is_item_focus || !m_canvas.MouseFocus() || m_main.IsLocked());
//---
   clr=(condition)? m_back_color : m_back_color_hover;
//--- Return the color
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Returns the color of the item text                               |
//+------------------------------------------------------------------+
uint CListView::TextColor(const int item_index)
  {
   uint clr=(item_index==m_selected_item)? m_label_color_pressed : m_label_color;
//--- Return the header color
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CListView::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Size
   int x_size =m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Set the new size
   ChangeMainSize(x_size,y_size);
//--- Calculate the size of the text box
   CalculateListYSize();
//--- Set the new size to the text box
   ChangeListSize();
//--- Draw the control
   Draw();
   Update();
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Change the height at the bottom edge of the window               |
//+------------------------------------------------------------------+
void CListView::ChangeHeightByBottomWindowSide(void)
  {
//--- Leave, if the anchoring mode to the bottom of the form is enabled  
   if(m_anchor_bottom_window_side)
      return;
//--- Size
   int x_size =(m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   int y_size =m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset;
//--- Set the new size
   ChangeMainSize(x_size,y_size);
//--- Calculate the size of the list view
   CalculateListYSize();
//--- Set the new size to the text box
   ChangeListSize();
//--- Draw the control
   Draw();
   Update();
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
