/*
 * +------------------------------------------------------------------+
 * |                                                       mt2Tdx.mq4 |
 * |                        Copyright 2016, MetaQuotes Software Corp. |
 * |                                             https://www.mql5.com |
 * +------------------------------------------------------------------+
 */
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https: /* www.mql5.com" */
#property version   "1.00"
#property strict
/*
 * +------------------------------------------------------------------+
 * | Script program start function                                    |
 * +------------------------------------------------------------------+
 */

input string InpDirectoryName = "tdx";


struct TdxDay {                 /* 日K线数据结构 */
	unsigned int	date;   /* e.g. 20100304 */
	int		open;   /* *0.01 开盘价 */
	int		high;   /* *0.01 最高价 */
	int		low;    /* *0.01 最低价 */
	int		close;  /* *0.01 收盘价 */
	float		amount; /* 成交额 */
	int		vol;    /* 成交量(手) */
	int		reserved;
};

struct TdxLei {                 /* 日K线数据结构 */
	char	code[7];
	char	name[3 * 16 + 9];
	char	path[16 * 16];
};


void OnStart()
{
	
	
	tdx_gen_day_file();
	tdx_gen_lei_file();

	/* tdx_add_day_data("sz397002.day",20160526,1,1,1,1,1); */


	/*
	 * //tdx_add_397("lcext.lei", "397003", "XAUUSD", "path");
	 * tdx_get_397("lcext.lei");
	 *
	 * string ldtdx = tdx_get_last_date("sz397002.day");
	 * Print(ldtdx);
	 * datetime ldd = date_tdx2mt(ldtdx);
	 */


	/*
	 * //---
	 * string name = "USDJPY";
	 * datetime start_time = D'2016.05.01 00:00';
	 * datetime stop_time = D'2016.06.01 00:00';
	 * ENUM_TIMEFRAMES timeframe = PERIOD_D1;
	 *
	 * MqlRates rates[];
	 * ArraySetAsSeries(rates,true);
	 * //int copied = CopyRates(name,0,0,100,rates);
	 *
	 * download_his_data(name, timeframe);
	 *
	 * Print("Total number of bars for the symbol-period at this moment = ",
	 *    SeriesInfoInteger(name,0,SERIES_BARS_COUNT));
	 * Print("The first date for the symbol-period at this moment = ",
	 *    (datetime)SeriesInfoInteger(name,0,SERIES_FIRSTDATE));
	 * Print("The last date for the symbol-period at this moment = ",
	 *    (datetime)SeriesInfoInteger(name,0,SERIES_LASTBAR_DATE));
	 * Print("The first date in the history for the symbol-period on the server = ",
	 *    (datetime)SeriesInfoInteger(name,0,SERIES_SERVER_FIRSTDATE));
	 *
	 * int copied=CopyRates(name,timeframe,start_time,stop_time,rates);
	 * if(copied>0)
	 * {
	 * PrintFormat("Bars copied: %d", copied);
	 * string format="%s,  open = %G, high = %G, low = %G, close = %G, volume = %d";
	 * string out;
	 * //int size=fmin(copied,10);
	 * for(int i=0;i<copied;i++)
	 *   {
	 *    if(ldd<=rates[i].time){
	 *       out=IntegerToString(i)+":" + TimeToString(rates[i].time);
	 *       out=out+" "+StringFormat(format,
	 *                                name,
	 *                                rates[i].open,
	 *                                rates[i].high,
	 *                                rates[i].low,
	 *                                rates[i].close,
	 *                                rates[i].tick_volume);
	 *       Print(out);
	 *
	 *    }
	 *   }
	 * }
	 * else Print("Failed to get history data for the symbol ",name);
	 *
	 */
}


void download_his_data( string symbol, ENUM_TIMEFRAMES timeframe )
{
	long chart_id = ChartOpen( symbol, timeframe );
	/* RefreshRates(); */
	ChartClose( chart_id );
}


datetime date_tdx2mt( string ldtdx )
{
	string		mtstr	= StringSubstr( ldtdx, 0, 4 ) + "." + StringSubstr( ldtdx, 4, 2 ) + "." + StringSubstr( ldtdx, 6, 2 ) + " 00:00";
	datetime	ldd	= StringToTime( mtstr );
	return(ldd);
}


int date_mt2tdx( datetime mddate )
{
	string dtstr = TimeToStr( mddate, TIME_DATE );
	StringReplace( dtstr, ".", "" );
	return(StringToInteger( dtstr ) );
}


