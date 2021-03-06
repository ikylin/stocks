/*
 * +------------------------------------------------------------------+
 * |                                                       mt2Tdx.mq4 |
 * |                        Copyright 2016, MetaQuotes Software Corp. |
 * |                                             https://www.mql5.com |
 * +------------------------------------------------------------------+
 */
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
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

struct TdxLc {                 /* 日K线数据结构 */
	unsigned short	date;        /* e.g. 20100304 */
	unsigned short	time;        /* e.g. 20100304 */
	float		open;              /* *0.01 开盘价 */
	float		high;   /* *0.01 最高价 */
	float		low;    /* *0.01 最低价 */
	float		close;  /* *0.01 收盘价 */
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
	
	tdx_gen_lc5_file();
	//Print(date_mt2tdx_lc5_date(D'2016.06.08 00:00'));
	//Print(tdx_get_last_lc_date("sz000001.lc5"));
	
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

short date_mt2tdx_lc5_date( datetime mddate )
{
	return (TimeYear(mddate)-2004)*2048 + TimeMonth(mddate)*100 + TimeDay(mddate);
}

short date_mt2tdx_lc5_time( datetime mddate )
{
	return (TimeHour(mddate))*60 + TimeMinute(mddate);
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

string tdx_get_last_lc_date( string inpFileName )
{
	string last_date;
	/* --- structure array */
	TdxLc lc[];
	/* --- file path */
	string path = InpDirectoryName + "//vipdoc//sz//fzline//" + inpFileName;
	/*
	 * C:\Users\Administrator\AppData\Roaming\MetaQuotes\Terminal\E87C1DD8E868208C65D1F9992B1D94AA\MQL4\Files
	 * --- open the file
	 */
	ResetLastError();
	int file_handle = FileOpen( path, FILE_READ | FILE_BIN );
	if ( file_handle != INVALID_HANDLE )
	{
		/* --- read all data from the file to the array */
		FileReadArray( file_handle, lc );
		/* --- receive the array size */
		int size = ArraySize( lc ) - 1;
		/* --- print data from the array */
		//last_date = IntegerToString( lc[size].date );
		//PrintFormat("%d,%d,%f,%f,%f,%f,%f,%d",lc[size-1].date,lc[size-1].time,lc[size-1].open,lc[size-1].high,lc[size-1].low,lc[size-1].close,lc[size-1].amount,lc[size-1].vol);
		//PrintFormat("%d,%d,%f,%f,%f,%f,%f,%d",lc[size].date,lc[size].time,lc[size].open,lc[size].high,lc[size].low,lc[size].close,lc[size].amount,lc[size].vol);
		//Print(lc[size].date);
		last_date = lc5_date_to_normal(lc[size].date);
		FileClose( file_handle );
	}else
		PrintFormat( "File open failed, error %d, %s", GetLastError(), path );
	return(last_date);
}

string lc5_date_to_normal(short date)
{
   string year = IntegerToString(2004+floor(date/2048));
   short m = floor((date%2048)/100);
   string month = m<10 ? "0" + IntegerToString(m) : IntegerToString(m);
   short d = (date%2048)%100;
   string day = d<10 ? "0" + IntegerToString(d) : IntegerToString(d);
   return year + month + day;
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
		//Print( IntegerToString( rd[size].date ) );
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

void tdx_write_lc_data( string inpFileName, TdxLc& lc[], int realsize )
{
	/* --- file path */
	string path = InpDirectoryName + "//vipdoc//sz//fzline//" + inpFileName;
	Print(path);
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
		   FileWriteArray( file_handle, lc, ArraySize( lc ) - realsize, realsize );
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
		//Print( "----------------------->" + CharArrayToString( l[size].code, 0, 6, CP_ACP ) );
		//Print( "----------------------->" + CharArrayToString( l[size].name, 0, 3 * 16 + 9, CP_ACP ) );
		//Print( "----------------------->" + CharArrayToString( l[size].path, 0, 16 * 16, CP_ACP ) );
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

		/*
      if (name != "CORN") {
         continue;
      }
      */    
      int	dotnum	= SymbolInfoInteger( Symbol(), SYMBOL_DIGITS );  
		//int	dotnum	= SymbolInfoInteger( Symbol(), SYMBOL_DIGITS ) > 2 ? SymbolInfoInteger( Symbol(), SYMBOL_DIGITS )-2 : 0;
		int	cs	= MathPow( 10, dotnum );
		//Print("--------------" + cs);
      


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
			
			/* int size=fmin(copied,10); */
			int i = copied - 1;
			for ( ; i >= 0; i-- )
			{
			   
			   if( ldd <= rates[i].time ){
			      //Print(TimeToString(rates[i].time));
   				rd[copied - i - 1].date		= date_mt2tdx( rates[i].time );
   				rd[copied - i - 1].open		= StringToInteger( DoubleToString( rates[i].open * cs ) );
   				rd[copied - i - 1].high		= StringToInteger( DoubleToString( rates[i].high * cs ) );
   				rd[copied - i - 1].low		= StringToInteger( DoubleToString( rates[i].low * cs ) );
   				rd[copied - i - 1].close	= StringToInteger( DoubleToString( rates[i].close * cs ) );
   				rd[copied - i - 1].vol		= rates[i].tick_volume;
   				realsize++;
        
               /*
   				string	out=IntegerToString(i)+":" + IntegerToString(rd[copied - i - 1].date);
   				out=out+" _ "+StringFormat(format,
   				                        name,
   				                        rd[copied - i - 1].open,
   				                        rd[copied - i - 1].high,
   				                        rd[copied - i - 1].low,
   				                        rd[copied - i - 1].close,
   				                        rd[copied - i - 1].vol);
   				Print(out);
   				*/
				 }
				 
			}
		}else Print( "Failed to get history data for the symbol ", name );

      //Print(file + "/" + ldtdx + "/" + realsize);
		if( realsize > 0 ){
		   //ArrayResize( rd, realsize );
		   tdx_write_day_data( file, rd, realsize );
      }
		extCode++;
		//break; 
	}
}



void tdx_gen_lc5_file()
{
	int num = SymbolsTotal( false );
	Print( num );

	TdxLc lc[];

	int	extCode = 397001;
	string	file;

	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );
   
