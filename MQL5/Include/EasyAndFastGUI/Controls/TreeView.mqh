//+------------------------------------------------------------------+
//|                                                     TreeView.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TreeItem.mqh"
#include "Scrolls.mqh"
#include "Pointer.mqh"
//+------------------------------------------------------------------+
//| Class for creating a tree view                                   |
//+------------------------------------------------------------------+
class CTreeView : public CElement
  {
private:
   //--- Objects for creating the control
   CTreeItem         m_items[];
   CTreeItem         m_content_items[];
   CScrollV          m_scrollv;
   CScrollV          m_content_scrollv;
   CPointer          m_x_resize;
   //--- Structure of the controls attached to each tab item
   struct TVElements
     {
      CElement         *elements[];
      int               list_index;
     };
   TVElements        m_tab_items[];
   //--- Arrays for all items of the tree view (full list)
   int               m_t_list_index[];
   int               m_t_prev_node_list_index[];
   string            m_t_item_text[];
   string            m_t_path_bmp[];
   int               m_t_item_index[];
   int               m_t_node_level[];
   int               m_t_prev_node_item_index[];
   int               m_t_items_total[];
   int               m_t_folders_total[];
   bool              m_t_item_state[];
   bool              m_t_is_folder[];
   //--- Arrays for the list of displayed items of the tree view
   int               m_td_list_index[];
   //--- Arrays for the content list of the items selected in the tree view (full list)
   int               m_c_list_index[];
   int               m_c_tree_list_index[];
   string            m_c_item_text[];
   //--- Arrays for the list of displayed items in the content list
   int               m_cd_list_index[];
   int               m_cd_tree_list_index[];
   string            m_cd_item_text[];
   //--- Total number of items and the number of lists in the visible part
   int               m_items_total;
   int               m_content_items_total;
   int               m_visible_items_total;
   //--- Indices of the selected items in the lists
   int               m_selected_item_index;
   int               m_selected_content_item_index;
   //--- Text of the item selected in the list.
   //    Only for files in the case of using a class for creating a file navigator.
   //    If not a file is selected in the list, then this field must contain an empty string "".
   string            m_selected_item_file_name;
   //--- Tree view area width
   int               m_treeview_width;
   //--- Height of the items
   int               m_item_y_size;
   //--- File navigator mode
   ENUM_FILE_NAVIGATOR_MODE m_file_navigator_mode;
   //--- Mode of highlighting when the cursor is hovering over
   bool              m_lights_hover;
   //--- Mode of displaying the item content in the working area
   bool              m_show_item_content;
   //--- Mode of changing the list widths
   bool              m_resize_list_mode;
   //--- Mode of tab items
   bool              m_tab_items_mode;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //--- (1) Minimum and (2) maximum level of node
   int               m_min_node_level;
   int               m_max_node_level;
   //--- The number of items in the root directory
   int               m_root_items_total;
   //---
public:
                     CTreeView(void);
                    ~CTreeView(void);
   //--- Methods for creating a tree view
   bool              CreateTreeView(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   bool              CreateScrollV(void);
   bool              CreateContentItems(void);
   bool              CreateContentScrollV(void);
   bool              CreateXResizePointer(void);
   //---
public:
   //--- Pointers to list scrollbars
   CScrollV         *GetScrollVPointer(void)                            { return(::GetPointer(m_scrollv));         }
   CScrollV         *GetContentScrollVPointer(void)                     { return(::GetPointer(m_content_scrollv)); }
   CPointer         *GetMousePointer(void)                              { return(::GetPointer(m_x_resize));        }
   //--- Returns the (1) pointer of the tree view item, (2) pointer of the content list item, 
   CTreeItem        *ItemPointer(const uint index);
   CTreeItem        *ContentItemPointer(const uint index);
   //--- (1) File navigator mode, (2) mode of highlighting when hovered, 
   //    (3) mode of changing the list widths, (4) tab items mode
   void              NavigatorMode(const ENUM_FILE_NAVIGATOR_MODE mode) { m_file_navigator_mode=mode;              }
   void              LightsHover(const bool state)                      { m_lights_hover=state;                    }
   void              ResizeListMode(const bool state)                   { m_resize_list_mode=state;                }
   void              TabItemsMode(const bool state)                     { m_tab_items_mode=state;                  }
   bool              TabItemsMode(void)                           const { return(m_tab_items_mode);                }
   //--- Mode of displaying the item contents, 
   void              ShowItemContent(const bool state)                  { m_show_item_content=state;               }
   bool              ShowItemContent(void)                        const { return(m_show_item_content);             }
   //--- The number of items (1) in the tree view, (2) in the content list and (3) visible number of items
   int               ItemsTotal(void)                             const { return(::ArraySize(m_items));            }
   int               ContentItemsTotal(void)                      const { return(::ArraySize(m_content_items));    }
   void              VisibleItemsTotal(const int total)                 { m_visible_items_total=total;             }
   //--- (1) The height of the item, (2) the width of the tree view and (3) the content list
   void              ItemYSize(const int y_size)                        { m_item_y_size=y_size;                    }
   void              TreeViewWidth(const int x_size)                    { m_treeview_width=x_size;                 }
   //--- (1) Selects the item by index and (2) returns the index of the selected item, (3) return the name of the file
   void              SelectedItemIndex(const int index)                 { m_selected_item_index=index;             }
   int               SelectedItemIndex(void)                      const { return(m_selected_item_index);           }
   string            SelectedItemFileName(void)                   const { return(m_selected_item_file_name);       }

   //--- Add item to the tree view
   void              AddItem(const int list_index,const int list_id,const string item_name,const string path_bmp,const int item_index,
                             const int node_number,const int item_number,const int items_total,const int folders_total,const bool item_state,const bool is_folder=true);
   //--- Add control to the tab item array
   void              AddToElementsArray(const int item_index,CElement &object);
   //--- Show controls of the selected tab item only
   void              ShowTabElements(void);
   //--- Returns the full path of the selected item
   string            CurrentFullPath(void);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Control availability
   virtual void      IsAvailable(const bool state,const bool without_items=false);
   //--- Management
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handle clicking the item list minimization/maximization button
   bool              OnClickItemArrow(const string clicked_object,const int id,const int index);
   //--- Handling clicking the tree view item
   bool              OnClickTreeItem(const string clicked_object,const int id,const int index);
   //--- Handling clicking the item in the content list
   bool              OnClickContentItem(const string clicked_object,const int id,const int index);

   //--- Generates an array of tab items
   void              GenerateTabItemsArray(void);
   //--- Determine and set (1) the node borders and (2) the size of the root directory
   void              SetNodeLevelBoundaries(void);
   void              SetRootItemsTotal(void);
   //--- Shift of the lists
   void              ShiftTreeList(void);
   void              ShiftContentList(void);
   //--- Fast forward of the list view
   void              FastSwitching(void);

   //--- Controls the width of the lists
   void              ResizeListArea(void);
   //--- Check readiness to change the width of lists
   void              CheckXResizePointer(const int x,const int y);
   //--- Checking for exceeding the limits
   bool              CheckOutOfArea(const int x,const int y);
   //--- Updating the list item widths
   void              UpdateXSize(const int x);

   //--- Add the item to the list in the content area
   void              AddDisplayedTreeItem(const int list_index);
   //--- Generates (1) the tree view and (2) the content list
   void              FormTreeList(void);
   void              FormContentList(void);
   //---
public:
   //--- Redraw the lists
   void              RedrawTreeList(void);
   void              RedrawContentList(void);
   //--- Updates (1) the tree view and (2) the content list
   void              UpdateTreeList(void);
   void              UpdateContentList(void);
   //---
private:
   //--- Checking for the index of the selected item exceeding the array range
   void              CheckSelectedItemIndex(void);

   //--- Draws the border between areas
   virtual void      DrawResizeBorder(void);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTreeView::CTreeView(void) : m_treeview_width(150),
                             m_item_y_size(20),
                             m_visible_items_total(12),
                             m_tab_items_mode(false),
                             m_lights_hover(false),
                             m_show_item_content(false),
                             m_resize_list_mode(false),
                             m_timer_counter(SPIN_DELAY_MSC),
                             m_selected_item_index(WRONG_VALUE),
                             m_selected_content_item_index(WRONG_VALUE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTreeView::~CTreeView(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CTreeView::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Move the tree view if the management of the slider is enabled
      if(m_scrollv.ScrollBarControl())
        {
         ShiftTreeList();
         m_scrollv.Update(true);
         return;
        }
      //--- Enter only if there is a list
      if(m_t_items_total[m_selected_item_index]>0)
        {
         //--- Move the content list if the management of the slider is enabled
         if(m_content_scrollv.ScrollBarControl())
           {
            ShiftContentList();
            m_content_scrollv.Update(true);
            return;
           }
        }
      //--- Management of the content area width
      ResizeListArea();
      return;
     }
//--- Handling the click on the scrollbar buttons 
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Leave, if the mode of changing the size of the content list area is active
      if(m_x_resize.IsVisible() || m_x_resize.State())
         return;
      //--- Handle clicking on the item arrow
      if(OnClickItemArrow(sparam,(int)lparam,(int)dparam))
         return;
      //--- Handling clicking the tree view item
      if(OnClickTreeItem(sparam,(int)lparam,(int)dparam))
         return;
      //--- Handling clicking the item in the content list
      if(OnClickContentItem(sparam,(int)lparam,(int)dparam))
         return;
      //--- If the pressing was on the buttons of the scrollbar
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         ShiftTreeList();
         m_scrollv.Update(true);
         return;
        }
      //--- If the pressing was on the buttons of the scrollbar
      if(m_content_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_content_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         ShiftContentList();
         m_content_scrollv.Update(true);
         return;
        }
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTreeView::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Creates the control                                              |
//+------------------------------------------------------------------+
bool CTreeView::CreateTreeView(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
   if(!CreateScrollV())
      return(false);
   if(!CreateContentItems())
      return(false);
   if(!CreateContentScrollV())
      return(false);
   if(!CreateXResizePointer())
      return(false);
//--- Generates an array of tab items
   GenerateTabItemsArray();
//--- Determine and set (1) the node borders and (2) the size of the root directory
   SetNodeLevelBoundaries();
   SetRootItemsTotal();
//--- Update lists
   FormTreeList();
   FormContentList();
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTreeView::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size =m_item_y_size*m_visible_items_total+2;
//--- Width of the list
   if(!m_show_item_content)
      m_treeview_width=m_x_size;
   else
      m_treeview_width=(m_treeview_width>=m_x_size)? m_x_size>>1 : m_treeview_width;
//--- Default colors
   m_back_color   =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_border_color =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
//--- Checking for the index of the selected item exceeding the array range
   CheckSelectedItemIndex();
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CTreeView::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("tree_view");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the tree view                                            |
//+------------------------------------------------------------------+
bool CTreeView::CreateItems(void)
  {
//--- Coordinates
   int x=1,y=1;
//---
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- Calculating the Y coordinate
      y=(i>0)? y+m_item_y_size : y;
      //--- Store the pointer to parent
      m_items[i].MainPointer(this);
      //--- Properties
      m_items[i].NamePart("tree_item");
      m_items[i].Index(m_t_list_index[i]);
      m_items[i].XSize(m_treeview_width);
      m_items[i].YSize(m_item_y_size);
      m_items[i].IconXGap(m_items[i].ArrowXGap(m_t_node_level[i])+17);
      m_items[i].IconYGap(2);
      m_items[i].IconFile(m_t_path_bmp[i]);
      m_items[i].IsHighlighted(m_lights_hover);
      //--- Determine the item type
      ENUM_TYPE_TREE_ITEM type=TI_SIMPLE;
      if(m_file_navigator_mode==FN_ALL)
        {
         type=(m_t_items_total[i]>0)? TI_HAS_ITEMS : TI_SIMPLE;
        }
      else // FN_ONLY_FOLDERS
        {
         type=(m_t_folders_total[i]>0)? TI_HAS_ITEMS : TI_SIMPLE;
        }
      //--- Adjustment of the initial state of the item
      m_t_item_state[i]=(type==TI_HAS_ITEMS)? m_t_item_state[i]: false;
      //--- Create control
      if(!m_items[i].CreateTreeItem(x,y,type,m_t_list_index[i],m_t_node_level[i],m_t_item_text[i],m_t_item_state[i]))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_items[i]);
     }
//--- Set the color of the selected item
   if(!m_tab_items_mode && m_selected_item_index>=0)
      m_items[m_selected_item_index].IsPressed(true);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the vertical scrollbar                                   |
//+------------------------------------------------------------------+
bool CTreeView::CreateScrollV(void)
  {
//--- Store the form pointer
   m_scrollv.MainPointer(this);
//--- Coordinates
   int x=m_treeview_width-((m_show_item_content)? 15 : 16);
   int y=1;
//--- set properties
   m_scrollv.Index(0);
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize(CElementBase::YSize()-2);
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(x,y,m_items_total,m_visible_items_total))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a content list of the selected item                       |
//+------------------------------------------------------------------+
bool CTreeView::CreateContentItems(void)
  {
//--- Leave, if (1) showing the item content is not needed or (2) the tab mode is enabled
   if(!m_show_item_content || m_tab_items_mode)
      return(true);
//--- Reserve size of the array
   int reserve_size=10000;
//--- Coordinates and width
   int x=m_treeview_width,y=1;
   int w=m_x_size-m_treeview_width-2;
//--- Counter of the number of items
   int c=0;
//--- 
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- This list must include items from the root directory, 
      //    therefore, if the node level is less than 1, go to the next
      if(m_t_node_level[i]<1)
         continue;
      //--- Increase the sizes of arrays by one element
      int new_size=c+1;
      ::ArrayResize(m_content_items,new_size,reserve_size);
      ::ArrayResize(m_c_item_text,new_size,reserve_size);
      ::ArrayResize(m_c_tree_list_index,new_size,reserve_size);
      ::ArrayResize(m_c_list_index,new_size,reserve_size);
      //--- Calculating the Y coordinate
      y=(c>0)? y+m_item_y_size : y;
      //--- Pass the panel object
      m_content_items[c].MainPointer(this);
      //--- Set properties before creation
      m_content_items[c].NamePart("content_item");
      m_content_items[c].Index(m_t_list_index[i]);
      m_content_items[c].XSize(w);
      m_content_items[c].YSize(m_item_y_size);
      m_content_items[c].IconXGap(7);
      m_content_items[c].IconYGap(2);
      m_content_items[c].IconFile(m_t_path_bmp[i]);
      m_content_items[c].IsHighlighted(m_lights_hover);
      //--- Creating an object
      if(!m_content_items[c].CreateTreeItem(x,y,TI_SIMPLE,c,0,m_t_item_text[i],false))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_content_items[c]);
      //--- Store (1) index of the general content list, (2) index of the tree view and (3) item text
      m_c_list_index[c]      =c;
      m_c_tree_list_index[c] =m_t_list_index[i];
      m_c_item_text[c]       =m_t_item_text[i];
      //---
      c++;
     }
//--- Store the size of the list
   m_content_items_total=::ArraySize(m_content_items);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create vertical scrollbar for working area                       |
//+------------------------------------------------------------------+
bool CTreeView::CreateContentScrollV(void)
  {
//--- Store the form pointer
   m_content_scrollv.MainPointer(this);
//--- Leave, if showing the item content is not needed
   if(!m_show_item_content)
      return(true);
//--- Coordinates
   int x=16,y=1;
//--- Properties
   m_content_scrollv.Index(1);
   m_content_scrollv.XSize(m_content_scrollv.ScrollWidth());
   m_content_scrollv.YSize(CElementBase::YSize()-2);
   m_content_scrollv.AnchorRightWindowSide(true);
//--- Creating the scrollbar
   if(!m_content_scrollv.CreateScroll(x,y,m_content_items_total,m_visible_items_total))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_content_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create cursor of changing the width                              |
//+------------------------------------------------------------------+
bool CTreeView::CreateXResizePointer(void)
  {
//--- Leave, if changing the width of the content area is not needed or the tab item mode is enabled
   if(!m_resize_list_mode || m_tab_items_mode)
     {
      m_x_resize.State(false);
      m_x_resize.IsVisible(false);
      return(true);
     }
//--- Properties
   m_x_resize.XGap(12);
   m_x_resize.YGap(9);
   m_x_resize.XSize(25);
   m_x_resize.Type(MP_X_RESIZE);
   m_x_resize.Id(CElementBase::Id());
//--- Create control
   if(!m_x_resize.CreatePointer(m_chart_id,m_subwin))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns tree view item pointer by the index                      |
//+------------------------------------------------------------------+
CTreeItem *CTreeView::ItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if the context menu has at least one item!");
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Returns content area item pointer by the index                   |
//+------------------------------------------------------------------+
CTreeItem *CTreeView::ContentItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_content_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if the context menu has at least one item!");
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_content_items[i]));
  }
