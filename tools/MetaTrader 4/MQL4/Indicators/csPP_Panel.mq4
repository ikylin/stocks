// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
// This code displays the results when your own conditions have been
// applied to bar[0] or bar[1] of each of your nominated pairs/timeframes.
// It melds the static code with your own condition-testing code.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   // Define your strategy-identifier
   // ===============================
#define csName "PP"

   // Here is where your own code gets included and called
   // ====================================================
#include <csPP_GetBarFlag.mqh>

int GetBarFlag(string Pair, int Timeframe, int i)
   {
   return(csPP_GetBarFlag( Pair, Timeframe, i ));
   }

   // This is static code. You shouldn't change it.
   // =============================================
                     #include <Utils.mqh>   // This code is static 
                     #include <cs_Panel.mqh>   // This code is static 


