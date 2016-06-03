
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
/*
 * +------------------------------------------------------------------+
 * | Script program start function                                    |
 * +------------------------------------------------------------------+
 */
void OnStart()
{
/* --- */
	get_market_data( 5 );
}


/* +------------------------------------------------------------------+ */


void get_market_data( int atemptnum )
{
	int num = SymbolsTotal( false );
	Print( num );

	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );
		Print( name );


		get_symbol_period_data( name, PERIOD_M1, atemptnum );
		get_symbol_period_data( name, PERIOD_M5, atemptnum );
		get_symbol_period_data( name, PERIOD_M15, atemptnum );
		get_symbol_period_data( name, PERIOD_M30, atemptnum );
		get_symbol_period_data( name, PERIOD_H1, atemptnum );
		get_symbol_period_data( name, PERIOD_H4, atemptnum );
		get_symbol_period_data( name, PERIOD_D1, atemptnum );
		get_symbol_period_data( name, PERIOD_W1, atemptnum );
		get_symbol_period_data( name, PERIOD_MN1, atemptnum );

      //get_symbol_period_data( name, PERIOD_MN1, atemptnum );
	}
}





bool get_symbol_period_data(string symbol, int period, int atemptnum){
   datetime daytimes[];
   int error;
   datetime last_day = D'1980.01.01 00:00';
   
   //---- the Time[] array was sroted in the descending order
   ArrayCopySeries(daytimes,MODE_TIME,symbol,period);
   error=GetLastError();
   if(error==ERR_HISTORY_WILL_UPDATED )
     {
      //---- make two more attempts to read
      for(int i=0;i<atemptnum; i++)
        {
         Sleep(5000);
         ArrayCopySeries(daytimes,MODE_TIME,symbol,period);
         //---- check the current daily bar time
         last_day=daytimes[0];
         if(check_date(last_day)) break;
        }
     }
     
   return check_date(last_day);
}

bool check_date(datetime last_day){
   return (Year()==TimeYear(last_day) && Month()==TimeMonth(last_day) && Day()==TimeDay(last_day));
}