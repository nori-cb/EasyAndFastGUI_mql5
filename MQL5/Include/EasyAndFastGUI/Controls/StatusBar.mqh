//+------------------------------------------------------------------+
//|                                                    StatusBar.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextLabel.mqh"
#include "SeparateLine.mqh"
//+------------------------------------------------------------------+
//| Class for creating the status bar                                |
//+------------------------------------------------------------------+
class CStatusBar : public CElement
  {
private:
   //--- Objects for creating the control
   CTextLabel        m_items[];
   CSeparateLine     m_sep_line[];
   //---
public:
                     CStatusBar(void);
                    ~CStatusBar(void);
   //--- Methods for creating the status bar
   bool              CreateStatusBar(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateItems(void);
   bool              CreateSeparateLine(const int line_index);
   //---
public:
   //--- Returns the pointer of the item and the separation line
   CTextLabel       *GetItemPointer(const uint index);
   CSeparateLine    *GetSeparateLinePointer(const uint index);
   //--- (1) Number of items and (2) separation lines
   int               ItemsTotal(void)         const { return(::ArraySize(m_items));    }
   int               SeparateLinesTotal(void) const { return(::ArraySize(m_sep_line)); }
   //--- Adds the item with specified properties before creating the status bar
   void              AddItem(const int width);
   //--- Setting the value by the specified index
   void              SetValue(const uint index,const string value);
   //---
public:
   //--- Deleting
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Calculating the width of control
   int               CalculationXSize(void);
   //--- Calculating the width of the first item
   int               CalculationFirstItemXSize(void);
   //--- Calculation of the X coordinate of the item
   int               CalculationItemX(const int item_index=0);
   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CStatusBar::CStatusBar(void)
  {
//--- Store the name of the control class in the base class  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CStatusBar::~CStatusBar(void)
  {
  }
//+------------------------------------------------------------------+
//| Creates the status bar                                           |
//+------------------------------------------------------------------+
bool CStatusBar::CreateStatusBar(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Creates the control
   if(!CreateCanvas())
      return(false);
   if(!CreateItems())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CStatusBar::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =CalculationXSize();
   m_y_size   =(m_y_size<1)? 22 : m_y_size;
//--- Default properties
   m_back_color   =(m_back_color!=clrNONE)? m_back_color : C'225,225,225';
   m_border_color =(m_border_color!=clrNONE)? m_border_color : m_back_color;
   m_label_color  =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap  =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap  =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CStatusBar::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("statusbar");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a list of status bar items                               |
//+------------------------------------------------------------------+
bool CStatusBar::CreateItems(void)
  {
   int x=0,y=0;
//--- Get the number of items
   int items_total=ItemsTotal();
//--- If there are no items in the group, report and leave
   if(items_total<1)
     {
      ::Print(__FUNCTION__," > This method is to be called, "
              "if a group contains at least one item! Use the CStatusBar::AddItem() method");
      return(false);
     }
//--- If the width of the first item is not set, then calculate it in relation to the total width of other items
   if(m_items[0].XSize()<1)
      m_items[0].XSize(CalculationFirstItemXSize());
//--- Create specified number of items
   for(int i=0; i<items_total; i++)
     {
      //--- Store the pointer to the parent control
      m_items[i].MainPointer(this);
      //--- X coordinate
      x=(i>0)? x+m_items[i-1].XSize() : 0;
      //--- Properties
      m_items[i].Index(i);
      m_items[i].YSize(m_y_size);
      m_items[i].Font(CElement::Font());
      m_items[i].FontSize(CElement::FontSize());
      m_items[i].LabelXGap(m_items[i].LabelXGap()<0? 7 : m_items[i].LabelXGap());
      m_items[i].LabelYGap(m_items[i].LabelYGap()<0? 5 : m_items[i].LabelYGap());
      //--- Creating an object
      if(!m_items[i].CreateTextLabel(m_items[i].LabelText(),x,y))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_items[i]);
     }
//--- Creating separation lines
   for(int i=1; i<items_total; i++)
      CreateSeparateLine(i);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates a separation line                                        |
//+------------------------------------------------------------------+
bool CStatusBar::CreateSeparateLine(const int line_index)
  {
//--- Lines are set starting from the second (1) item
   if(line_index<1)
      return(false);
//--- Coordinates
   int x =m_items[line_index].XGap();
   int y =3;
//--- Adjustment of the index
   int i=line_index-1;
//--- Increasing the array of lines by one element
   int array_size=::ArraySize(m_sep_line);
   ::ArrayResize(m_sep_line,array_size+1);
//--- Store the form pointer
   m_sep_line[i].MainPointer(this);
//--- Properties
   m_sep_line[i].TypeSepLine(V_SEP_LINE);
//--- Creating a line
   if(!m_sep_line[i].CreateSeparateLine(line_index,x,y,2,m_y_size-6))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_sep_line[i]);
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns a menu item pointer by the index                         |
//+------------------------------------------------------------------+
CTextLabel *CStatusBar::GetItemPointer(const uint index)
  {
   uint array_size=::ArraySize(m_items);
//--- If there is no item in the context menu, report
   if(array_size<1)
      ::Print(__FUNCTION__," > This method is to be called, if the there is at least one item!");
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_items[i]));
  }
//+------------------------------------------------------------------+
//| Returns a pointer to the separation line by index                |
//+------------------------------------------------------------------+
CSeparateLine *CStatusBar::GetSeparateLinePointer(const uint index)
  {
   uint array_size=::ArraySize(m_sep_line);
//--- If there is no item in the context menu, report
   if(array_size<1)
      return(NULL);
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_sep_line[i]));
  }
