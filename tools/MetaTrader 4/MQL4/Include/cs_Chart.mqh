#property copyright     "Martin Systems, Copyright © 2014"
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INCLUDED CODE
// =============
/*
This code is intended for inclusion within Indicator Code csXXXX_Chart.mq4
(where XXXX is the identifier for the condition under consideration).
It should not need to be modified.
 
It displays a line plot showing results of condition-testing.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
#property indicator_separate_window
#property indicator_buffers 2          //1 extra buffer used for de-bugging

double ResultBuffer[];
double TestBuffer[];


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void init()
   {
   Comment(csName);
   // Results plot
   // ============
   SetIndexBuffer(0,ResultBuffer);
   SetIndexLabel(0,csName + " Scan Results");

   // This buffer used for de-bugging
   // ===============================
   SetIndexBuffer(1,TestBuffer);
   SetIndexLabel(1,"TestResult");
   SetIndexStyle(1,DRAW_NONE,DRAW_NONE);
   SetIndexDrawBegin(1, 999999999);
   
   IndicatorShortName(csName + " Scan Results");
   IndicatorDigits(Digits+1);
   
   return;
   }
   
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// DeInitialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void deinit()
   {
   Comment("");
   }
   
   
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Main Program 
// ============
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void start()
   {
   int i, limit, counted_bars;
   counted_bars = IndicatorCounted();
   limit        = MathMin( Bars - counted_bars + 1, 200 );
   
   // Load up the 'result' buffer
   // ===========================
   for( i=0; i<limit; i++)
      {
      ResultBuffer[i] = GetBarFlag( i );
               // NB - the code for GetBarFlag() is in the 'includer' program
      }
   return;
   }
  