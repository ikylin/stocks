#property copyright     "Martin Systems, Copyright © 2014"
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// INCLUDED CODE
// =============
/*
This code is intended for inclusion within Indicator Code csXXXX_Panel.mq4
(where XXXX is the identifier for the condition under consideration).
It should not need to be modified.

It displays a panel showing the results of your condition testing on your
chosen pairs and timeframes.

Your test is applied to bar[0] after it is 90% formed, else to bar[1].
Wingdings show whether condition is tested on bar[0] or bar[1].
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
#property indicator_chart_window
#property indicator_buffers 1        // used for de-bugging

// User input
// ==========
extern string	XPairs = "AUDCAD,AUDCHF,AUDJPY,AUDNZD,AUDUSD,CADJPY,CHFJPY,EURAUD,EURCAD,EURCHF,EURGBP,EURJPY,EURNZD,EURUSD,GBPAUD,GBPCAD,GBPCHF,GBPJPY,GBPNZD,GBPUSD,NZDJPY,NZDUSD,USDCAD,USDCHF,USDJPY";
extern string	XTimeframes = "M5,M15,M30,H1,H4,D1";       // omits M1,W1,MN

// Panel construction variables
// ============================
string	FontName  =  "Courier New"; // A fixed-width font lines up nicely
int		FontSize  =    10;         
color    FontColor =  MediumBlue;    
int      x_width   =  22;         //pixels width for each timeframe column
int      x_offset;                //pixels from the RHS
int      y_depth   =  12;         //pixels depth for each display line

// Pairs
// =====
int		countPairs;              // Number of currency pairs
int      iP;                      // Indexer for Pairs
string	Pairs[];                 // Pairs array ("EURUSD" etc)

// Timeframes
// ==========
int		countTimeframes;         // Number of timeframes  
int      iT;                      // Indexer for timeframes
string	TimeframeDescs[];        // Timeframe array ("M1","M5" etc)
int		Timeframes[];	          // Timeframe array (in minutes)
datetime TimesDue[];              // Array for TimesDue as to when the next process should occur.
                                  // TimeDue is expressed as the number of seconds elapsed in a period.

// Objects
// =======
string objId ;       // Used to hold the full id of an object.
string objPrefix;

// For testing
// ===========
bool alerted=false;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initialise 
// ==========
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void init()
   {
   objPrefix = "cs" + csName + "_";
   RemoveObjects(objPrefix);   // NB objPrefix is defined in the "includer" program.
                               // RemoveObjects() is an 'included' utility function.

   // Disply the Panel Heading
   // ========================
	x_offset = 0;
	objId = objPrefix + "PanelHead";
   ObjectCreate(objId, OBJ_LABEL, 0, 0, 0);
   ObjectSet(objId, OBJPROP_CORNER, 0);
   ObjectSet(objId, OBJPROP_XDISTANCE, x_offset);
   ObjectSet(objId, OBJPROP_YDISTANCE, y_depth);


   // Check and Store Timeframes
   // ==========================
   int    Timeframe, lenXTimeframes, start;
   string TimeframeDesc;
   XTimeframes=XTimeframes + ","; //ensure trailing comma
   lenXTimeframes = StringLen(XTimeframes);
   iT=0;
   for( start=0; start<lenXTimeframes; )     //NB 'start' is incremented inside the loop
      {
      TimeframeDesc = StringSubstr(XTimeframes,start,StringFind(XTimeframes,",",start)-start); //Get timeframe desc from csv string
      start = start+StringLen(TimeframeDesc)+1;  //point to next char past the current timeframe and the comma
      Timeframe = TimeframeDescToMinutes(TimeframeDesc);    //Get the 'minutes' for this timeframe    
      if( Timeframe != -1 )
         {    // If this is a valid timeframe
         if( (iT != 0)   &&   (Timeframe <= Timeframes[iT-1]) )
            {
            Alert("Timeframes must be in ascending order");
            break;
            }
         else
            {
            ArrayResize(TimeframeDescs,iT+1);       // Make room to add a timeframe description...             
            ArrayResize(Timeframes,iT+1);           // ... and its 'minutes'
            ArrayResize(TimesDue,iT+1);             // ... and its TimeDue
            TimeframeDescs[iT]    =  TimeframeDesc; // Stack timeframe description in array
            Timeframes[iT]        =  Timeframe;     // Stack timeframe minutes in array
            TimesDue[iT]          = 0;              // Initialise to zero (redundant??)
            iT++;
            }
         }
      }
   countTimeframes = iT;     // preserve the final timeframes count



   // Display Timeframe column headings
   // =================================
   for(iT = 0; iT < countTimeframes; iT++)
      {
      TimeframeDesc = TimeframeDescs[iT];
      x_offset = 60 + iT*x_width + 2;

      objId = objPrefix + TimeframeDesc + "_Hd";
      ObjectCreate(objId,OBJ_LABEL,0,0,0,0,0);
      ObjectSet(objId,OBJPROP_CORNER,0);
      ObjectSet(objId,OBJPROP_XDISTANCE,x_offset);
      ObjectSet(objId,OBJPROP_YDISTANCE,2*y_depth);
      ObjectSetText(objId,TimeframeDesc,FontSize-2,FontName,FontColor);
      }
      
   
   
   // Check, store & display Pair symbols
   // ===================================
   int    Len_XPairs;
   string Pair;
   x_offset = 0;
   XPairs=XPairs + ","; //ensure trailing comma
   Len_XPairs = StringLen(XPairs);
   iP=0;
   for(start=0; start<Len_XPairs;)
      {
      Pair = StringSubstr(XPairs,start,StringFind(XPairs,",",start)-start); //Extract pair from csv string
      start = start+StringLen(Pair)+1;   // point to next char past the current pair and the comma
      
      if( iTime(Pair,0,0) != 0)          // verify Pair is a valid pair
         {
         ArrayResize(Pairs,iP+1);             
         Pairs[iP]=Pair;
   		objId = objPrefix + Pair;
		   ObjectCreate(objId,OBJ_LABEL,0,0,0,0,0);
		   ObjectSet(objId,OBJPROP_CORNER,0);
		   ObjectSet(objId,OBJPROP_XDISTANCE,x_offset);
		   ObjectSet(objId,OBJPROP_YDISTANCE,(iP+3)*y_depth);
		   ObjectSetText(objId,Pair,FontSize,FontName,FontColor);
         iP++;
         }
      }
   countPairs = iP;      // preserve the final Pairs count



   // Create one object for each pair within each timeframe
   // =====================================================
   for(iT=0; iT<countTimeframes; iT++)
      {
      Timeframe   = Timeframes[iT];
      
      for(iP=0; iP<countPairs; iP++)
         {
         Pair = Pairs[iP];
   	   x_offset = 60 + iT*x_width + 2;
			objId = objPrefix + Pair + Timeframe;
			ObjectCreate(objId,OBJ_LABEL,0,0,0,0,0);
 			ObjectSet(objId,OBJPROP_CORNER,0);
   		ObjectSet(objId,OBJPROP_XDISTANCE,x_offset);
			ObjectSet(objId,OBJPROP_YDISTANCE,(iP+3)*y_depth);
         }
      }
   }

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Finish 
// ======
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void deinit()
   {
   RemoveObjects(objPrefix);
   }

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Main Program 
// ============
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
void start()
   {
   // Cycle thru timeframes
   // =====================
   for(iT=0; iT<countTimeframes; iT++)
      {
         // For each timeframe, I want to do the processing ONCE, on the penultimate bar (bar[1]),
         // whenever the latest bar is less than 90% elapsed (the Changeover Time).
         //
         // Then, as the latest bar reaches 90% elapsed, I switch to the latest bar (bar[0]) and 
         // do the processing some more times in the last 10% of the timeframe.
         //
         // That is, I am always working on a bar that is at least 90% formed.
         //
         // Note that stuff can be affected by type casting rules (but it don't matter).

      int   Timeframe,           // Minutes per period 
            TimeframeSeconds,    // Seconds per period 
            TimeframeElapsed,    // Elapsed seconds in current period 
            TimeDue,             // No. of seconds from start of period when next analysis is due
            ChangeoverTime,      // No. of seconds into the period when we change from bar[1] to bar[0]
            i;                   // index to the bar I want to work on
      
      Timeframe        = Timeframes[iT];
      TimeframeSeconds = Timeframe * 60;
      ChangeoverTime   = 0.9 * TimeframeSeconds;   // Change to bar[0] when it is 90% formed
      
      TimeframeElapsed = TimeCurrent() - iTime( NULL, Timeframe, 0 );
      
               
      while( TimeframeElapsed > TimeframeSeconds ) // Allow for times of low activity when 
         {                                         // bars may be missing...
         TimeframeElapsed -= TimeframeSeconds;     // ... because Elapsed must fall within
         }                                         //     the timeframe
                        
      TimeDue          = TimesDue[iT];
                 
      if( TimeframeElapsed < TimeDue )           // If TimeDue not yet reached...
         {                                          //
         continue;                                  // ...skip this iteration. Go on to the next timeframe.
         }

      objId = objPrefix + "PanelHead";          // Time stamp the processing  
      ObjectSetText(objId,csName + ": " + TimeToStr(TimeCurrent(),TIME_DATE|TIME_SECONDS), FontSize, FontName, FontColor);
      
      
      if( TimeframeElapsed < ChangeoverTime )    // If we are short of the ChangeoverTime...
         {                                          //
         TimesDue[iT] = ChangeoverTime;             // ... set next TimeDue to ChangeoverTime
         i = 1;                                     // ... work on Bar[1]
         }                                         
      else                                       // But if we have reached or passed ChangeoverTime...
         {                                          //
         while( TimeDue <= TimeframeElapsed )       // ... until it is past the elapsed time
            {                                              
            TimeDue += .02 * TimeframeSeconds;        // ... advance the TimeDue by 2% of a timeframe
            }                                            
                                                         
         if( TimeDue > TimeframeSeconds )           // If TimeDue has advanced beyond the timeframe boundary...
            {                                         //
            TimeDue = 0;                              // ... set the TimeDue back to zero
            }
                                                            
         TimesDue[iT]=TimeDue;                      // ... save TimeDue for next time round
         i = 0;                                     // ... work on Bar[0]
         }
/*         
if(!alerted)
   {
   Alert(TimeCurrent());
   Alert(iT," ",Timeframe," ",TimeframeSeconds," ",TimeframeElapsed," ",TimeDue," ",ChangeoverTime," ",TimesDue[iT]);
   }
alerted=true;
return;
*/
         

      // Cycle thru pairs (within each timeframe)
      // ========================================
      for(iP=0; iP<countPairs; iP++)
         {
         string Pair = Pairs[iP];
         
         
         
              // Function returns 1,0,-1 depending on Long, neutral, short
         int Result = GetBarFlag( Pair, Timeframe, i ); 
               // NB - the code for GetBarFlag() is in the 'includer' program
         
            
         
               // Examine result and display as appropriate
         if( Result == 0 )
            {
            string ShowFont   = "WingDings";
            color  ShowColor  = DarkGray;
            string ShowCode   = CharToStr(128); // WingDing 0
            if(i==1) ShowCode = CharToStr(129); // WingDing 1
            }
            
         else ShowFont = FontName;
         
         
         if( Result > 0 )
            {
            ShowColor   =  Green;
            ShowCode    = Result;
            }
         
         
         if( Result < 0 )
            {
            ShowColor   = Red;
            ShowCode    = -Result;
            }
         


            
   		objId = objPrefix + Pair + Timeframe;      // Change WingdingCode object
   		ObjectSetText(objId,ShowCode,FontSize,ShowFont,ShowColor);
   		
         }//next iP
         
      }//next iT
   

   }//Endfunction

