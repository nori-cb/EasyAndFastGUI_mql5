//+------------------------------------------------------------------+
//|                                                        Mouse.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Defines.mqh"
#include "Objects.mqh"
#include <Charts\Chart.mqh>
//+------------------------------------------------------------------+
//| Class for getting the mouse parameters                           |
//+------------------------------------------------------------------+
class CMouse
  {
private:
   //--- Class instance for managing the chart
   CChart            m_chart;
   //--- Coordinates
   int               m_x;
   int               m_y;
   //--- Window number, in which the cursor is located
   int               m_subwin;
   //--- Time corresponding to the X coordinate
   datetime          m_time;
   //--- Level (price) corresponding to the Y coordinate
   double            m_level;
   //--- State of the left mouse button (pressed down/released)
   bool              m_left_button_state;
   //--- Counter of calls
   ulong             m_call_counter;
   //--- Pause button the left mouse button clicks (for determining the double click)
   uint              m_pause_between_clicks;
   //---
public:
                     CMouse(void);
                    ~CMouse(void);
   //--- Event handler
   void              OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   //--- Returns the absolute coordinates of the mouse cursor
   int               X(void)               const { return(m_x);                             }
   int               Y(void)               const { return(m_y);                             }
   //--- (1) Returns the window number, in which the cursor is located, (2) the time corresponding to the X coordinate 
   //    (3) the level (price) corresponding to the Y coordinate
   int               SubWindowNumber(void) const { return(m_subwin);                        }
   datetime          Time(void)            const { return(m_time);                          }
   double            Level(void)           const { return(m_level);                         }
   //--- Returns the state of the left mouse button (pressed down/released)
   bool              LeftButtonState(void) const { return(m_left_button_state);             }

   //--- Returns (1) the counter value (ms) stored in the last call and 
   //    (2) the difference (ms) between the calls to the mouse cursor event handler
   ulong             CallCounter(void)     const { return(m_call_counter);                  }
   ulong             GapBetweenCalls(void) const { return(::GetTickCount()-m_call_counter); }

   //--- Returns the relative coordinates of the mouse cursor from the passed canvas object
   int               RelativeX(CRectCanvas &object);
   int               RelativeY(CRectCanvas &object);
   //---
private:
   //--- Checking the change in the state of the left mouse button
   bool              CheckChangeLeftButtonState(const string mouse_state);
   //--- Checking the left mouse button double click
   void              CheckDoubleClick(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMouse::CMouse(void) : m_x(0),
                       m_y(0),
                       m_subwin(WRONG_VALUE),
                       m_time(NULL),
                       m_level(0.0),
                       m_left_button_state(false),
                       m_call_counter(::GetTickCount()),
                       m_pause_between_clicks(300)
  {
//--- Get the ID of the current chart
   m_chart.Attach();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMouse::~CMouse(void)
  {
//--- Detach from the chart
   m_chart.Detach();
  }
//+------------------------------------------------------------------+
//| Handling mouse events                                            |
//+------------------------------------------------------------------+
void CMouse::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Coordinates and the state of left button of the mouse
      m_x                 =(int)lparam;
      m_y                 =(int)dparam;
      m_left_button_state =CheckChangeLeftButtonState(sparam);
      //--- Store the value of the call counter
      m_call_counter=::GetTickCount();
      //--- Get the cursor location
      if(!::ChartXYToTimePrice(m_chart.ChartId(),m_x,m_y,m_subwin,m_time,m_level))
         return;
      //--- Get the relative Y coordinate
      if(m_subwin>0)
         m_y=m_y-m_chart.SubwindowY(m_subwin);
      return;
     }
//--- Handling event of clicking on the chart
   if(id==CHARTEVENT_CLICK)
     {
      //--- Check the left mouse button double click
      CheckDoubleClick();
      return;
     }
  }
//+------------------------------------------------------------------+
//| Returns the relative X coordinate of the mouse cursor            |
//| from the passed canvas object                                    |
//+------------------------------------------------------------------+
int CMouse::RelativeX(CRectCanvas &object)
  {
   return(m_x-object.X()+(int)object.GetInteger(OBJPROP_XOFFSET));
  }
//+------------------------------------------------------------------+
//| Returns the relative Y coordinate of the mouse cursor            |
//| from the passed canvas object                                    |
//+------------------------------------------------------------------+
int CMouse::RelativeY(CRectCanvas &object)
  {
   return(m_y-object.Y()+(int)object.GetInteger(OBJPROP_YOFFSET));
  }
//+------------------------------------------------------------------+
//| Checking the change in the state of the left mouse button        |
//+------------------------------------------------------------------+
bool CMouse::CheckChangeLeftButtonState(const string mouse_state)
  {
   bool left_button_state=(bool)int(mouse_state);
//--- Send a message about a change in the state of the left mouse button
   if(m_left_button_state!=left_button_state)
      ::EventChartCustom(m_chart.ChartId(),ON_CHANGE_MOUSE_LEFT_BUTTON,0,0.0,"");
//--- Return the current state of the left mouse button
   return(left_button_state);
  }
//+------------------------------------------------------------------+
//| Checking the left mouse button double click                      |
//+------------------------------------------------------------------+
void CMouse::CheckDoubleClick(void)
  {
   static uint prev_depressed =0;
   static uint curr_depressed =::GetTickCount();
//--- Update the values
   prev_depressed =curr_depressed;
   curr_depressed =::GetTickCount();
//--- Determine the time between the clicks
   uint counter=curr_depressed-prev_depressed;
//--- If the time passed between the two clicks is less than specified, send a message about a double click
   if(counter<m_pause_between_clicks)
      ::EventChartCustom(m_chart.ChartId(),ON_DOUBLE_CLICK,counter,0.0,"");
  }
//+------------------------------------------------------------------+
