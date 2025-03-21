//+------------------------------------------------------------------+
//|                                                   MainWindow.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Program.mqh"
//+------------------------------------------------------------------+
//| Creates a form for controls                                      |
//+------------------------------------------------------------------+
bool CProgram::CreateWindow(const string caption_text)
  {
//--- Add the window pointer to the window array
   CWndContainer::AddWindow(m_window);
//--- Coordinates
   int x=(m_window.X()>0) ? m_window.X() : 1;
   int y=(m_window.Y()>0) ? m_window.Y() : 1;
//--- Properties
   m_window.XSize(400);
   m_window.YSize(400);
   m_window.Alpha(200);
   m_window.IconXGap(3);
   m_window.IconYGap(2);
   m_window.IsMovable(true);
   m_window.ResizeMode(true);
   m_window.CloseButtonIsUsed(true);
   m_window.FullscreenButtonIsUsed(true);
   m_window.CollapseButtonIsUsed(true);
   m_window.TooltipsButtonIsUsed(true);
   m_window.RollUpSubwindowMode(true,true);
   m_window.TransparentOnlyCaption(false);
//--- Set the tooltips
   m_window.GetCloseButtonPointer().Tooltip("Close");
   m_window.GetFullscreenButtonPointer().Tooltip("Fullscreen/Minimize");
   m_window.GetCollapseButtonPointer().Tooltip("Collapse/Expand");
   m_window.GetTooltipButtonPointer().Tooltip("Tooltips");
//--- Creating a form
   if(!m_window.CreateWindow(m_chart_id,m_subwin,caption_text,x,y))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the status bar                                           |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp"
//---
bool CProgram::CreateStatusBar(const int x_gap,const int y_gap)
  {
#define STATUS_LABELS_TOTAL 2
//--- Store the pointer to the main control
   m_status_bar.MainPointer(m_window);
//--- Width
   int width[]={0,130};
//--- Properties
   m_status_bar.YSize(22);
   m_status_bar.AutoXResizeMode(true);
   m_status_bar.AutoXResizeRightOffset(1);
   m_status_bar.AnchorBottomWindowSide(true);
//--- Add items
   for(int i=0; i<STATUS_LABELS_TOTAL; i++)
      m_status_bar.AddItem(width[i]);
//--- Setting the text
   m_status_bar.SetValue(0,"For Help, press F1");
   m_status_bar.SetValue(1,"Disconnected...");
//--- Setting the icons
   m_status_bar.GetItemPointer(1).LabelXGap(25);
   m_status_bar.GetItemPointer(1).AddImagesGroup(5,3);
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_1.bmp");
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_2.bmp");
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_3.bmp");
   m_status_bar.GetItemPointer(1).AddImage(0,"Images\\EasyAndFastGUI\\Icons\\bmp16\\server_off_4.bmp");
//--- Create a control
   if(!m_status_bar.CreateStatusBar(x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_status_bar);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates text label 1                                             |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Controls\\resize_window.bmp"
//---
bool CProgram::CreatePicture1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_picture1.MainPointer(m_status_bar);
//--- Properties
   m_picture1.XSize(8);
   m_picture1.YSize(8);
   m_picture1.IconFile("Images\\EasyAndFastGUI\\Controls\\resize_window.bmp");
   m_picture1.AnchorRightWindowSide(true);
   m_picture1.AnchorBottomWindowSide(true);
//--- Creating the button
   if(!m_picture1.CreatePicture(x_gap,y_gap))
      return(false);
//--- Add the pointer to control to the base
   CWndContainer::AddToElementsArray(0,m_picture1);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a rendered table                                          |
//+------------------------------------------------------------------+
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\arrow_up.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\arrow_down.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\circle_gray.bmp"
#resource "\\Images\\EasyAndFastGUI\\Icons\\bmp16\\calendar.bmp"
//---
bool CProgram::CreateTable(const int x_gap,const int y_gap)
  {
#define COLUMNS1_TOTAL 5
#define ROWS1_TOTAL    20
//--- Store the pointer to the main control
   m_table.MainPointer(m_window);
//--- Array of column widths
   int width[COLUMNS1_TOTAL];
   ::ArrayInitialize(width,80);
   width[0]=122;
//--- Array of text offset along the X axis in the columns
   int text_x_offset[COLUMNS1_TOTAL];
   ::ArrayInitialize(text_x_offset,7);
   text_x_offset[0]=25;
   text_x_offset[4]=25;
//--- Array of text alignment in columns
   ENUM_ALIGN_MODE align[COLUMNS1_TOTAL];
   ::ArrayInitialize(align,ALIGN_LEFT);
//--- Array of column image offsets along the X axis
   int image_x_offset[COLUMNS1_TOTAL];
   ::ArrayInitialize(image_x_offset,3);
   image_x_offset[0]=6;
   image_x_offset[4]=5;
//--- Array of column image offsets along the Y axis
   int image_y_offset[COLUMNS1_TOTAL];
   ::ArrayInitialize(image_y_offset,2);
   image_y_offset[0]=4;
//--- Properties
   m_table.XSize(602);
   m_table.YSize(190);
   m_table.CellYSize(20);
   m_table.TableSize(COLUMNS1_TOTAL,ROWS1_TOTAL);
   m_table.TextAlign(align);
   m_table.ColumnsWidth(width);
   m_table.TextXOffset(text_x_offset);
   m_table.ImageXOffset(image_x_offset);
   m_table.ImageYOffset(image_y_offset);
   m_table.LabelXGap(5);
   m_table.LabelYGap(4);
   m_table.IconXGap(7);
   m_table.IconYGap(4);
   m_table.MinColumnWidth(0);
   m_table.ShowHeaders(true);
   m_table.IsSortMode(true);
   m_table.LightsHover(false);
   m_table.SelectableRow(false);
   m_table.IsWithoutDeselect(false);
   m_table.ColumnResizeMode(true);
   m_table.IsZebraFormatRows(clrWhiteSmoke);
   m_table.AutoXResizeMode(true);
   m_table.AutoXResizeRightOffset(7);
   m_table.AutoYResizeBottomOffset(28);
//--- Populate the table with data
   InitializingTable();
//--- Create a control
   if(!m_table.CreateTable(x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_table);
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialize the table                                             |
//+------------------------------------------------------------------+
void CProgram::InitializingTable(void)
  {
//--- Array of the text displayed in the table cells
   string text_array[20]=
     {
      "List of Controls",
      "Base Classes of the Standard Library as Primitive Objects",
      "Derived Classes of Primitive Objects with Additional Methods",
      "The Base Class for all Controls",
      "Test of Event Handlers of the Library and Program Classes",
      "The Form Class for Controls",
      "Methods for Creating a Form",
      "Attaching a Form to a Chart",
      "Managing the Graphical Interface",
      "Functionality for Moving the Form",
      "Testing Movement of the Form over the Chart",
      "Changing the Appearance of the Interface Component when the Cursor is Hovering over It",
      "Functions for the Form Buttons",
      "Deletion of Interface Elements",
      "Using the Form in Indicators",
      "Using the Form in Scripts",
      "The Main Menu of the Program",
      "Developing the Class for Creating a Menu Item",
      "Test of Attaching a Menu Item",
      "Further Development of the Library Main Classes"
     };
//--- Array of icons 1
   string image_array1[2]=
     {
      "Images\\EasyAndFastGUI\\Controls\\checkbox_off.bmp",
      "Images\\EasyAndFastGUI\\Controls\\checkbox_on.bmp"
     };
//--- Array of icons 2
   string image_array2[1]=
     {
      "Images\\EasyAndFastGUI\\Icons\\bmp16\\script.bmp"
     };
//--- Data and formatting of the table (background color and cell color)
   datetime start=::TimeCurrent();
//---
   for(int c=0; c<COLUMNS1_TOTAL; c++)
     {
      //--- Set the header titles
      m_table.SetHeaderText(c,"Column "+string(c));
      //---
      for(int r=0; r<ROWS1_TOTAL; r++)
        {
         //--- Checkboxes
         if(c==0)
           {
            //--- Set the type and images
            m_table.CellType(c,r,CELL_CHECKBOX);
            m_table.SetImages(c,r,image_array1);
            //--- Change the icon randomly
            m_table.ChangeImage(c,r,::rand()%2);
           }
         //--- Edits
         else if(c==1)
           {
            //--- Set the type
            m_table.CellType(c,r,CELL_EDIT);
           }
         //--- Combo boxes
         else if(c==2)
           {
            if(r%2==0)
              {
               //--- Set the type
               m_table.CellType(c,r,CELL_COMBOBOX);
               //--- Populate the combo box list
               string value_list[]={"item 0","item 1","item 2","item 3","item 4"};
               m_table.AddValueList(c,r,value_list,::rand()%4);
               continue;
              }
            else
              {
               //--- Set the type
               m_table.CellType(c,r,CELL_EDIT);
               //--- Set the text
               m_table.SetValue(c,r,::DoubleToString(::rand()%1000,2));
               continue;
              }
           }
         //--- Buttons
         else if(c==4)
           {
            //--- Set the type and images
            m_table.CellType(c,r,CELL_BUTTON);
            m_table.SetImages(c,r,image_array2);
           }
         //--- Set the text
         m_table.SetValue(c,r,text_array[::rand()%20]);
        }
     }
  }
//+------------------------------------------------------------------+
//| Creates a multiline text box                                     |
//+------------------------------------------------------------------+
bool CProgram::CreateTextBox1(const int x_gap,const int y_gap)
  {
//--- Store the pointer to the main control
   m_text_box1.MainPointer(m_window);
//--- Properties
   m_text_box1.XSize(115);
   m_text_box1.YSize(155);
   m_text_box1.FontSize(8);
   m_text_box1.Font("Calibri"); // Consolas|Calibri|Tahoma
   m_text_box1.TextYOffset(4);
   m_text_box1.BackColor(clrWhite);
   m_text_box1.BorderColor(C'150,170,180');
   m_text_box1.LabelColor(clrBlack);
   m_text_box1.MultiLineMode(true);
   m_text_box1.WordWrapMode(false);
   m_text_box1.ReadOnlyMode(true);
   m_text_box1.AutoYResizeMode(true);
   m_text_box1.AutoXResizeMode(true);
   m_text_box1.AutoXResizeRightOffset(7);
   m_text_box1.AutoYResizeBottomOffset(27);
//--- Add text to the first line
   m_text_box1.AddText(0,"Event logging...");
//--- Create a control
   if(!m_text_box1.CreateTextBox(x_gap,y_gap))
      return(false);
//--- Add the object to the common array of object groups
   CWndContainer::AddToElementsArray(0,m_text_box1);
   return(true);
  }
//+------------------------------------------------------------------+
