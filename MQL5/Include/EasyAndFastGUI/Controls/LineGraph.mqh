//+------------------------------------------------------------------+
//|                                                    LineGraph.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Class for creating a line chart                                  |
//+------------------------------------------------------------------+
class CLineGraph : public CElement
  {
private:
   //--- Objects for creating the control
   CLineChartObject  m_line_chart;
   //--- Gradient colors
   color             m_back_color2;
   //--- Grid color
   color             m_grid_color;
   //--- Number of decimal places
   int               m_digits;
   //---
public:
                     CLineGraph(void);
                    ~CLineGraph(void);
   //--- Methods for creating the control
   bool              CreateLineGraph(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateGraph(void);
   //---
public:
   //--- (1) The number of decimal places, (2) the maximum number of data series
   void              SetDigits(const int digits)       { m_digits=::fabs(digits);     }
   void              MaxData(const int total)          { m_line_chart.MaxData(total); }
   //--- Two colors for the gradient
   void              BackColor2(const color clr)       { m_back_color2=clr;           }
   void              GridColor(const color clr)        { m_grid_color=clr;            }
   //--- Setting parameters of the vertical scale
   void              VScaleParams(const double max,const double min,const int num_grid);
   //--- Add a series to the chart
   void              SeriesAdd(double &data[],const string descr,const color clr);
   //--- Update the series on the chart
   void              SeriesUpdate(const uint pos,const double &data[],const string descr,const color clr);
   //--- Delete the series from the chart
   void              SeriesDelete(const uint pos);
   //---
public:
   //--- Moving the control
   virtual void      Moving(const bool only_visible=true);
   //--- (1) Show, (2) hide, (3) reset, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //---
private:
   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Change the height at the bottom edge of the window
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CLineGraph::CLineGraph(void) : m_digits(2),
                               m_back_color2(C'0,80,95'),
                               m_grid_color(C'50,55,60')
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CLineGraph::~CLineGraph(void)
  {
  }
//+------------------------------------------------------------------+
//| Create a chart                                                   |
//+------------------------------------------------------------------+
bool CLineGraph::CreateLineGraph(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create control
   if(!CreateGraph())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CLineGraph::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x  =CElement::CalculateX(x_gap);
   m_y  =CElement::CalculateY(y_gap);
//--- Calculate the sizes
   m_x_size =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
//--- Default colors
   m_back_color   =(m_back_color!=clrNONE)? m_back_color : clrBlack;
   m_back_color2  =(m_back_color2!=clrNONE)? m_back_color2 : C'0,80,95';
   m_border_color =(m_border_color!=clrNONE)? m_border_color : clrSilver;
   m_label_color  =(m_label_color!=clrNONE)? m_label_color : clrLightSlateGray;
//--- Store the size
   CElementBase::XSize(m_x_size);
   CElementBase::YSize(m_y_size);
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CLineGraph::CreateGraph(void)
  {
//--- Adjust the sizes
   m_x_size =(m_x_size<1)? 50 : m_x_size;
   m_y_size =(m_y_size<1)? 20 : m_y_size;
//--- Forming the object name
   string name=CElementBase::ElementName("chart");
//--- Creating an object
   if(!m_line_chart.CreateBitmapLabel(m_chart_id,m_subwin,name,m_x,m_y,m_x_size,m_y_size,COLOR_FORMAT_ARGB_NORMALIZE))
      return(false);
//--- Get the pointer to the base class
   CChartObject *chart=::GetPointer(m_line_chart);
//--- Attach the object to the terminal chart
   if(!chart.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- Properties
   m_line_chart.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
   m_line_chart.ScaleDigits(m_digits);
   m_line_chart.ColorBackground(m_back_color);
   m_line_chart.ColorBackground2(m_back_color2);
   m_line_chart.ColorBorder(m_border_color);
   m_line_chart.ColorGrid(::ColorToARGB(m_grid_color));
   m_line_chart.ColorText(::ColorToARGB(m_label_color));
   m_line_chart.Tooltip("\n");
//--- Offsets from the extreme point
   m_line_chart.X(CElementBase::X());
   m_line_chart.Y(CElementBase::Y());
//--- Store the sizes (in the group)
   m_line_chart.XSize(CElementBase::XSize());
   m_line_chart.YSize(CElementBase::YSize());
//--- Offsets from the extreme point
   m_line_chart.XGap(CElement::CalculateXGap(m_x));
   m_line_chart.YGap(CElement::CalculateYGap(m_y));
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting parameters of the Y axis                                 |
//+------------------------------------------------------------------+
void CLineGraph::VScaleParams(const double max,const double min,const int num_grid)
  {
   m_line_chart.VScaleParams(max,min,num_grid);
  }
//+------------------------------------------------------------------+
//| Add series to the chart                                          |
//+------------------------------------------------------------------+
void CLineGraph::SeriesAdd(double &data[],const string descr,const color clr)
  {
   m_line_chart.SeriesAdd(data,descr,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Update series on the chart                                       |
//+------------------------------------------------------------------+
void CLineGraph::SeriesUpdate(const uint pos,const double &data[],const string descr,const color clr)
  {
   m_line_chart.SeriesUpdate(pos,data,descr,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Delete series from the chart                                     |
//+------------------------------------------------------------------+
void CLineGraph::SeriesDelete(const uint pos)
  {
   m_line_chart.SeriesDelete(pos);
  }
//+------------------------------------------------------------------+
//| Moving                                                           |
//+------------------------------------------------------------------+
void CLineGraph::Moving(const bool only_visible=true)
  {
//--- Leave, if the control is hidden
   if(only_visible)
      if(!CElementBase::IsVisible())
         return;
//--- Storing coordinates in the control fields
   CElementBase::X((m_anchor_right_window_side)? m_main.X2()-XGap() : m_main.X()+XGap());
   CElementBase::Y((m_anchor_bottom_window_side)? m_main.Y2()-YGap() : m_main.Y()+YGap());
//--- Storing coordinates in the fields of the objects
   m_line_chart.X((m_anchor_right_window_side)? m_main.X2()-m_line_chart.XGap() : m_main.X()+m_line_chart.XGap());
   m_line_chart.Y((m_anchor_bottom_window_side)? m_main.Y2()-m_line_chart.YGap() : m_main.Y()+m_line_chart.YGap());
//--- Updating coordinates of graphical objects
   m_line_chart.X_Distance(m_line_chart.X());
   m_line_chart.Y_Distance(m_line_chart.Y());
  }
//+------------------------------------------------------------------+
//| Shows a menu item                                                |
//+------------------------------------------------------------------+
void CLineGraph::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Make all the objects visible
   m_line_chart.Timeframes(OBJ_ALL_PERIODS);
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Hides a menu item                                                |
//+------------------------------------------------------------------+
void CLineGraph::Hide(void)
  {
//--- Leave, if the control is hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide all objects
   m_line_chart.Timeframes(OBJ_NO_PERIODS);
//--- Visible state
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CLineGraph::Reset(void)
  {
//--- Leave, if this is a drop-down control
   if(CElementBase::IsDropdown())
      return;
//--- Hide and show
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CLineGraph::Delete(void)
  {
   m_line_chart.DeleteAll();
   m_line_chart.Destroy();
//--- Initializing of variables by default values
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CLineGraph::ChangeWidthByRightWindowSide(void)
  {
//--- Coordinates
   int x=0;
//--- Size
   int x_size=0;
//--- Calculate the size
   x_size=m_main.X2()-m_line_chart.X()-m_auto_xresize_right_offset;
//--- Do not change the size, if it is less than the specified limit
   if(x_size<200)
      return;
//--- Set the new size
   CElementBase::XSize(x_size);
   m_line_chart.XSize(x_size);
   m_line_chart.Resize(x_size,m_line_chart.YSize());
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Change the height at the bottom edge of the window               |
//+------------------------------------------------------------------+
void CLineGraph::ChangeHeightByBottomWindowSide(void)
  {
//--- Coordinates
   int y=0;
//--- Size
   int y_size=0;
//--- Calculate the size
   y_size=m_main.Y2()-m_line_chart.Y()-m_auto_yresize_bottom_offset;
//--- Do not change the size, if it is less than the specified limit
   if(y_size<100)
      return;
//--- Set the new size
   CElementBase::YSize(y_size);
   m_line_chart.YSize(y_size);
   m_line_chart.Resize(m_line_chart.XSize(),y_size);
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
