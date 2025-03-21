//+------------------------------------------------------------------+
//|                                                     ComboBox.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "ListView.mqh"
//+------------------------------------------------------------------+
//| Class for creating a combo box                                   |
//+------------------------------------------------------------------+
class CComboBox : public CElement
  {
private:
   //--- Instances for creating a control
   CButton           m_button;
   CListView         m_listview;
   //--- Mode of control with a checkbox
   bool              m_checkbox_mode;
   //---
public:
                     CComboBox(void);
                    ~CComboBox(void);
   //--- Methods for creating a combo box
   bool              CreateComboBox(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateButton(void);
   bool              CreateList(void);
   //---
public:
   //--- Returns pointers to (1) the button, (2) the list view and (3) the scrollbar
   CButton          *GetButtonPointer(void)                 { return(::GetPointer(m_button));         }
   CListView        *GetListViewPointer(void)               { return(::GetPointer(m_listview));       }
   CScrollV         *GetScrollVPointer(void)                { return(m_listview.GetScrollVPointer()); }
   //--- (1) The size of the list view (the number of items) (2) setting the mode of control with a checkbox
   void              ItemsTotal(const int items_total)      { m_listview.ListSize(items_total);       }
   void              CheckBoxMode(const bool state)         { m_checkbox_mode=state;                  }
   //--- Control state (pressed/released)
   bool              IsPressed(void) const { return(m_is_pressed); }
   void              IsPressed(const bool state);
   //--- Stores the passed value in the list view by specified index
   void              SetValue(const int item_index,const string item_text);
   //--- Returns the value selected in the list view
   string            GetValue(void);
   //--- Highlighting the item by specified index
   void              SelectItem(const int item_index);
   //--- Changes the current state of the combo box for the opposite
   void              ChangeComboBoxListState(void);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Lock
   virtual void      IsLocked(const bool state);
   //--- Managing visibility
   //virtual void      Show(void);
   virtual void      Hide(void);
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Handle clicking the control
   bool              OnClickElement(const string pressed_object);
   //--- Handling the pressing of a button
   bool              OnClickButton(const string pressed_object,const int id,const int index);
   //--- Handling the pressing on the list view item
   bool              OnClickListItem(const int id);

   //--- Checking pressing of the left button of the mouse over the combo box button
   void              CheckPressedOverButton(void);
   //--- Draws the image
   virtual void      DrawImage(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CComboBox::CComboBox(void) : m_checkbox_mode(false)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Drop-down list view mode
   m_listview.IsDropdown(true);
   m_listview.GetScrollVPointer().IsDropdown(true);
   m_listview.GetScrollVPointer().GetIncButtonPointer().IsDropdown(true);
   m_listview.GetScrollVPointer().GetDecButtonPointer().IsDropdown(true);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CComboBox::~CComboBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CComboBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Check of the pressed left mouse button over the button
      CheckPressedOverButton();
      //--- Redraw the control
      if(CheckCrossingBorder())
         Update(true);
      //---
      return;
     }
//--- Handling the list view item press event
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_LIST_ITEM)
     {
      if(!OnClickListItem((int)lparam))
         return;
      //---
      return;
     }
//--- Handle clicking the control
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      if(OnClickElement(sparam))
         return;
      //---
      return;
     }
//--- Handling event of clicking on the button
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(OnClickButton(sparam,(uint)lparam,(uint)dparam))
         return;
      //---
      return;
     }
//--- Handle event of changing chart properties
   if(id==CHARTEVENT_CHART_CHANGE)
     {
      //--- Leave, if (1) the control is locked or (2) the button is released
      if(CElementBase::IsLocked() || !m_button.IsPressed())
         return;
      //--- Release the button
      m_button.IsPressed(false);
      //--- Change the state of list
      ChangeComboBoxListState();
      return;
     }
  }
//+------------------------------------------------------------------+
//| Creates a group of the combo box objects                         |
//+------------------------------------------------------------------+
bool CComboBox::CreateComboBox(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateButton())
      return(false);
   if(!CreateList())
      return(false);
//--- Set the text to the button
   m_button.LabelText(m_listview.SelectedItemText());
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CComboBox::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1)? 100 : m_x_size;
   m_y_size     =(m_y_size<1)? 20 : m_y_size;
   m_label_text =text;