string tdx_get_last_date( string inpFileName )
{
	string last_date;
	/* --- structure array */
	TdxDay rd[];
	/* --- file path */
	string path = InpDirectoryName + "//vipdoc//sz//lday//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( path, FILE_READ | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/* --- read all data from the file to the array */
		FileReadArray( file_handle, rd );
		/* --- receive the array size */
		int size = ArraySize( rd ) - 1;
		/* --- print data from the array */
		last_date = IntegerToString( rd[size].date );
		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), path );
	return(last_date);
}


void tdx_add_day_data( string inpFileName, unsigned int date,   /* e.g. 20100304 */
		       int open,                                /* *0.01 开盘价 */
		       int high,                                /* *0.01 最高价 */
		       int low,                                 /* *0.01 最低价 */
		       int close,                               /* *0.01 收盘价 */
		       int vol )                                /* 成交量(手)) */
{
	/* --- structure array */
	TdxDay rd[];
	ArrayResize( rd, 1 );
	rd[0].date	= date;
	rd[0].open	= open;
	rd[0].high	= high;
	rd[0].low	= low;
	rd[0].close	= close;
	rd[0].vol	= vol;

	/* --- file path */
	string path = InpDirectoryName + "//vipdoc//sz//lday//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( path, FILE_READ | FILE_WRITE | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/* --- read all data from the file to the array */
		if ( FileSeek( file_handle, 0, SEEK_END ) )
			FileWriteArray( file_handle, rd, 0, 1 );
		/* --- receive the array size */
		int size = ArraySize( rd ) - 1;
		/* --- print data from the array */
		Print( IntegerToString( rd[size].date ) );
		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), path );
}


void tdx_write_day_data( string inpFileName, TdxDay & rd[], int realsize )
{
	/* --- file path */
	string path = InpDirectoryName + "//vipdoc//sz//lday//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( path, FILE_READ | FILE_WRITE | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/* --- read all data from the file to the array */
		if ( FileSeek( file_handle, -1*sizeof(TdxDay), SEEK_END ) ){
		   FileWriteArray( file_handle, rd, ArraySize( rd ) - realsize, realsize );
		}

		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), path );
}


void tdx_get_397( string inpFileName )
{
	TdxLei	l[];
	string	path = InpDirectoryName + "//T0002//lc//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( path, FILE_READ | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/* --- read all data from the file to the array */
		FileReadArray( file_handle, l );
		/* --- receive the array size */
		int size = ArraySize( l ) - 1;
		/* --- print data from the array */
		Print( "----------------------->" + CharArrayToString( l[size].code, 0, 6, CP_ACP ) );
		Print( "----------------------->" + CharArrayToString( l[size].name, 0, 3 * 16 + 9, CP_ACP ) );
		Print( "----------------------->" + CharArrayToString( l[size].path, 0, 16 * 16, CP_ACP ) );
		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), path );
}


void tdx_add_397( string inpFileName, string code, string name, string path )
{
	TdxLei l[];
	ArrayResize( l, 1 );
	StringToCharArray( code, l[0].code, 0, StringLen( code ), CP_ACP );
	StringToCharArray( name, l[0].name, 0, StringLen( name ), CP_ACP );
	StringToCharArray( path, l[0].path, 0, StringLen( path ), CP_ACP );
	string filepath = InpDirectoryName + "//T0002//lc//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( filepath, FILE_READ | FILE_WRITE | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/*
		 * --- read all data from the file to the array
		 * if(FileSeek(file_handle,sizeof(TdxLei)*2,SEEK_SET)==true)
		 */
		if ( FileSeek( file_handle, 0, SEEK_END ) )
			FileWriteArray( file_handle, l, 0, 1 );
		/* --- receive the array size */
		int size = ArraySize( l ) - 1;


		/*
		 * //--- print data from the array
		 * Print("----------------------->" + CharArrayToString(l[size].code,0,6,CP_ACP));
		 * Print("----------------------->" + CharArrayToString(l[size].name,0,3*16+9,CP_ACP));
		 * Print("----------------------->" + CharArrayToString(l[size].path,0,16*16,CP_ACP));
		 */
		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), filepath );
}


