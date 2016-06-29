// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INCLUDED function
// =================
// This function is included in both the Chart indicator and the Panel indicator.
//
// Identify long or short setups. Long if fast MA crosses up
// through slow MA, and vice versa.
//
//            Return
//               0  if bar is inert
//               1  if a potential long trade is found
//              -1  if a potential short trade is found
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int csMAX_GetBarFlag( string Pair, int Timeframe, int i )
 {
   int flag = 0; // Default setting (indicates inert bar)
   
   double FastMA_Now   = iCustom(Pair, Timeframe, "csMAX_0", 0, i );
   double FastMA_Prev  = iCustom(Pair, Timeframe, "csMAX_0", 0, i+1 );
   double SlowMA_Now   = iCustom(Pair, Timeframe, "csMAX_0", 1, i );
   double SlowMA_Prev  = iCustom(Pair, Timeframe, "csMAX_0", 1, i+1 );

   
// Check for possible long trade (set flag to 1)
// =============================================
   if( IsLT( FastMA_Prev, SlowMA_Prev )  && IsGT( FastMA_Now, SlowMA_Now ) )
      {                                                              
      flag=1;
      }

   else


// Check for possible short trade (set flag to -1)
// ===============================================
   if( IsGE( FastMA_Prev, SlowMA_Prev ) && IsLT( FastMA_Now, SlowMA_Now ) )
      {                                                     
      flag=-1;
      }         


//TestBuffer[i]=FastMA_Prev - SlowMA_Prev;
   return (flag);
   }   

