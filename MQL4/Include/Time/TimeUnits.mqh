//+------------------------------------------------------------------+
//|                                                    TimeUnits.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TimeUnits
  {
public:
   static const int  Second;
   static const int  Minute;
   static const int  Hour;
   static const int  Day;
   static const int  Week;
   static const int  Month;
   static const int  Year;
  };
const int TimeUnits::Second=(((datetime)"2001.06.15 12:59:59")-((datetime)"2001.06.15 12:59:58"));
const int TimeUnits::Minute=(((datetime)"2001.06.15 12:59:59")-((datetime)"2001.06.15 12:58:59"));
const int TimeUnits::Hour=(((datetime)"2001.06.15 12:59:59")-((datetime)"2001.06.15 11:59:59"));
const int TimeUnits::Day=(((datetime)"2001.06.15 12:59:59")-((datetime)"2001.06.14 12:59:59"));
const int TimeUnits::Month=(((datetime)"2001.06.15 12:59:59")-((datetime)"2001.05.15 12:59:59"));
const int TimeUnits::Year=(((datetime)"2001.06.15 12:59:59")-((datetime)"2000.06.15 12:59:59"));
//+------------------------------------------------------------------+
