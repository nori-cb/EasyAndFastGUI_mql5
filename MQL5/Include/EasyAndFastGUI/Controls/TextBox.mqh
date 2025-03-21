//+------------------------------------------------------------------+
//|                                                      TextBox.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "Scrolls.mqh"
#include "..\Keys.mqh"
#include "..\Element.mqh"
#include "..\TimeCounter.mqh"
#include <Charts\Chart.mqh>
//+------------------------------------------------------------------+
//| Class for creating a multiline text box                          |
//+------------------------------------------------------------------+
class CTextBox : public CElement
  {
private:
   //--- Instance of the class for working with the keyboard
   CKeys             m_keys;
   //--- Object for working with the time counter
   CTimeCounter      m_counter;
   //--- Objects for creating the control
   CRectCanvas       m_textbox;
   CScrollV          m_scrollv;
   CScrollH          m_scrollh;
   //--- Characters and their properties
   struct StringOptions
     {
      string            m_symbol[];     // Characters
      int               m_width[];      // Width of the characters
      bool              m_end_of_line;  // End of line sign
     };
   StringOptions     m_lines[];
   //--- Total size and size of the visible part of the control
   int               m_area_x_size;
   int               m_area_y_size;
   int               m_area_visible_x_size;
   int               m_area_visible_y_size;
   //--- Background and character colors of the selected text
   color             m_selected_back_color;
   color             m_selected_text_color;
   //--- The start and end indexes of lines and characters (of the selected text)
   int               m_selected_line_from;
   int               m_selected_line_to;
   int               m_selected_symbol_from;
   int               m_selected_symbol_to;
   //--- Default text color
   color             m_default_text_color;
   //--- Default text
   string            m_default_text;
   //--- Variable for working with a string
   string            m_temp_input_string;
   //--- Text offsets from the text box edges
   int               m_text_x_offset;
   int               m_text_y_offset;
   //--- Current coordinates of the text cursor
   int               m_text_cursor_x;
   int               m_text_cursor_y;
   //--- Current position of the text cursor
   uint              m_text_cursor_x_pos;
   uint              m_text_cursor_y_pos;
   //--- For calculation of the boundaries of the visible area of the text box
   int               m_x_limit;
   int               m_y_limit;
   int               m_x2_limit;
   int               m_y2_limit;
   //--- The step size for the horizontal offset
   int               m_shift_x_step;
   //--- Offset limits
   int               m_shift_x2_limit;
   int               m_shift_y2_limit;
   //--- Multiline mode
   bool              m_multi_line_mode;
   //--- The Word wrap mode
   bool              m_word_wrap_mode;
   //--- Read-only mode
   bool              m_read_only_mode;
   //--- Automatic text selection mode
   bool              m_auto_selection_mode;
   //--- State of the text edit box
   bool              m_text_edit_state;
   //--- Timer counter for fast forwarding the list view
   int               m_timer_counter;
   //---
public:
                     CTextBox(void);
                    ~CTextBox(void);
   //--- Methods for creating the control
   bool              CreateTextBox(const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateTextBox(void);
   bool              CreateScrollV(void);
   bool              CreateScrollH(void);
   //---
public:
   //--- Returns pointers to the scrollbars
   CScrollV         *GetScrollVPointer(void)                   { return(::GetPointer(m_scrollv)); }
   CScrollH         *GetScrollHPointer(void)                   { return(::GetPointer(m_scrollh)); }
   //--- Background and character colors of the selected text
   void              SelectedBackColor(const color clr)        { m_selected_back_color=clr;       }
   void              SelectedTextColor(const color clr)        { m_selected_text_color=clr;       }
   //--- (1) Default text and (2) default text color
   void              DefaultText(const string text)            { m_default_text=text;             }
   void              DefaultTextColor(const color clr)         { m_default_text_color=clr;        }
   //--- (1) Multiline mode, (2) word wrap mode
   void              MultiLineMode(const bool mode)            { m_multi_line_mode=mode;          }
   bool              MultiLineMode(void)                const  { return(m_multi_line_mode);       }
   void              WordWrapMode(const bool mode)             { m_word_wrap_mode=mode;           }
   //--- (1) Read only mode, (2) state of the text box, (3) automatic text selection mode
   bool              ReadOnlyMode(void)                  const { return(m_read_only_mode);        }
   void              ReadOnlyMode(const bool mode)             { m_read_only_mode=mode;           }
   bool              TextEditState(void)                 const { return(m_text_edit_state);       }
   void              AutoSelectionMode(const bool state)       { m_auto_selection_mode=state;     }
   //--- (1) Text offsets from the text box edges, (2) text alignment mode
   void              TextXOffset(const int x_offset)           { m_text_x_offset=x_offset;        }
   void              TextYOffset(const int y_offset)           { m_text_y_offset=y_offset;        }
   //--- Returns the index of the (1) line, (2) character where the text cursor is located,
   //    (3) the number of lines, (4) the number of visible lines
   uint              TextCursorLine(void)                      { return(m_text_cursor_y_pos);     }
   uint              TextCursorColumn(void)                    { return(m_text_cursor_x_pos);     }
   uint              LinesTotal(void)                          { return(::ArraySize(m_lines));    }
   uint              VisibleLinesTotal(void);
   //--- The number of characters in the specified line
   uint              ColumnsTotal(const uint line_index);
   //--- Information about the text cursor (line/number of lines, column/number of columns)
   string            TextCursorInfo(void);
   //--- Adds a line 
   void              AddLine(const string added_text="");
   //--- Adds text to the specified line 
   void              AddText(const uint line_index,const string added_text);
   //--- Returns the text from the specified line
   string            GetValue(const uint line_index=0);
   //--- Clears the text edit box
   void              ClearTextBox(void);
   //--- Table scrolling: (1) vertical and (2) horizontal
   void              VerticalScrolling(const int pos=WRONG_VALUE);
   void              HorizontalScrolling(const int pos=WRONG_VALUE);
   //--- Shift the data relative to the positions of scrollbars
   void              ShiftData(void);
   //--- Adjust the text box size
   void              CorrectSize(void);
   //--- Activate the text box
   void              ActivateTextBox(void);
   //--- Deactivate the text box
   void              DeactivateTextBox(void);
   //--- Resizing
   void              ChangeSize(const uint x_size,const uint y_size);
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
   //--- Draws the control
   virtual void      Draw(void);
   //--- Updating the control
   virtual void      Update(const bool redraw=false);
   //---
private:
   //--- Handling of the press on the control
   bool              OnClickTextBox(const string clicked_object);

   //--- Handling a keypress
   bool              OnPressedKey(const long key_code);
   //--- Handling the pressing of the Backspace key
   bool              OnPressedKeyBackspace(const long key_code);
   //--- Handling the pressing of the Enter key
   bool              OnPressedKeyEnter(const long key_code);
   //--- Handling the pressing of the Left key
   bool              OnPressedKeyLeft(const long key_code);
   //--- Handling the pressing of the Right key
   bool              OnPressedKeyRight(const long key_code);
   //--- Handling the pressing of the Up key
   bool              OnPressedKeyUp(const long key_code);
   //--- Handling the pressing of the Down key
   bool              OnPressedKeyDown(const long key_code);
   //--- Handling the pressing of the Home key
   bool              OnPressedKeyHome(const long key_code);
   //--- Handling the pressing of the End key
   bool              OnPressedKeyEnd(const long key_code);

   //--- Handling the pressing of the Ctrl + Left keys
   bool              OnPressedKeyCtrlAndLeft(const long key_code);
   //--- Handling the pressing of the Ctrl + Right keys
   bool              OnPressedKeyCtrlAndRight(const long key_code);
   //--- Handling the simultaneous pressing of the Ctrl + Home keys
   bool              OnPressedKeyCtrlAndHome(const long key_code);
   //--- Handling the simultaneous pressing of the Ctrl + End keys
   bool              OnPressedKeyCtrlAndEnd(const long key_code);

   //--- Handling the pressing of the Shift + Left keys
   bool              OnPressedKeyShiftAndLeft(const long key_code);
   //--- Handling the pressing of the Shift + Right keys
   bool              OnPressedKeyShiftAndRight(const long key_code);
   //--- Handling the pressing of the Shift + Up keys
   bool              OnPressedKeyShiftAndUp(const long key_code);
   //--- Handling the pressing of the Shift + Down keys
   bool              OnPressedKeyShiftAndDown(const long key_code);
   //--- Handling the pressing of the Shift + Home keys
   bool              OnPressedKeyShiftAndHome(const long key_code);
   //--- Handling the pressing of the Shift + End keys
   bool              OnPressedKeyShiftAndEnd(const long key_code);

   //--- Handling the pressing of the Ctrl + Shift + Left keys
   bool              OnPressedKeyCtrlShiftAndLeft(const long key_code);
   //--- Handling the pressing of the Ctrl + Shift + Right keys
   bool              OnPressedKeyCtrlShiftAndRight(const long key_code);
   //--- Handling the pressing of the Ctrl + Shift + Home keys
   bool              OnPressedKeyCtrlShiftAndHome(const long key_code);
   //--- Handling the pressing of the Ctrl + Shift + End keys
   bool              OnPressedKeyCtrlShiftAndEnd(const long key_code);
   //---
private:
   //--- Sets the (1) start and (2) end indexes for text selection
   void              SetStartSelectedTextIndexes(void);
   void              SetEndSelectedTextIndexes(void);
   //--- Select all text
   void              SelectAllText(void);
   //--- Reset the selected text
   void              ResetSelectedText(void);
   //--- Fast scrolling of the text box
   void              FastSwitching(void);

   //--- Output text to canvas
   void              TextOut(void);
   //--- Draws the frame
   virtual void      DrawBorder(void);
   //--- Draws the text cursor
   void              DrawCursor(void);
   //--- Displays the text and blinking cursor
   void              DrawTextAndCursor(const bool show_state=false);

   //--- Returns the current background color
   uint              AreaColorCurrent(void);
   //--- Returns the current text color
   uint              TextColorCurrent(void);
   //--- Returns the current frame color
   uint              BorderColorCurrent(void);
   //--- Change of objects' color
   void              ChangeObjectsColor(void);

   //--- Builds a string from characters
   string            CollectString(const uint line_index,const uint symbols_total=0);
   //--- Adds a character and its properties to the arrays of the structure
   void              AddSymbol(const string key_symbol);
   //--- Deletes a character
   void              DeleteSymbol(void);
   //--- Deletes (1) the selected text, (2) on one line, (3) on multiple lines
   bool              DeleteSelectedText(void);
   void              DeleteTextOnOneLine(void);
   void              DeleteTextOnMultipleLines(void);

   //--- Returns the line height
   uint              LineHeight(void);
   //--- Returns the line width starting from the specified character, in pixels
   uint              LineWidth(const uint symbol_index,const uint line_index);
   //--- Returns the maximum line width
   uint              MaxLineWidth(void);

   //--- Shifts the lines up by one position
   void              ShiftOnePositionUp(void);
   //--- Shifts the lines down by one position
   void              ShiftOnePositionDown(void);

   //--- Check for presence of selected text
   bool              CheckSelectedText(const uint line_index,const uint symbol_index);
   //--- Check for presence of the mandatory first line
   uint              CheckFirstLine(void);

   //--- Resizes the arrays of properties for the specified line
   void              ArraysResize(const uint line_index,const uint new_size);
   //--- Makes a copy of the specified (source) line to a new location (destination)
   void              LineCopy(const uint destination,const uint source);
   //--- Clears the specified line
   void              ClearLine(const uint line_index);

   //--- Moving the text cursor in the specified direction
   void              MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction);
   void              MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction,const bool with_highlighted_text);
   //--- Moving the text cursor to the left
   void              MoveTextCursorToLeft(const bool to_next_word=false);
   //--- Moving the text cursor to the right
   void              MoveTextCursorToRight(const bool to_next_word=false);
   //--- Moving the text cursor up by one line
   void              MoveTextCursorToUp(void);
   //--- Moving the text cursor down by one line
   void              MoveTextCursorToDown(void);

   //--- Set the cursor at the specified position
   void              SetTextCursor(const uint x_pos,const uint y_pos);
   //--- Set the cursor at the specified position of the mouse cursor
   void              SetTextCursorByMouseCursor(void);
   //--- Adjusting the text cursor along the X axis
   void              CorrectingTextCursorXPos(const int x_pos=WRONG_VALUE);

   //--- Calculation of coordinates for the text cursor
   void              CalculateTextCursorX(void);
   void              CalculateTextCursorY(void);

   //--- Calculation of the text box boundaries
   void              CalculateBoundaries(void);
   void              CalculateXBoundaries(void);
   void              CalculateYBoundaries(void);
   //--- Calculation of the X position of the scrollbar thumb on the left edge of the text box
   int               CalculateScrollThumbX(void);
   //--- Calculation of the X position of the scrollbar thumb on the right edge of the text box
   int               CalculateScrollThumbX2(void);
   //--- Calculation of the X position of the scrollbar
   int               CalculateScrollPosX(const bool to_right=false);
   //--- Calculation of the Y position of the scrollbar thumb on the top edge of the text box
   int               CalculateScrollThumbY(void);
   //--- Calculation of the Y position of the scrollbar thumb on the bottom edge of the text box
   int               CalculateScrollThumbY2(void);
   //--- Calculation of the Y position of the scrollbar
   int               CalculateScrollPosY(const bool to_down=false);
   //--- Adjusting the horizontal scrollbar
   void              CorrectingHorizontalScrollThumb(void);
   //--- Adjusting the vertical scrollbar
   void              CorrectingVerticalScrollThumb(void);

   //--- Calculates the size of the text box
   void              CalculateTextBoxSize(void);
   bool              CalculateTextBoxXSize(void);
   bool              CalculateTextBoxYSize(void);
   //--- Change the main size of the control
   void              ChangeMainSize(const int x_size,const int y_size);
   //--- Resize the text box
   void              ChangeTextBoxSize(const bool x_offset=false,const bool y_offset=false);
   //--- Resize the scrollbars
   void              ChangeScrollsSize(void);

   //--- Word wrapping
   void              WordWrap(void);
   //--- Returns the indexes of the first visible character and space
   bool              CheckForOverflow(const uint line_index,int &symbol_index,int &space_index);
   //--- The number of words in the specified line
   uint              WordsTotal(const uint line_index);
   //--- Returns the number of wrapped characters
   bool              WrapSymbolsTotal(const uint line_index,uint &wrap_symbols_total);
   //--- Returns the space character index by its number 
   uint              SymbolIndexBySpaceNumber(const uint line_index,const uint space_index);
   //--- Moves the lines
   void              MoveLines(const uint from_index,const uint to_index,const uint count,const bool to_down=true);
   //--- Moving characters in the specified line
   void              MoveSymbols(const uint line_index,const uint from_pos,const uint to_pos,const bool to_left=true);
   //--- Adding text to the specified line
   void              AddToString(const uint line_index,const string text);
   //--- Copies the characters to the passed array for moving to the next line
   void              CopyWrapSymbols(const uint line_index,const uint start_pos,const uint symbols_total,string &array[]);
   //--- Pastes characters from the passed array to the specified line
   void              PasteWrapSymbols(const uint line_index,const uint start_pos,string &array[]);
   //--- Wrapping the text to the next line
   void              WrapTextToNewLine(const uint curr_line_index,const uint symbol_index,const bool by_pressed_enter=false);
   //--- Wrapping text from the specified line to the previous line
   void              WrapTextToPrevLine(const uint next_line_index,const uint wrap_symbols_total,const bool is_all_text=false);

   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Change the height at the bottom edge of the window
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CTextBox::CTextBox(void) : m_selected_text_color(clrWhite),
                           m_selected_back_color(C'51,153,255'),
                           m_selected_line_from(WRONG_VALUE),
                           m_selected_line_to(WRONG_VALUE),
                           m_selected_symbol_from(WRONG_VALUE),
                           m_selected_symbol_to(WRONG_VALUE),
                           m_default_text_color(clrTomato),
                           m_default_text(""),
                           m_temp_input_string(""),
                           m_text_x_offset(5),
                           m_text_y_offset(4),
                           m_multi_line_mode(false),
                           m_word_wrap_mode(false),
                           m_read_only_mode(false),
                           m_auto_selection_mode(false),
                           m_text_edit_state(false),
                           m_text_cursor_x_pos(0),
                           m_text_cursor_y_pos(0),
                           m_shift_x_step(10),
                           m_shift_x2_limit(0),
                           m_shift_y2_limit(0)
  {
//--- Store the name of the control class in the base class
   CElementBase::ClassName(CLASS_NAME);
//--- The initial coordinates of the text cursor
   m_text_cursor_x=m_text_x_offset;
   m_text_cursor_y=m_text_y_offset;
//--- Setting parameters for the timer counter
   m_counter.SetParameters(16,200);
//--- The mandatory first line of the multiline text box
   ::ArrayResize(m_lines,1);
//--- Set the end of line sign
   m_lines[0].m_end_of_line=true;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CTextBox::~CTextBox(void)
  {
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CTextBox::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Handling the mouse move event
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //--- Check for the status of the scrollbars
      bool is_scroll_state=m_scrollv.ScrollBarControl() || ((m_multi_line_mode)? m_scrollh.ScrollBarControl() : false);
      //---
      if(m_text_edit_state)
        {
         //--- If (1) not in focus and (2) the left mouse button is pressed and (3) not in the mode of moving the scrollbars
         if(!CElementBase::MouseFocus() && m_mouse.LeftButtonState() && !is_scroll_state)
           {
            //--- Send a message about the end of the line editing mode in the text box, if the text box was active
            string str=(m_multi_line_mode)? TextCursorInfo() : "";
            ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),str);
            //--- Deactivate the text box
            DeactivateTextBox();
            //--- Update
            Update(true);
           }
        }
      //--- Change of objects' color
      ChangeObjectsColor();
      //--- Leave, if the multiline mode is disabled
      if(!m_multi_line_mode)
         return;
      //--- If the scrollbar is active
      if(is_scroll_state)
        {
         //--- Shift the data relative to the scrollbars
         ShiftData();
         //--- Deactivate the text box
         DeactivateTextBox();
         //--- Update
         Update(true);
         //--- Update the active scrollbar
         if(m_scrollh.State()) m_scrollh.Update(true);
         if(m_scrollv.State()) m_scrollv.Update(true);
        }
      //--- If one of the scrollbar buttons is pressed
      if(m_mouse.LeftButtonState() && 
         (m_scrollv.ScrollIncState() || m_scrollv.ScrollDecState() || 
         m_scrollh.ScrollIncState() || m_scrollh.ScrollDecState()))
        {
         //--- Deactivate the text box
         DeactivateTextBox();
         //--- Update
         Update(true);
        }
      //---
      return;
     }
