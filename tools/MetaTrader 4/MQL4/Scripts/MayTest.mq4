//+------------------------------------------------------------------+
//|                                                      MayTest.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
#define KEY_NUMPAD_5       12
#define KEY_LEFT           37
#define KEY_UP             38
#define KEY_RIGHT          39
#define KEY_DOWN           40
#define KEY_NUMLOCK_DOWN   98
#define KEY_NUMLOCK_LEFT  100
#define KEY_NUMLOCK_5     101
#define KEY_NUMLOCK_RIGHT 102
#define KEY_NUMLOCK_UP    104
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
  
  //--- directory from which the terminal is started
   string terminal_path=TerminalInfoString(TERMINAL_PATH);
   Print("Terminal directory:",terminal_path);
//--- terminal data directory, in which the MQL4 folder with EAs and indicators is located
   string terminal_data_path=TerminalInfoString(TERMINAL_DATA_PATH);
   Print("Terminal data directory:",terminal_data_path);
  
//---
   Print("The Expert Advisor with name ",MQLInfoString(MQL_PROGRAM_NAME)," is running");

   
   int num = SymbolsTotal(false);
   
   /*
   for(int i=1; i<=num; i++){
   
      string name = SymbolName(1,false);
      Print(name);
      SymbolSelect(name,true);
      ChartID();
      long id = ChartOpen(name,PERIOD_D1);
      //--- enable object create events
      //ChartSetInteger(id,CHART_EVENT_OBJECT_CREATE,true);
      //--- enable object delete events
      //ChartSetInteger(id,CHART_EVENT_OBJECT_DELETE,true);
      //ChartClose(0);
   }
   */
   
   //ChartSetSymbolPeriod(0,name,PERIOD_W1);
   
   if(FileIsExist("may.tpl"))
     {
      Print("The file may.tpl found in Files'");
      //--- apply template
      if(ChartApplyTemplate(0,"\\Files\\may.tpl"))
        {
         Print("The template 'may.tpl' applied successfully");
        }
      else
         Print("Failed to apply 'may.tpl', error code ",GetLastError());
     }
   else
     {
      Print("File 'may.tpl' not found in "
            +TerminalInfoString(TERMINAL_PATH)+"\\MQL4\\Files");
     }
     
     ChartPeriod(0);
     
     
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,         // Event identifier  
                  const long& lparam,   // Event parameter of long type
                  const double& dparam, // Event parameter of double type
                  const string& sparam) // Event parameter of string type
  {
//--- the left mouse button has been pressed on the chart
   if(id==CHARTEVENT_CLICK)
     {
      Print("The coordinates of the mouse click on the chart are: x = ",lparam,"  y = ",dparam);
     }
//--- the mouse has been clicked on the graphic object
   if(id==CHARTEVENT_OBJECT_CLICK)
     {
      Print("The mouse has been clicked on the object with name '"+sparam+"'");
     }
//--- the key has been pressed
   if(id==CHARTEVENT_KEYDOWN)
     {
      switch(int(lparam))
        {
         case KEY_NUMLOCK_LEFT:  Print("The KEY_NUMLOCK_LEFT has been pressed");   break;
         case KEY_LEFT:          Print("The KEY_LEFT has been pressed");           break;
         case KEY_NUMLOCK_UP:    Print("The KEY_NUMLOCK_UP has been pressed");     break;
         case KEY_UP:            Print("The KEY_UP has been pressed");             break;
         case KEY_NUMLOCK_RIGHT: Print("The KEY_NUMLOCK_RIGHT has been pressed");  break;
         case KEY_RIGHT:         Print("The KEY_RIGHT has been pressed");          break;
         case KEY_NUMLOCK_DOWN:  Print("The KEY_NUMLOCK_DOWN has been pressed");   break;
         case KEY_DOWN:          Print("The KEY_DOWN has been pressed");           break;
         case KEY_NUMPAD_5:      Print("The KEY_NUMPAD_5 has been pressed");       break;
         case KEY_NUMLOCK_5:     Print("The KEY_NUMLOCK_5 has been pressed");      break;
         default:                Print("Some not listed key has been pressed");
        }
      ChartRedraw();
     }
//--- the object has been deleted
   if(id==CHARTEVENT_OBJECT_DELETE)
     {
      Print("The object with name ",sparam," has been deleted");
     }
//--- the object has been created
   if(id==CHARTEVENT_OBJECT_CREATE)
     {
      Print("The object with name ",sparam," has been created");
     }
//--- the object has been moved or its anchor point coordinates has been changed
   if(id==CHARTEVENT_OBJECT_DRAG)
     {
      Print("The anchor point coordinates of the object with name ",sparam," has been changed");
     }
//--- the text in the Edit of object has been changed
   if(id==CHARTEVENT_OBJECT_ENDEDIT)
     {
      Print("The text in the Edit field of the object with name ",sparam," has been changed");
     }
  }
//+------------------------------------------------------------------+
