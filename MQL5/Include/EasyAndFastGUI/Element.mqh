//+------------------------------------------------------------------+
//|                                                      Element.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "ElementBase.mqh"
class CWindow;
struct EImagesGroup;
//+------------------------------------------------------------------+
//| Derived class of control                                         |
//+------------------------------------------------------------------+
class CElement : public CElementBase
  {
protected:
   //--- Pointer to the form
   CWindow          *m_wnd;
   //--- Pointer to the main control
   CElement         *m_main;
   //--- Canvas for drawing a control
   CRectCanvas       m_canvas;
   //--- Pointers to nested controls
   CElement         *m_elements[];
   //--- Groups of images
   struct EImagesGroup
     {
      //--- Array of images
      CImage            m_image[];
      //--- Icon margins
      int               m_x_gap;
      int               m_y_gap;
      //--- Image from the group selected for display
      int               m_selected_image;
     };
   EImagesGroup      m_images_group[];
   //--- Icon margins
   int               m_icon_x_gap;
   int               m_icon_y_gap;
   //--- Color of the background in different states
   color             m_back_color;
   color             m_back_color_hover;
   color             m_back_color_locked;
   color             m_back_color_pressed;
   //--- Color of the border in different states
   color             m_border_color;
   color             m_border_color_hover;
   color             m_border_color_locked;
   color             m_border_color_pressed;
   //--- Color of the text in different states
   color             m_label_color;
   color             m_label_color_hover;
   color             m_label_color_locked;
   color             m_label_color_pressed;
   //--- Description text
   string            m_label_text;
   //--- Text label margins
   int               m_label_x_gap;
   int               m_label_y_gap;
   //--- Font
   string            m_font;
   int               m_font_size;
   //--- Value of the alpha channel (transparency of the control)
   uchar             m_alpha;
   //--- Tooltip text
   string            m_tooltip_text;
   //--- Mode of text alignment
   bool              m_is_center_text;
   //--- Priority of the left mouse button click
   long              m_zorder;
   //---
public:
                     CElement(void);
                    ~CElement(void);
   //---
protected:
   //--- Creating a canvas
   bool              CreateCanvas(const string name,const int x,const int y,
                                  const int x_size,const int y_size,ENUM_COLOR_FORMAT clr_format=COLOR_FORMAT_ARGB_NORMALIZE);
   //---
public:
   //--- Stores and returns the pointer to the form
   CWindow          *WindowPointer(void)                             { return(::GetPointer(m_wnd));     }
   void              WindowPointer(CWindow &object)                  { m_wnd=::GetPointer(object);      }
   //--- Stores and returns pointer to (1) the main control 
   //    (2) returns the pointer to the control's canvas, (3) returns the pointer to the group of images
   CElement         *MainPointer(void)                               { return(::GetPointer(m_main));    }
   void              MainPointer(CElement &object)                   { m_main=::GetPointer(object);     }
   CRectCanvas      *CanvasPointer(void)                             { return(::GetPointer(m_canvas));  }
   //--- (1) Getting the number of nested controls, (2) free the array of nested controls
   int               ElementsTotal(void)                       const { return(::ArraySize(m_elements)); }
   void              FreeElementsArray(void)                         { ::ArrayFree(m_elements);         }
   //--- Returns the pointer of the nested control at the specified index
   CElement         *Element(const uint index);
   //--- Value of the alpha channel (transparency of the control)
   void              Alpha(const uchar value)                        { m_alpha=value;                   }
   uchar             Alpha(void)                               const { return(m_alpha);                 }
   //--- (1) Tooltip, (2) tooltip display mode
   void              Tooltip(const string text)                      { m_tooltip_text=text;             }
   string            Tooltip(void)                             const { return(m_tooltip_text);          }
   void              ShowTooltip(const bool state);
   //--- Color of the background in different states
   void              BackColor(const color clr)                      { m_back_color=clr;                }
   color             BackColor(void)                           const { return(m_back_color);            }
   void              BackColorHover(const color clr)                 { m_back_color_hover=clr;          }
   color             BackColorHover(void)                      const { return(m_back_color_hover);      }
   void              BackColorLocked(const color clr)                { m_back_color_locked=clr;         }
   color             BackColorLocked(void)                     const { return(m_back_color_locked);     }
   void              BackColorPressed(const color clr)               { m_back_color_pressed=clr;        }
   color             BackColorPressed(void)                    const { return(m_back_color_pressed);    }
   //--- Color of the border in different states
   void              BorderColor(const color clr)                    { m_border_color=clr;              }
   color             BorderColor(void)                         const { return(m_border_color);          }
   void              BorderColorHover(const color clr)               { m_border_color_hover=clr;        }
   color             BorderColorHover(void)                    const { return(m_border_color_hover);    }
   void              BorderColorLocked(const color clr)              { m_border_color_locked=clr;       }
   color             BorderColorLocked(void)                   const { return(m_border_color_locked);   }
   void              BorderColorPressed(const color clr)             { m_border_color_pressed=clr;      }
   color             BorderColorPressed(void)                  const { return(m_border_color_pressed);  }
   //--- Colors of the text label in different states
   void              LabelColor(const color clr)                     { m_label_color=clr;               }
   color             LabelColor(void)                          const { return(m_label_color);           }
   void              LabelColorHover(const color clr)                { m_label_color_hover=clr;         }
   color             LabelColorHover(void)                     const { return(m_label_color_hover);     }
   void              LabelColorLocked(const color clr)               { m_label_color_locked=clr;        }
   color             LabelColorLocked(void)                    const { return(m_label_color_locked);    }
   void              LabelColorPressed(const color clr)              { m_label_color_pressed=clr;       }
   color             LabelColorPressed(void)                   const { return(m_label_color_pressed);   }
   //--- Icon margins
   void              IconXGap(const int x_gap)                       { m_icon_x_gap=x_gap;              }
   int               IconXGap(void)                            const { return(m_icon_x_gap);            }
   void              IconYGap(const int y_gap)                       { m_icon_y_gap=y_gap;              }
   int               IconYGap(void)                            const { return(m_icon_y_gap);            }
   //--- (1) Description text of the edit box, (2) margins of the text label
   void              LabelText(const string text)                    { m_label_text=text;               }
   string            LabelText(void)                           const { return(m_label_text);            }
   void              LabelXGap(const int x_gap)                      { m_label_x_gap=x_gap;             }
   int               LabelXGap(void)                           const { return(m_label_x_gap);           }
   void              LabelYGap(const int y_gap)                      { m_label_y_gap=y_gap;             }
   int               LabelYGap(void)                           const { return(m_label_y_gap);           }
   //--- (1) Font and (2) font size
   void              Font(const string font)                         { m_font=font;                     }
   string            Font(void)                                const { return(m_font);                  }
   void              FontSize(const int font_size)                   { m_font_size=font_size;           }
   int               FontSize(void)                            const { return(m_font_size);             }
   //--- (1) Align the text to the center, (2) priority of the left mouse click
   void              IsCenterText(const bool state)                  { m_is_center_text=state;          }
   bool              IsCenterText(void)                        const { return(m_is_center_text);        }
   long              Z_Order(void)                             const { return(m_zorder);                }
   void              Z_Order(const long z_order);
   //--- Locking the control
   virtual void      IsLocked(const bool state);
   //--- Control availability
   virtual void      IsAvailable(const bool state);
   //--- Indent for the images of the specified group
   int               ImageGroupXGap(const uint index);
   void              ImageGroupXGap(const uint index,const int x_gap);
   //--- Setting icons for the active and locked states
   void              IconFile(const string file_path);
   string            IconFile(void);
   void              IconFileLocked(const string file_path);
   string            IconFileLocked(void);
   //--- Setting icons for the control in the pressed state (available/locked)
   void              IconFilePressed(const string file_path);
   string            IconFilePressed(void);
   void              IconFilePressedLocked(const string file_path);
   string            IconFilePressedLocked(void);
   //--- Returns the number of image groups
   uint              ImagesGroupTotal(void) const { return(::ArraySize(m_images_group)); }
   //--- Returns the number of images in the specified group
   int               ImagesTotal(const uint group_index);
   //--- Adding a group of images with an array of images
   void              AddImagesGroup(const int x_gap,const int y_gap,const string &file_pathways[]);
   //--- Adding a group of images
   void              AddImagesGroup(const int x_gap,const int y_gap);
   //--- Adding the image to the specified group
   void              AddImage(const uint group_index,const string file_path);
   //--- Setting/replacing image
   void              SetImage(const uint group_index,const uint image_index,const string file_path);
   //--- Switching the image
   void              ChangeImage(const uint group_index,const uint image_index);
   //--- Returns the image selected for display in the specified group
   int               SelectedImage(const uint group_index=0);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {}
   //--- Timer
   virtual void      OnEventTimer(void) {}
   //--- Moving the control
   virtual void      Moving(const bool only_visible=true);
   //--- (1) Show, (2) hide, (3) move to the top layer, (4) delete
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Reset(void);
   virtual void      Delete(void);
   //--- (1) Setting, (2) resetting priorities of the left mouse click
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Updates the control to display the latest changes
   virtual void      Update(const bool redraw=false);
   //--- Draws the control
   virtual void      Draw(void) {}
   //---
protected:
   //--- Method for adding pointers to child controls to the common array
   void              AddToArray(CElement &object);
   //--- Checking for exceeding the range of image groups
   virtual bool      CheckOutOfRange(const uint group_index,const uint image_index);
   //--- Checking the presence of pointer to the main control
   bool              CheckMainPointer(void);

   //--- Calculation of absolute coordinates
   int               CalculateX(const int x_gap);
   int               CalculateY(const int y_gap);
   //--- Calculation of the relative coordinates from the edge of the form
   int               CalculateXGap(const int x);
   int               CalculateYGap(const int y);

   //--- Draws the background
   virtual void      DrawBackground(void);
   //--- Draws the frame
   virtual void      DrawBorder(void);
   //--- Draws the image
   virtual void      DrawImage(void);
   //--- Draw text
   virtual void      DrawText(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CElement::CElement(void) : m_alpha(255),
                           m_tooltip_text("\n"),
                           m_back_color(clrNONE),
                           m_back_color_hover(clrNONE),
                           m_back_color_locked(clrNONE),
                           m_back_color_pressed(clrNONE),
                           m_border_color(clrNONE),
                           m_border_color_hover(clrNONE),
                           m_border_color_locked(clrNONE),
                           m_border_color_pressed(clrNONE),
                           m_icon_x_gap(WRONG_VALUE),
                           m_icon_y_gap(WRONG_VALUE),
                           m_label_text(""),
                           m_label_x_gap(WRONG_VALUE),
                           m_label_y_gap(WRONG_VALUE),
                           m_label_color(clrNONE),
                           m_label_color_hover(clrNONE),
                           m_label_color_locked(clrNONE),
                           m_label_color_pressed(clrNONE),
                           m_font("Calibri"),
                           m_font_size(8),
                           m_is_center_text(false),
                           m_zorder(WRONG_VALUE)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CElement::~CElement(void)
  {
  }
//+------------------------------------------------------------------+
//| Creating a canvas for drawing a control                          |
//+------------------------------------------------------------------+
bool CElement::CreateCanvas(const string name,const int x,const int y,
                            const int x_size,const int y_size,ENUM_COLOR_FORMAT clr_format=COLOR_FORMAT_ARGB_NORMALIZE)
  {
//--- Adjust the sizes
   int xsize =(x_size<1)? 50 : x_size;
   int ysize =(y_size<1)? 20 : y_size;
//--- Reset the last error
   ::ResetLastError();
//--- Creating an object
   if(!m_canvas.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,xsize,ysize,clr_format))
     {
      ::Print(__FUNCTION__," > Failed to create a canvas for drawing the ("+m_class_name+") control: ",::GetLastError());
      return(false);
     }
//--- Reset the last error
   ::ResetLastError();
//--- Get the pointer to the base class
   CChartObject *chart=::GetPointer(m_canvas);
//--- Attach to the chart
   if(!chart.Attach(m_chart_id,name,(int)m_subwin,(int)1))
     {
      ::Print(__FUNCTION__," > Failed to attach the canvas to the chart: ",::GetLastError());
      return(false);
     }
//--- Properties
   m_canvas.Tooltip("\n");
   m_canvas.Corner(m_corner);
   m_canvas.Selectable(false);
//--- All controls, except the form, have a higher priority than the main control
   Z_Order((dynamic_cast<CWindow*>(&this)!=NULL)? 0 : m_main.Z_Order()+1);
//--- Coordinates
   m_canvas.X(x);
   m_canvas.Y(y);
//--- Size
   m_canvas.XSize(x_size);
   m_canvas.YSize(y_size);
//--- Offsets from the extreme point
   m_canvas.XGap(CalculateXGap(x));
   m_canvas.YGap(CalculateYGap(y));
   return(true);
  }
//+------------------------------------------------------------------+
//| Return the indent for the images of the specified group          |
//+------------------------------------------------------------------+
int CElement::ImageGroupXGap(const uint index)
  {
//--- Return the object pointer
   return(m_images_group[index].m_x_gap);
  }
//+------------------------------------------------------------------+
//| Set the indent for the images of the specified group             |
//+------------------------------------------------------------------+
void CElement::ImageGroupXGap(const uint index,const int x_gap)
  {
   m_images_group[index].m_x_gap=x_gap;
  }
//+------------------------------------------------------------------+
//| Returns the pointer of the nested control                        |
//+------------------------------------------------------------------+
CElement *CElement::Element(const uint index)
  {
   uint array_size=::ArraySize(m_elements);
//--- Verifying the size of the object array
   if(array_size<1)
     {
      ::Print(__FUNCTION__," > This control ("+m_class_name+") has no child controls!");
      return(NULL);
     }
//--- Adjustment in case the range has been exceeded
   uint i=(index>=array_size)? array_size-1 : index;
//--- Return the object pointer
   return(::GetPointer(m_elements[i]));
  }
//+------------------------------------------------------------------+
//| Setting the tooltip display                                      |
//+------------------------------------------------------------------+
void CElement::ShowTooltip(const bool state)
  {
   if(state)
      m_canvas.Tooltip(m_tooltip_text);
   else
      m_canvas.Tooltip("\n");
  }
//+------------------------------------------------------------------+
//| Priority of left mouse click                                     |
//+------------------------------------------------------------------+
void CElement::Z_Order(const long z_order)
  {
   m_zorder=z_order;
   SetZorders();
  }
//+------------------------------------------------------------------+
//| Lock/unlock the control                                          |
//+------------------------------------------------------------------+
void CElement::IsLocked(const bool state)
  {
//--- Leave, if already set
   if(state==CElementBase::IsLocked())
      return;
//--- Store the state
   CElementBase::IsLocked(state);
//--- Other controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].IsLocked(state);
//--- Checking the pointer
   if(::CheckPointer(m_main)==POINTER_INVALID)
      return;
//--- The event sends only the main control of the compound group
   if(this.Id()!=m_main.Id())
     {
      ::EventChartCustom(m_chart_id,ON_SET_LOCKED,CElementBase::Id(),(int)state,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
   else
     {
      if(state!=m_main.IsLocked())
        {
         ::EventChartCustom(m_chart_id,ON_SET_LOCKED,CElementBase::Id(),(int)state,"");
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
        }
     }
  }
//+------------------------------------------------------------------+
//| Control availability                                             |
//+------------------------------------------------------------------+
void CElement::IsAvailable(const bool state)
  {
//--- Leave, if already set
   if(state==CElementBase::IsAvailable())
      return;
//--- Set
   CElementBase::IsAvailable(state);
//--- Other controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].IsAvailable(state);
//--- Set priorities of the left mouse button click
   if(state)
      SetZorders();
   else
      ResetZorders();
  }
//+------------------------------------------------------------------+
//| Setting an icon for the active state                             |
//+------------------------------------------------------------------+
void CElement::IconFile(const string file_path)
  {
//--- If there are no image groups yet
   if(ImagesGroupTotal()<1)
     {
      m_icon_x_gap =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
      m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
      //--- Add a group and an image
      AddImagesGroup(m_icon_x_gap,m_icon_y_gap);
      AddImage(0,file_path);
      AddImage(1,"");
      //--- The default image
      m_images_group[0].m_selected_image=0;
      return;
     }
//--- Set the image to the first group as the first element
   SetImage(0,0,file_path);
  }
//+------------------------------------------------------------------+
//| Returns the icon                                                 |
//+------------------------------------------------------------------+
string CElement::IconFile(void)
  {
//--- Empty string, if there are no image groups
   if(ImagesGroupTotal()<1)
      return("");
//--- If there are no images in the group
   if(::ArraySize(m_images_group[0].m_image)<1)
      return("");
//--- Return the path to the image
   return(m_images_group[0].m_image[0].BmpPath());
  }
//+------------------------------------------------------------------+
//| Setting an icon for the locked state                             |
//+------------------------------------------------------------------+
void CElement::IconFileLocked(const string file_path)
  {
//--- If there are no image groups yet
   if(ImagesGroupTotal()<1)
     {
      m_icon_x_gap =(m_icon_x_gap!=WRONG_VALUE)? m_icon_x_gap : 0;
      m_icon_y_gap =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 0;
      //--- Add a group and an image
      AddImagesGroup(m_icon_x_gap,m_icon_y_gap);
      AddImage(0,"");
      AddImage(1,file_path);
      //--- The default image
      m_images_group[0].m_selected_image=0;
      return;
     }
//--- Set the image to the first group as the second element
   SetImage(0,1,file_path);
  }
//+------------------------------------------------------------------+
//| Returns the icon                                                 |
//+------------------------------------------------------------------+
string CElement::IconFileLocked(void)
  {
//--- Empty string, if there are no image groups
   if(ImagesGroupTotal()<1)
      return("");
//--- If there are no images in the group
   if(::ArraySize(m_images_group[0].m_image)<2)
      return("");
//--- Return the path to the image
   return(m_images_group[0].m_image[1].BmpPath());
  }
//+------------------------------------------------------------------+
//| Setting the icon for the pressed state (available)               |
//+------------------------------------------------------------------+
void CElement::IconFilePressed(const string file_path)
  {
//--- Add an area for the image if it does not exist already
   while(!CElement::CheckOutOfRange(0,2))
      AddImage(0,"");
//--- Set the icon
   CElement::SetImage(0,2,file_path);
  }
//+------------------------------------------------------------------+
//| Returns the icon                                                 |
//+------------------------------------------------------------------+
string CElement::IconFilePressed(void)
  {
//--- Empty string, if there are no image groups
   if(ImagesGroupTotal()<1)
      return("");
//--- If there are no images in the group
   if(::ArraySize(m_images_group[0].m_image)<3)
      return("");
//--- Return the path to the image
   return(m_images_group[0].m_image[2].BmpPath());
  }
//+------------------------------------------------------------------+
//| Setting the icon for the pressed state (locked)                  |
//+------------------------------------------------------------------+
void CElement::IconFilePressedLocked(const string file_path)
  {
//--- Add an area for the image if it does not exist already
   while(!CElement::CheckOutOfRange(0,3))
      AddImage(0,"");
//--- Set the icon
   CElement::SetImage(0,3,file_path);
  }
//+------------------------------------------------------------------+
//| Returns the icon                                                 |
//+------------------------------------------------------------------+
string CElement::IconFilePressedLocked(void)
  {
//--- Empty string, if there are no image groups
   if(ImagesGroupTotal()<1)
      return("");
//--- If there are no images in the group
   if(::ArraySize(m_images_group[0].m_image)<4)
      return("");
//--- Return the path to the image
   return(m_images_group[0].m_image[3].BmpPath());
  }
//+------------------------------------------------------------------+
//| Updating the control                                             |
//+------------------------------------------------------------------+
void CElement::Update(const bool redraw=false)
  {
//--- With redrawing the control
   if(redraw)
     {
      Draw();
      m_canvas.Update();
      return;
     }
//--- Apply
   m_canvas.Update();
  }
//+------------------------------------------------------------------+
//| Moving the control                                               |
//+------------------------------------------------------------------+
void CElement::Moving(const bool only_visible=true)
  {
//--- Leave, if the control is hidden
   if(only_visible)
      if(!CElementBase::IsVisible())
         return;
//--- If the anchored to the right
   if(m_anchor_right_window_side)
     {
      //--- Storing coordinates in the control fields
      CElementBase::X(m_main.X2()-XGap());
      //--- Storing coordinates in the fields of the objects
      m_canvas.X(m_main.X2()-m_canvas.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_canvas.X(m_main.X()+m_canvas.XGap());
     }
//--- If the anchored to the bottom
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_canvas.Y(m_main.Y2()-m_canvas.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_canvas.Y(m_main.Y()+m_canvas.YGap());
     }
//--- Updating coordinates of graphical objects
   m_canvas.X_Distance(m_canvas.X());
   m_canvas.Y_Distance(m_canvas.Y());
//--- Moving the nested controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Shows the control                                                |
//+------------------------------------------------------------------+
void CElement::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of objects
   Moving();
//--- Show the object
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
//--- Show the nested controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
     {
      if(!m_elements[i].IsDropdown())
         m_elements[i].Show();
     }
  }
//+------------------------------------------------------------------+
//| Hides the control                                                |
//+------------------------------------------------------------------+
void CElement::Hide(void)
  {
//--- Leave, if the control is already hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide the object
   m_canvas.Timeframes(OBJ_NO_PERIODS);
//--- Visible state
   CElementBase::IsVisible(false);
   CElementBase::MouseFocus(false);
//--- Hide the nested controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Hide();
  }
//+------------------------------------------------------------------+
//| Moving to the top layer                                          |
//+------------------------------------------------------------------+
void CElement::Reset(void)
  {
//--- Leave, if this is a drop-down control
   if(CElementBase::IsDropdown())
      return;
//--- Hide and show the nested controls
   Hide();
   Show();
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CElement::Delete(void)
  {
//--- Removing objects
   m_canvas.Destroy();
//--- Delete the nested controls
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].Delete();
//--- Free the array of nested controls
   FreeElementsArray();
//--- Initializing of variables by default values
   CElementBase::MouseFocus(false);
   CElementBase::IsVisible(true);
   CElementBase::IsAvailable(true);
//--- Reset the priorities
   m_zorder=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CElement::SetZorders(void)
  {
   m_canvas.Z_Order(m_zorder);
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].SetZorders();
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CElement::ResetZorders(void)
  {
   m_canvas.Z_Order(WRONG_VALUE);
   int elements_total=ElementsTotal();
   for(int i=0; i<elements_total; i++)
      m_elements[i].ResetZorders();
  }
//+------------------------------------------------------------------+
//| Method for adding pointers to nested controls                    |
//+------------------------------------------------------------------+
void CElement::AddToArray(CElement &object)
  {
   int size=ElementsTotal();
   ::ArrayResize(m_elements,size+1);
   m_elements[size]=::GetPointer(object);
  }
//+------------------------------------------------------------------+
//| Checking for exceeding the range                                 |
//+------------------------------------------------------------------+
bool CElement::CheckOutOfRange(const uint group_index,const uint image_index)
  {
//--- Checking the group index
   uint images_group_total=::ArraySize(m_images_group);
   if(images_group_total<1 || group_index>=images_group_total)
      return(false);
//--- Checking the inage index
   uint images_total=::ArraySize(m_images_group[group_index].m_image);
   if(images_total<1 || image_index>=images_total)
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns the number of images in the specified group              |
//+------------------------------------------------------------------+
int CElement::ImagesTotal(const uint group_index)
  {
//--- Checking the group index
   uint images_group_total=::ArraySize(m_images_group);
   if(images_group_total<1 || group_index>=images_group_total)
      return(WRONG_VALUE);
//--- The number of images
   return(::ArraySize(m_images_group[group_index].m_image));
  }
//+------------------------------------------------------------------+
//| Adding a group of images with an array of images                 |
//+------------------------------------------------------------------+
void CElement::AddImagesGroup(const int x_gap,const int y_gap,const string &file_pathways[])
  {
//--- Get the size of the image groups array
   uint images_group_total=::ArraySize(m_images_group);
//--- Add one group
   ::ArrayResize(m_images_group,images_group_total+1);
//--- Set indents for the images
   m_images_group[images_group_total].m_x_gap =x_gap;
   m_images_group[images_group_total].m_y_gap =y_gap;
//--- The default image
   m_images_group[images_group_total].m_selected_image=0;
//--- Get the size of the array of the added images
   uint images_total=::ArraySize(file_pathways);
//--- Add images to a new group, if a non-empty array was passed
   for(uint i=0; i<images_total; i++)
      AddImage(images_group_total,file_pathways[i]);
  }
//+------------------------------------------------------------------+
//| Adding a group of images                                         |
//+------------------------------------------------------------------+
void CElement::AddImagesGroup(const int x_gap,const int y_gap)
  {
//--- Get the size of the image groups array
   uint images_group_total=::ArraySize(m_images_group);
//--- Add one group
   ::ArrayResize(m_images_group,images_group_total+1);
//--- Set indents for the images
   m_images_group[images_group_total].m_x_gap=x_gap;
   m_images_group[images_group_total].m_y_gap=y_gap;
//--- The default image
   m_images_group[images_group_total].m_selected_image=0;
  }
//+------------------------------------------------------------------+
//| Adding the image to the specified group                          |
//+------------------------------------------------------------------+
void CElement::AddImage(const uint group_index,const string file_path)
  {
//--- Get the size of the image groups array
   uint images_group_total=::ArraySize(m_images_group);
//--- Leave, if there are no groups
   if(images_group_total<1)
     {
      Print(__FUNCTION__,
            " > A group of images can be added using the CElement::AddImagesGroup() methods");
      return;
     }
//--- Prevention of exceeding the range
   uint check_group_index=(group_index<images_group_total)? group_index : images_group_total-1;
//--- Get the size of the images array
   uint images_total=::ArraySize(m_images_group[check_group_index].m_image);
//--- Increase the array size by one element
   ::ArrayResize(m_images_group[check_group_index].m_image,images_total+1);
//--- Add an image
   m_images_group[check_group_index].m_image[images_total].ReadImageData(file_path);
  }
//+------------------------------------------------------------------+
//| Setting/replacing image                                          |
//+------------------------------------------------------------------+
void CElement::SetImage(const uint group_index,const uint image_index,const string file_path)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(group_index,image_index))
      return;
//--- Delete the image
   m_images_group[group_index].m_image[image_index].DeleteImageData();
//--- Add an image
   m_images_group[group_index].m_image[image_index].ReadImageData(file_path);
  }
//+------------------------------------------------------------------+
//| Switching the image                                              |
//+------------------------------------------------------------------+
void CElement::ChangeImage(const uint group_index,const uint image_index)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(group_index,image_index))
      return;
//--- Store the index of the image to display
   m_images_group[group_index].m_selected_image=(int)image_index;
  }
//+------------------------------------------------------------------+
//| Returns the image selected for display in the specified group    |
//+------------------------------------------------------------------+
int CElement::SelectedImage(const uint group_index=0)
  {
//--- Leave, if there are no groups
   uint images_group_total=::ArraySize(m_images_group);
   if(images_group_total<1 || group_index>=images_group_total)
      return(WRONG_VALUE);
//--- Leave, if there are no images in the specified group
   uint images_total=::ArraySize(m_images_group[group_index].m_image);
   if(images_total<1)
      return(WRONG_VALUE);
//--- Return the image selected for display
   return(m_images_group[group_index].m_selected_image);
  }
//+------------------------------------------------------------------+
//| Checking the presence of pointer to the main control             |
//+------------------------------------------------------------------+
bool CElement::CheckMainPointer(void)
  {
//--- If there is no pointer
   if(::CheckPointer(m_main)==POINTER_INVALID)
     {
      //--- Output the message to the terminal journal
      ::Print(__FUNCTION__,
              " > Before creating a control... \n...it is necessary to pass a pointer to the main control: "+
              ClassName()+"::MainPointer(CElementBase &object)");
      //--- Terminate building the graphical interface of the application
      return(false);
     }
//--- Store the form pointer
   m_wnd=m_main.WindowPointer();
//--- Store the mouse cursor pointer
   m_mouse=m_main.MousePointer();
//--- Store the properties
   m_id       =m_wnd.LastId()+1;
   m_chart_id =m_wnd.ChartId();
   m_subwin   =m_wnd.SubwindowNumber();
//--- Send the flag of pointer presence
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculate the absolute X coordinate                              |
//+------------------------------------------------------------------+
int CElement::CalculateX(const int x_gap)
  {
   return((AnchorRightWindowSide())? m_main.X2()-x_gap : m_main.X()+x_gap);
  }
//+------------------------------------------------------------------+
//| Calculate the absolute Y coordinate                              |
//+------------------------------------------------------------------+
int CElement::CalculateY(const int y_gap)
  {
   return((AnchorBottomWindowSide())? m_main.Y2()-y_gap : m_main.Y()+y_gap);
  }
//+------------------------------------------------------------------+
//| Calculate the relative X coordinate from the edge of the form    |
//+------------------------------------------------------------------+
int CElement::CalculateXGap(const int x)
  {
   return((AnchorRightWindowSide())? m_main.X2()-x : x-m_main.X());
  }
//+------------------------------------------------------------------+
//| Calculate the relative Y coordinate from the edge of the form    |
//+------------------------------------------------------------------+
int CElement::CalculateYGap(const int y)
  {
   return((AnchorBottomWindowSide())? m_main.Y2()-y : y-m_main.Y());
  }
//+------------------------------------------------------------------+
//| Draws the background                                             |
//+------------------------------------------------------------------+
void CElement::DrawBackground(void)
  {
   m_canvas.Erase(::ColorToARGB(m_back_color,m_alpha));
  }
//+------------------------------------------------------------------+
//| Draws the border                                                 |
//+------------------------------------------------------------------+
void CElement::DrawBorder(void)
  {
//--- Coordinates
   int x1=0,y1=0;
   int x2=m_canvas.X_Size()-1;
   int y2=m_canvas.Y_Size()-1;
//--- Draw a rectangle without fill
   m_canvas.Rectangle(x1,y1,x2,y2,::ColorToARGB(m_border_color,m_alpha));
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CElement::DrawImage(void)
  {
//--- The number of groups
   uint group_total=ImagesGroupTotal();
//--- Draw the image
   for(uint g=0; g<group_total; g++)
     {
      //--- Index of the selected image
      int i=SelectedImage(g);
      //--- If there are no images
      if(i==WRONG_VALUE)
         continue;
      //--- Coordinates
      int x =m_images_group[g].m_x_gap;
      int y =m_images_group[g].m_y_gap;
      //--- Size
      uint height =m_images_group[g].m_image[i].Height();
      uint width  =m_images_group[g].m_image[i].Width();
      //--- Draw
      for(uint ly=0,p=0; ly<height; ly++)
        {
         for(uint lx=0; lx<width; lx++,p++)
           {
            //--- If there is no color, go to the next pixel
            if(m_images_group[g].m_image[i].Data(p)<1)
               continue;
            //--- Get the color of the lower layer and color of the specified pixel of the icon
            uint background  =::ColorToARGB(m_canvas.PixelGet(x+lx,y+ly));
            uint pixel_color =m_images_group[g].m_image[i].Data(p);
            //--- Blend the colors
            uint foreground=::ColorToARGB(m_clr.BlendColors(background,pixel_color));
            //--- Draw the pixel of the overlay icon
            m_canvas.PixelSet(x+lx,y+ly,foreground);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw text                                                        |
//+------------------------------------------------------------------+
void CElement::DrawText(void)
  {
//--- Coordinates
   int x =m_label_x_gap;
   int y =m_label_y_gap;
//--- Define the color for the text label
   color clr=clrBlack;
//--- If the control is locked
   if(m_is_locked)
      clr=m_label_color_locked;
   else
     {
      //--- If the control is released
      if(!m_is_pressed)
         clr=(m_mouse_focus)? m_label_color_hover : m_label_color;
      else
        {
         if(m_class_name=="CButton")
            clr=m_label_color_pressed;
         else
            clr=(m_mouse_focus)? m_label_color_hover : m_label_color_pressed;
        }
     }
//--- Font properties
   m_canvas.FontSet(m_font,-m_font_size*10,FW_NORMAL);
//--- Draw the text with consideration of the center alignment mode
   if(m_is_center_text)
     {
      x =m_x_size>>1;
      y =m_y_size>>1;
      m_canvas.TextOut(x,y,m_label_text,::ColorToARGB(clr),TA_CENTER|TA_VCENTER);
     }
   else
      m_canvas.TextOut(x,y,m_label_text,::ColorToARGB(clr),TA_LEFT);
  }
//+------------------------------------------------------------------+