//+------------------------------------------------------------------+
//| Add item to the common array of the tree view                    |
//+------------------------------------------------------------------+
void CTreeView::AddItem(const int list_index,const int prev_node_list_index,const string item_text,const string path_bmp,const int item_index,
                        const int node_level,const int prev_node_item_index,const int items_total,const int folders_total,const bool item_state,const bool is_folder)
  {
//--- Reserve size of the array
   int reserve_size=10000;
//--- Increase the array size by one element
   int array_size =::ArraySize(m_items);
   m_items_total  =array_size+1;
   ::ArrayResize(m_items,m_items_total,reserve_size);
   ::ArrayResize(m_t_list_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_prev_node_list_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_item_text,m_items_total,reserve_size);
   ::ArrayResize(m_t_path_bmp,m_items_total,reserve_size);
   ::ArrayResize(m_t_item_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_node_level,m_items_total,reserve_size);
   ::ArrayResize(m_t_prev_node_item_index,m_items_total,reserve_size);
   ::ArrayResize(m_t_items_total,m_items_total,reserve_size);
   ::ArrayResize(m_t_folders_total,m_items_total,reserve_size);
   ::ArrayResize(m_t_item_state,m_items_total,reserve_size);
   ::ArrayResize(m_t_is_folder,m_items_total,reserve_size);
//--- Store the value of passed parameters
   m_t_list_index[array_size]           =list_index;
   m_t_prev_node_list_index[array_size] =prev_node_list_index;
   m_t_item_text[array_size]            =item_text;
   m_t_path_bmp[array_size]             =path_bmp;
   m_t_item_index[array_size]           =item_index;
   m_t_node_level[array_size]           =node_level;
   m_t_prev_node_item_index[array_size] =prev_node_item_index;
   m_t_items_total[array_size]          =items_total;
   m_t_folders_total[array_size]        =folders_total;
   m_t_item_state[array_size]           =item_state;
   m_t_is_folder[array_size]            =is_folder;
  }
