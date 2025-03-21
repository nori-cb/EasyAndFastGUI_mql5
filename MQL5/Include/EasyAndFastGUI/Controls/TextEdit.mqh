//+------------------------------------------------------------------+
//|                                                     TextEdit.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextBox.mqh"
class CCalendar;
//+------------------------------------------------------------------+
//| Class for creating the text edit box                             |<
//+------------------------------------------------------------------+
class CTextEdit : public CElement
  {
private:
   //--- Objects for creating the edit
   CTextBox          m_edit;
   CButton           m_button_inc;
   CButton           m_button_dec;
   //--- Mode of control with a checkbox
   bool              m_checkbox_mode;
   //--- Mode of spin edit box with buttons
   bool              m_spin_edit_mode;
   //--- Current value of the edit
   string            m_edit_value;
   //--- Mode of resetting the value (empty string)
   bool              m_reset_mode;
   //--- Minimum/maximum value
   double            m_min_value;
   double            m_max_value;
   //--- Step for changing the value in edit
   double            m_step_value;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //--- Number of decimal places
   int               m_digits;
   //---
public:
                     CTextEdit(void);
                    ~CTextEdit(void);
   //--- Methods for creating the text edit box
   bool              CreateTextEdit(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateEdit(void);
   bool              CreateSpinButton(CButton &button_obj,const int index);
   //---
public:
   //--- Returns pointers to components
   CTextBox         *GetTextBoxPointer(void)                 { return(::GetPointer(m_edit));       }
   CButton          *GetIncButtonPointer(void)               { return(::GetPointer(m_button_inc)); }
   CButton          *GetDecButtonPointer(void)               { return(::GetPointer(m_button_dec)); }
   //--- Reset mode when press on the text label takes place
   bool              ResetMode(void)                   const { return(m_reset_mode);               }
   void              ResetMode(const bool mode)              { m_reset_mode=mode;                  }
   //--- (1) Checkbox and (2) spin edit box modes
   void              CheckBoxMode(const bool state)          { m_checkbox_mode=state;              }
   bool              SpinEditMode(void)                const { return(m_spin_edit_mode);           }
   void              SpinEditMode(const bool state)          { m_spin_edit_mode=state;             }
   //--- Minimum value
   double            MinValue(void)                    const { return(m_min_value);                }
   void              MinValue(const double value)            { m_min_value=value;                  }
   //--- Maximum value
   double            MaxValue(void)                    const { return(m_max_value);                }
   void              MaxValue(const double value)            { m_max_value=value;                  }
   //--- (1) Value step, (2) setting the number of decimal places
   double            StepValue(void)                   const { return(m_step_value);               }
   void              StepValue(const double value)           { m_step_value=(value<=0)? 1 : value; }
   int               GetDigits(void)                   const { return(m_digits);                   }
   void              SetDigits(const int digits)             { m_digits=::fabs(digits);            }
   //--- Control state (pressed/released)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //--- Returning and setting the edit value
   string            GetValue(void) { return(m_edit.GetValue(0)); }
   void              SetValue(const string value);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Lock
   virtual void      IsLocked(const bool state);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handle clicking the control
   bool              OnClickElement(const string clicked_object);
   //--- Handling the end of the value input
   bool              OnEndEdit(const uint id);
   //--- Handling the edit button press
   bool              OnClickButtonInc(const string pressed_object,const uint id,const uint index);
   bool              OnClickButtonDec(const string pressed_object,const uint id,const uint index);
   //--- Fast scrolling of values in the edit
   void              FastSwitching(void);

   //--- Value adjustment
   string            AdjustmentValue(const double value);
   //--- Highlighting the limit
   void              HighlightLimit(void);

   //--- Draws the image
   virtual void      DrawImage(void);
   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTextEdit::CTextEdit(void) : m_edit_value(""),
                             m_digits(0),
                             m_min_value(DBL_MIN),
                             m_max_value(DBL_MAX),
                             m_step_value(1),
                             m_reset_mode(false),
                             m_checkbox_mode(false),
                             m_spin_edit_mode(false),
                             m_timer_counter(SPIN_DELAY_MSC)

  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTextEdit::~CTextEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
void CTextEdit::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Checking the focus over controls
      m_edit.MouseFocus(m_mouse.X()>m_edit.X() && m_mouse.X()<m_edit.X2() && 
                        m_mouse.Y()>m_edit.Y() && m_mouse.Y()<m_edit.Y2());
      //--- Redraw the control
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Handle clicking the control
      if(OnClickElement(sparam))
         return;
      //---
      return;
     }
//--- Handling the new value input
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Handle clicking the control
      if(OnEndEdit((uint)lparam))
         return;
      //---
      return;
     }
