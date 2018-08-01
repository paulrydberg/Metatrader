//+------------------------------------------------------------------+
//|                                              PortfolioTrader.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Signals\ExtremeBreak.mqh>
#include <Signals\AtrBreakout.mqh>
#include <EA\PortfolioManagerBasedBot\BasePortfolioManagerBot.mqh>
#include <EA\PortfolioTrader\PortfolioTraderConfig.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class PortfolioTrader : public BasePortfolioManagerBot
  {
public:
   void              PortfolioTrader(PortfolioTraderConfig &config);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PortfolioTrader::PortfolioTrader(PortfolioTraderConfig &config):BasePortfolioManagerBot(config)
  {
   int i;
   for(i=0;i<config.parallelSignals;i++)
     {
      this.signalSet.Add(
                         new ExtremeBreak(
                         config.extremeBreakPeriod,
                         config.extremeBreakTimeframe,
                         config.extremeBreakShift+(config.extremeBreakPeriod*i),
                         config.extremeBreakColor
                         ));

      this.signalSet.Add(new AtrBreakout(
                         config.atrPeriod,
                         config.atrMultiplier,
                         config.extremeBreakTimeframe,
                         config.extremeBreakShift+(config.extremeBreakPeriod*i),
                         config.atrMinimumTpSlDistance,
                         config.atrColor));
     }
     this.Initialize();
  }
//+------------------------------------------------------------------+
