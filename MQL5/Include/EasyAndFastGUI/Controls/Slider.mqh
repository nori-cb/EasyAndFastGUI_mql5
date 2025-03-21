//+------------------------------------------------------------------+
//|                                                       Slider.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
//+------------------------------------------------------------------+
//| Class for creating a slider with edit                            |
//+------------------------------------------------------------------+
class CSlider : public CElement
  {
private:
   //--- Objects for creating the control
   CTextEdit         m_left_edit;
   CTextEdit         m_right_edit;
   //--- (1) Coordinate and (2) the size of the indicator area
   int               m_slot_y;
   int               m_slot_y_size;
   //--- Colors of the indicator in different states
   color             m_slot_line_dark_color;
   color             m_slot_line_light_color;
   color             m_slot_indicator_color;
   color             m_slot_indicator_color_locked;
   //--- Current position of the slider thumb: (1) value, (2) XY coordinates
   double            m_thumb_x_pos_left;
   double            m_thumb_x_pos_right;
   double            m_thumb_x_left;
   double            m_thumb_x_right;
   int               m_thumb_y;
   //--- Size of the slider thumb
   int               m_thumb_x_size;
   int               m_thumb_y_size;
   //--- Colors of the slider thumb
   color             m_thumb_color;
   color             m_thumb_color_hover;
   color             m_thumb_color_locked;
   color             m_thumb_color_pressed;
   //--- (1) Focus on the thumb and (2) the moment of its border crossing
   bool              m_thumb_focus_left;
   bool              m_thumb_focus_right;
   bool              m_is_crossing_left_thumb_border;
   bool              m_is_crossing_right_thumb_border;
   //--- Number of pixels in the working area
   int               m_pixels_total;
   //--- Number of steps in the value range of the working area
   int               m_value_steps_total;
   //--- Step in relation to the width of the working area
   double            m_position_step;
   //--- Mouse button state (pressed/released)
   ENUM_MOUSE_STATE  m_clamping_left_thumb;
   ENUM_MOUSE_STATE  m_clamping_right_thumb;
   //--- To identify the mode of the slider thumb movement
   bool              m_slider_thumb_state;
   //--- Variables connected with the thumb movement
   int               m_slider_size_fixing;
   int               m_slider_point_fixing;
   //--- Dual slider mode
   bool              m_dual_slider_mode;
   //---
public:
                     CSlider(void);
                    ~CSlider(void);
   //--- Methods for creating the control
   bool              CreateSlider(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateLeftTextEdit(void);
   bool              CreateRightTextEdit(void);
   //---
public:
   //--- Returns pointers to controls
   CTextEdit        *GetLeftEditPointer(void)                   { return(::GetPointer(m_left_edit));  }
   CTextEdit        *GetRightEditPointer(void)                  { return(::GetPointer(m_right_edit)); }
   //--- Colors of the slider indicator in different states
   void              SlotLineDarkColor(const color clr)         { m_slot_line_dark_color=clr;         }
   void              SlotLineLightColor(const color clr)        { m_slot_line_light_color=clr;        }
   void              SlotIndicatorColor(const color clr)        { m_slot_indicator_color=clr;         }
   void              SlotIndicatorColorLocked(const color clr)  { m_slot_indicator_color_locked=clr;  }
   //--- Dual slider mode
   void              DualSliderMode(const bool state)           { m_dual_slider_mode=state;           }
   bool              DualSliderMode(void)                 const { return(m_dual_slider_mode);         }
   bool              State(void)                          const { return(m_slider_thumb_state);       }
   //--- Size of the slider thumb
   void              ThumbXSize(const int x_size)               { m_thumb_x_size=x_size;              }
   void              ThumbYSize(const int y_size)               { m_thumb_y_size=y_size;              }
   //--- Colors of the slider thumb
   void              ThumbColor(const color clr)                { m_thumb_color=clr;                  }
   void              ThumbColorHover(const color clr)           { m_thumb_color_hover=clr;            }
   void              ThumbColorLocked(const color clr)          { m_thumb_color_locked=clr;           }
   void              ThumbColorPressed(const color clr)         { m_thumb_color_pressed=clr;          }
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling entering the value in the edit box
   bool              OnEndEditLeftThumb(const int id,const int index);
   bool              OnEndEditRightThumb(const int id,const int index);
   //--- Process of the slider thumb movement
   void              OnDragLeftThumb(void);
   void              OnDragRightThumb(void);
   //--- Updating the slider thumb location
   void              UpdateLeftThumb(const int new_x_point);
   void              UpdateRightThumb(const int new_x_point);

   //--- Checking the focus over the scrollbar
   bool              CheckLeftThumbFocus(void);
   bool              CheckRightThumbFocus(void);
   //--- Checks the state of the mouse button
   void              CheckMouseOnLeftThumb(void);
   void              CheckMouseOnRightThumb(void);
   //--- Zeroing variables connected with the slider thumb movement
   void              ZeroLeftThumbVariables(void);
   void              ZeroRightThumbVariables(void);
   //--- Calculation of values (steps and coefficients)
   bool              CalculateCoefficients(void);
   //--- Calculation of the X coordinate of the slider thumb
   void              CalculateLeftThumbX(void);
   void              CalculateRightThumbX(void);
   //--- Changes the current position of the slider thumb in relation to the current value
   void              CalculateLeftThumbPos(void);
   void              CalculateRightThumbPos(void);
   //--- Current color of the thumb
   uint              ThumbColorCurrent(const bool thumb_focus,const ENUM_MOUSE_STATE thumb_clamping);

   //--- Draws borders for the indicator
   void              DrawSlot(void);
   //--- Draws the indicator
   void              DrawIndicator(void);
   //--- Draws the slider thumb
   void              DrawLeftThumb(void);
   void              DrawRightThumb(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSlider::CSlider(void) : m_dual_slider_mode(false),
                         m_slider_size_fixing(0),
                         m_slider_point_fixing(0),
                         m_slot_y(30),
                         m_slot_y_size(4),
                         m_slot_line_dark_color(clrSilver),
                         m_slot_line_light_color(clrWhite),
                         m_slot_indicator_color(C'85,170,255'),
                         m_slot_indicator_color_locked(clrLightGray),
                         m_thumb_x_pos_left(WRONG_VALUE),
                         m_thumb_x_pos_right(WRONG_VALUE),
                         m_thumb_x_left(0),
                         m_thumb_x_right(0),
                         m_thumb_y(0),
                         m_thumb_x_size(6),
                         m_thumb_y_size(14),
                         m_thumb_color(C'205,205,205'),
                         m_thumb_color_hover(C'166,166,166'),
                         m_thumb_color_locked(clrLightGray),
                         m_thumb_color_pressed(C'96,96,96'),
                         m_thumb_focus_left(false),
                         m_thumb_focus_right(false),
                         m_is_crossing_left_thumb_border(false),
                         m_is_crossing_right_thumb_border(false)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSlider::~CSlider(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CSlider::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Check and save the state of the mouse button
      CheckMouseOnRightThumb();
      //--- Change the color of the slider thumb
      CheckRightThumbFocus();
      //--- If management was passed to the slider line, identify its location
      if(m_clamping_right_thumb==PRESSED_INSIDE)
        {
         //--- Moving the slider thumb
         OnDragRightThumb();
         //--- Calculation of the slider thumb position in the value range
         CalculateRightThumbPos();
         //--- Setting a new value in the edit
         m_right_edit.SetValue(::DoubleToString(m_thumb_x_pos_right,m_right_edit.GetDigits()));
         //--- Update the control
         Update(true);
         m_right_edit.GetTextBoxPointer().Update(true);
         return;
        }
      //--- Leave, if this is not a dual slider
      if(!m_dual_slider_mode)
         return;
      //--- Check and save the state of the mouse button
      CheckMouseOnLeftThumb();
      //--- Change the color of the slider thumb
      CheckLeftThumbFocus();
      //--- If management was passed to the slider line, identify its location
      if(m_clamping_left_thumb==PRESSED_INSIDE)
        {
         //--- Moving the slider thumb
         OnDragLeftThumb();
         //--- Calculation of the slider thumb position in the value range
         CalculateLeftThumbPos();
         //--- Setting a new value in the edit
         m_left_edit.SetValue(::DoubleToString(m_thumb_x_pos_left,m_left_edit.GetDigits()));
         //--- Update the control
         Update(true);
         m_left_edit.GetTextBoxPointer().Update(true);
         return;
        }
      return;
     }
//--- Handling the value change in edit event
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Handling of the value input
      if(OnEndEditLeftThumb((int)lparam,(int)dparam))
         return;
      //--- Handling of the value input
      if(OnEndEditRightThumb((int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create slider with edit control                                  |
//+------------------------------------------------------------------+
bool CSlider::CreateSlider(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateRightTextEdit())
      return(false);
   if(!CreateLeftTextEdit())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CSlider::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x           =CElement::CalculateX(x_gap);
   m_y           =CElement::CalculateY(y_gap);
   m_label_text  =text;
   m_back_color  =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_border_color=(m_border_color!=clrNONE)? m_border_color : clrBlack;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CSlider::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("slider");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates edit box                                                 |
//+------------------------------------------------------------------+
bool CSlider::CreateRightTextEdit(void)
  {
//--- Store the pointer to the main control
   m_right_edit.MainPointer(this);
//--- Coordinates
   int x=0,y=0;
//--- Properties
   m_right_edit.Index(0);
   m_right_edit.YSize(20);
   m_right_edit.LabelXGap(0);
   m_right_edit.MaxValue((m_right_edit.MaxValue()==DBL_MAX)? 1000 : m_right_edit.MaxValue());
   m_right_edit.MinValue((m_right_edit.MinValue()==DBL_MIN)? -1000 : m_right_edit.MinValue());
   m_right_edit.StepValue(m_right_edit.StepValue());
   m_right_edit.SetDigits(m_right_edit.GetDigits());
//--- Value in the edit box
   int digits=m_right_edit.GetDigits();
   string value=(m_right_edit.GetValue()=="")? ::DoubleToString(0,digits) : m_right_edit.GetValue();
   m_right_edit.SetValue(value);
//--- Size
   int xsize=m_right_edit.GetTextBoxPointer().XSize();
   m_right_edit.GetTextBoxPointer().XSize((xsize>0)? xsize : 60);
//---
   m_right_edit.AutoXResizeMode(true);
   m_right_edit.IsDropdown(CElementBase::IsDropdown());
   m_right_edit.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_right_edit.CreateTextEdit(m_label_text,x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_right_edit);
//--- Calculation of the values of auxiliary variables
   CalculateCoefficients();
//--- Calculation of the X coordinates of the slider thumb in relation to the current value in the edit
   CalculateRightThumbX();
//--- Calculation of the Y coordinate of the scrollbar 
   m_thumb_y=m_slot_y-((m_thumb_y_size-m_slot_y_size)/2);
//--- Calculation of the slider thumb position in the value range
   CalculateRightThumbPos();
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates edit box                                                 |
//+------------------------------------------------------------------+
bool CSlider::CreateLeftTextEdit(void)
  {
   if(!m_dual_slider_mode)
      return(true);
//--- Store the pointer to parent
   m_left_edit.MainPointer(this);
//--- Size
   int x_size=m_right_edit.GetTextBoxPointer().XSize();
//--- Coordinates
   int x=x_size*2+2;
   int y=0;
//--- Properties
   m_left_edit.Index(1);
   m_left_edit.XSize(x_size+1);
   m_left_edit.YSize(20);
   m_left_edit.LabelXGap(0);
   m_left_edit.MaxValue(m_right_edit.MaxValue());
   m_left_edit.MinValue(m_right_edit.MinValue());
   m_left_edit.StepValue(m_right_edit.StepValue());
   m_left_edit.SetDigits(m_right_edit.GetDigits());
//--- Value in the edit box
   int digits=m_right_edit.GetDigits();
   string value=(m_left_edit.GetValue()=="")? ::DoubleToString(0,digits) : m_left_edit.GetValue();
   m_left_edit.SetValue((string)value);
   m_left_edit.AnchorRightWindowSide(true);
   m_left_edit.IsDropdown(CElementBase::IsDropdown());
   m_left_edit.GetTextBoxPointer().XSize(x_size);
   m_left_edit.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Create a control
   if(!m_left_edit.CreateTextEdit("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_left_edit);
//--- Calculation of the X coordinates of the slider thumb in relation to the current value in the edit
   CalculateLeftThumbX();
//--- Calculation of the slider thumb position in the value range
   CalculateLeftThumbPos();
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the value entering in the edit                          |
//+------------------------------------------------------------------+
bool CSlider::OnEndEditLeftThumb(const int id,const int index)
  {
//--- Leave, if identifiers and indexes do not match
   if(id!=m_left_edit.Id() || index!=m_left_edit.Index())
      return(false);
//--- Get the entered value
   double entered_value=::StringToDouble(m_left_edit.GetValue());
//--- Calculate the X coordinate of the slider thumb
   CalculateLeftThumbX();
//--- Updating the slider thumb location
   UpdateLeftThumb((int)m_thumb_x_left);
//--- Calculate the position in the value range
   CalculateLeftThumbPos();
//--- Setting a new value in the edit
   m_left_edit.SetValue(::DoubleToString(m_thumb_x_pos_left,m_left_edit.GetDigits()));
//--- Update the control
   Update(true);
   m_left_edit.GetTextBoxPointer().Update(true);
//--- Send a message about it
//::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),index,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the value entering in the edit                          |
//+------------------------------------------------------------------+
bool CSlider::OnEndEditRightThumb(const int id,const int index)
  {
//--- Leave, if identifiers and indexes do not match
   if(id!=m_right_edit.Id() || index!=m_right_edit.Index())
      return(false);
//--- Get the entered value
   double entered_value=::StringToDouble(m_right_edit.GetValue());
//--- Calculate the X coordinate of the slider thumb
   CalculateRightThumbX();
//--- Updating the slider thumb location
   UpdateRightThumb((int)m_thumb_x_right);
//--- Calculate the position in the value range
   CalculateRightThumbPos();
//--- Setting a new value in the edit
   m_right_edit.SetValue(::DoubleToString(m_thumb_x_pos_right,m_right_edit.GetDigits()));
//--- Update the control
   Update(true);
   m_right_edit.GetTextBoxPointer().Update(true);
//--- Send a message about it
//::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),index,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Process of the slider thumb movement                             |
//+------------------------------------------------------------------+
void CSlider::OnDragLeftThumb(void)
  {
   int x=m_mouse.RelativeX(m_canvas);
//--- To identify the new X coordinate
   int new_x_point=0;
//--- If the slider thumb is inactive, ...
   if(!m_slider_thumb_state)
     {
      //--- ...zero auxiliary variables for moving the slider
      m_slider_point_fixing =0;
      m_slider_size_fixing  =0;
      return;
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(m_slider_point_fixing==0)
      m_slider_point_fixing=x;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(m_slider_size_fixing==0)
      m_slider_size_fixing=(int)m_thumb_x_left-x;
//--- If the threshold is passed to the right in the pressed down state
   if(x-m_slider_point_fixing>0)
     {
      //--- Calculate the X coordinate
      new_x_point=x+m_slider_size_fixing;
      //--- Updating the scrollbar location
      UpdateLeftThumb(new_x_point);
      return;
     }
//--- If the threshold is passed to the left in the pressed down state
   if(x-m_slider_point_fixing<0)
     {
      //--- Calculate the X coordinate
      new_x_point=x-::fabs(m_slider_size_fixing);
      //--- Updating the scrollbar location
      UpdateLeftThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Process of the slider thumb movement                             |
//+------------------------------------------------------------------+
void CSlider::OnDragRightThumb(void)
  {
   int x=m_mouse.RelativeX(m_canvas);
//--- To identify the new X coordinate
   int new_x_point=0;
//--- If the slider thumb is inactive, ...
   if(!m_slider_thumb_state)
     {
      //--- ...zero auxiliary variables for moving the slider
      m_slider_point_fixing =0;
      m_slider_size_fixing  =0;
      return;
     }
//--- If the fixation point is zero, store current coordinates of the cursor
   if(m_slider_point_fixing==0)
      m_slider_point_fixing=x;
//--- If the distance from the edge of the slider to the current coordinate of the cursor is zero, calculate it
   if(m_slider_size_fixing==0)
      m_slider_size_fixing=(int)m_thumb_x_right-x;
//--- If the threshold is passed to the right in the pressed down state
   if(x-m_slider_point_fixing>0)
     {
      //--- Calculate the X coordinate
      new_x_point=x+m_slider_size_fixing;
      //--- Updating the scrollbar location
      UpdateRightThumb(new_x_point);
      return;
     }
//--- If the threshold is passed to the left in the pressed down state
   if(x-m_slider_point_fixing<0)
     {
      //--- Calculate the X coordinate
      new_x_point=x-::fabs(m_slider_size_fixing);
      //--- Updating the scrollbar location
      UpdateRightThumb(new_x_point);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Updating the slider thumb location                               |
//+------------------------------------------------------------------+
void CSlider::UpdateLeftThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Zeroing the fixation point
   m_slider_point_fixing=0;
//--- Right border
   int right_limit=(!m_dual_slider_mode)? m_x_size-m_thumb_x_size :(int)m_thumb_x_right-m_thumb_x_size;
//--- Check for exceeding the working area
   if(x>right_limit)
      x=right_limit;
   if(x<=0)
      x=0;
//--- Store the coordinate
   m_thumb_x_left=x;
  }
//+------------------------------------------------------------------+
//| Updating the slider thumb location                               |
//+------------------------------------------------------------------+
void CSlider::UpdateRightThumb(const int new_x_point)
  {
   int x=new_x_point;
//--- Zeroing the fixation point
   m_slider_point_fixing=0;
//--- Right border
   int right_limit=m_x_size-m_thumb_x_size;
//--- Left border
   int left_limit=(!m_dual_slider_mode)? 0 :(int)m_thumb_x_left+m_thumb_x_size;
//--- Check for exceeding the working area
   if(x>right_limit)
      x=right_limit;
   if(x<=left_limit)
      x=left_limit;
//--- Store the coordinate
   m_thumb_x_right=x;
  }
//+------------------------------------------------------------------+
//| Current color of the thumb                                       |
//+------------------------------------------------------------------+
uint CSlider::ThumbColorCurrent(const bool thumb_focus,const ENUM_MOUSE_STATE thumb_clamping)
  {
//--- Determine the color of the thumb
   color clr=(thumb_clamping==PRESSED_INSIDE)? m_thumb_color_pressed : m_thumb_color;
//--- If the mouse cursor is in the thumb area
   if(thumb_focus)
     {
      //--- If the left mouse button is released
      if(thumb_clamping==NOT_PRESSED)
         clr=m_thumb_color_hover;
      //--- The left mouse button is pressed down on the slider
      else if(thumb_clamping==PRESSED_INSIDE)
         clr=m_thumb_color_pressed;
     }
//--- If the cursor is outside the thumb area
   else
     {
      //--- Left mouse button is released
      if(thumb_clamping==NOT_PRESSED)
         clr=(m_is_locked)? m_thumb_color_locked : m_thumb_color;
     }
//---
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Checking the focus over the scrollbar                            |
//+------------------------------------------------------------------+
bool CSlider::CheckLeftThumbFocus(void)
  {
//--- Leave, if the pointer is invalid
   if(::CheckPointer(m_mouse)==POINTER_INVALID)
      return(false);
//--- Checking the focus over the scrollbar
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Verifying the focus
   m_thumb_focus_left=(x>m_thumb_x_left && x<m_thumb_x_left+m_thumb_x_size && 
                       y>m_thumb_y && y<m_thumb_y+m_thumb_y_size);
//--- If this is the moment of crossing the borders of the control
   if((m_thumb_focus_left && !m_is_crossing_left_thumb_border) || 
      (!m_thumb_focus_left && m_is_crossing_left_thumb_border))
     {
      m_is_crossing_left_thumb_border=m_thumb_focus_left;
      //--- Draw a filled rectangle
      DrawLeftThumb();
      m_canvas.Update();
      return(true);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Checking the focus over the scrollbar                            |
//+------------------------------------------------------------------+
bool CSlider::CheckRightThumbFocus(void)
  {
//--- Leave, if the pointer is invalid
   if(::CheckPointer(m_mouse)==POINTER_INVALID)
      return(false);
//--- Checking the focus over the scrollbar
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Verifying the focus
   m_thumb_focus_right=(x>m_thumb_x_right && x<m_thumb_x_right+m_thumb_x_size && 
                        y>m_thumb_y && y<m_thumb_y+m_thumb_y_size);
//--- If this is the moment of crossing the borders of the control
   if((m_thumb_focus_right && !m_is_crossing_right_thumb_border) || 
      (!m_thumb_focus_right && m_is_crossing_right_thumb_border))
     {
      m_is_crossing_right_thumb_border=m_thumb_focus_right;
      //--- Draw a filled rectangle
      DrawRightThumb();
      m_canvas.Update();
      return(true);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Verifies the state of the mouse button                           |
//+------------------------------------------------------------------+
void CSlider::CheckMouseOnLeftThumb(void)
  {
//--- Leave, if this is not a dual slider
   if(!m_dual_slider_mode)
      return;
//--- If the left mouse button is released
   if(!m_mouse.LeftButtonState())
     {
      //--- Zero out variables
      ZeroLeftThumbVariables();
      return;
     }
//--- If the left mouse button is pressed
   else
     {
      //--- Leave, if the button is pressed down in another area
      if(m_clamping_left_thumb!=NOT_PRESSED)
         return;
      //--- Outside of the slider thumb area
      if(!m_thumb_focus_left)
         m_clamping_left_thumb=PRESSED_OUTSIDE;
      //--- Inside the slider thumb area
      else
        {
         m_slider_thumb_state  =true;
         m_clamping_left_thumb =PRESSED_INSIDE;
         //--- Redraw the thumb
         DrawLeftThumb();
         m_canvas.Update();
         //--- Send a message to determine the available controls
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Verifies the state of the mouse button                           |
//+------------------------------------------------------------------+
void CSlider::CheckMouseOnRightThumb(void)
  {
//--- If the left mouse button is released
   if(!m_mouse.LeftButtonState())
     {
      //--- Zero out variables
      ZeroRightThumbVariables();
      return;
     }
//--- If the left mouse button is pressed
   else
     {
      //--- Leave, if the button is pressed down in another area
      if(m_clamping_right_thumb!=NOT_PRESSED)
         return;
      //--- Outside of the slider thumb area
      if(!m_thumb_focus_right)
         m_clamping_right_thumb=PRESSED_OUTSIDE;
      //--- Inside the slider thumb area
      else
        {
         m_slider_thumb_state=true;
         m_clamping_right_thumb=PRESSED_INSIDE;
         //--- Redraw the thumb
         DrawRightThumb();
         m_canvas.Update();
         //--- Send a message to determine the available controls
         ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Zeroing variables connected with the slider thumb movement       |
//+------------------------------------------------------------------+
void CSlider::ZeroLeftThumbVariables(void)
  {
//--- Leave, if this is not a dual slider
   if(!m_dual_slider_mode)
      return;
//--- If you are here, it means that the left mouse button is released.
//    If the left mouse button was pressed over the slider thumb...
   if(m_clamping_left_thumb==PRESSED_INSIDE)
     {
      //--- ... send a message that changing of the value in the edit box with the sider thumb is completed
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),"");
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
//--- Zero variables
   if(m_clamping_left_thumb!=NOT_PRESSED)
     {
      m_slider_thumb_state  =false;
      m_slider_size_fixing  =0;
      m_clamping_left_thumb =NOT_PRESSED;
      //--- Redraw the thumb
      DrawLeftThumb();
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Zeroing variables connected with the slider thumb movement       |
//+------------------------------------------------------------------+
void CSlider::ZeroRightThumbVariables(void)
  {
//--- If you are here, it means that the left mouse button is released.
//    If the left mouse button was pressed over the slider thumb...
   if(m_clamping_right_thumb==PRESSED_INSIDE)
     {
      //--- ... send a message that changing of the value in the edit box with the sider thumb is completed
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),"");
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
//--- Zero variables
   if(m_clamping_right_thumb!=NOT_PRESSED)
     {
      m_slider_thumb_state   =false;
      m_slider_size_fixing   =0;
      m_clamping_right_thumb =NOT_PRESSED;
      //--- Redraw the thumb
      DrawRightThumb();
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Calculation of values (steps and coefficients)                   |
//+------------------------------------------------------------------+
bool CSlider::CalculateCoefficients(void)
  {
//--- Leave, if the width of the control is less than the width of the slider thumb
   if(CElementBase::XSize()<m_thumb_x_size)
      return(false);
//--- Number of pixels in the working area
   m_pixels_total=CElementBase::XSize()-m_thumb_x_size;
//--- Number of steps in the value range of the working area
   m_value_steps_total=int((m_right_edit.MaxValue()-m_right_edit.MinValue())/m_right_edit.StepValue());
//--- Step in relation to the width of the working area
   m_position_step=m_right_edit.StepValue()*(double(m_value_steps_total)/double(m_pixels_total));
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculating the X coordinate of the slider thumb                 |
//+------------------------------------------------------------------+
void CSlider::CalculateLeftThumbX(void)
  {
//--- Adjustment considering that the minimum value can be negative
   double neg_range=(m_left_edit.MinValue()<0)? ::fabs(m_left_edit.MinValue()/m_position_step) : 0;
//--- Calculate the X coordinate for the slider thumb
   m_thumb_x_left=((double)m_left_edit.GetValue()/m_position_step)+neg_range;
//--- If the working area is exceeded on the left
   if(m_thumb_x_left<0)
      m_thumb_x_left=0;
//--- If the working area is exceeded on the right
   if(m_thumb_x_left+m_thumb_x_size>m_thumb_x_right)
      m_thumb_x_left=m_thumb_x_right-m_thumb_x_size;
  }
//+------------------------------------------------------------------+
//| Calculating the X coordinate of the slider thumb                 |
//+------------------------------------------------------------------+
void CSlider::CalculateRightThumbX(void)
  {
//--- Adjustment considering that the minimum value can be negative
   double neg_range=(m_right_edit.MinValue()<0)? ::fabs(m_right_edit.MinValue()/m_position_step) : 0;
//--- Calculate the X coordinate for the slider thumb
   m_thumb_x_right=((double)m_right_edit.GetValue()/m_position_step)+neg_range;
//--- If the working area is exceeded on the left
   if(m_thumb_x_right<0)
      m_thumb_x_right=0;
//--- If the working area is exceeded on the right
   if(m_thumb_x_right+m_thumb_x_size>m_x_size)
      m_thumb_x_right=m_x_size-m_thumb_x_size;
  }
//+------------------------------------------------------------------+
//| Calculation of the slider thumb position in the value range      |
//+------------------------------------------------------------------+
void CSlider::CalculateLeftThumbPos(void)
  {
//--- Get the position number of the slider thumb
   m_thumb_x_pos_left=m_thumb_x_left*m_position_step;
//--- Adjustment considering that the minimum value can be negative
   if(m_left_edit.MinValue()<0 && m_thumb_x_left!=WRONG_VALUE)
      m_thumb_x_pos_left+=int(m_left_edit.MinValue());
//--- Check for exceeding the working area on the left
   if(m_thumb_x_left<=0)
      m_thumb_x_pos_left=int(m_left_edit.MinValue());
  }
//+------------------------------------------------------------------+
//| Calculation of the slider thumb position in the value range      |
//+------------------------------------------------------------------+
void CSlider::CalculateRightThumbPos(void)
  {
//--- Get the position number of the slider thumb
   m_thumb_x_pos_right=m_thumb_x_right*m_position_step;
//--- Adjustment considering that the minimum value can be negative
   if(m_right_edit.MinValue()<0 && m_thumb_x_right!=WRONG_VALUE)
      m_thumb_x_pos_right+=int(m_right_edit.MinValue());
//--- Check for exceeding the working area on the right/left
   if(m_thumb_x_right+m_thumb_x_size>m_x_size)
      m_thumb_x_pos_right=int(m_right_edit.MaxValue());
   if(m_thumb_x_right<=0)
      m_thumb_x_pos_right=int(m_right_edit.MinValue());
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CSlider::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw the indicator borders
   DrawSlot();
//--- Draw the indicator
   DrawIndicator();
//--- Draw the slider thumb
   DrawLeftThumb();
//--- Draw the slider thumb
   DrawRightThumb();
  }
//+------------------------------------------------------------------+
//| Draws borders for the indicator                                  |
//+------------------------------------------------------------------+
void CSlider::DrawSlot(void)
  {
//--- Upper border
   int x1=0,x2=m_x_size;
   int y1=m_slot_y,y2=y1;
   m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_slot_line_dark_color));
//--- Lower border
   y1+=m_slot_y_size; y2=y1;
   m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_slot_line_light_color));
  }
//+------------------------------------------------------------------+
//| Draws the indicator                                              |
//+------------------------------------------------------------------+
void CSlider::DrawIndicator(void)
  {
//--- Coordinates
   int x1 =(int)m_thumb_x_left;
   int x2 =(int)m_thumb_x_right;
   int y1 =m_slot_y+1;
   int y2 =m_slot_y+m_slot_y_size-1;
//--- Color
   color clr=(m_is_locked)? m_slot_indicator_color_locked : m_slot_indicator_color;
//--- Draw the indicator
   m_canvas.FillRectangle(x1,y1,x2,y2,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Draws the slider thumb                                           |
//+------------------------------------------------------------------+
void CSlider::DrawLeftThumb(void)
  {
//--- Leave, if this is not a dual slider
   if(!m_dual_slider_mode)
      return;
//--- Coordinates
   int x1 =(int)m_thumb_x_left;
   int x2 =(int)m_thumb_x_left+m_thumb_x_size;
   int y1 =m_thumb_y;
   int y2 =y1+m_thumb_y_size;
//--- Draw the thumb
   m_canvas.FillRectangle(x1,y1,x2,y2,ThumbColorCurrent(m_thumb_focus_left,m_clamping_left_thumb));
  }
//+------------------------------------------------------------------+
//| Draws the slider thumb                                           |
//+------------------------------------------------------------------+
void CSlider::DrawRightThumb(void)
  {
//--- Coordinates
   int x1 =(int)m_thumb_x_right;
   int x2 =(int)m_thumb_x_right+m_thumb_x_size;
   int y1 =m_thumb_y;
   int y2 =y1+m_thumb_y_size;
//--- Draw the thumb
   m_canvas.FillRectangle(x1,y1,x2,y2,ThumbColorCurrent(m_thumb_focus_right,m_clamping_right_thumb));
  }
//+------------------------------------------------------------------+