void tdx_write_397( string inpFileName, TdxLei & l[] )
{
	string filepath = InpDirectoryName + "//T0002//lc//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( filepath, FILE_READ | FILE_WRITE | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/*
		 * --- read all data from the file to the array
		 * if(FileSeek(file_handle,sizeof(TdxLei)*2,SEEK_SET)==true)
		 */
		FileWriteArray( file_handle, l, 0, ArraySize( l ) );
		/*
		 * --- receive the array size
		 * int size=ArraySize(l)-1;
		 */


		/*
		 * //--- print data from the array
		 * Print("----------------------->" + CharArrayToString(l[size].code,0,6,CP_ACP));
		 * Print("----------------------->" + CharArrayToString(l[size].name,0,3*16+9,CP_ACP));
		 * Print("----------------------->" + CharArrayToString(l[size].path,0,16*16,CP_ACP));
		 */
		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), filepath );
}


void tdx_gen_day_file()
{
	int num = SymbolsTotal( false );
	Print( num );

	TdxDay rd[];

	int	extCode = 397001;
	string	file;

	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );

		int	dotnum	= SymbolInfoInteger( Symbol(), SYMBOL_DIGITS );
		int	cs	= MathPow( 10, dotnum );
		/* Print("--------------" + cs); */


		datetime	start_time	= D'1980.01.01 00:00';
		//datetime	stop_time	= D'2016.06.01 00:00';
		datetime stop_time = TimeCurrent();
		ENUM_TIMEFRAMES timeframe	= PERIOD_D1;

		MqlRates rates[];
		ArraySetAsSeries( rates, true );
		/* int copied = CopyRates(name,0,0,100,rates); */

		/* download_his_data(name, timeframe); */


      RefreshRates();
		int copied = CopyRates( name, timeframe, start_time, stop_time, rates );
		int realsize = 0;
		ArrayResize( rd, copied );
		
		file = "sz" + IntegerToString( extCode, 6, '0' ) + ".day";
		string ldtdx = tdx_get_last_date(file);
		datetime ldd = date_tdx2mt(ldtdx);
		
		if ( copied > 0 )
		{
			PrintFormat( "Bars copied: %d", copied );
			string	format = "%s,  open = %G, high = %G, low = %G, close = %G, volume = %d";
			string	out;
			/* int size=fmin(copied,10); */
			
			for ( int i = copied - 1; i >= 0; i-- )
			{
			   
			   if( ldd <= rates[i].time ){
			      Print(TimeToString(rates[i].time));
   				rd[copied - i - 1].date		= date_mt2tdx( rates[i].time );
   				rd[copied - i - 1].open		= StringToInteger( DoubleToString( rates[i].open * cs ) );
   				rd[copied - i - 1].high		= StringToInteger( DoubleToString( rates[i].high * cs ) );
   				rd[copied - i - 1].low		= StringToInteger( DoubleToString( rates[i].low * cs ) );
   				rd[copied - i - 1].close	= StringToInteger( DoubleToString( rates[i].close * cs ) );
   				rd[copied - i - 1].vol		= rates[i].tick_volume;
   				realsize++;
            /*
   				out=IntegerToString(i)+":" + IntegerToString(rd[i].date);
   				out=out+" "+StringFormat(format,
   				                        name,
   				                        rd[i].open,
   				                        rd[i].high,
   				                        rd[i].low,
   				                        rd[i].close,
   				                        rd[i].vol);
   				 //Print(out);
   				 */
				 }
				 
			}
		}else Print( "Failed to get history data for the symbol ", name );

      Print(file + "/" + ldtdx + "/" + realsize);
		if( realsize > 0 ){
		   //ArrayResize( rd, realsize );
		   tdx_write_day_data( file, rd, realsize );
      }
		extCode++;
		//break; 
	}
}


void tdx_gen_lei_file()
{
	int num = SymbolsTotal( false );
	Print( num );

	TdxLei l[];
	ArrayResize( l, num );
	int	extCode = 397001;
	string	path	= "null";
	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );

		StringToCharArray( IntegerToString( extCode, 6, '0' ), l[i - 1].code, 0, StringLen( IntegerToString( extCode, 6, '0' ) ), CP_ACP );
		StringToCharArray( name, l[i - 1].name, 0, StringLen( name ), CP_ACP );
		StringToCharArray( path, l[i - 1].path, 0, StringLen( path ), CP_ACP );


		extCode++;

		/*
		 * SymbolSelect(name,true);
		 * long id = ChartOpen(name,PERIOD_D1);
		 * --- enable object create events
		 * ChartSetInteger(id,CHART_EVENT_OBJECT_CREATE,true);
		 * --- enable object delete events
		 * ChartSetInteger(id,CHART_EVENT_OBJECT_DELETE,true);
		 * ChartClose(0);
		 */
	}

	tdx_write_397( "lcext.lei", l );
}


/* +------------------------------------------------------------------+ */
