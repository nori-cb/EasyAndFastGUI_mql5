//+------------------------------------------------------------------+
//|                                                     CheckBox.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Class for creating a checkbox                                    |
//+------------------------------------------------------------------+
class CCheckBox : public CElement
  {
public:
                     CCheckBox(void);
                    ~CCheckBox(void);
   //--- Methods for creating a checkbox
   bool              CreateCheckBox(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- Button state (pressed/released)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling of the press on the control
   bool              OnClickCheckbox(const string pressed_object);
   //--- Draws the image
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CCheckBox::CCheckBox(void)

  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CCheckBox::~CCheckBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Event Handling                                                   |
//+------------------------------------------------------------------+
void CCheckBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
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
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Pressing on the checkbox
      if(OnClickCheckbox(sparam))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Creates a group of the checkbox objects                          |
//+------------------------------------------------------------------+
bool CCheckBox::CreateCheckBox(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CCheckBox::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 14 : m_y_size;
   m_label_text =text;
//--- Default background color
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Margins and color of the text label
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 18;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
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
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp"
//---
bool CCheckBox::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("checkbox");
//--- Setting the images
   IconFile("Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp");
   IconFileLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp");
   IconFilePressed("Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp");
   IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the control state (pressed/released)                     |
//+------------------------------------------------------------------+
void CCheckBox::IsPressed(const bool state)
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
//| Clicking the control                                             |
//+------------------------------------------------------------------+
bool CCheckBox::OnClickCheckbox(const string pressed_object)
  {
//--- Leave, if (1) it has a different object name or (2) the control is locked
   if(m_canvas.Name()!=pressed_object || CElementBase::IsLocked())
      return(false);
//--- Switch to the opposite state
   IsPressed(!(IsPressed()));
//--- Redraw the control
   Update(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),0,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CCheckBox::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw icon
   CCheckBox::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CCheckBox::DrawImage(void)
  {
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
