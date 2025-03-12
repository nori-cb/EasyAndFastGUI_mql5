//+------------------------------------------------------------------+
//|                                                        Table.mqh |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "Pointer.mqh"
#include "Scrolls.mqh"
#include "TextEdit.mqh"
#include "ComboBox.mqh"
//+------------------------------------------------------------------+
//| Class for creating a rendered table                              |
//+------------------------------------------------------------------+
class CTable : public CElement
  {
private:
   //--- Objects for creating a table
   CRectCanvas       m_headers;
   CRectCanvas       m_table;
   CScrollV          m_scrollv;
   CScrollH          m_scrollh;
   CTextEdit         m_edit;
   CComboBox         m_combobox;
   CPointer          m_column_resize;
   //--- Properties of the table cells
   struct CTCell
     {
      ENUM_TYPE_CELL    m_type;           // Cell type
      CImage            m_images[];       // Array of icons
      int               m_selected_image; // Index of the selected (displayed) icon
      string            m_full_text;      // Full text
      string            m_short_text;     // Shortened text
      string            m_value_list[];   // Array of values (for cells with combo boxes)
      int               m_selected_item;  // Selected item in the combo box list 
      color             m_text_color;     // Text color
      uint              m_digits;         // Number of decimal places
     };
   //--- Array of rows and properties of the table columns
   struct CTOptions
     {
      int               m_x;              // X coordinate of the left edge of the column
      int               m_x2;             // X coordinate of the right edge of the column
      int               m_width;          // Column width
      ENUM_DATATYPE     m_data_type;      // Type of data in the column
      ENUM_ALIGN_MODE   m_text_align;     // Text alignment mode in the column cells
      int               m_text_x_offset;  // Text offset
      int               m_image_x_offset; // Image offset from the X-edge of the cell
      int               m_image_y_offset; // Image offset from the Y-edge of the cell
      string            m_header_text;    // Column header text
      CTCell            m_rows[];         // Array of the table rows
     };
   CTOptions         m_columns[];
   //--- Array of the table row properties
   struct CTRowOptions
     {
      int               m_y;  // Y coordinate of the top edge of the row
      int               m_y2; // Y coordinate of the bottom edge of the row
     };
   CTRowOptions      m_rows[];
   //--- The number of rows and columns
   uint              m_rows_total;
   uint              m_columns_total;
   //--- Total size and size of the visible part of the table
   int               m_table_x_size;
   int               m_table_y_size;
   int               m_table_visible_x_size;
   int               m_table_visible_y_size;
   //--- Presence of table cells with text edit boxes and combo boxes
   bool              m_edit_state;
   bool              m_combobox_state;
   //--- Indexes of the column and row of the last edited cell
   int               m_last_edit_row_index;
   int               m_last_edit_column_index;
   //--- The minimum width of the columns
   int               m_min_column_width;
   //--- Grid color
   color             m_grid_color;
   //--- Display mode of the table headers
   bool              m_show_headers;
   //--- Size (height) of the headers
   int               m_header_y_size;
   //--- Color of the headers (background) in different states
   color             m_headers_color;
   color             m_headers_color_hover;
   color             m_headers_color_pressed;
   //--- Header text color
   color             m_headers_text_color;
   //--- Icons for the sign of sorted data
   CImage            m_sort_arrows[];
   //--- Offsets for the sign icon of sorted data
   int               m_sort_arrow_x_gap;
   int               m_sort_arrow_y_gap;
   //--- Size (height) of cells
   int               m_cell_y_size;
   //--- Color of cells in different states
   color             m_cell_color;
   color             m_cell_color_hover;
   //--- Color of (1) the background and (2) selected row text
   color             m_selected_row_color;
   color             m_selected_row_text_color;
   //--- (1) Index and (2) text of the selected row
   int               m_selected_item;
   string            m_selected_item_text;
   //--- Index of the previous selected row
   int               m_prev_selected_item;
   //--- Offset from the borders of separation lines to display the mouse pointer in the mode of changing the column width
   int               m_sep_x_offset;
   //--- Mode of highlighting rows when hovered
   bool              m_lights_hover;
   //--- Mode of sorting data according to columns
   bool              m_is_sort_mode;
   //--- Index of the sorted column (WRONG_VALUE – table is not sorted)
   int               m_is_sorted_column_index;
   //--- Last sorting direction
   ENUM_SORT_MODE    m_last_sort_direction;
   //--- Selectable row mode
   bool              m_selectable_row;
   //--- No deselection of row when clicked again
   bool              m_is_without_deselect;
   //--- Mode of formatting in Zebra style
   color             m_is_zebra_format_rows;
   //--- State of the left mouse button (pressed down/released)
   bool              m_mouse_state;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //--- To determine the row focus
   int               m_item_index_focus;
   //--- To determine the moment of mouse cursor transition from one row to another
   int               m_prev_item_index_focus;
   //--- To determine the moment of mouse cursor transition from one header to another
   int               m_prev_header_index_focus;
   //--- Mode of changing the column widths
   bool              m_column_resize_mode;
   //--- The state of dragging the header border to change the column width
   int               m_column_resize_control;
   //--- Auxiliary fields for calculations in changing the column widths
   int               m_column_resize_x_fixed;
   int               m_column_resize_prev_width;
   int               m_column_resize_prev_thumb;
   //--- For determining the indexes of the visible part of the table
   uint              m_visible_table_from_index;
   uint              m_visible_table_to_index;
   //--- The step size for the horizontal offset
   int               m_shift_x_step;
   //--- Offset limits
   int               m_shift_x2_limit;
   int               m_shift_y2_limit;
   //---
public:
                     CTable(void);
                    ~CTable(void);
   //--- Methods for creating table
   bool              CreateTable(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateHeaders(void);
   bool              CreateTable(void);
   bool              CreateScrollV(void);
   bool              CreateScrollH(void);
   bool              CreateEdit(void);
   bool              CreateCombobox(void);
   bool              CreateColumnResizePointer(void);
   //---
public:
   //--- Returns pointers to controls
   CScrollV         *GetScrollVPointer(void)                 { return(::GetPointer(m_scrollv));  }
   CScrollH         *GetScrollHPointer(void)                 { return(::GetPointer(m_scrollh));  }
   CTextEdit        *GetTextEditPointer(void)                { return(::GetPointer(m_edit));     }
   CComboBox        *GetComboboxPointer(void)                { return(::GetPointer(m_combobox)); }
   //--- Returns the presence of controls (text box, combo box) in the table cells
   bool              HasEditElements(void)             const { return(m_edit_state);             }
   bool              HasComboboxElements(void)         const { return(m_combobox_state);         }
   //--- Color of (1) the grid and (2) table cells
   void              GridColor(const color clr)              { m_grid_color=clr;                 }
   void              CellColor(const color clr)              { m_cell_color=clr;                 }
   void              CellColorHover(const color clr)         { m_cell_color_hover=clr;           }
   //--- (1) Headers display mode, height of the (2) headers and (3) cells
   void              ShowHeaders(const bool flag)            { m_show_headers=flag;              }
   void              HeaderYSize(const int y_size)           { m_header_y_size=y_size;           }
   void              CellYSize(const int y_size)             { m_cell_y_size=y_size;             }
   //--- (1) Background and (2) text color of the headers
   void              HeadersColor(const color clr)           { m_headers_color=clr;              }
   void              HeadersColorHover(const color clr)      { m_headers_color_hover=clr;        }
   void              HeadersColorPressed(const color clr)    { m_headers_color_pressed=clr;      }
   void              HeadersTextColor(const color clr)       { m_headers_text_color=clr;         }
   //--- Offsets for the sign of sorted table
   void              SortArrowXGap(const int x_gap)          { m_sort_arrow_x_gap=x_gap;         }
   void              SortArrowYGap(const int y_gap)          { m_sort_arrow_y_gap=y_gap;         }
   //--- Setting the icons for the sign of sorted data
   void              SortArrowFileAscend(const string path)  { m_sort_arrows[0].BmpPath(path);   }
   void              SortArrowFileDescend(const string path) { m_sort_arrows[1].BmpPath(path);   }
   //--- Returns the total number of (1) rows and (2) columns, (3) the number rows of the visible part of the table
   uint              RowsTotal(void)                   const { return(m_rows_total);             }
   uint              ColumnsTotal(void)                const { return(m_columns_total);          }
   int               VisibleRowsTotal(void);
   //--- Returns the (1) index and (2) text of the selected row in the table
   int               SelectedItem(void)                const { return(m_selected_item);          }
   string            SelectedItemText(void)            const { return(m_selected_item_text);     }
   //--- (1) Row highlighting when hovered, (2) sorting data modes
   void              LightsHover(const bool flag)            { m_lights_hover=flag;              }
   void              IsSortMode(const bool flag)             { m_is_sort_mode=flag;              }
   //--- Modes of (1) row selection, (2) no deselection of row when clicked again
   void              SelectableRow(const bool flag)          { m_selectable_row=flag;            }
   void              IsWithoutDeselect(const bool flag)      { m_is_without_deselect=flag;       }
   //--- (1) Formatting of rows in Zebra style, (2) mode of changing the column widths
   void              IsZebraFormatRows(const color clr)      { m_is_zebra_format_rows=clr;       }
   void              ColumnResizeMode(const bool flag)       { m_column_resize_mode=flag;        }
   //--- The process of changing the width of columns
   bool              ColumnResizeControl(void) const { return(m_column_resize_control!=WRONG_VALUE); }

   //--- Returns the total number of icons in the specified cell
   int               ImagesTotal(const uint column_index,const uint row_index);
   //--- The minimum width of the columns
   void              MinColumnWidth(const int width);
   //--- Set the main size of the table
   void              TableSize(const int columns_total,const int rows_total);

   //--- Rebuilding the table
   void              Rebuilding(const int columns_total,const int rows_total,const bool redraw=false);
   //--- Adds a column to the table at the specified index
   void              AddColumn(const int column_index,const bool redraw=false);
   //--- Removes a column from the table at the specified index
   void              DeleteColumn(const int column_index,const bool redraw=false);
   //--- Adds a row to the table at the specified index
   void              AddRow(const int row_index,const bool redraw=false);
   //--- Removes a row from the table at the specified index
   void              DeleteRow(const int row_index,const bool redraw=false);
   //--- Clears the table. Only one column and one row are left.
   void              Clear(const bool redraw=false);

   //--- Setting the text to the specified header
   void              SetHeaderText(const uint column_index,const string value);
   //--- Setting the (1) text alignment mode, (2) text offsets within a cell along the X axis and (3) width for each column
   void              TextAlign(const ENUM_ALIGN_MODE &array[]);
   void              TextXOffset(const int &array[]);
   void              ColumnsWidth(const int &array[]);
   //--- Offset of the images along the X and Y axes
   void              ImageXOffset(const int &array[]);
   void              ImageYOffset(const int &array[]);
   //--- Setting/getting the data type
   void              DataType(const uint column_index,const ENUM_DATATYPE type);
   ENUM_DATATYPE     DataType(const uint column_index);
   //--- Setting/getting the cell type
   void              CellType(const uint column_index,const uint row_index,const ENUM_TYPE_CELL type);
   ENUM_TYPE_CELL    CellType(const uint column_index,const uint row_index);
   //--- Set icons to the specified cell
   void              SetImages(const uint column_index,const uint row_index,const string &bmp_file_path[]);
   //--- Changes/obtains the icon (index) in the specified cell
   void              ChangeImage(const uint column_index,const uint row_index,const uint image_index,const bool redraw=false);
   int               SelectedImageIndex(const uint column_index,const uint row_index);
   //--- Set the text color to the specified table cell
   void              TextColor(const uint column_index,const uint row_index,const color clr,const bool redraw=false);
   //--- Set/get the value in the specified table cell
   void              SetValue(const uint column_index,const uint row_index,const string value="",const uint digits=0,const bool redraw=false);
   string            GetValue(const uint column_index,const uint row_index);
   //--- Add a list of values to the combo box
   void              AddValueList(const uint column_index,const uint row_index,const string &array[],const uint selected_item=0);

   //--- Table scrolling: (1) vertical and (2) horizontal
   void              VerticalScrolling(const int pos=WRONG_VALUE);
   void              HorizontalScrolling(const int pos=WRONG_VALUE);
   //--- Shift the table relative to the positions of scrollbars
   void              ShiftTable(void);
   //--- Sort the data according to the specified column
   void              SortData(const uint column_index=0);
   //---
public:
   //--- Handler of chart events
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   //--- Timer
   virtual void      OnEventTimer(void);
   //--- Moving the control
   virtual void      Moving(const bool only_visible=true);
   //--- Management
   virtual void      Show(void);
   virtual void      Hide(void);
   virtual void      Delete(void);
   //--- (1) Setting, (2) resetting priorities of the left mouse click
   virtual void      SetZorders(void);
   virtual void      ResetZorders(void);
   //--- Updating the control
   virtual void      Update(const bool redraw=false);
   //---
private:
   //--- Handling clicking on a header
   bool              OnClickHeaders(const string clicked_object);
   //--- Handling clicking on the table
   bool              OnClickTable(const string clicked_object);
   //--- Handling double clicking on the table
   bool              OnDoubleClickTable(const string clicked_object);
   //--- Handling the end of the value input in the cell
   bool              OnEndEditCell(const int id);
   //--- Handling the selection of an item in the drop-down list of the cell
   bool              OnClickComboboxItem(const int id);

   //--- Checking if controls in the cells are hidden
   void              CheckAndHideEdit(void);
   void              CheckAndHideCombobox(void);

   //--- Returns the index of the clicked row
   int               PressedRowIndex(void);
   //--- Returns the index of the clicked cell column
   int               PressedCellColumnIndex(void);

   //--- Check if the cell control was activated when clicked
   bool              CheckCellElement(const int column_index,const int row_index,const bool double_click=false);
   //--- Check if the button in the cell was clicked
   bool              CheckPressedButton(const int column_index,const int row_index,const bool double_click=false);
   //--- Check if the checkbox in the cell was clicked
   bool              CheckPressedCheckBox(const int column_index,const int row_index,const bool double_click=false);
   //--- Check if the click was on a cell with a text box
   bool              CheckPressedEdit(const int column_index,const int row_index,const bool double_click=false);
   //--- Check if the click was on a cell with a combo box
   bool              CheckPressedCombobox(const int column_index,const int row_index,const bool double_click=false);

   //--- Quicksort method
   void              QuickSort(uint beg,uint end,uint column,const ENUM_SORT_MODE mode=SORT_ASCEND);
   //--- Checking the sorting conditions
   bool              CheckSortCondition(uint column_index,uint row_index,const string check_value,const bool direction);
   //--- Swap the values in the specified cells
   void              Swap(uint r1,uint r2);

   //--- Calculate the tale size
   void              CalculateTableSize(void);
   //--- Calculate the full table size along the X and Y axes
   void              CalculateTableXSize(void);
   void              CalculateTableYSize(void);
   //--- Calculate the visible table size along the X and Y axes
   void              CalculateTableVisibleXSize(void);
   void              CalculateTableVisibleYSize(void);

   //--- Change the main size of the table
   void              ChangeMainSize(const int x_size,const int y_size);
   //--- Resize the table
   void              ChangeTableSize(void);
   //--- Resize the scrollbars
   void              ChangeScrollsSize(void);
   //--- Determining the indexes of the visible part of the table
   void              VisibleTableIndexes(void);

   //--- Returns the text
   string            Text(const int column_index,const int row_index);
   //--- Returns the X coordinate of the text in the specified column
   int               TextX(const int column_index,const bool headers=false);
   //--- Returns the text alignment mode in the specified column
   uint              TextAlign(const int column_index,const uint anchor);
   //--- Returns the color of the cell text
   uint              TextColor(const int column_index,const int row_index);

   //--- Returns the current header background color
   uint              HeaderColorCurrent(const bool is_header_focus);
   //--- Returns the current row background color
   uint              RowColorCurrent(const int row_index,const bool is_row_focus);

   //--- Draws the control
   void              Draw(void);
   //--- Draws the table with consideration of the recent changes
   void              DrawTable(const bool only_visible=false);
   //--- Draws the table headers
   void              DrawTableHeaders(void);
   //--- Draws the headers
   void              DrawHeaders(void);
   //--- Draws the grid of the table headers
   void              DrawHeadersGrid(void);
   //--- Draws the sign of the possibility of sorting the table
   void              DrawSignSortedData(void);
   //--- Draws the text of the table headers
   void              DrawHeadersText(void);

   //--- Draws the background of the table rows
   void              DrawRows(void);
   //--- Draws a selected row
   void              DrawSelectedRow(void);
   //--- Draw grid
   void              DrawGrid(void);
   //--- Draw all icons of the table
   void              DrawImages(void);
   //--- Draw an icon in the specified cell
   void              DrawImage(const int column_index,const int row_index);
   //--- Draw text
   void              DrawText(void);

   //--- Redraws the specified cell of the table
   void              RedrawCell(const int column_index,const int row_index);
   //--- Redraws the specified table row according to the specified mode
   void              RedrawRow(const bool is_selected_row=false);

   //--- Checking the focus on the headers
   void              CheckHeaderFocus(void);
   //--- Checking the focus on the table rows
   int               CheckRowFocus(void);
   //--- Checking the focus on borders of headers to change their widths
   void              CheckColumnResizeFocus(void);
   //--- Changes the width of the dragged column
   void              ChangeColumnWidth(void);

   //--- Checks the size of the passed array and returns the adjusted value
   template<typename T>
   int               CheckArraySize(const T &array[]);
   //--- Checking for exceeding the range of columns
   bool              CheckOutOfColumnRange(const uint column_index);
   //--- Checking for exceeding the range of columns and rows
   virtual bool      CheckOutOfRange(const uint column_index,const uint row_index);
   //--- Recalculate with consideration of the recent changes and resize the table
   void              RecalculateAndResizeTable(const bool redraw=false);

   //--- Initialize the specified column with the default values
   void              ColumnInitialize(const uint column_index);
   //--- Initialize the specified cell with the default values
   void              CellInitialize(const uint column_index,const uint row_index);

   //--- Makes a copy of the specified column (source) to a new location (dest.)
   void              ColumnCopy(const uint destination,const uint source);
   //--- Makes a copy of the specified cell (source) to a new location (dest.)
   void              CellCopy(const uint column_dest,const uint row_dest,const uint column_source,const uint row_source);
   //--- Copies the image data from one array to another
   void              ImageCopy(CImage &destination[],CImage &source[],const int index);

   //--- Changes the color of the table objects
   void              ChangeObjectsColor(void);
   //--- Change the header color when hovered by mouse cursor
   void              ChangeHeadersColor(void);
   //--- Changing the row color when hovered
   void              ChangeRowsColor(void);

   //--- Returns the text adjusted to the column width
   string            CorrectingText(const int column_index,const int row_index,const bool headers=false);

   //--- Fast forward of the table
   void              FastSwitching(void);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Change the height at the bottom edge of the window
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTable::CTable(void) : m_rows_total(1),
                       m_columns_total(1),
                       m_edit_state(false),
                       m_combobox_state(false),
                       m_last_edit_row_index(WRONG_VALUE),
                       m_last_edit_column_index(WRONG_VALUE),
                       m_shift_x_step(10),
                       m_shift_x2_limit(0),
                       m_shift_y2_limit(0),
                       m_show_headers(false),
                       m_header_y_size(20),
                       m_cell_y_size(20),
                       m_min_column_width(30),
                       m_grid_color(clrLightGray),
                       m_headers_color(C'255,244,213'),
                       m_headers_color_hover(C'229,241,251'),
                       m_headers_color_pressed(C'204,228,247'),
                       m_headers_text_color(clrBlack),
                       m_is_sort_mode(false),
                       m_last_sort_direction(SORT_ASCEND),
                       m_is_sorted_column_index(WRONG_VALUE),
                       m_sort_arrow_x_gap(10),
                       m_sort_arrow_y_gap(8),
                       m_cell_color(clrWhite),
                       m_cell_color_hover(C'229,243,255'),
                       m_prev_selected_item(WRONG_VALUE),
                       m_selected_item(WRONG_VALUE),
                       m_selected_item_text(""),
                       m_sep_x_offset(5),
                       m_lights_hover(false),
                       m_selectable_row(false),
                       m_is_without_deselect(false),
                       m_column_resize_mode(false),
                       m_column_resize_control(WRONG_VALUE),
                       m_column_resize_x_fixed(0),
                       m_column_resize_prev_width(0),
                       m_column_resize_prev_thumb(0),
                       m_item_index_focus(WRONG_VALUE),
                       m_prev_item_index_focus(WRONG_VALUE),
                       m_prev_header_index_focus(WRONG_VALUE),
                       m_selected_row_color(C'51,153,255'),
                       m_selected_row_text_color(clrWhite),
                       m_is_zebra_format_rows(clrNONE),
                       m_visible_table_from_index(WRONG_VALUE),
                       m_visible_table_to_index(WRONG_VALUE)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- Default text color
   m_label_color=clrBlack;
//--- Set the table size
   TableSize(m_columns_total,m_rows_total);
//--- Initializing the structure of the sorting sign
   ::ArrayResize(m_sort_arrows,2);
   m_sort_arrows[0].BmpPath("");
   m_sort_arrows[1].BmpPath("");
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTable::~CTable(void)
  {
  }
//+------------------------------------------------------------------+
//| Event handler                                                    |
//+------------------------------------------------------------------+
void CTable::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- If the scrollbar is active
      if(m_scrollv.ScrollBarControl())
        {
         ShiftTable();
         m_scrollv.Update(true);
         return;
        }
      //--- If the scrollbar is active
      if(m_scrollh.ScrollBarControl())
        {
         ShiftTable();
         m_scrollh.Update(true);
         return;
        }
      //--- Leave, if the scrollbar is activated
      if(m_scrollh.State() || m_scrollv.State())
         return;
      //--- Checking the focus over controls
      m_headers.MouseFocus(m_mouse.X()>m_headers.X() && m_mouse.X()<m_headers.X2() && 
                           m_mouse.Y()>m_headers.Y() && m_mouse.Y()<m_headers.Y2());
      m_table.MouseFocus(m_mouse.X()>m_table.X() && m_mouse.X()<m_table.X2() && 
                         m_mouse.Y()>m_table.Y() && m_mouse.Y()<m_table.Y2());
      //--- Change of objects' color
      ChangeObjectsColor();
      //--- Change the width of the dragged column
      ChangeColumnWidth();
      return;
     }
//--- Handling the pressing on objects
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Clicking the header
      if(OnClickHeaders(sparam))
         return;
      //--- Clicking the table
      if(OnClickTable(sparam))
         return;
      //---
      return;
     }
