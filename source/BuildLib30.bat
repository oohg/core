@echo off
if /I "%1"=="/c" buildlib %1 HB30 %2 %3 %4 %5 %6 %7 %8 %9
if not /I "%1"=="/c" buildlib HB30 %1 %2 %3 %4 %5 %6 %7 %8 %9
