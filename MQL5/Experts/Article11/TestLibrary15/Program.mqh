//+------------------------------------------------------------------+
//|                                                      Program.mqh |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include <EasyAndFastGUI\WndEvents.mqh>
#include <EasyAndFastGUI\TimeCounter.mqh>
//+------------------------------------------------------------------+
//| Class for creating an application                                |
//+------------------------------------------------------------------+
class CProgram : public CWndEvents
  {
protected:
   //--- Time counters
   CTimeCounter      m_counter1; // for updating the execution process
   CTimeCounter      m_counter2; // for updating the items in the status bar
   //--- Main window
   CWindow           m_window;
   //--- Status bar
   CStatusBar        m_status_bar;
   //--- Icon
   CPicture          m_picture1;
   //--- Rendered table
   CTable            m_table;
   //--- Edits
   CTextBox          m_text_box1;

   //---
public:
                     CProgram(void);
                    ~CProgram(void);
   //--- Initialization/deinitialization
   void              OnInitEvent(void);
   void              OnDeinitEvent(const int reason);
   //--- Timer
   void              OnTimerEvent(void);
   //--- Chart event handler
   virtual void      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);

   //--- Create the graphical interface of the program
   bool              CreateGUI(void);
   //---
protected:
   //--- Main window
   bool              CreateWindow(const string text);
   //--- Status bar
   bool              CreateStatusBar(const int x_gap,const int y_gap);
   //--- Pictures
   bool              CreatePicture1(const int x_gap,const int y_gap);
   //--- Rendered table
   bool              CreateTable(const int x_gap,const int y_gap);
   //--- Edits
   bool              CreateTextBox1(const int x_gap,const int y_gap);

   //--- Initialize the table
   void              InitializingTable(void);
  };
//+------------------------------------------------------------------+
//| Creating controls                                                |
//+------------------------------------------------------------------+
#include "MainWindow.mqh"
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CProgram::CProgram(void)
  {
//--- Setting parameters for the time counters
   m_counter1.SetParameters(16,100);
   m_counter2.SetParameters(16,35);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CProgram::~CProgram(void)
  {
  }
//+------------------------------------------------------------------+
//| Initialization                                                    |
//+------------------------------------------------------------------+
void CProgram::OnInitEvent(void)
  {
  }
//+------------------------------------------------------------------+
//| Uninitialization                                                 |
//+------------------------------------------------------------------+
void CProgram::OnDeinitEvent(const int reason)
  {
//--- Removing the interface
   CWndEvents::Destroy();
  }
//+------------------------------------------------------------------+
//| Timer                                                            |
//+------------------------------------------------------------------+
void CProgram::OnTimerEvent(void)
  {
   CWndEvents::OnTimerEvent();
//---
   if(m_counter2.CheckTimeCounter())
     {
      if(m_status_bar.IsVisible())
        {
         static int index=0;
         index=(index+1>3)? 0 : index+1;
         m_status_bar.GetItemPointer(1).ChangeImage(0,index);
         m_status_bar.GetItemPointer(1).Update(true);
        }
     }
  }
//+------------------------------------------------------------------+
//| Chart event handler                                              |
//+------------------------------------------------------------------+
void CProgram::OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_CHECKBOX)
     {
      if(lparam==m_table.Id())
        {
         string str="id: "+TO_STRING(ON_CLICK_CHECKBOX)+" ("+string(CHARTEVENT_CUSTOM+ON_CLICK_CHECKBOX)+"); "+
                    "lparam: "+(string)lparam+"; dparam: "+(string)dparam+"; sparam: "+sparam;
         m_text_box1.AddLine(str);
         m_text_box1.Update(true);
         m_text_box1.VerticalScrolling();
        }
      return;
     }
//---
   if(id==CHARTEVENT_CUSTOM+ON_END_EDIT)
     {
      if(lparam==m_table.Id())
        {
         string str="id: "+TO_STRING(ON_END_EDIT)+" ("+string(CHARTEVENT_CUSTOM+ON_END_EDIT)+"); "+
                    "lparam: "+(string)lparam+"; dparam: "+(string)dparam+"; sparam: "+sparam;
         m_text_box1.AddLine(str);
         m_text_box1.Update(true);
         m_text_box1.VerticalScrolling();
        }
      return;
     }
//---
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)
     {
      if(lparam==m_table.Id())
        {
         string str="id: "+TO_STRING(ON_CLICK_COMBOBOX_ITEM)+" ("+string(CHARTEVENT_CUSTOM+ON_CLICK_COMBOBOX_ITEM)+"); "+
                    "lparam: "+(string)lparam+"; dparam: "+(string)dparam+"; sparam: "+sparam;
         m_text_box1.AddLine(str);
         m_text_box1.Update(true);
         m_text_box1.VerticalScrolling();
        }
      return;
     }
//---
   if(id==CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)
     {
      if(lparam==m_table.Id())
        {
         string str="id: "+TO_STRING(ON_CLICK_BUTTON)+" ("+string(CHARTEVENT_CUSTOM+ON_CLICK_BUTTON)+"); "+
                    "lparam: "+(string)lparam+"; dparam: "+(string)dparam+"; sparam: "+sparam;
         m_text_box1.AddLine(str);
         m_text_box1.Update(true);
         m_text_box1.VerticalScrolling();
        }
      return;
     }
  }
//+------------------------------------------------------------------+
//| Create the graphical interface of the program                    |
//+------------------------------------------------------------------+
bool CProgram::CreateGUI(void)
  {
//--- Creating a panel
   if(!CreateWindow("EXPERT PANEL"))
      return(false);
//--- Status bar
   if(!CreateStatusBar(1,23))
      return(false);
//--- Pictures
   if(!CreatePicture1(10,10))
      return(false);
//--- Create the table
   if(!CreateTable(7,26))
      return(false);
//--- Edits
   if(!CreateTextBox1(7,220))
      return(false);
//--- Finishing the creation of GUI
   CWndEvents::CompletedGUI();
   return(true);
  }
//+------------------------------------------------------------------+
