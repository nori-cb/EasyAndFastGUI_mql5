//+------------------------------------------------------------------+
//|                                                       Button.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
//+------------------------------------------------------------------+
//| Class for Creating an Icon Button                                |
//+------------------------------------------------------------------+
class CButton : public CElement
  {
private:
   //--- Mode of two button states
   bool              m_two_state;
   //---
public:
                     CButton(void);
                    ~CButton(void);
   //--- Methods for creating a button
   bool              CreateButton(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   //---
public:
   //--- (1) Setting the mode button, (2) button state (pressed/released)
   bool              TwoState(void)                       const { return(m_two_state);  }
   void              TwoState(const bool flag)                  { m_two_state=flag;     }
   bool              IsPressed(void)                      const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //--- Setting icons for the button in the pressed state (available/locked)
   void              IconFilePressed(const string file_path);
   void              IconFilePressedLocked(const string file_path);
   //--- Resizing
   void              ChangeSize(const uint x_size,const uint y_size);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Draws the control
   virtual void      Draw(void);
   //---
protected:
   //--- Draws the background
   virtual void      DrawBackground(void);
   //--- Draws the frame
   virtual void      DrawBorder(void);
   //--- Draws the image
   virtual void      DrawImage(void);
   //---
private:
   //--- Handling the pressing of a button
   bool              OnClickButton(const string pressed_object);
   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CButton::CButton(void) : m_two_state(false)
  {
//--- Store the name of the control class in the base class  
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CButton::~CButton(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CButton::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Redraw the control if borders were crossed
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickButton(sparam))
         return;
      //---
      return;
     }
//--- Handling the event of changing the state of the left mouse button
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_MOUSE_LEFT_BUTTON)
     {
      if(!CElementBase::MouseFocus())
         return;
      //--- Redraw the control
      Update(true);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates the control                                              |
//+------------------------------------------------------------------+
bool CButton::CreateButton(const string text,const int x_gap,const int y_gap)
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
void CButton::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Default background color
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrGainsboro;
   m_back_color_hover   =(m_back_color_hover!=clrNONE)? m_back_color_hover : C'229,241,251';
   m_back_color_locked  =(m_back_color_locked!=clrNONE)? m_back_color_locked : clrLightGray;
   m_back_color_pressed =(m_back_color_pressed!=clrNONE)? m_back_color_pressed : C'204,228,247';
//--- Default border color
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : C'0,120,215';
   m_border_color_locked  =(m_border_color_locked!=clrNONE)? m_border_color_locked : clrDarkGray;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : C'0,84,153';
//--- Margins and color of the text label and icon
   m_icon_x_gap          =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
   m_icon_y_gap          =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 24;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrBlack;
   m_label_color_locked  =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrGray;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrBlack;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CButton::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("button");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the button state - pressed/released                      |
//+------------------------------------------------------------------+
void CButton::IsPressed(const bool state)
  {
//--- Leave, if (1) two-state mode is disabled or (2) the control is locked or (3) the button is already in that state
   if(!m_two_state || CElementBase::IsLocked() || m_is_pressed==state)
      return;
//--- Setting the state
   m_is_pressed=state;
//--- Set the corresponding icon
   CElement::ChangeImage(0,!m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Setting the icon for the pressed state (available)               |
//+------------------------------------------------------------------+
void CButton::IconFilePressed(const string file_path)
  {
//--- Leave, if the two-state mode is disabled for the button
   if(!m_two_state)
      return;
//--- Add an icon
   CElement::IconFilePressed(file_path);
  }
//+------------------------------------------------------------------+
//| Setting the icon for the pressed state (locked)                  |
//+------------------------------------------------------------------+
void CButton::IconFilePressedLocked(const string file_path)
  {
//--- Leave, if the two-state mode is disabled for the button
   if(!m_two_state)
      return;
//--- Add an icon
   CElement::IconFilePressedLocked(file_path);
  }
//+------------------------------------------------------------------+
//| Resize                                                           |
//+------------------------------------------------------------------+
void CButton::ChangeSize(const uint x_size,const uint y_size)
  {
   int images_group=(int)ImagesGroupTotal();
   for(int i=0; i<images_group; i++)
     {
      int right_gap =m_x_size-ImageGroupXGap(i);
      ImageGroupXGap(i,(int)x_size-right_gap);
     }
//--- Set the new size
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
  }
//+------------------------------------------------------------------+
//| Pressing the button                                              |
//+------------------------------------------------------------------+
bool CButton::OnClickButton(const string pressed_object)
  {
//--- Leave, if (1) it has a different object name or (2) the control is locked
   if(m_canvas.Name()!=pressed_object || CElementBase::IsLocked())
      return(false);
//--- if this is a button with two states
   if(m_two_state)
      IsPressed(!IsPressed());
//--- Redraw the control
   Update(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),CElementBase::Index(),m_canvas.Name());
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CButton::Draw(void)
  {
//--- Draw the background
   DrawBackground();
//--- Draw frame
   DrawBorder();
//--- Draw icon
   DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the background                                             |
//+------------------------------------------------------------------+
void CButton::DrawBackground(void)
  {
//--- Determine the color
   uint clr=(m_is_pressed)? m_back_color_pressed : m_back_color;
//--- If the control is not locked
   if(!CElementBase::IsLocked())
     {
      if(CElementBase::MouseFocus())
         clr=(m_mouse.LeftButtonState() || m_is_pressed)? m_back_color_pressed : m_back_color_hover;
     }
   else
      clr=m_back_color_locked;
//--- Draw the background
   CElement::m_canvas.Erase(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Draws the frame of the Text box                                  |
//+------------------------------------------------------------------+
void CButton::DrawBorder(void)
  {
//--- Determine the color
   uint clr=(m_is_pressed)? m_border_color_pressed : m_border_color;
//--- If the control is not locked
   if(!CElementBase::IsLocked())
     {
      if(CElementBase::MouseFocus())
         clr=(m_mouse.LeftButtonState() || m_is_pressed)? m_border_color_pressed : m_border_color_hover;
     }
   else
      clr=m_border_color_locked;
//--- Coordinates
   int x1=0,y1=0;
   int x2=m_canvas.X_Size()-1;
   int y2=m_canvas.Y_Size()-1;
//--- Draw a rectangle without fill
   m_canvas.Rectangle(x1,y1,x2,y2,::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CButton::DrawImage(void)
  {
//--- Determine the index
   uint image_index=(!m_two_state)? 0 :(m_is_pressed)? 2 : 0;
//--- If the control is not locked
   if(!CElementBase::IsLocked())
     {
      if(!m_two_state)
         image_index=0;
      else
        {
         if(CElementBase::MouseFocus())
            image_index=(m_mouse.LeftButtonState() || m_is_pressed)? 2 : 0;
        }
     }
   else
      image_index=(!m_two_state)? 1 :(m_is_pressed)? 3 : 1;
//--- Store the index of the selected image
   CElement::ChangeImage(0,image_index);
//--- Draw the image
   CElement::DrawImage();
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CButton::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Coordinates
   int x=0;
//--- Size
   int x_size =m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Set the new size
   m_canvas.Resize(x_size,y_size);
//--- Redraw the control
   Draw();
  }
//+------------------------------------------------------------------+
