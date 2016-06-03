//+------------------------------------------------------------------+
//|                                                   symbolinfo.mq4 |
//|                        Copyright 2016, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2016, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input string	InpFileName		= "symbol_info_cw.csv";   /* File name */
input string	InpDirectoryName	= "Data";       /* Folder name */
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{
   gen_symbol_info_csv();
}



void symbol_info()
  {
  
//---
   
   ResetLastError();
	int file_handle = FileOpen( InpDirectoryName + "//" + InpFileName, FILE_READ | FILE_WRITE | FILE_TXT );
	if ( file_handle != INVALID_HANDLE )
	{
	
FileWrite( file_handle,"Symbol",",","EURUSD");
FileWrite( file_handle,"Low day price",",",MarketInfo("EURUSD",MODE_LOW));
FileWrite( file_handle,"High day price",",",MarketInfo("EURUSD",MODE_HIGH));
FileWrite( file_handle,"The last incoming tick time",",",(MarketInfo("EURUSD",MODE_TIME)));
FileWrite( file_handle,"Last incoming bid price",",",MarketInfo("EURUSD",MODE_BID));
FileWrite( file_handle,"Last incoming ask price",",",MarketInfo("EURUSD",MODE_ASK));
FileWrite( file_handle,"Point size in the quote currency",",",MarketInfo("EURUSD",MODE_POINT));
FileWrite( file_handle,"Digits after decimal point",",",MarketInfo("EURUSD",MODE_DIGITS));
FileWrite( file_handle,"Spread value in points",",",MarketInfo("EURUSD",MODE_SPREAD));
FileWrite( file_handle,"Stop level in points",",",MarketInfo("EURUSD",MODE_STOPLEVEL));
FileWrite( file_handle,"Lot size in the base currency",",",MarketInfo("EURUSD",MODE_LOTSIZE));
FileWrite( file_handle,"Tick value in the deposit currency",",",MarketInfo("EURUSD",MODE_TICKVALUE));
FileWrite( file_handle,"Tick size in points",",",MarketInfo("EURUSD",MODE_TICKSIZE)); 
FileWrite( file_handle,"Swap of the buy order",",",MarketInfo("EURUSD",MODE_SWAPLONG));
FileWrite( file_handle,"Swap of the sell order",",",MarketInfo("EURUSD",MODE_SWAPSHORT));
FileWrite( file_handle,"Market starting date (for futures)",",",MarketInfo("EURUSD",MODE_STARTING));
FileWrite( file_handle,"Market expiration date (for futures)",",",MarketInfo("EURUSD",MODE_EXPIRATION));
FileWrite( file_handle,"Trade is allowed for the symbol",",",MarketInfo("EURUSD",MODE_TRADEALLOWED));
FileWrite( file_handle,"Minimum permitted amount of a lot",",",MarketInfo("EURUSD",MODE_MINLOT));
FileWrite( file_handle,"Step for changing lots",",",MarketInfo("EURUSD",MODE_LOTSTEP));
FileWrite( file_handle,"Maximum permitted amount of a lot",",",MarketInfo("EURUSD",MODE_MAXLOT));
FileWrite( file_handle,"Swap calculation method",",",MarketInfo("EURUSD",MODE_SWAPTYPE));
FileWrite( file_handle,"Profit calculation mode",",",MarketInfo("EURUSD",MODE_PROFITCALCMODE));
FileWrite( file_handle,"Margin calculation mode",",",MarketInfo("EURUSD",MODE_MARGINCALCMODE));
FileWrite( file_handle,"Initial margin requirements for 1 lot",",",MarketInfo("EURUSD",MODE_MARGININIT));
FileWrite( file_handle,"Margin to maintain open orders calculated for 1 lot",",",MarketInfo("EURUSD",MODE_MARGINMAINTENANCE));
FileWrite( file_handle,"Hedged margin calculated for 1 lot",",",MarketInfo("EURUSD",MODE_MARGINHEDGED));
FileWrite( file_handle,"Free margin required to open 1 lot for buying",",",MarketInfo("EURUSD",MODE_MARGINREQUIRED));
FileWrite( file_handle,"Order freeze level in points",",",MarketInfo("EURUSD",MODE_FREEZELEVEL)); 

FileWrite( file_handle,"SYMBOL_SELECT",",",SymbolInfoInteger("EURUSD",SYMBOL_SELECT)); 
FileWrite( file_handle,"SYMBOL_VISIBLE",",",SymbolInfoInteger("EURUSD",SYMBOL_VISIBLE)); 
FileWrite( file_handle,"SYMBOL_SESSION_DEALS",",",SymbolInfoInteger("EURUSD",SYMBOL_SESSION_DEALS)); 
FileWrite( file_handle,"SYMBOL_SESSION_BUY_ORDERS",",",SymbolInfoInteger("EURUSD",SYMBOL_SESSION_BUY_ORDERS)); 
FileWrite( file_handle,"SYMBOL_SESSION_SELL_ORDERS",",",SymbolInfoInteger("EURUSD",SYMBOL_SESSION_SELL_ORDERS)); 
FileWrite( file_handle,"SYMBOL_VOLUME",",",SymbolInfoInteger("EURUSD",SYMBOL_VOLUME)); 
FileWrite( file_handle,"SYMBOL_VOLUMEHIGH",",",SymbolInfoInteger("EURUSD",SYMBOL_VOLUMEHIGH)); 
FileWrite( file_handle,"SYMBOL_VOLUMELOW",",",SymbolInfoInteger("EURUSD",SYMBOL_VOLUMELOW)); 
FileWrite( file_handle,"SYMBOL_TIME",",",SymbolInfoInteger("EURUSD",SYMBOL_TIME)); 
FileWrite( file_handle,"SYMBOL_DIGITS",",",SymbolInfoInteger("EURUSD",SYMBOL_DIGITS)); 
FileWrite( file_handle,"SYMBOL_SPREAD_FLOAT",",",SymbolInfoInteger("EURUSD",SYMBOL_SPREAD_FLOAT)); 
FileWrite( file_handle,"SYMBOL_SPREAD",",",SymbolInfoInteger("EURUSD",SYMBOL_SPREAD)); 
FileWrite( file_handle,"SYMBOL_TRADE_CALC_MODE",",",SymbolInfoInteger("EURUSD",SYMBOL_TRADE_CALC_MODE)); 
FileWrite( file_handle,"SYMBOL_TRADE_MODE",",",SymbolInfoInteger("EURUSD",SYMBOL_TRADE_MODE)); 
FileWrite( file_handle,"SYMBOL_START_TIME",",",SymbolInfoInteger("EURUSD",SYMBOL_START_TIME)); 
FileWrite( file_handle,"SYMBOL_EXPIRATION_TIME",",",SymbolInfoInteger("EURUSD",SYMBOL_EXPIRATION_TIME)); 
FileWrite( file_handle,"SYMBOL_TRADE_STOPS_LEVEL",",",SymbolInfoInteger("EURUSD",SYMBOL_TRADE_STOPS_LEVEL)); 
FileWrite( file_handle,"SYMBOL_TRADE_FREEZE_LEVEL",",",SymbolInfoInteger("EURUSD",SYMBOL_TRADE_FREEZE_LEVEL)); 
FileWrite( file_handle,"SYMBOL_TRADE_EXEMODE",",",SymbolInfoInteger("EURUSD",SYMBOL_TRADE_EXEMODE)); 
FileWrite( file_handle,"SYMBOL_SWAP_MODE",",",SymbolInfoInteger("EURUSD",SYMBOL_SWAP_MODE)); 
FileWrite( file_handle,"SYMBOL_SWAP_ROLLOVER3DAYS",",",SymbolInfoInteger("EURUSD",SYMBOL_SWAP_ROLLOVER3DAYS)); 
FileWrite( file_handle,"SYMBOL_EXPIRATION_MODE",",",SymbolInfoInteger("EURUSD",SYMBOL_EXPIRATION_MODE)); 
FileWrite( file_handle,"SYMBOL_FILLING_MODE",",",SymbolInfoInteger("EURUSD",SYMBOL_FILLING_MODE)); 
FileWrite( file_handle,"SYMBOL_ORDER_MODE",",",SymbolInfoInteger("EURUSD",SYMBOL_ORDER_MODE)); 


FileWrite( file_handle,"SYMBOL_BID",",",SymbolInfoDouble("EURUSD",SYMBOL_BID)); 
FileWrite( file_handle,"SYMBOL_BIDHIGH",",",SymbolInfoDouble("EURUSD",SYMBOL_BIDHIGH)); 
FileWrite( file_handle,"SYMBOL_BIDLOW",",",SymbolInfoDouble("EURUSD",SYMBOL_BIDLOW)); 
FileWrite( file_handle,"SYMBOL_ASK",",",SymbolInfoDouble("EURUSD",SYMBOL_ASK)); 
FileWrite( file_handle,"SYMBOL_ASKHIGH",",",SymbolInfoDouble("EURUSD",SYMBOL_ASKHIGH)); 
FileWrite( file_handle,"SYMBOL_ASKLOW",",",SymbolInfoDouble("EURUSD",SYMBOL_ASKLOW)); 
FileWrite( file_handle,"SYMBOL_LAST",",",SymbolInfoDouble("EURUSD",SYMBOL_LAST)); 
FileWrite( file_handle,"SYMBOL_LASTHIGH",",",SymbolInfoDouble("EURUSD",SYMBOL_LASTHIGH)); 
FileWrite( file_handle,"SYMBOL_LASTLOW",",",SymbolInfoDouble("EURUSD",SYMBOL_LASTLOW)); 
FileWrite( file_handle,"SYMBOL_POINT",",",SymbolInfoDouble("EURUSD",SYMBOL_POINT)); 
FileWrite( file_handle,"SYMBOL_TRADE_TICK_VALUE",",",SymbolInfoDouble("EURUSD",SYMBOL_TRADE_TICK_VALUE)); 
FileWrite( file_handle,"SYMBOL_TRADE_TICK_VALUE_PROFIT",",",SymbolInfoDouble("EURUSD",SYMBOL_TRADE_TICK_VALUE_PROFIT)); 
FileWrite( file_handle,"SYMBOL_TRADE_TICK_VALUE_LOSS",",",SymbolInfoDouble("EURUSD",SYMBOL_TRADE_TICK_VALUE_LOSS)); 
FileWrite( file_handle,"SYMBOL_TRADE_TICK_SIZE",",",SymbolInfoDouble("EURUSD",SYMBOL_TRADE_TICK_SIZE)); 
FileWrite( file_handle,"SYMBOL_TRADE_CONTRACT_SIZE",",",SymbolInfoDouble("EURUSD",SYMBOL_TRADE_CONTRACT_SIZE)); 
FileWrite( file_handle,"SYMBOL_VOLUME_MIN",",",SymbolInfoDouble("EURUSD",SYMBOL_VOLUME_MIN)); 
FileWrite( file_handle,"SYMBOL_VOLUME_MAX",",",SymbolInfoDouble("EURUSD",SYMBOL_VOLUME_MAX)); 
FileWrite( file_handle,"SYMBOL_VOLUME_STEP",",",SymbolInfoDouble("EURUSD",SYMBOL_VOLUME_STEP)); 
FileWrite( file_handle,"SYMBOL_VOLUME_LIMIT",",",SymbolInfoDouble("EURUSD",SYMBOL_VOLUME_LIMIT)); 
FileWrite( file_handle,"SYMBOL_SWAP_LONG",",",SymbolInfoDouble("EURUSD",SYMBOL_SWAP_LONG)); 
FileWrite( file_handle,"SYMBOL_SWAP_SHORT",",",SymbolInfoDouble("EURUSD",SYMBOL_SWAP_SHORT)); 
FileWrite( file_handle,"SYMBOL_MARGIN_INITIAL",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_INITIAL)); 
FileWrite( file_handle,"SYMBOL_MARGIN_MAINTENANCE",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_MAINTENANCE)); 
FileWrite( file_handle,"SYMBOL_MARGIN_LONG",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_LONG)); 
FileWrite( file_handle,"SYMBOL_MARGIN_SHORT",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_SHORT)); 
FileWrite( file_handle,"SYMBOL_MARGIN_LIMIT",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_LIMIT)); 
FileWrite( file_handle,"SYMBOL_MARGIN_STOP",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_STOP)); 
FileWrite( file_handle,"SYMBOL_MARGIN_STOPLIMIT",",",SymbolInfoDouble("EURUSD",SYMBOL_MARGIN_STOPLIMIT)); 
FileWrite( file_handle,"SYMBOL_SESSION_VOLUME",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_VOLUME)); 
FileWrite( file_handle,"SYMBOL_SESSION_TURNOVER",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_TURNOVER)); 
FileWrite( file_handle,"SYMBOL_SESSION_INTEREST",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_INTEREST)); 
FileWrite( file_handle,"SYMBOL_SESSION_BUY_ORDERS_VOLUME",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_BUY_ORDERS_VOLUME)); 
FileWrite( file_handle,"SYMBOL_SESSION_SELL_ORDERS_VOLUME",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_SELL_ORDERS_VOLUME)); 
FileWrite( file_handle,"SYMBOL_SESSION_OPEN",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_OPEN)); 
FileWrite( file_handle,"SYMBOL_SESSION_CLOSE",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_CLOSE)); 
FileWrite( file_handle,"SYMBOL_SESSION_AW",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_AW)); 
FileWrite( file_handle,"SYMBOL_SESSION_PRICE_SETTLEMENT",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_PRICE_SETTLEMENT)); 
FileWrite( file_handle,"SYMBOL_SESSION_PRICE_LIMIT_MIN",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_PRICE_LIMIT_MIN)); 
FileWrite( file_handle,"SYMBOL_SESSION_PRICE_LIMIT_MAX",",",SymbolInfoDouble("EURUSD",SYMBOL_SESSION_PRICE_LIMIT_MAX)); 


