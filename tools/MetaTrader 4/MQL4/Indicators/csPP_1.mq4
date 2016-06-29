// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
// Part of the Power Pro ("PP") strategy.
// Shows RSI(10) and an EMA(10) of the RSI.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#property indicator_separate_window

#property indicator_minimum 0
#property indicator_maximum 100

#property indicator_buffers 2
#property indicator_color1 Red   // for RSI
#property indicator_color2 Lime  // for EMA of RSI
#property indicator_level1 45    // neutral zone lower bound
#property indicator_level2 55    //              higher bound
 
// Parameters
// ==========
int RSI_Period   = 10;
int MA_Period    = 10;
int MA_Shift     = 0;
int MA_Method    = MODE_EMA;
 
// Indicator buffers
// =================
double RSI[];
double MA[];
 


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void init()
   {
   SetIndexBuffer(0,RSI);
   SetIndexLabel(0,"RSI");
   SetIndexStyle(0,DRAW_LINE);

   SetIndexBuffer(1,MA);
   SetIndexLabel(1,"EMAofRSI");
   SetIndexStyle(1,DRAW_LINE);
 
   IndicatorShortName("EMA of RSI");
   
   return;
   }
 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Main Program
// ============
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void start()
   {
   int i, limit, counted_bars;
   counted_bars = IndicatorCounted();
   limit        = Bars - counted_bars + 1;
   
   // Load the RSI buffer
   // ===================
   for( i=0; i<limit; i++)
      {
      RSI[i] = iRSI(NULL,0,RSI_Period,PRICE_CLOSE,i);
      }
      
   // Load the EMA of RSI buffer
   // ==========================
   for( i=limit; i>=0; i-- )     // NB Left-to-right for iMAOnArray
      {
      MA[i]  = iMAOnArray(RSI,0,MA_Period,MA_Shift,MA_Method,i);    
      }

   return;

   }