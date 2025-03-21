//+------------------------------------------------------------------+
//|                                                  ColorPicker.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextEdit.mqh"
#include "Button.mqh"
#include "ButtonsGroup.mqh"
#include "ColorButton.mqh"
//+------------------------------------------------------------------+
//| Class for creating color picker to select a color                |
//+------------------------------------------------------------------+
class CColorPicker : public CElement
  {
private:
   //--- Pointer to the button that calls the color picker control
   CColorButton     *m_color_button;
   //--- Instances for creating a control
   CButtonsGroup     m_radio_buttons;
   CTextEdit         m_spin_edits[9];
   CButton           m_buttons[2];
   //--- Coordinates
   int               m_pallete_x1;
   int               m_pallete_y1;
   int               m_pallete_x2;
   int               m_pallete_y2;
   //--- Palette sizes
   double            m_pallete_x_size;
   double            m_pallete_y_size;
   //--- Color of the palette frame
   color             m_palette_border_color;
   //--- The (1) current color, (2) selected color and (3) the color specified by the mouse
   color             m_current_color;
   color             m_picked_color;
   color             m_hover_color;
   //--- Component values in different color models:
   //    HSL
   double            m_hsl_h;
   double            m_hsl_s;
   double            m_hsl_l;
   //--- RGB
   double            m_rgb_r;
   double            m_rgb_g;
   double            m_rgb_b;
   //--- Lab
   double            m_lab_l;
   double            m_lab_a;
   double            m_lab_b;
   //--- XYZ
   double            m_xyz_x;
   double            m_xyz_y;
   double            m_xyz_z;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CColorPicker(void);
                    ~CColorPicker(void);
   //--- Methods for creating the control
   bool              CreateColorPicker(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateRadioButtons(void);
   bool              CreateSpinEdits(void);
   bool              CreateButtons(void);
   //---
public:
   //--- Returns pointers to form controls
   CButtonsGroup    *GetRadioButtonsPointer(void) { return(::GetPointer(m_radio_buttons)); }
   CTextEdit        *GetSpinEditPointer(const uint index);
   CButton          *GetButtonPointer(const uint index);
   //--- Store the pointer to the button that calls the color picker
   void              ColorButtonPointer(CColorButton &object);
   //--- Set the color selected by user on the palette
   void              CurrentColor(const color clr);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Get the color under the mouse cursor
   bool              OnHoverColor(const int x,const int y);
   //--- Handling the pressing on the palette
   bool              OnClickPalette(const string clicked_object);
   //--- Handling the pressing on the radio button
   bool              OnClickRadioButton(const uint id,const uint index,const string pressed_object);
   //--- Handling the entering new value in the edit box
   bool              OnEndEdit(const uint id,const uint index,const string pressed_object="");
   //--- Handling the pressing the 'OK' button
   bool              OnClickButtonOK(const uint id,const uint index,const string pressed_object);
   //--- Handling the pressing the 'Cancel' button
   bool              OnClickButtonCancel(const uint id,const uint index,const string pressed_object);

   //--- Draw palette
   void              DrawPalette(const int index);
   //--- Draw palette based on the HSL color model (0: H, 1: S, 2: L)
   void              DrawHSL(const int index);
   //--- Draw palette based on the RGB color model (3: R, 4: G, 5: B)
   void              DrawRGB(const int index);
   //--- Draw palette based on the LAB color model (6: L, 7: a, 8: b)
   void              DrawLab(const int index);
   //--- Draw palette frame
   void              DrawPaletteBorder(void);
   //--- Draws the border of the color markets
   void              DrawSamplesBorder(void);
   //--- Draws the color markers
   void              DrawCurrentSample(void);
   void              DrawPickedSample(void);
   void              DrawHoverSample(void);

   //--- Calculate and set the color components
   void              SetComponents(const int index,const bool fix_selected);
   //--- Set the current parameters in the edit boxes
   void              SetControls(const int index,const bool fix_selected);

   //--- Set the parameters of color models according to (1) HSL, (2) RGB, (3) Lab
   void              SetHSL(void);
   void              SetRGB(void);
   void              SetLab(void);

   //--- Adjust the RGB components
   void              AdjustmentComponentRGB(void);
   //--- Adjust the HSL components
   void              AdjustmentComponentHSL(void);

   //--- Fast scrolling of values in the edit
   void              FastSwitching(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CColorPicker::CColorPicker(void) : m_palette_border_color(clrSilver),
                                   m_current_color(clrGold),
                                   m_picked_color(clrCornflowerBlue),
                                   m_hover_color(clrRed)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CColorPicker::~CColorPicker(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CColorPicker::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Get the color under the mouse cursor
      if(OnHoverColor(m_mouse.X(),m_mouse.Y()))
         return;
      //---
      return;
     }
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- If the palette was pressed
      if(OnClickPalette(sparam))
         return;
      //---
      return;
     }
//--- Handling entering the value in the edit box
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      //--- Check the input of the new value
      if(OnEndEdit((uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
//--- Handle clicking the control
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- If the radio button was clicked
      if(OnClickRadioButton((uint)lparam,(uint)dparam,sparam))
         return;
      //--- Check the input of the new value
      if(OnEndEdit((uint)lparam,(uint)dparam,sparam))
         return;
      //--- If the "OK" button is clicked
      if(OnClickButtonOK((uint)lparam,(uint)dparam,sparam))
         return;
      //--- If the "CANCEL" button is clicked
      if(OnClickButtonCancel((uint)lparam,(uint)dparam,sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CColorPicker::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Create the Color Picker object                                   |
//+------------------------------------------------------------------+
bool CColorPicker::CreateColorPicker(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Create objects of the control
   if(!CreateCanvas())
      return(false);
   if(!CreateRadioButtons())
      return(false);
   if(!CreateSpinEdits())
      return(false);
   if(!CreateButtons())
      return(false);
//--- Calculate the components of all color models and draw the palette according to the selected radio button
   SetComponents(m_radio_buttons.SelectedButtonIndex(),false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CColorPicker::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x_size =348;
   m_y_size =266;
   m_x      =CElement::CalculateX(x_gap);
   m_y      =CElement::CalculateY(y_gap);
//--- Dimensions and coordinates of the palette
   m_pallete_x_size =255.0;
   m_pallete_y_size =255.0;
   m_pallete_x1     =6;
   m_pallete_y1     =5;
   m_pallete_x2     =m_pallete_x1+(int)m_pallete_x_size;
   m_pallete_y2     =m_pallete_y1+(int)m_pallete_y_size;
//--- Default background color
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Default border color
   m_border_color=(m_border_color!=clrNONE)? m_border_color : m_main.BackColor();
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CColorPicker::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("color_picker");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates group of radio buttons                                   |
//+------------------------------------------------------------------+
bool CColorPicker::CreateRadioButtons(void)
  {
//--- Identifier of the last added control
   CElementBase::LastId(m_main.LastId());
//--- Store the pointer to the parent control
   m_radio_buttons.MainPointer(this);
//--- Coordinates
   int x=266,y=35;
//--- Properties
   int    buttons_x_offset[] ={0,0,0,0,0,0,0,0,0};
   int    buttons_y_offset[] ={0,19,38,60,79,98,120,139,158};
   string buttons_text[]     ={"H:","S:","L:","R:","G:","B:","L:","a:","b:"};
   int    buttons_width[9];
   ::ArrayInitialize(buttons_width,35);
//--- Properties
   m_radio_buttons.NamePart("radio_button");
   m_radio_buttons.ButtonYSize(18);
   m_radio_buttons.RadioButtonsMode(true);
   m_radio_buttons.RadioButtonsStyle(true);
   m_radio_buttons.IconYGap(4);
   m_radio_buttons.LabelYGap(4);
   m_radio_buttons.LabelColor(clrBlack);
   m_radio_buttons.LabelColorLocked(clrSilver);
//--- Add radio buttons with the specified properties
   for(int i=0; i<9; i++)
      m_radio_buttons.AddButton(buttons_x_offset[i],buttons_y_offset[i],buttons_text[i],buttons_width[i]);
//--- Create a group of buttons
   if(!m_radio_buttons.CreateButtonsGroup(x,y))
      return(false);
//--- Select the button in the group
   m_radio_buttons.SelectButton(8);
//--- Add the control to the array
   CElement::AddToArray(m_radio_buttons);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates spin edit boxes                                          |
//+------------------------------------------------------------------+
bool CColorPicker::CreateSpinEdits(void)
  {
//--- Coordinates
   int x=297;
   int y[9]={36,55,74,96,115,134,156,175,194};
//---
   int max[9]   ={360,100,100,255,255,255,100,127,127};
   int min[9]   ={0,0,0,0,0,0,0,-128,-128};
   int value[9] ={360,50,100,50,50,50,50,50,50};
//---
   for(int i=0; i<9; i++)
     {
      //--- Store the pointer to the parent control
      m_spin_edits[i].MainPointer(this);
      //--- Properties
      m_spin_edits[i].Index(i);
      m_spin_edits[i].XSize(45);
      m_spin_edits[i].YSize(18);
      m_spin_edits[i].MaxValue(max[i]);
      m_spin_edits[i].MinValue(min[i]);
      m_spin_edits[i].StepValue(1);
      m_spin_edits[i].SetDigits(0);
      m_spin_edits[i].SpinEditMode(true);
      m_spin_edits[i].SetValue((string)value[i]);
      m_spin_edits[i].BackColor(m_back_color);
      m_spin_edits[i].GetTextBoxPointer().XGap(1);
      m_spin_edits[i].GetTextBoxPointer().XSize(m_spin_edits[i].XSize());
      //--- Create control
      if(!m_spin_edits[i].CreateTextEdit("",x,y[i]))
         return(false);
      //--- Offset of text in the text box
      m_spin_edits[i].GetTextBoxPointer().TextYOffset(4);
      //--- Add the control to the array
      CElement::AddToArray(m_spin_edits[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates buttons                                                  |
//+------------------------------------------------------------------+
bool CColorPicker::CreateButtons(void)
  {
   for(int i=0; i<2; i++)
     {
      //--- Store pointer to the form
      m_buttons[i].MainPointer(this);
      //--- Coordinates
      int x =267;
      int y =(i<1)? 218 : 241;
      //---
      string text=(i<1)? "OK" : "Cancel";
      //--- Properties
      m_buttons[i].Index(i+9);
      m_buttons[i].NamePart("button");
      m_buttons[i].XSize(76);
      m_buttons[i].YSize(20);
      m_buttons[i].IsCenterText(true);
      //--- Create control
      if(!m_buttons[i].CreateButton(text,x,y))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(m_buttons[i]);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns pointer to the specified spin edit box                   |
//+------------------------------------------------------------------+
CTextEdit *CColorPicker::GetSpinEditPointer(const uint index)
  {
   uint array_size=::ArraySize(m_spin_edits);
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//---
   return(::GetPointer(m_spin_edits[i]));
  }
//+------------------------------------------------------------------+
//| Returns pointer to the specified button                          |
//+------------------------------------------------------------------+
CButton *CColorPicker::GetButtonPointer(const uint index)
  {
   uint array_size=::ArraySize(m_buttons);
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the pointer
   return(::GetPointer(m_buttons[index]));
  }
//+------------------------------------------------------------------+
//| Store the pointer to the button that calls the color picker and  |
//| open the window it is attached to                                |
//+------------------------------------------------------------------+
void CColorPicker::ColorButtonPointer(CColorButton &object)
  {
//--- Store the button pointer
   m_color_button=::GetPointer(object);
//--- Set the color of the passed button to all palette markers
   CurrentColor(object.CurrentColor());
//--- If the pointer to the window the palette is attached to is valid
   if(::CheckPointer(m_wnd)!=POINTER_INVALID)
     {
      //--- Open the window
      m_wnd.OpenWindow();
     }
//--- Reset the button focus
   object.GetButtonPointer().MouseFocus(false);
   object.GetButtonPointer().Update(true);
  }
//+------------------------------------------------------------------+
//| Set the current color                                            |
//+------------------------------------------------------------------+
void CColorPicker::CurrentColor(const color clr)
  {
   m_hover_color=clr;
   DrawHoverSample();
//---
   m_picked_color=clr;
   DrawPickedSample();
//---
   m_current_color=clr;
   DrawCurrentSample();
  }
//+------------------------------------------------------------------+
//| Get the color under the mouse cursor                             |
//+------------------------------------------------------------------+
bool CColorPicker::OnHoverColor(const int x,const int y)
  {
//--- Leave, if the focus is on the control
   if(!CElementBase::MouseFocus())
      return(false);
//--- Check the focus on the palette
   m_canvas.MouseFocus(x>m_canvas.X()+m_pallete_x1 && x<m_canvas.X()+m_pallete_x2 && 
                       y>m_canvas.Y()+m_pallete_y1 && y<m_canvas.Y()+m_pallete_y2);
//--- Leave, if the focus is on the palette
   if(!m_canvas.MouseFocus())
     {
      m_canvas.Tooltip("\n");
      return(false);
     }
//--- Determine the color on the palette under the mouse cursor
   int lx =x-m_canvas.X();
   int ly =y-m_canvas.Y();
   m_hover_color=(color)::ColorToARGB(m_canvas.PixelGet(lx,ly),0);
//--- Set the color and tooltip to the corresponding sample (marker)
   DrawHoverSample();
//--- Set the tooltip to the palette
   m_canvas.Tooltip(::ColorToString(m_hover_color));
//--- Update the canvas
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the palette                             |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickPalette(const string clicked_object)
  {
//--- Leave, if the object name does not match
   if(clicked_object!=m_canvas.Name())
      return(false);
//--- Set the color and tooltip to the corresponding sample
   m_picked_color=m_hover_color;
   DrawPickedSample();
//--- Calculate and set the color components according to the selected radio button
   SetComponents();
//--- Update the spin edit boxes
   for(int i=0; i<9; i++)
      m_spin_edits[i].GetTextBoxPointer().Update(true);
//--- Update the canvas
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the radio button                        |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickRadioButton(const uint id,const uint index,const string pressed_object)
  {
//--- Leave, if clicking was not on the radio button
   if(::StringFind(pressed_object,m_radio_buttons.NamePart())<0)
      return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id() || index==m_radio_buttons.SelectedButtonIndex())
      return(false);
//--- Update the palette with consideration of the recent changes
   DrawPalette(index);
//--- Update the canvas
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the entering new value in the edit box                  |
//+------------------------------------------------------------------+
bool CColorPicker::OnEndEdit(const uint id,const uint index,const string pressed_object="")
  {
//--- Leave, if clicking was not on the button
   if(pressed_object!="")
      if(::StringFind(pressed_object,"spin")<0)
         return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Calculate and set the color components for all color models 
   SetComponents(index,false);
//--- Update the spin edit boxes
   for(int i=0; i<9; i++)
      m_spin_edits[i].GetTextBoxPointer().Update(true);
//--- Update the canvas
   m_canvas.Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing the 'OK' button                            |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickButtonOK(const uint id,const uint index,const string pressed_object)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,m_buttons[0].NamePart())<0)
      return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id() || index!=m_buttons[0].Index())
      return(false);
//--- Store the selected color
   m_current_color=m_picked_color;
   DrawCurrentSample();
   m_canvas.Update();
//--- If there is a pointer to the button for calling the color picker window
   if(::CheckPointer(m_color_button)!=POINTER_INVALID)
     {
      //--- Set the selected color to the button
      m_color_button.CurrentColor(m_current_color);
      m_color_button.Update(true);
      //--- Close the window
      m_wnd.CloseDialogBox();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CHANGE_COLOR,CElementBase::Id(),CElementBase::Index(),m_color_button.LabelText());
      //--- Reset the pointer
      m_color_button=NULL;
     }
   else
     {
      //--- If there is no pointer and the it is a dialog window,
      //    display a message that there is no pointer to the button for calling the control
      if(m_wnd.WindowType()==W_DIALOG)
         ::Print(__FUNCTION__," > Invalid pointer of the calling control (CColorButton).");
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing the 'Cancel' button                        |
//+------------------------------------------------------------------+
bool CColorPicker::OnClickButtonCancel(const uint id,const uint index,const string pressed_object)
  {
//--- Leave, if clicking was not on the button
   if(::StringFind(pressed_object,m_buttons[1].NamePart())<0)
      return(false);
//--- Leave, if the identifiers do not match
   if(id!=CElementBase::Id() || index!=m_buttons[1].Index())
      return(false);
//--- Close the window, if it is a dialog window
   if(m_wnd.WindowType()==W_DIALOG)
      m_wnd.CloseDialogBox();
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CColorPicker::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
//--- Draw the border of the color markets
   DrawSamplesBorder();
//--- Draw the color markers
   DrawCurrentSample();
   DrawPickedSample();
   DrawHoverSample();
//--- Calculate the components of all color models and
//    draw the palette according to the selected radio button
   SetComponents(m_radio_buttons.SelectedButtonIndex(),false);
  }
//+------------------------------------------------------------------+
//| Draws the border of the color markets                            |
//+------------------------------------------------------------------+
void CColorPicker::DrawSamplesBorder(void)
  {
   uint clr=::ColorToARGB(m_palette_border_color);
//--- Calculate the coordinates
   int x1 =m_pallete_x1+(int)m_pallete_x_size+5;
   int y1 =m_pallete_y1-1;
   int x2 =x1+76;
   int y2 =m_pallete_y1+25;
//--- Draw frame
   m_canvas.Line(x1,y1,x2,y1,clr);
   m_canvas.Line(x1,y2,x2,y2,clr);
   m_canvas.Line(x1,y1,x1,y2,clr);
   m_canvas.Line(x2,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Draws a marker with the current color                            |
//+------------------------------------------------------------------+
void CColorPicker::DrawCurrentSample(void)
  {
   uint clr=::ColorToARGB(m_current_color);
//--- Calculate the coordinates
   int x1 =m_pallete_x1+(int)m_pallete_x_size+6;
   int y1 =m_pallete_y1;
   int x2 =x1+24;
   int y2 =m_pallete_y1+24;
//--- Draw the marker
   m_canvas.FillRectangle(x1,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Draws a marker with the selected color                           |
//+------------------------------------------------------------------+
void CColorPicker::DrawPickedSample(void)
  {
   uint clr=::ColorToARGB(m_picked_color);
//--- Calculate the coordinates
   int x1 =m_pallete_x1+(int)m_pallete_x_size+6+25;
   int y1 =m_pallete_y1;
   int x2 =x1+24;
   int y2 =m_pallete_y1+24;
//--- Draw the marker
   m_canvas.FillRectangle(x1,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Draws a marker with the specified color                          |
//+------------------------------------------------------------------+
void CColorPicker::DrawHoverSample(void)
  {
   uint clr=::ColorToARGB(m_hover_color);
//--- Calculate the coordinates
   int x1 =m_pallete_x1+(int)m_pallete_x_size+6+50;
   int y1 =m_pallete_y1;
   int x2 =x1+24;
   int y2 =m_pallete_y1+24;
//--- Draw the marker
   m_canvas.FillRectangle(x1,y1,x2,y2,clr);
  }
//+------------------------------------------------------------------+
//| Draw palette                                                     |
//+------------------------------------------------------------------+
void CColorPicker::DrawPalette(const int index)
  {
   switch(index)
     {
      //--- HSL (0: H, 1: S, 2: L)
      case 0 : case 1 : case 2 :
        {
         DrawHSL(index);
         break;
        }
      //--- RGB (3: R, 4: G, 5: B)
      case 3 : case 4 : case 5 :
        {
         DrawRGB(index);
         break;
        }
      //--- LAB (6: L, 7: a, 8: b)
      case 6 : case 7 : case 8 :
        {
         DrawLab(index);
         break;
        }
     }
//--- Draw palette frame
   DrawPaletteBorder();
  }
//+------------------------------------------------------------------+
//| Draw HSL palette                                                 |
//+------------------------------------------------------------------+
void CColorPicker::DrawHSL(const int index)
  {
   switch(index)
     {
      //--- Hue (H) - color hue ranging from 0 to 360
      case 0 :
        {
         //--- Calculate the H component
         m_hsl_h=(double)m_spin_edits[0].GetValue()/360.0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Calculate the L-component
            m_hsl_l=ly/m_pallete_y_size;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the S-component
               m_hsl_s=lx/m_pallete_x_size;
               //--- Conversion of the HSL components into the RGB components
               m_clr.HSLtoRGB(m_hsl_h,m_hsl_s,m_hsl_l,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Adjust, if components are out of range
               AdjustmentComponentRGB();
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Saturation (S) - saturation ranging from 0 to 100
      case 1 :
        {
         //--- Calculate the S-component
         m_hsl_s=(double)m_spin_edits[1].GetValue()/100.0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Calculate the L-component
            m_hsl_l=ly/m_pallete_y_size;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the H component
               m_hsl_h=lx/m_pallete_x_size;
               //--- Conversion of the HSL components into the RGB components
               m_clr.HSLtoRGB(m_hsl_h,m_hsl_s,m_hsl_l,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Adjust, if components are out of range
               AdjustmentComponentRGB();
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Lightness (L) - lightness ranging from 0 to 100
      case 2 :
        {
         //--- Calculate the L-component
         m_hsl_l=(double)m_spin_edits[2].GetValue()/100.0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Calculate the S-component
            m_hsl_s=ly/m_pallete_y_size;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the H component
               m_hsl_h=lx/m_pallete_x_size;
               //--- Conversion of the HSL components into the RGB components
               m_clr.HSLtoRGB(m_hsl_h,m_hsl_s,m_hsl_l,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Adjust, if components are out of range
               AdjustmentComponentRGB();
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw RGB palette                                                 |
//+------------------------------------------------------------------+
void CColorPicker::DrawRGB(const int index)
  {
//--- Steps along the X and Y axes for calculation of the RGB components
   double rgb_x_step =255.0/m_pallete_x_size;
   double rgb_y_step =255.0/m_pallete_y_size;
//---
   switch(index)
     {
      //--- Red (R) - red. The color range is from 0 to 255
      case 3 :
        {
         //--- Get the current R-component and zero the B-component
         m_rgb_r =(double)m_spin_edits[3].GetValue();
         m_rgb_b =0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Calculate the B-component and zero the R-component
            m_rgb_g=0;
            m_rgb_b+=rgb_y_step;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the G-component
               m_rgb_g+=rgb_x_step;
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Green (G) - green. The color range is from 0 to 255
      case 4 :
        {
         //--- Get the current G-component and zero the B-component
         m_rgb_g =(double)m_spin_edits[4].GetValue();
         m_rgb_b =0;
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Calculate the B-component and zero the R-component
            m_rgb_r=0;
            m_rgb_b+=rgb_y_step;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the R-component
               m_rgb_r+=rgb_x_step;
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Blue (B) - blue. The color range is from 0 to 255
      case 5 :
        {
         //--- Get the current B-component and zero the G-component
         m_rgb_g =0;
         m_rgb_b =(double)m_spin_edits[5].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<m_pallete_y2; ly++)
           {
            //--- Calculate the G-component and zero the R-component
            m_rgb_r=0;
            m_rgb_g+=rgb_y_step;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the R-component
               m_rgb_r+=rgb_x_step;
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw Lab palette                                                 |
//+------------------------------------------------------------------+
void CColorPicker::DrawLab(const int index)
  {
   switch(index)
     {
      //--- Lightness (L) - lightness ranging from 0 to 100
      case 6 :
        {
         //--- Get the current L-component
         m_lab_l=(double)m_spin_edits[6].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<=m_pallete_y2; ly++)
           {
            //--- Calculate the b-component
            m_lab_b=(ly/m_pallete_y_size*255.0)-128;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the a-component
               m_lab_a=(lx/m_pallete_x_size*255.0)-128;
               //--- Conversion of the Lab components into the RGB components
               m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
               m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Adjust the RGB components
               AdjustmentComponentRGB();
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Chromatic component 'a' - ranges from -128 (green) to 127 (magenta)
      case 7 :
        {
         //--- Get the current a-component
         m_lab_a=(double)m_spin_edits[7].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<=m_pallete_y2; ly++)
           {
            //--- Calculate the b-component
            m_lab_b=(ly/m_pallete_y_size*255.0)-128;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the L-component
               m_lab_l=100.0*lx/m_pallete_x_size;
               //--- Conversion of the Lab components into the RGB components
               m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
               m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Adjust the RGB components
               AdjustmentComponentRGB();
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
      //--- Chromatic component 'b' - ranges from -128 (blue) to 127 (yellow)
      case 8 :
        {
         //--- Get the current b-component
         m_lab_b=(double)m_spin_edits[8].GetValue();
         //---
         for(int ly=m_pallete_y1; ly<=m_pallete_y2; ly++)
           {
            //--- Calculate the a-component
            m_lab_a=(ly/m_pallete_y_size*255.0)-128;
            //---
            for(int lx=m_pallete_x1; lx<m_pallete_x2; lx++)
              {
               //--- Calculate the L-component
               m_lab_l=100.0*lx/m_pallete_x_size;
               //--- Conversion of the Lab components into the RGB components
               m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
               m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
               //--- Adjust the RGB components
               AdjustmentComponentRGB();
               //--- Merge channels
               uint rgb_color=XRGB(m_rgb_r,m_rgb_g,m_rgb_b);
               m_canvas.PixelSet(lx,ly,rgb_color);
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw palette frame                                               |
//+------------------------------------------------------------------+
void CColorPicker::DrawPaletteBorder(void)
  {
   uint clr=::ColorToARGB(m_palette_border_color);
//--- Palette size
   int x1 =m_pallete_x1-1;
   int y1 =m_pallete_y1-1;
   int x2 =m_pallete_x1+(int)m_pallete_x_size;
   int y2 =m_pallete_y1+(int)m_pallete_y_size;
//--- Draw frame
   m_canvas.Line(x1,y1,x2,y1,clr);
   m_canvas.Line(x1,y2,x2,y2,clr);
   m_canvas.Line(x2,y1,x2,y2,clr);
   m_canvas.Line(x1,y1,x1,y2,clr);
  }
//+------------------------------------------------------------------+
//| Calculate and set the color components                           |
//+------------------------------------------------------------------+
void CColorPicker::SetComponents(const int index=0,const bool fix_selected=true)
  {
//--- If it is necessary to adjust the colors according to the component selected by the radio button
   if(fix_selected)
     {
      //--- Split the selected color into the RGB components
      m_rgb_r =m_clr.GetR(m_picked_color);
      m_rgb_g =m_clr.GetG(m_picked_color);
      m_rgb_b =m_clr.GetB(m_picked_color);
      //--- Convert the RGB components into HSL components
      m_clr.RGBtoHSL(m_rgb_r,m_rgb_g,m_rgb_b,m_hsl_h,m_hsl_s,m_hsl_l);
      //--- Adjust the HSL components
      AdjustmentComponentHSL();
      //--- Convert the RGB components into LAB components
      m_clr.RGBtoXYZ(m_rgb_r,m_rgb_g,m_rgb_b,m_xyz_x,m_xyz_y,m_xyz_z);
      m_clr.XYZtoCIELab(m_xyz_x,m_xyz_y,m_xyz_z,m_lab_l,m_lab_a,m_lab_b);
      //--- Set the colors in the edit boxes
      SetControls(m_radio_buttons.SelectedButtonIndex(),true);
      return;
     }
//--- Set the parameter of the color models
   switch(index)
     {
      case 0 : case 1 : case 2 :
         SetHSL();
         break;
      case 3 : case 4 : case 5 :
         SetRGB();
         break;
      case 6 : case 7 : case 8 :
         SetLab();
         break;
     }
//--- Draw the palette according to the selected radio button
   DrawPalette(m_radio_buttons.SelectedButtonIndex());
  }
//+------------------------------------------------------------------+
//| Set the current parameters in the edit boxes                     |
//+------------------------------------------------------------------+
void CColorPicker::SetControls(const int index,const bool fix_selected)
  {
//--- If is necessary to fix the value in the edit box of the selected radio button
   if(fix_selected)
     {
      //--- HSL components
      if(index!=0)
         m_spin_edits[0].SetValue(::DoubleToString(m_hsl_h,0));
      if(index!=1)
         m_spin_edits[1].SetValue(::DoubleToString(m_hsl_s,0));
      if(index!=2)
         m_spin_edits[2].SetValue(::DoubleToString(m_hsl_l,0));
      //--- RGB components
      if(index!=3)
         m_spin_edits[3].SetValue(::DoubleToString(m_rgb_r,0));
      if(index!=4)
         m_spin_edits[4].SetValue(::DoubleToString(m_rgb_g,0));
      if(index!=5)
         m_spin_edits[5].SetValue(::DoubleToString(m_rgb_b,0));
      //--- Lab components
      if(index!=6)
         m_spin_edits[6].SetValue(::DoubleToString(m_lab_l,0));
      if(index!=7)
         m_spin_edits[7].SetValue(::DoubleToString(m_lab_a,0));
      if(index!=8)
         m_spin_edits[8].SetValue(::DoubleToString(m_lab_b,0));
      return;
     }
//--- If is necessary to adjust the values in the edit boxes of all color models
   m_spin_edits[0].SetValue(::DoubleToString(m_hsl_h,0));
   m_spin_edits[1].SetValue(::DoubleToString(m_hsl_s,0));
   m_spin_edits[2].SetValue(::DoubleToString(m_hsl_l,0));
//---
   m_spin_edits[3].SetValue(::DoubleToString(m_rgb_r,0));
   m_spin_edits[4].SetValue(::DoubleToString(m_rgb_g,0));
   m_spin_edits[5].SetValue(::DoubleToString(m_rgb_b,0));
//---
   m_spin_edits[6].SetValue(::DoubleToString(m_lab_l,0));
   m_spin_edits[7].SetValue(::DoubleToString(m_lab_a,0));
   m_spin_edits[8].SetValue(::DoubleToString(m_lab_b,0));
  }
//+------------------------------------------------------------------+
//| Set the parameters of color models according to HSL              |
//+------------------------------------------------------------------+
void CColorPicker::SetHSL(void)
  {
//--- Get the current values of the HSL components
   m_hsl_h =(double)m_spin_edits[0].GetValue();
   m_hsl_s =(double)m_spin_edits[1].GetValue();
   m_hsl_l =(double)m_spin_edits[2].GetValue();
//--- Conversion of the HSL components into the RGB components
   m_clr.HSLtoRGB(m_hsl_h/360.0,m_hsl_s/100.0,m_hsl_l/100.0,m_rgb_r,m_rgb_g,m_rgb_b);
//--- Conversion of the RGB components into the Lab components
   m_clr.RGBtoXYZ(m_rgb_r,m_rgb_g,m_rgb_b,m_xyz_x,m_xyz_y,m_xyz_z);
   m_clr.XYZtoCIELab(m_xyz_x,m_xyz_y,m_xyz_z,m_lab_l,m_lab_a,m_lab_b);
//--- Set the current parameters in the edit boxes
   SetControls(0,false);
  }
//+------------------------------------------------------------------+
//| Set the parameters of color models according to RGB              |
//+------------------------------------------------------------------+
void CColorPicker::SetRGB(void)
  {
//--- Get the current values of the RGB components
   m_rgb_r =(double)m_spin_edits[3].GetValue();
   m_rgb_g =(double)m_spin_edits[4].GetValue();
   m_rgb_b =(double)m_spin_edits[5].GetValue();
//--- Conversion of the RGB components into the HSL components
   m_clr.RGBtoHSL(m_rgb_r,m_rgb_g,m_rgb_b,m_hsl_h,m_hsl_s,m_hsl_l);
//--- Adjust the HSL components
   AdjustmentComponentHSL();
//--- Conversion of the RGB components into the Lab components
   m_clr.RGBtoXYZ(m_rgb_r,m_rgb_g,m_rgb_b,m_xyz_x,m_xyz_y,m_xyz_z);
   m_clr.XYZtoCIELab(m_xyz_x,m_xyz_y,m_xyz_z,m_lab_l,m_lab_a,m_lab_b);
//--- Set the current parameters in the edit boxes
   SetControls(0,false);
  }
//+------------------------------------------------------------------+
//| Set the parameters of color models according to Lab              |
//+------------------------------------------------------------------+
void CColorPicker::SetLab(void)
  {
//--- Get the current values of the Lab components
   m_lab_l =(double)m_spin_edits[6].GetValue();
   m_lab_a =(double)m_spin_edits[7].GetValue();
   m_lab_b =(double)m_spin_edits[8].GetValue();
//--- Conversion of the Lab components into the RGB components
   m_clr.CIELabToXYZ(m_lab_l,m_lab_a,m_lab_b,m_xyz_x,m_xyz_y,m_xyz_z);
   m_clr.XYZtoRGB(m_xyz_x,m_xyz_y,m_xyz_z,m_rgb_r,m_rgb_g,m_rgb_b);
//--- Adjust the RGB components
   AdjustmentComponentRGB();
//--- Conversion of the RGB components into the HSL components
   m_clr.RGBtoHSL(m_rgb_r,m_rgb_g,m_rgb_b,m_hsl_h,m_hsl_s,m_hsl_l);
//--- Adjust the HSL components
   AdjustmentComponentHSL();
//--- Set the current parameters in the edit boxes
   SetControls(0,false);
  }
//+------------------------------------------------------------------+
//| Adjustment of the RGB components                                 |
//+------------------------------------------------------------------+
void CColorPicker::AdjustmentComponentRGB(void)
  {
   m_rgb_r=::fmin(::fmax(m_rgb_r,0),255);
   m_rgb_g=::fmin(::fmax(m_rgb_g,0),255);
   m_rgb_b=::fmin(::fmax(m_rgb_b,0),255);
  }
//+------------------------------------------------------------------+
//| Adjustment of the HSL components                                 |
//+------------------------------------------------------------------+
void CColorPicker::AdjustmentComponentHSL(void)
  {
   m_hsl_h*=360;
   m_hsl_s*=100;
   m_hsl_l*=100;
  }
//+------------------------------------------------------------------+
//| Fast scrolling of values in the edit                             |
//+------------------------------------------------------------------+
void CColorPicker::FastSwitching(void)
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
      //--- Determination of the activated counter of the activated radio button
      int index=WRONG_VALUE;
      //---
      for(int i=0; i<9; i++)
        {
         if(m_radio_buttons.SelectedButtonIndex()==i && 
            (m_spin_edits[i].GetIncButtonPointer().MouseFocus() || m_spin_edits[i].GetDecButtonPointer().MouseFocus()))
           {
            index=i;
            break;
           }
        }
      //--- If so, update the palette
      if(index!=WRONG_VALUE)
        {
         DrawPalette(index);
         //--- Update the canvas
         m_canvas.Update();
        }
      //--- Determine the activated counter
      index=WRONG_VALUE;
      //---
      for(int i=0; i<9; i++)
        {
         if(m_spin_edits[i].GetIncButtonPointer().MouseFocus() || m_spin_edits[i].GetDecButtonPointer().MouseFocus())
           {
            index=i;
            break;
           }
        }
      //--- If so, recalculate the components of all color models and update the palette
      if(index!=WRONG_VALUE)
        {
         SetComponents(index,false);
         //--- Update the canvas
         m_canvas.Update();
        }
     }
  }
//+------------------------------------------------------------------+
