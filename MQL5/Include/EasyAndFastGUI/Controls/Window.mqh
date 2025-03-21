//+------------------------------------------------------------------+
//|                                                       Window.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\ElementBase.mqh"
#include "Button.mqh"
#include "Pointer.mqh"
//+------------------------------------------------------------------+
//| The Form Class for Controls                                      |
//+------------------------------------------------------------------+
class CWindow : public CElement
  {
private:
   //--- Objects for creating a form
   CButton           m_button_close;
   CButton           m_button_fullscreen;
   CButton           m_button_collapse;
   CButton           m_button_tooltip;
   CPointer          m_xy_resize;
   //--- Index of the previously active window
   int               m_prev_active_window_index;
   //--- Possibility to move a window over the chart
   bool              m_is_movable;
   //--- Status of the minimized window
   bool              m_is_minimized;
   //--- Status of the window in full screen mode
   bool              m_is_fullscreen;
   //--- Last coordinates and dimensions of the window before switching to full screen
   int               m_last_x;
   int               m_last_y;
   int               m_last_x_size;
   int               m_last_y_size;
   bool              m_last_auto_xresize;
   bool              m_last_auto_yresize;
   //--- Minimum window size
   int               m_minimum_x_size;
   int               m_minimum_y_size;
   //--- Window type
   ENUM_WINDOW_TYPE  m_window_type;
   //--- Mode of a set height of the sub-window (for indicators)
   bool              m_height_subwindow_mode;
   //--- Mode of the form minimization in the indicator sub-window
   bool              m_rollup_subwindow_mode;
   //--- Height of the indicator sub-window
   int               m_subwindow_height;
   //--- Total height of the form
   int               m_full_height;
   //--- Header height
   int               m_caption_height;
   //--- Header colors
   color             m_caption_color;
   color             m_caption_color_hover;
   color             m_caption_color_locked;
   //--- Enables transparency only for the header
   bool              m_transparent_only_caption;
   //--- Presence of the button for (1) closing, (2) maximizing the window to full screen, (3) minimizing the window
   bool              m_close_button;
   bool              m_fullscreen_button;
   bool              m_collapse_button;
   //--- Presence of the button for the tooltip display mode
   bool              m_tooltips_button;
   bool              m_tooltips_button_state;
   //--- Chart size
   int               m_chart_width;
   int               m_chart_height;
   //--- For identifying the capture area boundaries in the window header
   int               m_right_limit;
   //--- Variables related to window movement
   int               m_prev_x;
   int               m_prev_y;
   int               m_size_fixing_x;
   int               m_size_fixing_y;
   //--- State of the mouse button considering the position where it was clicked
   ENUM_MOUSE_STATE  m_clamping_area_mouse;
   //--- Window resizing mode
   bool              m_xy_resize_mode;
   //--- Index of the border for resizing the window
   int               m_resize_mode_index;
   //--- Variables related to resizing the window
   int               m_x_fixed;
   int               m_size_fixed;
   int               m_point_fixed;
   //--- For managing the State of the Chart
   bool              m_custom_event_chart_state;
   //---
public:
                     CWindow(void);
                    ~CWindow(void);
   //--- Methods for creating a window
   bool              CreateWindow(const long chart_id,const int window,const string caption_text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const long chart_id,const int subwin,const string caption_text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButtons(void);
   bool              CreateResizePointer(void);
   //---
public:
   //--- Returns pointers to form buttons
   CButton          *GetCloseButtonPointer(void)                     { return(::GetPointer(m_button_close));      }
   CButton          *GetFullscreenButtonPointer(void)                { return(::GetPointer(m_button_fullscreen)); }
   CButton          *GetCollapseButtonPointer(void)                  { return(::GetPointer(m_button_collapse));   }
   CButton          *GetTooltipButtonPointer(void)                   { return(::GetPointer(m_button_tooltip));    }
   //--- (1) Getting and storing the index of the previously active window
   int               PrevActiveWindowIndex(void)               const { return(m_prev_active_window_index);        }
   void              PrevActiveWindowIndex(const int index)          { m_prev_active_window_index=index;          }
   //--- (1) Window type, (2) limitation of the capture area of the header
   ENUM_WINDOW_TYPE  WindowType(void)                          const { return(m_window_type);                     }
   void              WindowType(const ENUM_WINDOW_TYPE flag)         { m_window_type=flag;                        }
   void              RightLimit(const int value)                     { m_right_limit=value;                       }
   //--- Header height
   void              CaptionHeight(const int height)                 { m_caption_height=height;                   }
   int               CaptionHeight(void)                       const { return(m_caption_height);                  }
   //--- (1) Header color, (2) enables transparency mode only for the header
   void              CaptionColor(const color clr)                   { m_caption_color=clr;                       }
   void              CaptionColorHover(const color clr)              { m_caption_color_hover=clr;                 }
   void              CaptionColorLocked(const color clr)             { m_caption_color_locked=clr;                }
   void              TransparentOnlyCaption(const bool state)        { m_transparent_only_caption=state;          }
   //--- (1) Use the button for closing the window, (2) use the full screen button,
   //    (3) use the button for minimizing/maximizing the window, (4) use the tooltip button
   void              CloseButtonIsUsed(const bool state)             { m_close_button=state;                      }
   bool              CloseButtonIsUsed(void)                   const { return(m_close_button);                    }
   void              FullscreenButtonIsUsed(const bool state)        { m_fullscreen_button=state;                 }
   bool              FullscreenButtonIsUsed(void)              const { return(m_fullscreen_button);               }
   void              CollapseButtonIsUsed(const bool state)          { m_collapse_button=state;                   }
   bool              CollapseButtonIsUsed(void)                const { return(m_collapse_button);                 }
   void              TooltipsButtonIsUsed(const bool state)          { m_tooltips_button=state;                   }
   bool              TooltipsButtonIsUsed(void)                const { return(m_tooltips_button);                 }
   //--- (1) Checking the tooltip display mode
   void              TooltipButtonState(const bool state)            { m_tooltips_button_state=state;             }
   bool              TooltipButtonState(void)                  const { return(m_tooltips_button_state);           }
   //--- Possibility of moving the window
   bool              IsMovable(void)                           const { return(m_is_movable);                      }
   void              IsMovable(const bool state)                     { m_is_movable=state;                        }
   //--- (1) State of the minimized window, (2) returns the area, where the left mouse button was pressed down
   bool              IsMinimized(void)                         const { return(m_is_minimized);                    }
   void              IsMinimized(const bool state)                   { m_is_minimized=state;                      }
   ENUM_MOUSE_STATE  ClampingAreaMouse(void)                   const { return(m_clamping_area_mouse);             }
   //--- Setting the minimum window size
   void              MinimumXSize(const int x_size)                  { m_minimum_x_size=x_size;                   }
   void              MinimumYSize(const int y_size)                  { m_minimum_y_size=y_size;                   }
   //--- Ability to resize the window
   bool              ResizeMode(void)                          const { return(m_xy_resize_mode);                  }
   void              ResizeMode(const bool state)                    { m_xy_resize_mode=state;                    }
   //--- Status of the window resizing process
   bool              ResizeState(void) const { return(m_resize_mode_index!=WRONG_VALUE && m_mouse.LeftButtonState()); }

   //--- Default label
   string            DefaultIcon(void);
   //--- Setting the state of the window
   void              State(const bool flag);
   //--- The indicator sub-window minimization mode
   void              RollUpSubwindowMode(const bool flag,const bool height_mode);
   //--- Managing sizes
   void              ChangeWindowWidth(const int width);
   void              ChangeWindowHeight(const int height);
   //--- Changes the height of the indicator sub-window
   void              ChangeSubwindowHeight(const int height);

   //--- Getting the chart size
   void              SetWindowProperties(void);
   //--- Checking the cursor in the header area 
   bool              CursorInsideCaption(const int x,const int y);
   //--- Zeroing variables
   void              ZeroMoveVariables(void);
   void              ZeroResizeVariables(void);

   //--- Verifying the state of the left mouse button
   void              CheckMouseButtonState(void);
   //--- Setting the chart mode
   void              SetChartState(void);
   //--- Updating the form coordinates
   void              UpdateWindowXY(const int x,const int y);
   //--- Custom flag for managing the chart properties
   void              CustomEventChartState(const bool state) { m_custom_event_chart_state=state; }

   //--- Open the window
   void              OpenWindow(void);
   //--- Closing the main window
   void              CloseWindow(void);
   //--- Closing a dialog window
   void              CloseDialogBox(void);
   //--- Changing the window state
   void              ChangeWindowState(void);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Moving the control
   virtual void      Moving(const int x,const int y);
   //--- Showing, hiding, resetting, deleting
   virtual void      Show(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handling the event of clicking the "Close window" button
   bool              OnClickCloseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //--- Switch to full screen or to previous window size
   bool              OnClickFullScreenButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //--- Handling the event of clicking the "Minimize window" button
   bool              OnClickCollapseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE);
   //--- Handling the event of clicking on the Tooltips button
   bool              OnClickTooltipsButton(const uint id,const uint index);

   //--- Methods for (1) minimizing and (2) maximizing the window
   void              Collapse(void);
   void              Expand(void);

   //--- Controls the window sizes
   void              ResizeWindow(void);
   //--- Check the readiness to resize the window
   bool              CheckResizePointer(const int x,const int y);
   //--- Returns the index of the window resizing mode
   int               ResizeModeIndex(const int x,const int y);
   //--- Updating the window sizes
   void              UpdateSize(const int x,const int y);
   //--- Check dragging of the window border
   int               CheckDragWindowBorder(const int x,const int y);
   //--- Calculating and resizing the window
   void              CalculateAndResizeWindow(const int distance);

   //--- Draws the background
   virtual void      DrawBackground(void);
   //--- Draws the foreground
   virtual void      DrawForeground(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CWindow::CWindow(void) : m_right_limit(0),
                         m_caption_height(20),
                         m_caption_color(C'0,130,225'),
                         m_caption_color_hover(C'0,130,225'),
                         m_caption_color_locked(clrLightSkyBlue),
                         m_transparent_only_caption(true),
                         m_prev_active_window_index(0),
                         m_subwindow_height(0),
                         m_rollup_subwindow_mode(false),
                         m_height_subwindow_mode(false),
                         m_is_movable(false),
                         m_x_fixed(0),
                         m_size_fixed(0),
                         m_point_fixed(0),
                         m_xy_resize_mode(false),
                         m_resize_mode_index(WRONG_VALUE),
                         m_is_minimized(false),
                         m_is_fullscreen(false),
                         m_last_x(0),
                         m_last_y(0),
                         m_last_x_size(0),
                         m_last_y_size(0),
                         m_minimum_x_size(0),
                         m_minimum_y_size(0),
                         m_last_auto_xresize(false),
                         m_last_auto_yresize(false),
                         m_close_button(true),
                         m_fullscreen_button(false),
                         m_collapse_button(false),
                         m_tooltips_button(false),
                         m_tooltips_button_state(false),
                         m_window_type(W_MAIN),
                         m_clamping_area_mouse(NOT_PRESSED)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Get the chart window size
   SetWindowProperties();
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CWindow::~CWindow(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CWindow::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Leave, if the form is in another subwindow of the chart
      if(!CElementBase::CheckSubwindowNumber())
        {
         //--- IF the chart scrolling is disabled
         if(!m_chart.GetInteger(CHART_MOUSE_SCROLL))
           {
            //--- Zeroing
            ZeroMoveVariables();
            CElementBase::MouseFocus(false);
            //--- Set the chart state
            m_chart.MouseScroll(true);
            m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,true);
           }
         //---
         return;
        }
      //--- Verifying the mouse focus
      CElementBase::CheckMouseFocus();
      //--- Check and save the state of the mouse button
      CheckMouseButtonState();
      //--- Set the chart state
      SetChartState();
      //--- Leave, if the form is locked
      if(CElementBase::IsLocked())
         return;
      //--- If the control is passed to the window
      if(m_clamping_area_mouse==PRESSED_INSIDE_HEADER)
        {
         //--- Leave, if numbers of subwindows do not match
         if(CElementBase::m_subwin!=CElementBase::m_mouse.SubWindowNumber())
            return;
         //--- Updating window coordinates
         UpdateWindowXY(m_mouse.X(),m_mouse.Y());
         return;
        }
      //--- Resizing the window
      ResizeWindow();
      return;
     }
//--- Handling event of clicking on the chart
   if(id==CHARTEVENT_CLICK)
     {
      //--- Get the chart window size
      SetWindowProperties();
      return;
     }
//--- Handling the event of double-clicking an object
   if(id==CHARTEVENT_CUSTOM+ON_DOUBLE_CLICK)
     {
      //--- If the event was generated in the window title
      if(CursorInsideCaption(m_mouse.X(),m_mouse.Y()))
         OnClickFullScreenButton(m_button_fullscreen.Id(),m_button_fullscreen.Index());
      //---
      return;
     }
//--- Handling the even of clicking the form buttons
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Close the window
      if(OnClickCloseButton((uint)lparam,(uint)dparam))
         return;
      //--- Check for full screen mode
      if(OnClickFullScreenButton((uint)lparam,(uint)dparam))
         return;
      //--- Minimize/Maximize the window
      if(OnClickCollapseButton((uint)lparam,(uint)dparam))
         return;
      //--- If the Tooltips button was clicked
      if(OnClickTooltipsButton((uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
//--- Event of changing the chart properties
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      //--- If the button is released
      if(m_clamping_area_mouse==NOT_PRESSED)
        {
         //--- Get the chart window size
         SetWindowProperties();
         //--- Adjustment of coordinates
         UpdateWindowXY(m_x,m_y);
        }
      //--- Change the width if the mode is enabled
      if(CElementBase::AutoXResizeMode())
         ChangeWindowWidth(m_chart.WidthInPixels()-2);
      //--- Change the height if the mode is enabled
      if(CElementBase::AutoYResizeMode())
         ChangeWindowHeight(m_chart.HeightInPixels(m_subwin)-3);
      //---
      return;
     }
//--- Handling the event of changing the expert subwindow height
   if(id==CHARTEVENT_CUSTOM+ON_SUBWINDOW_CHANGE_HEIGHT)
     {
      //--- Leave, if (1) the message was from the expert or (2) it is not an expert
      if(sparam==PROGRAM_NAME || CElementBase::ProgramType()!=PROGRAM_EXPERT)
         return;
      //--- Leave, if the mode of the sub-window fixed height is not set
      if(!m_height_subwindow_mode)
         return;
      //--- Calculate and change the subwindow height
      m_subwindow_height=(m_is_minimized)? m_caption_height+3 : m_full_height+3;
      ChangeSubwindowHeight(m_subwindow_height);
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates a form for controls                                      |
//+------------------------------------------------------------------+
bool CWindow::CreateWindow(const long chart_id,const int subwin,const string caption_text,const int x,const int y)
  {
//--- Leave, if the identifier is not defined
   if(CElementBase::Id()==WRONG_VALUE)
     {
      ::Print(__FUNCTION__," > Before creating a window, its pointer has to be stored in the base: CWndContainer::AddWindow(CWindow &object)");
      return(false);
     }
//--- Store the pointers to itself
   CElement::WindowPointer(this);
   CElement::MainPointer(this);
//--- Save the chart window properties
   SetWindowProperties();
//--- Initialization of the properties
   InitializeProperties(chart_id,subwin,caption_text,x,y);
//--- Creating all object of the window
   if(!CreateCanvas())
      return(false);
   if(!CreateButtons())
      return(false);
   if(!CreateResizePointer())
      return(false);
//--- The value of the last set identifier
   CElementBase::LastId(CElementBase::Id());
//--- If this program is an indicator
   if(CElementBase::ProgramType()==PROGRAM_INDICATOR)
     {
      //--- If the mode of the sub-window set height is set
      if(m_height_subwindow_mode)
        {
         m_subwindow_height=m_full_height+3;
         ChangeSubwindowHeight(m_subwindow_height);
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CWindow::InitializeProperties(const long chart_id,const int subwin,const string caption_text,const int x_gap,const int y_gap)
  {
   m_chart_id   =chart_id;
   m_subwin     =subwin;
   m_label_text =caption_text;
//--- Coordinates and sizes
   m_x              =x_gap;
   m_y              =y_gap;
   m_x_size         =(m_auto_xresize_mode)? m_chart_width-2 : m_x_size;
   m_y_size         =(m_auto_yresize_mode)? m_chart_height-3 : m_y_size;
   m_x_size         =(m_x_size<1)? 200 : m_x_size;
   m_y_size         =(m_y_size<1)? 200 : m_y_size;
   m_full_height    =m_y_size;
   m_last_x_size    =m_x_size;
   m_last_y_size    =m_y_size;
   m_minimum_x_size =(m_minimum_x_size<200)? m_x_size : m_minimum_x_size;
   m_minimum_y_size =(m_minimum_y_size<200)? m_y_size : m_minimum_y_size;
//--- Default properties
   m_back_color         =(m_back_color!=clrNONE)? m_back_color : clrWhiteSmoke;
   m_icon_x_gap         =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 5;
   m_icon_y_gap         =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 2;
   m_label_x_gap        =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 24;
   m_label_y_gap        =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
   m_label_color        =(m_label_color!=clrNONE)? m_label_color : clrWhite;
   m_label_color_hover  =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrWhite;
   m_label_color_locked =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrBlack;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CWindow::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("window");
//--- Size of the window depends on its state (minimized/maximized)
   if(m_window_type==W_MAIN)
      m_y_size=(m_is_minimized)? m_caption_height : m_full_height;
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- set properties
   if(CElement::IconFile()=="")
     {
      CElement::IconFile(DefaultIcon());
      CElement::IconFileLocked(DefaultIcon());
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates buttons on the form                                      |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\close_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\close_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\full_screen.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\minimize_to_window.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\up_thin_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\down_thin_white.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\help.bmp"
//---
bool CWindow::CreateButtons(void)
  {
//--- If the program type is script, leave
   if(CElementBase::ProgramType()==PROGRAM_SCRIPT)
      return(true);
//--- Counter, size, number
   int i=0,x_size=20;
   int buttons_total=4;
//--- The path to the file
   string icon_file="";
//--- Exception in the capture area
   m_right_limit=0;
//---
   CButton *button_obj=NULL;
//---
   for(int b=0; b<buttons_total; b++)
     {
      //---
      if(b==0)
        {
         CElementBase::LastId(LastId()-1);
         m_button_close.MainPointer(this);
         if(!m_close_button)
            continue;
         //---
         button_obj=::GetPointer(m_button_close);
         icon_file ="Images\\EasyAndFastGUI\\Controls\\close_white.bmp";
        }
      else if(b==1)
        {
         m_button_fullscreen.MainPointer(this);
         //--- Leave, if (1) the button is not enabled or (2) it is a dialog box
         if(!m_fullscreen_button || m_window_type==W_DIALOG)
            continue;
         //---
         button_obj=::GetPointer(m_button_fullscreen);
         icon_file="Images\\EasyAndFastGUI\\Controls\\full_screen.bmp";
        }
      else if(b==2)
        {
         m_button_collapse.MainPointer(this);
         //--- Leave, if (1) the button is not enabled or (2) it is a dialog box
         if(!m_collapse_button || m_window_type==W_DIALOG)
            continue;
         //---
         button_obj=::GetPointer(m_button_collapse);
         if(m_is_minimized)
            icon_file="Images\\EasyAndFastGUI\\Controls\\down_thin_white.bmp";
         else
            icon_file="Images\\EasyAndFastGUI\\Controls\\up_thin_white.bmp";
        }
      else if(b==3)
        {
         m_button_tooltip.MainPointer(this);
         //--- Leave, if (1) the button is not enabled or (2) it is a dialog box
         if(!m_tooltips_button || m_window_type==W_DIALOG)
            continue;
         //---
         button_obj=::GetPointer(m_button_tooltip);
         icon_file ="Images\\EasyAndFastGUI\\Controls\\help.bmp";
        }
      //--- Properties
      button_obj.Index(i);
      button_obj.XSize(x_size);
      button_obj.YSize(x_size);
      button_obj.IconXGap(2);
      button_obj.IconYGap(2);
      button_obj.BackColor(m_caption_color);
      button_obj.BackColorHover((b<1)? C'242,27,45' : C'0,150,245');
      button_obj.BackColorPressed((b<1)? C'149,68,116' : C'0,160,255');
      button_obj.BackColorLocked(m_caption_color_locked);
      button_obj.BorderColor(m_caption_color);
      button_obj.BorderColorHover(m_caption_color);
      button_obj.BorderColorLocked(m_caption_color_locked);
      button_obj.BorderColorPressed(m_caption_color);
      button_obj.IconFile(icon_file);
      button_obj.IconFileLocked(icon_file);
      if(b==3)
        {
         button_obj.TwoState(true);
         button_obj.IconFilePressed(icon_file);
         button_obj.IconFilePressedLocked(icon_file);
        }
      button_obj.AnchorRightWindowSide(true);
      //--- Calculation of indent for the next button
      m_right_limit+=x_size-((i<3)? 0 : 1);
      i++;
      //--- Create the control
      if(!button_obj.CreateButton("",m_right_limit,0))
         return(false);
      //--- Add the control to the array
      CElement::AddToArray(button_obj);
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the mouse cursor for resizing                            |
//+------------------------------------------------------------------+
bool CWindow::CreateResizePointer(void)
  {
//--- Leave, if the resizing mode is disabled
   if(!m_xy_resize_mode)
      return(true);
//--- Properties
   m_xy_resize.XGap(13);
   m_xy_resize.YGap(11);
   m_xy_resize.XSize(23);
   m_xy_resize.YSize(23);
   m_xy_resize.Id(CElementBase::Id());
   m_xy_resize.Type(MP_WINDOW_RESIZE);
//--- Create control
   if(!m_xy_resize.CreatePointer(m_chart_id,m_subwin))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Identifying the default icon                                     |
//+------------------------------------------------------------------+
//--- Icons (by default) symbolizing the program type
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\advisor.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\indicator.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\script.bmp"
//---
string CWindow::DefaultIcon(void)
  {
   string path="Images\\EasyAndFastGUI\\Icons\\bmp16\\advisor.bmp";
//---
   switch(CElementBase::ProgramType())
     {
      case PROGRAM_SCRIPT:
        {
         path="Images\\EasyAndFastGUI\\Icons\\bmp16\\script.bmp";
         break;
        }
      case PROGRAM_EXPERT:
        {
         path="Images\\EasyAndFastGUI\\Icons\\bmp16\\advisor.bmp";
         break;
        }
      case PROGRAM_INDICATOR:
        {
         path="Images\\EasyAndFastGUI\\Icons\\bmp16\\indicator.bmp";
         break;
        }
     }
//---
   return(path);
  }
//+------------------------------------------------------------------+
//| Mode of indicator sub-window minimization                        |
//+------------------------------------------------------------------+
void CWindow::RollUpSubwindowMode(const bool rollup_mode=false,const bool height_mode=false)
  {
//--- Leave, if this is a script
   if(CElementBase::m_program_type==PROGRAM_SCRIPT)
      return;
//---
   m_rollup_subwindow_mode =rollup_mode;
   m_height_subwindow_mode =height_mode;
//---
   if(m_height_subwindow_mode)
      ChangeSubwindowHeight(m_subwindow_height);
  }
//+------------------------------------------------------------------+
//| Changes the height of the indicator sub-window                   |
//+------------------------------------------------------------------+
void CWindow::ChangeSubwindowHeight(const int height)
  {
//--- If the graphical interface (1) is not in subwindow or (2) the program is of "Script" type
   if(CElementBase::m_subwin<=0 || CElementBase::m_program_type==PROGRAM_SCRIPT)
      return;
//--- If the subwindow height needs to be changed
   if(height>0)
     {
      //--- If the program is of the "Indicator" type
      if(CElementBase::m_program_type==PROGRAM_INDICATOR)
        {
         if(!::IndicatorSetInteger(INDICATOR_HEIGHT,height))
            ::Print(__FUNCTION__," > Failed to change the height of indicator subwindow! Error code: ",::GetLastError());
        }
      //--- If the program is of the EA type
      else
        {
         //--- Send the message to the SubWindow.ex5 indicator, informing that the window sizes must be changed
         ::EventChartCustom(m_chart_id,ON_SUBWINDOW_CHANGE_HEIGHT,(long)height,0,PROGRAM_NAME);
        }
     }
  }
//+------------------------------------------------------------------+
//| Changes the width of the window                                  |
//+------------------------------------------------------------------+
void CWindow::ChangeWindowWidth(const int width)
  {
//--- If the width has not changed, leave
   if(width==m_canvas.XSize())
      return;
//--- Update the width for the background and the header
   CElementBase::XSize(width);
   m_canvas.XSize(width);
   m_canvas.Resize(width,m_y_size);
//--- Redraw the window
   Draw();
//--- A message that the window sizes have been changed
   ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_XSIZE,(long)CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Changes the height of the window                                 |
//+------------------------------------------------------------------+
void CWindow::ChangeWindowHeight(const int height)
  {
//--- If the height has not changed, leave
   if(height==m_canvas.YSize())
      return;
//--- Leave, if the window is minimized
   if(m_is_minimized)
      return;
//--- Update the height for background
   CElementBase::YSize(height);
   m_canvas.YSize(height);
   m_canvas.Resize(m_x_size,height);
   m_full_height=m_last_y_size;
//--- Redraw the window
   Draw();
//--- A message that the window sizes have been changed
   ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_YSIZE,(long)CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Getting the chart size                                           |
//+------------------------------------------------------------------+
void CWindow::SetWindowProperties(void)
  {
//--- Get width and height of the chart window
   m_chart_width  =m_chart.WidthInPixels();
   m_chart_height =m_chart.HeightInPixels(m_subwin);
  }
//+------------------------------------------------------------------+
//| Verifying the cursor location in the area of the window title    |
//+------------------------------------------------------------------+
bool CWindow::CursorInsideCaption(const int x,const int y)
  {
   return(x>m_x && x<X2()-m_right_limit && y>m_y && y<m_y+m_caption_height);
  }
//+------------------------------------------------------------------+
//| Zeroing variables connected with displacement of the window and  |
//| the state of the left mouse button                               |
//+------------------------------------------------------------------+
void CWindow::ZeroMoveVariables(void)
  {
//--- Leave, if already zeroed
   if(m_clamping_area_mouse==NOT_PRESSED)
      return;
//--- Send a message to restore only if there was dragging in the header area
   if(m_clamping_area_mouse==PRESSED_INSIDE_HEADER)
     {
      //--- Send a message to restore the available controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      //--- Send a message about the completion of dragging the form
      ::EventChartCustom(m_chart_id,ON_WINDOW_DRAG_END,CElementBase::Id(),0,"");
     }
//--- Zero
   m_prev_x              =0;
   m_prev_y              =0;
   m_size_fixing_x       =0;
   m_size_fixing_y       =0;
   m_clamping_area_mouse =NOT_PRESSED;
  }
//+------------------------------------------------------------------+
//| Resetting variables related to resizing the window               |
//+------------------------------------------------------------------+
void CWindow::ZeroResizeVariables(void)
  {
//--- Leave, if already zeroed
   if(m_point_fixed<1)
      return;
//--- Zero
   m_x_fixed     =0;
   m_size_fixed  =0;
   m_point_fixed =0;
//--- Send a message to restore the available controls
   
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Verifies the state of the mouse button                           |
//+------------------------------------------------------------------+
void CWindow::CheckMouseButtonState(void)
  {
//--- If the button is released
   if(!m_mouse.LeftButtonState())
     {
      //--- Zero out variables
      ZeroMoveVariables();
      return;
     }
//--- If the button is pressed
   else
     {
      //--- Leave, if the state is already recorded
      if(m_clamping_area_mouse!=NOT_PRESSED)
         return;
      //--- Outside the form area
      if(!CElementBase::MouseFocus())
         m_clamping_area_mouse=PRESSED_OUTSIDE;
      //--- Inside the form area
      else
        {
         //--- Leave, if the form is in another subwindow of the chart
         if(!CElementBase::CheckSubwindowNumber())
            return;
         //--- If inside the header
         if(CursorInsideCaption(m_mouse.X(),m_mouse.Y()))
           {
            m_clamping_area_mouse=PRESSED_INSIDE_HEADER;
            //--- Send a message to determine the available controls
            ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
            //--- Send a message about the change in the graphical interface
            ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
            return;
           }
         //--- If inside the form area
         else
            m_clamping_area_mouse=PRESSED_INSIDE;
        }
     }
  }
//+------------------------------------------------------------------+
//| Set the chart state                                              |
//+------------------------------------------------------------------+
void CWindow::SetChartState(void)
  {
//--- If (the cursor is in the panel area and the mouse button is released) or
//    the mouse button was pressed inside the area of the form or header
   if((CElementBase::MouseFocus() && m_clamping_area_mouse==NOT_PRESSED) || 
      m_clamping_area_mouse==PRESSED_INSIDE_HEADER ||
      m_clamping_area_mouse==PRESSED_INSIDE_BORDER ||
      m_clamping_area_mouse==PRESSED_INSIDE ||
      m_custom_event_chart_state)
     {
      //--- Disable scroll and management of trading levels
      m_chart.MouseScroll(false);
      m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,false);
     }
//--- Enable management, if the cursor is outside of the window area
   else
     {
      m_chart.MouseScroll(true);
      m_chart.SetInteger(CHART_DRAG_TRADE_LEVELS,true);
     }
  }
//+------------------------------------------------------------------+
//| Updating window coordinates                                      |
//+------------------------------------------------------------------+
void CWindow::UpdateWindowXY(const int x,const int y)
  {
//--- Leave, if the fixed form mode is set
   if(!m_is_movable)
      return;
//--- To calculate new X and Y coordinates
   int new_x_point=0,new_y_point=0;
//--- Limits
   int limit_top=0,limit_left=0,limit_bottom=0,limit_right=0;
//--- If the mouse button is pressed
   if((bool)m_clamping_area_mouse)
     {
      //--- Store current XY coordinates of the cursor
      if(m_prev_y==0 || m_prev_x==0)
        {
         m_prev_y=y;
         m_prev_x=x;
        }
      //--- Store the distance from the edge point of the form to the cursor
      if(m_size_fixing_y==0 || m_size_fixing_x==0)
        {
         m_size_fixing_y =m_y-m_prev_y;
         m_size_fixing_x =m_x-m_prev_x;
        }
     }
//--- Set limits
   limit_top    =y-::fabs(m_size_fixing_y);
   limit_left   =x-::fabs(m_size_fixing_x);
   limit_bottom =m_y+m_caption_height;
   limit_right  =m_x+m_x_size;
//--- If the boundaries of the chart are not exceeded downwards/upwards/right/left
   if(limit_bottom<m_chart_height && limit_top>=0 && 
      limit_right<m_chart_width && limit_left>=0)
     {
      new_y_point =y+m_size_fixing_y;
      new_x_point =x+m_size_fixing_x;
     }
//--- If the boundaries of the chart were exceeded
   else
     {
      if(limit_bottom>m_chart_height) // > downwards
        {
         new_y_point =m_chart_height-m_caption_height;
         new_x_point =x+m_size_fixing_x;
        }
      else if(limit_top<0) // > upwards
        {
         new_y_point =0;
         new_x_point =x+m_size_fixing_x;
        }
      if(limit_right>m_chart_width) // > right
        {
         new_x_point =m_chart_width-m_x_size;
         new_y_point =y+m_size_fixing_y;
        }
      else if(limit_left<0) // > left
        {
         new_x_point =0;
         new_y_point =y+m_size_fixing_y;
        }
     }
//--- Update coordinates, if there was a displacement
   if(new_x_point>0 || new_y_point>0)
     {
      //--- Adjust the form coordinates
      m_x =(new_x_point<=0)? 1 : new_x_point;
      m_y =(new_y_point<=0)? 1 : new_y_point;
      //---
      if(new_x_point>0)
         m_x=(m_x>m_chart_width-m_x_size-1) ? m_chart_width-m_x_size-1 : m_x;
      if(new_y_point>0)
         m_y=(m_y>m_chart_height-m_caption_height-2) ? m_chart_height-m_caption_height-2 : m_y;
      //--- Zero the anchor points
      m_prev_x=0;
      m_prev_y=0;
     }
  }
//+------------------------------------------------------------------+
//| Open the window                                                  |
//+------------------------------------------------------------------+
void CWindow::OpenWindow(void)
  {
//--- Display the control
   CWindow::Show();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_OPEN_DIALOG_BOX,CElementBase::Id(),0,m_program_name);
  }
//+------------------------------------------------------------------+
//| Closing the dialog window or the program                         |
//+------------------------------------------------------------------+
void CWindow::CloseWindow(void)
  {
   OnClickCloseButton();
  }
//+------------------------------------------------------------------+
//| Closing a dialog window                                          |
//+------------------------------------------------------------------+
void CWindow::CloseDialogBox(void)
  {
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLOSE_DIALOG_BOX,CElementBase::Id(),m_prev_active_window_index,m_label_text);
  }
//+------------------------------------------------------------------+
//| Changing the window state to the opposite (minimize/maximize)    |
//+------------------------------------------------------------------+
void CWindow::ChangeWindowState(void)
  {
   OnClickCollapseButton();
  }
//+------------------------------------------------------------------+
//| Setting the state of the window                                  |
//+------------------------------------------------------------------+
void CWindow::State(const bool flag)
  {
   int elements_total=CElement::ElementsTotal();
//--- If the window is to be locked
   if(!flag)
     {
      //--- Set the status
      CElementBase::IsLocked(true);
      for(int i=0; i<elements_total; i++)
         m_elements[i].IsLocked(true);
     }
//--- If the window is to be unlocked
   else
     {
      //--- Set the status
      CElementBase::IsLocked(false);
      for(int i=0; i<elements_total; i++)
         m_elements[i].IsLocked(false);
      //--- Zero the focus
      CElementBase::MouseFocus(false);
     }
//--- Redraw the window
   Update(true);
   for(int i=0; i<elements_total; i++)
      m_elements[i].Update(true);
  }
//+------------------------------------------------------------------+
//| Moving the window                                                |
//+------------------------------------------------------------------+
void CWindow::Moving(const int x,const int y)
  {
//--- Storing coordinates in variables
   m_canvas.X(x);
   m_canvas.Y(y);
//--- Updating coordinates of graphical objects
   m_canvas.X_Distance(x);
   m_canvas.Y_Distance(y);
//--- Moving controls
   int elements_total=CElement::ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Moving();
  }
//+------------------------------------------------------------------+
//| Shows the window                                                 |
//+------------------------------------------------------------------+
void CWindow::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving(m_x,m_y);
//--- Show the object
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Display the controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Show();
//--- Get the chart window size
   SetWindowProperties();
  }
//+------------------------------------------------------------------+
//| Redrawing of all window objects                                  |
//+------------------------------------------------------------------+
void CWindow::Reset(void)
  {
//--- Hide and show the object
   m_canvas.Timeframes(OBJ_NO_PERIODS);
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Visible state
   CElementBase::IsVisible(true);
//--- Zero the focus
   CElementBase::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CWindow::Delete(void)
  {
   CElement::Delete();
//--- Zeroing variables
   m_right_limit=0;
  }
//+------------------------------------------------------------------+
//| Closing the dialog window or the program                         |
//+------------------------------------------------------------------+
bool CWindow::OnClickCloseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   uint check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   uint check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the values do not match
   if(check_id!=m_button_close.Id() || check_index!=m_button_close.Index())
      return(false);
//--- If this is the main window
   if(m_window_type==W_MAIN)
     {
      //--- If the program is of the EA type
      if(CElementBase::ProgramType()==PROGRAM_EXPERT)
        {
         string text="Do you want the program to be removed from the chart?";
         //--- Open a dialog box
         int mb_res=::MessageBox(text,NULL,MB_YESNO|MB_ICONQUESTION);
         //--- If the button "Yes" is pressed, delete the program from the chart
         if(mb_res==IDYES)
           {
            ::Print(__FUNCTION__," > The program was deleted from the chart due to your decision!");
            //--- Removing the EA from the chart
            ::ExpertRemove();
            return(true);
           }
         else
           {
            m_button_close.MouseFocus(false);
            m_button_close.Update(true);
           }
        }
      //--- If the program is of the "Indicator" type
      else if(CElementBase::ProgramType()==PROGRAM_INDICATOR)
        {
         //--- Removing the indicator from the chart
         if(::ChartIndicatorDelete(m_chart_id,::ChartWindowFind(),CElementBase::ProgramName()))
           {
            ::Print(__FUNCTION__," > The program was deleted from the chart due to your decision!");
            return(true);
           }
        }
     }
//--- If this is a dialog box, close it
   else if(m_window_type==W_DIALOG)
      CloseDialogBox();
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Switch to full screen or to previous form size                   |
//+------------------------------------------------------------------+
bool CWindow::OnClickFullScreenButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   int check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   int check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the indexes do not match
   if(check_id!=m_button_fullscreen.Id() || check_index!=m_button_fullscreen.Index())
      return(false);
//--- If the window is not in full screen
   if(!m_is_fullscreen)
     {
      //--- Switch to full screen
      m_is_fullscreen=true;
      //--- Get the current dimensions of the chart window
      SetWindowProperties();
      //--- Store the current coordinates and dimensions of the form
      m_last_x            =m_x;
      m_last_y            =m_y;
      m_last_x_size       =m_x_size;
      m_last_y_size       =m_full_height;
      m_last_auto_xresize =m_auto_xresize_mode;
      m_last_auto_yresize =m_auto_yresize_mode;
      //--- Enable auto-resizing of the form
      m_auto_xresize_mode=true;
      m_auto_yresize_mode=true;
      //--- Maximize the form to the entire chart
      ChangeWindowWidth(m_chart.WidthInPixels()-2);
      ChangeWindowHeight(m_chart.HeightInPixels(m_subwin)-3);
      //--- Update the location
      m_x=m_y=1;
      Moving(m_x,m_y);
      //--- Replace the button icon
      m_button_fullscreen.IconFile("Images\\EasyAndFastGUI\\Controls\\minimize_to_window.bmp");
      m_button_fullscreen.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\minimize_to_window.bmp");
     }
//--- If the window is in full screen
   else
     {
      //--- Switch to previous window size
      m_is_fullscreen=false;
      //--- Disable auto-resizing
      m_auto_xresize_mode=m_last_auto_xresize;
      m_auto_yresize_mode=m_last_auto_yresize;
      //--- If the mode is disabled, set the previous size
      if(!m_auto_xresize_mode)
         ChangeWindowWidth(m_last_x_size);
      if(!m_auto_yresize_mode)
         ChangeWindowHeight(m_last_y_size);
      //--- Update the location
      m_x=m_last_x;
      m_y=m_last_y;
      Moving(m_x,m_y);
      //--- Replace the button icon
      m_button_fullscreen.IconFile("Images\\EasyAndFastGUI\\Controls\\full_screen.bmp");
      m_button_fullscreen.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\full_screen.bmp");
     }
//--- Remove the focus from the button
   m_button_fullscreen.MouseFocus(false);
   m_button_fullscreen.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Check for the window minimization/maximization event             |
//+------------------------------------------------------------------+
bool CWindow::OnClickCollapseButton(const int id=WRONG_VALUE,const int index=WRONG_VALUE)
  {
//--- Check the identifier and index of control if there was an external call
   int check_id    =(id!=WRONG_VALUE)? id : CElementBase::Id();
   int check_index =(index!=WRONG_VALUE)? index : CElementBase::Index();
//--- Leave, if the indexes do not match
   if(check_id!=m_button_collapse.Id() || check_index!=m_button_collapse.Index())
      return(false);
//--- If the window is maximized
   if(!m_is_minimized)
      Collapse();
   else
      Expand();
//--- Remove the focus from the button
   m_button_collapse.MouseFocus(false);
   m_button_collapse.Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Minimizes the window                                             |
//+------------------------------------------------------------------+
void CWindow::Collapse(void)
  {
//--- Change the button
   m_button_collapse.IconFile("Images\\EasyAndFastGUI\\Controls\\down_thin_white.bmp");
   m_button_collapse.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\down_thin_white.bmp");
//--- Set and store the size
   CElementBase::YSize(m_caption_height);
   m_canvas.YSize(m_caption_height);
   m_canvas.Resize(m_x_size,m_canvas.YSize());
//--- State of the form "Minimized"
   m_is_minimized=true;
//--- Redraw the window
   Update(true);
//--- Calculate the subwindow height
   m_subwindow_height=m_caption_height+3;
//--- If this program is in a subwindow with a fixed height and with the subwindow minimization mode,
//    set the size of the program subwindow
   if(m_height_subwindow_mode)
      if(m_rollup_subwindow_mode)
         ChangeSubwindowHeight(m_subwindow_height);
//--- Get the program subwindow number
   int subwin=(CElementBase::ProgramType()==PROGRAM_INDICATOR)? ::ChartWindowFind() : m_subwin;
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_WINDOW_COLLAPSE,CElementBase::Id(),subwin,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Maximizes the window                                             |
//+------------------------------------------------------------------+
void CWindow::Expand(void)
  {
//--- Change the button
   m_button_collapse.IconFile("Images\\EasyAndFastGUI\\Controls\\up_thin_white.bmp");
   m_button_collapse.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\up_thin_white.bmp");
//--- Set and store the size
   CElementBase::YSize(m_full_height);
   m_canvas.YSize(m_full_height);
   m_canvas.Resize(m_x_size,m_canvas.YSize());
//--- Maximized state of the form
   m_is_minimized=false;
//--- Redraw the window
   Update(true);
//--- Calculate the subwindow height
   m_subwindow_height=m_full_height+3;
//--- If this is an indicator with a set height and with the sub-window minimization mode,
//    set the size of the program subwindow
   if(m_height_subwindow_mode)
      if(m_rollup_subwindow_mode)
         ChangeSubwindowHeight(m_subwindow_height);
//--- Get the program subwindow number
   int subwin=(CElementBase::ProgramType()==PROGRAM_INDICATOR)? ::ChartWindowFind() : m_subwin;
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_WINDOW_EXPAND,CElementBase::Id(),subwin,"");
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
  }
//+------------------------------------------------------------------+
//| Handling the event of clicking on the Tooltips button            |
//+------------------------------------------------------------------+
bool CWindow::OnClickTooltipsButton(const uint id,const uint index)
  {
//--- This button is not required, if the window is a dialog window
   if(m_window_type==W_DIALOG)
      return(false);
//--- Leave, if the indexes do not match
   if(id!=m_button_tooltip.Id() || index!=m_button_tooltip.Index())
      return(false);
//--- Store the state in the class field
   m_tooltips_button_state=m_button_tooltip.IsPressed();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_WINDOW_TOOLTIPS,CElementBase::Id(),CElementBase::Index(),"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Controls the window sizes                                        |
//+------------------------------------------------------------------+
void CWindow::ResizeWindow(void)
  {
//--- Leave, if the window is unavailable
   if(!IsAvailable())
      return;
//--- Leave, if the mouse button was not pressed over the form button
   if(m_clamping_area_mouse!=PRESSED_INSIDE_BORDER && m_clamping_area_mouse!=NOT_PRESSED)
      return;
//--- Leave, if (1) the window resizing mode is disabled or 
//    (2) the window is in full screen or (3) the window is minimized
   if(!m_xy_resize_mode || m_is_fullscreen || m_is_minimized)
      return;
//--- Coordinates
   int x =m_mouse.RelativeX(m_canvas);
   int y =m_mouse.RelativeY(m_canvas);
//--- Check readiness to change the width of lists
   if(!CheckResizePointer(x,y))
      return;
//--- Updating the window sizes
   UpdateSize(x,y);
  }
//+------------------------------------------------------------------+
//| Check the readiness to resize the window                         |
//+------------------------------------------------------------------+
bool CWindow::CheckResizePointer(const int x,const int y)
  {
//--- Define the current mode index
   m_resize_mode_index=ResizeModeIndex(x,y);
//--- If the cursor is hidden
   if(!m_xy_resize.IsVisible())
     {
      //--- If the mode is defined
      if(m_resize_mode_index!=WRONG_VALUE)
        {
         //--- For determining the index of the displayed icon of the mouse pointer
         int index=WRONG_VALUE;
         //--- If on vertical borders
         if(m_resize_mode_index==0 || m_resize_mode_index==1)
            index=0;
         //--- If on horizontal borders
         else if(m_resize_mode_index==2)
            index=1;
         //--- Change the icon
         m_xy_resize.ChangeImage(0,index);
         //--- Move, redraw and show
         m_xy_resize.Moving(m_mouse.X(),m_mouse.Y());
         m_xy_resize.Update(true);
         m_xy_resize.Reset();
         return(true);
        }
     }
   else
     {
      //--- Move the pointer
      if(m_resize_mode_index!=WRONG_VALUE)
         m_xy_resize.Moving(m_mouse.X(),m_mouse.Y());
      //--- Hide the cursor
      else if(!m_mouse.LeftButtonState())
        {
         //--- Hide the pointer and reset the variables
         m_xy_resize.Hide();
         ZeroResizeVariables();
        }
      //--- Refresh the chart
      m_chart.Redraw();
      return(true);
     }
//---
   return(false);
  }
//+------------------------------------------------------------------+
//| Returns the index of the window resizing mode                    |
//+------------------------------------------------------------------+
int CWindow::ResizeModeIndex(const int x,const int y)
  {
//--- Return the border index, if already dragging
   if(m_resize_mode_index!=WRONG_VALUE && m_mouse.LeftButtonState())
      return(m_resize_mode_index);
//--- Width, offset and index of the border
   int width  =5;
   int offset =15;
   int index  =WRONG_VALUE;
//--- Checking the focus on the left border
   if(x>0 && x<width && y>m_caption_height+offset && y<m_y_size-offset)
      index=0;
//--- Checking the focus on the right border
   else if(x>m_x_size-width && x<m_x_size && y>m_caption_height+offset && y<m_y_size-offset)
      index=1;
//--- Checking the focus on the bottom border
   else if(y>m_y_size-width && y<m_y_size && x>offset && x<m_x_size-offset)
      index=2;
//--- If the index is obtained, mark the area of the click
   if(index!=WRONG_VALUE)
      m_clamping_area_mouse=PRESSED_INSIDE_BORDER;
//--- Return the area index
   return(index);
  }
//+------------------------------------------------------------------+
//| Updating the window sizes                                        |
//+------------------------------------------------------------------+
void CWindow::UpdateSize(const int x,const int y)
  {
//--- If finished and the left mouse button is released, reset the values
   if(!m_mouse.LeftButtonState())
     {
      ZeroResizeVariables();
      return;
     }
//--- Leave, if the capture and movement of the border has not started yet
   int distance=0;
   if((distance=CheckDragWindowBorder(x,y))==0)
      return;
//--- Calculating and resizing the window
   CalculateAndResizeWindow(distance);
//--- Redraw the window
   Update(true);
//--- Update the position of objects
   Moving(m_x,m_y);
//--- A message that the window sizes have been changed
   if(m_resize_mode_index==2)
      ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_YSIZE,(long)CElementBase::Id(),0,"");
   else
      ::EventChartCustom(m_chart_id,ON_WINDOW_CHANGE_XSIZE,(long)CElementBase::Id(),0,"");
  }
//+------------------------------------------------------------------+
//| Check dragging of the window border                              |
//+------------------------------------------------------------------+
int CWindow::CheckDragWindowBorder(const int x,const int y)
  {
//--- To determine the displacement distance
   int distance=0;
//--- If the border is not dragged
   if(m_point_fixed<1)
     {
      //--- If resizing along the X axis
      if(m_resize_mode_index==0 || m_resize_mode_index==1)
        {
         m_x_fixed     =m_x;
         m_size_fixed  =m_x_size;
         m_point_fixed =x;
        }
      //--- If resizing along the Y axis
      else if(m_resize_mode_index==2)
        {
         m_size_fixed  =m_y_size;
         m_point_fixed =y;
        }
      //--- Send a message to determine the available controls
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      return(0);
     }
//--- If this is the left border
   if(m_resize_mode_index==0)
      distance=m_mouse.X()-m_x_fixed;
//--- If this is the right border
   else if(m_resize_mode_index==1)
      distance=x-m_point_fixed;
//--- If this is the bottom border
   else if(m_resize_mode_index==2)
      distance=y-m_point_fixed;
//--- Return the passed distance
   return(distance);
  }
//+------------------------------------------------------------------+
//| Calculating and resizing the window                              |
//+------------------------------------------------------------------+
void CWindow::CalculateAndResizeWindow(const int distance)
  {
//--- Left border
   if(m_resize_mode_index==0)
     {
      int new_x      =m_x_fixed+distance-m_point_fixed;
      int new_x_size =m_size_fixed-distance+m_point_fixed;
      //--- Leave, if exceeding the limits
      if(new_x<1 || new_x_size<=m_minimum_x_size)
         return;
      //--- Coordinates
      CElementBase::X(new_x);
      m_canvas.X_Distance(new_x);
      //--- Set and store the size
      CElementBase::XSize(new_x_size);
      m_canvas.XSize(new_x_size);
      m_canvas.Resize(new_x_size,m_canvas.YSize());
     }
//--- Right border
   else if(m_resize_mode_index==1)
     {
      int gap_x2     =m_chart_width-m_mouse.X()-(m_size_fixed-m_point_fixed);
      int new_x_size =m_size_fixed+distance;
      //--- Leave, if exceeding the limits
      if(gap_x2<1 || new_x_size<=m_minimum_x_size)
         return;
      //--- Set and store the size
      CElementBase::XSize(new_x_size);
      m_canvas.XSize(new_x_size);
      m_canvas.Resize(new_x_size,m_canvas.YSize());
     }
//--- Lower border
   else if(m_resize_mode_index==2)
     {
      int gap_y2=m_chart_height-m_mouse.Y()-(m_size_fixed-m_point_fixed);
      int new_y_size=m_size_fixed+distance;
      //--- Leave, if exceeding the limits
      if(gap_y2<2 || new_y_size<=m_minimum_y_size)
         return;
      //--- Set and store the size
      m_full_height=new_y_size;
      CElementBase::YSize(new_y_size);
      m_canvas.YSize(new_y_size);
      m_canvas.Resize(m_canvas.XSize(),new_y_size);
     }
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CWindow::Draw(void)
  {
//--- Draws the background
   DrawBackground();
//--- Draws the foreground
   DrawForeground();
//--- Draw icon
   CElement::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the background                                             |
//+------------------------------------------------------------------+
void CWindow::DrawBackground(void)
  {
   uint clr=(CElementBase::IsLocked())? m_caption_color_locked :(CElementBase::MouseFocus())? m_caption_color_hover : m_caption_color;
   CElement::m_canvas.Erase(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Draws the foreground                                             |
//+------------------------------------------------------------------+
void CWindow::DrawForeground(void)
  {
//--- Leave, if the window is minimized
   if(m_is_minimized)
      return;
//--- Coordinates
   int x  =1;
   int y  =m_caption_height;
   int x2 =m_x_size-2;
   int y2 =m_y_size-2;
//--- Draw a filled rectangle
   m_canvas.FillRectangle(x,y,x2,y2,::ColorToARGB(m_back_color,(m_transparent_only_caption)?(uchar)255 : m_alpha));
  }
//+------------------------------------------------------------------+
