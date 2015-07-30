#!/usr/bin/perl

use strict;
use POSIX qw(strftime);
my $week = strftime( "%U",localtime);
my $date = strftime( "%Y-%m-%d",localtime);

print "$week $date \n";
