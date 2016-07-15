
//+------------------------------------------------------------------+
//|                                                      CCTimeX.mq4 |
//|                                       Copyright © 2015, Barmaley |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright ""
#property link      ""
//---
#property indicator_chart_window
//---
int ts=12;
int PP;
int X0;
int Y0;
//---
string PPS;
int TFCount=0;
int TFSX[50];
//---
int ServerTimeOffset=0;// Смещение времени сервера относительно локального времени компьютера
extern string TFS="  1 5 15 20 30 60 240 480 1440 ";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


bool check_manual_follow(string symbolname){
   bool check = false;
   
   string mfl[] = {
   //"ZARJPYpro",
   "XAUUSDpro",
   //"XAUJPYpro",
   //"XAUGBPpro",
   //"XAUEURpro",
   //"XAUCHFpro",
   //"XAUAUDpro",
   "XAGUSDpro",
   //"WHEAT",
   "US_OIL",
   //"US_NATG",
   //"USDZARpro",
   //"USDTRYpro",
   //"USDSGDpro",
   //"USDSEKpro",
   //"USDRUBpro",
   //"USDPLNpro",
   //"USDNOKpro",
   //"USDMXNpro",
   //"USDJPYpro",
   //"USDJPY",
   //"USDHUFpro",
   //"USDHKD",
   //"USDDKKpro",
   //"USDCZKpro",
   "USDCNHpro",
   //"USDCHFpro",
   //"USDCHF",
   //"USDCADpro",
   //"USDCAD",
   //"US30",
   //"UK_OIL",
   "UK100",
   "SUGAR",
   //"SPX500",
   //"SOYBEAN",
   //"SGDJPYpro",
   "PLAT",
   "PALLAD",
   //"NZDUSDpro",
   //"NZDUSD",
   //"NZDJPYpro",
   //"NZDCHFpro",
   //"NZDCADpro",
   //"NAS100",
   //"JPN225",
   //"HTG_OIL",
   //"HK50",
   //"GER30",
   //"GBPUSDpro",
   //"GBPUSD",
   //"GBPNZDpro",
   //"GBPJPYpro",
   //"GBPCHFpro",
   //"GBPCADpro",
   //"GBPAUDpro",
   //"FRA40",
   //"EURUSDpro",
   //"EURUSD",
   //"EURTRYpro",
   //"EURSEKpro",
   //"EURPLNpro",
   //"EURNZDpro",
   //"EURNOKpro",
   //"EURJPYpro",
   //"EURHUFpro",
   //"EURGBPpro",
   //"EURDKKpro",
   //"EURCZKpro",
   //"EURCHFpro",
   //"EURCADpro",
   //"EURAUDpro",
   //"ESTX50",
   "COTTON",
   "CORN",
   "COPPER",
   //"CHFJPYpro",
   //"CADJPYpro",
   //"CADCHFpro",
   //"AUS200",
   //"AUDUSDpro",
   //"AUDUSD",
   //"AUDNZDpro",
   //"AUDJPYpro",
   "AUDCHFpro"
   //"AUDCADpro",


   };
   for(int i = 0; i < ArraySize(mfl); i++){
      if(symbolname == mfl[i]){
         check = true;
         break;
      }
   }
   
   return check;
}


