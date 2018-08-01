//+------------------------------------------------------------------+
//|                                                BasicSettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

input string WatchedSymbols="USDJPYpro,GBPUSDpro,USDCADpro,USDCHFpro,USDSEKpro"; // Currency Basket, csv list or blank for current chart.
input ENUM_TIMEFRAMES PortfolioTimeframe=PERIOD_CURRENT;
input double Lots=0.01; // Lots to trade.
input double ProfitTarget=25; // Profit target in account currency.
input double MaxLoss=25; // Maximum allowed loss in account currency.
input int Slippage=10; // Allowed slippage.
extern ENUM_DAY_OF_WEEK Start_Day=0; // Start Day
extern ENUM_DAY_OF_WEEK End_Day=6; // End Day
extern string   Start_Time="00:00"; // Start Time
extern string   End_Time="24:00"; // End Time
input bool ScheduleIsDaily=false; // Use start and stop times daily?
input bool TradeAtBarOpenOnly=false; // Trade only at opening of new bar?
input bool PinExits=true; // Disable signals from moving exits backward?
input bool SwitchDirectionBySignal=true; // Allow signal switching to close orders?