FileWrite( file_handle,"SYMBOL_CURRENCY_BASE",",",SymbolInfoString("EURUSD",SYMBOL_CURRENCY_BASE)); 
FileWrite( file_handle,"SYMBOL_CURRENCY_PROFIT",",",SymbolInfoString("EURUSD",SYMBOL_CURRENCY_PROFIT)); 
FileWrite( file_handle,"SYMBOL_CURRENCY_MARGIN",",",SymbolInfoString("EURUSD",SYMBOL_CURRENCY_MARGIN)); 
FileWrite( file_handle,"SYMBOL_DESCRIPTION",",",SymbolInfoString("EURUSD",SYMBOL_DESCRIPTION)); 
FileWrite( file_handle,"SYMBOL_PATH",",",SymbolInfoString("EURUSD",SYMBOL_PATH)); 



   

	}else
		PrintFormat( "Failed to open %s file, Error code = %d", InpFileName, GetLastError() );

  }
//+------------------------------------------------------------------+


void gen_symbol_info_csv(){

	ResetLastError();
	int file_handle = FileOpen( InpDirectoryName + "//" + InpFileName, FILE_READ | FILE_WRITE | FILE_TXT );
	if ( file_handle != INVALID_HANDLE )
	{
		
		
		FileWrite( file_handle, "name", ",", "spread", ",", "lotsize", ",", "tickvalue", ",", "ticksize", ",", "minlot", ",", "maxlot", ",", "margin" );
      int num = SymbolsTotal( false );
   	for ( int i = 1; i <= num; i++ )
   	{
   		string name = SymbolName( i - 1, false );
   		
         double spread=MarketInfo(name,MODE_SPREAD);
         double lotsize=MarketInfo(name,MODE_LOTSIZE);
         double tickvalue=MarketInfo(name,MODE_TICKVALUE);
         double ticksize=MarketInfo(name,MODE_TICKSIZE);
         double minlot=MarketInfo(name,MODE_MINLOT);
         double maxlot=MarketInfo(name,MODE_MAXLOT);
         double margin=MarketInfo(name,MODE_MARGINREQUIRED);
         
         FileWrite( file_handle, name, ",", spread, ",", lotsize, ",", tickvalue, ",", ticksize, ",", minlot, ",", maxlot, ",", margin );
      
   	}

	}else
		PrintFormat( "Failed to open %s file, Error code = %d", InpFileName, GetLastError() );
		
}