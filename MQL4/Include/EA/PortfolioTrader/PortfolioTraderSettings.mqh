//+------------------------------------------------------------------+
//|                                      PortfolioTraderSettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

input int ExtremeBreakPeriod=30; // Breakout period, highest and lowest price threshold.
input int ExtremeBreakShift=1; // How many bars are in a breakout?
input color ExtremeBreakColor=clrAquamarine; // Color the breakout box
input int AtrPeriod=3; // Atr period for calculating Tp/Sl
input double AtrMultiplier=3; // Atr multiplier.
input double AtrMinimumTpSlDistance=5; // Tp/Sl minimum distance, in spreads.
input color AtrColor=clrHotPink; // Color the Atr box.
input int ParallelSignals=3; // Quantity of parallel signals to use.
#include <EA\PortfolioManagerBasedBot\BasicSettings.mqh>
