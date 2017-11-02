@echo off
if /I "%1"=="/c" buildapp %1 HB32 %2 %3 %4 %5 %6 %7 %8 %9
if not /I "%1"=="/c" buildapp HB32 %1 %2 %3 %4 %5 %6 %7 %8 %9