//--- Background color and indents for the icon/checkbox
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Margins and color of the text label
   m_icon_y_gap          =(m_icon_y_gap!=WRONG_VALUE)? m_icon_y_gap : 4;
   m_label_x_gap         =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : (m_checkbox_mode)? 20 : 0;
   m_label_y_gap         =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 4;
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
bool CComboBox::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("combobox");
//--- If a control with a checkbox is required
   if(m_checkbox_mode)
     {
      IconFile("Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp");
      IconFileLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_off_locked.bmp");
      IconFilePressed("Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp");
      IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\checkbox_on_locked.bmp");
     }
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates button                                                   |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\up_thin_black.bmp"
#resource "\\Images\\EasyAndFastGUI\\Controls\\down_thin_black.bmp"
//---
bool CComboBox::CreateButton(void)
  {
//--- Store the pointer to the parent control
   m_button.MainPointer(this);
//--- Size
   int x_size=(m_button.XSize()<1)? 80 : m_button.XSize();
//--- Coordinates
   int x =(m_button.XGap()<1)? x_size : m_button.XGap();
   int y =0;
//--- Margins for the image
   int icon_x_gap =(m_button.IconXGap()<1)? x_size-18 : m_button.IconXGap();
   int icon_y_gap =(m_button.IconYGap()<1)? 2 : m_button.IconYGap();
//--- Margins for the text
   int label_x_gap =(m_button.LabelXGap()<1)? 7 : m_button.LabelXGap();
   int label_y_gap =(m_button.LabelYGap()<1)? 4 : m_button.LabelYGap();
//--- Properties
   m_button.NamePart("combobox_button");
   m_button.Index(0);
   m_button.TwoState(true);
   m_button.XSize(x_size);
   m_button.YSize(m_y_size);
   m_button.IconXGap(icon_x_gap);
   m_button.IconYGap(icon_y_gap);
   m_button.LabelXGap(label_x_gap);
   m_button.LabelYGap(label_y_gap);
   m_button.IsDropdown(CElementBase::IsDropdown());
   m_button.IconFile("Images\\EasyAndFastGUI\\Controls\\down_thin_black.bmp");
   m_button.IconFileLocked("Images\\EasyAndFastGUI\\Controls\\down_thin_black.bmp");
   m_button.IconFilePressed("Images\\EasyAndFastGUI\\Controls\\up_thin_black.bmp");
   m_button.IconFilePressedLocked("Images\\EasyAndFastGUI\\Controls\\up_thin_black.bmp");
//--- Create a control
   if(!m_button.CreateButton("",x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_button);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the list view                                            |
//+------------------------------------------------------------------+
bool CComboBox::CreateList(void)
  {
//--- Store the pointer to the main control
   m_listview.MainPointer(this);
//--- Coordinates
   int x =m_button.XGap();
   int y =m_button.YSize();
//--- Size
   int x_size =(m_listview.XSize()<1)? m_button.XSize() : m_listview.XSize();
   int y_size =(m_listview.YSize()<1)? 93 : m_listview.YSize();
//--- Properties
   m_listview.XSize(x_size);
   m_listview.YSize(y_size);
   m_listview.AnchorRightWindowSide(m_button.AnchorRightWindowSide());
//--- Create a control
   if(!m_listview.CreateListView(x,y))
      return(false);
//--- Hide the list view
   m_listview.Hide();
//--- Add the control to the array
   CElement::AddToArray(m_listview);
   return(true);
  }
//+------------------------------------------------------------------+
//| Setting the control state (pressed/released)                     |
//+------------------------------------------------------------------+
void CComboBox::IsPressed(const bool state)
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
//| Stores the passed value in the list view by the specified index  |
//+------------------------------------------------------------------+
void CComboBox::SetValue(const int item_index,const string item_text)
  {
   m_listview.SetValue(item_index,item_text);
  }
//+------------------------------------------------------------------+
//| Returns the value selected in the list view                      |
//+------------------------------------------------------------------+
string CComboBox::GetValue(void)
  {
   return(m_listview.SelectedItemText());
  }
//+------------------------------------------------------------------+
//| Select the item by specified index                               |
//+------------------------------------------------------------------+
void CComboBox::SelectItem(const int item_index)
  {
//--- Highlight the item in the list view
   m_listview.SelectItem(item_index);
//--- Set the text to the button
   m_button.LabelText(m_listview.SelectedItemText());
  }
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
void CComboBox::IsLocked(const bool state)
  {
   CElement::IsLocked(state);
//--- Set the corresponding icon
   CElement::ChangeImage(0,(m_is_locked)? !m_is_pressed? 1 : 3 : !m_is_pressed? 0 : 2);
  }
//+------------------------------------------------------------------+
//| Lock                                                             |
//+------------------------------------------------------------------+
//void CComboBox::Show(void)
//  {
//   CElement::Show();
//   m_button.Show();
//   m_listview.Hide();
//  }
//+------------------------------------------------------------------+
//| Hide                                                             |
//+------------------------------------------------------------------+
void CComboBox::Hide(void)
  {
   CElement::Hide();
//--- Release the button
   m_button.IsPressed(false);
  }
//+------------------------------------------------------------------+
//| Changes the current state of the combo box for the opposite      |
//+------------------------------------------------------------------+
void CComboBox::ChangeComboBoxListState(void)
  {
//--- If the button is pressed
   if(m_button.IsPressed())
     {
      //--- Show the list view
      m_listview.Show();
      //--- Send a message to determine the available controls
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
   else
     {
      //--- Hide the list view
      m_listview.Hide();
      //--- Send a message to restore the controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
     }
  }
//+------------------------------------------------------------------+
//| Pressing the checkbox                                            |
//+------------------------------------------------------------------+
bool CComboBox::OnClickElement(const string pressed_object)
  {
//--- Leave, if (1) the control is locked or (2) it has a different object name
   if(CElementBase::IsLocked() || m_canvas.Name()!=pressed_object)
      return(false);
//--- If the checkbox is enabled
   if(m_checkbox_mode)
     {
      //--- Switch to the opposite state
      IsPressed(!(IsPressed()));
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),CElementBase::Index(),"");
     }
//--- Draw the control
   CElement::Update(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Pressing on the combo box button                                 |
//+------------------------------------------------------------------+
bool CComboBox::OnClickButton(const string pressed_object,const int id,const int index)
  {
//--- Leave, if the pressing was on another control
   if(!m_button.CheckElementName(pressed_object))
      return(false);
//--- Leave, if the values do not match
   if(id!=m_button.Id() || index!=m_button.Index())
      return(false);
//--- Change the state of list
   ChangeComboBoxListState();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_BUTTON,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing on the list view item                      |
//+------------------------------------------------------------------+
bool CComboBox::OnClickListItem(const int id)
  {
//--- Leave, if the values do not match
   if(id!=CElementBase::Id())
      return(false);
//--- Release the button
   m_button.IsPressed(false);
//--- Set the text to the button
   m_button.LabelText(m_listview.SelectedItemText());
   m_button.Update(true);
//--- Change the state of list
   ChangeComboBoxListState();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_COMBOBOX_ITEM,CElementBase::Id(),0,m_label_text);
   return(true);
  }
//+------------------------------------------------------------------+
//| Check of the pressed left mouse button over the button           |
//+------------------------------------------------------------------+
void CComboBox::CheckPressedOverButton(void)
  {
//--- Leave, if the button is already released
   if(!m_button.IsPressed())
      return;
//--- Leave, if (1) the control is locked or (2) the left mouse button is released
   if(CElementBase::IsLocked() || !m_mouse.LeftButtonState())
      return;
//--- If there is no focus
   if(!CElementBase::MouseFocus() && !m_button.MouseFocus())
     {
      //--- Leave, if the focus is over the list view or the scrollbar is active
      if(m_listview.MouseFocus() || m_listview.ScrollState())
         return;
      //--- Hide the list view
      m_listview.Hide();
      m_button.IsPressed(false);
      m_button.Update(true);
      //--- Draw the control
      Update(true);
      //--- Send a message to restore the controls
      
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0.0,"");
     }
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CComboBox::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw icon
   CElement::DrawImage();
//--- Draw text
   CElement::DrawText();
  }
//+------------------------------------------------------------------+
//| Draws the image                                                  |
//+------------------------------------------------------------------+
void CComboBox::DrawImage(void)
  {
//--- Leave, if (1) the checkbox is not required or (2) icon is not defined
   if(!m_checkbox_mode || CElement::IconFile()=="")
      return;
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