//--- Handling the input end event
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      if(OnEndEditCell((int)lparam))
         return;
      //---
      return;
     }
//--- Handling the event of selecting an item in the list
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      if(OnClickComboboxItem((int)lparam))
         return;
      //---
      return;
     }
//--- Handling the click on the scrollbar buttons
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- Leave, if the click was not on the combo box button
      if(m_combobox.CheckElementName(sparam))
         return;
      //--- Leave, if the click was not on the scrollbar button
      if(!m_scrollv.GetIncButtonPointer().CheckElementName(sparam))
         return;
      //--- If the click was on the buttons of the vertical scrollbar
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Shift the data
         ShiftTable();
         m_scrollv.Update(true);
         return;
        }
      //--- If the click was on the buttons of the scrollbar
      if(m_scrollh.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollh.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Shift the data
         ShiftTable();
         m_scrollh.Update(true);
         return;
        }
     }
//--- Change in the state of the left mouse button
   if(id==CHARTEVENT_CUSTOM+ON_CHANGE_MOUSE_LEFT_BUTTON)
     {
      //--- Checking if text boxes in the cells are hidden
      CheckAndHideEdit();
      //--- Checking if combo boxes in the cells are hidden
      CheckAndHideCombobox();
      //--- Leave, if the headers are disabled
      if(!m_show_headers)
         return;
      //--- If the left mouse button is released
      if(m_column_resize_control!=WRONG_VALUE && !m_mouse.LeftButtonState())
        {
         //--- Reset the width changing mode
         m_column_resize_control=WRONG_VALUE;
         //--- Redraw the table
         DrawTable();
         Update();
         //--- Hide the cursor
         m_column_resize.Hide();
         //--- Send a message to determine the available controls
         
::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),1,"");
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      //--- Reset the index of the last focus on a header
      m_prev_header_index_focus=WRONG_VALUE;
      //--- Change of objects' color
      ChangeObjectsColor();
      return;
     }
//--- Handling the left mouse button double click
   if(id==CHARTEVENT_CUSTOM+ON_DOUBLE_CLICK)
     {
      //--- Leave, if a combo box is present and visible
      if(m_combobox_state && m_combobox.IsVisible())
         return;
      //--- Clicking the table
      if(OnDoubleClickTable(sparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTable::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
  }
//+------------------------------------------------------------------+
//| Create a rendered table                                          |
//+------------------------------------------------------------------+
bool CTable::CreateTable(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Calculate the table sizes
   CalculateTableSize();
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateTable())
      return(false);
   if(!CreateHeaders())
      return(false);
   if(!CreateScrollV())
      return(false);
   if(!CreateScrollH())
      return(false);
   if(!CreateEdit())
      return(false);
   if(!CreateCombobox())
      return(false);
   if(!CreateColumnResizePointer())
      return(false);
//--- Resize the table
   ChangeTableSize();
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTable::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<1 || m_auto_xresize_mode)? (m_anchor_right_window_side)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<1 || m_auto_yresize_mode)? (m_anchor_bottom_window_side)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
//--- Default properties
   m_back_color          =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_label_color         =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_hover   =(m_label_color_hover!=clrNONE)? m_label_color_hover : clrBlack;
   m_label_color_pressed =(m_label_color_pressed!=clrNONE)? m_label_color_pressed : clrWhite;
   m_border_color        =(m_border_color!=clrNONE)? m_border_color : C'150,170,180';
   m_icon_x_gap          =(m_icon_x_gap>0)? m_icon_x_gap : 3;
   m_icon_y_gap          =(m_icon_y_gap>0)? m_icon_y_gap : 2;
   m_label_x_gap         =(m_label_x_gap>0)? m_label_x_gap : 5;
   m_label_y_gap         =(m_label_y_gap>0)? m_label_y_gap : 4;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Create the table background                                      |
