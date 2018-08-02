//+------------------------------------------------------------------+
//|                                        BacktestOptimizations.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Stats\PortfolioStats.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BacktestOptimizations
  {
private:
   double            Score;
public:
   void              BacktestOptimizations(double initialScore=1)
     {
      Score=initialScore;
     };

   double GetScore()
     {
      return this.Score;
     }

   BacktestOptimizations *GainsStdDevLimit(double limit=5)
     {
      double tmpDouble=PortfolioStats::GainsStdDev();
      if(tmpDouble>0)
        {
         this.Score=this.Score*tmpDouble;
        }
      return GetPointer(this);
     };

   BacktestOptimizations *LossesStdDevLimit(double limit=1)
     {
      double tmpDouble=PortfolioStats::LossesStdDev();
      if(tmpDouble>0)
        {
         this.Score=this.Score *(limit/tmpDouble);
        }
      return GetPointer(this);
     };

   BacktestOptimizations *StrategyIsProfitable()
     {
      double tmpDouble=PortfolioStats::NetProfit();
      if(tmpDouble>0)
        {
         this.Score=this.Score*2;
        }
      else if(this.Score!=0)
        {
         this.Score=this.Score/2;
        }
      return GetPointer(this);
     };

   BacktestOptimizations *LargestLossPerTotalGainLimit(double highestPercent=5.0)
     {
      double tmpDouble=0;
      double gainsOnly=PortfolioStats::TotalGain();
      double largestLoss=Stats::AbsoluteValue(PortfolioStats::LargestLoss());
      if(gainsOnly>0 && largestLoss>0)
        {
         tmpDouble=gainsOnly *(highestPercent/100);
         this.Score=this.Score *(tmpDouble/largestLoss);
        }
      return GetPointer(this);
     };

   BacktestOptimizations *TradesPerDay(double targetTradesPerDay=1)
     {
      double tmpDouble=0;
      double days=PortfolioStats::HistoryDuration().ToDays();
      int totalTrades=PortfolioStats::TotalTrades();
      if(days>0 && totalTrades>0)
        {
         tmpDouble=(((double)totalTrades)/(days * targetTradesPerDay));
         this.Score=this.Score*tmpDouble;
        }
      else
        {
         this.Score=0;
        }
      return GetPointer(this);
     };
  };
//+------------------------------------------------------------------+