int OnInit()
  {
   //print_symbol_list();
   string list = "";
   get_signs(list);
   //open_charts(PERIOD_W1);
   //open_charts(PERIOD_H4);
   //open_charts(PERIOD_M5);
  
  

   string s="ServerTime";

   ObjectCreate(s,OBJ_LABEL,0,0,0,0,0,0,0);
   ObjectSetText(s,"");
   X0=ChartGetInteger(0,CHART_WIDTH_IN_PIXELS)/2;
   Y0=ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS)/9;
   ObjectSet(s,OBJPROP_XDISTANCE,X0);
   ObjectSet(s,OBJPROP_YDISTANCE,Y0);

   s="";
   int i=0;
   int n=StringLen(TFS);
   //--- Удаление лишних символов из списка таймфреймов, остаются только цифры и пробелы
   for(i=0;i<=n-1;i++)
     {
      int k=StringGetCharacter(TFS,i);
      string ss=StringSubstr(TFS,i,1);
      if(ss==" " || (k>=48 && k<=57)) s=s+ss;
     }
   //---
   TFS=s+" "; s="";
   //--- Обработка списка таймфреймов	  
   while(true)
     {
      i=StringFind(TFS," ");
      if(i<0) break;
      //---
      n=StringLen(TFS);
      if(i==0) TFS=StringSubstr(TFS,1,n-1);
      else
        {
         ss=StringSubstr(TFS,0,i+1);
         k=(int)ss;
         if(k<=1440)
            if((k<=60 && MathMod(60,k)==0) || (k>60 && MathMod(1440,k)==0))// Проверка ТФ на корректность
              {
               TFSX[TFCount]=(int)ss;
               TFCount++;
              }
         //---
         TFS=StringSubstr(TFS,i,1000);
        }
     }
   //---
   if(TFCount==0) {TFCount++; TFSX[0]=_Period;} // Пустой список = текущий таймфрейм
   //---
   for(i=0;i<=TFCount-1;i++)
     {
      s="ServerTime"+(string)i;
      ObjectCreate(s,OBJ_LABEL,0,0,0,0,0,0,0);
      ObjectSetText(s,"");
      s="ServerTime"+(string)i+(string)i;
      ObjectCreate(s,OBJ_LABEL,0,0,0,0,0,0,0);
      ObjectSetText(s,"");
     }
   //---
   EventSetTimer(1);
   //print_symbol_list();
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   string s="ServerTime";
   //---
   if( reason==REASON_CHARTCHANGE || reason==REASON_PARAMETERS) return;
   //---
   ObjectDelete(s);
   //---
   for(int i=0;i<=TFCount-1;i++)
     {
      s="ServerTime"+(string)i+(string)i;
      ObjectDelete(s);
      //---
      s="ServerTime"+(string)i;
      ObjectDelete(s);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
   //--- Смещение времени сервера относительно локального времени компьютера   
   if(MarketInfo(_Symbol,MODE_TRADEALLOWED)>0) ServerTimeOffset=TimeCurrent()-TimeLocal();
   //---
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTimer()
  {
   //--- Положение синих часов
   int x=ObjectGet("ServerTime",OBJPROP_XDISTANCE);
   int y=ObjectGet("ServerTime",OBJPROP_YDISTANCE);
   ts=ObjectGet("ServerTime",OBJPROP_FONTSIZE);
   //---
   datetime tt=TimeLocal()+ServerTimeOffset;
   //--- Серверное время
   ObjectSetText("ServerTime",TimeToStr(tt,TIME_SECONDS),ts,"Courier New",clrRoyalBlue);
   //--- Таймеры баров
   for(int i=0;i<=TFCount-1;i++)
     {
      PP=TFSX[i];
      //---
      PPS="M"+(string)PP;
      if(PP==1440) PPS="D1";
      else if(PP>=60) PPS="H"+(string)(PP/60);
      //---
      //int n=tt/PP/60;
      //datetime it=n*PP*60;
      //datetime t=PP*60-tt+it;
      
      datetime t = get_close_seconds_left(TFSX[i]);
      
      //---
      string s="ServerTime"+(string)i+(string)i;
      ObjectSetText(s,TimeToStr(t,TIME_SECONDS),ts,"Courier New",clrRed);
      ObjectSet(s,OBJPROP_XDISTANCE,x);
      ObjectSet(s,OBJPROP_YDISTANCE,y+(ts+5)*(i+1));
      //---
      s="ServerTime"+(string)i;
      ObjectSetText(s,PPS,ts,"Courier New",clrRed);
      ObjectSet(s,OBJPROP_XDISTANCE,x-ts*5);
      ObjectSet(s,OBJPROP_YDISTANCE,y+(ts+5)*(i+1));
     }
  }
  
datetime get_close_seconds_left(int period){
   int PP = period;
   datetime tt=TimeLocal()+ServerTimeOffset;
   int n=tt/PP/60;
   datetime it=n*PP*60;
   datetime t=PP*60-tt+it;
   check_actions(period, (int)t);
   return t;
}

bool isCheckSignal(int period){
   int check_period_list[] = {
      //PERIOD_M1, 
      //PERIOD_M5, 
      //PERIOD_M15, 
      //PERIOD_M30, 
      //PERIOD_H1, 
      PERIOD_H4, 
      //PERIOD_D1, 
      //PERIOD_W1, 
      //PERIOD_MN1
   };
   bool check = false;

   for(int i = 0; i < ArraySize(check_period_list); i++){
      if(period == check_period_list[i]){
         check = true;
      }
   }
   
   return check;
}


bool isCheckTrend(int period){
   bool check = false;
   
   if(period == PERIOD_D1){
      check = true;
   }
   
   return check;
}

bool isDataReady(int leftseconds){
   bool ready = false;
   
   if(leftseconds == 3){
      ready = true;
   }
   
   return ready;
}

void check_actions(int period, int leftseconds){
   string symbolList = "";
   if(isCheckSignal(period) && isDataReady(leftseconds)){
      symbolList = "Signal list:";
      if(get_signs(symbolList)){
         SendMail("Signal" + symbolList, symbolList);
      }
      Print(symbolList);
   }
   
   if(isCheckTrend(period) && isDataReady(leftseconds)){
      symbolList = "Trend list:";
      if(get_trends(symbolList)){
         SendMail("Trend" + symbolList, symbolList);
      }
      Print(symbolList);
   }
}

void print_symbol_list(){
   int num = SymbolsTotal( false );

	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );
      Print(i + " : " + name);
	}
}

