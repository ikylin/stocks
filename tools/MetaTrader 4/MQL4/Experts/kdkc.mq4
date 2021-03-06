/*
 * +------------------------------------------------------------------+
 * |                                                kdkc.mq4 |
 * |                      Copyright ?2007, MetaQuotes Software Corp. |
 * |                                        http://www.metaquotes.net |
 * +------------------------------------------------------------------+
 */
#property copyright "Copyright ?2007, MetaQuotes Software Corp."
#property link      "www.metaquotes.net"
extern double	Lots		= 1.0;
extern double	TakeProfit	= 5000;
extern double	TrailingStop	= 2000;
extern double	bsl	= 0.0;
extern double	btp	= 0.0;
extern double	MaxLots		= 7;
extern double	pips		= 7;

extern double	per_K		= 9;
extern double	per_D		= 5;
extern double	slow		= 5;
extern double	zoneBUY		= 20;
extern double	zoneSELL	= 80;



extern bool OPBUY=False;
extern bool OPSELL=False;
extern double Risk= 10;
extern double SL=26.0;
extern int Jumlah_OP=1;
double ModifyTP;
extern bool CloseALL=False;
extern int MagicNumber=333;
extern double AccountBalance=250.0;

int ticket;
int OpType;
double asbid,TP;
double RiskLoss;
double poen;


/*
 * +------------------------------------------------------------------+
 * | expert initialization function                                   |
 * +------------------------------------------------------------------+
 */
int init()
{
/* ---- */

/* ---- */
	return(0);
}


/*
 * +------------------------------------------------------------------+
 * | expert deinitialization function                                 |
 * +------------------------------------------------------------------+
 */
int deinit()
{
/* ---- */

/* ---- */
	return(0);
}


/*
 * +------------------------------------------------------------------+
 * | expert start function                                            |
 * +------------------------------------------------------------------+
 */
int start()
{
	double	total, Cena, cnt, lot;
	double	cenaoppos, l, sl;
	total = OrdersTotal();
	if ( total < 30 )
	{
		if ( iStochastic( NULL, 0, per_K, per_D, slow, MODE_LWMA, 1, 0, 1 ) > iStochastic( NULL, 0, per_K, per_D, slow, MODE_LWMA, 1, 1, 1 )
		     && iStochastic( NULL, 0, per_K, per_D, slow, MODE_LWMA, 1, 1, 1 ) < zoneBUY && iMA( NULL, 0, 5, 0, MODE_SMMA, PRICE_CLOSE, 1 ) < iClose(NULL,0,1))
		{
			sl = MaxLots * TrailingStop * Point + 20 * Point;
			OrderSend( Symbol(), OP_BUY, get_cw(), Ask, 3, bsl, btp, 0, Green );
		}
		
	}
}


double get_cw()
{
   if(Digits==2 || Digits==4) poen=Point;
   if(Digits==3 || Digits==5) poen=Point;

   double tick=MarketInfo(Symbol(),MODE_TICKVALUE);
   double minlot=MarketInfo(Symbol(),MODE_MINLOT);
   double maxlot=MarketInfo(Symbol(),MODE_MAXLOT);
   double spread=MarketInfo(Symbol(),MODE_SPREAD);

   RiskLoss=(Risk/100)*AccountBalance;

   Lots=RiskLoss/((MathAbs(SL-Ask)+spread)*tick);
//----
   if(OPBUY) { OpType=OP_BUY; asbid=Ask; if(TakeProfit>0) TP=NormalizeDouble(Ask+TakeProfit*poen,Digits); else TP=0;}
   if(OPSELL) { OpType=OP_SELL; asbid=Bid; if(TakeProfit>0) TP=NormalizeDouble(Bid-TakeProfit*poen,Digits); else TP=0;}

   double mylot;
   double newSL=SL+spread;

   //mylot=NormalizeDouble(Lots/Jumlah_OP,2);
   mylot=minlot*int(Lots/minlot);

   if(mylot<=minlot) mylot=minlot;
   if(mylot>=maxlot) mylot=maxlot;

   if(mylot<minlot)
     {
      Print("not enough money....");
      Comment("\n\nNot enough money....");
      return(0);
     }
   Print(mylot);
   return mylot;
}