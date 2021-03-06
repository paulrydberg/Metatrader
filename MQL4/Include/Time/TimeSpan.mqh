//+------------------------------------------------------------------+
//|                                                     TimeSpan.mqh |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict

#include <Time\TimeUnits.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct TimeSpan
  {
   int               Years;
   int               Months;
   int               Days;
   int               Hours;
   int               Minutes;
   int               Seconds;

   void TimeSpan()
     {
      this.Years=0;
      this.Months=0;
      this.Days=0;
      this.Hours=0;
      this.Minutes=0;
      this.Seconds=0;
     };

   TimeSpan FromSeconds(int seconds)
     {
      int remaining=seconds;

      this.Years=(int)MathFloor(remaining/TimeUnits::Year);
      remaining=remaining -(this.Years*TimeUnits::Year);

      this.Months=(int)MathFloor(remaining/TimeUnits::Month);
      remaining=remaining -(this.Months*TimeUnits::Month);

      this.Days=(int)MathFloor(remaining/TimeUnits::Day);
      remaining=remaining -(this.Days*TimeUnits::Day);

      this.Hours=(int)MathFloor(remaining/TimeUnits::Hour);
      remaining=remaining -(this.Hours*TimeUnits::Hour);

      this.Minutes=(int)MathFloor(remaining/TimeUnits::Minute);
      remaining=remaining -(this.Minutes*TimeUnits::Minute);

      this.Seconds=remaining;

      return this;
     };

   TimeSpan FromDateTime(datetime dt)
     {
      int s=((int)dt);
      FromSeconds(s);
      return this;
     };

   int ToSeconds()
     {
      int dt=this.Seconds
             +(this.Minutes*TimeUnits::Minute)
             +(this.Hours*TimeUnits::Hour)
             +(this.Days*TimeUnits::Day)
             +(this.Months*TimeUnits::Month)
             +(this.Years*TimeUnits::Year);
      return dt;
     };

   double ToMinutes()
     {
      return ((double)this.ToSeconds() / (double)TimeUnits::Minute);
     };

   double ToHours()
     {
      return ((double)this.ToSeconds() / (double)TimeUnits::Hour);
     };

   double ToDays()
     {
      return ((double)this.ToSeconds() / (double)TimeUnits::Day);
     };

   double ToMonths()
     {
      return ((double)this.ToSeconds() / (double)TimeUnits::Month);
     };

   double ToYears()
     {
      return ((double)this.ToSeconds() / (double)TimeUnits::Year);
     };

   datetime ToDateTime()
     {
      return ((datetime)this.ToSeconds());
     };

   string ToString()
     {
      return StringFormat("%i Years,%i Months,%i Days,%i Hours,%i Minutes,%i Seconds, Raw Value: %i",
                          this.Years,this.Months,this.Days,this.Hours,this.Minutes,this.Seconds,
                          this.ToSeconds());
     };

   TimeSpan Add(int seconds)
     {
      return this.FromSeconds(this.ToSeconds() + seconds);
     };

   TimeSpan Add(datetime dt)
     {
      return this.FromSeconds(this.ToSeconds() + ((int)dt));
     };

   TimeSpan Add(TimeSpan &t)
     {
      return this.FromSeconds(this.ToSeconds() + t.ToSeconds());
     };

   TimeSpan Subtract(int seconds)
     {
      return this.FromSeconds(this.ToSeconds() - seconds);
     };

   TimeSpan Subtract(datetime dt)
     {
      return this.FromSeconds(this.ToSeconds() - ((int)dt));
     };

   TimeSpan Subtract(TimeSpan &t)
     {
      return this.FromSeconds(this.ToSeconds() - t.ToSeconds());
     };
  };
//+------------------------------------------------------------------+
