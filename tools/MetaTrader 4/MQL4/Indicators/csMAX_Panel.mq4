
   // This is where you define your 'condition' identifier
   // ====================================================
#define csName "MAX" 


   // This is where your own code gets included and called
   // ====================================================
#include <csMAX_GetBarFlag.mqh>

int GetBarFlag(string Pair, int Timeframe, int i)
   {
   return(csMAX_GetBarFlag( Pair, Timeframe, i ));
   }

                     #include <Utils.mqh>   // This code is static 
                     #include <cs_Panel.mqh>   // This code is static 