//--- Leave, if the spin edit box mode is disabled
   if(!m_spin_edit_mode)
      return;
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Handling the pressing of the increment button
      if(OnClickButtonInc(sparam,(uint)lparam,(uint)dparam))
         return;
      //--- Handling the pressing of the decrement button
      if(OnClickButtonDec(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTextEdit::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Creates a group of text edit box objects                         |
//+------------------------------------------------------------------+
bool CTextEdit::CreateTextEdit(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateEdit())
      return(false);
   if(!CreateSpinButton(m_button_inc,0))
      return(false);
   if(!CreateSpinButton(m_button_dec,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTextEdit::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Default properties
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_icon_y_gap          =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 4;
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : (m_checkbox_mode)? 20 : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : C'0,120,215';
   m_label_color_locked  =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrSilver;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrBlack;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CTextEdit::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("text_edit");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates edit box                                                 |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp"
//---
bool CTextEdit::CreateEdit(void)
  {
//--- Store the pointer to the main control
   m_edit.MainPointer(this);
//--- Size
   int x_size=(m_edit.XSize()<1)? 80 : m_edit.XSize();
//--- Coordinates
   int x =(m_edit.XGap()<1)? x_size : m_edit.XGap();
   int y =0;
//--- If a control with a checkbox is required
   if(m_checkbox_mode)
     {
      IconFile("Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp");
      IconFileLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp");
      IconFilePressed("Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp");
      IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp");
     }
//--- Set properties before creation
   if(m_index!=WRONG_VALUE)
      m_edit.Index(m_index);
//---
   m_edit.XSize(x_size);
   m_edit.YSize(m_y_size);
   m_edit.TextYOffset(5);
   m_edit.Font(CElement::Font());
   m_edit.FontSize(CElement::FontSize());
   m_edit.IsDropdown(CElementBase::IsDropdown());
//--- Set the object
   if(!m_edit.CreateTextBox(x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_edit);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates up and down buttons of the spin edit box                 |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\spin_inc.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\spin_dec.bmp"
//---
bool CTextEdit::CreateSpinButton(CButton &button_obj,const int index)
  {
//--- Store the pointer to the main control
   button_obj.MainPointer(m_edit);
//--- Leave, if the spin edit box mode is disabled
   if(!m_spin_edit_mode)
      return(true);
//--- Size
   int x_size=15,y_size=0;
//--- Coordinates
   int x=x_size+1,y=0;
//--- Files
   string file="",file_locked="",file_pressed="";
//--- Up button
   if(index==0)
     {
      y      =1;
      y_size =m_edit.YSize()/2;
      //--- 
      file         ="Images\\EasyAndFastGUI\\Controls\\spin_inc.bmp";
      file_locked  ="Images\\EasyAndFastGUI\\Controls\\spin_inc.bmp";
      file_pressed ="Images\\EasyAndFastGUI\\Controls\\spin_inc.bmp";
      //---
      button_obj.NamePart(button_obj.NamePart()==""? "spin_inc" : button_obj.NamePart());
      button_obj.AnchorRightWindowSide(true);
      //--- Index of the control
      button_obj.Index((m_index!=WRONG_VALUE)? m_index*2 : 0);
     }
//--- Down button
   else
     {
      y      =m_button_inc.YGap()+m_button_inc.YSize()-1;
      y_size =m_edit.Y2()-m_button_inc.Y2();
      //---
      file         ="Images\\EasyAndFastGUI\\Controls\\spin_dec.bmp";
      file_locked  ="Images\\EasyAndFastGUI\\Controls\\spin_dec.bmp";
      file_pressed ="Images\\EasyAndFastGUI\\Controls\\spin_dec.bmp";
      //---
      button_obj.NamePart(button_obj.NamePart()==""? "spin_dec" : button_obj.NamePart());
      button_obj.AnchorRightWindowSide(true);
      button_obj.AnchorBottomWindowSide(true);
      //--- Index of the control
      button_obj.Index((m_index!=WRONG_VALUE)? m_button_inc.Index()+1 : 1);
     }
//--- 
   color back_color         =(button_obj.BackColor()!=clrNONE)? button_obj.BackColor() : m_edit.BackColor();
   color back_color_hover   =(button_obj.BackColorHover()!=clrNONE)? button_obj.BackColorHover() : C'225,225,225';
   color back_color_pressed =(button_obj.BackColorPressed()!=clrNONE)? button_obj.BackColorPressed() : clrLightGray;
//--- Set properties before creation
   button_obj.XSize(x_size);
   button_obj.YSize(y_size);
   button_obj.IconXGap(5);
   button_obj.IconYGap(3);
   button_obj.BackColor(back_color);
   button_obj.BackColorHover(back_color_hover);
   button_obj.BackColorLocked(clrLightGray);
   button_obj.BackColorPressed(back_color_pressed);
   button_obj.BorderColor(back_color);
   button_obj.BorderColorHover(back_color_hover);
   button_obj.BorderColorLocked(clrLightGray);
   button_obj.BorderColorPressed(back_color_pressed);
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
//| Setting the control state (pressed/released)                     |
//+------------------------------------------------------------------+
void CTextEdit::IsPressed(const bool state)
  {
//--- Leave, if (1) the control is locked or (2) the control is already in that state
   if(CElementBase::IsLocked() || m_is_pressed==state)
      return;
//--- Setting the state
   m_is_pressed=state;
//--- Set the corresponding icon
   CElement::ChangeImage(0,!m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Setting value in the edit box                                    |
//+------------------------------------------------------------------+
void CTextEdit::SetValue(const string value)
  {
//--- Clear the text edit box
   m_edit.ClearTextBox();
//--- Add a new value
   if(!m_spin_edit_mode)
      m_edit.AddText(0,value);
   else
      m_edit.AddText(0,AdjustmentValue(::StringToDouble(value)));
//--- Adjust the text box size
   m_edit.CorrectSize();
  }
//+------------------------------------------------------------------+
//| Value adjustment                                                 |
//+------------------------------------------------------------------+
string CTextEdit::AdjustmentValue(const double value)
  {
//--- For adjustment
   double corrected_value=0.0;
//--- Adjust considering the step
   corrected_value=::MathRound(value/m_step_value)*m_step_value;
//--- Check for the minimum/maximum
   if(corrected_value<m_min_value)
      corrected_value=m_min_value;
   if(corrected_value>m_max_value)
      corrected_value=m_max_value;
//--- If the value has been changed
   if(::StringToDouble(m_edit_value)!=corrected_value)
      m_edit_value=::DoubleToString(corrected_value,m_digits);
//--- Value unchanged
   return(m_edit_value);
  }
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
void CTextEdit::IsLocked(const bool state)
  {
   CElement::IsLocked(state);
//--- Set the corresponding icon
   CElement::ChangeImage(0,(m_is_locked)? !m_is_pressed? 1 : 3 : !m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Handle clicking the control                                      |
//+------------------------------------------------------------------+
bool CTextEdit::OnClickElement(const string clicked_object)
  {
//--- Leave, if (1) the control is locked or (2) it has a different object name
   if(CElementBase::IsLocked() || m_canvas.Name()!=clicked_object)
      return(false);
//--- If the mode of resetting the value is enabled
   if(m_reset_mode)
      SetValue("");
//--- If the checkbox is enabled
   if(m_checkbox_mode)
     {
      //--- Switch to the opposite state
      IsPressed(!(IsPressed()));
      //--- Draw the control
      Update(true);
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),CElementBase::Index(),"");
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking the control                                      |
//+------------------------------------------------------------------+
bool CTextEdit::OnEndEdit(const uint id)
  {
//--- Leave, if identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Set the value
   SetValue(m_edit.GetValue());
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the increment spin                                   |
//+------------------------------------------------------------------+
bool CTextEdit::OnClickButtonInc(const string pressed_object,const uint id,const uint index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,m_program_name+"_spin_inc")<0)
      return(false);
//--- Leave, if identifiers and indexes do not match
   if(id!=CElementBase::Id() || index!=m_button_inc.Index())
      return(false);
//--- Get the new value
   double value=::StringToDouble(m_edit.GetValue())+m_step_value;
//--- Increase by one step and check for exceeding the limit
   SetValue(::DoubleToString(value));
//--- Release the button
   m_button_inc.IsPressed(false);
//--- Update the text box
   m_edit.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the decrement spin                                   |
//+------------------------------------------------------------------+
bool CTextEdit::OnClickButtonDec(const string pressed_object,const uint id,const uint index)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,m_program_name+"_spin_dec")<0)
      return(false);
//--- Leave, if identifiers and indexes do not match
   if(id!=CElementBase::Id() || index!=m_button_dec.Index())
      return(false);
//--- Get the current value
   double value=::StringToDouble(m_edit.GetValue())-m_step_value;
//--- Decrease by one step and check for exceeding the limit
   SetValue(::DoubleToString(value));
//--- Release the button
   m_button_dec.IsPressed(false);
//--- Update the text box
   m_edit.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Fast scrolling of values in the edit                             |
//+------------------------------------------------------------------+
void CTextEdit::FastSwitching(void)
  {
//--- Leave, if (1) the focus is not on the control or (2) the control is part of the calendar
   if(!CElementBase::MouseFocus() || dynamic_cast<CCalendar*>(m_main)!=NULL)
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
      //--- Get the current value in the edit
      double current_value=::StringToDouble(m_edit.GetValue());
      //--- If increase 
      if(m_button_inc.MouseFocus())
        {
         SetValue(::DoubleToString(current_value+m_step_value));
         m_edit.Update(true);
        }
      //--- If decrease
      else if(m_button_dec.MouseFocus())
        {
         SetValue(::DoubleToString(current_value-m_step_value));
         m_edit.Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTextEdit::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw icon
   CElement::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CTextEdit::DrawImage(void)
  {
//--- Leave, if (1) the checkbox is not required or (2) icon is not defined
   if(!m_checkbox_mode || CElement::IconFile()=="")
      return;
//--- Determine the index
   uint image_index=(m_is_pressed)? 2 : 0;
//--- If the control is not locked
   if(!CElementBase::IsLocked())
     {
      if(CElementBase::MouseFocus())
         image_index=(m_is_pressed)? 2 : 0;
     }
   else
      image_index=(m_is_pressed)? 3 : 1;
//--- Set the corresponding icon
   CElement::ChangeImage(0,image_index);
//--- Draw the image
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CTextEdit::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Coordinates and sizes
   int x=0,x_size=0;
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
