// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INDICATOR
// =========
// This code plots the results (in a separate window) when your condition
// testing has been applied historically to the bars of the CURRENT chart.
// It melds the static csf code with your own condition-testing code.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      

   // Here is where your trading-opportunities code gets included and called
   // ======================================================================
#define csName "PP"   
#include <csPP_GetBarFlag.mqh>

int GetBarFlag( int i )
   {
   return( csPP_GetBarFlag( Symbol(), Period(), i ) );
   }



   // This is static code. You shouldn't change it.
   // =============================================
#include <Utils.mqh>         // This code should not be altered
#include <cs_Chart.mqh>         // This code should not be altered