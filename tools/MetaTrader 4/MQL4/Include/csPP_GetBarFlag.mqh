// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INCLUDED CODE
// =============
// Identify long or short setups. If there are two or more consecutive 
// long signals, discard all bar the first. Same with short signals.
// For the conditions, see comments embedded in the code below.
//
//            Return
//               0  if bar is inert
//               1  if a potential long trade is found
//              -1  if a potential short trade is found
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int csPP_GetBarFlag( string Pair, int Timeframe, int i )
   {

// First, get a raw flag for bar[i]
// ================================
   int ThisBarFlag = SetFlag( Pair, Timeframe, i );

   
// Then filter out if consecutive same-direction flags
// ===================================================
   if( ThisBarFlag != 0 )                     // If this bar is active...
      {                                         
      for( int iPrev = i+1; true; iPrev++ )   //...look back at previous bars
         {                                      
                                                
                                                   
         if( iBars(Pair,Timeframe) <= iPrev ) // If there are no previous bars...
            {                                   //... ThisBarFlag stands
            break;                              //... and we exit the loop
            }                                      
                                                   
                                                   
                                              // But if there is a previous bar,
         int PrevBarFlag = SetFlag( Pair, Timeframe, iPrev );  // get its flag
                                                
         if( PrevBarFlag != 0 )               // If we find an active previous bar
            {                                 //
            if( PrevBarFlag == ThisBarFlag )    // If it points in the same direction as ThisBar...
               {                                //
               ThisBarFlag = 0;                 // ... we discard ThisBarFlag
               }                                // 
            break;                           // Either way, we stop back-checking and exit the loop
            }
                                             // But if the previous flag was inert ...
                                             //...we continue to look back for an active bar
         }//endfor( int iPrev = i+1; true; iPrev++ )          
         
      }//endif( ThisBarFlag != 0 )

//ThisBarFlag=-1;
//if(iOpen(Pair,Timeframe,i) < iClose(Pair,Timeframe,i)) ThisBarFlag=1;
   
   return( ThisBarFlag );
   }
// ~~ end function ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~





// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Function
// ========
// Decide whether this bar on its own could be a trigger for a trade.
//
//   Return
//     0  if bar is inert
//     1  if a potential long trade is found
//    -1  if a potential short trade is found
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

int SetFlag( string Pair, int Timeframe, int i )
   {
   int flag = 0; // Default setting (indicates inert bar)
   double C;
   double RSI;

   C = iClose( Pair, Timeframe, i );

   
      // Check for possible long trade (set flag to 1)
      // =============================================
   if( C > iOpen( Pair, Timeframe, i ) )                           // Close is above open...
      {                                                              
      if( C > iCustom(Pair,Timeframe,"csPP_0",0,i) )               // ... and above bands
         {                                                     
         RSI = iCustom( Pair, Timeframe, "csPP_1", 0, i ); 
         if( RSI > 55 )                                            // ... and RSI is above neutral zone
            {                                                        
            if( RSI > iCustom(Pair,Timeframe, "csPP_1", 1, i) )   // ... and above its own average
               {
               flag=1;           // Set flag to indicate a possible long trade
               }
            }
         }         
      }


   else


      // Check for possible short trade (set flag to -1)
      // ===============================================
   if( C < iOpen( Pair, Timeframe, i ) )                        // Close is below open ...
      {                                                              
      if( C < iCustom(Pair,Timeframe,"csPP_0",1,i) )            // ... and below bands  
         {
         RSI = iCustom( Pair, Timeframe, "csPP_1", 0, i ); 
         if( RSI < 45 )                                         // ... and RSI is below neutral zone
            {                                                        
            if( RSI < iCustom(Pair,Timeframe,"csPP_1", 1, i) ) // ... and below its own average
               {
               flag=-1;          // Set flag to indicate possible short trade
               }
            }
         }
      }

   return (flag);
   }   