//+------------------------------------------------------------------+
//| Add control to the array of the specified tab                    |
//+------------------------------------------------------------------+
void CTreeView::AddToElementsArray(const int tab_index,CElement &object)
  {
//--- Leave, if the tab item mode is disabled
   if(!m_tab_items_mode)
      return;
//--- Checking for exceeding the array range
   int array_size=::ArraySize(m_tab_items);
   if(array_size<1 || tab_index<0 || tab_index>=array_size)
      return;
//--- Add pointer of the passed control to array of the specified tab
   int size=::ArraySize(m_tab_items[tab_index].elements);
   ::ArrayResize(m_tab_items[tab_index].elements,size+1);
   m_tab_items[tab_index].elements[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Show controls of the selected tab item only                      |
//+------------------------------------------------------------------+
void CTreeView::ShowTabElements(void)
  {
//--- Leave, if (1) the control is hidden or (2) tab item mode is disabled
   if(!CElementBase::IsVisible() || !m_tab_items_mode)
      return;
//--- Index of the selected tab
   int tab_index=WRONG_VALUE;
//--- Determine the index of the selected tab
   int tab_items_total=::ArraySize(m_tab_items);
   for(int i=0; i<tab_items_total; i++)
     {
      if(m_tab_items[i].list_index==m_selected_item_index)
        {
         tab_index=i;
         break;
        }
     }
//--- Show controls of the selected tab only
   for(int i=0; i<tab_items_total; i++)
     {
      //--- Get the number of controls attached to the tab
      int tab_elements_total=::ArraySize(m_tab_items[i].elements);
      //--- If this tab item is selected
      if(i==tab_index)
        {
         //--- Display the controls
         for(int j=0; j<tab_elements_total; j++)
            m_tab_items[i].elements[j].Reset();
        }
      else
        {
         //--- Hide the controls
         for(int j=0; j<tab_elements_total; j++)
            m_tab_items[i].elements[j].Hide();
        }
     }
  }
//+------------------------------------------------------------------+
//| return the current full path                                     |
//+------------------------------------------------------------------+
string CTreeView::CurrentFullPath(void)
  {
//--- To generate a directory to the selected item
   string path="";
//--- Index of the selected item
   int li=m_selected_item_index;
//--- Array for generating the directory
   string path_parts[];
//--- Get the description (text) of the selected tree view item,
//    but only if it is a folder
   if(m_t_is_folder[li])
     {
      ::ArrayResize(path_parts,1);
      path_parts[0]=m_t_item_text[li];
     }
//--- Iterate over the full list
   int total=::ArraySize(m_t_list_index);
   for(int i=0; i<total; i++)
     {
      //--- Only folders are considered.
      //    If it is a file, go to the next item.
      if(!m_t_is_folder[i])
         continue;
      //--- If (1) index of the general list matches the index of the general list of the previous node and
      //    (2) index of the local list item matches the index of the previous node item and
      //    (3) the sequence of node levels is maintained
      if(m_t_list_index[i]==m_t_prev_node_list_index[li] &&
         m_t_item_index[i]==m_t_prev_node_item_index[li] &&
         m_t_node_level[i]==m_t_node_level[li]-1)
        {
         //--- Increase the array by one element and store the item description
         int sz=::ArraySize(path_parts);
         ::ArrayResize(path_parts,sz+1);
         path_parts[sz]=m_t_item_text[i];
         //--- Store the index for subsequent checking
         li=i;
         //--- If the zero level of the node is reached, leave the cycle
         if(m_t_node_level[i]==0 || i<=0)
            break;
         // --- Reset the cycle counter
         i=-1;
        }
     }
//--- Generate a string - the full path to the selected item in the tree view
   total=::ArraySize(path_parts);
   for(int i=total-1; i>=0; i--)
      ::StringAdd(path,path_parts[i]+"\\");
//--- If the selected item in the tree view is a folder
   if(m_t_is_folder[m_selected_item_index])
     {
      m_selected_item_file_name="";
      //--- If the item in the content area is selected
      if(m_selected_content_item_index>0)
        {
         //--- If the selected item is a file, store its name
         if(!m_t_is_folder[m_c_tree_list_index[m_selected_content_item_index]])
            m_selected_item_file_name=m_c_item_text[m_selected_content_item_index];
        }
     }
//--- If the selected item in the tree view is a file
   else
//--- Store its name
      m_selected_item_file_name=m_t_item_text[m_selected_item_index];
//--- Return directory
   return(path);
  }
//+------------------------------------------------------------------+
//| Control availability                                             |
//+------------------------------------------------------------------+
void CTreeView::IsAvailable(const bool state,const bool without_items=false)
  {
//--- If it has no items
   if(without_items)
     {
      m_is_available=state;
      return;
     }
//--- If it has items
   else
     {
      m_is_available=state;
      int elements_total=CElement::ElementsTotal();
      for(int i=0; i<elements_total; i++)
         m_elements[i].IsAvailable(state);
      //---
      if(state)
         SetZorders();
      else
         ResetZorders();
     }
  }
//+------------------------------------------------------------------+
//| Shows the control                                                |
//+------------------------------------------------------------------+
void CTreeView::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Display the control
   CElement::Show();
//--- Update coordinates and sizes of lists
   ShiftTreeList();
   ShiftContentList();
  }
//+------------------------------------------------------------------+
//| Hides the control                                                |
//+------------------------------------------------------------------+
void CTreeView::Hide(void)
  {
//--- Leave, if the control is already hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide the control
   CElement::Hide();
//--- Hide tree view items
   int total=::ArraySize(m_items);
   for(int i=0; i<total; i++)
      m_items[i].Hide();
//--- Hide content list items
   total=::ArraySize(m_content_items);
   for(int i=0; i<total; i++)
      m_content_items[i].Hide();
//--- Hide the scrollbars
   m_scrollv.Hide();
   m_content_scrollv.Hide();
//--- Adjust the scrollbar size
   m_scrollv.ChangeThumbSize(m_items_total,m_visible_items_total);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CTreeView::Delete(void)
  {
   CElement::Delete();
   m_x_resize.Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_items);
   ::ArrayFree(m_content_items);
//---
   int total=::ArraySize(m_tab_items);
   for(int i=0; i<total; i++)
      ::ArrayFree(m_tab_items[i].elements);
   ::ArrayFree(m_tab_items);
//---
   ::ArrayFree(m_t_prev_node_list_index);
   ::ArrayFree(m_t_list_index);
   ::ArrayFree(m_t_item_text);
   ::ArrayFree(m_t_path_bmp);
   ::ArrayFree(m_t_item_index);
   ::ArrayFree(m_t_node_level);
   ::ArrayFree(m_t_prev_node_item_index);
   ::ArrayFree(m_t_items_total);
   ::ArrayFree(m_t_folders_total);
   ::ArrayFree(m_t_item_state);
   ::ArrayFree(m_t_is_folder);
//---
   ::ArrayFree(m_td_list_index);
//---
   ::ArrayFree(m_c_list_index);
   ::ArrayFree(m_c_item_text);
//---
   ::ArrayFree(m_cd_item_text);
   ::ArrayFree(m_cd_list_index);
   ::ArrayFree(m_cd_tree_list_index);
//--- Initializing of variables by default values
   m_selected_item_index=WRONG_VALUE;
   m_selected_content_item_index=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTreeView::Draw(void)
  {
//--- Draw the background
   DrawBackground();
//--- Draw frame
   DrawBorder();
//--- Draw the border of areas
   DrawResizeBorder();
  }
//+------------------------------------------------------------------+
//| Clicking the item list minimization/maximization button          |
//+------------------------------------------------------------------+
bool CTreeView::OnClickItemArrow(const string clicked_object,const int id,const int index)
  {
//--- Leave, if it has a different object name
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_tree_item_",0)<0)
      return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Get the index of the item in the general list
   int list_index=CElementBase::IndexFromObjectName(clicked_object);
//--- Leave, if this item does not have a drop-down list
   if(m_items[list_index].Type()!=TI_HAS_ITEMS)
      return(false);
//--- Get the relative coordinates under the mouse cursor
   int x=m_mouse.RelativeX(m_canvas);
//--- Leave, if the pressing was not on the arrow
   if(x<m_items[list_index].ArrowXGap() || x>m_items[list_index].ArrowXGap()+16)
      return(false);
//--- Get the state of the item arrow and set the opposite one
   m_t_item_state[list_index]=!m_t_item_state[list_index];
//--- Highlight the selected item
   m_items[list_index].ItemState(m_t_item_state[list_index]);
   m_items[list_index].IsPressed((list_index==m_selected_item_index)? true : false);
   m_items[list_index].Update(true);
//--- Generate the tree view
   FormTreeList();
//--- Update
   UpdateTreeList();
//--- Calculate the location of teh scrollbar slider
   m_scrollv.MovingThumb(m_scrollv.CurrentPos());
//--- Show controls of the selected tab item
   ShowTabElements();
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Clicking a tree view item                                        |
//+------------------------------------------------------------------+
bool CTreeView::OnClickTreeItem(const string clicked_object,const int id,const int index)
  {
//--- Leave, if the scrollbar is active
   if(m_scrollv.State() || m_content_scrollv.State())
      return(false);
//--- Leave, if it has a different object name
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_tree_item_",0)<0)
      return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Get the current position of the scrollbar slider
   int v=m_scrollv.CurrentPos();
//--- Iterate over the list
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Check to prevent exceeding the array range
      if(v>=0 && v<m_items_total)
        {
         //--- Get the general index of the item
         int li=m_td_list_index[v];
         //--- If this list view item was selected
         if(m_items[li].CanvasPointer().Name()==clicked_object)
           {
            //--- Leave, if this item was already highlighted
            if(li==m_selected_item_index)
              {
               m_items[li].IsPressed(true);
               m_items[li].Update(true);
               return(false);
              }
            //--- If the tab items mode is enabled and the content display mode is disabled,
            //    do not highlight the items without a list
            if(m_tab_items_mode && !m_show_item_content)
              {
               //--- If the current item does not contain a list, stop the cycle
               if(m_t_items_total[li]>0)
                 {
                  m_items[li].IsPressed(false);
                  m_items[li].Update(true);
                  break;
                 }
              }
            //--- Set the color to the previous highlighted item
            m_items[m_selected_item_index].IsPressed(false);
            m_items[m_selected_item_index].Update(true);
            //--- Store the index for the current item and change its color
            m_selected_item_index=li;
            m_items[li].IsPressed(true);
            m_items[li].Update(true);
            break;
           }
         v++;
        }
     }
//--- Reset colors in the content area
   if(m_selected_content_item_index>=0)
     {
      m_content_items[m_selected_content_item_index].IsPressed(false);
      m_content_items[m_selected_content_item_index].Update();
     }
//--- Reset the highlighted item
   m_selected_content_item_index=WRONG_VALUE;
//--- Update the content list
   FormContentList();
   UpdateContentList();
//--- Calculate the location of teh scrollbar slider
   m_content_scrollv.MovingThumb(m_content_scrollv.CurrentPos());
//--- Show controls of the selected tab item
   ShowTabElements();
//--- Send a message about selecting a new directory in the tree view
   ::EventChartCustom(m_chart_id,ON_CHANGE_TREE_PATH,0,0,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Clicking the item in the content list                            |
//+------------------------------------------------------------------+
bool CTreeView::OnClickContentItem(const string clicked_object,const int id,const int index)
  {
//--- Leave, if the content area is disabled
   if(!m_show_item_content)
      return(false);
//--- Leave, if the scrollbar is active
   if(m_scrollv.State() || m_content_scrollv.State())
      return(false);
//--- Leave, if it has a different object name
   if(::StringFind(clicked_object,CElementBase::ProgramName()+"_content_item_",0)<0)
      return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Get the number of items in the content list
   int content_items_total=::ArraySize(m_cd_list_index);
//--- Get the current position of the scrollbar slider
   int v=m_content_scrollv.CurrentPos();
//--- Iterate over the list
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Check to prevent exceeding the array range
      if(v>=0 && v<content_items_total)
        {
         //--- Get the general index of the list
         int li=m_cd_list_index[v];
         //--- If this list view item was selected
         if(m_content_items[li].CanvasPointer().Name()==clicked_object)
           {
            //--- Set the color to the previous highlighted item
            if(m_selected_content_item_index>=0)
              {
               m_content_items[m_selected_content_item_index].IsPressed(false);
               m_content_items[m_selected_content_item_index].Update(true);
              }
            //--- Store the index for the current item and change the color
            m_selected_content_item_index=li;
            m_content_items[li].IsPressed(true);
            m_content_items[li].Update(true);
           }
         v++;
        }
     }
//--- Send a message about selecting a new directory in the tree view
   ::EventChartCustom(m_chart_id,ON_CHANGE_TREE_PATH,0,0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Generates an array of tab items                                  |
//+------------------------------------------------------------------+
void CTreeView::GenerateTabItemsArray(void)
  {
//--- Leave, if the tab item mode is disabled
   if(!m_tab_items_mode)
      return;
//--- Add only empty items to the array of tab items
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- If this item contains other items, go to the next\
      if(m_t_items_total[i]>0)
         continue;
      //--- Increase the size of the tab items array by one element
      int array_size=::ArraySize(m_tab_items);
      ::ArrayResize(m_tab_items,array_size+1);
      //--- Store the general index of the item
      m_tab_items[array_size].list_index=i;
     }
//--- If item content display is disabled
   if(!m_show_item_content)
     {
      //--- Get the size of the tab items array
      int tab_items_total=::ArraySize(m_tab_items);
      //--- Adjust the index if out of range
      if(m_selected_item_index>=tab_items_total)
         m_selected_item_index=tab_items_total-1;
      //--- Index of the selected tab
      int tab_index=m_tab_items[m_selected_item_index].list_index;
      m_selected_item_index=tab_index;
      m_items[tab_index].IsPressed(true);
      m_items[tab_index].Update();
     }
  }
//+------------------------------------------------------------------+
//| Determine and set the node borders                               |
//+------------------------------------------------------------------+
void CTreeView::SetNodeLevelBoundaries(void)
  {
//--- Determine the minimum and maximum node levels
   m_min_node_level =m_t_node_level[::ArrayMinimum(m_t_node_level)];
   m_max_node_level =m_t_node_level[::ArrayMaximum(m_t_node_level)];
  }
//+------------------------------------------------------------------+
//| Determine and set the size of the root directory                 |
//+------------------------------------------------------------------+
void CTreeView::SetRootItemsTotal(void)
  {
//--- Determine the number of items in the root directory
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- If this is the minimum level, increase the counter
      if(m_t_node_level[i]==m_min_node_level)
         m_root_items_total++;
     }
  }
//+------------------------------------------------------------------+
//| Moves the tree view along the scrollbar                          |
//+------------------------------------------------------------------+
void CTreeView::ShiftTreeList(void)
  {
//--- Leave, if the control is hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide all items in the tree view
   int items_total=ItemsTotal();
   for(int i=0; i<items_total; i++)
      m_items[i].Hide();
//--- Get the number of displayed items in the list
   int total=::ArraySize(m_td_list_index);
//--- Calculating the width of the list items
   int w=(m_scrollv.IsScroll())? CElementBase::XSize()-m_scrollv.ScrollWidth()-2 : CElementBase::XSize();
//--- Determine the scrollbar position
   int v=(m_scrollv.IsScroll())? m_scrollv.CurrentPos() : 0;
   m_scrollv.CurrentPos(v);
//--- Coordinates
   int x=1,y=1;
//---
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Check to prevent exceeding the array range
      if(v>=0 && v<total)
        {
         //--- Calculate the Y coordinate
         y=(r>0)? y+m_item_y_size : y;
         //--- Get the general index of the tree view item
         int li=m_td_list_index[v];
         //--- Set the coordinates and width
         m_items[li].UpdateX(x);
         m_items[li].UpdateY(y);
         //--- Show the item
         m_items[li].Show();
         v++;
        }
     }
//--- Redraw the scrollbar
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
  }
//+------------------------------------------------------------------+
//| Moves the tree view along the scrollbar                          |
//+------------------------------------------------------------------+
void CTreeView::ShiftContentList(void)
  {
//--- Leave, if (1) showing the item content is not needed or (2) the control is hidden
   if(!m_show_item_content || !CElementBase::IsVisible())
      return;
//--- Hide all content list items
   m_content_items_total=ContentItemsTotal();
   for(int i=0; i<m_content_items_total; i++)
      m_content_items[i].Hide();
//--- Get the number of items displayed in the content list
   int total=::ArraySize(m_cd_list_index);
//--- If a scrollbar is required
   bool is_scroll=total>m_visible_items_total;
//--- Calculating the width of the list items
   int w=(is_scroll)? m_x_size-m_treeview_width-m_content_scrollv.ScrollWidth()-2 : m_x_size-m_treeview_width-2;
//--- Determine the scrollbar position
   int v=(is_scroll)? m_content_scrollv.CurrentPos() : 0;
   m_content_scrollv.CurrentPos(v);
//--- X coordinate
   int x=m_treeview_width+1;
//--- The Y coordinate of the first item of the tree view
   int y=1;
//--- 
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Check to prevent exceeding the array range
      if(v>=0 && v<total)
        {
         //--- Calculate the Y coordinate
         y=(r>0)? y+m_item_y_size : y;
         //--- Get the general index of the tree view item
         int li=m_cd_list_index[v];
         //--- Set the coordinates and width
         m_content_items[li].UpdateX(x);
         m_content_items[li].UpdateY(y);
         //--- Show the item
         m_content_items[li].Show();
         v++;
        }
     }
//--- Redraw the scrollbar
   if(is_scroll)
      m_content_scrollv.Show();
  }
//+------------------------------------------------------------------+
//| Fast forward of the lists                                        |
//+------------------------------------------------------------------+
void CTreeView::FastSwitching(void)
  {
//--- Determining the focus on one of the scrollbar buttons
   bool spin_buttons_focus=m_scrollv.GetIncButtonPointer().MouseFocus() || 
                           m_scrollv.GetDecButtonPointer().MouseFocus() ||
                           m_content_scrollv.GetIncButtonPointer().MouseFocus() ||
                           m_content_scrollv.GetDecButtonPointer().MouseFocus();
//--- Leave, if (1) outside of the control area or (2) the mode of changing the content area width is activated
   if((!CElementBase::MouseFocus() && !spin_buttons_focus) || m_x_resize.State())
     {
      //--- Send a message about the change in the graphical interface
      if(m_timer_counter!=SPIN_DELAY_MSC)
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      //--- Return counter to initial value
      m_timer_counter=SPIN_DELAY_MSC;
      return;
     }
//--- If the mouse button is released
   if(!m_mouse.LeftButtonState())
     {
      //--- Send a message about the change in the graphical interface
      if(m_timer_counter!=SPIN_DELAY_MSC)
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      //--- Return counter to initial value
      m_timer_counter=SPIN_DELAY_MSC;
     }
//--- If the mouse button is pressed
   else
     {
      //--- Leave, if no button is pressed
      if(!spin_buttons_focus)
         return;
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
      //--- If the button is pressed
      if(scroll_v)
        {
         //--- Update the list
         ShiftTreeList();
         m_scrollv.Update(true);
         return;
        }
      //--- Leave, if the content area is disabled
      if(!m_show_item_content)
         return;
      //--- If scrolling up
      if(m_content_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_content_scrollv.OnClickScrollInc((uint)Id(),2);
         scroll_v=true;
        }
      //--- If scrolling down
      else if(m_content_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_content_scrollv.OnClickScrollDec((uint)Id(),3);
         scroll_v=true;
        }
      //--- If the button is pressed
      if(scroll_v)
        {
         //--- Update the list
         ShiftContentList();
         m_content_scrollv.Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Controls the width of the lists                                  |
//+------------------------------------------------------------------+
void CTreeView::ResizeListArea(void)
  {
//--- Leave, (1) if changing the width of the content area is not needed or 
//    (2) the tab items mode is enabled or (3) the scrollbar is active
   if(!m_resize_list_mode || !m_show_item_content || m_tab_items_mode || m_scrollv.State())
      return;
//--- Coordinates
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Check readiness to change the width of lists
   CheckXResizePointer(x,y);
//--- Leave, if the cursor is disabled
   if(!m_x_resize.State())
      return;
//--- Checking for exceeding the specified limits 
   if(!CheckOutOfArea(x,y))
      return;
//--- Set the X-coordinate to the object at the center of the mouse cursor
   m_x_resize.UpdateX(m_mouse.X());
//--- The Y-coordinate is set only if the control area was not exceeded
   if(y>0 && y<m_y_size)
      m_x_resize.UpdateY(m_mouse.Y());
//--- Updating the list item widths
   UpdateXSize(x);
//--- Redraw cursor
   m_x_resize.Reset();
  }
//+------------------------------------------------------------------+
//| Check readiness to change the width of lists                     |
//+------------------------------------------------------------------+
void CTreeView::CheckXResizePointer(const int x,const int y)
  {
//--- If the pointer is not activated, but the mouse cursor is in its area
   if(!m_x_resize.State() && 
      y>0 && y<m_y_size && x>m_treeview_width && x<m_treeview_width+3)
     {
      //--- Update the cursor coordinates and make it visible
      m_x_resize.Moving(m_mouse.X(),m_mouse.Y());
      m_x_resize.Reset();
      //--- If the mouse left button is pressed, activate the pointer
      if(m_mouse.LeftButtonState())
        {
         m_x_resize.State(true);
         m_x_resize.Update(true);
         //--- Send a message to determine the available controls
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
     }
   else
     {
      //--- If the left mouse button is released
      if(!m_mouse.LeftButtonState())
        {
         //--- Leave, if the cursor is already hidden
         if(!m_x_resize.IsVisible())
            return;
         //--- If the cursor is active
         if(m_x_resize.State())
           {
            //--- Deactivate the cursor
            m_x_resize.State(false);
            //--- Adjusting the width of list items
            RedrawTreeList();
            RedrawContentList();
            UpdateTreeList();
            UpdateContentList();
            //--- Send a message to determine the available controls
            
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
            //--- Send a message about the change in the graphical interface
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
           }
         //--- Hide the cursor
         m_x_resize.Hide();
        }
     }
  }
//+------------------------------------------------------------------+
//| Checking for exceeding the limits                                |
//+------------------------------------------------------------------+
bool CTreeView::CheckOutOfArea(const int x,const int y)
  {
//--- Limit
   int area_limit=80;
//--- If the horizontal limit of the control is exceeded ...
   if(x<area_limit || x>m_x_size-area_limit)
     {
      // ... move the pointer vertically only, without exceeding the limits
      if(y>0 && y<m_y_size)
         m_x_resize.UpdateY(m_mouse.Y());
      //--- Do not change the width of the lists
      return(false);
     }
//--- Change the width of the lists
   return(true);
  }
//+------------------------------------------------------------------+
//| Update the tree view width                                       |
//+------------------------------------------------------------------+
void CTreeView::UpdateXSize(const int x)
  {
//--- Coordinates
   int y1=1,y2=m_y_size-2;
//--- Erase the border
   m_canvas.LineVertical(m_treeview_width,y1,y2,::ColorToARGB(m_back_color));
//--- Calculate and set the width of the tree view
   m_treeview_width=x-3;
//--- Calculate and set the width of the items in the tree view, taking the scrollbars into account
   int w=(m_scrollv.IsScroll())? m_treeview_width-m_scrollv.ScrollWidth()-2 : m_treeview_width-1;
//--- Determine the scrollbar position
   int v=(m_scrollv.IsScroll())? m_scrollv.CurrentPos() : 0;
   m_scrollv.CurrentPos(v);
//--- Get the number of displayed items in the list
   int total=::ArraySize(m_td_list_index);
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Check to prevent exceeding the array range
      if(v>=0 && v<total)
        {
         //--- Get the general index of the tree view item
         int li=m_td_list_index[v];
         //--- Set the coordinates and width
         m_items[li].UpdateWidth(w);
         m_items[li].Update(true);
         v++;
        }
     }
//--- Calculate the width for items in the list
   w=(m_content_scrollv.IsScroll())? m_x_size-m_treeview_width-m_content_scrollv.ScrollWidth()-3 : m_x_size-m_treeview_width-2;
//--- Determine the scrollbar position
   v=(m_content_scrollv.IsScroll())? m_content_scrollv.CurrentPos() : 0;
   m_content_scrollv.CurrentPos(v);
//--- Get the number of items displayed in the content list
   total=::ArraySize(m_cd_list_index);
   for(int r=0; r<m_visible_items_total; r++)
     {
      //--- Check to prevent exceeding the array range
      if(v>=0 && v<total)
        {
         //--- Get the general index of the tree view item
         int li=m_cd_list_index[v];
         //--- Set the coordinates and width
         m_content_items[li].MouseFocus(false);
         m_content_items[li].UpdateWidth(w);
         m_content_items[li].UpdateX(m_treeview_width+1);
         m_content_items[li].Moving();
         m_content_items[li].Update(true);
         v++;
        }
     }
//--- Draw the border
   m_canvas.LineVertical(m_treeview_width,y1,y2,::ColorToARGB(m_border_color));
//--- Calculate and set the coordinates for the scrollbar of the tree view
   m_scrollv.XDistance(m_treeview_width-15);
//--- Update the control
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Add item to the array of the items displayed                     |
//| in the tree view                                                 |
//+------------------------------------------------------------------+
void CTreeView::AddDisplayedTreeItem(const int list_index)
  {
//--- Increase the array size by one element
   int array_size=::ArraySize(m_td_list_index);
   ::ArrayResize(m_td_list_index,array_size+1);
//--- Store the value of passed parameters
   m_td_list_index[array_size]=list_index;
  }
//+------------------------------------------------------------------+
//| Generates the tree view                                          |
//+------------------------------------------------------------------+
void CTreeView::FormTreeList(void)
  {
//--- Arrays to control the sequence of items:
   int l_prev_node_list_index[]; // general index of the list of the previous node
   int l_item_index[];           // local index of the item
   int l_items_total[];          // the number of items in a node
   int l_folders_total[];        // the number of folders in a node
//--- Define the initial size of the arrays
   int begin_size=m_max_node_level+2;
   ::ArrayResize(l_prev_node_list_index,begin_size);
   ::ArrayResize(l_item_index,begin_size);
   ::ArrayResize(l_items_total,begin_size);
   ::ArrayResize(l_folders_total,begin_size);
//--- Initialization of arrays
   ::ArrayInitialize(l_prev_node_list_index,-1);
   ::ArrayInitialize(l_item_index,-1);
   ::ArrayInitialize(l_items_total,-1);
   ::ArrayInitialize(l_folders_total,-1);
//--- Release the array of displayed tree view items
   ::ArrayFree(m_td_list_index);
//--- Counter of the local item indices
   int ii=0;
//--- To set the flag of the last item in the root directory
   bool end_list=false;
//--- Gather the displayed items to the array. The cycle will run as long as: 
//    1: the node counter is not greater than maximum;
//    2: the last item has not been reached (after checking all items nested in it);
//    3: the user did not delete the program.
   int items_total=::ArraySize(m_items);
   for(int nl=m_min_node_level; nl<=m_max_node_level && !end_list; nl++)
     {
      for(int i=0; i<items_total && !::IsStopped(); i++)
        {
         //--- If the "Show only folders" mode is enabled
         if(m_file_navigator_mode==FN_ONLY_FOLDERS)
           {
            //--- If this is a file, go to the next item
            if(!m_t_is_folder[i])
               continue;
           }
         //--- If (1) this is a different node or (2) the sequence of the local indices is not maintained,
         //    go to the next
         if(nl!=m_t_node_level[i] || m_t_item_index[i]<=l_item_index[nl])
            continue;
         //--- Go to the next point, if (1) currently not in the root directory and 
         //    (2) the general index of the list of the previous node is not equal to the one in memory
         if(nl>m_min_node_level && m_t_prev_node_list_index[i]!=l_prev_node_list_index[nl])
            continue;
         //--- Store the local item index, if the next is not less than the size of the local list
         if(m_t_item_index[i]+1>=l_items_total[nl])
            ii=m_t_item_index[i];
         //--- If the list of the current item is open
         if(m_t_item_state[i])
           {
            //--- Add the item to the array of the displayed tree view items
            AddDisplayedTreeItem(i);
            //--- Store the current values and go to the next node
            int n=nl+1;
            l_prev_node_list_index[n] =m_t_list_index[i];
            l_item_index[nl]          =m_t_item_index[i];
            l_items_total[n]          =m_t_items_total[i];
            l_folders_total[n]        =m_t_folders_total[i];
            //--- Zero the counter of the local indices of items
            ii=0;
            //--- Go to the next node
            break;
           }
         //--- Add the item to the array of the displayed tree view items
         AddDisplayedTreeItem(i);
         //--- Increase the counter of the local indices of items
         ii++;
         //--- If the last item in the root directory has been reached
         if(nl==m_min_node_level && ii>=m_root_items_total)
           {
            //--- Set the flag and complete the current cycle
            end_list=true;
            break;
           }
         //--- If the last item in the root directory has not been reached yet
         else if(nl>m_min_node_level)
           {
            //--- Get the number of items in the current node
            int total=(m_file_navigator_mode==FN_ONLY_FOLDERS)? l_folders_total[nl]: l_items_total[nl];
            //--- If this is not the last local index of the item, go to the next
            if(ii<total)
               continue;
            //--- If the last local index is reached, then 
            //    it is necessary to return to the previous node and continue from the item it left off
            while(true)
              {
               //--- Reset the values of the current node in the arrays listed below
               l_prev_node_list_index[nl] =-1;
               l_item_index[nl]           =-1;
               l_items_total[nl]          =-1;
               //--- Decrease the node counter, while the equality in the number of items in the local lists is preserved 
               //    or until the root directory is reached
               if(l_item_index[nl-1]+1>=l_items_total[nl-1])
                 {
                  if(nl-1==m_min_node_level)
                     break;
                  //---
                  nl--;
                  continue;
                 }
               //---
               break;
              }
            //--- Go to the previous node
            nl=nl-2;
            //--- Zero the counter of the local indices of items and go to the next node
            ii=0;
            break;
           }
        }
     }
//--- Redraw the list
   RedrawTreeList();
  }
//+------------------------------------------------------------------+
//| Generates a content list                                         |
//+------------------------------------------------------------------+
void CTreeView::FormContentList(void)
  {
//--- Index of the selected item
   int li=m_selected_item_index;
//--- Release the content list arrays
   ::ArrayFree(m_cd_item_text);
   ::ArrayFree(m_cd_list_index);
   ::ArrayFree(m_cd_tree_list_index);
//--- Generate a content list
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
     {
      //--- If the (1) node levels and (2) local indices of the items, and also
      //    (3) the index of the previous node match the index of the selected item
      if(m_t_node_level[i]==m_t_node_level[li]+1 && 
         m_t_prev_node_item_index[i]==m_t_item_index[li] &&
         m_t_prev_node_list_index[i]==li)
        {
         //--- Increase the arrays of the displayed content list items
         int size     =::ArraySize(m_cd_list_index);
         int new_size =size+1;
         ::ArrayResize(m_cd_item_text,new_size);
         ::ArrayResize(m_cd_list_index,new_size);
         ::ArrayResize(m_cd_tree_list_index,new_size);
         //--- Store the item text and the general index of the tree view to the arrays
         m_cd_item_text[size]       =m_t_item_text[i];
         m_cd_tree_list_index[size] =m_t_list_index[i];
        }
     }
//--- If the resulting list is not empty, fill the array of general indices of the content list
   int cd_items_total=::ArraySize(m_cd_list_index);
   if(cd_items_total>0)
     {
      //--- Item counter
      int c=0;
      //--- Iterate over the list
      int c_items_total=::ArraySize(m_c_list_index);
      for(int i=0; i<c_items_total; i++)
        {
         //--- If the description and general indices of the tree view items match
         if(m_c_item_text[i]==m_cd_item_text[c] && 
            m_c_tree_list_index[i]==m_cd_tree_list_index[c])
           {
            //--- Store the general content list index and go to the next
            m_cd_list_index[c]=m_c_list_index[i];
            c++;
            //--- Leave the cycle, if reached the end of the displayed list
            if(c>=cd_items_total)
               break;
           }
        }
     }
//--- Redraw the list
   RedrawContentList();
  }
//+------------------------------------------------------------------+
//| Redraw the list                                                  |
//+------------------------------------------------------------------+
void CTreeView::RedrawTreeList(void)
  {
//--- Hide the list items
   int items_total=::ArraySize(m_items);
   for(int i=0; i<items_total; i++)
      m_items[i].Hide();
//--- Hide the scrollbar
   m_scrollv.Hide();
//--- The Y coordinate of the first item of the tree view
   int y=1;
//--- Get the number of items
   m_items_total=::ArraySize(m_td_list_index);
//--- Adjust the size of the scrollbar
   m_scrollv.Reinit(m_items_total,m_visible_items_total);
   m_scrollv.ChangeYSize(m_y_size-2);
   m_scrollv.Update(true);
//--- Calculating the width of the tree view items
   int w=0;
   if(m_show_item_content)
      w=(m_scrollv.IsScroll()) ? m_treeview_width-m_scrollv.ScrollWidth()-2 : m_treeview_width-1;
   else
      w=(m_scrollv.IsScroll()) ? m_treeview_width-m_scrollv.ScrollWidth()-3 : m_treeview_width-2;
//--- Set new values
   for(int i=0; i<m_items_total; i++)
     {
      //--- Calculate the Y coordinate for each item
      y=(i>0)? y+m_item_y_size : y;
      //--- Get the general index of the list item
      int li=m_td_list_index[i];
      //--- Update coordinates and sizes
      m_items[li].UpdateY(y);
      m_items[li].UpdateWidth(w);
     }
//--- Show the list items
   for(int i=0; i<items_total; i++)
      m_items[i].Show();
//--- Update coordinates and size of the list
   ShiftTreeList();
  }
//+------------------------------------------------------------------+
//| Redraw the content list                                          |
//+------------------------------------------------------------------+
void CTreeView::RedrawContentList(void)
  {
//--- Leave, if (1) showing the item content is not needed or (2) the tab mode is enabled
   if(!m_show_item_content || m_tab_items_mode)
      return;
//--- The number of items in the list
   int content_items_total=::ArraySize(m_content_items);
//--- If the control is not hidden, hide the list items
   if(CElementBase::IsVisible())
     {
      for(int i=0; i<content_items_total; i++)
         m_content_items[i].Hide();
      //--- Hide the scrollbar
      m_content_scrollv.Hide();
     }
//--- The Y coordinate of the first item of the tree view
   int y=1;
//--- Get the number of items
   int items_total=::ArraySize(m_cd_list_index);
//--- Adjust the size of the scrollbar
   m_content_scrollv.Reinit(items_total,m_visible_items_total);
   m_content_scrollv.ChangeYSize(m_y_size-2);
   m_content_scrollv.Update(true);
//--- Calculating the width of the tree view items
   int w=(m_content_scrollv.IsScroll()) ? m_x_size-m_treeview_width-m_scrollv.ScrollWidth()-3 : m_x_size-m_treeview_width-2;
//--- Set new values
   for(int i=0; i<items_total; i++)
     {
      //--- Calculate the Y coordinate for each item
      y=(i>0)? y+m_item_y_size : y;
      //--- Get the general index of the list item
      int li=m_cd_list_index[i];
      //--- Update coordinates and sizes
      m_content_items[li].UpdateY(y);
      m_content_items[li].UpdateWidth(w);
     }
//--- If the control is not hidden, show the list items
   if(CElementBase::IsVisible())
     {
      for(int i=0; i<content_items_total; i++)
         m_content_items[i].Show();
     }
//--- Update coordinates and size of the list
   ShiftContentList();
  }
//+------------------------------------------------------------------+
//| Updates the list                                                 |
//+------------------------------------------------------------------+
void CTreeView::UpdateTreeList(void)
  {
   int items_total=::ArraySize(m_td_list_index);
   for(int i=0; i<items_total; i++)
     {
      //--- Get the general index of the list item
      int li=m_td_list_index[i];
      //--- Update
      m_items[li].Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Update the content list                                          |
//+------------------------------------------------------------------+
void CTreeView::UpdateContentList(void)
  {
   int items_total=::ArraySize(m_cd_list_index);
   for(int i=0; i<items_total; i++)
     {
      //--- Get the general index of the list item
      int li=m_cd_list_index[i];
      //--- Update
      m_content_items[li].Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Checking for index of the selected item exceeding array range    |
//+------------------------------------------------------------------+
void CTreeView::CheckSelectedItemIndex(void)
  {
//--- If the index is not defined
   if(m_selected_item_index==WRONG_VALUE)
     {
      //--- The first list item will be selected
      m_selected_item_index=0;
      return;
     }
//--- Checking for exceeding the array range
   int array_size=::ArraySize(m_items);
   if(array_size<1 || m_selected_item_index<0 || m_selected_item_index>=array_size)
     {
      //--- The first list item will be selected
      m_selected_item_index=0;
      return;
     }
  }
//+------------------------------------------------------------------+
//| Draws the border between areas                                   |
//+------------------------------------------------------------------+
void CTreeView::DrawResizeBorder(void)
  {
//--- Leave, if the mode is disabled
   if(!m_show_item_content)
      return;
//--- Coordinates
   int x=m_treeview_width;
   int y1=0,y2=m_y_size;
//--- Draw a line
   m_canvas.LineVertical(x,y1,y2,::ColorToARGB(m_border_color));
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CTreeView::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Coordinates and width
   int x=0,w=0;
//--- Size
   int x_size =m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Set the new size
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,y_size);
//--- If there is no content list
   if(!m_show_item_content)
     {
      //--- Calculate and set the width for items in the list
      w=(m_scrollv.IsScroll())? CElementBase::XSize()-m_scrollv.ScrollWidth()-3 : CElementBase::XSize()-2;
      //---
      int v=(m_scrollv.IsScroll())? m_scrollv.CurrentPos() : 0;
      //--- Get the number of items displayed in the content list
      int total=::ArraySize(m_td_list_index);
      for(int r=0; r<m_visible_items_total; r++)
        {
         //--- Check to prevent exceeding the array range
         if(v>=0 && v<total)
           {
            //--- Get the general index of the tree view item
            int li=m_td_list_index[v];
            //--- Set the coordinates and width
            m_items[li].UpdateWidth(w);
            m_items[li].Draw();
            v++;
           }
        }
     }
//--- If there is a content list
   else
     {
      w=(m_content_scrollv.IsScroll())? m_x_size-m_treeview_width-m_content_scrollv.ScrollWidth()-2 : m_x_size-m_treeview_width-2;
      //---
      int v=(m_content_scrollv.IsScroll())? m_content_scrollv.CurrentPos() : 0;
      //--- Get the number of items displayed in the content list
      int total=::ArraySize(m_cd_list_index);
      for(int r=0; r<m_visible_items_total; r++)
        {
         //--- Check to prevent exceeding the array range
         if(v>=0 && v<total)
           {
            //--- Get the general index of the tree view item
            int li=m_cd_list_index[v];
            //--- Set the coordinates and width
            m_content_items[li].UpdateWidth(w);
            m_content_items[li].Draw();
            v++;
           }
        }
     }
//--- Redraw the control
   Draw();
  }
//+------------------------------------------------------------------+
