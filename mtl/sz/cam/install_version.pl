#!/usr/bin/perl

use strict;
open (FH, "> C:/genesis/e92/nt/script_version") or die $!; 
print FH 0.3;  
close FH;
print "rewrite  ok\n";

