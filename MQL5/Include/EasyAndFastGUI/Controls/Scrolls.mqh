//+------------------------------------------------------------------+
//|                                                      Scrolls.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Button.mqh"
//--- List of classes in file for quick navigation (Alt+G)
class CScroll;
class CScrollV;
class CScrollH;
//+------------------------------------------------------------------+
//| Base class for creating the scrollbar                            |
//+------------------------------------------------------------------+
class CScroll : public CElement
  {
protected:
   //--- Objects for creating the scrollbar
   CButton           m_button_inc;
   CButton           m_button_dec;
   //--- Properties of the general area of the scrollbar
   int               m_area_width;
   int               m_area_length;
   //--- Button icons
   string            m_inc_file;
   string            m_inc_file_locked;
   string            m_inc_file_pressed;
   string            m_dec_file;
   string            m_dec_file_locked;
   string            m_dec_file_pressed;
   //--- (1) Focus on the thumb and (2) the moment of its border crossing
   bool              m_thumb_focus;
   bool              m_is_crossing_thumb_border;
   //--- Colors of the thumb in different states
   color             m_thumb_color;
   color             m_thumb_color_hover;
   color             m_thumb_color_pressed;
   //--- (1) Total number of items and (2) visible
   int               m_items_total;
   int               m_visible_items_total;
   //--- Coordinates of the thumb
   int               m_thumb_x;
   int               m_thumb_y;
   //--- (1) Width of the thumb, (2) length of the slider (3) and its minimal length
   int               m_thumb_width;
   int               m_thumb_length;
   int               m_thumb_min_length;
   //--- (1) Step of the thumb and (2) the number of steps
   double            m_thumb_step_size;
   double            m_thumb_steps_total;
   //--- Variables connected with the thumb movement
   bool              m_scroll_state;
   int               m_thumb_size_fixing;
   int               m_thumb_point_fixing;
   //--- Current location of the thumb
   int               m_current_pos;
   //--- To identify the area of pressing down the left mouse button
   ENUM_MOUSE_STATE  m_clamping_area_mouse;
   //---
public:
                     CScroll(void);
                    ~CScroll(void);
   //--- Methods for creating the scrollbar
   bool              CreateScroll(const int x_gap,const int y_gap,
                                  const int items_total,const int visible_items_total);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap,
                                          const int items_total,const int visible_items_total);
   bool              CreateCanvas(void);
   bool              CreateScrollButton(CButton &button_obj,const int index);
   //---
public:
   //--- Returns pointers to the scrollbar buttons
   CButton          *GetIncButtonPointer(void)                { return(::GetPointer(m_button_inc)); }
   CButton          *GetDecButtonPointer(void)                { return(::GetPointer(m_button_dec)); }
   //--- Width of the scrollbar
   void              ScrollWidth(const int width)             { m_area_width=width;                 }
   int               ScrollWidth(void)                  const { return(m_area_width);               }
   //--- Setting icons for buttons
   void              IncFile(const string file_path)          { m_inc_file=file_path;               }
   void              IncFileLocked(const string file_path)    { m_inc_file_locked=file_path;        }
   void              IncFilePressed(const string file_path)   { m_inc_file_pressed=file_path;       }
   void              DecFile(const string file_path)          { m_dec_file=file_path;               }
   void              DecFileLocked(const string file_path)    { m_dec_file_locked=file_path;        }
   void              DecFilePressed(const string file_path)   { m_dec_file_pressed=file_path;       }
   //--- (1) Colors of the thumb and (2) the thumb border
   void              ThumbColor(const color clr)              { m_thumb_color=clr;                  }
   void              ThumbColorHover(const color clr)         { m_thumb_color_hover=clr;            }
   void              ThumbColorPressed(const color clr)       { m_thumb_color_pressed=clr;          }
   //--- State of buttons
   bool              ScrollIncState(void)               const { return(m_button_inc.IsPressed());   }
   bool              ScrollDecState(void)               const { return(m_button_dec.IsPressed());   }
   //--- State of the scrollbar (free/moving the slider)
   void              State(const bool scroll_state)           { m_scroll_state=scroll_state;        }
   bool              State(void)                        const { return(m_scroll_state);             }
   //--- Current location of the thumb
   void              CurrentPos(const int pos)                { m_current_pos=pos;                  }
   int               CurrentPos(void)                   const { return(m_current_pos);              }
   //--- Initialize with the new values
   void              Reinit(const int items_total,const int visible_items_total);
   //--- Change the size of the slider on new conditions
   void              ChangeThumbSize(const int items_total,const int visible_items_total);
   //--- The necessity to show the scrollbar
   bool              IsScroll(void) const { return(m_items_total>m_visible_items_total); }
   //---
