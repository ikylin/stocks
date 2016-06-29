   // This is where your trading-opportunities code gets included and called
   // ======================================================================
#define csName "MAX"   
#include <csMAX_GetBarFlag.mqh>

int GetBarFlag( int i )
   {
   return( csMAX_GetBarFlag( Symbol(), Period(), i ) );
   }



   // The following code should not be altered
   // ========================================
#include <Utils.mqh>         // This code should not be altered
#include <cs_Chart.mqh>         // This code should not be altered      

