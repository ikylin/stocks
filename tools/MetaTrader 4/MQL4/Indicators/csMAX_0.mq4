// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
// Shows green EMA(50) and red EMA(100).
//
// Part of a moving average cross-over strategy.
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#property indicator_chart_window

#property indicator_buffers 2
#property indicator_color1 Green
#property indicator_color2 Red
#property indicator_width1 2
#property indicator_width2 2
 
// Parameters
// ==========
int FastMA_Period    = 50;
int SlowMA_Period    = 100;
int MA_Method        = MODE_EMA;
int MA_Shift         = 0;
 
// Indicator buffers
// =================
double FMA[];
double SMA[];
 


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void init()
   {
   SetIndexBuffer(0,FMA);
   SetIndexLabel(0,"FastMA");
   SetIndexStyle(0,DRAW_LINE);

   SetIndexBuffer(1,SMA);
   SetIndexLabel(1,"SlowMA");
   SetIndexStyle(1,DRAW_LINE);
 
   IndicatorShortName("MA Cross-over");
   
   return;
   }
 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Function Main Program
// =====================
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void start()
   {
   int i, limit, counted_bars;
   counted_bars = IndicatorCounted();
   limit        = MathMin( Bars - counted_bars + 1, 200 );
   
   // Load the MA buffers
   // ===================
   for( i=0; i<limit; i++)
      {
      FMA[i] = iMA(NULL,0,FastMA_Period,MA_Shift,MA_Method,PRICE_CLOSE,i);
      SMA[i] = iMA(NULL,0,SlowMA_Period,MA_Shift,MA_Method,PRICE_CLOSE,i);
      }

   return;

   }