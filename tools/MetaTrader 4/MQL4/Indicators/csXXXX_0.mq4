// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
// You might want to use this to construct an on-chart indicator.
// Remember to 'save as...', replacing XXXX by your setup identifier.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#property indicator_chart_window

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void init()
   {
   
   return;
   }
 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Main Program
// ============
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void start()
   {
   // Work out how many bars need re-calculation (max 200?)
   // =====================================================
   int i, limit, counted_bars;
   counted_bars = IndicatorCounted();
   limit        = MathMin( Bars - counted_bars + 1, 200 );
   
   // Load buffers
   // ============
   for( i=0; i<limit; i++)
      {

      }

   return;

   }