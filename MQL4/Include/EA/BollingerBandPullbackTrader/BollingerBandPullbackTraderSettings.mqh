//+------------------------------------------------------------------+
//|                          BollingerBandPullbackTraderSettings.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

input int BollingerBandPullbackBbPeriod=30; // Period for Bollinger Bands.
input bool BollingerBandPullbackFadeTouch=false; // Fade the BB touch?
input int BollingerBandPullbackTouchPeriod=30; // How many bars is a BB touch valid?
input double BollingerBandPullbackBbDeviation=2; // BB standard deviation(s).
input ENUM_APPLIED_PRICE BollingerBandPullbackBbAppliedPrice=PRICE_OPEN;
input int BollingerBandPullbackTouchShift=0;
input int BollingerBandPullbackBbShift=0;
input color BollingerBandPullbackBbIndicatorColor=clrMagenta;
input color BollingerBandPullbackTouchIndicatorColor=clrAqua;

input int BollingerBandPullbackMaPeriod=30;
input int BollingerBandPullbackMaShift=0;
input ENUM_MA_METHOD BollingerBandPullbackMaMethod=MODE_EMA;
input ENUM_APPLIED_PRICE BollingerBandPullbackMaAppliedPrice=PRICE_TYPICAL;
input color BollingerBandPullbackMaColor=clrHotPink;

input int BollingerBandPullbackAtrPeriod=30;
input double BollingerBandPullbackAtrMultiplier=4;
input color BollingerBandPullbackAtrColor=clrWheat;

input int BollingerBandPullbackShift=0;
input double BollingerBandPullbackMinimumTpSlDistance=5; // Tp/Sl minimum distance, in spreads.
input int BollingerBandPullbackParallelSignals=2; // Quantity of parallel signals to use.
#include <EA\PortfolioManagerBasedBot\BasicSettings.mqh>
