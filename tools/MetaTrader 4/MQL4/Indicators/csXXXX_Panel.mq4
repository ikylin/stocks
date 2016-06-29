// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
/*
This indicator displays a panel showing, for your chosen pairs and
timeframes, the results of your condition tests.

For example, if you are searching for a moving average crossover, this
indicator can show which pairs/timeframes have just shown a crossover.

This code, plus three pieces of 'included' code, make up the indicator.

When you use this code to build your indicator, start by using 'save as...',
replacing XXXX in the filename by your own identifier. Then modify that new 
document, replacing the characters XXXX below by your own identifier. 

*/


   // Define your 'conditions' identifier
   // ===================================
#define csName "XXXX"


   // Here is where your condition-testing code gets included and called
   // ==================================================================
#include <csXXXX_GetBarFlag.mqh>

int GetBarFlag(string Pair, int Timeframe, int i)
   {
   return(csXXXX_GetBarFlag( Pair, Timeframe, i ));
   }

   // This code should not be altered
   // ===============================
#include <Utils.mqh>      // This code should not be altered
#include <cs_Panel.mqh>   // This code should not be altered