//+------------------------------------------------------------------+
bool CTable::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("table");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a table                                                   |
//+------------------------------------------------------------------+
bool CTable::CreateTable(void)
  {
//--- Forming the object name
   string name=CElementBase::ProgramName()+"_"+"table_grid"+"_"+(string)CElementBase::Id();
//--- Coordinates
   int x =m_x+1;
   int y =m_y+((m_show_headers)? m_header_y_size : 1);
//--- Creating an object
   ::ResetLastError();
   if(!m_table.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,m_table_x_size,m_header_y_size,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Failed to create a canvas for drawing the table: ",::GetLastError());
      return(false);
     }
//--- Get the pointer to the base class
   CChartObject *chart=::GetPointer(m_table);
//--- Attach to the chart
   if(!chart.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- Properties
   m_table.Z_Order(m_zorder+1);
   m_table.Tooltip("\n");
//--- Coordinates
   m_table.X(x);
   m_table.Y(y);
//--- Store the size
   m_table.XSize(m_table_visible_x_size);
   m_table.YSize(m_table_visible_y_size);
//--- Margins from the edge of the panel
   m_table.XGap(CElement::CalculateXGap(x));
   m_table.YGap(CElement::CalculateYGap(y));
//--- Set the size of the visible area
   m_table.SetInteger(OBJPROP_XSIZE,m_table_visible_x_size);
   m_table.SetInteger(OBJPROP_YSIZE,m_table_visible_y_size);
//--- Set the frame offset within the image along the X and Y axes
   m_table.SetInteger(OBJPROP_XOFFSET,0);
   m_table.SetInteger(OBJPROP_YOFFSET,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the table headers                                        |
//+------------------------------------------------------------------+
bool CTable::CreateHeaders(void)
  {
//--- Leave, if the headers are disabled
   if(!m_show_headers)
      return(true);
//--- Forming the object name
   string name=CElementBase::ProgramName()+"_"+"table_headers"+"_"+(string)CElementBase::Id();
//--- Coordinates
   int x =m_x+1;
   int y =m_y+1;
//--- Define the icons as a sign of the possibility of sorting the table
   ::ArrayResize(m_sort_arrows,2);
   if(m_sort_arrows[0].BmpPath()=="")
      m_sort_arrows[0].BmpPath("Images\\EasyAndFastGUI\\Controls\\spin_inc.bmp");
   if(m_sort_arrows[1].BmpPath()=="")
      m_sort_arrows[1].BmpPath("Images\\EasyAndFastGUI\\Controls\\spin_dec.bmp");
//--- Store the icons to arrays
   for(int i=0; i<2; i++)
      m_sort_arrows[i].ReadImageData(m_sort_arrows[i].BmpPath());
//--- Creating an object
   ::ResetLastError();
   if(!m_headers.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,m_table_x_size,m_header_y_size,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Failed to create a canvas for drawing the table headers: ",::GetLastError());
      return(false);
     }
//--- Get the pointer to the base class
   CChartObject *chart=::GetPointer(m_headers);
//--- Attach to the chart
   if(!chart.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- set properties
   m_headers.Z_Order(m_zorder+1);
   m_headers.Tooltip("\n");
//--- Coordinates
   m_headers.X(x);
   m_headers.Y(y);
//--- Store the size
   m_headers.XSize(m_table_visible_x_size);
   m_headers.YSize(m_header_y_size);
//--- Margins from the edge of the panel
   m_headers.XGap(CElement::CalculateXGap(x));
   m_headers.YGap(CElement::CalculateYGap(y));
//--- Set the size of the visible area
   m_headers.SetInteger(OBJPROP_XSIZE,m_table_visible_x_size);
   m_headers.SetInteger(OBJPROP_YSIZE,m_header_y_size);
//--- Set the frame offset within the image along the X and Y axes
   m_headers.SetInteger(OBJPROP_XOFFSET,0);
   m_headers.SetInteger(OBJPROP_YOFFSET,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the vertical scrollbar                                   |
//+------------------------------------------------------------------+
bool CTable::CreateScrollV(void)
  {
//--- Store the pointer to parent
   m_scrollv.MainPointer(this);
//--- Coordinates
   int x=16,y=1;
//--- Properties
   m_scrollv.Index(0);
   m_scrollv.XSize(15);
   m_scrollv.YSize(CElementBase::YSize()-2);
   m_scrollv.AnchorRightWindowSide(true);
   m_scrollv.Alpha(m_alpha);
//--- Calculate the number of steps for offset
   uint rows_total         =RowsTotal();
   uint visible_rows_total =VisibleRowsTotal();
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(x,y,rows_total,visible_rows_total))
      return(false);
//--- Hide, if it is not required now
   if(!m_scrollv.IsScroll())
      m_scrollv.Hide();
//--- Add the control to the array
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the horizontal scrollbar                                 |
//+------------------------------------------------------------------+
bool CTable::CreateScrollH(void)
  {
//--- Store the pointer to the main control
   m_scrollh.MainPointer(this);
//--- Coordinates
   int x=1,y=16;
//--- Properties
   m_scrollh.Index(1);
   m_scrollh.XSize(CElementBase::XSize()-2);
   m_scrollh.YSize(15);
   m_scrollh.AnchorBottomWindowSide(true);
   m_scrollh.Alpha(m_alpha);
//--- Calculate the number of steps for offset
   uint x_size_total         =m_table_x_size/m_shift_x_step;
   uint visible_x_size_total =m_table_visible_x_size/m_shift_x_step;
//--- Creating the scrollbar
   if(!m_scrollh.CreateScroll(x,y,x_size_total,visible_x_size_total))
      return(false);
//--- Hide, if it is not required now
   if(!m_scrollh.IsScroll())
      m_scrollh.Hide();
//--- Add the control to the array
   CElement::AddToArray(m_scrollh);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates edit box                                                 |
//+------------------------------------------------------------------+
bool CTable::CreateEdit(void)
  {
//--- If there are no cells with text boxes
   if(!m_edit_state)
      return(true);
//--- Store the pointer to the main control
   m_edit.MainPointer(this);
//--- Coordinates
   int x=-1,y=0;
//--- Properties
   m_edit.Alpha(0);
   m_edit.XSize(50);
   m_edit.YSize(21);
   m_edit.SetValue("");
   m_edit.GetTextBoxPointer().XGap(1);
   m_edit.GetTextBoxPointer().XSize(50);
   m_edit.GetTextBoxPointer().TextYOffset(4);
   m_edit.GetTextBoxPointer().AutoSelectionMode(true);
//--- Create a control
   if(!m_edit.CreateTextEdit("",x,y))
      return(false);
//--- Hide
   m_edit.Hide();
//--- Add the control to the array
   CElement::AddToArray(m_edit);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates combo box                                                |
//+------------------------------------------------------------------+
bool CTable::CreateCombobox(void)
  {
//--- If there are no cells with combo boxes
   if(!m_combobox_state)
      return(true);
//--- Store the pointer to the main control
   m_combobox.MainPointer(this);
//--- Coordinates
   int x=-1,y=0;
//--- Properties
   m_combobox.Alpha(0);
   m_combobox.XSize(50);
   m_combobox.YSize(21);
   m_combobox.ItemsTotal(5);
   m_combobox.GetButtonPointer().XGap(1);
   m_combobox.GetButtonPointer().LabelYGap(4);
   m_combobox.GetButtonPointer().IconYGap(3);
   m_combobox.IsDropdown(CElementBase::IsDropdown());
//--- Get the list view pointer
   CListView *lv=m_combobox.GetListViewPointer();
//--- Set the list view properties
   lv.YSize(93);
   lv.LightsHover(true);
   lv.GetScrollVPointer().Index(2);
//--- Add the values to the list
   for(int i=0; i<5; i++)
      m_combobox.SetValue(i,(string)i);
//--- Select the current month in the list
   m_combobox.SelectItem(0);
//--- Create a control
   if(!m_combobox.CreateComboBox("",x,y))
      return(false);
//--- Hide
   m_combobox.Hide();
//--- Add the control to the array
   CElement::AddToArray(m_combobox);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create cursor of changing the column widths                      |
//+------------------------------------------------------------------+
bool CTable::CreateColumnResizePointer(void)
  {
//--- Leave, if the mode of changing the column widths is disabled
   if(!m_column_resize_mode)
     {
      m_column_resize.State(false);
      m_column_resize.IsVisible(false);
      return(true);
     }
//--- Properties
   m_column_resize.XGap(13);
   m_column_resize.YGap(14);
   m_column_resize.XSize(20);
   m_column_resize.YSize(20);
   m_column_resize.Id(CElementBase::Id());
   m_column_resize.Type(MP_X_RESIZE_RELATIVE);
//--- Create control
   if(!m_column_resize.CreatePointer(m_chart_id,m_subwin))
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns the number of visible rows                               |
//+------------------------------------------------------------------+
int CTable::VisibleRowsTotal(void)
  {
   double visible_rows_total =m_table_visible_y_size/m_cell_y_size;
   double check_y_size       =visible_rows_total*m_cell_y_size;
   visible_rows_total=(check_y_size<m_table_visible_y_size-1)? visible_rows_total-1 : visible_rows_total;
   return((int)visible_rows_total);
  }
//+------------------------------------------------------------------+
//| Returns the total number of icons in the specified cell          |
//+------------------------------------------------------------------+
int CTable::ImagesTotal(const uint column_index,const uint row_index)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return(WRONG_VALUE);
//--- Return the size of the icons array
   return(::ArraySize(m_columns[column_index].m_rows[row_index].m_images));
  }
//+------------------------------------------------------------------+
//| The minimum width of the columns                                 |
//+------------------------------------------------------------------+
void CTable::MinColumnWidth(const int width)
  {
//--- The column width is at least 3 pixels
   m_min_column_width=(width>3)? width : 3;
  }
//+------------------------------------------------------------------+
//| Set the size of the table                                        |
//+------------------------------------------------------------------+
void CTable::TableSize(const int columns_total,const int rows_total)
  {
//--- There must be at least one column
   m_columns_total=(columns_total<1)? 1 : columns_total;
//--- There must be at least two rows
   m_rows_total=(rows_total<1)? 1 : rows_total;
//--- Set the size to the arrays of rows, columns and headers
   ::ArrayResize(m_rows,m_rows_total);
   ::ArrayResize(m_columns,m_columns_total);
//--- Set the size of table arrays
   for(uint c=0; c<m_columns_total; c++)
     {
      ::ArrayResize(m_columns[c].m_rows,m_rows_total);
      //--- Initialize the column properties with the default values
      ColumnInitialize(c);
      //--- Initialization of the cell properties
      for(uint r=0; r<m_rows_total; r++)
         CellInitialize(c,r);
     }
  }
//+------------------------------------------------------------------+
//| Rebuilding the table                                             |
//+------------------------------------------------------------------+
void CTable::Rebuilding(const int columns_total,const int rows_total,const bool redraw=false)
  {
//--- Set the new size
   TableSize(columns_total,rows_total);
//--- Calculate and resize the table
   RecalculateAndResizeTable(redraw);
  }
//+------------------------------------------------------------------+
//| Adds a column to the table at the specified index                |
//+------------------------------------------------------------------+
void CTable::AddColumn(const int column_index,const bool redraw=false)
  {
//--- Increase the array size by one element
   int array_size=(int)ColumnsTotal();
   m_columns_total=array_size+1;
   ::ArrayResize(m_columns,m_columns_total);
//--- Set the size of the rows arrays
   ::ArrayResize(m_columns[array_size].m_rows,m_rows_total);
//--- Adjustment of the index in case the range has been exceeded
   int checked_column_index=(column_index>=(int)m_columns_total)?(int)m_columns_total-1 : column_index;
//--- Shift other columns (starting from the end of the array to the index of the added column)
   for(int c=array_size; c>=checked_column_index; c--)
     {
      //--- Shift the sign of sorted array
      if(c==m_is_sorted_column_index && m_is_sorted_column_index!=WRONG_VALUE)
         m_is_sorted_column_index++;
      //--- Index of the previous column
      int prev_c=c-1;
      //--- Initialize the new column with the default values
      if(c==checked_column_index)
         ColumnInitialize(c);
      //--- Move the data from the previous column to the current column
      else
         ColumnCopy(c,prev_c);
      //---
      for(uint r=0; r<m_rows_total; r++)
        {
         //--- Initialize the new column cells with the default values
         if(c==checked_column_index)
           {
            CellInitialize(c,r);
            continue;
           }
         //--- Move the data from the previous column cell to the current column cell
         CellCopy(c,r,prev_c,r);
        }
     }
//--- Calculate and resize the table
   RecalculateAndResizeTable(redraw);
  }
//+------------------------------------------------------------------+
//| Removes a column from the table at the specified index           |
//+------------------------------------------------------------------+
void CTable::DeleteColumn(const int column_index,const bool redraw=false)
  {
//--- Get the size of the array of columns
   int array_size=(int)ColumnsTotal();
//--- Leave, if only one column is left
   if(array_size<2)
      return;
//--- Adjustment of the index in case the range has been exceeded
   int checked_column_index=(column_index>=array_size)? array_size-1 : column_index;
//--- Shift other columns (starting from the specified index to the last column)
   for(int c=checked_column_index; c<array_size-1; c++)
     {
      //--- Shift the sign of sorted array
      if(c!=checked_column_index)
        {
         if(c==m_is_sorted_column_index && m_is_sorted_column_index!=WRONG_VALUE)
            m_is_sorted_column_index--;
        }
      //--- Zero, if a sorted column was removed
      else
         m_is_sorted_column_index=WRONG_VALUE;
      //--- Index of the next column
      int next_c=c+1;
      //--- Move the data from the next column to the current column
      ColumnCopy(c,next_c);
      //--- Move the data from the next column cells to the current column cells
      for(uint r=0; r<m_rows_total; r++)
         CellCopy(c,r,next_c,r);
     }
//--- Decrease the array of columns by one element
   m_columns_total=array_size-1;
   ::ArrayResize(m_columns,m_columns_total);
//--- Calculate and resize the table
   RecalculateAndResizeTable(redraw);
  }
//+------------------------------------------------------------------+
//| Adds a row to the table at the specified index                   |
//+------------------------------------------------------------------+
void CTable::AddRow(const int row_index,const bool redraw=false)
  {
//--- Increase the array size by one element
   int array_size=(int)RowsTotal();
   m_rows_total=array_size+1;
//--- Set the size of the rows arrays
   for(uint i=0; i<m_columns_total; i++)
     {
      ::ArrayResize(m_rows,m_rows_total);
      ::ArrayResize(m_columns[i].m_rows,m_rows_total);
     }
//--- Adjustment of the index in case the range has been exceeded
   int checked_row_index=(row_index>=(int)m_rows_total)?(int)m_rows_total-1 : row_index;
//--- Shift other rows (starting from the end of the array to the index of the added row)
   for(int c=0; c<(int)m_columns_total; c++)
     {
      for(int r=array_size; r>=checked_row_index; r--)
        {
         //--- Initialize the new row cells with the default values
         if(r==checked_row_index)
           {
            CellInitialize(c,r);
            continue;
           }
         //--- Index of the previous row
         uint prev_r=r-1;
         //--- Move the data from the previous row cell to the current row cell
         CellCopy(c,r,c,prev_r);
        }
     }
//--- Calculate and resize the table
   RecalculateAndResizeTable(redraw);
  }
//+------------------------------------------------------------------+
//| Removes a row from the table at the specified index              |
//+------------------------------------------------------------------+
void CTable::DeleteRow(const int row_index,const bool redraw=false)
  {
//--- Get the size of the lines array
   int array_size=(int)RowsTotal();
//--- Leave, if only one row is left
   if(array_size<2)
      return;
//--- Adjustment of the index in case the range has been exceeded
   int checked_row_index=(row_index>=(int)m_rows_total)?(int)m_rows_total-1 : row_index;
//--- Shift other rows (starting from the specified index to the last row)
   for(int c=0; c<(int)m_columns_total; c++)
     {
      for(int r=checked_row_index; r<array_size-1; r++)
        {
         //--- Index of the next row
         uint next_r=r+1;
         //--- Move the data from the next row cell to the current row cell
         CellCopy(c,r,c,next_r);
        }
     }
//--- Decrease the rows array size by one element
   m_rows_total=array_size-1;
//--- Set the size of the rows arrays
   for(uint i=0; i<m_columns_total; i++)
     {
      ::ArrayResize(m_rows,m_rows_total);
      ::ArrayResize(m_columns[i].m_rows,m_rows_total);
     }
//--- Calculate and resize the table
   RecalculateAndResizeTable(redraw);
  }
//+------------------------------------------------------------------+
//| Clears the table. Only one column and one row are left.     |
//+------------------------------------------------------------------+
void CTable::Clear(const bool redraw=false)
  {
//--- Set the minimum size of 1x1
   TableSize(1,1);
//--- Set the default values
   m_selected_item_text     ="";
   m_selected_item          =WRONG_VALUE;
   m_last_sort_direction    =SORT_ASCEND;
   m_is_sorted_column_index =WRONG_VALUE;
//--- Calculate and resize the table
   RecalculateAndResizeTable(redraw);
  }
//+------------------------------------------------------------------+
//| Fills the array of headers at the specified index                |
//+------------------------------------------------------------------+
void CTable::SetHeaderText(const uint column_index,const string value)
  {
//--- Checking for exceeding the column range
   if(!CheckOutOfColumnRange(column_index))
      return;
//--- Store the value into the array
   m_columns[column_index].m_header_text=value;
  }
//+------------------------------------------------------------------+
//| Fills the array of text alignment modes                          |
//+------------------------------------------------------------------+
void CTable::TextAlign(const ENUM_ALIGN_MODE &array[])
  {
   int total=0;
//--- Leave, if a zero-sized array was passed
   if((total=CheckArraySize(array))==WRONG_VALUE)
      return;
//--- Store the values in the structure
   for(int c=0; c<total; c++)
      m_columns[c].m_text_align=array[c];
  }
//+------------------------------------------------------------------+
//| Fills the array of text offset along the X axis within a cell    |
//+------------------------------------------------------------------+
void CTable::TextXOffset(const int &array[])
  {
   int total=0;
//--- Leave, if a zero-sized array was passed
   if((total=CheckArraySize(array))==WRONG_VALUE)
      return;
//--- Store the values in the structure
   for(int c=0; c<total; c++)
      m_columns[c].m_text_x_offset=array[c];
  }
//+------------------------------------------------------------------+
//| Fills the array of column widths                                 |
//+------------------------------------------------------------------+
void CTable::ColumnsWidth(const int &array[])
  {
   int total=0;
//--- Leave, if a zero-sized array was passed
   if((total=CheckArraySize(array))==WRONG_VALUE)
      return;
//--- Store the values in the structure
   for(int c=0; c<total; c++)
      m_columns[c].m_width=array[c];
  }
//+------------------------------------------------------------------+
//| Image offsets from the cell edges along the X axis               |
//+------------------------------------------------------------------+
void CTable::ImageXOffset(const int &array[])
  {
   int total=0;
//--- Leave, if a zero-sized array was passed
   if((total=CheckArraySize(array))==WRONG_VALUE)
      return;
//--- Store the values in the structure
   for(int c=0; c<total; c++)
      m_columns[c].m_image_x_offset=array[c];
  }
//+------------------------------------------------------------------+
//| Image offsets from the cell edges along the Y axis               |
//+------------------------------------------------------------------+
void CTable::ImageYOffset(const int &array[])
  {
   int total=0;
//--- Leave, if a zero-sized array was passed
   if((total=CheckArraySize(array))==WRONG_VALUE)
      return;
//--- Store the values in the structure
   for(int c=0; c<total; c++)
      m_columns[c].m_image_y_offset=array[c];
  }
//+------------------------------------------------------------------+
//| Set the data type of the specified column                        |
//+------------------------------------------------------------------+
void CTable::DataType(const uint column_index,const ENUM_DATATYPE type)
  {
//--- Checking for exceeding the column range
   if(!CheckOutOfColumnRange(column_index))
      return;
//--- Set the data type for the specified column
   m_columns[column_index].m_data_type=type;
  }
//+------------------------------------------------------------------+
//| Get the data type of the specified column                        |
//+------------------------------------------------------------------+
ENUM_DATATYPE CTable::DataType(const uint column_index)
  {
//--- Checking for exceeding the column range
   if(!CheckOutOfColumnRange(column_index))
      return(WRONG_VALUE);
//--- Return the data type for the specified column
   return(m_columns[column_index].m_data_type);
  }
//+------------------------------------------------------------------+
//| Sets the cell type                                               |
//+------------------------------------------------------------------+
void CTable::CellType(const uint column_index,const uint row_index,const ENUM_TYPE_CELL type)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return;
//--- Set the cell type
   m_columns[column_index].m_rows[row_index].m_type=type;
//--- Sign of a text edit box presence
   if(type==CELL_EDIT && !m_edit_state)
      m_edit_state=true;
//--- Sign of a combo box presence
   else if(type==CELL_COMBOBOX && !m_combobox_state)
      m_combobox_state=true;
  }
//+------------------------------------------------------------------+
//| Gets the cell type                                               |
//+------------------------------------------------------------------+
ENUM_TYPE_CELL CTable::CellType(const uint column_index,const uint row_index)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return(WRONG_VALUE);
//--- Return the data type for the specified column
   return(m_columns[column_index].m_rows[row_index].m_type);
  }
//+------------------------------------------------------------------+
//| Set icons to the specified cell                                  |
//+------------------------------------------------------------------+
void CTable::SetImages(const uint column_index,const uint row_index,const string &bmp_file_path[])
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return;
//--- Leave, if a zero-sized array was passed
   int total=0;
   if((total=::ArraySize(bmp_file_path))<1)
      return;
//--- Resize the arrays
   ::ArrayResize(m_columns[column_index].m_rows[row_index].m_images,total);
//---
   for(int i=0; i<total; i++)
     {
      //--- The first icon of the array is selected by default
      m_columns[column_index].m_rows[row_index].m_selected_image=0;
      //--- Write the passed icon to the array and store its size
      if(!m_columns[column_index].m_rows[row_index].m_images[i].ReadImageData(bmp_file_path[i]))
         return;
     }
  }
//+------------------------------------------------------------------+
//| Changes the icon in the specified cell                           |
//+------------------------------------------------------------------+
void CTable::ChangeImage(const uint column_index,const uint row_index,const uint image_index,const bool redraw=false)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return;
//--- Get the number of cell icons
   int images_total=ImagesTotal(column_index,row_index);
//--- Leave, if (1) there are no icons or (2) out of range
   if(images_total==WRONG_VALUE || image_index>=(uint)images_total)
      return;
//--- Leave, if the specified icon matches the selected one
   if(image_index==m_columns[column_index].m_rows[row_index].m_selected_image)
      return;
//--- Store the index of the selected icon of the cell
   m_columns[column_index].m_rows[row_index].m_selected_image=(int)image_index;
//--- Redraw the cell, if specified
   if(redraw)
      RedrawCell(column_index,row_index);
  }
//+------------------------------------------------------------------+
//| Returns the image index in the specified cell                    |
//+------------------------------------------------------------------+
int CTable::SelectedImageIndex(const uint column_index,const uint row_index)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return(WRONG_VALUE);
//--- Return the value
   return(m_columns[column_index].m_rows[row_index].m_selected_image);
  }
//+------------------------------------------------------------------+
//| Fill the text color array                                        |
//+------------------------------------------------------------------+
void CTable::TextColor(const uint column_index,const uint row_index,const color clr,const bool redraw=false)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return;
//--- Store the text color in the common array
   m_columns[column_index].m_rows[row_index].m_text_color=clr;
//--- Redraw the cell, if specified
   if(redraw)
      RedrawCell(column_index,row_index);
  }
//+------------------------------------------------------------------+
//| Fills the array by the specified indexes                         |
//+------------------------------------------------------------------+
void CTable::SetValue(const uint column_index,const uint row_index,const string value="",const uint digits=0,const bool redraw=false)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return;
//--- Store the value into the array:
//    String
   if(m_columns[column_index].m_data_type==TYPE_STRING)
      m_columns[column_index].m_rows[row_index].m_full_text=value;
//--- Double
   else if(m_columns[column_index].m_data_type==TYPE_DOUBLE)
     {
      m_columns[column_index].m_rows[row_index].m_digits=digits;
      double type_value=::StringToDouble(value);
      m_columns[column_index].m_rows[row_index].m_full_text=::DoubleToString(type_value,digits);
     }
//--- Time
   else if(m_columns[column_index].m_data_type==TYPE_DATETIME)
     {
      datetime type_value=::StringToTime(value);
      m_columns[column_index].m_rows[row_index].m_full_text=::TimeToString(type_value);
     }
//--- Any other type will be stored as a string
   else
      m_columns[column_index].m_rows[row_index].m_full_text=value;
//--- Adjust and store the text, if it does not fit the cell
   m_columns[column_index].m_rows[row_index].m_short_text=CorrectingText(column_index,row_index);
//--- Redraw the cell, if specified
   if(redraw)
      RedrawCell(column_index,row_index);
  }
//+------------------------------------------------------------------+
//| Return value at the specified index                              |
//+------------------------------------------------------------------+
string CTable::GetValue(const uint column_index,const uint row_index)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return("");
//--- Return the value
   return(m_columns[column_index].m_rows[row_index].m_full_text);
  }
//+------------------------------------------------------------------+
//| Add a list of values to the combo box                            |
//+------------------------------------------------------------------+
void CTable::AddValueList(const uint column_index,const uint row_index,const string &array[],const uint selected_item=0)
  {
//--- Checking for exceeding the array range
   if(!CheckOutOfRange(column_index,row_index))
      return;
//--- Set the list size of the specified cell
   uint total=::ArraySize(array);
   ::ArrayResize(m_columns[column_index].m_rows[row_index].m_value_list,total);
//--- Store the passed values
   ::ArrayCopy(m_columns[column_index].m_rows[row_index].m_value_list,array);
//--- Check the index of the selected item in the list
   uint check_item_index=(selected_item>=total)? total-1 : selected_item;
//--- Store the selected item in the list
   m_columns[column_index].m_rows[row_index].m_selected_item=(int)check_item_index;
//--- Store the text of the selected in the cell
   m_columns[column_index].m_rows[row_index].m_full_text=array[check_item_index];
  }
//+------------------------------------------------------------------+
//| Horizontal scrollbar of the text box                             |
//+------------------------------------------------------------------+
void CTable::HorizontalScrolling(const int pos=WRONG_VALUE)
  {
//--- To determine the position of the thumb
   int index=0;
//--- Index of the last position
   int last_pos_index=int(m_table_x_size-m_table_visible_x_size);
//--- Adjustment in case the range has been exceeded
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Move the scrollbar thumb
   m_scrollh.MovingThumb(index);
//--- Shift the text box
   ShiftTable();
  }
//+------------------------------------------------------------------+
//| Vertical scrollbar of the text box                               |
//+------------------------------------------------------------------+
void CTable::VerticalScrolling(const int pos=WRONG_VALUE)
  {
//--- To determine the position of the thumb
   int index=0;
//--- Index of the last position
   int last_pos_index=int(m_table_y_size-m_table_visible_y_size);
//--- Adjustment in case the range has been exceeded
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Move the scrollbar thumb
   m_scrollv.MovingThumb(index);
//--- Shift the text box
   ShiftTable();
  }
//+------------------------------------------------------------------+
//| Shift the table relative to the scrollbars                       |
//+------------------------------------------------------------------+
void CTable::ShiftTable(void)
  {
//--- Get the current positions of sliders of the vertical and horizontal scrollbars
   int h_offset =m_scrollh.CurrentPos()*m_shift_x_step;
   int v_offset =m_scrollv.CurrentPos()*m_cell_y_size;
//--- Calculate the offsets for shifting
   int x_offset =(h_offset<1)? 0 : (h_offset>=m_shift_x2_limit)? m_shift_x2_limit-2 : h_offset;
   int y_offset =(v_offset<1)? 0 : (v_offset>=m_shift_y2_limit)? m_shift_y2_limit : v_offset;
//--- Calculation of the data position relative to the scrollbar thumbs
   long x =(m_table_x_size>m_table_visible_x_size)? x_offset : 0;
   long y =(m_table_y_size>m_table_visible_y_size)? y_offset : 0;
//--- Shift of the table
   m_table.SetInteger(OBJPROP_XOFFSET,x);
   m_table.SetInteger(OBJPROP_YOFFSET,y);
   m_headers.SetInteger(OBJPROP_XOFFSET,x);
  }
//+------------------------------------------------------------------+
//| Sort the data according to the specified column                  |
//+------------------------------------------------------------------+
void CTable::SortData(const uint column_index=0)
  {
//--- Index to start sorting from
   uint first_index=0;
//--- The last index
   uint last_index=m_rows_total-1;
//--- The first time it will be sorted in ascending order, every time after that it will be sorted in the opposite direction
   if(m_is_sorted_column_index==WRONG_VALUE || column_index!=m_is_sorted_column_index || m_last_sort_direction==SORT_DESCEND)
      m_last_sort_direction=SORT_ASCEND;
   else
      m_last_sort_direction=SORT_DESCEND;
//--- Store the index of the last sorted data column
   m_is_sorted_column_index=(int)column_index;
//--- Sorting
   QuickSort(first_index,last_index,column_index,m_last_sort_direction);
//--- Update the table
   Update(true);
  }
//+------------------------------------------------------------------+
//| Updating the table                                               |
//+------------------------------------------------------------------+
void CTable::Update(const bool redraw=false)
  {
//--- Redraw the table, if specified
   if(redraw)
     {
      //--- Calculate the table sizes
      CalculateTableSize();
      //--- Resize the table
      ChangeTableSize();
      //--- Redraw the table
      DrawTable();
      //--- Update the table
      m_canvas.Update();
      m_table.Update();
      //--- Update headers, if they are enabled
      if(m_show_headers)
         m_headers.Update();
      //---
      return;
     }
//--- Update the table
   m_canvas.Update();
   m_table.Update();
//--- Update headers, if they are enabled
   if(m_show_headers)
      m_headers.Update();
  }
//+------------------------------------------------------------------+
//| Handling clicking on a header                                    |
//+------------------------------------------------------------------+
bool CTable::OnClickHeaders(const string clicked_object)
  {
//--- Leave, if (1) the sorting mode is disabled or (2) in the process of changing the column width
   if(!m_is_sort_mode || m_column_resize_control!=WRONG_VALUE)
      return(false);
//--- Leave, if the cells contain text boxes or combo boxes
   if(m_edit_state && m_combobox_state)
      return(false);
//--- Leave, if the scrollbar is active
   if(m_scrollv.State() || m_scrollh.State())
      return(false);
//--- Leave, if it has a different object name
   if(m_headers.Name()!=clicked_object)
      return(false);
//--- For determining the column index
   uint column_index=0;
//--- Get the relative X coordinate below the mouse cursor
   int x=m_mouse.RelativeX(m_headers);
//--- Determine the clicked header
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- If the header is found, store its index
      if(x>=m_columns[c].m_x && x<=m_columns[c].m_x2)
        {
         column_index=c;
         break;
        }
     }
//--- Sort the data according to the specified column
   SortData(column_index);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_SORT_DATA,CElementBase::Id(),m_is_sorted_column_index,::EnumToString(DataType(column_index)));
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling clicking on the table                                   |
//+------------------------------------------------------------------+
bool CTable::OnClickTable(const string clicked_object)
  {
//--- Leave, if in the process of changing the column width
   if(m_column_resize_control!=WRONG_VALUE)
      return(false);
//--- Leave, if the scrollbar is active
   if(m_scrollv.State() || m_scrollh.State())
      return(false);
//--- Leave, if it has a different object name
   if(m_table.Name()!=clicked_object)
      return(false);
//--- Determine the clicked row
   int r=PressedRowIndex();
//--- Determine the clicked cell
   int c=PressedCellColumnIndex();
//--- Check if the control in the cell was activated
   bool is_cell_element=CheckCellElement(c,r);
//--- If (1) the row selection mode is enabled and (2) cell control is not activated
   if(m_selectable_row && !is_cell_element)
     {
      //--- Change the color
      RedrawRow(true);
      m_table.Update();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CLICK_LIST_ITEM,CElementBase::Id(),m_selected_item,string(c)+"_"+string(r));
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling double clicking on the table                            |
//+------------------------------------------------------------------+
bool CTable::OnDoubleClickTable(const string clicked_object)
  {
//--- Leave, if the table is out of focus
   if(!m_table.MouseFocus())
      return(false);
//--- Determine the clicked row
   int r=PressedRowIndex();
//--- Determine the clicked cell
   int c=PressedCellColumnIndex();
//--- Check if the control in the cell was activated and return the result
   return(CheckCellElement(c,r,true));
  }
//+------------------------------------------------------------------+
//| Handling the end of the value input in the cell                  |
//+------------------------------------------------------------------+
bool CTable::OnEndEditCell(const int id)
  {
//--- Leave, if (1) the identifiers do not match or (2) there are no cells with text boxes
   if(id!=CElementBase::Id() || !m_edit_state)
      return(false);
//--- Set the value to the table cell
   SetValue(m_last_edit_column_index,m_last_edit_row_index,m_edit.GetValue(),0,true);
   Update();
//--- Deactivate and hide the text box
   m_edit.GetTextBoxPointer().DeactivateTextBox();
   m_edit.Hide();
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling selection of an item in the cell combo box              |
//+------------------------------------------------------------------+
bool CTable::OnClickComboboxItem(const int id)
  {
//--- Leave, if (1) the identifiers do not match or (2) there are no cells with combo boxes
   if(id!=CElementBase::Id() || !m_combobox_state)
      return(false);
//--- Indexes of the last edited cell
   int c=m_last_edit_column_index;
   int r=m_last_edit_row_index;
//--- Store the index of the item selected in the cell
   m_columns[c].m_rows[r].m_selected_item=m_combobox.GetListViewPointer().SelectedItemIndex();
//--- Set the value to the table cell
   SetValue(c,r,m_combobox.GetValue(),0,true);
   Update();
   return(true);
  }
//+------------------------------------------------------------------+
//| Checking if text boxes in the cells are hidden                   |
//+------------------------------------------------------------------+
void CTable::CheckAndHideEdit(void)
  {
//--- Leave, if (1) there is no text box or (2) it is hidden
   if(!m_edit_state || !m_edit.IsVisible())
      return;
//--- Check the focus
   m_edit.GetTextBoxPointer().CheckMouseFocus();
//--- Deactivate and hide the text box, if it (1) is out of focus and (2) the left mouse button is pressed
   if(!m_edit.GetTextBoxPointer().MouseFocus() && m_mouse.LeftButtonState())
     {
      m_edit.GetTextBoxPointer().DeactivateTextBox();
      m_edit.Hide();
      m_chart.Redraw();
     }
  }
//+------------------------------------------------------------------+
//| Checking if combo boxes in the cells are hidden                  |
//+------------------------------------------------------------------+
void CTable::CheckAndHideCombobox(void)
  {
//--- Leave, if (1) there is no combo box or (2) it is hidden
   if(!m_combobox_state || !m_combobox.IsVisible())
      return;
//--- Hide the combo box if it is out of focus and the mouse button is pressed
   if(!m_combobox.GetButtonPointer().MouseFocus() && m_mouse.LeftButtonState())
     {
      m_combobox.Hide();
      m_chart.Redraw();
     }
  }
//+------------------------------------------------------------------+
//| Returns the index of the clicked row                             |
//+------------------------------------------------------------------+
int CTable::PressedRowIndex(void)
  {
   int index=0;
//--- Get the relative Y coordinate below the mouse cursor
   int y=m_mouse.RelativeY(m_table);
//--- Determine the clicked row
   for(uint r=0; r<m_rows_total; r++)
     {
      //--- If the click was not on this line, go to the next
      if(!(y>=m_rows[r].m_y && y<=m_rows[r].m_y2))
         continue;
      //--- If the row selection mode is disabled, store the row index
      if(!m_selectable_row)
         index=(int)r;
      else
        {
         //--- If clicked a selected row
         if(r==m_selected_item)
           {
            //--- Deselect, if not prohibited
            if(!m_is_without_deselect)
              {
               m_prev_selected_item =m_selected_item;
               m_selected_item      =WRONG_VALUE;
               m_selected_item_text ="";
              }
            break;
           }
         //--- Store the row index and the row of the first cell
         m_prev_selected_item =(m_selected_item==WRONG_VALUE)? (int)r : m_selected_item;
         m_selected_item      =(int)r;
         m_selected_item_text =m_columns[0].m_rows[r].m_full_text;
        }
      break;
     }
//--- If the row selection mode is enabled, determine the clicked row index
   if(m_selectable_row)
      index=(m_selected_item==WRONG_VALUE)? m_prev_selected_item : m_selected_item;
//--- Return the index
   return(index);
  }
//+------------------------------------------------------------------+
//| Returns the index of the clicked cell column                     |
//+------------------------------------------------------------------+
int CTable::PressedCellColumnIndex(void)
  {
   int index=0;
//--- Get the relative X coordinate below the mouse cursor
   int x=m_mouse.RelativeX(m_table);
//--- Determine the clicked cell
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- If this cell was clicked, store the column index
      if(x>=m_columns[c].m_x && x<=m_columns[c].m_x2)
        {
         index=(int)c;
         break;
        }
     }
//--- Return the column index
   return(index);
  }
//+------------------------------------------------------------------+
//| Check if the cell control was activated when clicked             |
//+------------------------------------------------------------------+
bool CTable::CheckCellElement(const int column_index,const int row_index,const bool double_click=false)
  {
//--- Leave, if the cell has no controls
   if(m_columns[column_index].m_rows[row_index].m_type==CELL_SIMPLE)
      return(false);
//---
   switch(m_columns[column_index].m_rows[row_index].m_type)
     {
      //--- If it is a button cell
      case CELL_BUTTON :
        {
         if(!CheckPressedButton(column_index,row_index,double_click))
            return(false);
         //---
         break;
        }
      //--- If it is a checkbox cell
      case CELL_CHECKBOX :
        {
         if(!CheckPressedCheckBox(column_index,row_index,double_click))
            return(false);
         //---
         break;
        }
      //--- If this is a cell with a text edit box
      case CELL_EDIT :
        {
         if(!CheckPressedEdit(column_index,row_index,double_click))
            return(false);
         //---
         break;
        }
      //--- If this is a cell with a combo box
      case CELL_COMBOBOX :
        {
         if(!CheckPressedCombobox(column_index,row_index,double_click))
            return(false);
         //---
         break;
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Check if the button in the cell was clicked                      |
//+------------------------------------------------------------------+
bool CTable::CheckPressedButton(const int column_index,const int row_index,const bool double_click=false)
  {
//--- Leave, if there are no images in the cell
   if(ImagesTotal(column_index,row_index)<1)
     {
      ::Print(__FUNCTION__," > Assign at least one image to the button cell!");
      return(false);
     }
//--- Get the relative coordinates under the mouse cursor
   int x=m_mouse.RelativeX(m_table);
// --- Get the right border of the image
   int image_x  =int(m_columns[column_index].m_x+m_columns[column_index].m_image_x_offset);
   int image_x2 =int(image_x+m_columns[column_index].m_rows[row_index].m_images[0].Width());
//--- Leave, if the click was not on the image
   if(x>image_x2)
      return(false);
   else
     {
      //--- If this is not a double click, send a message
      if(!double_click)
        {
         int image_index=m_columns[column_index].m_rows[row_index].m_selected_image;
         ::EventChartCustom(m_chart_id,ON_CLICK_BUTTON,CElementBase::Id(),image_index,string(column_index)+"_"+string(row_index));
        }
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Check if the checkbox in the cell was clicked                    |
//+------------------------------------------------------------------+
bool CTable::CheckPressedCheckBox(const int column_index,const int row_index,const bool double_click=false)
  {
//--- Leave, if there are no images in the cell
   if(ImagesTotal(column_index,row_index)<2)
     {
      ::Print(__FUNCTION__," > Assign at least two images to the checkbox cell!");
      return(false);
     }
//--- Get the relative coordinates under the mouse cursor
   int x=m_mouse.RelativeX(m_table);
// --- Get the right border of the image
   int image_x  =int(m_columns[column_index].m_x+m_icon_x_gap);
   int image_x2 =int(image_x+m_columns[column_index].m_rows[row_index].m_images[0].Width());
//--- Leave, if (1) the click was not on the image and (2) it is not a double click
   if(x>image_x2 && !double_click)
      return(false);
   else
     {
      //--- Current index of the selected image
      int image_i=m_columns[column_index].m_rows[row_index].m_selected_image;
      //--- Determine the next index for the image
      int next_i=(image_i<ImagesTotal(column_index,row_index)-1)?++image_i : 0;
      //--- Select the next image and update the table
      ChangeImage(column_index,row_index,next_i,true);
      m_table.Update();
      //--- Send a message about it
      ::EventChartCustom(m_chart_id,ON_CLICK_CHECKBOX,CElementBase::Id(),next_i,string(column_index)+"_"+string(row_index));
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Check if the click was on the text box in the cell               |
//+------------------------------------------------------------------+
bool CTable::CheckPressedEdit(const int column_index,const int row_index,const bool double_click=false)
  {
//--- Leave, if it is not a double click
   if(!double_click)
      return(false);
//--- Store the indexes
   m_last_edit_row_index    =row_index;
   m_last_edit_column_index =column_index;
//--- Shift along the two axes
   int x_offset=(int)m_table.GetInteger(OBJPROP_XOFFSET);
   int y_offset=(int)m_table.GetInteger(OBJPROP_YOFFSET);
//--- Set the new coordinates
   m_edit.XGap(m_columns[column_index].m_x-x_offset);
   m_edit.YGap(m_rows[row_index].m_y+((m_show_headers)? m_header_y_size : 0)-y_offset);
//--- Size
   int x_size =m_columns[column_index].m_x2-m_columns[column_index].m_x+1;
   int y_size =m_cell_y_size+1;
//--- Set the size
   m_edit.GetTextBoxPointer().ChangeSize(x_size,y_size);
//--- Set the value from the table cell
   m_edit.SetValue(m_columns[column_index].m_rows[row_index].m_full_text);
//--- Activate the text box
   m_edit.GetTextBoxPointer().ActivateTextBox();
//--- Set the focus
   m_edit.GetTextBoxPointer().MouseFocus(true);
//--- Show the text box
   m_edit.Reset();
//--- Redraw the chart
   m_chart.Redraw();
   return(true);
  }
//+------------------------------------------------------------------+
//| Check if the combo box in the cell was clicked                   |
//+------------------------------------------------------------------+
bool CTable::CheckPressedCombobox(const int column_index,const int row_index,const bool double_click=false)
  {
//--- Leave, if it is not a double click
   if(!double_click)
      return(false);
//--- Store the indexes
   m_last_edit_row_index    =row_index;
   m_last_edit_column_index =column_index;
//--- Shift along the two axes
   int x_offset=(int)m_table.GetInteger(OBJPROP_XOFFSET);
   int y_offset=(int)m_table.GetInteger(OBJPROP_YOFFSET);
//--- Set the new coordinates
   m_combobox.XGap(m_columns[column_index].m_x-x_offset);
   m_combobox.YGap(m_rows[row_index].m_y+((m_show_headers)? m_header_y_size : 0)-y_offset);
//--- Set the button size
   int x_size =m_columns[column_index].m_x2-m_columns[column_index].m_x+1;
   int y_size =m_cell_y_size+1;
   m_combobox.GetButtonPointer().ChangeSize(x_size,y_size);
//--- Set the list size
   y_size=m_combobox.GetListViewPointer().YSize();
   m_combobox.GetListViewPointer().ChangeSize(x_size,y_size);
//--- Set the cell list size
   int total=::ArraySize(m_columns[column_index].m_rows[row_index].m_value_list);
   m_combobox.GetListViewPointer().Rebuilding(total);
//--- Set the list from the cell
   for(int i=0; i<total; i++)
      m_combobox.GetListViewPointer().SetValue(i,m_columns[column_index].m_rows[row_index].m_value_list[i]);
//--- Set the item from the cell
   int index=m_columns[column_index].m_rows[row_index].m_selected_item;
   m_combobox.SelectItem(index);
//--- Update the control
   m_combobox.GetButtonPointer().MouseFocus(true);
   m_combobox.GetButtonPointer().Update(true);
   m_combobox.GetListViewPointer().Update(true);
//--- Show the text box
   m_combobox.Reset();
//--- Redraw the chart
   m_chart.Redraw();
//--- Send a message about the change in the graphical interface
   ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
   return(true);
  }
//+------------------------------------------------------------------+
//| Quicksort algorithm                                              |
//+------------------------------------------------------------------+
void CTable::QuickSort(uint beg,uint end,uint column,const ENUM_SORT_MODE mode=SORT_ASCEND)
  {
   uint   r1         =beg;
   uint   r2         =end;
   uint   c          =column;
   string temp       =NULL;
   string value      =NULL;
   uint   data_total =m_rows_total-1;
//--- Run the algorithm while the left index is less than the rightmost index
   while(r1<end)
     {
      //--- Get the value from the middle of the row
      value=m_columns[c].m_rows[(beg+end)>>1].m_full_text;
      //--- Run the algorithm while the left index is less than the found right index
      while(r1<r2)
        {
         //--- Shift the index to the right while finding the value on the specified condition
         while(CheckSortCondition(c,r1,value,(mode==SORT_ASCEND)? false : true))
           {
            //--- Checking for exceeding the array range
            if(r1==data_total)
               break;
            r1++;
           }
         //--- Shift the index to the left while finding the value on the specified condition
         while(CheckSortCondition(c,r2,value,(mode==SORT_ASCEND)? true : false))
           {
            //--- Checking for exceeding the array range
            if(r2==0)
               break;
            r2--;
           }
         //--- If the left index is still not greater than the right index
         if(r1<=r2)
           {
            //--- Swap the values
            Swap(r1,r2);
            //--- If the left limit has been reached
            if(r2==0)
              {
               r1++;
               break;
              }
            //---
            r1++;
            r2--;
           }
        }
      //--- Recursive continuation of the algorithm, until the beginning of the range is reached
      if(beg<r2)
         QuickSort(beg,r2,c,mode);
      //--- Narrow the range for the next iteration
      beg=r1;
      r2=end;
     }
  }
//+------------------------------------------------------------------+
//| Comparing the values on the specified sorting condition          |
//+------------------------------------------------------------------+
//| direction: true (>), false (<)                                   |
//+------------------------------------------------------------------+
bool CTable::CheckSortCondition(uint column_index,uint row_index,const string check_value,const bool direction)
  {
   bool condition=false;
//---
   switch(m_columns[column_index].m_data_type)
     {
      case TYPE_STRING :
        {
         string v1=m_columns[column_index].m_rows[row_index].m_full_text;
         string v2=check_value;
         condition=(direction)? v1>v2 : v1<v2;
         break;
        }
      //---
      case TYPE_DOUBLE :
        {
         double v1=double(m_columns[column_index].m_rows[row_index].m_full_text);
         double v2=double(check_value);
         condition=(direction)? v1>v2 : v1<v2;
         break;
        }
      //---
      case TYPE_DATETIME :
        {
         datetime v1=::StringToTime(m_columns[column_index].m_rows[row_index].m_full_text);
         datetime v2=::StringToTime(check_value);
         condition=(direction)? v1>v2 : v1<v2;
         break;
        }
      //---
      default :
        {
         long v1=(long)m_columns[column_index].m_rows[row_index].m_full_text;
         long v2=(long)check_value;
         condition=(direction)? v1>v2 : v1<v2;
         break;
        }
     }
//---
   return(condition);
  }
//+------------------------------------------------------------------+
//| Swap the elements                                                |
//+------------------------------------------------------------------+
void CTable::Swap(uint r1,uint r2)
  {
//--- Iterate over all columns in a loop
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- Swap the full text
      string temp_text                    =m_columns[c].m_rows[r1].m_full_text;
      m_columns[c].m_rows[r1].m_full_text =m_columns[c].m_rows[r2].m_full_text;
      m_columns[c].m_rows[r2].m_full_text =temp_text;
      //--- Swap the short text
      temp_text                            =m_columns[c].m_rows[r1].m_short_text;
      m_columns[c].m_rows[r1].m_short_text =m_columns[c].m_rows[r2].m_short_text;
      m_columns[c].m_rows[r2].m_short_text =temp_text;
      //--- Swap the number of decimal places
      uint temp_digits                 =m_columns[c].m_rows[r1].m_digits;
      m_columns[c].m_rows[r1].m_digits =m_columns[c].m_rows[r2].m_digits;
      m_columns[c].m_rows[r2].m_digits =temp_digits;
      //--- Swap the text color
      color temp_text_color                =m_columns[c].m_rows[r1].m_text_color;
      m_columns[c].m_rows[r1].m_text_color =m_columns[c].m_rows[r2].m_text_color;
      m_columns[c].m_rows[r2].m_text_color =temp_text_color;
      //--- Swap the index of the selected icon
      int temp_selected_image                  =m_columns[c].m_rows[r1].m_selected_image;
      m_columns[c].m_rows[r1].m_selected_image =m_columns[c].m_rows[r2].m_selected_image;
      m_columns[c].m_rows[r2].m_selected_image =temp_selected_image;
      //--- Check if the cells contain images
      int r1_images_total=::ArraySize(m_columns[c].m_rows[r1].m_images);
      int r2_images_total=::ArraySize(m_columns[c].m_rows[r2].m_images);
      //--- Go to the next column, if both cells have no images
      if(r1_images_total<1 && r2_images_total<1)
         continue;
      //--- Swap the images
      CImage r1_temp_images[];
      //---
      ::ArrayResize(r1_temp_images,r1_images_total);
      for(int i=0; i<r1_images_total; i++)
         ImageCopy(r1_temp_images,m_columns[c].m_rows[r1].m_images,i);
      //---
      ::ArrayResize(m_columns[c].m_rows[r1].m_images,r2_images_total);
      for(int i=0; i<r2_images_total; i++)
         ImageCopy(m_columns[c].m_rows[r1].m_images,m_columns[c].m_rows[r2].m_images,i);
      //---
      ::ArrayResize(m_columns[c].m_rows[r2].m_images,r1_images_total);
      for(int i=0; i<r1_images_total; i++)
         ImageCopy(m_columns[c].m_rows[r2].m_images,r1_temp_images,i);
     }
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CTable::Draw(void)
  {
   DrawTable();
  }
//+------------------------------------------------------------------+
//| Draw table                                                       |
//+------------------------------------------------------------------+
void CTable::DrawTable(const bool only_visible=false)
  {
//--- If not indicated to redraw only the visible part of the table
   if(!only_visible)
     {
      //--- Set the row indexes of the entire table from the beginning to the end
      m_visible_table_from_index =0;
      m_visible_table_to_index   =m_rows_total;
     }
//--- Get the row indexes of the visible part of the table
   else
      VisibleTableIndexes();
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
//--- Draw the background of the table rows
   DrawRows();
//--- Draw a selected row
   DrawSelectedRow();
//--- Draw grid
   DrawGrid();
//--- Draw icon
   DrawImages();
//--- Draw text
   DrawText();
//--- Update headers, if they are enabled
   if(m_show_headers)
      DrawTableHeaders();
  }
//+------------------------------------------------------------------+
//| Redraws the specified cell of the table                          |
//+------------------------------------------------------------------+
void CTable::RedrawCell(const int column_index,const int row_index)
  {
//--- Coordinates
   int x1=m_columns[column_index].m_x+1;
   int x2=m_columns[column_index].m_x2-1;
   int y1=m_rows[row_index].m_y+1;
   int y2=m_rows[row_index].m_y2-1;
//--- To calculate the coordinates
   int  x=0,y=0;
//--- To check the focus
   bool is_row_focus=false;
//--- If the row highlighting mode is enabled
   if(m_lights_hover)
     {
      //--- (1) Get the relative Y coordinate of the mouse cursor and (2) the focus on the specified table row
      y=m_mouse.RelativeY(m_table);
      is_row_focus=(y>m_rows[row_index].m_y && y<=m_rows[row_index].m_y2);
     }
//--- Draw the cell background
   m_table.FillRectangle(x1,y1,x2,y2,RowColorCurrent(row_index,is_row_focus));
//--- Draw the icon, if (1) it is present in this cell and (2) the text of this column is aligned to the left
   if(ImagesTotal(column_index,row_index)>0 && m_columns[column_index].m_text_align==ALIGN_LEFT)
      CTable::DrawImage(column_index,row_index);
//--- Get the text alignment mode
   uint text_align=TextAlign(column_index,TA_TOP);
//--- Draw the text
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- Get the X coordinate of the text
      x=TextX(c);
      //--- Stop the cycle
      if(c==column_index)
         break;
     }
//--- (1) Calculate the Y coordinate, and (2) draw the text
   y=y1+m_label_y_gap-1;
   m_table.TextOut(x,y,m_columns[column_index].m_rows[row_index].m_short_text,TextColor(column_index,row_index),text_align);
  }
//+------------------------------------------------------------------+
//| Redraws the specified table row according to the specified mode  |
//+------------------------------------------------------------------+
void CTable::RedrawRow(const bool is_selected_row=false)
  {
//--- The current and the previous row indexes
   int item_index      =WRONG_VALUE;
   int prev_item_index =WRONG_VALUE;
//--- Initialization of the row indexes relative to the specified mode
   if(is_selected_row)
     {
      item_index      =m_selected_item;
      prev_item_index =m_prev_selected_item;
     }
   else
     {
      item_index      =m_item_index_focus;
      prev_item_index =m_prev_item_index_focus;
     }
//--- Leave, if the indexes are not defined
   if(prev_item_index==WRONG_VALUE && item_index==WRONG_VALUE)
      return;
//--- The number of rows and columns for drawing
   uint rows_total    =(item_index!=WRONG_VALUE && prev_item_index!=WRONG_VALUE && item_index!=prev_item_index)? 2 : 1;
   uint columns_total =m_columns_total-1;
//--- Coordinates
   int x1=0,x2=m_table_x_size-2;
   int y1[2]={0},y2[2]={0};
//--- Array for values in a certain sequence
   int indexes[2];
//--- If (1) the mouse cursor moved down or if (2) entering for the first time
   if(item_index>m_prev_item_index_focus || item_index==WRONG_VALUE)
     {
      indexes[0]=(item_index==WRONG_VALUE || prev_item_index!=WRONG_VALUE)? prev_item_index : item_index;
      indexes[1]=item_index;
     }
//--- If the mouse cursor moved up
   else
     {
      indexes[0]=item_index;
      indexes[1]=prev_item_index;
     }
//--- Draw the background of rows
   for(uint r=0; r<rows_total; r++)
     {
      //--- Calculate the coordinates of the upper and lower boundaries of the row
      y1[r]=m_rows[indexes[r]].m_y+1;
      y2[r]=m_rows[indexes[r]].m_y2-1;
      //--- Determine the focus on the row with respect to the highlighting mode
      bool is_item_focus=false;
      if(!m_lights_hover)
         is_item_focus=(indexes[r]==item_index && item_index!=WRONG_VALUE);
      else
         is_item_focus=(item_index==WRONG_VALUE)?(indexes[r]==prev_item_index) :(indexes[r]==item_index);
      //--- Draw the row background
      m_table.FillRectangle(x1,y1[r],x2,y2[r],RowColorCurrent(indexes[r],is_item_focus));
     }
//--- Grid color
   uint clr=::ColorToARGB(m_grid_color);
//--- Draw the borders
   for(uint r=0; r<rows_total; r++)
     {
      for(uint c=0; c<columns_total; c++)
         m_table.Line(m_columns[c].m_x2,y1[r],m_columns[c].m_x2,y2[r],clr);
     }
//--- Draw the icons
   for(uint r=0; r<rows_total; r++)
     {
      for(uint c=0; c<m_columns_total; c++)
        {
         //--- Draw the icon, if (1) it is present in this cell and (2) the text of this column is aligned to the left
         if(ImagesTotal(c,indexes[r])>0 && m_columns[c].m_text_align==ALIGN_LEFT)
            CTable::DrawImage(c,indexes[r]);
        }
     }
//--- To calculate the coordinates
   int x=0,y=0;
//--- Text alignment mode
   uint text_align=0;
//--- Draw the text
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- Get (1) the X coordinate of the text and (2) the text alignment mode
      x          =TextX(c);
      text_align =TextAlign(c,TA_TOP);
      //---
      for(uint r=0; r<rows_total; r++)
        {
         //--- (1) Calculate the coordinate and (2) draw the text
         y=m_rows[indexes[r]].m_y+m_label_y_gap;
         m_table.TextOut(x,y,m_columns[c].m_rows[indexes[r]].m_short_text,TextColor(c,indexes[r]),text_align);
        }
     }
  }
//+------------------------------------------------------------------+
//| Draws the background of the table rows                           |
//+------------------------------------------------------------------+
void CTable::DrawRows(void)
  {
//--- Coordinates of the mouse cursor
   int y=0;
//--- Coordinates of the headers
   int x1=0,x2=m_table_x_size-2;
   int y1=0,y2=0;
   bool is_row_focus=false;
//--- Get the relative X coordinate below the mouse cursor
   y=m_mouse.RelativeY(m_table);
//--- Draw the rows
   for(uint r=m_visible_table_from_index; r<m_visible_table_to_index; r++)
     {
      //--- Calculation of the coordinates of the row borders and storing the values
      m_rows[r].m_y  =y1 =(int)(r*m_cell_y_size);
      m_rows[r].m_y2 =y2 =y1+m_cell_y_size;
      //--- Check the focus
      is_row_focus=(m_lights_hover)?(y>y1 && y<y2) : false;
      //--- Draw the row background
      m_table.FillRectangle(x1,y1,x2,y2,RowColorCurrent(r,is_row_focus));
     }
  }
//+------------------------------------------------------------------+
//| Draws the selected row                                           |
//+------------------------------------------------------------------+
void CTable::DrawSelectedRow(void)
  {
//--- Leave, if there is no selected row
   if(m_selected_item==WRONG_VALUE)
      return;
//--- Set the initial coordinates for checking the condition
   int y_offset=m_selected_item*m_cell_y_size;
//--- Coordinates
   int x1=0;
   int y1=y_offset;
   int x2=m_table_x_size-2;
   int y2=y_offset+m_cell_y_size;
//--- Draw a filled rectangle
   m_table.FillRectangle(x1,y1,x2,y2,::ColorToARGB(m_selected_row_color,m_alpha));
  }
//+------------------------------------------------------------------+
//| Draw grid                                                        |
//+------------------------------------------------------------------+
void CTable::DrawGrid(void)
  {
//--- Grid color
   uint clr=::ColorToARGB(m_grid_color);
//--- Size of canvas for drawing
   int x_size=m_table_x_size;
   int y_size=m_table_y_size-1;
//--- Coordinates
   int x1=0,x2=0,y1=0,y2=0;
//--- Horizontal lines
   x1=0; y1=0; x2=x_size; y2=0;
   for(uint i=0; i<m_rows_total; i++)
      m_table.Line(x1,m_rows[i].m_y,x2,m_rows[i].m_y,clr);
//--- Vertical lines
   x1=0; y1=0; x2=0; y2=y_size;
   for(uint i=0; i<m_columns_total; i++)
     {

      m_columns[i].m_x2=x2=x1+=m_columns[i].m_width;
      m_table.Line(x1,y1,x2,y2,clr);
      //--- Store the X coordinate of the column
      if(i>0)
        {
         uint prev_i=i-1;
         m_columns[i].m_x=m_columns[prev_i].m_x+m_columns[prev_i].m_width;
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw all icons of the table                                      |
//+------------------------------------------------------------------+
void CTable::DrawImages(void)
  {
//--- To calculate the coordinates
   int x=0,y=0;
//--- Columns
   for(int c=0; c<(int)m_columns_total; c++)
     {
      //--- If the text is not aligned to the left, go to the next column
      if(m_columns[c].m_text_align!=ALIGN_LEFT)
         continue;
      //--- Rows
      for(int r=(int)m_visible_table_from_index; r<(int)m_visible_table_to_index; r++)
        {
         //--- Go to the next, if this cell does not contain icons
         if(ImagesTotal(c,r)<1)
            continue;
         //--- The selected icon in the cell (the first [0] is selected by default)
         int selected_image=m_columns[c].m_rows[r].m_selected_image;
         //--- Go to the next, if the array of pixels is empty
         if(m_columns[c].m_rows[r].m_images[selected_image].DataTotal()<1)
            continue;
         //--- Draw icon
         CTable::DrawImage(c,r);
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw an icon in the specified cell                               |
//+------------------------------------------------------------------+
void CTable::DrawImage(const int column_index,const int row_index)
  {
//--- Calculating coordinates
   int x =m_columns[column_index].m_x+m_columns[column_index].m_image_x_offset;
   int y =m_rows[row_index].m_y+m_columns[column_index].m_image_y_offset;
//--- The icon selected in the cell and its size
   int  selected_image =m_columns[column_index].m_rows[row_index].m_selected_image;
   uint image_height   =m_columns[column_index].m_rows[row_index].m_images[selected_image].Height();
   uint image_width    =m_columns[column_index].m_rows[row_index].m_images[selected_image].Width();
//--- Draw
   for(uint ly=0,i=0; ly<image_height; ly++)
     {
      for(uint lx=0; lx<image_width; lx++,i++)
        {
         //--- If there is no color, go to the next pixel
         if(m_columns[column_index].m_rows[row_index].m_images[selected_image].Data(i)<1)
            continue;
         //--- Get the color of the lower layer (cell background) and color of the specified pixel of the icon
         uint background  =(row_index==m_selected_item)? m_selected_row_color : m_canvas.PixelGet(x+lx,y+ly);
         uint pixel_color =m_columns[column_index].m_rows[row_index].m_images[selected_image].Data(i);
         //--- Blend the colors
         uint foreground=::ColorToARGB(m_clr.BlendColors(background,pixel_color));
         //--- Draw the pixel of the overlay icon
         m_table.PixelSet(x+lx,y+ly,foreground);
        }
     }
  }
//+------------------------------------------------------------------+
//| Draw text                                                        |
//+------------------------------------------------------------------+
void CTable::DrawText(void)
  {
//--- To calculate the coordinates and offsets
   int  x=0,y=0;
   uint text_align=0;
//--- Font properties
   m_table.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Columns
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- Get the X coordinate of the text
      x=TextX(c);
      //--- Get the text alignment mode
      text_align=TextAlign(c,TA_TOP);
      //--- Rows
      for(uint r=m_visible_table_from_index; r<m_visible_table_to_index; r++)
        {
         //--- Calculate the Y coordinate
         y=m_rows[r].m_y+m_label_y_gap;
         //--- Draw text
         m_table.TextOut(x,y,Text(c,r),TextColor(c,r),text_align);
        }
      //--- Zero the Y coordinate for the next cycle
      y=0;
     }
  }
//+------------------------------------------------------------------+
//| Draws the table headers                                          |
//+------------------------------------------------------------------+
void CTable::DrawTableHeaders(void)
  {
//--- Draw headers
   DrawHeaders();
//--- Draw grid
   DrawHeadersGrid();
//--- Draw the text of headers
   DrawHeadersText();
//--- Draw the sign of the possibility of sorting the table
   DrawSignSortedData();
  }
//+------------------------------------------------------------------+
//| Draws the background of headers                                  |
//+------------------------------------------------------------------+
void CTable::DrawHeaders(void)
  {
//--- If not in focus, reset the header colors
   if(!m_headers.MouseFocus() && m_column_resize_control==WRONG_VALUE)
     {
      m_headers.Erase(::ColorToARGB(m_headers_color,m_alpha));
      return;
     }
//--- To check the focus on the headers
   bool is_header_focus=false;
//--- Coordinates of the mouse cursor
   int x=0;
//--- Coordinates
   int y1=0,y2=m_header_y_size;
//--- Get the relative X coordinate below the mouse cursor
   if(::CheckPointer(m_mouse)!=POINTER_INVALID)
      x=m_mouse.RelativeX(m_headers);
//--- Clear the background of headers
   m_headers.Erase(::ColorToARGB(clrNONE,m_alpha));
//--- Offset considering the mode of changing the column widths
   int sep_x_offset=(m_column_resize_mode)? m_sep_x_offset : 0;
//--- Draw the background of headers
   for(uint i=0; i<m_columns_total; i++)
     {
      //--- Check the focus
      if(is_header_focus=x>m_columns[i].m_x+((i!=0)? sep_x_offset : 0) && x<=m_columns[i].m_x2+sep_x_offset)
         m_prev_header_index_focus=(int)i;
      //--- Determine the header color
      uint clr=(i==m_column_resize_control)? ::ColorToARGB(m_headers_color_hover,m_alpha) : HeaderColorCurrent(is_header_focus);
      //--- Draw the header background
      m_headers.FillRectangle(m_columns[i].m_x,y1,m_columns[i].m_x2,y2,clr);
     }
  }
//+------------------------------------------------------------------+
//| Draws the grid of the table headers                              |
//+------------------------------------------------------------------+
void CTable::DrawHeadersGrid(void)
  {
//--- Grid color
   uint clr=::ColorToARGB(m_grid_color);
//--- Coordinates
   int x1=0,x2=0,y1=0,y2=0;
   x2=m_table_x_size-1;
   y2=m_header_y_size-1;
//--- Draw frame
   m_headers.Line(x1,y2,x2,y2,clr);
//--- Separation lines
   x2=x1=m_columns[0].m_width;
   for(uint i=1; i<m_columns_total; i++)
      m_headers.Line(m_columns[i].m_x,y1,m_columns[i].m_x,y2,clr);
  }
//+------------------------------------------------------------------+
//| Draws the sign of the possibility of sorting the table           |
//+------------------------------------------------------------------+
void CTable::DrawSignSortedData(void)
  {
//--- Leave, if (1) sorting is disabled or (2) has not been performed yet
   if(!m_is_sort_mode || m_is_sorted_column_index==WRONG_VALUE)
      return;
//--- Leave, if the cells contain text boxes or combo boxes
   if(m_edit_state && m_combobox_state)
      return;
//--- Calculating coordinates
   int x =m_columns[m_is_sorted_column_index].m_x2-m_sort_arrow_x_gap;
   int y =m_sort_arrow_y_gap;
//--- The selected icon for the sorting direction
   int image_index=(m_last_sort_direction==SORT_ASCEND)? 0 : 1;
//--- Draw
   for(uint ly=0,i=0; ly<m_sort_arrows[image_index].Height(); ly++)
     {
      for(uint lx=0; lx<m_sort_arrows[image_index].Width(); lx++,i++)
        {
         //--- If there is no color, go to the next pixel
         if(m_sort_arrows[image_index].Data(i)<1)
            continue;
         //--- Get the color of the lower layer (header background) and color of the specified pixel of the icon
         uint background  =m_headers.PixelGet(x+lx,y+ly);
         uint pixel_color =m_sort_arrows[image_index].Data(i);
         //--- Blend the colors
         uint foreground=::ColorToARGB(m_clr.BlendColors(background,pixel_color));
         //--- Draw the pixel of the overlay icon
         m_headers.PixelSet(x+lx,y+ly,foreground);
        }
     }
  }
//+------------------------------------------------------------------+
//| Draws the text of the table headers                              |
//+------------------------------------------------------------------+
void CTable::DrawHeadersText(void)
  {
//--- To calculate the coordinates and offsets
   int x=0,y=m_header_y_size/2;
   int column_offset =0;
   uint text_align   =0;
//--- Text color
   uint clr=::ColorToARGB(m_headers_text_color);
//--- Font properties
   m_headers.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Draw text
   for(uint c=0; c<m_columns_total; c++)
     {
      //--- Get the X coordinate of the text
      x=TextX(c,true);
      //--- Get the text alignment mode
      text_align=TextAlign(c,TA_VCENTER);
      //--- Draw the column name
      m_headers.TextOut(x,y,CorrectingText(c,0,true),clr,text_align);
     }
  }
//+------------------------------------------------------------------+
//| Change the color of the table objects                            |
//+------------------------------------------------------------------+
void CTable::ChangeObjectsColor(void)
  {
//--- Track color change only if not in the mode of changing the column width
   if(m_column_resize_control!=WRONG_VALUE)
      return;
//--- Changing the color of the headers
   ChangeHeadersColor();
//--- Change the color of rows when hovered
   ChangeRowsColor();
  }
//+------------------------------------------------------------------+
//| Changing the table header color when hovered by mouse cursor     |
//+------------------------------------------------------------------+
void CTable::ChangeHeadersColor(void)
  {
//--- Leave, if the headers are disabled
   if(!m_show_headers)
      return;
//--- If the cursor is activated
   if(m_column_resize_control==WRONG_VALUE && 
      m_column_resize.IsVisible() && m_mouse.LeftButtonState())
     {
      //--- Store the index of the dragged column
      m_column_resize_control=m_prev_header_index_focus;
      //--- Send a message to determine the available controls
      ::EventChartCustom(m_chart_id,ON_SET_AVAILABLE,CElementBase::Id(),0,"");
      //--- Send a message about the change in the graphical interface
      ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
      return;
     }
//--- If not in focus
   if(!m_headers.MouseFocus())
     {
      //--- If not yet indicated that not in focus
      if(m_prev_header_index_focus!=WRONG_VALUE)
        {
         //--- Reset the focus
         m_prev_header_index_focus=WRONG_VALUE;
         //--- Change the color
         DrawTableHeaders();
         m_headers.Update();
        }
     }
//--- If in focus
   else
     {
      //--- Check the focus on the headers
      CheckHeaderFocus();
      //--- If there is no focus
      if(m_prev_header_index_focus==WRONG_VALUE)
        {
         //--- Change the color
         DrawTableHeaders();
         m_headers.Update();
        }
     }
  }
//+------------------------------------------------------------------+
//| Change the color of rows when hovered                            |
//+------------------------------------------------------------------+
void CTable::ChangeRowsColor(void)
  {
//--- Leave, if row highlighting when hovered is disabled
   if(!m_lights_hover)
      return;
//--- If not in focus
   if(!m_table.MouseFocus())
     {
      //--- If not yet indicated that not in focus
      if(m_prev_item_index_focus!=WRONG_VALUE)
        {
         m_item_index_focus=WRONG_VALUE;
         //--- Change the color
         RedrawRow();
         m_table.Update();
         //--- Reset the focus
         m_prev_item_index_focus=WRONG_VALUE;
        }
     }
//--- If in focus
   else
     {
      //--- Check the focus on the rows
      if(m_item_index_focus==WRONG_VALUE)
        {
         //--- Get the index of the row with the focus
         m_item_index_focus=CheckRowFocus();
         //--- Change the row color
         RedrawRow();
         m_table.Update();
         //--- Store as the previous index in focus
         m_prev_item_index_focus=m_item_index_focus;
         return;
        }
      //--- Get the relative Y coordinate below the mouse cursor
      int y=m_mouse.RelativeY(m_table);
      //--- Verifying the focus
      bool condition=(y>m_rows[m_item_index_focus].m_y && y<=m_rows[m_item_index_focus].m_y2);
      //--- If the focus changed
      if(!condition)
        {
         //--- Get the index of the row with the focus
         m_item_index_focus=CheckRowFocus();
         //--- Change the row color
         RedrawRow();
         m_table.Update();
         //--- Store as the previous index in focus
         m_prev_item_index_focus=m_item_index_focus;
        }
     }
  }
//+------------------------------------------------------------------+
//| Checking the focus on the header                                 |
//+------------------------------------------------------------------+
void CTable::CheckHeaderFocus(void)
  {
//--- Leave, if (1) the headers are disabled or (2) changing the column width has started
   if(!m_show_headers || m_column_resize_control!=WRONG_VALUE)
      return;
//--- Get the relative X coordinate below the mouse cursor
   int x=m_mouse.RelativeX(m_headers);
//--- Offset considering the mode of changing the column widths
   int sep_x_offset=(m_column_resize_mode)? m_sep_x_offset : 0;
//--- Search for focus
   for(uint i=0; i<m_columns_total; i++)
     {
      //--- If the header focus has changed
      if((x>m_columns[i].m_x+sep_x_offset && x<=m_columns[i].m_x2+sep_x_offset) && m_prev_header_index_focus!=i)
        {
         m_prev_header_index_focus=WRONG_VALUE;
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Determining the indexes of the visible part of the table         |
//+------------------------------------------------------------------+
void CTable::VisibleTableIndexes(void)
  {
//--- Determine the boundaries taking the offset of the visible part of the table into account
   int yoffset1 =(int)m_table.GetInteger(OBJPROP_YOFFSET);
   int yoffset2 =yoffset1+m_table_visible_y_size;
//--- Determine the first and the last indexes of the visible part of the table
   m_visible_table_from_index =int(double(yoffset1/m_cell_y_size));
   m_visible_table_to_index   =int(double(yoffset2/m_cell_y_size));
//--- Increase the lower index by one, if not out of range
   m_visible_table_to_index=(m_visible_table_to_index+1>m_rows_total)? m_rows_total : m_visible_table_to_index+1;
  }
//+------------------------------------------------------------------+
//| Checking the focus on the table rows                               |
//+------------------------------------------------------------------+
int CTable::CheckRowFocus(void)
  {
   int item_index_focus=WRONG_VALUE;
//--- Get the relative Y coordinate below the mouse cursor
   int y=m_mouse.RelativeY(m_table);
///--- Get the indexes of the local area of the table
   VisibleTableIndexes();
//--- Search for focus
   for(uint i=m_visible_table_from_index; i<m_visible_table_to_index; i++)
     {
      //--- If the row focus changed
      if(y>m_rows[i].m_y && y<=m_rows[i].m_y2)
        {
         item_index_focus=(int)i;
         break;
        }
     }
//--- Return the index of the row with the focus
   return(item_index_focus);
  }
//+------------------------------------------------------------------+
//| Checking the focus on borders of headers to change their widths  |
//+------------------------------------------------------------------+
void CTable::CheckColumnResizeFocus(void)
  {
//--- Leave, if the mode of changing the column widths is disabled
   if(!m_column_resize_mode)
      return;
//--- Leave, if started changing the column width
   if(m_column_resize_control!=WRONG_VALUE)
     {
      //--- Update coordinates of cursor
      m_column_resize.Moving(m_mouse.X(),m_mouse.Y());
      return;
     }
//--- To check the focus on the borders of headers
   bool is_focus=false;
//--- If the mouse cursor is in the area of headers
   if(m_headers.MouseFocus())
     {
      //--- Get the relative X coordinate below the mouse cursor    
      int x=m_mouse.RelativeX(m_headers);
      //--- Search for focus
      for(uint i=0; i<m_columns_total; i++)
        {
         if(is_focus=x>m_columns[i].m_x2-m_sep_x_offset && x<=m_columns[i].m_x2+m_sep_x_offset)
            break;
        }
      //--- If there is a focus
      if(is_focus)
        {
         //--- Update the cursor coordinates and make it visible
         m_column_resize.Moving(m_mouse.X(),m_mouse.Y());
         m_column_resize.Reset();
         m_chart.Redraw();
        }
      else
        {
         m_column_resize.Hide();
        }
     }
//--- Hide the pointer, if not in focus
   else if(!is_focus)
      m_column_resize.Hide();
  }
//+------------------------------------------------------------------+
//| Changes the width of the dragged column                          |
//+------------------------------------------------------------------+
void CTable::ChangeColumnWidth(void)
  {
//--- Leave, if the headers are disabled
   if(!m_show_headers)
      return;
//--- Check the focus on the header borders
   CheckColumnResizeFocus();
//--- If completed, reset the value
   if(m_column_resize_control==WRONG_VALUE)
     {
      m_column_resize_x_fixed    =0;
      m_column_resize_prev_width =0;
      m_column_resize_prev_thumb =0;
      return;
     }
//--- Get the relative X coordinate below the mouse cursor
   int x=m_mouse.RelativeX(m_headers);
//--- If the process of changing the column width has just begun
   if(m_column_resize_x_fixed<1)
     {
      //--- Store the current X coordinate and width of the column
      m_column_resize_x_fixed    =x;
      m_column_resize_prev_width =m_columns[m_column_resize_control].m_width;
      m_column_resize_prev_thumb =m_scrollh.CurrentPos();
     }
//--- Calculate the new width for the column
   int new_width=m_column_resize_prev_width+(x-m_column_resize_x_fixed);
//--- Leave unchanged, if less than the specified limit
   if(new_width<m_min_column_width)
      return;
//--- Save the new width of the column
   m_columns[m_column_resize_control].m_width=new_width;
//--- Calculate the table sizes
   CalculateTableSize();
//--- Resize the table
   ChangeTableSize();
//--- Adjust the scrollbar thumb if its position has changed
   if(m_scrollh.CurrentPos()!=m_column_resize_prev_thumb)
     {
      m_scrollh.MovingThumb(m_column_resize_prev_thumb);
      //--- Adjustment of the table relative to the scrollbars
      ShiftTable();
     }
//--- Draw the table
   DrawTable(true);
   Update();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Checking for exceeding the range of columns                      |
//+------------------------------------------------------------------+
template<typename T>
int CTable::CheckArraySize(const T &array[])
  {
   int total=0;
   int array_size=::ArraySize(array);
//--- Leave, if a zero-sized array was passed
   if(array_size<1)
      return(WRONG_VALUE);
//--- Adjust the value to prevent the array exceeding the range 
   total=(array_size<(int)m_columns_total)? array_size :(int)m_columns_total;
//--- Return the adjusted size of the array
   return(total);
  }
//+------------------------------------------------------------------+
//| Checking for exceeding the range of columns                      |
//+------------------------------------------------------------------+
bool CTable::CheckOutOfColumnRange(const uint column_index)
  {
//--- Checking for exceeding the column range
   uint csize=::ArraySize(m_columns);
   if(csize<1 || column_index>=csize)
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Checking for exceeding the range of columns and rows             |
//+------------------------------------------------------------------+
bool CTable::CheckOutOfRange(const uint column_index,const uint row_index)
  {
//--- Checking for exceeding the column range
   uint csize=::ArraySize(m_columns);
   if(csize<1 || column_index>=csize)
      return(false);
//--- Checking for exceeding the row range
   uint rsize=::ArraySize(m_columns[column_index].m_rows);
   if(rsize<1 || row_index>=rsize)
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculate with consideration of recent changes and resize table  |
//+------------------------------------------------------------------+
void CTable::RecalculateAndResizeTable(const bool redraw=false)
  {
//--- Calculate the table sizes
   CalculateTableSize();
//--- Resize the table
   ChangeTableSize();
//--- Update the table
   Update(redraw);
  }
//+------------------------------------------------------------------+
//| Initialize the specified column with the default values          |
//+------------------------------------------------------------------+
void CTable::ColumnInitialize(const uint column_index)
  {
//--- Initialize the column properties with the default values
   m_columns[column_index].m_x              =0;
   m_columns[column_index].m_x2             =0;
   m_columns[column_index].m_width          =100;
   m_columns[column_index].m_data_type      =TYPE_STRING;
   m_columns[column_index].m_text_align     =ALIGN_CENTER;
   m_columns[column_index].m_text_x_offset  =m_label_x_gap;
   m_columns[column_index].m_image_x_offset =m_icon_x_gap;
   m_columns[column_index].m_image_y_offset =m_icon_y_gap;
   m_columns[column_index].m_header_text    ="";
  }
//+------------------------------------------------------------------+
//| Initialize the specified cell with the default values            |
//+------------------------------------------------------------------+
void CTable::CellInitialize(const uint column_index,const uint row_index)
  {
   m_columns[column_index].m_rows[row_index].m_full_text      ="";
   m_columns[column_index].m_rows[row_index].m_short_text     ="";
   m_columns[column_index].m_rows[row_index].m_selected_image =0;
   m_columns[column_index].m_rows[row_index].m_text_color     =m_label_color;
   m_columns[column_index].m_rows[row_index].m_digits         =0;
   m_columns[column_index].m_rows[row_index].m_type           =CELL_SIMPLE;
//--- By default, the cells do not contain images
   ::ArrayFree(m_columns[column_index].m_rows[row_index].m_images);
  }
//+------------------------------------------------------------------+
//| Makes a copy of specified column (source) to new location (dest.)|
//+------------------------------------------------------------------+
void CTable::ColumnCopy(const uint destination,const uint source)
  {
   m_columns[destination].m_header_text    =m_columns[source].m_header_text;
   m_columns[destination].m_width          =m_columns[source].m_width;
   m_columns[destination].m_data_type      =m_columns[source].m_data_type;
   m_columns[destination].m_text_align     =m_columns[source].m_text_align;
   m_columns[destination].m_text_x_offset  =m_columns[source].m_text_x_offset;
   m_columns[destination].m_image_x_offset =m_columns[source].m_image_x_offset;
   m_columns[destination].m_image_y_offset =m_columns[source].m_image_y_offset;
  }
//+------------------------------------------------------------------+
//| Makes a copy of specified cell (source) to new location (dest.)  |
//+------------------------------------------------------------------+
void CTable::CellCopy(const uint column_dest,const uint row_dest,const uint column_source,const uint row_source)
  {
   m_columns[column_dest].m_rows[row_dest].m_type           =m_columns[column_source].m_rows[row_source].m_type;
   m_columns[column_dest].m_rows[row_dest].m_digits         =m_columns[column_source].m_rows[row_source].m_digits;
   m_columns[column_dest].m_rows[row_dest].m_full_text      =m_columns[column_source].m_rows[row_source].m_full_text;
   m_columns[column_dest].m_rows[row_dest].m_short_text     =m_columns[column_source].m_rows[row_source].m_short_text;
   m_columns[column_dest].m_rows[row_dest].m_text_color     =m_columns[column_source].m_rows[row_source].m_text_color;
   m_columns[column_dest].m_rows[row_dest].m_selected_image =m_columns[column_source].m_rows[row_source].m_selected_image;
//--- Copy the array size from the source to receiver
   int images_total=::ArraySize(m_columns[column_source].m_rows[row_source].m_images);
   ::ArrayResize(m_columns[column_dest].m_rows[row_dest].m_images,images_total);
//---
   for(int i=0; i<images_total; i++)
     {
      //--- Copy, if there are images
      if(m_columns[column_source].m_rows[row_source].m_images[i].DataTotal()<1)
         continue;
      //--- make a copy of the image
      ImageCopy(m_columns[column_dest].m_rows[row_dest].m_images,m_columns[column_source].m_rows[row_source].m_images,i);
     }
  }
//+------------------------------------------------------------------+
//| Copies the image data from one array to another                  |
//+------------------------------------------------------------------+
void CTable::ImageCopy(CImage &destination[],CImage &source[],const int index)
  {
//--- Copy the image pixels
   destination[index].CopyImageData(source[index]);
//--- Copy the image properties
   destination[index].Width(source[index].Width());
   destination[index].Height(source[index].Height());
   destination[index].BmpPath(source[index].BmpPath());
  }
//+------------------------------------------------------------------+
//| Returns the text                                                 |
//+------------------------------------------------------------------+
string CTable::Text(const int column_index,const int row_index)
  {
   string text="";
//--- Adjust the text, if not in the mode of changing the column width
   if(m_column_resize_control==WRONG_VALUE)
      text=CorrectingText(column_index,row_index);
//--- If in the mode of changing the column width, then...
   else
     {
      //--- ...adjust the text only for the column with the width being changed
      if(column_index==m_column_resize_control)
         text=CorrectingText(column_index,row_index);
      //--- For all others, use the previously adjusted text
      else
         text=m_columns[column_index].m_rows[row_index].m_short_text;
     }
//--- Return the text
   return(text);
  }
//+------------------------------------------------------------------+
//| Returns the X coordinate of the text in the specified column     |
//+------------------------------------------------------------------+
int CTable::TextX(const int column_index,const bool headers=false)
  {
   int x=0;
//--- Text alignment in cells based on the mode set for each column
   switch(m_columns[column_index].m_text_align)
     {
      //--- Center
      case ALIGN_CENTER :
         x=m_columns[column_index].m_x+(m_columns[column_index].m_width/2);
         break;
         //--- Right
      case ALIGN_RIGHT :
        {
         int x_offset=0;
         //---
         if(headers)
           {
            bool condition=(m_is_sorted_column_index!=WRONG_VALUE && m_is_sorted_column_index==column_index);
            x_offset=(condition)? m_label_x_gap+m_sort_arrow_x_gap : m_label_x_gap;
           }
         else
            x_offset=m_columns[column_index].m_text_x_offset;
         //---
         x=m_columns[column_index].m_x2-x_offset;
         break;
        }
      //--- Left
      case ALIGN_LEFT :
         x=m_columns[column_index].m_x+((headers)? m_label_x_gap : m_columns[column_index].m_text_x_offset);
         break;
     }
//--- Return the alignment type
   return(x);
  }
//+------------------------------------------------------------------+
//| Returns the text alignment mode in the specified column          |
//+------------------------------------------------------------------+
uint CTable::TextAlign(const int column_index,const uint anchor)
  {
   uint text_align=0;
//--- Text alignment for the current column
   switch(m_columns[column_index].m_text_align)
     {
      case ALIGN_CENTER :
         text_align=TA_CENTER|anchor;
         break;
      case ALIGN_RIGHT :
         text_align=TA_RIGHT|anchor;
         break;
      case ALIGN_LEFT :
         text_align=TA_LEFT|anchor;
         break;
     }
//--- Return the alignment type
   return(text_align);
  }
//+------------------------------------------------------------------+
//| Returns the color of the cell text                               |
//+------------------------------------------------------------------+
uint CTable::TextColor(const int column_index,const int row_index)
  {
   uint clr=(row_index==m_selected_item)? m_selected_row_text_color : m_columns[column_index].m_rows[row_index].m_text_color;
//--- Return the header color
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Returns the current header background color                      |
//+------------------------------------------------------------------+
uint CTable::HeaderColorCurrent(const bool is_header_focus)
  {
   uint clr=clrNONE;
//--- If there is no focus
   if(!is_header_focus || !m_headers.MouseFocus())
      clr=m_headers_color;
   else
     {
      //--- If the left mouse button is pressed and not in the process of changing the column width
      bool condition=(m_mouse.LeftButtonState() && m_column_resize_control==WRONG_VALUE);
      clr=(condition)? m_headers_color_pressed : m_headers_color_hover;
     }
//--- Return the header color
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Returns the current row background color                         |
//+------------------------------------------------------------------+
uint CTable::RowColorCurrent(const int row_index,const bool is_row_focus)
  {
//--- If the row is selected
   if(row_index==m_selected_item)
      return(::ColorToARGB(m_selected_row_color,m_alpha));
//--- Row height
   uint clr=m_cell_color;
//--- If (1) there is no focus or (2) in the process of changing the column width or (3) the form is locked
   bool condition=(!is_row_focus || !m_table.MouseFocus() || m_column_resize_control!=WRONG_VALUE || m_main.IsLocked());
//--- If the mode of formatting in Zebra style is enabled
   if(m_is_zebra_format_rows!=clrNONE)
     {
      if(condition)
         clr=(row_index%2!=0)? m_is_zebra_format_rows : m_cell_color;
      else
         clr=m_cell_color_hover;
     }
   else
     {
      clr=(condition)? m_cell_color : m_cell_color_hover;
     }
//--- Return the color
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Returns the text adjusted to the column width                    |
//+------------------------------------------------------------------+
string CTable::CorrectingText(const int column_index,const int row_index,const bool headers=false)
  {
//--- Get the current text
   string corrected_text=(headers)? m_columns[column_index].m_header_text : m_columns[column_index].m_rows[row_index].m_full_text;
//--- Offsets from the cell edges along the X axis
   int x_offset=0;
//---
   if(headers)
      x_offset=(m_is_sorted_column_index==WRONG_VALUE)? m_label_x_gap*2 : m_label_x_gap+m_sort_arrow_x_gap;
   else
      x_offset=m_label_x_gap+m_columns[column_index].m_text_x_offset;
//--- Get the pointer to the canvas object
   CRectCanvas *obj=(headers)? ::GetPointer(m_headers) : ::GetPointer(m_table);
//--- Get the width of the text
   int full_text_width=obj.TextWidth(corrected_text);
//--- Space for the row
   int space_width=m_columns[column_index].m_width-x_offset;
//--- If it fits the cell, save the adjusted text in a separate array and return it
   if(full_text_width<=space_width)
     {
      //--- If those are not headers, save the adjusted text
      if(!headers)
         m_columns[column_index].m_rows[row_index].m_short_text=corrected_text;
      //---
      return(corrected_text);
     }
//--- If the text does not fit the cell, it is necessary to adjust the text (trim the excessive characters and add an ellipsis)
   else
     {
      //--- For working with a string
      string temp_text="";
      //--- Get the string length
      int total=::StringLen(corrected_text);
      //--- Delete characters from the string one by one, until the desired text width is reached
      for(int i=total-1; i>=0; i--)
        {
         //--- Delete one character
         temp_text=::StringSubstr(corrected_text,0,i);
         //--- If nothing is left, leave an empty string
         if(temp_text=="")
           {
            corrected_text="";
            break;
           }
         //--- Add an ellipsis before checking
         int text_width=obj.TextWidth(temp_text+"...");
         //--- If fits the cell
         if(text_width<space_width)
           {
            //--- Save the text and stop the cycle
            corrected_text=temp_text+"...";
            break;
           }
        }
     }
//--- If those are not headers, save the adjusted text
   if(!headers)
      m_columns[column_index].m_rows[row_index].m_short_text=corrected_text;
//--- Return the adjusted text
   return(corrected_text);
  }
//+------------------------------------------------------------------+
//| Moving the control                                               |
//+------------------------------------------------------------------+
void CTable::Moving(const bool only_visible=true)
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
      m_table.X(m_main.X2()-m_table.XGap());
      m_headers.X(m_main.X2()-m_headers.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_table.X(m_main.X()+m_table.XGap());
      m_headers.X(m_main.X()+m_headers.XGap());
     }
//--- If the anchored to the bottom
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_table.Y(m_main.Y2()-m_table.YGap());
      m_headers.X(m_main.Y2()-m_headers.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_table.Y(m_main.Y()+m_table.YGap());
      m_headers.Y(m_main.Y()+m_headers.YGap());
     }
//--- Updating coordinates of graphical objects
   m_table.X_Distance(m_table.X());
   m_table.Y_Distance(m_table.Y());
   m_headers.X_Distance(m_headers.X());
   m_headers.Y_Distance(m_headers.Y());
//--- Move the rest of the controls
   CElement::Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Shows the control                                                |
//+------------------------------------------------------------------+
void CTable::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Visible state
   CElementBase::IsVisible(true);
//--- Moving the control
   Moving();
//--- Make all the objects visible
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
   m_table.Timeframes(OBJ_ALL_PERIODS);
   m_headers.Timeframes(OBJ_ALL_PERIODS);
//---
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
   if(m_scrollh.IsScroll())
      m_scrollh.Show();
  }
//+------------------------------------------------------------------+
//| Hides the control                                                |
//+------------------------------------------------------------------+
void CTable::Hide(void)
  {
//--- Leave, if the control is already hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide all objects
   m_canvas.Timeframes(OBJ_NO_PERIODS);
   m_table.Timeframes(OBJ_NO_PERIODS);
   m_headers.Timeframes(OBJ_NO_PERIODS);
   m_scrollv.Hide();
   m_scrollh.Hide();
//--- Visible state
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CTable::Delete(void)
  {
//--- Delete graphical objects
   m_table.Delete();
   m_canvas.Delete();
   m_headers.Delete();
   m_column_resize.Delete();
//--- Emptying the control arrays
   for(uint c=0; c<m_columns_total; c++)
     {
      for(uint r=0; r<m_rows_total; r++)
        {
         for(int i=0; i<ImagesTotal(c,r); i++)
            m_columns[c].m_rows[r].m_images[i].DeleteImageData();
         //---
         ::ArrayFree(m_columns[c].m_rows[r].m_images);
        }
     }
//---
   for(uint c=0; c<m_columns_total; c++)
      ::ArrayFree(m_columns[c].m_rows);
//---
   for(uint i=0; i<2; i++)
      m_sort_arrows[i].DeleteImageData();
//---
   ::ArrayFree(m_rows);
   ::ArrayFree(m_columns);
   ::ArrayFree(m_sort_arrows);
//--- Initializing of variables by default values
   CElementBase::IsVisible(true);
   m_is_sorted_column_index=WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CTable::SetZorders(void)
  {
   CElement::SetZorders();
   m_table.Z_Order(m_zorder+1);
   m_headers.Z_Order(m_zorder+1);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CTable::ResetZorders(void)
  {
   CElement::ResetZorders();
   m_table.Z_Order(WRONG_VALUE);
   m_headers.Z_Order(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Fast forward of the scrollbar                                    |
//+------------------------------------------------------------------+
void CTable::FastSwitching(void)
  {
//--- Leave, if there is no focus on the list view
   if(!CElementBase::MouseFocus())
      return;
//--- Return counter to initial value if the mouse button is released
   if(!m_mouse.LeftButtonState() || m_scrollv.State() || m_scrollh.State())
      m_timer_counter=SPIN_DELAY_MSC;
//--- If the mouse button is pressed
   else
     {
      //--- Increase counter to the specified interval
      m_timer_counter+=TIMER_STEP_MSC;
      //--- Exit if below zero
      if(m_timer_counter<0)
         return;
      //---
      bool scroll_v=false,scroll_h=false;
      //--- If scrolling up
      if(m_scrollv.GetIncButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollInc((uint)Id(),0);
         scroll_v=true;
        }
      //--- If scrolling down
      else if(m_scrollv.GetDecButtonPointer().MouseFocus())
        {
         m_scrollv.OnClickScrollDec((uint)Id(),1);
         scroll_v=true;
        }
      //--- If scrolling left
      else if(m_scrollh.GetIncButtonPointer().MouseFocus())
        {
         m_scrollh.OnClickScrollInc((uint)Id(),2);
         scroll_h=true;
        }
      //--- If scrolling right
      else if(m_scrollh.GetDecButtonPointer().MouseFocus())
        {
         m_scrollh.OnClickScrollDec((uint)Id(),3);
         scroll_h=true;
        }
      //--- Leave, if no button is pressed
      if(!scroll_v && !scroll_h)
         return;
      //--- Shift the table
      ShiftTable();
      //--- Update the scrollbars
      if(scroll_v) m_scrollv.Update(true);
      if(scroll_h) m_scrollh.Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Calculate the size of the table                                  |
//+------------------------------------------------------------------+
void CTable::CalculateTableSize(void)
  {
//--- Calculate the total width and height of the table
   CalculateTableXSize();
   CalculateTableYSize();
//--- Calculate the visible table size (twice in case it is necessary to display both scrollbars)
   for(int i=0; i<2; i++)
     {
      CalculateTableVisibleXSize();
      CalculateTableVisibleYSize();
     }
  }
//+------------------------------------------------------------------+
//| Calculate the full table size along the X axis                   |
//+------------------------------------------------------------------+
void CTable::CalculateTableXSize(void)
  {
//--- Calculate the total width of the table
   m_table_x_size=0;
   for(uint c=0; c<m_columns_total; c++)
      m_table_x_size=m_table_x_size+m_columns[c].m_width;
  }
//+------------------------------------------------------------------+
//| Calculate the full table size along the Y axis                   |
//+------------------------------------------------------------------+
void CTable::CalculateTableYSize(void)
  {
//--- Calculate the total height of the table
   m_table_y_size=(int)(m_cell_y_size*m_rows_total)+1;
  }
//+------------------------------------------------------------------+
//| Calculate the visible table size along the X axis                |
//+------------------------------------------------------------------+
void CTable::CalculateTableVisibleXSize(void)
  {
//--- Width of the table with a vertical scrollbar
   int x_size=(m_table_y_size>m_table_visible_y_size) ? m_x_size-m_scrollh.ScrollWidth()-2 : m_x_size-2;
//--- Set the frame width to display a fragment of the image (visible part of the table)
   m_table_visible_x_size=x_size;
//--- Adjust the size of the visible area along the X axis
   m_table_visible_x_size=(m_table_visible_x_size>=m_table_x_size)? m_table_x_size : m_table_visible_x_size;
//--- Store the shifting limitation
   m_shift_x2_limit=m_table_x_size-m_table_visible_x_size;
  }
//+------------------------------------------------------------------+
//| Calculate the visible table size along the Y axis                |
//+------------------------------------------------------------------+
void CTable::CalculateTableVisibleYSize(void)
  {
//--- Calculate the number of steps for offset
   uint x_size_total         =m_table_x_size/m_shift_x_step;
   uint visible_x_size_total =m_table_visible_x_size/m_shift_x_step;
//--- If there are headers and a horizontal scrollbar, adjust the control size along the Y axis
   int header_y_size=(m_show_headers)? m_header_y_size : 2;
   int y_size=(x_size_total>visible_x_size_total) ? m_y_size-header_y_size-m_scrollv.ScrollWidth()-2 : m_y_size-header_y_size-2;
//--- Set the frame height to display a fragment of the image (visible part of the table)
   m_table_visible_y_size=y_size;
//--- Adjust the size of the visible area along the Y axis
   m_table_visible_y_size=(m_table_visible_y_size>=m_table_y_size)? m_table_y_size : m_table_visible_y_size;
//--- Store the shifting limitation
   m_shift_y2_limit=m_table_y_size-m_table_visible_y_size;
  }
//+------------------------------------------------------------------+
//| Change the main size of the table                                |
//+------------------------------------------------------------------+
void CTable::ChangeMainSize(const int x_size,const int y_size)
  {
//--- Set the new size to the table background
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(x_size);
   m_canvas.YSize(y_size);
   m_canvas.Resize(x_size,y_size);
  }
//+------------------------------------------------------------------+
//| Resize the table                                                 |
//+------------------------------------------------------------------+
void CTable::ChangeTableSize(void)
  {
//--- Resize the table
   m_table.XSize(m_table_visible_x_size);
   m_table.YSize(m_table_visible_y_size);
   m_headers.XSize(m_table_visible_x_size);
   m_headers.YSize(m_header_y_size);
   m_table.Resize(m_table_x_size,m_table_y_size);
   m_headers.Resize(m_table_x_size,m_header_y_size);
//--- Set the size of the visible area
   m_table.SetInteger(OBJPROP_XSIZE,m_table_visible_x_size);
   m_table.SetInteger(OBJPROP_YSIZE,m_table_visible_y_size);
   m_headers.SetInteger(OBJPROP_XSIZE,m_table_visible_x_size);
   m_headers.SetInteger(OBJPROP_YSIZE,m_header_y_size);
//--- Resize the scrollbars
   ChangeScrollsSize();
//--- Adjust the data
   ShiftTable();
  }
//+------------------------------------------------------------------+
//| Resize the scrollbars                                            |
//+------------------------------------------------------------------+
void CTable::ChangeScrollsSize(void)
  {
//--- Calculate the number of steps for offset
   uint x_size_total         =m_table_x_size/m_shift_x_step;
   uint visible_x_size_total =m_table_visible_x_size/m_shift_x_step;
   uint y_size_total         =RowsTotal();
   uint visible_y_size_total =VisibleRowsTotal();
//--- Calculate the sizes of the scrollbars
   m_scrollh.Reinit(x_size_total,visible_x_size_total);
   m_scrollv.Reinit(y_size_total,visible_y_size_total);
//--- If the horizontal scrollbar is not required
   if(!m_scrollh.IsScroll())
     {
      //--- Hide the horizontal scrollbar
      m_scrollh.Hide();
      //--- Calculate and change the height of the vertical scrollbar
      int y_size=CElementBase::YSize()-2;
      if(m_scrollv.YSize()!=y_size)
         m_scrollv.ChangeYSize(y_size);
     }
   else
     {
      //--- Show the horizontal scrollbar
      if(CElementBase::IsVisible())
         m_scrollh.Show();
      //--- Calculate and change the height of the vertical scrollbar
      int y_size=CElementBase::YSize()-m_scrollh.ScrollWidth()-2;
      if(m_scrollv.YSize()!=y_size)
         m_scrollv.ChangeYSize(y_size);
     }
//--- If the vertical scrollbar is not required
   if(!m_scrollv.IsScroll())
     {
      //--- Hide the vertical scrollbar
      m_scrollv.Hide();
      //--- Change the width of the horizontal scrollbar
      int x_size=CElementBase::XSize()-1;
      if(m_scrollh.XSize()!=x_size)
         m_scrollh.ChangeXSize(x_size);
     }
   else
     {
      //--- Show the vertical scrollbar
      if(CElementBase::IsVisible())
         m_scrollv.Show();
      //--- Calculate and change the width of the horizontal scrollbar
      int x_size=CElementBase::XSize()-m_scrollv.ScrollWidth()-1;
      if(m_scrollh.XSize()!=x_size)
         m_scrollh.ChangeXSize(x_size);
     }
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CTable::ChangeWidthByRightWindowSide(void)
  {
//--- Leave, if the anchoring mode to the right side of the form is enabled
   if(m_anchor_right_window_side)
      return;
//--- Size
   int x_size =m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
   int y_size =(m_auto_yresize_mode)? m_main.Y2()-m_canvas.Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Leave, if the size is less than specified
   if(x_size<100)
      return;
//--- Set the new size of the table background
   ChangeMainSize(x_size,y_size);
//--- Calculate the table sizes
   CalculateTableSize();
//--- Resize the table
   ChangeTableSize();
//--- Draw the table
   DrawTable();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Change the height at the bottom edge of the window               |
//+------------------------------------------------------------------+
void CTable::ChangeHeightByBottomWindowSide(void)
  {
//--- Leave, if the anchoring mode to the bottom of the form is enabled  
   if(m_anchor_bottom_window_side)
      return;
//--- Size
   int x_size =(m_auto_xresize_mode)? m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset : m_x_size;
   int y_size =m_main.Y2()-m_canvas.Y()-m_auto_yresize_bottom_offset;
//--- Leave, if the size is less than specified
   if(y_size<60)
      return;
//--- Set the new size of the table background
   ChangeMainSize(x_size,y_size);
//--- Calculate the table sizes
   CalculateTableSize();
//--- Resize the table
   ChangeTableSize();
//--- Draw the table
   DrawTable();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
