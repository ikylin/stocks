/*
 * +------------------------------------------------------------------+
 * |                                                       MyQSZB.mq4 |
 * |                        Copyright 2016, MetaQuotes Software Corp. |
 * |                                             https://www.mql5.com |
 * +------------------------------------------------------------------+
 */
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
/* --- show the window of input parameters when launching the script */
#property script_show_inputs

extern bool UseAlerts=true;
extern bool UseEmailAlerts=false; // Don't forget to configure SMTP parameters in Tools->Options->Emails

/* --- parameters for receiving data from the terminal */
input string		InpSymbolName	= "EURUSD";     /* Сurrency pair */
input ENUM_TIMEFRAMES	InpSymbolPeriod = PERIOD_H1;    /* Time frame */
input int		Kperiod		= 9;            /* Fast EMA period */
input int		Dperiod		= 5;            /* Slow EMA period */
input int		slowing		= 5;            /* Difference averaging period */
input ENUM_MA_METHOD	InpAppliedPrice = MODE_SMA;     /* Price type */
input int		price_field	= 0;            /* Difference averaging period */
/* --- parameters for writing data to file */
input string	InpFileName		= "kd_sign.csv";   /* File name */
input string	InpDirectoryName	= "Data";       /* Folder name */
input int	sign_line	= 25;       /* Folder name */


/*
 * +------------------------------------------------------------------+
 * | Script program start function                                    |
 * +------------------------------------------------------------------+
 */

struct SignData {
	string		symbol;
	ENUM_TIMEFRAMES period;
	datetime	date;
	int		signtype;
	double		k;
	double		d;
	double		ma5;
	double		close;
	int datanum;
};

void get_sign(string symbolname, ENUM_TIMEFRAMES timeframe, SignData& sd){
	int		sign_buff[];            /* signal array (true - buy, false - sell) */
	double		k_buff[];               /* array of indicator k values */
	double		d_buff[];               /* array of indicator d values */
	double		ma1_buff[];             /* array of indicator ma1 values */
	double		ma2_buff[];             /* array of indicator ma2 values */
	datetime	date_buff[];            /* array of indicator dates */
	double		close_buff[];           /* array of indicator closes */
	
/* --- set indexing as time series */
	ArraySetAsSeries( sign_buff, true );
	ArraySetAsSeries( k_buff, true );
	ArraySetAsSeries( d_buff, true );
	ArraySetAsSeries( ma1_buff, true );
	ArraySetAsSeries( ma2_buff, true );
	ArraySetAsSeries( date_buff, true );
	ArraySetAsSeries( close_buff, true );

/* --- reset last error code */
	ResetLastError();

	//int barname = iBars( symbolname, timeframe );
	int barname = 100;
/* --- copying the time from last 1000 bars */
   RefreshRates();
	CopyTime( symbolname, timeframe, 0, barname, date_buff );
	int copied = CopyClose( symbolname, timeframe, 0, barname, close_buff );

	if ( copied <= 0 )
	{
		PrintFormat( "Failed to copy time values. Error code = %d", GetLastError() );
		return;
	}else{
	   //PrintFormat( "Copy %s/%d values : %d", symbolname, timeframe, copied );
	}


/* --- prepare ma1_buff array */
	ArrayResize( k_buff, copied );
	ArrayResize( d_buff, copied );
	ArrayResize( ma1_buff, copied );
	ArrayResize( ma2_buff, copied );
	ArrayResize( sign_buff, copied );
/* --- copy the values of main line of the indicator */
	for ( int i = 1; i < copied; i++ )
	{
		k_buff[i]	= iStochastic( symbolname, timeframe, 9, 5, 5, MODE_SMA, 0, MODE_MAIN, i );
		d_buff[i]	= iStochastic( symbolname, timeframe, 9, 5, 5, MODE_SMA, 0, MODE_SIGNAL, i );
		ma1_buff[i]	= iMA( symbolname, timeframe, 5, 0, MODE_SMMA, PRICE_CLOSE, i );
		ma2_buff[i]	= iMA( symbolname, timeframe, 30, 0, MODE_SMMA, PRICE_CLOSE, i );
	}

/* --- analyze the data and save the indicator signals to the arrays */
	for ( int i = 2; i < copied; i++ )
	{
		/* --- buy signal */
		//if ( k_buff[i - 1] < 20 )
		if ( close_buff[i - 1] > ma1_buff[i - 1] && k_buff[i - 1] < sign_line && k_buff[i - 1] > d_buff[i - 1] )
		{
			sign_buff[i-1]	= 1;
		}else{
		   sign_buff[i-1]	= 0;
		}
	}
	
   sd.symbol = symbolname;
   sd.period = timeframe;
   sd.datanum = copied;
   if( copied > 2 ){
      //sd = {symbolname, timeframe, date_buff[0], sign_buff[0], k_buff[0], d_buff[0], ma1_buff[0], close_buff[0]};

      
      int findex;
      
      for(findex = 1; findex < ArraySize(sign_buff) && sign_buff[findex] == 0; findex++ );
      
      if( findex < (ArraySize(sign_buff) - 1) ){
         sd.signtype = findex;
         sd.k = k_buff[findex];
         sd.d = d_buff[findex];
         sd.ma5 = ma1_buff[findex];
         sd.close = close_buff[findex];
         sd.date = date_buff[findex];
      }else{
         sd.signtype = 0;
         sd.k = k_buff[1];
         sd.d = d_buff[1];
         sd.ma5 = ma1_buff[1];
         sd.close = close_buff[1];
         sd.date = date_buff[1];
      }
      
      if( sd.signtype < 10 && sd.signtype > 0 && sd.period >= 30){
         long chart_id = ChartOpen(symbolname,timeframe);
         ChartApplyTemplate(chart_id,"\\Files\\may.tpl");
         SymbolSelect(symbolname,true);
         Print(symbolname + "/" + IntegerToString(timeframe));
      }
   }
}