//+------------------------------------------------------------------+
//| Adds a menu item                                                 |
//+------------------------------------------------------------------+
void CStatusBar::AddItem(const int width)
  {
//--- Increase the array size by one element
   int array_size=::ArraySize(m_items);
   ::ArrayResize(m_items,array_size+1);
//--- Store the value of passed parameters
   m_items[array_size].XSize(width);
  }
//+------------------------------------------------------------------+
//| Setting the value by the specified index                         |
//+------------------------------------------------------------------+
void CStatusBar::SetValue(const uint index,const string value)
  {
//--- Checking for exceeding the array range
   uint array_size=::ArraySize(m_items);
   if(array_size<1)
      return;
//--- Adjust the index value if the array range is exceeded
   uint correct_index=(index>=array_size)? array_size-1 : index;
//--- Setting the passed text
   m_items[correct_index].LabelText(value);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CStatusBar::Delete(void)
  {
   CElement::Delete();
//--- Emptying the control arrays
   ::ArrayFree(m_items);
   ::ArrayFree(m_sep_line);
  }
//+------------------------------------------------------------------+
//| Calculating the width of control                                 |
//+------------------------------------------------------------------+
int CStatusBar::CalculationXSize(void)
  {
   return((m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size);
  }
//+------------------------------------------------------------------+
//| Calculating the width of the first item                          |
//+------------------------------------------------------------------+
int CStatusBar::CalculationFirstItemXSize(void)
  {
   int width=0;
//--- Get the number of items
   int items_total=ItemsTotal();
   if(items_total<1)
      return(0);
//--- Calculate the width relative to the total width of the other items
   for(int i=1; i<items_total; i++)
      width+=m_items[i].XSize();
//---
   return(m_x_size-width);
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CStatusBar::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Coordinates and width
   int x=0;
//--- Calculate and set the new total size
   int x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Calculate and set the new size of the first item
   x_size=CalculationFirstItemXSize();
   m_items[0].XSize(x_size);
   m_items[0].CanvasPointer().XSize(x_size);
   m_items[0].CanvasPointer().Resize(x_size,m_y_size);
   m_items[0].Update(true);
//--- Get the number of items
   int items_total=ItemsTotal();
//--- Set the coordinate and offset for all items except the first
   for(int i=1; i<items_total; i++)
     {
      x=x+m_items[i-1].XSize();
      m_items[i].XGap(x);
      m_sep_line[i-1].XGap(x);
      m_items[i].CanvasPointer().XGap(x);
      m_sep_line[i-1].CanvasPointer().XGap(x);
     }
//--- Redraw the control
   Draw();
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CStatusBar::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
  }
//+------------------------------------------------------------------+
