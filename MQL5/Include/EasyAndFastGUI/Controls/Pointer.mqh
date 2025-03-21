//+------------------------------------------------------------------+
//|                                                      Pointer.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//--- Resources
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_x_rs.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_x_rs_blue.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_y_rs.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_y_rs_blue.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_xy1_rs.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_xy1_rs_blue.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_xy2_rs.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_xy2_rs_blue.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_x_rs_rel.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_y_rs_rel.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_x_scroll.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_x_scroll_blue.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_y_scroll.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_y_scroll_blue.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\pointer_text_select.bmp"
//+------------------------------------------------------------------+
//| Class for creating the mouse cursor                              |
//+------------------------------------------------------------------+
class CPointer : public CElement
  {
private:
   //--- Icons for cursor
   string            m_file_on;
   string            m_file_off;
   //--- Cursor type
   ENUM_MOUSE_POINTER m_type;
   //--- State of the cursor
   bool              m_state;
   //---
public:
                     CPointer(void);
                    ~CPointer(void);
   //--- Create cursor icon
   bool              CreatePointer(const long chart_id,const int subwin);
   //---
private:
   bool              CreateCanvas(void);
   //---
public:
   //--- Set icons for cursor
   void              FileOn(const string file_path)       { m_file_on=file_path;  }
   void              FileOff(const string file_path)      { m_file_off=file_path; }
   //--- Get and set (1) the cursor type, (2) the cursor state
   ENUM_MOUSE_POINTER Type(void)                    const { return(m_type);       }
   void              Type(ENUM_MOUSE_POINTER type)        { m_type=type;          }
   bool              State(void)                    const { return(m_state);      }
   void              State(const bool state);
   //--- Update coordinates
   void              UpdateX(const int mouse_x)           { m_canvas.X_Distance(mouse_x-CElementBase::XGap()); }
   void              UpdateY(const int mouse_y)           { m_canvas.Y_Distance(mouse_y-CElementBase::YGap()); }
   //---
public:
   //--- Moving the control
   virtual void      Moving(const int mouse_x,const int mouse_y);
   //--- Management
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Set images for the mouse cursor
   void              SetPointerBmp(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CPointer::CPointer(void) : m_state(true),
                           m_file_on(""),
                           m_file_off(""),
                           m_type(MP_X_RESIZE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Default index of the control
   CElement::Index(0);
//--- Transparent background
   m_alpha=0;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CPointer::~CPointer(void)
  {
  }
//+------------------------------------------------------------------+
//| Create cursor                                                    |
//+------------------------------------------------------------------+
bool CPointer::CreatePointer(const long chart_id,const int subwin)
  {
//--- Properties
   m_chart_id =chart_id;
   m_subwin   =subwin;
   m_x_size   =(m_x_size<1)? 16 : m_x_size;
   m_y_size   =(m_y_size<1)? 16 : m_y_size;
//--- Store the pointer to itself
   CElement::MainPointer(this);
//--- Set images for cursor
   SetPointerBmp();
//--- Creates the control
   if(!CreateCanvas())
      return(false);
//--- Hide the control
   Hide();
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CPointer::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("pointer");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Disabled by default
   State(false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the state of the cursor                                  |
//+------------------------------------------------------------------+
void CPointer::State(const bool state)
  {
//--- Leave, if repeating
   if(state==m_state)
      return;
//--- Store the state
   m_state=state;
//--- Store the index of the selected image
   CElement::ChangeImage(0,CElement::SelectedImage());
//--- Draw the image
   Draw();
//--- Apply
   CElement::Update(true);
  }
//+------------------------------------------------------------------+
//| Moving the control                                               |
//+------------------------------------------------------------------+
void CPointer::Moving(const int mouse_x,const int mouse_y)
  {
   UpdateX(mouse_x);
   UpdateY(mouse_y);
  }
//+------------------------------------------------------------------+
//| Shows the control                                                |
//+------------------------------------------------------------------+
void CPointer::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Make all the objects visible  
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Visible state
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Hides the control                                                |
//+------------------------------------------------------------------+
void CPointer::Hide(void)
  {
//--- Leave, if the control is hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide the objects
   m_canvas.Timeframes(OBJ_NO_PERIODS);
//--- Visible state
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Redrawing                                                        |
//+------------------------------------------------------------------+
void CPointer::Reset(void)
  {
//--- Hide and show
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CPointer::Delete(void)
  {
   m_canvas.Delete();
//--- Store the state
   m_state=true;
//--- Visible state
   CElementBase::IsVisible(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CPointer::Draw(void)
  {
//--- Draws the background
   CElement::DrawBackground();
//--- Draw icon
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
//| Set the cursor images based on cursor type                       |
//+------------------------------------------------------------------+
void CPointer::SetPointerBmp(void)
  {
   switch(m_type)
     {
      case MP_X_RESIZE :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_x_rs.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_x_rs_blue.bmp";
         break;
      case MP_Y_RESIZE :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_y_rs.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_y_rs_blue.bmp";
         break;
      case MP_XY1_RESIZE :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_xy1_rs.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_xy1_rs_blue.bmp";
         break;
      case MP_XY2_RESIZE :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_xy2_rs.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_xy2_rs_blue.bmp";
         break;
      case MP_WINDOW_RESIZE :
        {
         CElement::AddImagesGroup(0,0);
         CElement::AddImage(0,"Images\\EasyAndFastGUI\\Controls\\pointer_x_rs.bmp");
         CElement::AddImage(0,"Images\\EasyAndFastGUI\\Controls\\pointer_y_rs.bmp");
         break;
        }
      case MP_X_RESIZE_RELATIVE :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_x_rs_rel.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_x_rs_rel.bmp";
         break;
      case MP_Y_RESIZE_RELATIVE :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_y_rs_rel.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_y_rs_rel.bmp";
         break;
      case MP_X_SCROLL :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_x_scroll.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_x_scroll_blue.bmp";
         break;
      case MP_Y_SCROLL :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_y_scroll.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_y_scroll_blue.bmp";
         break;
      case MP_TEXT_SELECT :
         m_file_on  ="Images\\EasyAndFastGUI\\Controls\\pointer_text_select.bmp";
         m_file_off ="Images\\EasyAndFastGUI\\Controls\\pointer_text_select.bmp";
         break;
     }
//--- If custom type (MP_CUSTOM) is specified
   if(m_type==MP_CUSTOM)
      if(m_file_on=="" || m_file_off=="")
         ::Print(__FUNCTION__," > Icons must be set for the cursor!");
//--- Set the icon
   if(m_type!=MP_WINDOW_RESIZE)
     {
      CElement::IconFile(m_file_on);
      CElement::IconFileLocked(m_file_off);
     }
  }
//+------------------------------------------------------------------+