void get_signs(SignData& sds[])
{
	int num = SymbolsTotal( false );
	Print( num );

	int sdindex = 0;
	ArrayResize( sds, num * 9 );
	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );

      /*
      get_sign(name, PERIOD_M1, sds[sdindex++]);
      get_sign(name, PERIOD_M5, sds[sdindex++]);
      get_sign(name, PERIOD_M15, sds[sdindex++]);
      
      get_sign(name, PERIOD_M30, sds[sdindex++]);
      get_sign(name, PERIOD_H1, sds[sdindex++]);
      */
      get_sign(name, PERIOD_H4, sds[sdindex++]);
      
      get_sign(name, PERIOD_D1, sds[sdindex++]);
      
      get_sign(name, PERIOD_W1, sds[sdindex++]);
      get_sign(name, PERIOD_MN1, sds[sdindex++]);
	}
}

void close_all_windows(){

   int num = SymbolsTotal( false );
	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );
		bool ret = SymbolSelect(name,false);
		if( !ret ){
         //Print("1  " + name + "/" + ret);
      }
	}
	
   //--- variables for chart ID
   long currChart,prevChart=ChartFirst();
   Print("ChartFirst =",ChartSymbol(prevChart)," ID =",prevChart);
   while( true )// We have certainly not more than 100 open charts
     {
      currChart=ChartNext(prevChart); // Get the new chart ID by using the previous chart ID
      if(currChart<0) break;          // Have reached the end of the chart list
      string name = ChartSymbol(currChart);
      bool ret = SymbolSelect(name,true);
		if( !ret ){
         //Print("2  " + name + "/" + ret);
      }
      prevChart=currChart;// let's save the current chart ID for the ChartNext()
     }
}