protected:
   //--- Current color of the thumb
   uint              ThumbColorCurrent(void);
   //--- Checking the focus over the scrollbar
   bool              CheckThumbFocus(const int x,const int y);
   //--- Identifies the area of pressing down the left mouse button
   void              CheckMouseButtonState(void);
   //--- Zeroing variables
   void              ZeroThumbVariables(void);
   //--- Calculation of the length of the scrollbar thumb
   bool              CalculateThumbSize(void);
   //--- Calculation of the boundaries of the scrollbar thumb
   void              CalculateThumbBoundaries(int &x1,int &y1,int &x2,int &y2);
   //---
public:
   //--- Management
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Draws the background
   virtual void      DrawThumb(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScroll::CScroll(void) : m_current_pos(0),
                         m_area_width(15),
                         m_area_length(0),
                         m_inc_file(""),
                         m_inc_file_locked(""),
                         m_inc_file_pressed(""),
                         m_dec_file(""),
                         m_dec_file_locked(""),
                         m_dec_file_pressed(""),
                         m_thumb_focus(false),
                         m_is_crossing_thumb_border(false),
                         m_thumb_x(0),
                         m_thumb_y(0),
                         m_thumb_width(0),
                         m_thumb_length(0),
                         m_thumb_min_length(15),
                         m_thumb_size_fixing(0),
                         m_thumb_point_fixing(0),
                         m_thumb_color(C'205,205,205'),
                         m_thumb_color_hover(C'166,166,166'),
                         m_thumb_color_pressed(C'96,96,96')
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScroll::~CScroll(void)
  {
  }
//+------------------------------------------------------------------+
//| Creates the scrollbar                                            |
//+------------------------------------------------------------------+
bool CScroll::CreateScroll(const int x_gap,const int y_gap,const int items_total,const int visible_items_total)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Leave, if there is an attempt to use the base class of the scrollbar
   if(CElementBase::ClassName()=="")
     {
      ::Print(__FUNCTION__," > Use derived classes of the scrollbar (CScrollV or CScrollH).");
      return(false);
     }
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap,items_total,visible_items_total);
//--- Create control 
   if(!CreateCanvas())
      return(false);
   if(!CreateScrollButton(m_button_inc,0))
      return(false);
   if(!CreateScrollButton(m_button_dec,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CScroll::InitializeProperties(const int x_gap,const int y_gap,
                                   const int items_total,const int visible_items_total)
  {
   m_x                   =CElement::CalculateX(x_gap);
   m_y                   =CElement::CalculateY(y_gap);
   m_area_width          =(CElementBase::ClassName()=="CScrollV")? CElementBase::XSize() : CElementBase::YSize();
   m_area_length         =(CElementBase::ClassName()=="CScrollV")? CElementBase::YSize() : CElementBase::XSize();
   m_items_total         =(items_total<1)? 1 : items_total;
   m_visible_items_total =(visible_items_total>0)? visible_items_total : 1;
   m_thumb_width         =m_area_width;
   m_thumb_steps_total   =(IsScroll())? m_items_total-m_visible_items_total : 1;
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : C'240,240,240';
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Calculate the size of the scrollbar
   CalculateThumbSize();
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CScroll::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName((CElementBase::ClassName()=="CScrollV")? "scrollv" : "scrollh");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create scrollbar spin up or left                                 |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_up_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_up_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_left_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_left_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_down_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_down_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_right_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\scroll_right_white.bmp"
//---
bool CScroll::CreateScrollButton(CButton &button_obj,const int index)
  {
//--- Store the pointer to the main control
   button_obj.MainPointer(this);
//--- Coordinates
   int x=0,y=0;
//--- Files
   string file="",file_locked="",file_pressed="";
//--- Up or down button
   if(index==0)
     {
      //--- Setting properties considering the scrollbar type
      if(CElementBase::ClassName()=="CScrollV")
        {
         file=(m_inc_file=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_up_black.bmp" : m_inc_file;
         file_locked=(m_inc_file_locked=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_up_black.bmp" : m_inc_file_locked;
         file_pressed=(m_inc_file_pressed=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_up_white.bmp" : m_inc_file_pressed;
        }
      else
        {
         file=(m_inc_file=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_left_black.bmp" : m_inc_file;
         file_locked=(m_inc_file_locked=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_left_black.bmp" : m_inc_file_locked;
         file_pressed=(m_inc_file_pressed=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_left_white.bmp" : m_inc_file_pressed;
        }
      //--- Index of the control
      button_obj.Index(m_index*2);
     }
//--- Down or right button
   else
     {
      //--- Setting properties considering the scrollbar type
      if(CElementBase::ClassName()=="CScrollV")
        {
         x=0; y=m_thumb_width;
         file=(m_dec_file=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_down_black.bmp" : m_dec_file;
         file_locked=(m_dec_file_locked=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_down_black.bmp" : m_dec_file_locked;
         file_pressed=(m_dec_file_pressed=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_down_white.bmp" : m_dec_file_pressed;
         button_obj.AnchorBottomWindowSide(true);
        }
      else
        {
         x=m_thumb_width; y=0;
         file=(m_dec_file=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_right_black.bmp" : m_dec_file;
         file_locked=(m_dec_file_locked=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_right_black.bmp" : m_dec_file_locked;
         file_pressed=(m_dec_file_pressed=="")? "Images\\EasyAndFastGUI\\Controls\\scroll_right_white.bmp" : m_dec_file_pressed;
         button_obj.AnchorRightWindowSide(true);
        }
      //--- Index of the control
      button_obj.Index(m_index*2+1);
     }
//--- Properties
   button_obj.NamePart("scroll_button");
   button_obj.Alpha(m_alpha);
   button_obj.XSize(15);
   button_obj.YSize(15);
   button_obj.IconXGap(0);
   button_obj.IconYGap(0);
   button_obj.TwoState(true);
   button_obj.BackColor(m_back_color);
   button_obj.BackColorHover(C'218,218,218');
   button_obj.BackColorLocked(clrLightGray);
   button_obj.BackColorPressed(m_thumb_color_pressed);
   button_obj.BorderColor(m_back_color);
   button_obj.BorderColorHover(C'218,218,218');
   button_obj.BorderColorLocked(clrLightGray);
   button_obj.BorderColorPressed(m_thumb_color_pressed);
   button_obj.IconFile(file);
   button_obj.IconFileLocked(file_locked);
   button_obj.IconFilePressed(file_pressed);
   button_obj.IconFilePressedLocked(file_locked);
   button_obj.IsDropdown(CElementBase::IsDropdown());
//--- Create a control
   if(!button_obj.CreateButton("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(button_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Current color of the thumb                                       |
//+------------------------------------------------------------------+
uint CScroll::ThumbColorCurrent(void)
  {
//--- Determine the color of the thumb
   color clr=(m_scroll_state)? m_thumb_color_pressed : m_thumb_color;
//--- If the mouse cursor is in the scrollbar thumb area
   if(m_thumb_focus)
     {
      //--- If the left mouse button is released
      if(m_clamping_area_mouse==NOT_PRESSED)
         clr=m_thumb_color_hover;
      //--- The left mouse button is pressed down on the slider
      else if(m_clamping_area_mouse==PRESSED_INSIDE)
         clr=m_thumb_color_pressed;
     }
//--- If the cursor is outside of the scrollbar area
   else
     {
      //--- Left mouse button is released
      if(m_clamping_area_mouse==NOT_PRESSED)
         clr=m_thumb_color;
     }
//---
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Checking the focus over the scrollbar                            |
//+------------------------------------------------------------------+
bool CScroll::CheckThumbFocus(const int x,const int y)
  {
//--- Checking the focus over the scrollbar
   if(CElementBase::ClassName()=="CScrollV")
     {
      m_thumb_focus=(x>m_thumb_x && x<m_thumb_x+m_thumb_width && 
                     y>m_thumb_y && y<m_thumb_y+m_thumb_length);
     }
   else
     {
      m_thumb_focus=(x>m_thumb_x && x<m_thumb_x+m_thumb_length && 
                     y>m_thumb_y && y<m_thumb_y+m_thumb_width);
     }
//--- If this is the moment of crossing the borders of the control
   if((m_thumb_focus && !m_is_crossing_thumb_border) || (!m_thumb_focus && m_is_crossing_thumb_border))
     {
      m_is_crossing_thumb_border=m_thumb_focus;
      //---
      if(!CScroll::State())
        {
         int x1=0,y1=0,x2=0,y2=0;
         CalculateThumbBoundaries(x1,y1,x2,y2);
         //--- Draw a filled rectangle
         m_canvas.FillRectangle(x1,y1,x2-1,y2-1,ThumbColorCurrent());
         m_canvas.Update();
        }
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Identifies the area of pressing the left mouse button            |
//+------------------------------------------------------------------+
void CScroll::CheckMouseButtonState(void)
  {
//--- If the left mouse button is released
   if(!m_mouse.LeftButtonState())
     {
      //--- Zero out variables
      ZeroThumbVariables();
      return;
     }
//--- If the button is pressed
   else
     {
      //--- Leave, if the button is pressed down in another area
      if(m_clamping_area_mouse!=NOT_PRESSED)
         return;
      //--- Outside of the slider area
      if(!m_thumb_focus)
         m_clamping_area_mouse=PRESSED_OUTSIDE;
      //--- Inside the slider area
      else
        {
         m_scroll_state        =true;
         m_clamping_area_mouse =PRESSED_INSIDE;
         //--- Redraw the control
         Update(true);
         //--- If this is not a drop-down control
         if(!CElementBase::IsDropdown())
           {
            //--- Send a message to determine the available controls
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
            //--- Send a message about the change in the graphical interface
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Zeroing variables connected with the slider movement             |
//+------------------------------------------------------------------+
void CScroll::ZeroThumbVariables(void)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return;
//--- Leave, if the button is already released
   if(m_clamping_area_mouse==NOT_PRESSED)
      return;
//--- If this is not a drop-down control
   if(!CElementBase::IsDropdown() && m_clamping_area_mouse==PRESSED_INSIDE)
     {
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
//--- Zero variables
   m_scroll_state        =false;
   m_thumb_size_fixing   =0;
   m_clamping_area_mouse =NOT_PRESSED;
//--- Redraw the control
   Update(true);
  }
//+------------------------------------------------------------------+
//| Change the size of the slider on new conditions                  |
//+------------------------------------------------------------------+
void CScroll::ChangeThumbSize(const int items_total,const int visible_items_total)
  {
   m_items_total         =items_total;
   m_visible_items_total =visible_items_total;
//--- Leave, if the number of the list view items is not greater than the size of its visible part
   if(!IsScroll())
      return;
//--- Get the number of steps for the slider
   m_thumb_steps_total=items_total-visible_items_total;
//--- Get the size of the scrollbar
   if(!CalculateThumbSize())
      return;
  }
//+------------------------------------------------------------------+
//| Calculation of the length of the scrollbar slider                |
//+------------------------------------------------------------------+
bool CScroll::CalculateThumbSize(void)
  {
//--- Percentage of difference between the total number of items and visible ones
   double percentage_difference=1-(double)(m_items_total-m_visible_items_total)/m_items_total;
//--- Calculate the size of the slider step
   uint bg_length=(m_class_name=="CScrollV")? m_y_size-(m_thumb_width*2) : m_x_size-(m_thumb_width*2);
   m_thumb_step_size=(double)(bg_length-(bg_length*percentage_difference))/m_thumb_steps_total;
//--- Calculate the size of the working area for moving the slider
   double work_area=m_thumb_step_size*m_thumb_steps_total;
//--- If the size of the working area is less than the size of the whole area, get the size of the slider otherwise set the minimal size
   double thumb_size=(work_area<bg_length)? bg_length-work_area+m_thumb_step_size : m_thumb_min_length;
//--- Check of the slider size using the type casting
   m_thumb_length=((int)thumb_size<m_thumb_min_length)? m_thumb_min_length :(int)thumb_size;
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculation of the boundaries of the scrollbar thumb             |
//+------------------------------------------------------------------+
void CScroll::CalculateThumbBoundaries(int &x1,int &y1,int &x2,int &y2)
  {
   if(CElementBase::ClassName()=="CScrollV")
     {
      x1 =0;
      y1 =(m_thumb_y>0) ? m_thumb_y : m_thumb_width;
      x2 =x1+m_thumb_width;
      y2 =y1+m_thumb_length;
     }
   else
     {
      x1 =(m_thumb_x>0) ? m_thumb_x : m_thumb_width;
      y1 =0;
      x2 =x1+m_thumb_length;
      y2 =y1+m_thumb_width;
     }
  }
//+------------------------------------------------------------------+
//| Initialize with the new values                                   |
//+------------------------------------------------------------------+
void CScroll::Reinit(const int items_total,const int visible_items_total)
  {
   m_items_total         =(items_total>0)? items_total : 1;
   m_visible_items_total =(visible_items_total>items_total)? items_total : visible_items_total;
   m_thumb_steps_total   =m_items_total-m_visible_items_total+1;
  }
//+------------------------------------------------------------------+
//| Shows the control                                                |
//+------------------------------------------------------------------+
void CScroll::Show(void)
  {
//--- Leave, if this control is already visible or (2) showing it is not necessary
   if(CElementBase::IsVisible() || !IsScroll())
      return;
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving();
//--- Show objects
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
   m_button_inc.Show();
   m_button_dec.Show();
  }
//+------------------------------------------------------------------+
//| Hides the control                                                |
//+------------------------------------------------------------------+
void CScroll::Hide(void)
  {
   m_canvas.Timeframes(OBJ_NO_PERIODS);
   m_button_inc.Hide();
   m_button_dec.Hide();
//--- Visible state
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CScroll::Delete(void)
  {
//--- Removing objects
   m_canvas.Delete();
//--- Initializing of variables by default values
   m_thumb_x=0;
   m_thumb_y=0;
   CurrentPos(0);
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CScroll::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw the thumb
   DrawThumb();
  }
//+------------------------------------------------------------------+
//| Draws the scrollbar thumb                                        |
//+------------------------------------------------------------------+
void CScroll::DrawThumb(void)
  {
//--- Coordinates
   int x1=0,y1=0,x2=0,y2=0;
//--- Calculation of the boundaries of the thumb
   CalculateThumbBoundaries(x1,y1,x2,y2);
//--- Save the coordinates of the thumb (upper left corner)
   m_thumb_x=x1;
   m_thumb_y=y1;
//--- Draw a filled rectangle
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,ThumbColorCurrent());
  }
//+------------------------------------------------------------------+
//| Class for managing the vertical scrollbar                        |
//+------------------------------------------------------------------+
class CScrollV : public CScroll
  {
public:
                     CScrollV(void);
                    ~CScrollV(void);
   //--- Managing the scrollbar
   bool              ScrollBarControl(void);
   //--- Moves the thumb to the specified position
   void              MovingThumb(const int pos=WRONG_VALUE);
   //--- Set the new coordinate for the scrollbar
   void              XDistance(const int x);
   //--- Change the length of the scrollbar
   void              ChangeYSize(const int height);
   //--- Handling the pressing on the scrollbar buttons
   bool              OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   bool              OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //---
private:
   //--- Process of the slider movement
   bool              OnDragThumb(const int y);
   //--- Updating the location of the slider
   void              UpdateThumb(const int new_y_point);
   //--- Calculation of the Y coordinate of the scrollbar
   void              CalculateThumbY(void);
   //--- Corrects the value of the slider position
   void              CalculateThumbPos(void);
   //--- Quick redraw of the scrollbar thumb
   void              RedrawThumb(const int y);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScrollV::CScrollV(void)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScrollV::~CScrollV(void)
  {
  }
//+------------------------------------------------------------------+
//| Managing the slider                                              |
//+------------------------------------------------------------------+
bool CScrollV::ScrollBarControl(void)
  {
//--- Leave, if (1) there is no pointer to the main control or (2) the control is hidden
   if(!CElement::CheckMainPointer() || !CElementBase::IsVisible())
      return(false);
//--- Leave, if the parent is disabled by another control
   if(!m_main.IsAvailable())
      return(false);
//--- Checking the focus over the scrollbar
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
   CheckThumbFocus(x,y);
//--- Check and save the state of the mouse button
   CScroll::CheckMouseButtonState();
//--- If the management is passed to the scrollbar, identify the location of the scrollbar
   if(CScroll::State())
     {
      //--- If the thumb was moved
      if(OnDragThumb(y))
        {
         //--- Changes the value of the scrollbar location
         CalculateThumbPos();
         return(true);
        }
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Moves the thumb to the specified position                        |
//+------------------------------------------------------------------+
void CScrollV::MovingThumb(const int pos=WRONG_VALUE)
  {
//--- Leave, if the scrollbar is not required
   if(!IsScroll())
      return;
// --- To check the position of the thumb
   uint check_pos=0;
//--- Adjustment the position in case the range has been exceeded
   if(pos<0 || pos>m_items_total-m_visible_items_total)
      check_pos=m_items_total-m_visible_items_total;
   else
      check_pos=pos;
//--- Store the position of the thumb
   CScroll::CurrentPos(check_pos);
//--- Calculate and set the Y coordinate of the scrollbar thumb
   CalculateThumbY();
  }
//+------------------------------------------------------------------+
//| Calculate and set the Y coordinate of the scrollbar thumb        |
//+------------------------------------------------------------------+
void CScrollV::CalculateThumbY(void)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return;
//--- Identify current Y coordinate of the scrollbar
   int scroll_thumb_y=int(m_thumb_width+(CurrentPos()*m_thumb_step_size));
//--- If the working area is exceeded upwards
   if(scroll_thumb_y<=m_thumb_width)
      scroll_thumb_y=m_thumb_width;
//--- If the working area is exceeded downwards
   if(scroll_thumb_y+m_thumb_length>=m_y_size-m_thumb_width || 
      CScroll::CurrentPos()>=m_thumb_steps_total-1)
     {
      scroll_thumb_y=int(m_y_size-m_thumb_width-m_thumb_length);
     }
//--- Update the coordinate and margin along the Y axis
   m_thumb_y=scroll_thumb_y;
  }
//+------------------------------------------------------------------+
//| Change the X coordinate of the control                           |
//+------------------------------------------------------------------+
void CScrollV::XDistance(const int x)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return;
//--- Update the X coordinate of the control ...
   CElementBase::X(CElement::CalculateX(x));
   CElementBase::XGap(x);
   m_canvas.X(x);
//--- Set the coordinate and indent
   m_canvas.X_Distance(x);
   m_canvas.XGap(x);
//--- Move the objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Change the length of the scrollbar                               |
//+------------------------------------------------------------------+
void CScrollV::ChangeYSize(const int height)
  {
//--- Coordinates and sizes
   int y=0,y_size=0;
//--- Change the width of the control and the background
   CElementBase::YSize(height);
   m_canvas.YSize(height);
   m_canvas.Resize(m_x_size,height);
//--- Adjust the position of the decrement button
   m_button_dec.Moving();
//--- Calculate and set the sizes of the scrollbar objects
   CalculateThumbSize();
//--- Adjust the thumb position
   if(m_thumb_y+m_thumb_length>=m_y_size-m_thumb_length || m_thumb_y<m_thumb_width)
     {
      CalculateThumbY();
      CalculateThumbPos();
     }
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the upwards/to the left button          |
//+------------------------------------------------------------------+
bool CScrollV::OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the values do not match
   if(check_id!=m_button_inc.Id() || check_index!=m_button_inc.Index())
      return(false);
//--- Leave, if (1) it is currently active or (2) the number of steps is undefined
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Decrease the value of the scrollbar position
   if(CScroll::CurrentPos()>0)
      CScroll::m_current_pos--;
//--- Calculation of the Y coordinate of the scrollbar
   CalculateThumbY();
//--- Release the button
   m_button_inc.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the downwards/to the left right         |
//+------------------------------------------------------------------+
bool CScrollV::OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the values do not match
   if(check_id!=m_button_dec.Id() || check_index!=m_button_dec.Index())
      return(false);
//--- Leave, if (1) it is currently active or (2) the number of steps is undefined
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Increase the value of the scrollbar position
   if(CScroll::CurrentPos()<CScroll::m_thumb_steps_total-1)
      CScroll::m_current_pos++;
//--- Calculation of the Y coordinate of the scrollbar
   CalculateThumbY();
//--- Release the button
   m_button_dec.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving the slider                                                |
//+------------------------------------------------------------------+
bool CScrollV::OnDragThumb(const int y)
  {
//--- To identify the new Y coordinate
   int new_y_point=0;
//--- If the scrollbar is inactive, ...
   if(!CScroll::State())
     {
      //--- ...zero auxiliary variables for moving the slider
      m_thumb_size_fixing  =0;
      m_thumb_point_fixing =0;
      return(false);
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(m_thumb_point_fixing==0)
      m_thumb_point_fixing=y;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(m_thumb_size_fixing==0)
      m_thumb_size_fixing=m_thumb_y-y;
//--- If the threshold is passed downwards in the pressed down state
   if(y-m_thumb_point_fixing>0)
     {
      //--- Calculate the Y coordinate
      new_y_point=y+m_thumb_size_fixing;
      //--- Update location of the slider
      UpdateThumb(new_y_point);
      return(true);
     }
//--- If the threshold is passed upwards in the pressed down state
   if(y-m_thumb_point_fixing<0)
     {
      //--- Calculate the Y coordinate
      new_y_point=y-::fabs(m_thumb_size_fixing);
      //--- Update location of the slider
      UpdateThumb(new_y_point);
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Updating of the location of the slider                           |
//+------------------------------------------------------------------+
void CScrollV::UpdateThumb(const int new_y_point)
  {
   int y=new_y_point;
//--- Zeroing the fixation point
   m_thumb_point_fixing=0;
//--- Checking for exceeding the working area downwards and adjusting values
   if(new_y_point>m_y_size-m_thumb_width-m_thumb_length)
     {
      y=m_y_size-m_thumb_width-m_thumb_length;
      CScroll::CurrentPos(int(m_thumb_steps_total-1));
     }
//--- Checking for exceeding the working area upwards and adjusting values
   if(new_y_point<=m_thumb_width)
     {
      y=m_thumb_width;
      CScroll::CurrentPos(0);
     }
//--- Current coordinates
   RedrawThumb(y);
  }
//+------------------------------------------------------------------+
//| Corrects the value of the slider position                        |
//+------------------------------------------------------------------+
void CScrollV::CalculateThumbPos(void)
  {
//--- Leave, if the step is zero
   if(m_thumb_step_size==0)
      return;
//--- Corrects the value of the position of the scrollbar
   CScroll::CurrentPos(int((m_thumb_y-m_thumb_width+1)/m_thumb_step_size));
//--- Check for exceeding the working area downwards/upwards
   if(m_thumb_y+m_thumb_length>=m_y_size-m_thumb_width)
      CScroll::CurrentPos(int(m_thumb_steps_total-1));
   if(m_thumb_y<=m_thumb_width)
      CScroll::CurrentPos(0);
  }
//+------------------------------------------------------------------+
//| Quick redraw of the scrollbar thumb                              |
//+------------------------------------------------------------------+
void CScrollV::RedrawThumb(const int y)
  {
//--- Current coordinates
   int x1=0,y1=0,x2=0,y2=0;
   CalculateThumbBoundaries(x1,y1,x2,y2);
//--- Delete the current position of the thumb
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_back_color);
//--- Update the coordinates
   m_thumb_y=y;
   y2=y+m_thumb_length;
//--- Draw the new position of the thumb
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_thumb_color_pressed);
  }
//+------------------------------------------------------------------+
//| Class for managing the horizontal scrollbar                      |
//+------------------------------------------------------------------+
class CScrollH : public CScroll
  {
public:
                     CScrollH(void);
                    ~CScrollH(void);
   //--- Managing the scrollbar
   bool              ScrollBarControl(void);
   //--- Moves the thumb to the specified position
   void              MovingThumb(const int pos=WRONG_VALUE);
   //--- Set the new coordinate for the scrollbar
   void              YDistance(const int y);
   //--- Change the length of the scrollbar
   void              ChangeXSize(const int width);
   //--- Handling the pressing on the scrollbar buttons
   bool              OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   bool              OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //---
private:
   //--- Moving the slider
   bool              OnDragThumb(const int x);
   //--- Updating the location of the slider
   void              UpdateThumb(const int new_x_point);
   //--- Calculation of the X coordinate of the slider
   void              CalculateThumbX(void);
   //--- Corrects the value of the slider position
   void              CalculateThumbPos(void);
   //--- Quick redraw of the scrollbar thumb
   void              RedrawThumb(const int x);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CScrollH::CScrollH(void)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CScrollH::~CScrollH(void)
  {
  }
//+------------------------------------------------------------------+
//| Managing the scrollbar                                           |
//+------------------------------------------------------------------+
bool CScrollH::ScrollBarControl(void)
  {
//--- Leave, if (1) there is no pointer to the main control or (2) the control is hidden
   if(!CElement::CheckMainPointer() || !CElementBase::IsVisible())
      return(false);
//--- Leave, if the parent is disabled by another control
   if(!m_main.IsAvailable())
      return(false);
//--- Checking the focus over the scrollbar
   int x=m_mouse.RelativeX(m_canvas);
   int y=m_mouse.RelativeY(m_canvas);
   CheckThumbFocus(x,y);
//--- Check and save the state of the mouse button
   CScroll::CheckMouseButtonState();
//--- If the management is passed to the scrollbar, identify the location of the scrollbar
   if(CScroll::State())
     {
      //--- If the thumb was moved
      if(OnDragThumb(x))
        {
         //--- Changes the value of the scrollbar location
         CalculateThumbPos();
         return(true);
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//| Moves the thumb to the specified position                        |
//+------------------------------------------------------------------+
void CScrollH::MovingThumb(const int pos=WRONG_VALUE)
  {
//--- Leave, if the scrollbar is not required
   if(!IsScroll())
      return;
// --- To check the position of the thumb
   uint check_pos=0;
//--- Adjustment the position in case the range has been exceeded
   if(pos<0 || pos>m_items_total-m_visible_items_total)
      check_pos=m_items_total-m_visible_items_total;
   else
      check_pos=pos;
//--- Store the position of the thumb
   CScroll::CurrentPos(check_pos);
//--- Calculate and set the Y coordinate of the scrollbar thumb
   CalculateThumbX();
  }
//+------------------------------------------------------------------+
//| Calculation of the X coordinate of the slider                    |
//+------------------------------------------------------------------+
void CScrollH::CalculateThumbX(void)
  {
//--- Identify current X coordinate of the scrollbar
   double scroll_thumb_x=m_thumb_width+(CurrentPos()*m_thumb_step_size);
//--- If the working area is exceeded on the left
   if(scroll_thumb_x<=m_thumb_width)
     {
      scroll_thumb_x=m_thumb_width;
     }
//--- If the working area is exceeded on the right
   if(scroll_thumb_x+m_thumb_length>=m_x_size-m_thumb_width || 
      CScroll::CurrentPos()>=m_thumb_steps_total-1)
     {
      scroll_thumb_x=int(m_x_size-m_thumb_width-m_thumb_length);
     }
//--- Update the coordinate and margin along the X axis
   m_thumb_x=(int)scroll_thumb_x;
  }
//+------------------------------------------------------------------+
//| Change the Y coordinate of the control                           |
//+------------------------------------------------------------------+
void CScrollH::YDistance(const int y)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return;
//--- Update the X coordinate of the control ...
   CElementBase::Y(CElement::CalculateY(y));
   CElementBase::YGap(y);
//--- ...and all the objects of the scrollbar
   m_canvas.Y(y);
   m_thumb_y=y;
//--- Set the coordinates to the objects
   m_canvas.Y_Distance(m_canvas.Y());
//--- Update the indents of all objects of the control
   int y_gap=CElement::CalculateYGap(y);
   m_canvas.YGap(CElement::CalculateYGap(y));
  }
//+------------------------------------------------------------------+
//| Change the length of the scrollbar                               |
//+------------------------------------------------------------------+
void CScrollH::ChangeXSize(const int width)
  {
//--- Coordinates and sizes
   int x=0,x_size=width-1;
//--- Change the width of the control and the background
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Adjust the position of the decrement button
   m_button_dec.Moving();
//--- Calculate and set the sizes of the scrollbar objects
   CalculateThumbSize();
//--- Adjust the thumb position
   if(m_thumb_x+m_thumb_length>=m_x_size-m_thumb_length || m_thumb_x<m_thumb_width)
     {
      CalculateThumbX();
      CalculateThumbPos();
     }
  }
//+------------------------------------------------------------------+
//| Pressing on the left spin                                        |
//+------------------------------------------------------------------+
bool CScrollH::OnClickScrollInc(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the values do not match
   if(check_id!=m_button_inc.Id() || check_index!=m_button_inc.Index())
      return(false);
//--- Leave, if (1) it is currently active or (2) the number of steps is undefined
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Decrease the value of the scrollbar position
   if(CScroll::CurrentPos()>0)
      CScroll::m_current_pos--;
//--- Calculation of the X coordinate of the scrollbar
   CalculateThumbX();
//--- Release the button
   m_button_inc.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the right spin                                       |
//+------------------------------------------------------------------+
bool CScrollH::OnClickScrollDec(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the values do not match
   if(check_id!=m_button_inc.Id() || check_index!=m_button_dec.Index())
      return(false);
//--- Leave, if (1) it is currently active or (2) the number of steps is undefined
   if(CScroll::State() || m_thumb_steps_total<1)
      return(false);
//--- Increase the value of the scrollbar position
   if(CScroll::CurrentPos()<CScroll::m_thumb_steps_total-1)
      CScroll::m_current_pos++;
//--- Calculation of the X coordinate of the scrollbar
   CalculateThumbX();
//--- Release the button
   m_button_dec.IsPressed(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Moving the slider                                                |
//+------------------------------------------------------------------+
bool CScrollH::OnDragThumb(const int x)
  {
//--- To identify the new X coordinate
   int new_x_point=0;
//--- If the scrollbar is inactive, ...
   if(!CScroll::State())
     {
      //--- ...zero auxiliary variables for moving the slider
      CScroll::m_thumb_size_fixing  =0;
      CScroll::m_thumb_point_fixing =0;
      return(false);
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(CScroll::m_thumb_point_fixing==0)
      CScroll::m_thumb_point_fixing=x;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(CScroll::m_thumb_size_fixing==0)
      CScroll::m_thumb_size_fixing=m_thumb_x-x;
//--- If the threshold is passed to the right in the pressed down state
   if(x-CScroll::m_thumb_point_fixing>0)
     {
      //--- Calculate the X coordinate
      new_x_point=x+CScroll::m_thumb_size_fixing;
      //--- Updating the scrollbar location
      UpdateThumb(new_x_point);
      return(true);
     }
//--- If the threshold is passed to the left in the pressed down state
   if(x-CScroll::m_thumb_point_fixing<0)
     {
      //--- Calculate the X coordinate
      new_x_point=x-::fabs(CScroll::m_thumb_size_fixing);
      //--- Updating the scrollbar location
      UpdateThumb(new_x_point);
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Updating the scrollbar location                                  |
//+------------------------------------------------------------------+
void CScrollH::UpdateThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Zeroing the fixation point
   CScroll::m_thumb_point_fixing=0;
//--- Checking for exceeding the working area to the right and adjusting values
   if(new_x_point>m_x_size-m_thumb_width-m_thumb_length)
     {
      x=m_x_size-m_thumb_width-m_thumb_length;
      CScroll::CurrentPos(0);
     }
//--- Checking for exceeding the working area to the left and adjusting values
   if(new_x_point<=m_thumb_width)
     {
      x=m_thumb_width;
      CScroll::CurrentPos(int(m_thumb_steps_total));
     }
//--- Current coordinates
   RedrawThumb(x);
  }
//+------------------------------------------------------------------+
//| Corrects the value of the slider position                        |
//+------------------------------------------------------------------+
void CScrollH::CalculateThumbPos(void)
  {
//--- Leave, if the step is zero
   if(CScroll::m_thumb_step_size==0)
      return;
//--- Corrects the value of the position of the scrollbar
   double pos=(m_thumb_x-m_thumb_width)/m_thumb_step_size;
   CScroll::CurrentPos((int)::MathCeil(pos));
//--- Check for exceeding the working area on the left/right
   if(m_thumb_x+m_thumb_length>=m_x_size-m_thumb_width-1)
      CScroll::CurrentPos(int(m_thumb_steps_total-1));
   if(m_thumb_x<m_thumb_width)
      CScroll::CurrentPos(0);
  }
//+------------------------------------------------------------------+
//| Quick redraw of the scrollbar thumb                              |
//+------------------------------------------------------------------+
void CScrollH::RedrawThumb(const int x)
  {
//--- Current coordinates
   int x1=0,y1=0,x2=0,y2=0;
   CalculateThumbBoundaries(x1,y1,x2,y2);
//--- Delete the current position of the thumb
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_back_color);
//--- Update the coordinates
   m_thumb_x=x;
   x2=x+m_thumb_length;
//--- Draw the new position of the thumb
   m_canvas.FillRectangle(x1,y1,x2-1,y2-1,m_thumb_color_pressed);
  }
//+------------------------------------------------------------------+
