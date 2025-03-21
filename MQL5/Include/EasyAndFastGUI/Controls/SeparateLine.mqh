//+------------------------------------------------------------------+
//|                                                 SeparateLine.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Class for creating a separation line                             |
//+------------------------------------------------------------------+
class CSeparateLine : public CElement
  {
private:
   //--- Properties
   ENUM_TYPE_SEP_LINE m_type_sep_line;   
   color             m_dark_color;
   color             m_light_color;
   //---
public:
                     CSeparateLine(void);
                    ~CSeparateLine(void);
   //--- Creating a separation line
   bool              CreateSeparateLine(const int index,const int x_gap,const int y_gap,const int x_size,const int y_size);
   //---
private:
   //--- Creates the canvas for drawing a separation line
   bool              CreateSepLine(void);
   //---
public:
   //--- (1) Line type, (2) line colors
   void              TypeSepLine(const ENUM_TYPE_SEP_LINE type) { m_type_sep_line=type; }
   void              DarkColor(const color clr)                 { m_dark_color=clr;     }
   void              LightColor(const color clr)                { m_light_color=clr;    }
   //---
public:
   //--- Draws the control
   virtual void      Draw(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CSeparateLine::CSeparateLine(void) : m_type_sep_line(H_SEP_LINE),
                                     m_dark_color(C'160,160,160'),
                                     m_light_color(clrWhite)
  {
//--- Store the name of the control class in the base class  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CSeparateLine::~CSeparateLine(void)
  {
  }
//+------------------------------------------------------------------+
//| Creates a separation line                                        |
//+------------------------------------------------------------------+
bool CSeparateLine::CreateSeparateLine(const int index,const int x_gap,const int y_gap,const int x_size,const int y_size)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   m_index  =index;
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
   m_x_size =x_size;
   m_y_size =y_size;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
//--- Create control
   if(!CreateSepLine())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Crates the canvas for drawing a separation line                  |
//+------------------------------------------------------------------+
bool CSeparateLine::CreateSepLine(void)
  {
//--- Forming the object name  
   string name=CElementBase::ElementName("separate_line");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
     return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CSeparateLine::Draw(void)
  {
//--- Coordinates for the lines
   int x1=0,x2=0,y1=0,y2=0;
//--- Canvas size
   int   x_size =m_canvas.X_Size()-1;
   int   y_size =m_canvas.Y_Size()-1;
//--- Clear canvas
   m_canvas.Erase(::ColorToARGB(clrNONE,0));
//--- If the line is horizontal
   if(m_type_sep_line==H_SEP_LINE)
     {
      //--- The dark line above
      x1=0; y1=0; x2=x_size; y2=0;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_dark_color));
      //--- The light line below
      x1=0; x2=x_size; y1=y_size; y2=y_size;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_light_color));
     }
//--- If the line is vertical
   else
     {
      //--- The dark line on the left
      x1=0; x2=0; y1=0; y2=y_size;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_dark_color));
      //--- The light line on the right
      x1=x_size; y1=0; x2=x_size; y2=y_size;
      m_canvas.Line(x1,y1,x2,y2,::ColorToARGB(m_light_color));
     }
  }
//+------------------------------------------------------------------+
