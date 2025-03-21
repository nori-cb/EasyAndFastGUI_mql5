//+------------------------------------------------------------------+
//|                                                     Calendar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
#include "ComboBox.mqh"
#include "Button.mqh"
#include "ButtonsGroup.mqh"
#include <Tools\DateTime.mqh>
//--- The number of days in the table
#define DAYS_TOTAL 42
//+------------------------------------------------------------------+
//| Class for creating the calendar                                  |
//+------------------------------------------------------------------+
class CCalendar : public CElement
  {
private:
   //--- Controls for creating a calendar
   CButton           m_month_dec;
   CButton           m_month_inc;
   CComboBox         m_months;
   CTextEdit         m_years;
   CButtonsGroup     m_days;
   CButton           m_button_today;
   //--- Instances of the structure for working with dates and time:
   CDateTime         m_date;      // date selected by user
   CDateTime         m_today;     // current date (system date on a user's PC)
   CDateTime         m_temp_date; // instance for calculations and checks
   //--- Color of the current day item
   color             m_today_color;
   //--- Color of separation line
   color             m_sepline_color;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CCalendar(void);
                    ~CCalendar(void);
   //--- Methods for creating the calendar
   bool              CreateCalendar(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateMonthArrow(CButton &button_obj,const int index);
   bool              CreateMonthsList(void);
   bool              CreateYearsSpinEdit(void);
   bool              CreateDaysMonth(void);
   bool              CreateButtonToday(void);
   //---
public:
   //--- Returns pointers to the calendar controls
   CButton          *GetMonthDecPointer(void)              { return(::GetPointer(m_month_dec));    }
   CButton          *GetMonthIncPointer(void)              { return(::GetPointer(m_month_inc));    }
   CComboBox        *GetComboBoxPointer(void)              { return(::GetPointer(m_months));       }
   CTextEdit        *GetSpinEditPointer(void)              { return(::GetPointer(m_years));        }
   CButton          *GetTodayButtonPointer(void)           { return(::GetPointer(m_button_today)); }
   CButtonsGroup    *GetDayButtonsPointer(void)            { return(::GetPointer(m_days));         }
   //--- (1) get the current date in the calendar, (2) set (select) and (3) get the selected date
   datetime          Today(void)                           { return(m_today.DateTime());           }
   datetime          SelectedDate(void)                    { return(m_date.DateTime());            }
   void              SelectedDate(const datetime date);
   //--- Display last changes in the calendar
   void              UpdateCalendar(void);
   //--- Updates the calendar controls
   void              UpdateElements(void);
   //--- Update the current date
   void              UpdateCurrentDate(void);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Show
   virtual void      Show(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling clicking on the button to go to a previous month
   bool              OnClickMonthDec(const string clicked_object,const int id,const int index);
   //--- Handling clicking on the button to go to a following month
   bool              OnClickMonthInc(const string clicked_object,const int id,const int index);
   //--- Handling month selection in the list
   bool              OnClickMonthList(const int id);
   //--- Handling value input to the year edit box
   bool              OnEndEnterYear(const string edited_object,const int id);
   //--- Handling clicking on the button to switch to a next year
   bool              OnClickYearInc(const string clicked_object,const int id,const int index);
   //--- Handling clicking on the button to go to a previous year
   bool              OnClickYearDec(const string clicked_object,const int id,const int index);
   //--- Handling clicking on a day of a month
   bool              OnClickDayOfMonth(const string clicked_object,const int id,const int index);
   //--- Handling clicking the button to go to a current date
   bool              OnClickTodayButton(const string clicked_object,const int id,const int index);

   //--- Correcting the selected day by the number of days in a month
   void              CorrectingSelectedDay(void);
   //--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   int               OffsetFirstDayOfMonth(void);
   //--- Display last changes in the calendar table
   void              SetCalendar(void);
   //--- Fast switching of calendar values
   void              FastSwitching(void);
   //--- Highlight the current date and the user selected date
   void              HighlightDate(void);
   //--- Reset time to midnight
   void              ResetTime(void);

   //--- Draws the names of the days of the week
   void              DrawDaysWeek(void);
   //--- Drawing a separation line
   void              DrawSeparateLine(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCalendar::CCalendar(void) : m_today_color(C'0,102,204')
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Initialization of time structures
   m_date.DateTime(::TimeLocal());
   m_today.DateTime(::TimeLocal());
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCalendar::~CCalendar(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CCalendar::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the event of selecting an item in the drop-down list
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      //--- Handling value input to the year edit box
      if(OnClickMonthList((int)lparam))
         return;
      //---
      return;
     }
//--- Handle event of entering value to the edit box
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Handling value input to the year edit box
      if(OnEndEnterYear(sparam,(int)lparam))
         return;
      //---
      return;
     }
//--- Handling the event of clicking a button in the group
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_GROUP_BUTTON)
     {
      //--- Handling pressing on the day of the calendar
      if(OnClickDayOfMonth(sparam,(int)lparam,(int)dparam))
         return;
      //---
      return;
     }
//--- Handling event of clicking on the button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Handling clicking on buttons of switching months
      if(OnClickMonthDec(sparam,(int)lparam,(int)dparam))
         return;
      if(OnClickMonthInc(sparam,(int)lparam,(int)dparam))
         return;
      //--- Handling clicking on the buttons for switching years
      if(OnClickYearInc(sparam,(int)lparam,(int)dparam))
         return;
      if(OnClickYearDec(sparam,(int)lparam,(int)dparam))
         return;
      //--- Handling clicking the button to go to a current date
      if(OnClickTodayButton(sparam,(int)lparam,(int)dparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CCalendar::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
//--- Update of the current date of the calendar
   UpdateCurrentDate();
  }
//+------------------------------------------------------------------+
//| Creates a context menu                                           |
//+------------------------------------------------------------------+
bool CCalendar::CreateCalendar(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateMonthArrow(m_month_dec,0))
      return(false);
   if(!CreateMonthArrow(m_month_inc,1))
      return(false);
   if(!CreateMonthsList())
      return(false);
   if(!CreateYearsSpinEdit())
      return(false);
   if(!CreateDaysMonth())
      return(false);
   if(!CreateButtonToday())
      return(false);
//--- Update calendar
   UpdateCalendar();
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CCalendar::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =161;
   m_y_size =158;
//--- Default colors
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_border_color       =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_label_color        =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_locked =(m_label_color_locked!=clrNONE)? m_label_color_locked : C'200,200,200';
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CCalendar::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("calendar");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create left month switch                                         |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\left_thin_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\right_thin_black.bmp"
//---
bool CCalendar::CreateMonthArrow(CButton &button_obj,const int index)
  {
//--- Store the pointer to the main control
   button_obj.MainPointer(this);
//--- Size
   int x_size=12;
   int y_size=18;
//--- Offset
   int offset=2;
//--- Coordinates
   int x =(index<1)? offset : x_size+offset;
   int y =offset;
//--- Properties
   button_obj.Index(index);
   button_obj.XSize(x_size);
   button_obj.YSize(y_size);
   button_obj.IconXGap(-2);
   button_obj.IconYGap(1);
   button_obj.IsDropdown(CElementBase::IsDropdown());
//--- Button icons
   if(index<1)
     {
      button_obj.IconFile("Images\\EasyAndFastGUI\\Controls\\left_thin_black.bmp");
      button_obj.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\left_thin_black.bmp");
     }
   else
     {
      button_obj.IconFile("Images\\EasyAndFastGUI\\Controls\\right_thin_black.bmp");
      button_obj.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\right_thin_black.bmp");
      button_obj.AnchorRightWindowSide(true);
     }
//--- Create a control
   if(!button_obj.CreateButton("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(button_obj);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create combo box with months                                     |
//+------------------------------------------------------------------+
bool CCalendar::CreateMonthsList(void)
  {
//--- Store the pointer to the main control
   m_months.MainPointer(this);
//--- Coordinates
   int x=14,y=2;
//--- Properties
   m_months.XSize(50);
   m_months.YSize(18);
   m_months.ItemsTotal(12);
   m_months.GetButtonPointer().XGap(1);
   m_months.GetButtonPointer().LabelYGap(3);
   m_months.IsDropdown(CElementBase::IsDropdown());
//--- Get the list view pointer
   CListView *lv=m_months.GetListViewPointer();
//--- Set the list view properties
   lv.YSize(93);
   lv.LightsHover(true);
//--- Store the values to the list (names of months)
   for(int i=0; i<12; i++)
      m_months.SetValue(i,m_date.MonthName(i+1));
//--- Select the current month in the list
   m_months.SelectItem(m_date.mon-1);
//--- Create a control
   if(!m_months.CreateComboBox("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_months);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create year edit box                                             |
//+------------------------------------------------------------------+
bool CCalendar::CreateYearsSpinEdit(void)
  {
//--- Store the pointer to the main control
   m_years.MainPointer(this);
//--- Coordinates
   int x=95,y=2;
//--- Properties
   m_years.Index(m_is_dropdown? 1 : 0);
   m_years.XSize(50);
   m_years.YSize(18);
   m_years.MaxValue(2099);
   m_years.MinValue(1970);
   m_years.StepValue(1);
   m_years.SetDigits(0);
   m_years.SpinEditMode(true);
   m_years.SetValue((string)m_date.year);
   m_years.GetTextBoxPointer().XGap(1);
   m_years.GetTextBoxPointer().XSize(50);
   m_years.GetIncButtonPointer().NamePart("cal_spin_inc");
   m_years.GetDecButtonPointer().NamePart("cal_spin_dec");
//--- Create a control
   if(!m_years.CreateTextEdit("",x,y))
      return(false);
//--- Offset of text in the text box
   m_years.GetTextBoxPointer().TextYOffset(4);
//--- Add the control to the array
   CElement::AddToArray(m_years);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create table of days of the month                                |
//+------------------------------------------------------------------+
bool CCalendar::CreateDaysMonth(void)
  {
//--- Counter of days
   int i=0;
//--- Coordinates and offsets
   int x=0,y=0;
   int x_offset=7,y_offset=44;
//--- Size
   int x_size=21,y_size=15;
//--- Store the pointer to the main control
   m_days.MainPointer(this);
//---
   int    buttons_x_offset[DAYS_TOTAL]={};
   int    buttons_y_offset[DAYS_TOTAL]={};
   string buttons_text[DAYS_TOTAL]={};
//--- Set the objects of table of calendar days
   for(int r=0; r<6; r++)
     {
      //--- Calculating the Y coordinate
      y=(r>0)? y+y_size : 0;
      //---
      for(int c=0; c<7; c++)
        {
         //--- Calculation of the X coordinate
         x=(c>0)? x+x_size : 0;
         //--
         buttons_text[i]     =string(i);
         buttons_x_offset[i] =x;
         buttons_y_offset[i] =y;
         //---
         i++;
        }
     }
//--- Properties
   m_days.NamePart("day");
   m_days.ButtonYSize(y_size);
   m_days.LabelYGap(1);
   m_days.IsCenterText(true);
   m_days.RadioButtonsMode(true);
   m_days.IsDropdown(CElementBase::IsDropdown());
//--- Add buttons to the group
   for(int j=0; j<DAYS_TOTAL; j++)
      m_days.AddButton(buttons_x_offset[j],buttons_y_offset[j],buttons_text[j],x_size);
//--- Create a group of buttons
   x=x_offset;
   y=y_offset;
   if(!m_days.CreateButtonsGroup(x,y))
      return(false);
//--- Properties
   for(int j=0; j<DAYS_TOTAL; j++)
     {
      m_days.GetButtonPointer(j).BackColor(m_back_color);
      m_days.GetButtonPointer(j).BorderColor(m_back_color);
     }
//--- Add the control to the array
   CElement::AddToArray(m_days);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create button to go to the current date                          |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp"
//---
bool CCalendar::CreateButtonToday(void)
  {
//--- Store the pointer to the main control
   m_button_today.MainPointer(this);
//--- Coordinates
   int x=22,y=YSize()-23;
//--- Properties
   m_button_today.NamePart("today_button");
   m_button_today.Index(2);
   m_button_today.XSize(120);
   m_button_today.YSize(20);
   m_button_today.IconXGap(1);
   m_button_today.IconYGap(1);
   m_button_today.LabelXGap(25);
   m_button_today.LabelYGap(4);
   m_button_today.BackColor(m_back_color);
   m_button_today.BackColorHover(m_back_color);
   m_button_today.BackColorLocked(m_back_color);
   m_button_today.BackColorPressed(m_back_color);
   m_button_today.BorderColor(m_back_color);
   m_button_today.BorderColorHover(m_back_color);
   m_button_today.BorderColorLocked(m_back_color);
   m_button_today.BorderColorPressed(m_back_color);
   m_button_today.LabelColorHover(C'0,102,250');
   m_button_today.IsDropdown(CElementBase::IsDropdown());
   m_button_today.IconFile("Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp");
   m_button_today.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp");
   m_button_today.IconFilePressed("Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp");
   m_button_today.IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\calendar_today.bmp");
//--- Create a control
   if(!m_button_today.CreateButton("Today: "+::TimeToString(::TimeLocal(),TIME_DATE),x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_button_today);
   return(true);
  }
//+------------------------------------------------------------------+
//| Selection of a new date                                          |
//+------------------------------------------------------------------+
void CCalendar::SelectedDate(const datetime date)
  {
//--- Store date in the structure and field of the class
   m_date.DateTime(date);
//--- Display last changes in the calendar
   UpdateCalendar();
  }
//+------------------------------------------------------------------+
//| Display last changes in the calendar                             |
//+------------------------------------------------------------------+
void CCalendar::UpdateCalendar(void)
  {
//--- Display changes in the calendar table
   SetCalendar();
//--- Highlight the current date and the user selected date
   HighlightDate();
//--- Set the year in the edit box
   m_years.SetValue((string)m_date.year);
//--- Set the month in the combo box list
   m_months.SelectItem(m_date.mon-1);
  }
//+------------------------------------------------------------------+
//| Updates the calendar controls                                    |
//+------------------------------------------------------------------+
void CCalendar::UpdateElements(void)
  {
   m_days.Update(true);
   m_years.Update(true);
   m_months.Update(true);
   m_months.GetButtonPointer().Update(true);
   m_years.GetTextBoxPointer().Update(true);
   m_months.GetListViewPointer().Update(true);
  }
//+------------------------------------------------------------------+
//| Update current date                                              |
//+------------------------------------------------------------------+
void CCalendar::UpdateCurrentDate(void)
  {
//--- Counter
   static int count=0;
//--- Exit if was less than a second
   if(count<1000)
     {
      count+=TIMER_STEP_MSC;
      return;
     }
//--- Zero the counter
   count=0;
//--- Obtain current (local) time
   MqlDateTime local_time;
   ::TimeToStruct(::TimeLocal(),local_time);
//--- If a new day has begun
   if(local_time.day!=m_today.day)
     {
      //--- Update date in the calendar
      m_today.DateTime(::TimeLocal());
      m_button_today.LabelText(::TimeToString(m_today.DateTime()));
      //--- Display last changes in the calendar
      UpdateCalendar();
      return;
     }
//--- Update date in the calendar
   m_today.DateTime(::TimeLocal());
  }
//+------------------------------------------------------------------+
//| Show the calendar                                                |
//+------------------------------------------------------------------+
void CCalendar::Show(void)
  {
//--- If it is not a drop-down calendar, make all its elements visible
   CElement::Show();
//--- If it is a drop-down calendar
   if(CElementBase::IsDropdown())
     {
      int elements_total=ElementsTotal();
      for(int i=0; i<elements_total; i++)
         m_elements[i].Show();
     }
  }
//+------------------------------------------------------------------+
//| Click the arrow to the left. Go to a previous a month.                        |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthDec(const string clicked_object,const int id,const int index)
  {
//--- Leave, if the pressing was on this control
   if(!m_month_dec.CheckElementName(clicked_object))
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || index!=m_month_dec.Index() || CElementBase::IsLocked())
      return(false);
//--- If the current year in the calendar equals the minimum indicated and the current month is "January"
   if(m_date.year==m_years.MinValue() && m_date.mon==1)
      return(true);
//--- Go to a previous month
   m_date.MonDec();
//--- Set first day of a month
   m_date.day=1;
//--- Reset time
   ResetTime();
//--- Display last changes in the calendar
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Click the arrow to the left. Go to the next month.           |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthInc(const string clicked_object,const int id,const int index)
  {
//--- Leave, if the pressing was on this control
   if(!m_month_inc.CheckElementName(clicked_object))
      return(false);
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || index!=m_month_inc.Index() || CElementBase::IsLocked())
      return(false);
//--- If the current year in the calendar equals the maximum indicated and the current month is "December"
   if(m_date.year==m_years.MaxValue() && m_date.mon==12)
      return(true);
//--- Go to the next month
   m_date.MonInc();
//--- Set first day of a month
   m_date.day=1;
//--- Reset time
   ResetTime();
//--- Display last changes in the calendar
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle month selection in the list                               |
//+------------------------------------------------------------------+
bool CCalendar::OnClickMonthList(const int id)
  {
//--- Leave, if control identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Obtain selected month in a list
   int month=m_months.GetListViewPointer().SelectedItemIndex()+1;
   m_date.Mon(month);
//--- Correcting the selected day by the number of days in a month
   CorrectingSelectedDay();
//--- Reset time
   ResetTime();
//--- Display changes in the calendar table
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle value input to the year edit box                          |
//+------------------------------------------------------------------+
bool CCalendar::OnEndEnterYear(const string edited_object,const int id)
  {
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Exit if the value hasn't changed
   string value=m_years.GetValue();
   if(m_date.year==(int)value)
     {
      //--- Updates the edit box
      m_years.GetTextBoxPointer().Update(true);
      return(false);
     }
//--- Correct value in case of going beyond the set restrictions
   if((int)value<m_years.MinValue())
      value=(string)int(m_years.MinValue());
   if((int)value>m_years.MaxValue())
      value=(string)int(m_years.MaxValue());
//--- Define the number of days in a current month
   string year  =value;
   string month =string(m_date.mon);
   string day   =string(1);
   m_temp_date.DateTime(::StringToTime(year+"."+month+"."+day));
//--- If value of a selected day exceeds the number of days in a month,
//    set current number of days in a month as a selected day
   if(m_date.day>m_temp_date.DaysInMonth())
      m_date.day=m_temp_date.DaysInMonth();
//--- Set a date in the structure
   m_date.DateTime(::StringToTime(year+"."+month+"."+string(m_date.day)));
//--- Display changes in the table of the calendar
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking on the button to go to a following year          |
//+------------------------------------------------------------------+
bool CCalendar::OnClickYearInc(const string clicked_object,const int id,const int index)
  {
//--- Leave, if the pressing was on this control
   if(!m_years.GetIncButtonPointer().CheckElementName(clicked_object))
      return(false);
//--- If the list of months is open, we will close it
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Leave, if control identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- If a year is below the maximum specified, then to increase value by one
   if(m_date.year<m_years.MaxValue())
      m_date.YearInc();
//--- Correcting the selected day by the number of days in a month
   CorrectingSelectedDay();
//--- Display changes in the calendar table
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking on the button to go to a previous year           |
//+------------------------------------------------------------------+
bool CCalendar::OnClickYearDec(const string clicked_object,const int id,const int index)
  {
//--- Leave, if the pressing was on this control
   if(!m_years.GetDecButtonPointer().CheckElementName(clicked_object))
      return(false);
//--- If the list of months is open, we will close it
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Leave, if control identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- If the year is greater than the minimum specified, reduce the value by one
   if(m_date.year>m_years.MinValue())
      m_date.YearDec();
//--- Correcting the selected day by the number of days in a month  
   CorrectingSelectedDay();
//--- Display changes in the calendar table
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking on a day of a month of the calendar              |
//+------------------------------------------------------------------+
bool CCalendar::OnClickDayOfMonth(const string clicked_object,const int id,const int index)
  {
//--- Leave, if (1) the identifiers do not match or (2) the control is locked
   if(id!=CElementBase::Id() || CElementBase::IsLocked())
      return(false);
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   OffsetFirstDayOfMonth();
//--- Iterate over the table's items in the loop
   int items_total=m_days.ButtonsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- If the date of the current item is lower than a minimum set in the system
      if(m_temp_date.DateTime()<datetime(D'01.01.1970'))
        {
         //--- If this is the object that we have clicked on
         if(i==index)
            return(false);
         //--- Move to the next date
         m_temp_date.DayInc();
         continue;
        }
      //--- If this is the object that we have clicked on
      if(i==index)
        {
         //--- Store date
         m_date.DateTime(m_temp_date.DateTime());
         //--- Display last changes in the calendar
         UpdateCalendar();
         break;
        }
      //--- Move to the next date
      m_temp_date.DayInc();
      //--- Check exit beyond the maximum set in the system
      if(m_temp_date.year>m_years.MaxValue())
         return(false);
     }
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handle clicking the button to go to a current date               |
//+------------------------------------------------------------------+
bool CCalendar::OnClickTodayButton(const string clicked_object,const int id,const int index)
  {
//--- Exit if it has a different object name
   if(::StringFind(clicked_object,m_button_today.NamePart(),0)<0)
      return(false);
//--- Leave, if control identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- If the list of months is open, we will close it
   if(m_months.GetListViewPointer().IsVisible())
      m_months.ChangeComboBoxListState();
//--- Set the current date
   m_date.DateTime(::TimeLocal());
//--- Display last changes in the calendar
   UpdateCalendar();
//--- Updates the calendar controls
   UpdateElements();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Determine the first day of a month                               |
//+------------------------------------------------------------------+
void CCalendar::CorrectingSelectedDay(void)
  {
//--- Set the current number of days in a month, it the selected day value is higher
   if(m_date.day>m_date.DaysInMonth())
      m_date.day=m_date.DaysInMonth();
  }
//+------------------------------------------------------------------+
//| Define the difference from the first item of the calendar's tab  |
//| until the item of the first day of the current month             |
//+------------------------------------------------------------------+
int CCalendar::OffsetFirstDayOfMonth(void)
  {
//--- Get the date of the first day of the selected year and month in a string
   string date=string(m_date.year)+"."+string(m_date.mon)+"."+string(1);
//--- Set this date in the structure for calculations
   m_temp_date.DateTime(::StringToTime(date));
//--- If the result of deducting 1 from the current number of the day of the week exceeds or equals 0,
//    return result, otherwise — return 6
   int diff=(m_temp_date.day_of_week-1>=0) ? m_temp_date.day_of_week-1 : 6;
//--- Store date that is in the first item of the table
   m_temp_date.DayDec(diff);
   return(diff);
  }
//+------------------------------------------------------------------+
//| Setting calendar values                                          |
//+------------------------------------------------------------------+
void CCalendar::SetCalendar(void)
  {
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   int diff=OffsetFirstDayOfMonth();
//--- Iterate over all items of the calendar table in the loop
   int items_total=m_days.ButtonsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- Setting day in the current item of the table
      m_days.GetButtonPointer(i).LabelText(string(m_temp_date.day));
      //--- Move to the next date
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Fast switching the calendar                                      |
//+------------------------------------------------------------------+
void CCalendar::FastSwitching(void)
  {
//--- Exit if there is no focus on the control
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
      //--- If the left arrow is pressed
      if(m_month_dec.MouseFocus())
        {
         //--- If the current year in the calendar exceeds/equals minimum specified
         if(m_date.year>=m_years.MinValue())
           {
            //--- If a current year in the calendar already equals a specified minimum and
            //    current month is "January"
            if(m_date.year==m_years.MinValue() && m_date.mon==1)
               return;
            //--- Proceed to a next month (downward)
            m_date.MonDec();
            //--- Set first day of a month
            m_date.day=1;
           }
        }
      //--- If the right arrow is pressed
      else if(m_month_inc.MouseFocus())
        {
         //--- If a current year in the calendar is below/equal to a specified maximum
         if(m_date.year<=m_years.MaxValue())
           {
            //--- If a current year in the calendar already equals a specified maximum and
            //    the current month is "December"
            if(m_date.year==m_years.MaxValue() && m_date.mon==12)
               return;
            //--- Go to the following month (upward)
            m_date.MonInc();
            //--- Set first day of a month
            m_date.day=1;
           }
        }
      //--- If the increment button of the year edit box is pressed
      else if(m_years.GetIncButtonPointer().MouseFocus())
        {
         //--- If below maximum specified year,
         //    go to the next year (upward)
         if(m_date.year<m_years.MaxValue())
            m_date.YearInc();
         else
            return;
        }
      //--- If the field decrement button is pressed
      else if(m_years.GetDecButtonPointer().MouseFocus())
        {
         //--- If a minimum specified year is exceeded,
         //    go to a following year (downward)
         if(m_date.year>m_years.MinValue())
            m_date.YearDec();
         else
            return;
        }
      else
         return;
      //--- Display last changes in the calendar
      UpdateCalendar();
      //--- Updates the calendar controls
      UpdateElements();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CHANGE_DATE,CElementBase::Id(),m_date.DateTime(),"");
     }
  }
//+------------------------------------------------------------------+
//| Highlight the current date and the user selected date            |
//+------------------------------------------------------------------+
void CCalendar::HighlightDate(void)
  {
//--- Calculate the difference from the first item of the calendar's table until the item of the first day of the current month
   OffsetFirstDayOfMonth();
//--- Iterate over the table's items in the loop
   int items_total=m_days.ButtonsTotal();
   for(int i=0; i<items_total; i++)
     {
      //--- If a month of the item matches with a current month and 
      //    the item date matches the selected date
      if(m_temp_date.mon==m_date.mon &&
         m_temp_date.day==m_date.day)
        {
         //--- Select this button
         m_days.SelectButton(i);
         //--- Proceed to the next item of the table
         m_temp_date.DayInc();
         continue;
        }
      //--- If this is a current date (today)
      if(m_temp_date.year==m_today.year && 
         m_temp_date.mon==m_today.mon &&
         m_temp_date.day==m_today.day)
        {
         m_days.GetButtonPointer(i).LabelColor(m_today_color);
         m_days.GetButtonPointer(i).BorderColor(m_today_color);
         //--- Proceed to the next item of the table
         m_temp_date.DayInc();
         continue;
        }
      //---
      m_days.GetButtonPointer(i).BorderColor(m_back_color);
      m_days.GetButtonPointer(i).LabelColor((m_temp_date.mon==m_date.mon)? m_label_color : m_label_color_locked);
      //--- Proceed to the next item of the table
      m_temp_date.DayInc();
     }
  }
//+------------------------------------------------------------------+
//| Reset time to midnight                                           |
//+------------------------------------------------------------------+
void CCalendar::ResetTime(void)
  {
   m_date.hour =0;
   m_date.min  =0;
   m_date.sec  =0;
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CCalendar::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
//--- Draws the names of the days of the week
   DrawDaysWeek();
//--- Drawing a separation line
   DrawSeparateLine();
  }
//+------------------------------------------------------------------+
//| Draws the names of the days of the week                          |
//+------------------------------------------------------------------+
void CCalendar::DrawDaysWeek(void)
  {
//--- Coordinates
   int x=17,y=26;
//--- Size
   int x_size =21;
   int y_size =16;
//--- Counter for days of the week (for the objects array)
   int w=0;
//--- Set the objects displaying the abbreviated names for the days of the week
   for(int i=1; i<7; i++,w++)
     {
      //--- Calculation of the X coordinate
      x=(w>0)? x+x_size : x;
      //--- Font properties
      m_canvas.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
      //--- Output text
      m_canvas.TextOut(x,y,m_date.ShortDayName(i),::ColorToARGB(clrBlack),TA_CENTER);
      //--- If there was a reset, leave
      if(i==0)
         break;
      //--- Reset, if passed all days of the week
      if(i>=6)
         i=-1;
     }
  }
//+------------------------------------------------------------------+
//| Draws a separation line                                          |
//+------------------------------------------------------------------+
void CCalendar::DrawSeparateLine(void)
  {
//--- Coordinates
   int x1=7,x2=154,y=42;
//--- Draw a line
   m_canvas.Line(x1,y,x2,y,::ColorToARGB(m_border_color));
  }
//+------------------------------------------------------------------+
