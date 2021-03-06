//+------------------------------------------------------------------+
//|                                              ExportOrderBook.mq4 |
//|                                 Copyright © 2017, Matthew Kastor |
//|                                 https://github.com/matthewkastor |
//+------------------------------------------------------------------+
#property copyright "Matthew Kastor"
#property link      "https://github.com/matthewkastor"
#property strict
#property show_inputs

#include <Monitors\OrderBookMonitor.mqh>

sinput string Note_1="Files will be created in MQL\\Files or Tester\\Files";
sinput string Note_2="subdirectory of the terminal folder.";
input string OutputFile="OrderBook.csv";// Output File
input bool ExportActiveTickets=true;// Export Active Orders
input int ActiveTicketDepth=1000;// Limit Active Order Export Records
input bool ExportHistoricTickets=true;// Export Order History
input int HistoricTicketDepth=1000;// Limit Historic Order Export Records
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   OrderBookMonitor mon(OutputFile,false,ExportActiveTickets,ActiveTicketDepth,ExportHistoricTickets,HistoricTicketDepth,false);
   if(!mon.RecordData())
     {
      Alert("Operation failed");
     }
  }
//+------------------------------------------------------------------+
