//+------------------------------------------------------------------+
//|                                                                  |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property description "Buys or sells when current MA goes above or below previous MA."
#property description "This will only buy, sell, or close at the beginning of a new bar."
#property description "Try it on Daily bars with the default settings, for a trendy pair."
//----
extern double Leverage_Per_Position=10;
extern bool Average_Up=false;
extern bool Average_Down=false;
extern double StopLoss_Percent=0;
extern double TakeProfit_Percent=0;
extern int Minimum_Free_Equity_Percent=50;
extern int Slippage=10;
extern ENUM_TIMEFRAMES MA_Timeframe_Previous=1440;
extern ENUM_TIMEFRAMES MA_Timeframe_Current=1440;
extern int MA_Period_Previous_Add=10;
extern int MA_Period_Current=42;
extern int MA_Shift_Previous=2;
extern int MA_Shift_Current=0;
extern ENUM_MA_METHOD MA_Method=0;
extern ENUM_APPLIED_PRICE MA_Applied_Price=1;

int effectiveLeverage=Leverage_Per_Position;
double StopLoss=0;
double TakeProfit=0;
double scaledSl = 0;
double scaledTp = 0;
double sl = 0;
double tp = 0;
double freeEquityFactor=100;
datetime lastBarTime=Time[0];
int MA_Period_Previous=1440;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void init()
  {
   MA_Period_Previous=MA_Period_Current+MA_Period_Previous_Add;
   if(StopLoss_Percent>0)
     {
      StopLoss=StopLoss_Percent/100;
     }
   if(TakeProfit_Percent>0)
     {
      TakeProfit=TakeProfit_Percent/100;
     }
   if(Minimum_Free_Equity_Percent>0)
     {
      freeEquityFactor=NormalizeDouble(Minimum_Free_Equity_Percent,2)/100;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void NormalizeExits()
  {
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol())
        {
         double ret=OrderModify(OrderTicket(),OrderOpenPrice(),sl,tp,0);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CloseOrders(int Type)
  {
   int ticket,i;
   bool Result;
//----
   Result=True;
   if(OrdersTotal()>0)
     {
      for(i=0;i<OrdersTotal();i++)
        {
         ticket=OrderSelect(i,SELECT_BY_POS);
         if(OrderType()==Type)
           {
            if(Type==OP_BUY)
              {
               if(OrderClose(OrderTicket(),OrderLots(),Bid,Slippage)==false)
                 {
                  Result=false;
                  Print(GetLastError());
                 }
              }
            if(Type==OP_SELL)
              {
               if(OrderClose(OrderTicket(),OrderLots(),Ask,Slippage)==false)
                 {
                  Result=false;
                  Print(GetLastError());
                 }
              }
           }
         else
           {
            Result=(false || Average_Up || Average_Down);
           }
        }
     }
   return(Result);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsNewBar()
  {
   bool output=false;
   if(lastBarTime!=Time[0])
     {
      lastBarTime=Time[0];
      output=true;
     }
   return output;
  }
//+------------------------------------------------------------------+
//|Gets the highest price paid for any order on the given pair.      |
//+------------------------------------------------------------------+
double PairHighestPricePaid(string symbol)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         if(num==0 || OrderOpenPrice()>num)
           {
            num=OrderOpenPrice();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|Gets the lowest price paid for any order on the given pair.       |
//+------------------------------------------------------------------+
double PairLowestPricePaid(string symbol)
  {
   double num=0;
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==symbol && (OrderType()==OP_BUY || OrderType()==OP_SELL))
        {
         if(num==0 || OrderOpenPrice()<num)
           {
            num=OrderOpenPrice();
           }
        }
     }
   return num;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsNewBar())
     {
      return;
     }
   if(Bars<MA_Period_Current)
     {
      Print("bars less than MA_Period_Current. Waiting for more history.");
      return;
     }
   if(Bars<MA_Period_Previous)
     {
      Print("bars less than MA_Period_Previous. Waiting for more history.");
      return;
     }

   effectiveLeverage=OrdersTotal()*Leverage_Per_Position;

   int ticket;
   string symbol=Symbol();

   double MA=iMA(symbol,MA_Timeframe_Current,MA_Period_Current,MA_Shift_Current,MA_Method,MA_Applied_Price,0);
   double MAPrev=iMA(symbol,MA_Timeframe_Previous,MA_Period_Previous,MA_Shift_Previous,MA_Method,MA_Applied_Price,0);
   double minLots = MarketInfo(symbol,MODE_MINLOT);
   double maxLots = MarketInfo(symbol,MODE_MAXLOT);
   double lotStep = MarketInfo(symbol,MODE_LOTSTEP);
   double stopLevel=MarketInfo(symbol,MODE_STOPLEVEL)*Point;
   double Lots=NormalizeDouble(AccountBalance()/100000,2)*Leverage_Per_Position;
   double modLots=NormalizeDouble(Lots-MathMod(Lots,lotStep),2);
   double minMargin=AccountBalance()*freeEquityFactor;

   if(modLots>0)
     {
      Lots=modLots;
     }
   if(Lots<minLots)
     {
      Lots=minLots;
      Print("Lot size is too small. Using broker specified minimum lot size ",minLots);
     }
   if(Lots>maxLots)
     {
      Lots=maxLots;
      Print("Lot size is too large. Using broker specified maximum lot size ",maxLots);
     }

   Comment("MA Previous : ",MAPrev
           ,"\r\nMA : ",MA
           ,"\r\nLots : ",Lots
           ,"\r\nAccount Balance : ",AccountBalance()
           ,"\r\nAccount Equity : ",AccountEquity()
           ,"\r\nP&L : ",AccountEquity()-AccountBalance()
           ,"\r\nFree Margin : ",AccountFreeMargin()
           ,"\r\nStopLoss : ",StopLoss
           ,"\r\nTakeProfit : ",TakeProfit
           ,"\r\nMin Margin Allowed : ",minMargin);

// give up instead of getting margin call "stop out"
   if(AccountFreeMargin()<=minMargin)
     {
      while(OrdersTotal()>0)
        {
         Print("Close them all");
         CloseOrders(OP_SELL);
         CloseOrders(OP_BUY);
        }
     }
// Reset the stoploss and takeprofit levels if all orders are closed     
   if(OrdersTotal()==0)
     {
      sl=0;
      tp=0;
      scaledSl = 0;
      scaledTp = 0;
      effectiveLeverage=Leverage_Per_Position;
     }

   if(StopLoss>0)
     {
      scaledSl=(StopLoss/effectiveLeverage);
     }

   if(TakeProfit>0)
     {
      scaledTp=(TakeProfit/effectiveLeverage);
     }
   double tmpDbl=0;
// Check any open SELL orders
   if(MAPrev<MA)
     {
      if(CloseOrders(OP_SELL)==True)
        {
         if(AccountFreeMarginCheck(symbol,OP_BUY,Lots)<=AccountBalance()*freeEquityFactor || GetLastError()==134)
           {
            PrintFormat("Not Opening order, not enough free margin for %2.2f lots.",Lots);
           }
         else
           {
            if(StopLoss>0 && (sl==0 || Average_Up || Average_Down))
              {
               tmpDbl=NormalizeDouble(Ask-(Ask*scaledSl),Digits);
               if(tmpDbl>sl || sl==0)
                 {
                  sl=tmpDbl;
                 }
               if((Ask*scaledSl)<stopLevel)
                 {
                  sl=NormalizeDouble(Bid-stopLevel,Digits);
                 }
              }
            if(TakeProfit>0 && (tp==0 || Average_Up || Average_Down))
              {
               tmpDbl=NormalizeDouble(Ask+(Ask*scaledTp),Digits);
               if(tmpDbl<tp || tp==0)
                 {
                  tp=tmpDbl;
                 }
               if((Ask*scaledTp)<stopLevel)
                 {
                  tp=NormalizeDouble(Bid+stopLevel,Digits);
                 }
              }

            if(
               OrdersTotal()==0
               || (Ask>PairHighestPricePaid(symbol) && Average_Up)
               || (Ask<PairLowestPricePaid(symbol) && Average_Down)
               )
              {
               ticket=OrderSend(symbol,OP_BUY,Lots,Ask,Slippage,sl,tp);
               if(ticket<0)
                 {
                  Print(GetLastError());
                 }
               NormalizeExits();
              }
           }
        }
     }
// Check any open BUY orders
   if(MAPrev>MA)
     {
      if(CloseOrders(OP_BUY)==True)
        {
         if(AccountFreeMarginCheck(symbol,OP_SELL,Lots)<=AccountEquity()*freeEquityFactor || GetLastError()==134)
           {
            PrintFormat("Not Opening order, not enough free margin for %2.2f lots.",Lots);
           }
         else
           {
            if(StopLoss>0 && (sl==0 || Average_Up || Average_Down))
              {
               tmpDbl=NormalizeDouble(Bid+(Bid*scaledSl),Digits);
               if(tmpDbl<sl || sl==0)
                 {
                  sl=tmpDbl;
                 }
               if((Bid*scaledSl)<stopLevel)
                 {
                  sl=NormalizeDouble(Ask+stopLevel,Digits);
                 }
              }
            if(TakeProfit>0 && (tp==0 || Average_Up || Average_Down))
              {
               tmpDbl=NormalizeDouble(Bid-(Bid*scaledTp),Digits);
               if(tmpDbl>tp || tp==0)
                 {
                  tp=tmpDbl;
                 }
               if((Bid*scaledTp)<stopLevel)
                 {
                  tp=NormalizeDouble(Ask-stopLevel,Digits);
                 }
              }
            if(
               OrdersTotal()==0
               || (Bid<PairLowestPricePaid(symbol) && Average_Up)
               || (Bid>PairHighestPricePaid(symbol) && Average_Down)
               )
              {
               ticket=OrderSend(symbol,OP_SELL,Lots,Bid,Slippage,sl,tp);
               if(ticket<0)
                 {
                  Print(GetLastError());
                 }
               NormalizeExits();
              }
           }
        }
     }
   return;
  }
//+------------------------------------------------------------------+