bool get_trends(string& symbolList){
   int num = SymbolsTotal( false );
   //string symbolList = "Trend list:";
   bool has = false;

	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );

      int sign = check_trend(name);
      Print("Trend  " + name + ":" + IntegerToString(sign));
      if(sign == 1){
         symbolList = symbolList + name + "/";
         has = true;
      }
	}
	
	return has;
}

bool check_date(datetime last_day){
   return (Year()==TimeYear(last_day) && Month()==TimeMonth(last_day) && Day()==TimeDay(last_day));
}


int get_symbol_period_data(string symbol, int period, int atemptnum){
   datetime daytimes[];
   double opens[];
   double highs[];
   double lows[];
   double closes[];
   long volumes[];
   int error;
   datetime last_day = D'1980.01.01 00:00';
   
   int copied1, copied2, copied3, copied4, copied5, copied6;
   
   //---- the Time[] array was sroted in the descending order
   copied1 = ArrayCopySeries(daytimes,MODE_TIME,symbol,period);
   copied2 = ArrayCopySeries(opens,MODE_OPEN,symbol,period);
   copied3 = ArrayCopySeries(lows,MODE_LOW,symbol,period);
   copied4 = ArrayCopySeries(highs,MODE_HIGH,symbol,period);
   copied5 = ArrayCopySeries(closes,MODE_CLOSE,symbol,period);
   copied6 = ArrayCopySeries(volumes,MODE_VOLUME,symbol,period);
   
   error=GetLastError();
   if(error==ERR_HISTORY_WILL_UPDATED )
     {
      //---- make two more attempts to read
      for(int i=0;i<atemptnum; i++)
        {
         Sleep(5000);
         copied1 = ArrayCopySeries(daytimes,MODE_TIME,symbol,period);
         copied2 = ArrayCopySeries(opens,MODE_OPEN,symbol,period);
         copied3 = ArrayCopySeries(lows,MODE_LOW,symbol,period);
         copied4 = ArrayCopySeries(highs,MODE_HIGH,symbol,period);
         copied5 = ArrayCopySeries(closes,MODE_CLOSE,symbol,period);
         copied6 = ArrayCopySeries(volumes,MODE_VOLUME,symbol,period);
         //---- check the current daily bar time
         last_day=daytimes[0];
         if(check_date(last_day)) break;
        }
     }
     
   PrintFormat("%s / %d : %d, %d, %d, %d, %d, %d", symbol, period, copied1, copied2, copied3, copied4, copied5, copied6);
     
   return copied1 + copied2 + copied3 + copied4 + copied5 + copied6;
     
   //return check_date(last_day);
}

