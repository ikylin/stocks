// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
/*
This indicator can produce a separate-window plot indicating, for the current
symbol and timeframe, the results of your condition tests.

For example, if you are searching for a moving average crossover, you can use
this to show historically where this occurred on the current chart.

This code, plus three pieces of 'included' code, make up the indicator.

When you use this code to build your indicator, start by using 'save as...',
replacing XXXX in the filename by your own identifier. Then modify that new 
document, replacing the characters XXXX below by your own identifier. 
*/


   //
   // Replace 'XXXX' by your setup identifier (in three places in the code below).
   // ============================================================================
#define csName "XXXX"
   
#include <csXXXX_GetBarFlag.mqh>

int GetBarFlag( int i )
   {
   return( csXXXX_GetBarFlag( Symbol(), Period(), i ) );
   }


#include <Utils.mqh>         // This code should not be altered
#include <cs_Chart.mqh>      // This code should not be altered     