      /*
      if (name != "CORN") {
         continue;
      }
      */
		int	dotnum	= SymbolInfoInteger( Symbol(), SYMBOL_DIGITS ) > 2 ? SymbolInfoInteger( Symbol(), SYMBOL_DIGITS )-2 : 0;
		int	cs	= MathPow( 10, dotnum );
		//Print("--------------" + cs);
      

		datetime	start_time	= D'1980.01.01 00:00';
		//datetime	stop_time	= D'2016.06.01 00:00';
		datetime stop_time = TimeCurrent();
		ENUM_TIMEFRAMES timeframe	= PERIOD_M5;

		MqlRates rates[];
		ArraySetAsSeries( rates, true );
		/* int copied = CopyRates(name,0,0,100,rates); */

		/* download_his_data(name, timeframe); */


      RefreshRates();
		int copied = CopyRates( name, timeframe, start_time, stop_time, rates );
		int realsize = 0;
		ArrayResize( lc, copied );
		
		file = "sz" + IntegerToString( extCode, 6, '0' ) + ".lc5";
		string ldtdx = tdx_get_last_lc_date(file);
		datetime ldd = date_tdx2mt(ldtdx);
		
		if ( copied > 0 )
		{
			PrintFormat( "Bars copied: %d", copied );
			string	format = "%s,  open = %G, high = %G, low = %G, close = %G, volume = %d";
			
			/* int size=fmin(copied,10); */
			int i = copied - 1;
			for ( ; i >= 0; i-- )
			{
			   
			   if( ldd <= rates[i].time ){
			      //Print(TimeToString(rates[i].time));
   				lc[copied - i - 1].date		= date_mt2tdx_lc5_date( rates[i].time );
   				lc[copied - i - 1].time		= date_mt2tdx_lc5_time( rates[i].time );
   				lc[copied - i - 1].open		= rates[i].open * cs;
   				lc[copied - i - 1].high		= rates[i].high * cs;
   				lc[copied - i - 1].low		= rates[i].low * cs;
   				lc[copied - i - 1].close	= rates[i].close * cs;
   				lc[copied - i - 1].vol		= rates[i].tick_volume;
   				realsize++;
               
               /*        
   				string out=IntegerToString(i)+":" + IntegerToString(lc[copied - i - 1].date);
   				out=out+" "+StringFormat(format,
   				                        name,
   				                        lc[copied - i - 1].open,
   				                        lc[copied - i - 1].high,
   				                        lc[copied - i - 1].low,
   				                        lc[copied - i - 1].close,
   				                        lc[copied - i - 1].vol);
   				 Print(out);
				    */
				 }
				 
			}
		}else Print( "Failed to get history data for the symbol ", name );

      //Print(file + "/" + ldtdx + "/" + realsize);
		if( realsize > 0 ){
		   //ArrayResize( rd, realsize );
		   tdx_write_lc_data( file, lc, realsize );
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
