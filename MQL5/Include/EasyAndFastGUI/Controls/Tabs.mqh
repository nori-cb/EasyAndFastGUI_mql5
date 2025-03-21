//+------------------------------------------------------------------+
//|                                                         Tabs.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "ButtonsGroup.mqh"
//+------------------------------------------------------------------+
//| Class for creating tabs                                          |
//+------------------------------------------------------------------+
class CTabs : public CElement
  {
private:
   //--- Instances for creating a control
   CButtonsGroup     m_tabs;
   //--- Structure of properties and arrays of the controls attached to each tab
   struct TElements
     {
      CElement         *elements[];
     };
   TElements         m_tab[];
   //--- Positioning of tabs
   ENUM_TABS_POSITION m_position_mode;
   //--- Size of the tabs along the Y axis
   int               m_tab_y_size;
   //--- Index of the selected tab
   int               m_selected_tab;
   //---
public:
                     CTabs(void);
                    ~CTabs(void);
   //--- Methods for creating the tabs
   bool              CreateTabs(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButtons(void);
   //---
public:
   //--- Returns the pointer to the group of buttons 
   CButtonsGroup    *GetButtonsGroupPointer(void) { return(::GetPointer(m_tabs)); }
   //--- (1) returns the number of tabs, 
   //--- (2) Set/set the tab positions (top/bottom/left/right), (3) set the tab size along the Y axis
   int               TabsTotal(void)                           const { return(m_tabs.ButtonsTotal()); }
   void              PositionMode(const ENUM_TABS_POSITION mode)     { m_position_mode=mode;          }
   ENUM_TABS_POSITION PositionMode(void)                       const { return(m_position_mode);       }
   void              TabsYSize(const int y_size);
   //--- (1) Store and (2) return index of the selected tab
   void              SelectedTab(const int index)                    { m_selected_tab=index;          }
   int               SelectedTab(void)                         const { return(m_selected_tab);        }
   //--- Set the text by the specified index
   void              Text(const uint index,const string text);
   //--- Select the specified tab
   void              SelectTab(const int index);
   //--- Adds a tab
   void              AddTab(const string tab_text="",const int tab_width=50);
   //--- Add control to the tab array
   void              AddToElementsArray(const int tab_index,CElement &object);
   //--- Show controls of the selected tab only
   void              ShowTabElements(void);
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
   //--- Handling the pressing on tab
   bool              OnClickTab(const int id,const int index);
   //--- Width of all tabs
   int               SumWidthTabs(void);
   //--- Check index of the selected tab
   void              CheckTabIndex();

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Change the height at the bottom edge of the window
   virtual void      ChangeHeightByBottomWindowSide(void);

   //--- Draws the background of the area of controls
   void              DrawMainArea(void);
   //--- Draws the tab label
   void              DrawPatch();
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTabs::CTabs(void) : m_tab_y_size(22),
                     m_position_mode(TABS_TOP),
                     m_selected_tab(WRONG_VALUE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Height of the tabs
   m_tabs.ButtonYSize(m_tab_y_size);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTabs::~CTabs(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CTabs::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_GROUP_BUTTON)
     {
      //--- Pressing a tab
      if(OnClickTab((int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create Tabs control                                              |
//+------------------------------------------------------------------+
bool CTabs::CreateTabs(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- If there is no tab in the group, report
   if(TabsTotal()<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if a group contains at least one tab! Use the CTabs::AddTab() method");
      return(false);
     }
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create control
   if(!CreateButtons())
      return(false);
   if(!CreateCanvas())
      return(false);
//--- 
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTabs::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
//--- Default background color
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrWhiteSmoke;
   m_back_color_hover   =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'229,241,251';
   m_back_color_pressed =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : clrWhite;
//--- Default border color
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : C'217,217,217';
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : m_border_color;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : m_border_color;
//--- Margins and color of the text label
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Priority same as parent's
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CTabs::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("tabs");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create group of buttons                                          |
//+------------------------------------------------------------------+
bool CTabs::CreateButtons(void)
  {
   int x=0,y=0;
//--- Get the number of tabs
   int tabs_total=TabsTotal();
//--- If there are no tabs in the group, report and leave
   if(tabs_total<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if a group contains at least one tab! Use the CTabs::AddTabs() method");
      return(false);
     }
//--- Store the pointer to the main control
   m_tabs.MainPointer(this);
//--- Calculating coordinates relative to positioning of tabs
   if(m_position_mode==TABS_TOP)
     {
      y=-m_tab_y_size+1;
     }
   else if(m_position_mode==TABS_BOTTOM)
     {
      y=1;
      m_tabs.AnchorBottomWindowSide(true);
     }
   else if(m_position_mode==TABS_RIGHT)
     {
      x=1;
      m_tabs.AnchorRightWindowSide(true);
     }
   else if(m_position_mode==TABS_LEFT)
     {
      x=-SumWidthTabs()+1;
     }
//--- Check index of the selected tab
   CheckTabIndex();
//--- Properties
   m_tabs.NamePart("tab");
   m_tabs.RadioButtonsMode(true);
   m_tabs.IsCenterText(CElement::IsCenterText());
//--- Create a group of buttons
   if(!m_tabs.CreateButtonsGroup(x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_tabs);
//---
   for(int i=0; i<tabs_total; i++)
     {
      m_tabs.GetButtonPointer(i).LabelYGap(2);
      m_tabs.GetButtonPointer(i).BackColor(m_back_color);
      m_tabs.GetButtonPointer(i).BackColorHover(m_back_color_hover);
      m_tabs.GetButtonPointer(i).BackColorPressed(m_back_color_pressed);
      m_tabs.GetButtonPointer(i).BorderColor(m_border_color);
      m_tabs.GetButtonPointer(i).BorderColorHover(m_border_color);
      m_tabs.GetButtonPointer(i).BorderColorPressed(m_border_color);
      m_tabs.GetButtonPointer(i).BorderColorLocked(m_border_color);
     }
//---
   m_back_color=m_back_color_pressed;
//--- Select the button
   m_tabs.SelectButton(m_selected_tab);
   return(true);
  }
//+------------------------------------------------------------------+
//| Sets the height of tabs                                          |
//+------------------------------------------------------------------+
void CTabs::TabsYSize(const int y_size)
  {
   m_tab_y_size=y_size;
   m_tabs.ButtonYSize(y_size);
  }
//+------------------------------------------------------------------+
//| Sets the tab text                                                |
//+------------------------------------------------------------------+
void CTabs::Text(const uint index,const string text)
  {
//--- Get the number of tabs
   uint tabs_total=TabsTotal();
//--- Leave, if there is no tab in a group
   if(tabs_total<1)
      return;
//--- Adjust the index value if the array range is exceeded
   uint correct_index=(index>=tabs_total)? tabs_total-1 : index;
//--- Set the text
   m_tabs.GetButtonPointer(correct_index).LabelText(text);
  }
//+------------------------------------------------------------------+
//| Select the tab                                                   |
//+------------------------------------------------------------------+
void CTabs::SelectTab(const int index)
  {
//--- Get the number of tabs
   uint tabs_total=TabsTotal();
   for(uint i=0; i<tabs_total; i++)
     {
      //--- If this tab is clicked
      if(index==i)
        {
         //--- Store index of the selected tab
         SelectedTab(index);
         //---
         m_tabs.SelectButton(index);
        }
     }
//--- Show controls of the selected tab only
   ShowTabElements();
  }
//+------------------------------------------------------------------+
//| Add a tab                                                        |
//+------------------------------------------------------------------+
void CTabs::AddTab(const string tab_text,const int tab_width)
  {
//--- Reserve count
   int reserve=10;
//--- Set the size of tab arrays
   int array_size=::ArraySize(m_tab);
   ::ArrayResize(m_tab,array_size+1,reserve);
//--- Coordinates
   int x=0,y=0;
   if(array_size>0)
     {
      if(m_position_mode==TABS_TOP || m_position_mode==TABS_BOTTOM)
         x=SumWidthTabs()-tab_width;
      else
         y=((array_size*m_tab_y_size)+m_tab_y_size)-m_tab_y_size-array_size;
     }
//--- Add button to the group
   m_tabs.AddButton(x,y,tab_text,tab_width,m_back_color,m_back_color_hover,m_back_color_pressed);
  }
//+------------------------------------------------------------------+
//| Add control to the array of the specified tab                    |
//+------------------------------------------------------------------+
void CTabs::AddToElementsArray(const int tab_index,CElement &object)
  {
//--- Checking for exceeding the array range
   int array_size=::ArraySize(m_tab);
   if(array_size<1 || tab_index<0 || tab_index>=array_size)
      return;
//--- Add pointer of the passed control to array of the specified tab
   int size=::ArraySize(m_tab[tab_index].elements);
   ::ArrayResize(m_tab[tab_index].elements,size+1);
   m_tab[tab_index].elements[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Show controls of the selected tab only                           |
//+------------------------------------------------------------------+
void CTabs::ShowTabElements(void)
  {
//--- Leave, if the tabs are hidden
   if(!CElementBase::IsVisible())
      return;
//--- Check index of the selected tab
   CheckTabIndex();
//---
   uint tabs_total=TabsTotal();
   for(uint i=0; i<tabs_total; i++)
     {
      //--- Get the number of controls attached to the tab
      int tab_elements_total=::ArraySize(m_tab[i].elements);
      //--- If this tab is selected
      if(i==m_selected_tab)
        {
         //--- Display the tab controls
         for(int j=0; j<tab_elements_total; j++)
           {
            //--- Display the controls
            CElement *el=m_tab[i].elements[j];
            el.Reset();
            //--- If this is the Tabs control, show the controls of the opened one
            CTabs *tb=dynamic_cast<CTabs*>(el);
            if(tb!=NULL)
               tb.ShowTabElements();
           }
        }
      //--- Hide the controls of inactive tabs
      else
        {
         for(int j=0; j<tab_elements_total; j++)
            m_tab[i].elements[j].Hide();
        }
     }
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_TAB,CElementBase::Id(),m_selected_tab,"");
  }
//+------------------------------------------------------------------+
//| Showing                                                          |
//+------------------------------------------------------------------+
void CTabs::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving();
//--- Display the controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
     {
      if(!m_elements[i].IsDropdown())
         m_elements[i].Show();
     }
//--- Show the object (must be on top of the button group)
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
  }
//+------------------------------------------------------------------+
//| Hide                                                             |
//+------------------------------------------------------------------+
void CTabs::Hide(void)
  {
//--- Leave, if the control is already hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide the object
   m_canvas.Timeframes(OBJ_NO_PERIODS);
//--- Visible state
   CElementBase::IsVisible(false);
   CElementBase::MouseFocus(false);
//--- Hide the controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Hide();
//--- Hide the controls of the tabs
   int tabs_total=TabsTotal();
   for(int i=0; i<tabs_total; i++)
     {
      int tab_elements_total=::ArraySize(m_tab[i].elements);
      for(int t=0; t<tab_elements_total; t++)
         m_tab[i].elements[t].Hide();
     }
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CTabs::Delete(void)
  {
   CElement::Delete();
//--- Emptying the control arrays
   uint tabs_total=TabsTotal();
   for(uint i=0; i<tabs_total; i++)
      ::ArrayFree(m_tab[i].elements);
//--- 
   ::ArrayFree(m_tab);
   m_back_color=clrNONE;
  }
//+------------------------------------------------------------------+
//| Pressing a tab in a group                                        |
//+------------------------------------------------------------------+
bool CTabs::OnClickTab(const int id,const int index)
  {
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Leave, if the index does not match
   if(index!=m_tabs.SelectedButtonIndex())
      return(true);
//--- Store index of the selected tab
   SelectedTab(index);
//--- Redraw the control
   m_canvas.Timeframes(OBJ_NO_PERIODS);
   Update(true);
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Show controls of the selected tab only
   ShowTabElements();
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Total width of all tabs                                          |
//+------------------------------------------------------------------+
int CTabs::SumWidthTabs(void)
  {
   int width=0;
//--- If tabs are positioned right or left, return the width of the first tab
   if(m_position_mode==TABS_LEFT || m_position_mode==TABS_RIGHT)
      return(m_tabs.GetButtonPointer(0).XSize());
//--- Sum the width of all tabs
   int tabs_total=::ArraySize(m_tab);
   for(int i=0; i<tabs_total; i++)
      width=width+m_tabs.GetButtonPointer(i).XSize();
//--- With consideration of one pixel overlay
   width=width-(tabs_total-1);
   return(width);
  }
//+------------------------------------------------------------------+
//| Check index of the selected tab                                  |
//+------------------------------------------------------------------+
void CTabs::CheckTabIndex(void)
  {
//--- Checking for exceeding the array range
   int array_size=::ArraySize(m_tab);
   if(m_selected_tab<0)
      m_selected_tab=0;
   if(m_selected_tab>=array_size)
      m_selected_tab=array_size-1;
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CTabs::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if anchoring mode to the right side of the window is enabled
   if(m_anchor_right_window_side)
      return;
//--- Size
   int x_size=0;
//--- Calculate and set the new size to the control background
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Redraw the control
   Draw();
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Change the height at the bottom edge of the window               |
//+------------------------------------------------------------------+
void CTabs::ChangeHeightByBottomWindowSide(void)
  {
//--- Leave, if anchoring mode to the bottom side of the window is enabled
   if(m_anchor_bottom_window_side)
      return;
//--- Size
   int y_size=0;
//--- Calculate and set the new size to the control background
   y_size=m_main.Y2()-m_canvas.Y()-m_auto_yresize_bottom_offset;
   CElementBase::YSize(y_size);
   m_canvas.YSize(y_size);
   m_canvas.Resize(m_x_size,y_size);
//--- Redraw the control
   Draw();
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTabs::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
//--- Draw the label of the selected tab
   DrawPatch();
  }
//+------------------------------------------------------------------+
//| Draws the tab label                                              |
//+------------------------------------------------------------------+
void CTabs::DrawPatch(void)
  {
//--- Coordinates
   int x1 =0,x2 =0;
   int y1 =0,y2 =0;
//---
   if(m_position_mode==TABS_TOP)
     {
      x1 =m_tabs.GetButtonPointer(m_selected_tab).XGap()+1;
      x2 =x1+m_tabs.GetButtonPointer(m_selected_tab).XSize()-2;
     }
   else if(m_position_mode==TABS_BOTTOM)
     {
      x1 =m_tabs.GetButtonPointer(m_selected_tab).XGap()+1;
      x2 =x1+m_tabs.GetButtonPointer(m_selected_tab).XSize()-2;
      y1 =YSize()-1;
      y2 =y1;
     }
   else if(m_position_mode==TABS_LEFT)
     {
      y1 =m_tabs.GetButtonPointer(m_selected_tab).YGap()+1;
      y2 =y1+m_tabs.GetButtonPointer(m_selected_tab).YSize()-3;
     }
   else if(m_position_mode==TABS_RIGHT)
     {
      x1 =XSize()-1;
      x2 =x1;
      y1 =m_tabs.GetButtonPointer(m_selected_tab).YGap()+1;
      y2 =y1+m_tabs.GetButtonPointer(m_selected_tab).YSize()-3;
     }
//---
   m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_back_color,m_alpha));
  }
//+------------------------------------------------------------------+
