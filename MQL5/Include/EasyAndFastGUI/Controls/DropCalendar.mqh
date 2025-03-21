//+------------------------------------------------------------------+
//|                                                 DropCalendar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Calendar.mqh"
//+------------------------------------------------------------------+
//| Class for creating a drop down calendar                          |
//+------------------------------------------------------------------+
class CDropCalendar : public CElement
  {
private:
   //--- Objects and elements for creating a control
   CTextEdit         m_date_box;
   CButton           m_drop_button;
   CCalendar         m_calendar;
   //---
public:
                     CDropCalendar(void);
                    ~CDropCalendar(void);
   //--- Methods for creating a drop down calendar
   bool              CreateDropCalendar(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateDateBox(void);
   bool              CreateDropButton(void);
   bool              CreateCalendar(void);
   //---
public:
   //--- Returns pointers to controls
   CTextEdit        *GetTextEditPointer(void)      { return(::GetPointer(m_date_box));    }
   CButton          *GetDropButtonPointer(void)    { return(::GetPointer(m_drop_button)); }
   CCalendar        *GetCalendarPointer(void)      { return(::GetPointer(m_calendar));    }
   //--- (1) Set (select) and (2) get the selected date
   void              SelectedDate(const datetime date);
   datetime          SelectedDate(void) { return(m_calendar.SelectedDate()); }
   //--- Change the calendar visibility state for the opposite
   void              ChangeComboBoxCalendarState(void);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling of pressing the combo box button
   bool              OnClickButton(const string pressed_object,const int id,const int index);
   //--- Checking pressing of the left button of the mouse over the combo box button
   void              CheckPressedOverButton(void);

  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CDropCalendar::CDropCalendar(void)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CDropCalendar::~CDropCalendar(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CDropCalendar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Checking pressing of the left button of the mouse over the combo box button
      CheckPressedOverButton();
      return;
     }
//--- Handle event of new date selection in the calendar
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_DATE)
     {
      //--- Leave, if control identifiers do not match
      if(lparam!=CElementBase::Id())
         return;
      //--- Set a new date in the combo box field
      m_date_box.SetValue(::TimeToString((datetime)dparam,TIME_DATE));
      m_date_box.GetTextBoxPointer().Update(true);
      return;
     }
//--- Handling event of clicking on the button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickButton(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create drop down calendar                                        |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDropCalendar(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateDateBox())
      return(false);
   if(!CreateDropButton())
      return(false);
   if(!CreateCalendar())
      return(false);
//--- Hide calendar
   m_calendar.Hide();
//--- Display selected date in the calendar
   m_date_box.SetValue(::TimeToString((datetime)m_calendar.SelectedDate(),TIME_DATE));
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CDropCalendar::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x           =CElement::CalculateX(x_gap);
   m_y           =CElement::CalculateY(y_gap);
   m_label_text  =text;
//--- Default colors
   m_back_color  =(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Priority as in the main control, since the control does not have its own area for clicking
   CElement::Z_Order(m_main.Z_Order());
  }
//+------------------------------------------------------------------+
//| Create date edit box                                             |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateDateBox(void)
  {
//--- Store the pointer to the parent control
   m_date_box.MainPointer(this);
//--- Properties
   m_date_box.Index(0);
   m_date_box.NamePart("drop_calendar");
   m_date_box.XSize(m_x_size);
   m_date_box.YSize(m_y_size);
   m_date_box.LabelXGap(m_label_x_gap);
   m_date_box.LabelYGap(m_label_y_gap);
   m_date_box.Font(CElement::Font());
   m_date_box.FontSize(CElement::FontSize());
   m_date_box.GetTextBoxPointer().XSize(100);
   m_date_box.GetTextBoxPointer().TextYOffset(5);
   m_date_box.GetTextBoxPointer().ReadOnlyMode(true);
   m_date_box.GetTextBoxPointer().NamePart("date_box");
   m_date_box.GetTextBoxPointer().AnchorRightWindowSide(true);
//--- Set the object
   if(!m_date_box.CreateTextEdit(m_label_text,0,0))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_date_box);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates combo box button                                         |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_drop_on.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_drop_off.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_drop_locked.bmp"
//---
bool CDropCalendar::CreateDropButton(void)
  {
//--- Store the pointer to the parent control
   m_drop_button.MainPointer(m_date_box);
//--- Size
   int x_size=28;
//--- Coordinates
   int x=x_size,y=0;
//--- Margins for the image
   int icon_x_gap =(m_drop_button.IconXGap()<1)? 4 : m_drop_button.IconXGap();
   int icon_y_gap =(m_drop_button.IconYGap()<1)? 2 : m_drop_button.IconYGap();
//--- Properties
   m_drop_button.NamePart("drop_button");
   m_drop_button.TwoState(true);
   m_drop_button.XSize(x_size);
   m_drop_button.YSize(m_y_size);
   m_drop_button.IconXGap(icon_x_gap);
   m_drop_button.IconYGap(icon_y_gap);
   m_drop_button.AnchorRightWindowSide(true);
   m_drop_button.IconFile("Images\\EasyAndFastGUI\\Controls\\calendar_drop_off.bmp");
   m_drop_button.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\calendar_drop_locked.bmp");
   m_drop_button.IconFilePressed("Images\\EasyAndFastGUI\\Controls\\calendar_drop_on.bmp");
   m_drop_button.IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\calendar_drop_locked.bmp");
//--- Create a control
   if(!m_drop_button.CreateButton("",x,y))
      return(false);
//--- Set the priority
   m_drop_button.Z_Order(m_date_box.GetTextBoxPointer().Z_Order()+1);
//--- Add the control to the array
   CElement::AddToArray(m_drop_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the list view                                            |
//+------------------------------------------------------------------+
bool CDropCalendar::CreateCalendar(void)
  {
//--- Store the pointer to the main control
   m_calendar.MainPointer(m_date_box);
//--- Coordinates
   int x =m_date_box.GetTextBoxPointer().XGap();
   int y =m_y_size;
//--- Properties
   m_calendar.IsDropdown(true);
   m_calendar.AnchorRightWindowSide(true);
//--- Create a control
   if(!m_calendar.CreateCalendar(x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_calendar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Set a new date in the calendar                                   |
//+------------------------------------------------------------------+
void CDropCalendar::SelectedDate(const datetime date)
  {
//--- Set and store the date
   m_calendar.SelectedDate(date);
//--- Display date in the combo box edit box
   m_date_box.LabelText(::TimeToString(date,TIME_DATE));
  }
//+------------------------------------------------------------------+
//| Change the calendar visibility state for the opposite            |
//+------------------------------------------------------------------+
void CDropCalendar::ChangeComboBoxCalendarState(void)
  {
//--- If the calendar is open, hide it
   if(m_calendar.IsVisible())
      {
       m_calendar.Hide();
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      }
//--- If the calendar is hidden, open it
   else
      {
       m_calendar.Show();
      //--- Send a message to determine the available controls
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      }
  }
//+------------------------------------------------------------------+
//| Pressing on the combo box button                                 |
//+------------------------------------------------------------------+
bool CDropCalendar::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Leave, if the pressing was on this control
   if(!m_drop_button.CheckElementName(pressed_object))
      return(false);
//--- Leave, if the values do not match
   if(id!=m_drop_button.Id() || index!=m_drop_button.Index())
      return(false);
//--- Change the calendar visibility state for the opposite
   ChangeComboBoxCalendarState();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_BUTTON,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Check of the pressed left mouse button over the button           |
//+------------------------------------------------------------------+
void CDropCalendar::CheckPressedOverButton(void)
  {
//--- Leave, if (1) the left mouse button or (2) the calendar call button are released
   if(!m_mouse.LeftButtonState() || !m_drop_button.IsPressed())
      return;
//--- If the focus is not on the control
   if(!CElementBase::MouseFocus())
     {
      //--- Leave, if the focus is on the calendar
      if(m_calendar.MouseFocus())
         return;
      //--- Leave, if the scrollbar of the calendar month list is active
      if(m_calendar.GetComboBoxPointer().GetScrollVPointer().State())
         return;
      //--- Hide the calendar and reset the colors of objects
      m_calendar.Hide();
      m_drop_button.IsPressed(false);
      m_drop_button.Update(true);
      //--- Send a message to determine the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CDropCalendar::Draw(void)
  {
//--- Draw the background
   DrawBackground();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
