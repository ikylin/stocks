// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
// Part of the Power Pro ("PP") strategy
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#property indicator_chart_window

#property indicator_buffers 4

// Slow EMA of Highs
#property indicator_color1 DodgerBlue
#property indicator_width1 2
#property indicator_style1 STYLE_SOLID

// Slow EMA of Lows
#property indicator_color2 Red
#property indicator_width2 2
#property indicator_style2 STYLE_SOLID

// Fast EMA of Highs
#property indicator_color3 DodgerBlue
#property indicator_width3 1
#property indicator_style3 STYLE_DOT

// Fast EMA of Lows
#property indicator_color4 Red
#property indicator_width4 1
#property indicator_style4 STYLE_DOT
 
// Parameters
// ==========
int SlowMA_Period    = 20;
int FastMA_Period    = 10;
int MA_Method        = MODE_EMA;
int MA_Shift         = 0;
 
// Indicator buffers
// =================
double SH[];   // Slow high 
double SL[];   // Slow low 
double FH[];   // Fast high 
double FL[];   // Fast low


// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void OnInit()
   {
   SetIndexBuffer(0,SH);
   SetIndexLabel(0,"Slow EMA of Highs");

   SetIndexBuffer(1,SL);
   SetIndexLabel(1,"Slow EMA of Lows");

   SetIndexBuffer(2,FH);
   SetIndexLabel(2,"Fast EMA of Highs");

   SetIndexBuffer(3,FL);
   SetIndexLabel(3,"Fast EMA of Lows");
 
   IndicatorShortName("Power Pro");
   
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
      SH[i] = iMA(NULL,0,SlowMA_Period,MA_Shift,MA_Method,PRICE_HIGH,i);
      SL[i] = iMA(NULL,0,SlowMA_Period,MA_Shift,MA_Method,PRICE_LOW,i);
      FH[i] = iMA(NULL,0,FastMA_Period,MA_Shift,MA_Method,PRICE_HIGH,i);
      FL[i] = iMA(NULL,0,FastMA_Period,MA_Shift,MA_Method,PRICE_LOW,i);
      }

   return;

   }