void init_all_symbol(){

   int num = SymbolsTotal( false );
	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );
      bool ret = SymbolSelect(name,true);
      /*
      ChartOpen(name,PERIOD_M1);
      ChartOpen(name,PERIOD_M5);
      ChartOpen(name,PERIOD_M15);
      ChartOpen(name,PERIOD_M30);
      ChartOpen(name,PERIOD_H1);
      ChartOpen(name,PERIOD_H4);
      ChartOpen(name,PERIOD_D1);
      ChartOpen(name,PERIOD_W1);
      ChartOpen(name,PERIOD_MN1);
      */
		if( !ret ){
         //Print("3  " + name + "/" + ret);
      }
	}
	
	//Sleep(5000);
	
	   //--- variables for chart ID
   long currChart,prevChart=ChartFirst();
   Print("ChartFirst =",ChartSymbol(prevChart)," ID =",prevChart);
   while( true )// We have certainly not more than 100 open charts
     {
      currChart=ChartNext(prevChart); // Get the new chart ID by using the previous chart ID
      if(currChart<0) break;          // Have reached the end of the chart list
      ChartClose(currChart);
      prevChart=currChart;// let's save the current chart ID for the ChartNext()
     }

}

void gen_data_file(SignData& sds[])
{
	ResetLastError();
	int file_handle = FileOpen( InpDirectoryName + "//" + InpFileName, FILE_WRITE | FILE_TXT );
	if ( file_handle != INVALID_HANDLE )
	{
		PrintFormat( "%s file is available for writing", InpFileName );
		PrintFormat( "File path: %s\\Files\\", TerminalInfoString( TERMINAL_DATA_PATH ) );
		/* --- first, write the number of signals */
		FileWrite( file_handle, InpSymbolName, ",", InpSymbolPeriod );
		/* --- write the time and values of signals to the file */
		//for ( int i = 0; i < copied; i++ )
		//{
			/* FileWrite(file_handle,time_buff[i],sign_buff[i]); */
		//	FileWrite( file_handle, date_buff[i], ",", k_buff[i], ",", d_buff[i], ",", ma1_buff[i], ",", close_buff[i], ",", sign_buff[i] );
		//}
		FileWrite( file_handle, "symbol", ",", "period", ",", "date", ",", "k", ",", "d", ",", "ma5", ",", "close", ",", "datanum", ",", "signtype" );
		for ( int i = 0; i < ArraySize(sds); i++ )
		   FileWrite( file_handle, sds[i].symbol, ",", sds[i].period, ",", sds[i].date, ",", sds[i].k, ",", sds[i].d, ",", sds[i].ma5, ",", sds[i].close, ",", sds[i].datanum, ",", sds[i].signtype );
		//FileWrite( file_handle, sd.symbol, ",", sd.period, ",", sd.k, ",", sd.d, ",", sd.ma5, ",", sd.close, ",", sd.signtype );
		/* --- close the file */
		FileClose( file_handle );
		PrintFormat( "Data is written, %s file is closed", InpFileName );
	}else
		PrintFormat( "Failed to open %s file, Error code = %d", InpFileName, GetLastError() );
}

void OnStart()
{


   init_all_symbol();

   SignData sds[];
   get_signs(sds);
   
   gen_data_file(sds);
   
   //close_all_windows(); 

}





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TimeframeToString(int P)
  {
   switch(P)
     {
      case PERIOD_M1:  return("M1");
      case PERIOD_M5:  return("M5");
      case PERIOD_M15: return("M15");
      case PERIOD_M30: return("M30");
      case PERIOD_H1:  return("H1");
      case PERIOD_H4:  return("H4");
      case PERIOD_D1:  return("D1");
      case PERIOD_W1:  return("W1");
      case PERIOD_MN1: return("MN1");
     }
   return("");
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendAlert(string dir)
  {
   string per=TimeframeToString(Period());
   if(UseAlerts)
     {
      Alert(dir+" Pinbar on ",Symbol()," @ ",per);
      PlaySound("alert.wav");
     }
   if(UseEmailAlerts)
      SendMail(Symbol()+" @ "+per+" - "+dir+" Pinbar",dir+" Pinbar on "+Symbol()+" @ "+per+" as of "+TimeToStr(TimeCurrent()));
  }
//+------------------------------------------------------------------+