int check_trend(string symbolname){

   if(check_manual_follow(symbolname)){
      return true;
   }
   
   int sign = 0;
   
   double close_D1_buf[];
   double close_W1_buf[];
   double close_MN1_buf[];
   datetime tm_buf[];
   int num = 100;
   ArrayResize(close_D1_buf, num);
   ArrayResize(close_W1_buf, num);
   ArrayResize(close_MN1_buf, num);
   ArrayResize(tm_buf, num);
   ArraySetAsSeries(close_D1_buf, true);
   ArraySetAsSeries(close_W1_buf, true);
   ArraySetAsSeries(close_MN1_buf, true);
   ArraySetAsSeries(tm_buf, true);
   
   RefreshRates();
   
   
   int copied = CopyTime(symbolname, PERIOD_D1, 0, num, tm_buf);
   copied = CopyClose(symbolname, PERIOD_D1, 0, num, close_D1_buf);
   copied = CopyClose(symbolname, PERIOD_W1, 0, num, close_W1_buf);
   copied = CopyClose(symbolname, PERIOD_MN1, 0, num, close_MN1_buf);
   
   
   double ma_d1_30,
   ma_w1_30,
   ma_mn_30,
   ma_d1_30_pre,
   ma_w1_30_pre,
   ma_mn_30_pre;
   
   get_symbol_period_data(symbolname, PERIOD_D1, 5);
   get_symbol_period_data(symbolname, PERIOD_W1, 5);
   get_symbol_period_data(symbolname, PERIOD_MN1, 5);
   
   
   ma_d1_30	= iMA( symbolname, PERIOD_D1, 30, 0, MODE_SMA, PRICE_CLOSE, 1 );
   ma_w1_30	= iMA( symbolname, PERIOD_W1, 30, 0, MODE_SMA, PRICE_CLOSE, 1 );
   ma_mn_30	= iMA( symbolname, PERIOD_MN1, 30, 0, MODE_SMA, PRICE_CLOSE, 1 );
   
   ma_d1_30_pre	= iMA( symbolname, PERIOD_D1, 30, 0, MODE_SMA, PRICE_CLOSE, 2 );
   ma_w1_30_pre	= iMA( symbolname, PERIOD_W1, 30, 0, MODE_SMA, PRICE_CLOSE, 2 );
   ma_mn_30_pre	= iMA( symbolname, PERIOD_MN1, 30, 0, MODE_SMA, PRICE_CLOSE, 2 );
   
   //PrintFormat("check_trend %s : %f, %f, %f, %f, %f, %f - %s", symbolname, ma_d1_30, ma_w1_30, ma_mn_30, ma_d1_30_pre, ma_w1_30_pre, ma_mn_30_pre, TimeToStr(tm_buf[0], TIME_DATE|TIME_MINUTES));
   
   if(ma_d1_30 > ma_d1_30_pre && ma_w1_30 > ma_w1_30_pre && ma_mn_30 > ma_mn_30_pre){
      sign = 1;
      //PrintFormat("%s", symbolname);
   }
   
   return sign;
}

int check_signal(string symbolname, ENUM_TIMEFRAMES timeframe){
   int sign = 0;
   int dateIndex = 0;
   
   datetime tm_buf[];
   int num = 100;
   ArrayResize(tm_buf, num);
   ArraySetAsSeries(tm_buf, true);
   
   RefreshRates();
   
   int copied = CopyTime(symbolname, timeframe, 0, num, tm_buf);
   
   double close,
   k,
   d,
   ma5;
   
   close = iClose(symbolname,timeframe,dateIndex);
	k	= iStochastic( symbolname, timeframe, 9, 5, 5, MODE_SMA, 0, MODE_MAIN, dateIndex );
	d	= iStochastic( symbolname, timeframe, 9, 5, 5, MODE_SMA, 0, MODE_SIGNAL, dateIndex );
	ma5	= iMA( symbolname, timeframe, 5, 0, MODE_SMA, PRICE_CLOSE, dateIndex );

   if(k < 20 && d < 20 && close>ma5){
      sign = 1;
   }
   PrintFormat("check_signal %s : %d - %f, %f, %f, %f - %s", symbolname, sign, close, k, d, ma5, TimeToStr(tm_buf[0], TIME_DATE|TIME_MINUTES));
   
   return sign;
}


int get_sign(string symbolname, ENUM_TIMEFRAMES timeframe){
	int sign = 0;            /* signal array (true - buy, false - sell) */
	
	//if(check_signal(symbolname, timeframe) == 1){
	if(check_trend(symbolname) == true && check_signal(symbolname, timeframe) == 1){
	   sign = 1;
	}

   return sign;
}

bool get_signs(string& symbolList)
{
	int num = SymbolsTotal( false );
	//string symbolList = "Signal List:"
   bool has = false;
   
	int sdindex = 0;
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
      int sign = get_sign(name, PERIOD_H4);
      //Print("Signal  " + name + ":" + IntegerToString(sign));
      if(sign == 1){
         symbolList = symbolList + name + "/";
         has = true;
      }
      
      //get_sign(name, PERIOD_D1);
      
      //get_sign(name, PERIOD_W1, sds[sdindex++]);
      //get_sign(name, PERIOD_MN1, sds[sdindex++]);
	}
	
	return has;
}


void open_charts(int period)
{
	int num = SymbolsTotal( false );
	//string symbolList = "Signal List:"
   bool has = false;
   
	int sdindex = 0;
	for ( int i = 1; i <= num; i++ )
	{
		string name = SymbolName( i - 1, false );
		ChartOpen(name, period);
	}
}


  
//+------------------------------------------------------------------+