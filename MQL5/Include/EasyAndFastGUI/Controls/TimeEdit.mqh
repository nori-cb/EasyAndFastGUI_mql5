//+------------------------------------------------------------------+
//|                                                     TimeEdit.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
//+------------------------------------------------------------------+
//| Class for creating the Time control                              |
//+------------------------------------------------------------------+
class CTimeEdit : public CElement
  {
private:
   //--- Objects for creating the control
   CTextEdit         m_hours;
   CTextEdit         m_minutes;
   //--- The mode of resetting the value
   bool              m_reset_mode;
   //--- Mode of control with a checkbox
   bool              m_checkbox_mode;
   //---
public:
                     CTimeEdit(void);
                    ~CTimeEdit(void);
   //--- Methods for creating the control
   bool              CreateTimeEdit(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateSpinEdit(CTextEdit &edit_obj,const int index);
   //---
public:
   //--- (1) Return the pointers to edit boxes, (2) get/set the availability state of the control
   CTextEdit        *GetHoursEditPointer(void)        { return(::GetPointer(m_hours));     }
   CTextEdit        *GetMinutesEditPointer(void)      { return(::GetPointer(m_minutes));   }
   //--- (1) Reset mode when pressing the text label, (2) mode of control with a checkbox
   bool              ResetMode(void)                  { return(m_reset_mode);              }
   void              ResetMode(const bool mode)       { m_reset_mode=mode;                 }
   void              CheckBoxMode(const bool state)   { m_checkbox_mode=state;             }
   //--- Get and set the edit box values
   int               GetHours(void)                   { return((int)m_hours.GetValue());   }
   int               GetMinutes(void)                 { return((int)m_minutes.GetValue()); }
   void              SetHours(const uint value)       { m_hours.SetValue((string)value);   }
   void              SetMinutes(const uint value)     { m_minutes.SetValue((string)value); }
   //--- Control state (pressed/released)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Lock
   virtual void      IsLocked(const bool state);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handle clicking the control
   bool              OnClickElement(const string clicked_object);
   //--- Draws the image
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTimeEdit::CTimeEdit(void) : m_reset_mode(false)

  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTimeEdit::~CTimeEdit(void)
  {
  }
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
void CTimeEdit::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Redraw the control
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Handling the event of left mouse button press on the control
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickElement(sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates the Time control                                         |
//+------------------------------------------------------------------+
bool CTimeEdit::CreateTimeEdit(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateSpinEdit(m_minutes,0))
      return(false);
   if(!CreateSpinEdit(m_hours,1))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTimeEdit::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Default background color
   m_back_color =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 4;
//--- Margins and color of the text label
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 3;
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
bool CTimeEdit::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("time_edit");
//--- If a control with a checkbox is required
   if(m_checkbox_mode)
     {
      IconFile("Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp");
      IconFileLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp");
      IconFilePressed("Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp");
      IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp");
     }
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates edit boxes for hours and minutes                         |
//+------------------------------------------------------------------+
bool CTimeEdit::CreateSpinEdit(CTextEdit &edit_obj,const int index)
  {
//--- Store the pointer to the main control
   edit_obj.MainPointer(this);
//--- Coordinates
   int x=0,y=0;
//--- Size
   int x_size=40;
//--- Edit box for minutes
   if(index==0)
     {
      x=x_size;
      //--- Maximum value
      edit_obj.MaxValue(59);
      //--- Index of the control
      edit_obj.Index(0);
     }
//--- Edit box for hours
   else
     {
      x=x_size*2;
      //--- Maximum value
      edit_obj.MaxValue(23);
      //--- Index of the control
      edit_obj.Index(1);
     }
//--- Set properties before creation
   edit_obj.XSize(x_size);
   edit_obj.YSize(m_y_size);
   edit_obj.MinValue(0);
   edit_obj.StepValue(1);
   edit_obj.SpinEditMode(true);
   edit_obj.AnchorRightWindowSide(true);
   edit_obj.GetTextBoxPointer().XGap(1);
   edit_obj.GetTextBoxPointer().XSize(x_size-1);
   edit_obj.IsDropdown(CElementBase::IsDropdown());
//--- Create a control
   if(!edit_obj.CreateTextEdit("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(edit_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Display the control                                              |
//+------------------------------------------------------------------+
void CTimeEdit::IsLocked(const bool state)
  {
   CElement::IsLocked(state);
//--- Set the corresponding icon
   CElement::ChangeImage(0,(m_is_locked)? !m_is_pressed? 1 : 3 : !m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Setting the control state (pressed/released)                     |
//+------------------------------------------------------------------+
void CTimeEdit::IsPressed(const bool state)
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
//| Handle clicking the control                                      |
//+------------------------------------------------------------------+
bool CTimeEdit::OnClickElement(const string clicked_object)
  {
//--- Leave, if (1) the control is locked or (2) it has a different object name
   if(CElementBase::IsLocked() || m_canvas.Name()!=clicked_object)
      return(false);
//--- If the checkbox is not used
   if(!m_checkbox_mode)
      return(true);
//--- Switch to the opposite state
   IsPressed(!(IsPressed()));
//--- Draw the control
   Update(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTimeEdit::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw icon
   CTimeEdit::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CTimeEdit::DrawImage(void)
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