//--- Handling the event of left mouse button click on the object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      //--- Pressing the text box
      if(OnClickTextBox(sparam))
         return;
      //---
      return;
     }
//--- Handling the click on the scrollbar buttons
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      //--- If the pressing was on the buttons of the scrollbar
      if(m_scrollv.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollv.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Shift the data
         ShiftData();
         m_scrollv.Update(true);
         return;
        }
      //--- If the pressing was on the buttons of the scrollbar
      if(m_scrollh.OnClickScrollInc((uint)lparam,(uint)dparam) ||
         m_scrollh.OnClickScrollDec((uint)lparam,(uint)dparam))
        {
         //--- Shift the data
         ShiftData();
         m_scrollh.Update(true);
         return;
        }
     }
//--- Handling the pressing of keyboard button
   if(id==CHARTEVENT_KEYDOWN)
     {
      //--- Leave, if the text box is not activated
      if(!m_text_edit_state)
         return;
      //--- Pressing a character key
      if(OnPressedKey(lparam))
         return;
      //--- Pressing the Backspace key
      if(OnPressedKeyBackspace(lparam))
         return;
      //--- Pressing the Enter key
      if(OnPressedKeyEnter(lparam))
         return;
      //--- Pressing the Left key
      if(OnPressedKeyLeft(lparam))
         return;
      //--- Pressing the Right key
      if(OnPressedKeyRight(lparam))
         return;
      //--- Pressing the Up key
      if(OnPressedKeyUp(lparam))
         return;
      //--- Pressing the Down key
      if(OnPressedKeyDown(lparam))
         return;
      //--- Pressing the Home key
      if(OnPressedKeyHome(lparam))
         return;
      //--- Pressing the End key
      if(OnPressedKeyEnd(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Left keys
      if(OnPressedKeyCtrlAndLeft(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Right keys
      if(OnPressedKeyCtrlAndRight(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Home keys
      if(OnPressedKeyCtrlAndHome(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + End keys
      if(OnPressedKeyCtrlAndEnd(lparam))
         return;
      //--- Simultaneous pressing of the Shift + Left keys
      if(OnPressedKeyShiftAndLeft(lparam))
         return;
      //--- Simultaneous pressing of the Shift + Right keys
      if(OnPressedKeyShiftAndRight(lparam))
         return;
      //--- Simultaneous pressing of the Shift + Up keys
      if(OnPressedKeyShiftAndUp(lparam))
         return;
      //--- Simultaneous pressing of the Shift + Down keys
      if(OnPressedKeyShiftAndDown(lparam))
         return;
      //--- Simultaneous pressing of the Shift + Home keys
      if(OnPressedKeyShiftAndHome(lparam))
         return;
      //--- Simultaneous pressing of the Shift + End keys
      if(OnPressedKeyShiftAndEnd(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Shift + Left keys
      if(OnPressedKeyCtrlShiftAndLeft(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Shift + Right keys
      if(OnPressedKeyCtrlShiftAndRight(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Shift + Home keys
      if(OnPressedKeyCtrlShiftAndHome(lparam))
         return;
      //--- Simultaneous pressing of the Ctrl + Shift + End keys
      if(OnPressedKeyCtrlShiftAndEnd(lparam))
         return;
      //---
      return;
     }
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CTextBox::OnEventTimer(void)
  {
//--- Fast switching of the values
   FastSwitching();
//--- Pause between updates of the text cursor
   if(m_counter.CheckTimeCounter())
     {
      //--- Update the text cursor if the control is visible and the text box is activated
      if(CElementBase::IsVisible() && m_text_edit_state)
         DrawTextAndCursor();
     }
  }
//+------------------------------------------------------------------+
//| Creates the Text Edit box control                                |
//+------------------------------------------------------------------+
bool CTextBox::CreateTextBox(const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(x_gap,y_gap);
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Create control
   if(!CreateCanvas())
      return(false);
   if(!CreateTextBox())
      return(false);
   if(!CreateScrollV())
      return(false);
   if(!CreateScrollH())
      return(false);
//--- Change the size of the text box
   ChangeTextBoxSize();
//--- In the word wrap mode, it is necessary to recalculate and reset the sizes
   if(m_word_wrap_mode)
     {
      CalculateTextBoxSize();
      ChangeTextBoxSize();
     }
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CTextBox::InitializeProperties(const int x_gap,const int y_gap)
  {
   m_x        =CElement::CalculateX(x_gap);
   m_y        =CElement::CalculateY(y_gap);
   m_x_size   =(m_x_size<0 || m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   m_y_size   =(m_y_size<0 || m_auto_yresize_mode)? m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset : m_y_size;
//--- Default colors
   m_back_color           =(m_back_color!=clrNONE)? m_back_color : clrWhite;
   m_back_color_locked    =(m_back_color_locked!=clrNONE)? m_back_color_locked : clrWhiteSmoke;
   m_border_color         =(m_border_color!=clrNONE)? m_border_color : clrGray;
   m_border_color_hover   =(m_border_color_hover!=clrNONE)? m_border_color_hover : clrBlack;
   m_border_color_locked  =(m_border_color_locked!=clrNONE)? m_border_color_locked : clrSilver;
   m_border_color_pressed =(m_border_color_pressed!=clrNONE)? m_border_color_pressed : clrCornflowerBlue;
   m_label_color          =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_color_locked   =(m_label_color_locked!=clrNONE)? m_label_color_locked : clrSilver;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing the background                    |
//+------------------------------------------------------------------+
bool CTextBox::CreateCanvas(void)
  {
//--- Forming the object name
   string name=CElementBase::ElementName("textbox");
//--- Creating an object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//--- Check for presence of the mandatory first line
   CheckFirstLine();
   return(true);
  }
//+------------------------------------------------------------------+
//| Crates the canvas for drawing a text box                         |
//+------------------------------------------------------------------+
bool CTextBox::CreateTextBox(void)
  {
//--- Forming the object name
   string name="";
   if(m_index==WRONG_VALUE)
      name=m_program_name+"_"+"textbox_edit"+"_"+(string)m_id;
   else
      name=m_program_name+"_"+"textbox_edit"+"_"+(string)m_index+"__"+(string)m_id;
//--- Coordinates
   int x =m_x+1;
   int y =m_y+1;
//--- Size
   int x_size =m_area_x_size-2;
   int y_size =m_area_y_size-2;
//--- Creating an object
   ::ResetLastError();
   if(!m_textbox.CreateBitmapLabel(m_chart_id,m_subwin,name,x,y,x_size,y_size,COLOR_FORMAT_ARGB_NORMALIZE))
     {
      ::Print(__FUNCTION__," > Failed to create a canvas for drawing the text box: ",::GetLastError());
      return(false);
     }
//--- Get the pointer to the base class
   CChartObject *chart=::GetPointer(m_textbox);
//--- Attach to the chart
   if(!chart.Attach(m_chart_id,name,m_subwin,1))
      return(false);
//--- Properties
   m_textbox.Z_Order(m_zorder+1);
   m_textbox.Tooltip("\n");
//--- Coordinates
   m_textbox.X(x);
   m_textbox.Y(y);
//--- Margins from the edge of the panel
   m_textbox.XGap(CElement::CalculateXGap(x));
   m_textbox.YGap(CElement::CalculateYGap(y));
//--- Set the size of the visible area
   m_textbox.SetInteger(OBJPROP_XSIZE,m_area_visible_x_size);
   m_textbox.SetInteger(OBJPROP_YSIZE,m_area_visible_y_size);
//--- Set the frame offset within the image along the X and Y axes
   m_textbox.SetInteger(OBJPROP_XOFFSET,0);
   m_textbox.SetInteger(OBJPROP_YOFFSET,0);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the vertical scrollbar                                   |
//+------------------------------------------------------------------+
bool CTextBox::CreateScrollV(void)
  {
//--- Store the pointer to the parent control
   m_scrollv.MainPointer(this);
//--- If the multiline mode is disabled
   if(!m_multi_line_mode)
     {
      //--- Initialize the vertical scrollbar
      m_scrollv.Reinit(m_area_y_size,m_area_visible_y_size);
      //--- Store the pointer to the parent control
      m_scrollv.GetIncButtonPointer().MainPointer(m_scrollv);
      m_scrollv.GetDecButtonPointer().MainPointer(m_scrollv);
      return(true);
     }
//--- Coordinates
   int x =m_scrollv.ScrollWidth()+1;
   int y =1;
//--- set properties
   m_scrollv.Index(0);
   m_scrollv.IsDropdown(CElementBase::IsDropdown());
   m_scrollv.XSize(m_scrollv.ScrollWidth());
   m_scrollv.YSize(m_y_size-m_scrollv.ScrollWidth()-1);
   m_scrollv.AnchorRightWindowSide(true);
//--- Calculate the number of steps for offset
   uint lines_total         =LinesTotal()+1;
   uint visible_lines_total =VisibleLinesTotal();
//--- Creating the scrollbar
   if(!m_scrollv.CreateScroll(x,y,lines_total,visible_lines_total))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_scrollv);
   return(true);
  }
//+------------------------------------------------------------------+
//| Creates the horizontal scrollbar                                 |
//+------------------------------------------------------------------+
bool CTextBox::CreateScrollH(void)
  {
//--- Store the pointer to the parent control
   m_scrollh.MainPointer(this);
//--- If the multiline mode is disabled
   if(!m_multi_line_mode)
     {
      //--- Initialize the horizontal scrollbar
      m_scrollh.Reinit(m_area_x_size,m_area_visible_x_size);
      //--- Store the pointer to the main control
      m_scrollh.GetIncButtonPointer().MainPointer(m_scrollh);
      m_scrollh.GetDecButtonPointer().MainPointer(m_scrollh);
      return(true);
     }
//--- Coordinates
   int x =1;
   int y =m_scrollh.ScrollWidth()+1;
//--- set properties
   m_scrollh.Index(1);
   m_scrollh.IsDropdown(CElementBase::IsDropdown());
   m_scrollh.XSize(CElementBase::XSize()-m_scrollv.ScrollWidth()-1);
   m_scrollh.YSize(m_scrollv.ScrollWidth());
   m_scrollh.AnchorBottomWindowSide(true);
//--- Calculate the number of steps for offset
   uint x_size_total         =m_area_x_size/m_shift_x_step;
   uint visible_x_size_total =m_area_visible_x_size/m_shift_x_step;
//--- Creating the scrollbar
   if(!m_scrollh.CreateScroll(x,y,x_size_total,visible_x_size_total))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_scrollh);
   return(true);
  }
//+------------------------------------------------------------------+
//| Returns the number of visible rows                               |
//+------------------------------------------------------------------+
uint CTextBox::VisibleLinesTotal(void)
  {
   return((m_area_visible_y_size-(m_text_y_offset*2))/LineHeight());
  }
//+------------------------------------------------------------------+
//| Returns the number of characters in the specified line           |
//+------------------------------------------------------------------+
uint CTextBox::ColumnsTotal(const uint line_index)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Prevention of exceeding the range
   uint check_index=(line_index<lines_total)? line_index : lines_total-1;
//--- Get the size of the array of characters in the line
   uint symbols_total=::ArraySize(m_lines[check_index].m_symbol);
//--- Return the number of characters
   return(symbols_total);
  }
//+------------------------------------------------------------------+
//| Information about the text cursor                                |
//+------------------------------------------------------------------+
string CTextBox::TextCursorInfo(void)
  {
//--- String components
   string lines_total        =(string)LinesTotal();
   string columns_total      =(string)ColumnsTotal(TextCursorLine());
   string text_cursor_line   =string(TextCursorLine()+1);
   string text_cursor_column =string(TextCursorColumn()+1);
//--- Generate the string
   string text_box_info="Ln "+text_cursor_line+"/"+lines_total+", "+"Col "+text_cursor_column+"/"+columns_total;
//--- Return the string
   return(text_box_info);
  }
//+------------------------------------------------------------------+
//| Adds a line                                                      |
//+------------------------------------------------------------------+
void CTextBox::AddLine(const string added_text="")
  {
//--- Leave, if the multiline mode is disabled
   if(!m_multi_line_mode)
      return;
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Reserve size of the array
   int reserve_size=100;
//--- Set the size of the arrays of the structure
   ::ArrayResize(m_lines,lines_total+1,reserve_size);
//--- Set the end of line sign
   m_lines[lines_total].m_end_of_line=true;
//--- Set the text
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Add text to the line
   AddToString(lines_total,added_text);
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize();
//--- In the word wrap mode, it is necessary to recalculate and reset the sizes
   if(m_word_wrap_mode)
     {
      CalculateTextBoxSize();
      ChangeTextBoxSize();
     }
//--- Redraw the scrollbars
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Adds text to the specified line                                  |
//+------------------------------------------------------------------+
void CTextBox::AddText(const uint line_index,const string added_text)
  {
//--- Leave, if an empty string is passed
   if(added_text=="")
      return;
//--- Get the size of the lines array, with a check for presence of the mandatory first line
   uint lines_total=CheckFirstLine();
//--- Prevention of exceeding the range
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Adjustment of the index with consideration of the word wrap mode
   if(m_word_wrap_mode)
     {
      for(uint i=0,j=0; i<lines_total; i++)
        {
         //--- Count lines by the end of line sign
         if(m_lines[i].m_end_of_line)
           {
            //---
            if(l==j || i+1>=lines_total)
              {
               l=i;
               break;
              }
            //---
            j++;
           }
        }
     }
//--- Set the text
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Add text to the line
   AddToString(l,added_text);
  }
//+------------------------------------------------------------------+
//| Returns the text from the specified line                         |
//+------------------------------------------------------------------+
string CTextBox::GetValue(const uint line_index=0)
  {
//--- Get the size of the lines array, with a check for presence of the mandatory first line
   uint lines_total=CheckFirstLine();
//--- Prevention of exceeding the range
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Return the text
   return(CollectString(l));
  }
//+------------------------------------------------------------------+
//| Clears the text edit box                                         |
//+------------------------------------------------------------------+
void CTextBox::ClearTextBox(void)
  {
//--- Delete all lines except the first
   ::ArrayResize(m_lines,1);
//--- Clear the first line
   ClearLine(0);
  }
//+------------------------------------------------------------------+
//| Horizontal scrollbar of the text box                             |
//+------------------------------------------------------------------+
void CTextBox::HorizontalScrolling(const int pos=WRONG_VALUE)
  {
//--- To determine the position of the thumb
   int index=0;
//--- Index of the last position
   int last_pos_index=int(m_area_x_size-m_area_visible_x_size);
//--- Adjustment in case the range has been exceeded
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Move the scrollbar thumb
   m_scrollh.MovingThumb(index);
//--- Shift the text box
   ShiftData();
//--- Update the scrollbar
   m_scrollh.Update();
  }
//+------------------------------------------------------------------+
//| Vertical scrollbar of the text box                               |
//+------------------------------------------------------------------+
void CTextBox::VerticalScrolling(const int pos=WRONG_VALUE)
  {
//--- To determine the position of the thumb
   int index=0;
//--- Index of the last position
   int last_pos_index=int((m_area_y_size-m_area_visible_y_size)/(double)LineHeight());
//--- Adjustment in case the range has been exceeded
   if(pos<0)
      index=last_pos_index;
   else
      index=(pos>last_pos_index)? last_pos_index : pos;
//--- Move the scrollbar thumb
   m_scrollv.MovingThumb(index);
//--- Shift the text box
   ShiftData();
//--- Update the scrollbar
   m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Shifts the data relative to the scrollbars                       |
//+------------------------------------------------------------------+
void CTextBox::ShiftData(void)
  {
//--- Get the current positions of sliders of the vertical and horizontal scrollbars
   int h_offset =m_scrollh.CurrentPos()*m_shift_x_step;
   int v_offset =m_text_y_offset+(m_scrollv.CurrentPos()*(int)LineHeight())-2;
//--- Calculate the offsets for shifting
   int x_offset =(h_offset<1)? 0 : (h_offset>=m_shift_x2_limit)? m_shift_x2_limit : h_offset;
   int y_offset =(v_offset<1)? 0 : (v_offset>=m_shift_y2_limit)? m_shift_y2_limit : v_offset;
//--- Calculation of the data position relative to the scrollbar thumbs
   long x =(m_area_x_size>m_area_visible_x_size && !m_word_wrap_mode)? x_offset : 0;
   long y =(m_area_y_size>m_area_visible_y_size)? y_offset : 0;
//--- Shift the data
   m_textbox.SetInteger(OBJPROP_XOFFSET,x);
   m_textbox.SetInteger(OBJPROP_YOFFSET,y);
  }
//+------------------------------------------------------------------+
//| Adjust the text box size                                         |
//+------------------------------------------------------------------+
void CTextBox::CorrectSize(void)
  {
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize(true,true);
  }
//+------------------------------------------------------------------+
//| Activate the text box                                            |
//+------------------------------------------------------------------+
void CTextBox::ActivateTextBox(void)
  {
   OnClickTextBox(m_textbox.Name());
  }
//+------------------------------------------------------------------+
//| Resize                                                           |
//+------------------------------------------------------------------+
void CTextBox::ChangeSize(const uint x_size,const uint y_size)
  {
//--- Set the new size
   ChangeMainSize(x_size,y_size);
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize();
  }
//+------------------------------------------------------------------+
//| Moving the control                                               |
//+------------------------------------------------------------------+
void CTextBox::Moving(const bool only_visible=true)
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
      m_textbox.X(m_main.X2()-m_textbox.XGap());
     }
   else
     {
      CElementBase::X(m_main.X()+XGap());
      m_textbox.X(m_main.X()+m_textbox.XGap());
     }
//--- If the anchored to the bottom
   if(m_anchor_bottom_window_side)
     {
      CElementBase::Y(m_main.Y2()-YGap());
      m_textbox.Y(m_main.Y2()-m_textbox.YGap());
     }
   else
     {
      CElementBase::Y(m_main.Y()+YGap());
      m_textbox.Y(m_main.Y()+m_textbox.YGap());
     }
//--- Update coordinates
   m_textbox.X_Distance(m_textbox.X());
   m_textbox.Y_Distance(m_textbox.Y());
//--- Update the position of objects
   CElement::Moving(only_visible);
  }
//+------------------------------------------------------------------+
//| Shows the control                                                |
//+------------------------------------------------------------------+
void CTextBox::Show(void)
  {
//--- Leave, if this control is already visible
   if(CElementBase::IsVisible())
      return;
//--- Make all the objects visible
   m_canvas.Timeframes(OBJ_ALL_PERIODS);
   m_textbox.Timeframes(OBJ_ALL_PERIODS);
//--- Visible state
   CElementBase::IsVisible(true);
//--- Update the position of object
   Moving();
//--- Show the scrollbars
   if(m_scrollv.IsScroll())
      m_scrollv.Show();
   if(m_scrollh.IsScroll())
      m_scrollh.Show();
  }
//+------------------------------------------------------------------+
//| Hides the control                                                |
//+------------------------------------------------------------------+
void CTextBox::Hide(void)
  {
//--- Leave, if the control is hidden
   if(!CElementBase::IsVisible())
      return;
//--- Hide all objects
   m_canvas.Timeframes(OBJ_NO_PERIODS);
   m_textbox.Timeframes(OBJ_NO_PERIODS);
   m_scrollv.Hide();
   m_scrollh.Hide();
//--- Visible state
   CElementBase::IsVisible(false);
  }
//+------------------------------------------------------------------+
//| Deleting                                                         |
//+------------------------------------------------------------------+
void CTextBox::Delete(void)
  {
//--- Removing objects
   m_canvas.Destroy();
   m_textbox.Destroy();
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Emptying the control arrays
   for(uint i=0; i<lines_total; i++)
     {
      ::ArrayFree(m_lines[i].m_width);
      ::ArrayFree(m_lines[i].m_symbol);
     }
//---
   ::ArrayFree(m_lines);
//--- Initializing of variables by default values
   m_text_edit_state=false;
   CElementBase::IsVisible(true);
   CElementBase::MouseFocus(false);
  }
//+------------------------------------------------------------------+
//| Seth the priorities                                              |
//+------------------------------------------------------------------+
void CTextBox::SetZorders(void)
  {
   CElement::SetZorders();
   m_textbox.Z_Order(m_zorder+1);
  }
//+------------------------------------------------------------------+
//| Reset the priorities                                             |
//+------------------------------------------------------------------+
void CTextBox::ResetZorders(void)
  {
   CElement::ResetZorders();
   m_textbox.Z_Order(WRONG_VALUE);
  }
//+------------------------------------------------------------------+
//| Handling clicking the control                                    |
//+------------------------------------------------------------------+
bool CTextBox::OnClickTextBox(const string clicked_object)
  {
//--- Leave, if it has a different object name
   if(m_textbox.Name()!=clicked_object)
     {
      //--- Send a message about the end of the line editing mode in the text box, if the text box was active
      if(m_text_edit_state)
        {
         string str=(m_multi_line_mode)? TextCursorInfo() : "";
         ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),str);
        }
      //--- Deactivate the text box
      DeactivateTextBox();
      //--- Update
      Update(true);
      return(false);
     }
//--- Leave, if (1) the Read-only mode is enabled or if (2) the control is locked
   if(m_read_only_mode || CElementBase::IsLocked())
      return(true);
//--- Leave, if the scrollbar is active
   if(m_scrollv.State() || m_scrollh.State())
      return(true);
//--- If (1) the auto text selection mode is enabled and (2) the text box has just been activated
   if(m_auto_selection_mode && !m_text_edit_state)
      SelectAllText();
//--- Reset the selection
   else
      ResetSelectedText();
//--- Disable chart management
   m_chart.SetInteger(CHART_KEYBOARD_CONTROL,false);
//--- If (1) the auto text selection mode is enabled and (2) the text box is activated
   if(!m_auto_selection_mode || (m_auto_selection_mode && m_text_edit_state))
     {
      //--- Set the text cursor at the mouse cursor location
      SetTextCursorByMouseCursor();
     }
//--- If the multiline text box mode is enabled, adjust the vertical scrollbar
   if(m_multi_line_mode)
      CorrectingVerticalScrollThumb();
//--- Activate the text box
   m_text_edit_state=true;
//--- Update the text and the cursor
   DrawTextAndCursor(true);
//--- Change the border color
   DrawBorder();
   m_canvas.Update();
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_CLICK_TEXT_BOX,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling a keypress                                              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKey(const long key_code)
  {
//--- Get the key character
   string pressed_key=m_keys.KeySymbol(key_code);
//--- Leave, if there is no character
   if(pressed_key=="")
      return(false);
//--- If there is a selected text, delete it
   DeleteSelectedText();
//--- Add the character and its properties
   AddSymbol(pressed_key);
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize(true,true);
//--- Adjust the horizontal scrollbar
   CorrectingHorizontalScrollThumb();
//--- If the word wrap mode is enabled, adjust the vertical scrollbar
   if(m_word_wrap_mode)
      CorrectingVerticalScrollThumb();
//--- Update the text in the text box
   DrawTextAndCursor(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Backspace key                       |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyBackspace(const long key_code)
  {
//--- Leave, if it is not the Backspace key
   if(key_code!=KEY_BACKSPACE)
      return(false);
//--- If there is a selected text, delete it and leave
   if(DeleteSelectedText())
      return(true);
//--- Delete the character, if the position is greater than zero
   if(m_text_cursor_x_pos>0)
      DeleteSymbol();
//--- If it is the zero position and not the first line,
//    delete the line and shift the lines up by one position
   else if(m_text_cursor_y_pos>0)
      ShiftOnePositionUp();
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize(true,true);
//--- Adjust the scrollbars
   CorrectingHorizontalScrollThumb();
   CorrectingVerticalScrollThumb();
//--- Update the text in the text box
   DrawTextAndCursor(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Enter key                           |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyEnter(const long key_code)
  {
//--- Leave, if it is not the Enter key
   if(key_code!=KEY_ENTER)
      return(false);
//--- If there is a selected text, delete it
   DeleteSelectedText();
//--- If the multiline mode is disabled
   if(!m_multi_line_mode)
     {
      //--- Deactivate the text box
      DeactivateTextBox();
      //--- Update
      Update(true);
      //--- Send a message about it
      string str=(m_multi_line_mode)? TextCursorInfo() : "";
      ::EventChartCustom(m_chart_id,ON_END_EDIT,CElementBase::Id(),CElementBase::Index(),str);
      return(false);
     }
//--- Shift the lines down by one position
   ShiftOnePositionDown();
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize();
//--- Adjust the vertical scrollbar
   CorrectingVerticalScrollThumb();
//--- Move the cursor to the beginning of the line
   SetTextCursor(0,m_text_cursor_y_pos);
//--- Move the scrollbar to the beginning
   HorizontalScrolling(0);
//--- Update the text in the text box
   DrawTextAndCursor(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Left key                            |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyLeft(const long key_code)
  {
//--- Leave, if (1) it is not the Left key or (2) the Ctrl key is pressed or (3) the Shift key is pressed
   if(key_code!=KEY_LEFT || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor to the left by one character
   MoveTextCursor(TO_NEXT_LEFT_SYMBOL,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Right key                           |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyRight(const long key_code)
  {
//--- Leave, if (1) it is not the Right key or (2) the Ctrl key is pressed or (3) the Shift key is pressed
   if(key_code!=KEY_RIGHT || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor to the right by one character
   MoveTextCursor(TO_NEXT_RIGHT_SYMBOL,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Up key                              |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyUp(const long key_code)
  {
//--- Leave, if the multiline mode is disabled
   if(!m_multi_line_mode)
      return(false);
//--- Leave, if (1) it is not the Up key or (2) if the Shift key is pressed
   if(key_code!=KEY_UP || m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor up by one line
   MoveTextCursor(TO_NEXT_UP_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Down key                            |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyDown(const long key_code)
  {
//--- Leave, if the multiline mode is disabled
   if(!m_multi_line_mode)
      return(false);
//--- Leave, if (1) it is not the Down key or (2) if the Shift key is pressed
   if(key_code!=KEY_DOWN || m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor down by one line
   MoveTextCursor(TO_NEXT_DOWN_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Home key                            |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyHome(const long key_code)
  {
//--- Leave, if (1) it is not the Home key or (2) the Ctrl key is pressed or (3) the Shift key is pressed
   if(key_code!=KEY_HOME || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Move the cursor to the beginning of the current line
   MoveTextCursor(TO_BEGIN_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the End key                             |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyEnd(const long key_code)
  {
//--- Leave, if (1) it is not the End key or (2) the Ctrl key is pressed or (3) the Shift key is pressed
   if(key_code!=KEY_END || m_keys.KeyCtrlState() || m_keys.KeyShiftState())
      return(false);
//--- Move the cursor to the end of the current line
   MoveTextCursor(TO_END_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the simultaneous pressing of the Ctrl + Left keys       |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndLeft(const long key_code)
  {
//--- Leave, if (1) it is not the Left key and (2) the Ctrl key is not pressed or (3) the Shift key is pressed
   if(!(key_code==KEY_LEFT && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor to the left by one word
   MoveTextCursor(TO_NEXT_LEFT_WORD,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the simultaneous pressing of the Ctrl + Right keys      |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndRight(const long key_code)
  {
//--- Leave, if (1) it is not the Right key and (2) the Ctrl key is not pressed or (3) the Shift key is pressed
   if(!(key_code==KEY_RIGHT && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor to the right by one word
   MoveTextCursor(TO_NEXT_RIGHT_WORD,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the simultaneous pressing of the Ctrl + Home keys       |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndHome(const long key_code)
  {
//--- Leave, if (1) it is not the Home key and (2) the Ctrl key is not pressed or (3) the Shift key is pressed
   if(!(key_code==KEY_HOME && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Move the cursor to the beginning of the first line
   MoveTextCursor(TO_BEGIN_FIRST_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the simultaneous pressing of the Ctrl + End keys        |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlAndEnd(const long key_code)
  {
//--- Leave, if (1) it is not the End key and (2) the Ctrl key is not pressed or (3) the Shift key is pressed
   if(!(key_code==KEY_END && m_keys.KeyCtrlState()) || m_keys.KeyShiftState())
      return(false);
//--- Move the cursor to the end of the last line
   MoveTextCursor(TO_END_LAST_LINE,false);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Shift + Left keys                   |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndLeft(const long key_code)
  {
//--- Leave, if (1) it is not the Left key or (2) the Ctrl key is pressed or (3) the Shift key is not pressed
   if(key_code!=KEY_LEFT || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor to the left by one character
   MoveTextCursor(TO_NEXT_LEFT_SYMBOL,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Shift + Right keys                  |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndRight(const long key_code)
  {
//--- Leave, if (1) it is not the Right key or (2) the Ctrl key is pressed or (3) the Shift key is not pressed
   if(key_code!=KEY_RIGHT || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor to the right by one character
   MoveTextCursor(TO_NEXT_RIGHT_SYMBOL,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Shift + Up keys                     |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndUp(const long key_code)
  {
//--- Leave, if (1) it is not the Up key or (2) the Ctrl key is pressed or (3) the Shift key is not pressed
   if(key_code!=KEY_UP || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor up by one line
   MoveTextCursor(TO_NEXT_UP_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Shift + Down keys                   |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndDown(const long key_code)
  {
//--- Leave, if (1) it is not the Down key or (2) the Ctrl key is pressed or (3) the Shift key is not pressed
   if(key_code!=KEY_DOWN || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Shift the text cursor down by one line
   MoveTextCursor(TO_NEXT_DOWN_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Shift + Home keys                   |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndHome(const long key_code)
  {
//--- Leave, if (1) it is not the Home key or (2) the Ctrl key is pressed or (3) the Shift key is not pressed
   if(key_code!=KEY_HOME || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Move the cursor to the beginning of the current line
   MoveTextCursor(TO_BEGIN_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Shift + End keys                    |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyShiftAndEnd(const long key_code)
  {
//--- Leave, if (1) it is not the End key or (2) the Ctrl key is pressed or (3) the Shift key is not pressed
   if(key_code!=KEY_END || m_keys.KeyCtrlState() || !m_keys.KeyShiftState())
      return(false);
//--- Move the cursor to the end of the current line
   MoveTextCursor(TO_END_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Ctrl + Shift + Left keys            |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndLeft(const long key_code)
  {
//--- Leave, if (1) it is not the Left key and (2) the Ctrl key is not pressed and (3) the Shift key is pressed
   if(!(key_code==KEY_LEFT && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Shift the text cursor to the left by one word
   MoveTextCursor(TO_NEXT_LEFT_WORD,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Ctrl + Shift + Right keys           |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndRight(const long key_code)
  {
//--- Leave, if (1) it is not the Right key and (2) the Ctrl key is not pressed and (3) the Shift key is pressed
   if(!(key_code==KEY_RIGHT && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Shift the text cursor to the right by one word
   MoveTextCursor(TO_NEXT_RIGHT_WORD,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Ctrl + Shift + Home keys            |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndHome(const long key_code)
  {
//--- Leave, if (1) it is not the Home key and (2) the Ctrl key is not pressed and (3) the Shift key is pressed
   if(!(key_code==KEY_HOME && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Move the cursor to the beginning of the first line
   MoveTextCursor(TO_BEGIN_FIRST_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Handling the pressing of the Ctrl + Shift + End keys             |
//+------------------------------------------------------------------+
bool CTextBox::OnPressedKeyCtrlShiftAndEnd(const long key_code)
  {
//--- Leave, if (1) it is not the End key and (2) the Ctrl key is not pressed and (3) the Shift key is pressed
   if(!(key_code==KEY_END && m_keys.KeyCtrlState() && m_keys.KeyShiftState()))
      return(false);
//--- Move the cursor to the end of the last line
   MoveTextCursor(TO_END_LAST_LINE,true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Set the start indexes for selecting text                         |
//+------------------------------------------------------------------+
void CTextBox::SetStartSelectedTextIndexes(void)
  {
//--- If the starting indexes for selecting text have not been set yet
   if(m_selected_line_from==WRONG_VALUE)
     {
      m_selected_line_from   =(int)m_text_cursor_y_pos;
      m_selected_symbol_from =(int)m_text_cursor_x_pos;
     }
  }
//+------------------------------------------------------------------+
//| Set the end indexes for selecting text                           |
//+------------------------------------------------------------------+
void CTextBox::SetEndSelectedTextIndexes(void)
  {
//--- Set the end indexes for selecting text
   m_selected_line_to   =(int)m_text_cursor_y_pos;
   m_selected_symbol_to =(int)m_text_cursor_x_pos;
//--- If all indexes are the same, clear the selection
   if(m_selected_line_from==m_selected_line_to && m_selected_symbol_from==m_selected_symbol_to)
      ResetSelectedText();
  }
//+------------------------------------------------------------------+
//| Select all text                                                  |
//+------------------------------------------------------------------+
void CTextBox::SelectAllText(void)
  {
//--- Get the size of the array of characters
   int symbols_total=::ArraySize(m_lines[0].m_symbol);
//--- Set the indexes for selecting text
   m_selected_line_from   =0;
   m_selected_line_to     =0;
   m_selected_symbol_from =0;
   m_selected_symbol_to   =symbols_total;
//--- Move the thumb of the horizontal scrollbar to the last position
   HorizontalScrolling();
//--- Move the cursor to the end of the line
   SetTextCursor(symbols_total,0);
  }
//+------------------------------------------------------------------+
//| Reset the selected text                                          |
//+------------------------------------------------------------------+
void CTextBox::ResetSelectedText(void)
  {
   m_selected_line_from   =WRONG_VALUE;
   m_selected_line_to     =WRONG_VALUE;
   m_selected_symbol_from =WRONG_VALUE;
   m_selected_symbol_to   =WRONG_VALUE;
  }
//+------------------------------------------------------------------+
//| Deactivation of the text box                                     |
//+------------------------------------------------------------------+
void CTextBox::DeactivateTextBox(void)
  {
//--- Leave, if it is already deactivated
   if(!m_text_edit_state)
      return;
//--- Deactivate
   m_text_edit_state=false;
//--- Enable chart management
   m_chart.SetInteger(CHART_KEYBOARD_CONTROL,true);
//--- Reset the selection
   ResetSelectedText();
//--- If the multiline mode is disabled
   if(!m_multi_line_mode)
     {
      //--- Move the cursor to the beginning of the line
      SetTextCursor(0,0);
      //--- Move the scrollbar to the beginning of the line
      HorizontalScrolling(0);
     }
  }
//+------------------------------------------------------------------+
//| Fast forward of the scrollbar                                    |
//+------------------------------------------------------------------+
void CTextBox::FastSwitching(void)
  {
//--- Exit if there is no focus on the control
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
      //--- Shifts the text box
      ShiftData();
      //--- Update the scrollbars
      if(scroll_v) m_scrollv.Update(true);
      if(scroll_h) m_scrollh.Update(true);
     }
  }
//+------------------------------------------------------------------+
//| Draw text                                                        |
//+------------------------------------------------------------------+
void CTextBox::Draw(void)
  {
//--- Output the text
   CTextBox::TextOut();
//--- Draw the frame
   DrawBorder();
  }
//+------------------------------------------------------------------+
//| Updating the control                                             |
//+------------------------------------------------------------------+
void CTextBox::Update(const bool redraw=false)
  {
//--- Redraw the table, if specified
   if(redraw)
     {
      //--- Draw
      Draw();
      //--- Apply
      m_canvas.Update();
      m_textbox.Update();
      return;
     }
//--- Apply
   m_canvas.Update();
   m_textbox.Update();
  }
//+------------------------------------------------------------------+
//| Output text to canvas                                            |
//+------------------------------------------------------------------+
void CTextBox::TextOut(void)
  {
//--- Clear canvas
   m_textbox.Erase(AreaColorCurrent());
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Adjustment in case the range has been exceeded
   m_text_cursor_y_pos=(m_text_cursor_y_pos>=lines_total)? lines_total-1 : m_text_cursor_y_pos;
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- If multiline mode is enabled or if the number of characters is greater than zero
   if(m_multi_line_mode || symbols_total>0)
     {
      //--- Text color
      uint text_color=TextColorCurrent();
      //--- Get the line width
      int line_width=(int)LineWidth(m_text_cursor_x_pos,m_text_cursor_y_pos);
      //--- Get the line height and iterate over all lines in a loop
      int line_height=(int)LineHeight();
      for(uint i=0; i<lines_total; i++)
        {
         //--- Get the coordinates for the text
         int x=m_text_x_offset;
         int y=m_text_y_offset+((int)i*line_height);
         //--- Get the string size
         uint string_length=::ArraySize(m_lines[i].m_symbol);
         //--- Draw the text
         for(uint s=0; s<string_length; s++)
           {
            //--- If there is a selected text, determine its color and the background color of the current character
            if(CheckSelectedText(i,s))
              {
               //--- Color of the selected text
               text_color=::ColorToARGB(m_selected_text_color);
               //--- Calculate the coordinates for drawing the background
               int x2 =x+m_lines[i].m_width[s];
               int y2 =y+line_height-1;
               //--- Draw the background color of the character
               m_textbox.FillRectangle(x,y,x2,y2,::ColorToARGB(m_selected_back_color,m_alpha));
              }
            else
               text_color=TextColorCurrent();
            //--- Draw the character
            m_textbox.TextOut(x,y,m_lines[i].m_symbol[s],text_color,TA_LEFT);
            //--- X coordinate for the next character
            x+=m_lines[i].m_width[s];
           }
        }
     }
//--- If the multiline mode is disabled and there are no characters, the default text will be displayed (if specified)
   else
     {
      if(m_default_text!="")
         m_textbox.TextOut(m_area_x_size/2,m_area_y_size/2,m_default_text,::ColorToARGB(m_default_text_color),TA_CENTER|TA_VCENTER);
     }
  }
//+------------------------------------------------------------------+
//| Draws the frame of the Text box                                  |
//+------------------------------------------------------------------+
void CTextBox::DrawBorder(void)
  {
//--- Get the offset along the X axis
   int xo=(int)m_canvas.GetInteger(OBJPROP_XOFFSET);
   int yo=(int)m_canvas.GetInteger(OBJPROP_YOFFSET);
//--- Boundaries
   int x_size =m_canvas.X_Size()-1;
   int y_size =m_canvas.Y_Size()-1;
//--- Coordinates
   int x1=xo,y1=yo;
   int x2=xo+x_size;
   int y2=yo+y_size;
//--- Draw a rectangle without fill
   m_canvas.Rectangle(x1,y1,x2,y2,BorderColorCurrent());
  }
//+------------------------------------------------------------------+
//| Draws the text cursor                                            |
//+------------------------------------------------------------------+
void CTextBox::DrawCursor(void)
  {
//--- Get the line height
   int line_height=(int)LineHeight();
//--- Get the X coordinate of the cursor
   CalculateTextCursorX();
//--- Draw the text cursor
   for(int i=0; i<line_height; i++)
     {
      //--- Get the Y coordinate of the pixel
      int y=m_text_y_offset+((int)m_text_cursor_y_pos*line_height)+i;
      //--- Get the current color of the pixel
      uint pixel_color=m_textbox.PixelGet(m_text_cursor_x,y);
      //--- Invert color for the cursor
      pixel_color=::ColorToARGB(m_clr.Negative((color)pixel_color));
      m_textbox.PixelSet(m_text_cursor_x,y,::ColorToARGB(pixel_color));
     }
  }
//+------------------------------------------------------------------+
//| Displays the text and blinking cursor                            |
//+------------------------------------------------------------------+
void CTextBox::DrawTextAndCursor(const bool show_state=false)
  {
//--- Determine the state for the text cursor (show/hide)
   static bool state=false;
   state=(!show_state)? !state : show_state;
//--- Output the text
   CTextBox::TextOut();
//--- Draw the text cursor
   if(state)
      DrawCursor();
//--- Update the text box
   m_canvas.Update();
   m_textbox.Update();
   m_scrollh.Update(true);
   m_scrollv.Update(true);
//--- Reset the counter
   m_counter.ZeroTimeCounter();
  }
//+------------------------------------------------------------------+
//| Returns background color relative to current state of control    |
//+------------------------------------------------------------------+
uint CTextBox::AreaColorCurrent(void)
  {
   uint clr=(!CElementBase::IsLocked())? m_back_color : m_back_color_locked;
//--- Return the color
   return(::ColorToARGB(clr,m_alpha));
  }
//+------------------------------------------------------------------+
//| Returns text color relative to current state of control          |
//+------------------------------------------------------------------+
uint CTextBox::TextColorCurrent(void)
  {
   uint clr=(!CElementBase::IsLocked())? m_label_color : m_label_color_locked;
//--- Return the color
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Returns frame color relative to current state of control         |
//+------------------------------------------------------------------+
uint CTextBox::BorderColorCurrent(void)
  {
   uint clr=clrBlack;
//--- If the control is not locked
   if(!CElementBase::IsLocked())
     {
      //--- If the text box is activated
      if(m_text_edit_state)
         clr=m_border_color_pressed;
      //--- If not activated, check the control focus
      else
         clr=(CElementBase::MouseFocus())? m_border_color_hover : m_border_color;
     }
//--- If the control is locked
   else
      clr=m_border_color_locked;
//--- Return the color
   return(::ColorToARGB(clr));
  }
//+------------------------------------------------------------------+
//| Changing the object colors                                       |
//+------------------------------------------------------------------+
void CTextBox::ChangeObjectsColor(void)
  {
//--- Track the change of color only if the parent itself is available too 
   if(m_main.IsLocked() || !CElementBase::IsAvailable())
      return;
//--- If this is the moment of crossing the borders of the control
   if(CElementBase::CheckCrossingBorder())
     {
      //--- Change the color
      DrawBorder();
      m_canvas.Update();
     }
  }
//+------------------------------------------------------------------+
//| Builds a string from characters                                  |
//+------------------------------------------------------------------+
string CTextBox::CollectString(const uint line_index,const uint symbols_total=0)
  {
   m_temp_input_string="";
//--- Get the string size
   uint string_length=::ArraySize(m_lines[line_index].m_symbol);
//---
   for(uint i=0; i<string_length; i++)
     {
      if(symbols_total>0)
        {
         if(i==symbols_total)
            break;
        }
      //---
      ::StringAdd(m_temp_input_string,m_lines[line_index].m_symbol[i]);
     }
//--- Return the resulting string
   return(m_temp_input_string);
  }
//+------------------------------------------------------------------+
//| Adds character and its properties to the arrays of the structure |
//+------------------------------------------------------------------+
void CTextBox::AddSymbol(const string key_symbol)
  {
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Resize the arrays
   ArraysResize(m_text_cursor_y_pos,symbols_total+1);
//--- Shift all characters from the end of the array to the index of the added character
   MoveSymbols(m_text_cursor_y_pos,0,m_text_cursor_x_pos,false);
//--- Get the width of the character
   int width=m_textbox.TextWidth(key_symbol);
//--- Add the character to the vacated element
   m_lines[m_text_cursor_y_pos].m_symbol[m_text_cursor_x_pos] =key_symbol;
   m_lines[m_text_cursor_y_pos].m_width[m_text_cursor_x_pos]  =width;
//--- Increase the cursor position counter
   m_text_cursor_x_pos++;
  }
//+------------------------------------------------------------------+
//| Deletes a character                                              |
//+------------------------------------------------------------------+
void CTextBox::DeleteSymbol(void)
  {
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- If the array is empty
   if(symbols_total<1)
     {
      //--- Set the cursor to the zero position of the cursor line
      SetTextCursor(0,m_text_cursor_y_pos);
      return;
     }
//--- Get the position of the previous character
   int check_pos=(int)m_text_cursor_x_pos-1;
//--- Leave, if out of range
   if(check_pos<0)
      return;
//--- Shift all characters by one element to the right from the index of the deleted character
   MoveSymbols(m_text_cursor_y_pos,m_text_cursor_x_pos,check_pos);
//--- Decrease the cursor position counter
   m_text_cursor_x_pos--;
//--- Resize the arrays
   ArraysResize(m_text_cursor_y_pos,symbols_total-1);
  }
//+------------------------------------------------------------------+
//| Deletes the selected text                                        |
//+------------------------------------------------------------------+
bool CTextBox::DeleteSelectedText(void)
  {
//--- Leave, if no text is selected
   if(m_selected_line_from==WRONG_VALUE)
      return(false);
//--- If characters are deleted from one line
   if(m_selected_line_from==m_selected_line_to)
      DeleteTextOnOneLine();
//--- If characters are deleted from multiple lines
   else
      DeleteTextOnMultipleLines();
//--- Reset the selected text
   ResetSelectedText();
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize();
//--- Adjust the scrollbars
   CorrectingHorizontalScrollThumb();
   CorrectingVerticalScrollThumb();
//--- Update the text in the text box
   DrawTextAndCursor(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
   return(true);
  }
//+------------------------------------------------------------------+
//| Deletes text selected on one line                                |
//+------------------------------------------------------------------+
void CTextBox::DeleteTextOnOneLine(void)
  {
   int symbols_total     =::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
   int symbols_to_delete =::fabs(m_selected_symbol_from-m_selected_symbol_to);
//--- If the initial index of the character is on the right
   if(m_selected_symbol_to<m_selected_symbol_from)
     {
      //--- Shift the characters to the freed area in the current line
      MoveSymbols(m_text_cursor_y_pos,m_selected_symbol_from,m_selected_symbol_to);
     }
//--- If the initial index of the character is on the left
   else
     {
      //--- Shift the text cursor to the left by the number of characters to be deleted
      m_text_cursor_x_pos-=symbols_to_delete;
      //--- Shift the characters to the freed area in the current line
      MoveSymbols(m_text_cursor_y_pos,m_selected_symbol_to,m_selected_symbol_from);
     }
//--- Decrease the array size of the current line by the number of extracted characters
   ArraysResize(m_text_cursor_y_pos,symbols_total-symbols_to_delete);
  }
//+------------------------------------------------------------------+
//| Deletes text selected on multiple lines                          |
//+------------------------------------------------------------------+
void CTextBox::DeleteTextOnMultipleLines(void)
  {
//--- The total number of characters on the initial and final lines
   uint symbols_total_line_from =::ArraySize(m_lines[m_selected_line_from].m_symbol);
   uint symbols_total_line_to   =::ArraySize(m_lines[m_selected_line_to].m_symbol);
//--- The number of intermediate lines to be deleted
   uint lines_to_delete=::fabs(m_selected_line_from-m_selected_line_to);
//--- The number of characters to be deleted on the initial and final lines
   uint symbols_to_delete_in_line_from =::fabs(symbols_total_line_from-m_selected_symbol_from);
   uint symbols_to_delete_in_line_to   =::fabs(symbols_total_line_to-m_selected_symbol_to);
//--- If the initial line is below the final line
   if(m_selected_line_from>m_selected_line_to)
     {
      //--- Copy the characters to be moved into the array
      string array[];
      CopyWrapSymbols(m_selected_line_from,m_selected_symbol_from,symbols_to_delete_in_line_from,array);
      //--- Resize the receiver line
      uint new_size=m_selected_symbol_to+symbols_to_delete_in_line_from;
      ArraysResize(m_selected_line_to,new_size);
      //--- Add data to the arrays of the receiver line structure
      PasteWrapSymbols(m_selected_line_to,m_selected_symbol_to,array);
      //--- Get the size of the lines array
      uint lines_total=::ArraySize(m_lines);
      //--- Shift lines up by the number of lines to be deleted
      MoveLines(m_selected_line_to+1,lines_total-lines_to_delete,lines_to_delete,false);
      //--- Resize the lines array
      ::ArrayResize(m_lines,lines_total-lines_to_delete);
     }
//--- If the initial line is above the final line
   else
     {
      //--- Copy the characters to be moved into the array
      string array[];
      CopyWrapSymbols(m_selected_line_to,m_selected_symbol_to,symbols_to_delete_in_line_to,array);
      //--- Resize the receiver line
      uint new_size=m_selected_symbol_from+symbols_to_delete_in_line_to;
      ArraysResize(m_selected_line_from,new_size);
      //--- Add data to the arrays of the receiver line structure
      PasteWrapSymbols(m_selected_line_from,m_selected_symbol_from,array);
      //--- Get the size of the lines array
      uint lines_total=::ArraySize(m_lines);
      //--- Shift lines up by the number of lines to be deleted
      MoveLines(m_selected_line_from+1,lines_total-lines_to_delete,lines_to_delete,false);
      //--- Resize the lines array
      ::ArrayResize(m_lines,lines_total-lines_to_delete);
      //--- Move the cursor to the initial position in the selection
      SetTextCursor(m_selected_symbol_from,m_selected_line_from);
     }
  }
//+------------------------------------------------------------------+
//| Returns the line height                                          |
//+------------------------------------------------------------------+
uint CTextBox::LineHeight(void)
  {
//--- Set the font to be displayed on the canvas (required for getting the line height)
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Return the line height
   return(m_textbox.TextHeight("|"));
  }
//+------------------------------------------------------------------+
//| Returns line width from beginning to the specified position      |
//+------------------------------------------------------------------+
uint CTextBox::LineWidth(const uint symbol_index,const uint line_index)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Prevention of exceeding the range
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Get the size of the array of characters for the specified line
   uint symbols_total=::ArraySize(m_lines[l].m_symbol);
//--- Prevention of exceeding the range
   uint s=(symbol_index<symbols_total)? symbol_index : symbols_total;
//--- Sum the width of all characters
   uint width=0;
   for(uint i=0; i<s; i++)
      width+=m_lines[l].m_width[i];
//--- Return the line width
   return(width);
  }
//+------------------------------------------------------------------+
//| Returns the maximum line width                                   |
//+------------------------------------------------------------------+
uint CTextBox::MaxLineWidth(void)
  {
   uint max_line_width=0;
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
   for(uint i=0; i<lines_total; i++)
     {
      //--- Get the size of the array of characters
      uint symbols_total=::ArraySize(m_lines[i].m_symbol);
      //--- Get the line width
      uint line_width=LineWidth(symbols_total,i);
      //--- Store the maximum width
      if(line_width>max_line_width)
         max_line_width=line_width;
     }
//--- Return the maximum line width
   return(max_line_width);
  }
//+------------------------------------------------------------------+
//| Shifts the lines up by one position                              |
//+------------------------------------------------------------------+
void CTextBox::ShiftOnePositionUp(void)
  {
//--- If word wrapping is enabled
   if(m_word_wrap_mode)
     {
      //--- Index of the previous row
      uint prev_line_index=m_text_cursor_y_pos-1;
      //--- Get the size of the array of characters
      uint symbols_total=::ArraySize(m_lines[prev_line_index].m_symbol);
      //--- If the previous line has the end of line sign
      if(m_lines[prev_line_index].m_end_of_line)
        {
         //--- (1) Remove the end of line sign and (2) move the text cursor to the end of the line
         m_lines[prev_line_index].m_end_of_line=false;
         SetTextCursor(symbols_total,prev_line_index);
        }
      else
        {
         //--- (1) Move the text cursor to the end of the line (2) and remove the character
         SetTextCursor(symbols_total,prev_line_index);
         DeleteSymbol();
        }
      return;
     }
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- If there are characters in this line, store them in order to append to the previous line
   m_temp_input_string=(symbols_total>0)? CollectString(m_text_cursor_y_pos) : "";
//--- Shift the lines up starting from the next element by one position
   MoveLines(m_text_cursor_y_pos,lines_total-1,1,false);
//--- Resize the lines array
   ::ArrayResize(m_lines,lines_total-1);
//--- Decrease the lines counter
   m_text_cursor_y_pos--;
//--- Get the size of the array of characters
   symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- Move the cursor to the end
   m_text_cursor_x_pos=symbols_total;
//--- Get the X coordinate of the cursor
   CalculateTextCursorX();
//--- If there is a line that must be appended to the previous one
   if(m_temp_input_string!="")
      AddToString(m_text_cursor_y_pos,m_temp_input_string);
  }
//+------------------------------------------------------------------+
//| Shifts the lines down by one position                            |
//+------------------------------------------------------------------+
void CTextBox::ShiftOnePositionDown(void)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Increase the array by one element
   uint new_size=lines_total+1;
   ::ArrayResize(m_lines,new_size);
//--- Shift the lines down starting from the current position by one item (from the end of the array)
   MoveLines(lines_total,m_text_cursor_y_pos+1,1);
//--- Wrap the text to the new line
   WrapTextToNewLine(m_text_cursor_y_pos,m_text_cursor_x_pos,true);
  }
//+------------------------------------------------------------------+
//| Check for presence of selected text                              |
//+------------------------------------------------------------------+
bool CTextBox::CheckSelectedText(const uint line_index,const uint symbol_index)
  {
   bool is_selected_text=false;
//--- Leave, if there is no selected text
   if(m_selected_line_from==WRONG_VALUE)
      return(false);
//--- If the initial index is on the line below
   if(m_selected_line_from>m_selected_line_to)
     {
      //--- The final line and the character to the right of the final selected one
      if((int)line_index==m_selected_line_to && (int)symbol_index>=m_selected_symbol_to)
        { is_selected_text=true; }
      //--- The initial line and the character to the left of the initial selected one
      else if((int)line_index==m_selected_line_from && (int)symbol_index<m_selected_symbol_from)
        { is_selected_text=true; }
      //--- Intermediate line (all characters are selected)
      else if((int)line_index>m_selected_line_to && (int)line_index<m_selected_line_from)
        { is_selected_text=true; }
     }
//--- If the initial index is on the line above
   else if(m_selected_line_from<m_selected_line_to)
     {
      //--- The final line and the character to the left of the final selected one
      if((int)line_index==m_selected_line_to && (int)symbol_index<m_selected_symbol_to)
        { is_selected_text=true; }
      //--- The initial line and the character to the right of the initial selected one
      else if((int)line_index==m_selected_line_from && (int)symbol_index>=m_selected_symbol_from)
        { is_selected_text=true; }
      //--- Intermediate line (all characters are selected)
      else if((int)line_index<m_selected_line_to && (int)line_index>m_selected_line_from)
        { is_selected_text=true; }
     }
//--- If the initial and final indexes are on the same line
   else
     {
      //--- Find the checked line
      if((int)line_index>=m_selected_line_to && (int)line_index<=m_selected_line_from)
        {
         //--- If the cursor is shifted to the right and the character is within the selected range
         if(m_selected_symbol_from>m_selected_symbol_to)
           {
            if((int)symbol_index>=m_selected_symbol_to && (int)symbol_index<m_selected_symbol_from)
               is_selected_text=true;
           }
         //--- If the cursor is shifted to the left and the character is within the selected range
         else
           {
            if((int)symbol_index>=m_selected_symbol_from && (int)symbol_index<m_selected_symbol_to)
               is_selected_text=true;
           }
        }
     }
//--- Return the result
   return(is_selected_text);
  }
//+------------------------------------------------------------------+
//| Check for presence of the mandatory first line                   |
//+------------------------------------------------------------------+
uint CTextBox::CheckFirstLine(void)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- if there are no lines, set the size of the arrays of the structure
   if(lines_total<1)
      ::ArrayResize(m_lines,++lines_total);
//--- Return the number of lines
   return(lines_total);
  }
//+------------------------------------------------------------------+
//| Resizes the arrays of properties for the specified line          |
//+------------------------------------------------------------------+
void CTextBox::ArraysResize(const uint line_index,const uint new_size)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Prevention of exceeding the range
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Reserve size of the array
   int reserve_size=100;
//--- Set the size of the arrays of the structure
   ::ArrayResize(m_lines[line_index].m_symbol,new_size,reserve_size);
   ::ArrayResize(m_lines[line_index].m_width,new_size,reserve_size);
  }
//+------------------------------------------------------------------+
//| Makes a copy of specified (source) line to new location(dest.)   |
//+------------------------------------------------------------------+
void CTextBox::LineCopy(const uint destination,const uint source)
  {
   ::ArrayCopy(m_lines[destination].m_width,m_lines[source].m_width);
   ::ArrayCopy(m_lines[destination].m_symbol,m_lines[source].m_symbol);
   m_lines[destination].m_end_of_line=m_lines[source].m_end_of_line;
  }
//+------------------------------------------------------------------+
//| Clears the specified line                                        |
//+------------------------------------------------------------------+
void CTextBox::ClearLine(const uint line_index)
  {
   ::ArrayFree(m_lines[line_index].m_symbol);
   ::ArrayFree(m_lines[line_index].m_width);
  }
//+------------------------------------------------------------------+
//| Moving the text cursor in the specified direction                |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction)
  {
   switch(direction)
     {
      //--- Move the cursor one character to the left
      case TO_NEXT_LEFT_SYMBOL  : MoveTextCursorToLeft();        break;
      //--- Move the cursor one character to the right
      case TO_NEXT_RIGHT_SYMBOL : MoveTextCursorToRight();       break;
      //--- Move the cursor one word to the left
      case TO_NEXT_LEFT_WORD    : MoveTextCursorToLeft(true);    break;
      //--- Move the cursor one word to the right
      case TO_NEXT_RIGHT_WORD   : MoveTextCursorToRight(true);   break;
      //--- Move the cursor one line up
      case TO_NEXT_UP_LINE      : MoveTextCursorToUp();          break;
      //--- Move the cursor one line down
      case TO_NEXT_DOWN_LINE    : MoveTextCursorToDown();        break;
      //--- Move the cursor to the beginning of the current line
      case TO_BEGIN_LINE : SetTextCursor(0,m_text_cursor_y_pos); break;
      //--- Move the cursor to the end of the current line
      case TO_END_LINE :
        {
         //--- Get the number of characters in the current line
         uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
         //--- Move the cursor
         SetTextCursor(symbols_total,m_text_cursor_y_pos);
         break;
        }
      //--- Move the cursor to the beginning of the first line
      case TO_BEGIN_FIRST_LINE : SetTextCursor(0,0); break;
      //--- Move the cursor to the end of the last line
      case TO_END_LAST_LINE :
        {
         //--- Get the number of lines and characters in the last line
         uint lines_total   =::ArraySize(m_lines);
         uint symbols_total =::ArraySize(m_lines[lines_total-1].m_symbol);
         //--- Move the cursor
         SetTextCursor(symbols_total,lines_total-1);
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//| Moving the text cursor in the specified direction and            |
//| with a condition                                                 |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursor(const ENUM_MOVE_TEXT_CURSOR direction,const bool with_highlighted_text)
  {
//--- If it is only text cursor movement
   if(!with_highlighted_text)
     {
      //--- Reset the selection
      ResetSelectedText();
      //--- Move the cursor to the beginning of the first line
      MoveTextCursor(direction);
     }
//--- If text selection is enabled
   else
     {
      //--- Set the start indexes for selecting text
      SetStartSelectedTextIndexes();
      //--- Shift the text cursor by one character
      MoveTextCursor(direction);
      //--- Set the end indexes for selecting text
      SetEndSelectedTextIndexes();
     }
//--- Adjust the scrollbars
   CorrectingHorizontalScrollThumb();
   CorrectingVerticalScrollThumb();
//--- Update the text in the text box
   DrawTextAndCursor(true);
//--- Send a message about it
   ::EventChartCustom(m_chart_id,ON_MOVE_TEXT_CURSOR,CElementBase::Id(),CElementBase::Index(),TextCursorInfo());
  }
//+------------------------------------------------------------------+
//| Moving the text cursor to the left                               |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToLeft(const bool to_next_word=false)
  {
//--- If going to the next character
   if(!to_next_word)
     {
      //--- If the text cursor position is greater than zero
      if(m_text_cursor_x_pos>0)
        {
         //--- Shift it to the previous character
         m_text_cursor_x-=m_lines[m_text_cursor_y_pos].m_width[m_text_cursor_x_pos-1];
         //--- Decrease the characters counter
         m_text_cursor_x_pos--;
        }
      else
        {
         //--- If this is not the first line
         if(m_text_cursor_y_pos>0)
           {
            //--- Move to the end of the previous line
            m_text_cursor_y_pos--;
            CorrectingTextCursorXPos();
           }
        }
      return;
     }
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Get the number of characters in the current line
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- If the cursor is at the beginning of the current line, and this is not the first line,
//    move the cursor to the end of the previous line
   if(m_text_cursor_x_pos==0 && m_text_cursor_y_pos>0)
     {
      //--- Get the index of the previous line
      uint prev_line_index=m_text_cursor_y_pos-1;
      //--- Get the number of characters in the previous line
      symbols_total=::ArraySize(m_lines[prev_line_index].m_symbol);
      //--- Move the cursor to the end of the previous line
      SetTextCursor(symbols_total,prev_line_index);
     }
// --- If the cursor is at the beginning of the current line or the cursor is on the first line
   else
     {
      //--- Find the beginning of a continuous sequence of characters (from right to left)
      for(uint i=m_text_cursor_x_pos; i<=symbols_total; i--)
        {
         //--- Go to the next, if the cursor is at the end of the line
         if(i==symbols_total)
            continue;
         //--- If this is the first character of the line
         if(i==0)
           {
            //--- Set the cursor to the beginning of the line
            SetTextCursor(0,m_text_cursor_y_pos);
            break;
           }
         //--- If this is not the first character of the line
         else
           {
            //--- If found the beginning of a continuous sequence for the first time.
            //    The beginning is considered to be the space at the next index.
            if(i!=m_text_cursor_x_pos && 
               m_lines[m_text_cursor_y_pos].m_symbol[i]!=SPACE && 
               m_lines[m_text_cursor_y_pos].m_symbol[i-1]==SPACE)
              {
               //--- Set the cursor to the beginning of a new continuous sequence
               SetTextCursor(i,m_text_cursor_y_pos);
               break;
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Moving the text cursor to the right by one character             |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToRight(const bool to_next_word=false)
  {
//--- If going to the next character
   if(!to_next_word)
     {
      //--- Get the size of the array of characters
      uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_width);
      //--- If this is the end of the line
      if(m_text_cursor_x_pos<symbols_total)
        {
         //--- Shift the position of the text cursor to the next character
         m_text_cursor_x+=m_lines[m_text_cursor_y_pos].m_width[m_text_cursor_x_pos];
         //--- Increase the character counter
         m_text_cursor_x_pos++;
        }
      else
        {
         //--- Get the size of the lines array
         uint lines_total=::ArraySize(m_lines);
         //--- If this is not the last line
         if(m_text_cursor_y_pos<lines_total-1)
           {
            //--- Move the cursor to the beginning of the next line
            m_text_cursor_x=m_text_x_offset;
            SetTextCursor(0,++m_text_cursor_y_pos);
           }
        }
      return;
     }
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Get the number of characters in the current line
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_symbol);
//--- If the cursor is at the end of the line and this is not the last line, move the cursor to the beginning of the next line
   if(m_text_cursor_x_pos==symbols_total && m_text_cursor_y_pos<lines_total-1)
     {
      SetTextCursor(0,m_text_cursor_y_pos+1);
     }
//--- If the cursor is not at the end of the line or this is the last line
   else
     {
      //--- Find the beginning of a continuous sequence of characters (from left to right)
      for(uint i=m_text_cursor_x_pos; i<=symbols_total; i++)
        {
         //--- If this is the first character, go to the next
         if(i==0)
            continue;
         //--- If reached the end of the line, move the cursor to the end
         if(i>=symbols_total-1)
           {
            SetTextCursor(symbols_total,m_text_cursor_y_pos);
            break;
           }
         //--- If found the beginning of a continuous sequence for the first time.
         //    The beginning is considered to be the space at the previous index.
         if(i!=m_text_cursor_x_pos && 
            m_lines[m_text_cursor_y_pos].m_symbol[i]!=SPACE && 
            m_lines[m_text_cursor_y_pos].m_symbol[i-1]==SPACE)
           {
            //--- Set the cursor to the end of a new continuous sequence
            SetTextCursor(i,m_text_cursor_y_pos);
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Moving the text cursor up by one line                            |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToUp(void)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- If not exceeding the array range
   if(m_text_cursor_y_pos-1<lines_total)
     {
      //--- Move to the previous line
      m_text_cursor_y_pos--;
      //--- Adjusting the text cursor along the X axis
      CorrectingTextCursorXPos(m_text_cursor_x_pos);
     }
  }
//+------------------------------------------------------------------+
//| Moving the text cursor down by one line                          |
//+------------------------------------------------------------------+
void CTextBox::MoveTextCursorToDown(void)
  {
   uint lines_total=::ArraySize(m_lines);
//--- If not exceeding the array range
   if(m_text_cursor_y_pos+1<lines_total)
     {
      //--- Move to the next line
      m_text_cursor_y_pos++;
      //--- Adjusting the text cursor along the X axis
      CorrectingTextCursorXPos(m_text_cursor_x_pos);
     }
  }
//+------------------------------------------------------------------+
//| Set the cursor at the specified position                         |
//+------------------------------------------------------------------+
void CTextBox::SetTextCursor(const uint x_pos,const uint y_pos)
  {
   m_text_cursor_x_pos=x_pos;
   m_text_cursor_y_pos=(!m_multi_line_mode)? 0 : y_pos;
  }
//+------------------------------------------------------------------+
//| Set the cursor at the specified position of the mouse cursor     |
//+------------------------------------------------------------------+
void CTextBox::SetTextCursorByMouseCursor(void)
  {
//--- Determine the text edit box coordinates below the mouse cursor
   int x =m_mouse.RelativeX(m_textbox);
   int y =m_mouse.RelativeY(m_textbox);
//--- Get the line height
   int line_height=(int)LineHeight();
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Determine the clicked character
   for(uint l=0; l<lines_total; l++)
     {
      //--- Set the initial coordinates for checking the condition
      int x_offset=m_text_x_offset;
      int y_offset=m_text_y_offset+((int)l*line_height);
      //--- Checking the condition along the Y axis
      bool y_pos_check=(l<lines_total-1)?(y>=y_offset && y<y_offset+line_height) : y>=y_offset;
      //--- If the click was not on this line, go to the next
      if(!y_pos_check)
         continue;
      //--- Get the size of the array of characters
      uint symbols_total=::ArraySize(m_lines[l].m_width);
      //--- If this is an empty line, move the cursor to the specified position and leave the cycle
      if(symbols_total<1)
        {
         SetTextCursor(0,l);
         HorizontalScrolling(0);
         break;
        }
      //--- Find the character that was clicked
      for(uint s=0; s<symbols_total; s++)
        {
         //--- If the character is found, move the cursor to the specified position and leave the cycle
         if(x>=x_offset && x<x_offset+m_lines[l].m_width[s])
           {
            SetTextCursor(s,l);
            l=lines_total;
            break;
           }
         //--- Add the width of the current character for the next check
         x_offset+=m_lines[l].m_width[s];
         //--- If this is the last character, move the cursor to the end of the line and leave the cycle
         if(s==symbols_total-1 && x>x_offset)
           {
            SetTextCursor(s+1,l);
            l=lines_total;
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Adjusting the text cursor along the X axis                       |
//+------------------------------------------------------------------+
void CTextBox::CorrectingTextCursorXPos(const int x_pos=WRONG_VALUE)
  {
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[m_text_cursor_y_pos].m_width);
//--- Determine the cursor position
   uint text_cursor_x_pos=0;
//--- If the position is available
   if(x_pos!=WRONG_VALUE)
      text_cursor_x_pos=(x_pos>(int)symbols_total-1)? symbols_total : x_pos;
//--- If the position is not available, set the cursor to the end of the line
   else
      text_cursor_x_pos=symbols_total;
//--- Zero position, if the line contains no characters
   m_text_cursor_x_pos=(symbols_total<1)? 0 : text_cursor_x_pos;
//--- Get the X coordinate of the cursor
   CalculateTextCursorX();
  }
//+------------------------------------------------------------------+
//| Calculation of the X coordinate for the text cursor              |
//+------------------------------------------------------------------+
void CTextBox::CalculateTextCursorX(void)
  {
//--- Get the line width
   int line_width=(int)LineWidth(m_text_cursor_x_pos,m_text_cursor_y_pos);
//--- Calculate and store the X coordinate of the cursor
   m_text_cursor_x=m_text_x_offset+line_width;
  }
//+------------------------------------------------------------------+
//| Calculation of the Y coordinate for the text cursor              |
//+------------------------------------------------------------------+
void CTextBox::CalculateTextCursorY(void)
  {
//--- Get the line height
   int line_height=(int)LineHeight();
//--- Get the Y coordinate of the cursor
   m_text_cursor_y=m_text_y_offset+int(line_height*m_text_cursor_y_pos);
  }
//+------------------------------------------------------------------+
//| Calculation of the text box boundaries along the two axes        |
//+------------------------------------------------------------------+
void CTextBox::CalculateBoundaries(void)
  {
   CalculateXBoundaries();
   CalculateYBoundaries();
  }
//+------------------------------------------------------------------+
//| Calculation of the text box boundaries along the X axis          |
//+------------------------------------------------------------------+
void CTextBox::CalculateXBoundaries(void)
  {
//--- Get the X coordinate and offset along the X axis
   int x       =(int)m_textbox.GetInteger(OBJPROP_XDISTANCE);
   int xoffset =(int)m_textbox.GetInteger(OBJPROP_XOFFSET);
//--- Calculate the boundaries of the visible portion of the text box
   m_x_limit  =(x+xoffset)-x;
   m_x2_limit =(m_multi_line_mode)? (x+xoffset+m_x_size-m_scrollv.ScrollWidth()-m_text_x_offset)-x : (x+xoffset+m_x_size-m_text_x_offset)-x;
  }
//+------------------------------------------------------------------+
//| Calculation of the text box boundaries along the Y axis          |
//+------------------------------------------------------------------+
void CTextBox::CalculateYBoundaries(void)
  {
//--- Leave, if the multiline mode is disabled
   if(!m_multi_line_mode)
      return;
//--- Get the Y coordinate and offset along the Y axis
   int y       =(int)m_textbox.GetInteger(OBJPROP_YDISTANCE);
   int yoffset =(int)m_textbox.GetInteger(OBJPROP_YOFFSET);
//--- Calculate the boundaries of the visible portion of the text box
   m_y_limit  =(y+yoffset)-y;
   m_y2_limit =(y+yoffset+m_y_size-m_scrollh.ScrollWidth())-y;
  }
//+------------------------------------------------------------------+
//| Calculate X coordinate of scrollbar on left edge of the text box |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbX(void)
  {
   return(m_text_cursor_x-m_text_x_offset);
  }
//+------------------------------------------------------------------+
//| Calculate X coordinate of scrollbar on right edge of the text box|
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbX2(void)
  {
   return((m_multi_line_mode)? m_text_cursor_x-m_x_size+m_scrollv.ScrollWidth()+m_text_x_offset : m_text_cursor_x-m_x_size+m_text_x_offset*2);
  }
//+------------------------------------------------------------------+
//| Calculation of the X position of the scrollbar                   |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollPosX(const bool to_right=false)
  {
   int    calc_x      =(!to_right)? CalculateScrollThumbX() : CalculateScrollThumbX2();
   double pos_x_value =(calc_x-::fmod((double)calc_x,(double)m_shift_x_step))/m_shift_x_step+((!to_right)? 0 : 1);
//---
   return((int)pos_x_value);
  }
//+------------------------------------------------------------------+
//| Calculate Y coordinate of scrollbar on top edge of the text box  |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbY(void)
  {
   return(m_text_cursor_y-m_text_y_offset);
  }
//+------------------------------------------------------------------+
//| Calculate Y coordinate of scrollbar on bottom edge of text box   |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollThumbY2(void)
  {
//--- Set the font to be displayed on the canvas (required for getting the line height)
   m_textbox.FontSet(CElement::Font(),-CElement::FontSize()*10,FW_NORMAL);
//--- Get the line height
   int line_height=m_textbox.TextHeight("|");
//--- Calculate and return the value
   return(m_text_cursor_y-m_y_size+m_scrollh.ScrollWidth()+m_text_y_offset+line_height);
  }
//+------------------------------------------------------------------+
//| Calculate the Y position of the scrollbar                        |
//+------------------------------------------------------------------+
int CTextBox::CalculateScrollPosY(const bool to_down=false)
  {
   int    calc_y      =(!to_down)? CalculateScrollThumbY() : CalculateScrollThumbY2();
   double pos_y_value =(calc_y-::fmod((double)calc_y,(double)LineHeight()))/LineHeight()+((!to_down)? 0 : 1);
//---
   return((int)pos_y_value);
  }
//+------------------------------------------------------------------+
//| Adjusting the horizontal scrollbar                               |
//+------------------------------------------------------------------+
void CTextBox::CorrectingHorizontalScrollThumb(void)
  {
//--- Get the boundaries of the visible portion of the text box
   CalculateXBoundaries();
//--- Get the X coordinate of the cursor
   CalculateTextCursorX();
//--- If the text cursor leaves the visible part to the left
   if(m_text_cursor_x<=m_x_limit)
     {
      HorizontalScrolling(CalculateScrollPosX());
     }
//--- If the text cursor leaves the visible part to the right
   else if(m_text_cursor_x>=m_x2_limit)
     {
      HorizontalScrolling(CalculateScrollPosX(true));
     }
  }
//+------------------------------------------------------------------+
//| Adjusting the vertical scrollbar                                 |
//+------------------------------------------------------------------+
void CTextBox::CorrectingVerticalScrollThumb(void)
  {
//--- Get the boundaries of the visible portion of the text box
   CalculateYBoundaries();
//--- Get the Y coordinate of the cursor
   CalculateTextCursorY();
//--- If the text cursor leaves the visible part upwards
   if(m_text_cursor_y<=m_y_limit)
     {
      VerticalScrolling(CalculateScrollPosY());
     }
//--- If the text cursor leaves the visible part downwards
   else if(m_text_cursor_y+(int)LineHeight()>=m_y2_limit)
     {
      VerticalScrolling(CalculateScrollPosY(true));
     }
  }
//+------------------------------------------------------------------+
//| Calculates the size of the text box                              |
//+------------------------------------------------------------------+
void CTextBox::CalculateTextBoxSize(void)
  {
   CalculateTextBoxXSize();
   CalculateTextBoxYSize();
  }
//+------------------------------------------------------------------+
//| Calculates the width of the text box                             |
//+------------------------------------------------------------------+
bool CTextBox::CalculateTextBoxXSize(void)
  {
//--- Store the current size
   int area_x_size_curr=m_area_x_size;
//--- Get the maximum line width from the text box
   int max_line_width=int((m_text_x_offset*2)+MaxLineWidth()+m_scrollv.ScrollWidth());
//--- Determine the total width
   m_area_x_size=(max_line_width>m_x_size)? max_line_width : m_x_size;
//--- Determine the visible width
   m_area_visible_x_size=m_x_size-2;
//--- Store the shifting limitation
   m_shift_x2_limit=m_area_x_size-m_area_visible_x_size;
//--- Sign that the sizes did not change
   if(area_x_size_curr==m_area_x_size)
      return(false);
//--- Sign that the sizes changed
   return(true);
  }
//+------------------------------------------------------------------+
//| Calculate the height of the text box                             |
//+------------------------------------------------------------------+
bool CTextBox::CalculateTextBoxYSize(void)
  {
//--- Store the current size
   int area_y_size_curr=m_area_y_size;
//--- Get the line height
   int line_height=(int)LineHeight();
//--- Get the size of the lines array
   int lines_total=::ArraySize(m_lines);
//--- Calculate the total height of the control
   int lines_height=int((m_text_y_offset*2)+(line_height*lines_total)+m_scrollh.ScrollWidth());//*2);
//--- Determine the total height
   m_area_y_size=(m_multi_line_mode && lines_height>m_y_size)? lines_height : m_y_size;
//--- Determine the visible height
   m_area_visible_y_size=m_y_size-2;
//--- Store the shifting limitation
   m_shift_y2_limit=m_area_y_size-m_area_visible_y_size;
//--- Sign that the sizes did not change
   if(area_y_size_curr==m_area_y_size)
      return(false);
//--- Sign that the sizes changed
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the main size of the control                              |
//+------------------------------------------------------------------+
void CTextBox::ChangeMainSize(const int x_size,const int y_size)
  {
//--- Set the new size
   CElementBase::XSize(x_size);
   CElementBase::YSize(y_size);
   m_canvas.XSize(m_x_size);
   m_canvas.YSize(m_y_size);
   m_canvas.Resize(m_x_size,m_y_size);
  }
//+------------------------------------------------------------------+
//| Resize the text box                                              |
//+------------------------------------------------------------------+
void CTextBox::ChangeTextBoxSize(const bool is_x_offset=false,const bool is_y_offset=false)
  {
//--- Resize the table
   m_textbox.XSize(m_area_x_size);
   m_textbox.YSize(m_area_y_size);
   m_textbox.Resize(m_area_x_size,m_area_y_size);
//--- Set the size of the visible area
   m_textbox.SetInteger(OBJPROP_XSIZE,m_area_visible_x_size);
   m_textbox.SetInteger(OBJPROP_YSIZE,m_area_visible_y_size);
//--- Difference between the total width and visible area
   int x_different =m_area_x_size-m_area_visible_x_size;
   int y_different =m_area_y_size-m_area_visible_y_size;
//--- Set the frame offset within the image along the X and Y axes
   int x_offset=(int)m_textbox.GetInteger(OBJPROP_XOFFSET);
   int y_offset=(int)m_textbox.GetInteger(OBJPROP_YOFFSET);
   m_textbox.SetInteger(OBJPROP_XOFFSET,(!is_x_offset)? 0 : (x_offset<=x_different)? x_offset : x_different);
   m_textbox.SetInteger(OBJPROP_YOFFSET,(!is_y_offset)? 0 : (y_offset<=y_different)? y_offset : y_different);
//--- Resize the scrollbars
   ChangeScrollsSize();
//--- Word wrapping
   WordWrap();
//--- Adjust the data
   ShiftData();
  }
//+------------------------------------------------------------------+
//| Resize the scrollbars                                            |
//+------------------------------------------------------------------+
void CTextBox::ChangeScrollsSize(void)
  {
//--- Calculate the number of steps for offset
   uint x_size_total         =m_area_x_size/m_shift_x_step;
   uint visible_x_size_total =m_area_visible_x_size/m_shift_x_step;
   uint y_size_total         =LinesTotal()+1;
   uint visible_y_size_total =VisibleLinesTotal();
//--- Calculate the sizes of the scrollbars
   m_scrollh.Reinit(x_size_total,visible_x_size_total);
   m_scrollv.Reinit(y_size_total,visible_y_size_total);
//--- Leave, if this is a single-line text box
   if(!m_multi_line_mode)
      return;
//--- If (1) the horizontal scrollbar is not required or (2) word wrapping is enabled
   if(!m_scrollh.IsScroll() || m_word_wrap_mode)
     {
      HorizontalScrolling(0);
      //--- Hide the horizontal scrollbar
      m_scrollh.Hide();
      //--- Change the height of the vertical scrollbar
      if(m_multi_line_mode)
         m_scrollv.ChangeYSize(CElementBase::YSize()-2);
     }
   else
     {
      //--- Show the horizontal scrollbar
      if(CElementBase::IsVisible())
        {
         m_scrollh.Show();
         m_scrollh.GetIncButtonPointer().Show();
         m_scrollh.GetDecButtonPointer().Show();
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      //--- Calculate and change the height of the vertical scrollbar
      if(m_multi_line_mode)
         m_scrollv.ChangeYSize(CElementBase::YSize()-m_scrollh.ScrollWidth()-2);
     }
//--- If the vertical scrollbar is not required
   if(!m_scrollv.IsScroll())
     {
      VerticalScrolling(0);
      //--- Hide the vertical scrollbar
      m_scrollv.Hide();
      //--- Change the width of the horizontal scrollbar, if the word wrap is disabled
      if(!m_word_wrap_mode)
         m_scrollh.ChangeXSize(CElementBase::XSize()-1);
     }
   else
     {
      //--- Show the vertical scrollbar
      if(CElementBase::IsVisible())
        {
         m_scrollv.Show();
         m_scrollv.GetIncButtonPointer().Show();
         m_scrollv.GetDecButtonPointer().Show();
         //--- Send a message about the change in the graphical interface
         ::EventChartCustom(m_chart_id,ON_CHANGE_GUI,CElementBase::Id(),0,"");
        }
      //--- Change the width of the horizontal scrollbar, if the word wrap is disabled
      if(!m_word_wrap_mode)
         m_scrollh.ChangeXSize(CElementBase::XSize()-m_scrollh.ScrollWidth()-1);
     }
  }
//+------------------------------------------------------------------+
//| Word wrapping                                                    |
//+------------------------------------------------------------------+
void CTextBox::WordWrap(void)
  {
//--- Leave, if the (1) multiline text box and (2) word wrapping modes are disabled
   if(!m_multi_line_mode || !m_word_wrap_mode)
      return;
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Check if it is necessary to adjust the text to the text box width
   for(uint i=0; i<lines_total; i++)
     {
      //--- To determine the first visible (1) character and (2) space
      int symbol_index =WRONG_VALUE;
      int space_index  =WRONG_VALUE;
      //--- Index of the next row
      uint next_line_index=i+1;
      //--- If the line does not fit, then wrap a part of the current line to the new line
      if(CheckForOverflow(i,symbol_index,space_index))
        {
         //--- If a space character is found, it will not be wrapped
         if(space_index!=WRONG_VALUE)
            space_index++;
         //--- Increase the lines array by one element
         ::ArrayResize(m_lines,++lines_total);
         //--- Shift the lines down starting from the current position by one item
         MoveLines(lines_total-1,next_line_index,1);
         //--- Check the index of the character, from which the text will be moved
         int check_index=(space_index==WRONG_VALUE && symbol_index!=WRONG_VALUE)? symbol_index : space_index;
         //--- Wrap the text to the new line
         WrapTextToNewLine(i,check_index);
        }
      //--- If the line fits, then check if a reverse word wrapping should be done
      else
        {
         //--- Skip, if (1) this line has the end of line sign or (2) this is the last line
         if(m_lines[i].m_end_of_line || next_line_index>=lines_total)
            continue;
         //--- Determine the number of characters to be wrapped
         uint wrap_symbols_total=0;
         //--- If it is necessary to wrap the remaining text of the next line to the current line
         if(WrapSymbolsTotal(i,wrap_symbols_total))
           {
            WrapTextToPrevLine(next_line_index,wrap_symbols_total,true);
            //--- Update the array size for further use in the cycle
            lines_total=::ArraySize(m_lines);
            //--- Step back in order to avoid skipping a line for the next check
            i--;
           }
         //--- Wrap only what fits
         else
            WrapTextToPrevLine(next_line_index,wrap_symbols_total);
        }
     }
  }
//+------------------------------------------------------------------+
//| Checking for line overflow                                       |
//+------------------------------------------------------------------+
bool CTextBox::CheckForOverflow(const uint line_index,int &symbol_index,int &space_index)
  {
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Indents
   uint x_offset_plus=m_text_x_offset+m_scrollv.XSize();
//--- Get the full width of the line
   uint full_line_width=LineWidth(symbols_total,line_index)+x_offset_plus;
//--- If the width of the line fits the text box
   if(full_line_width<(uint)m_area_visible_x_size)
      return(false);
//--- Determine the indexes of the overflowing characters
   for(uint s=symbols_total-1; s>0; s--)
     {
      //--- Get the (1) width of the substring from the beginning to the current character and (2) the character
      uint   line_width =LineWidth(s,line_index)+x_offset_plus;
      string symbol     =m_lines[line_index].m_symbol[s];
      //--- If a visible character has not been found yet
      if(symbol_index==WRONG_VALUE)
        {
         //--- If the substring width fits the text box area, store the character index
         if(line_width<(uint)m_area_visible_x_size)
            symbol_index=(int)s;
         //--- Go to the next character
         continue;
        }
      //--- If this is a space, store its index and stop the cycle
      if(symbol==SPACE)
        {
         space_index=(int)s;
         break;
        }
     }
//--- If this condition is met, then it indicates that the line does not fit
   bool is_overflow=(symbol_index!=WRONG_VALUE || space_index!=WRONG_VALUE);
//--- Return the result
   return(is_overflow);
  }
//+------------------------------------------------------------------+
//| Returns the number of words in the specified line                |
//+------------------------------------------------------------------+
uint CTextBox::WordsTotal(const uint line_index)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Prevention of exceeding the range
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Get the size of the array of characters for the specified line
   uint symbols_total=::ArraySize(m_lines[l].m_symbol);
//--- Word counter
   uint words_counter=0;
//--- Search for a space at the specified index
   for(uint s=1; s<symbols_total; s++)
     {
      //--- Count, if (2) reached the end of line or (2) found a space (end of word)
      if(s+1==symbols_total || (m_lines[l].m_symbol[s]!=SPACE && m_lines[l].m_symbol[s-1]==SPACE))
         words_counter++;
     }
//--- Return the number of words
   return((words_counter<1)? 1 : words_counter);
  }
//+------------------------------------------------------------------+
//| Returns the number of wrapped characters with the volume signs   |
//+------------------------------------------------------------------+
bool CTextBox::WrapSymbolsTotal(const uint line_index,uint &wrap_symbols_total)
  {
//--- Signs of (1) the number of characters to be wrapped and (2) line without spaces
   bool is_all_text=false,is_solid_row=false;
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Indents
   uint x_offset_plus=m_text_x_offset+m_scrollv.XSize();
//--- Get the full width of the line
   uint full_line_width=LineWidth(symbols_total,line_index)+x_offset_plus;
//--- Get the width of the free space
   uint free_space=m_area_visible_x_size-full_line_width;
//--- Get the number of words in the next line
   uint next_line_index =line_index+1;
   uint words_total     =WordsTotal(next_line_index);
//--- Get the size of the array of characters
   uint next_line_symbols_total=::ArraySize(m_lines[next_line_index].m_symbol);
//--- Determine the number of words to be moved from the next line (search by spaces)
   for(uint w=0; w<words_total; w++)
     {
      //--- Get the (1) space index and (2) width if the substring from the beginning till the space
      uint ss_index        =SymbolIndexBySpaceNumber(next_line_index,w);
      uint substring_width =LineWidth(ss_index,next_line_index);
      //--- If the substring fits the free space of the current line
      if(substring_width<free_space)
        {
         //--- ...check if another word can be inserted
         wrap_symbols_total=ss_index;
         //--- Stop if is the whole line
         if(next_line_symbols_total==wrap_symbols_total)
           {
            is_all_text=true;
            break;
           }
        }
      else
        {
         //--- If this is a continuous line without spaces
         if(ss_index==next_line_symbols_total)
            is_solid_row=true;
         //---
         break;
        }
     }
//--- Return the result immediately, if (1) this is a line with a space character or (2) there is no free space
   if(!is_solid_row || free_space<1)
      return(is_all_text);
//--- Get the full width of the next line
   full_line_width=LineWidth(next_line_symbols_total,next_line_index)+x_offset_plus;
//--- If (1) the line does not fit and there are no spaces at the end of the (2) current and (3) previous lines
   if(full_line_width>free_space && 
      m_lines[line_index].m_symbol[symbols_total-1]!=SPACE && 
      m_lines[next_line_index].m_symbol[next_line_symbols_total-1]!=SPACE)
     {
      //--- Determine the number of characters to be moved from the next line
      for(uint s=next_line_symbols_total-1; s>=0; s--)
        {
         //--- Get the width of the substring from the beginning till the specified character
         uint substring_width=LineWidth(s,next_line_index);
         //--- If the substring does not fit the free space of the specified container, go to the next character
         if(substring_width>=free_space)
            continue;
         //--- If the substring fits, store the value and stop
         wrap_symbols_total=s;
         break;
        }
     }
//--- Return true, if it is necessary to move the entire text
   return(is_all_text);
  }
//+------------------------------------------------------------------+
//| Returns the space character index by its number                  |
//+------------------------------------------------------------------+
uint CTextBox::SymbolIndexBySpaceNumber(const uint line_index,const uint space_index)
  {
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Prevention of exceeding the range
   uint l=(line_index<lines_total)? line_index : lines_total-1;
//--- Get the size of the array of characters for the specified line
   uint symbols_total=::ArraySize(m_lines[l].m_symbol);
//--- (1) For determining the space character index and (2) counter of spaces
   uint symbol_index  =0;
   uint space_counter =0;
//--- Search for a space at the specified index
   for(uint s=1; s<symbols_total; s++)
     {
      //--- If found a space
      if(m_lines[l].m_symbol[s]!=SPACE && m_lines[l].m_symbol[s-1]==SPACE)
        {
         //--- If the counter is equal to the specified space index, store it and stop the cycle
         if(space_counter==space_index)
           {
            symbol_index=s;
            break;
           }
         //--- Increase the counter of spaces
         space_counter++;
        }
     }
//--- Return the line size if space index was not found
   return((symbol_index<1)? symbols_total : symbol_index);
  }
//+------------------------------------------------------------------+
//| Moving the lines by the specified number of positions            |
//+------------------------------------------------------------------+
void CTextBox::MoveLines(const uint from_index,const uint to_index,const uint count,const bool to_down=true)
  {
//--- Shifting lines downwards
   if(to_down)
     {
      for(uint i=from_index; i>to_index; i--)
        {
         //--- Index of the previous element of the lines array
         uint prev_index=i-count;
         //--- Get the size of the array of characters
         uint symbols_total=::ArraySize(m_lines[prev_index].m_symbol);
         //--- Resize the arrays
         ArraysResize(i,symbols_total);
         //--- make a copy of the line
         LineCopy(i,prev_index);
         //--- If this is the last iteration
         if(prev_index==to_index)
           {
            //--- Leave, if this is the first line
            if(to_index<1)
               break;
           }
        }
     }
//--- Shifting lines upwards
   else
     {
      for(uint i=from_index; i<to_index; i++)
        {
         //--- Index of the next element of the lines array
         uint next_index=i+count;
         //--- Get the size of the array of characters
         uint symbols_total=::ArraySize(m_lines[next_index].m_symbol);
         //--- Resize the arrays
         ArraysResize(i,symbols_total);
         //--- make a copy of the line
         LineCopy(i,next_index);
        }
     }
  }
//+------------------------------------------------------------------+
//| Moving characters in the specified line                          |
//+------------------------------------------------------------------+
void CTextBox::MoveSymbols(const uint line_index,const uint from_pos,const uint to_pos,const bool to_left=true)
  {
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Difference
   uint offset=from_pos-to_pos;
//--- If the characters are to be moved to the left
   if(to_left)
     {
      for(uint s=to_pos; s<symbols_total-offset; s++)
        {
         uint i=s+offset;
         m_lines[line_index].m_symbol[s] =m_lines[line_index].m_symbol[i];
         m_lines[line_index].m_width[s]  =m_lines[line_index].m_width[i];
        }
     }
//--- If the characters are to be moved to the right
   else
     {
      for(uint s=symbols_total-1; s>to_pos; s--)
        {
         uint i=s-1;
         m_lines[line_index].m_symbol[s] =m_lines[line_index].m_symbol[i];
         m_lines[line_index].m_width[s]  =m_lines[line_index].m_width[i];
        }
     }
  }
//+------------------------------------------------------------------+
//| Adds text to the specified line                                  |
//+------------------------------------------------------------------+
void CTextBox::AddToString(const uint line_index,const string text)
  {
//--- Transfer the line to array
   uchar array[];
   int total=::StringToCharArray(text,array)-1;
//--- Get the size of the array of characters
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- Resize the arrays
   uint new_size=symbols_total+total;
   ArraysResize(line_index,new_size);
//--- Add the data to the arrays of the structure
   for(uint i=symbols_total; i<new_size; i++)
     {
      m_lines[line_index].m_symbol[i] =::CharToString(array[i-symbols_total]);
      m_lines[line_index].m_width[i]  =m_textbox.TextWidth(m_lines[line_index].m_symbol[i]);
     }
  }
//+------------------------------------------------------------------+
//| Copies the characters to the passed array for moving             |
//+------------------------------------------------------------------+
void CTextBox::CopyWrapSymbols(const uint line_index,const uint start_pos,const uint symbols_total,string &array[])
  {
//--- Set the array size
   ::ArrayResize(array,symbols_total);
//--- Copy the characters to be moved into the array
   for(uint i=0; i<symbols_total; i++)
      array[i]=m_lines[line_index].m_symbol[start_pos+i];
  }
//+------------------------------------------------------------------+
//| Pastes the characters to the specified line                      |
//+------------------------------------------------------------------+
void CTextBox::PasteWrapSymbols(const uint line_index,const uint start_pos,string &array[])
  {
   uint array_size=::ArraySize(array);
//--- Add the data to the arrays of the structure for the new line
   for(uint i=0; i<array_size; i++)
     {
      uint s=start_pos+i;
      m_lines[line_index].m_symbol[s] =array[i];
      m_lines[line_index].m_width[s]  =m_textbox.TextWidth(array[i]);
     }
  }
//+------------------------------------------------------------------+
//| Wrapping the text to a new line                                  |
//+------------------------------------------------------------------+
void CTextBox::WrapTextToNewLine(const uint line_index,const uint symbol_index,const bool by_pressed_enter=false)
  {
//--- Get the size of the array of characters in the line
   uint symbols_total=::ArraySize(m_lines[line_index].m_symbol);
//--- The last character index
   uint last_symbol_index=symbols_total-1;
//--- Adjustment in case of an empty line
   uint check_symbol_index=(symbol_index>last_symbol_index && symbol_index!=symbols_total)? last_symbol_index : symbol_index;
//--- Index of the next row
   uint next_line_index=line_index+1;
//--- The number of characters to be moved to the new line
   uint new_line_size=symbols_total-check_symbol_index;
//--- Copy the characters to be moved into the array
   string array[];
   CopyWrapSymbols(line_index,check_symbol_index,new_line_size,array);
//--- Resize the arrays of the structure for the line
   ArraysResize(line_index,symbols_total-new_line_size);
//--- Resize the arrays of the structure for the new line
   ArraysResize(next_line_index,new_line_size);
//--- Add the data to the arrays of the structure for the new line
   PasteWrapSymbols(next_line_index,0,array);
//--- Determine the new location of the text cursor
   int x_pos=int(new_line_size-(symbols_total-m_text_cursor_x_pos));
   m_text_cursor_x_pos =(x_pos<0)? (int)m_text_cursor_x_pos : x_pos;
   m_text_cursor_y_pos =(x_pos<0)? (int)line_index : (int)next_line_index;
//--- If indicated that the call was initiated by pressing Enter
   if(by_pressed_enter)
     {
      //--- If the line had an end sign, then set the end sign to the current and to the next lines
      if(m_lines[line_index].m_end_of_line)
        {
         m_lines[line_index].m_end_of_line      =true;
         m_lines[next_line_index].m_end_of_line =true;
        }
      //--- If not, then only to the current
      else
        {
         m_lines[line_index].m_end_of_line      =true;
         m_lines[next_line_index].m_end_of_line =false;
        }
     }
   else
     {
      //--- If the line had an end sign, then continue and set the sign to the next line
      if(m_lines[line_index].m_end_of_line)
        {
         m_lines[line_index].m_end_of_line      =false;
         m_lines[next_line_index].m_end_of_line =true;
        }
      //--- If the line did not have the end sign, then continue in both lines
      else
        {
         m_lines[line_index].m_end_of_line      =false;
         m_lines[next_line_index].m_end_of_line =false;
        }
     }
  }
//+------------------------------------------------------------------+
//| Wrapping text from the next line to the current line             |
//+------------------------------------------------------------------+
void CTextBox::WrapTextToPrevLine(const uint next_line_index,const uint wrap_symbols_total,const bool is_all_text=false)
  {
//--- Get the size of the array of characters in the line
   uint symbols_total=::ArraySize(m_lines[next_line_index].m_symbol);
//--- Index of the previous row
   uint prev_line_index=next_line_index-1;
//--- Copy the characters to be moved into the array
   string array[];
   CopyWrapSymbols(next_line_index,0,wrap_symbols_total,array);
//--- Get the size of the array of characters in the previous line
   uint prev_line_symbols_total=::ArraySize(m_lines[prev_line_index].m_symbol);
//--- Increase the array size of the previous line by the number of added characters
   uint new_prev_line_size=prev_line_symbols_total+wrap_symbols_total;
   ArraysResize(prev_line_index,new_prev_line_size);
//--- Add the data to the arrays of the structure for the new line
   PasteWrapSymbols(prev_line_index,new_prev_line_size-wrap_symbols_total,array);
//--- Shift the characters to the freed area in the current line
   MoveSymbols(next_line_index,wrap_symbols_total,0);
//--- Decrease the array size of the current line by the number of extracted characters
   ArraysResize(next_line_index,symbols_total-wrap_symbols_total);
//--- Adjust the text cursor
   if((is_all_text && next_line_index==m_text_cursor_y_pos) || 
      (!is_all_text && next_line_index==m_text_cursor_y_pos && wrap_symbols_total>0))
     {
      m_text_cursor_x_pos=new_prev_line_size-(wrap_symbols_total-m_text_cursor_x_pos);
      m_text_cursor_y_pos--;
     }
//--- Leave, if this is not all the remaining text of the line
   if(!is_all_text)
      return;
//--- Add the end sign to the previous line, if the current line has it
   if(m_lines[next_line_index].m_end_of_line)
      m_lines[next_line_index-1].m_end_of_line=true;
//--- Get the size of the lines array
   uint lines_total=::ArraySize(m_lines);
//--- Shift lines up by one
   MoveLines(next_line_index,lines_total-1,1,false);
//--- Resize the lines array
   ::ArrayResize(m_lines,lines_total-1);
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CTextBox::ChangeWidthByRightWindowSide(void)
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
   ChangeMainSize(x_size,y_size);
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize();
//--- In the word wrap mode, it is necessary to recalculate and reset the sizes
   if(m_word_wrap_mode)
     {
      CalculateTextBoxSize();
      ChangeTextBoxSize();
     }
//--- Draw the text and deactivate the text box
   DeactivateTextBox();
//--- Redraw the control
   Draw();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
//| Change the height at the bottom edge of the window               |
//+------------------------------------------------------------------+
void CTextBox::ChangeHeightByBottomWindowSide(void)
  {
//--- Leave, if the anchoring mode to the bottom of the form is enabled  
   if(m_anchor_bottom_window_side)
      return;
//--- Coordinates
   int y=0;
//--- Size
   int x_size =(m_auto_xresize_mode)? m_main.X2()-CElementBase::X()-m_auto_xresize_right_offset : m_x_size;
   int y_size =m_main.Y2()-CElementBase::Y()-m_auto_yresize_bottom_offset;
//--- Set the new size
   ChangeMainSize(x_size,y_size);
//--- Calculate the size of the text box
   CalculateTextBoxSize();
//--- Set the new size to the text box
   ChangeTextBoxSize();
//--- Draw the text and deactivate the text box
   DeactivateTextBox();
//--- Redraw the control
   Draw();
   if(m_scrollh.IsScroll())
      m_scrollh.Update(true);
   if(m_scrollv.IsScroll())
      m_scrollv.Update(true);
  }
//+------------------------------------------------------------------+
