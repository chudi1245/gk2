#!/usr/bin/perl

use strict;
use Tk;
use POSIX qw(strftime);
my $week = strftime( "%U",localtime);
my $date = strftime( "%Y-%m-%d",localtime);
print "$week,$date";	   
	
=head  

	   use strict;
       use POSIX qw(strftime);
       #my $datetime=strftime("%Y-%m-%d %H:%M:%S\n", localtime(time));
       #print $datetime;
       print strftime("%Y%m%d", localtime);



my $day=getdate();
print "$day\n";

sub getdate{
	my ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime();    
	$year += 1900;    
	$mon++;
	$mon= ($mon < 10  ? $mon = "2"."$mon" : $mon=$mon );
	$day= ($day < 10  ? $day = "0"."$day" : $mon=$day );
	my $date = "$year$mon$day";    
	#print $date, "\n";
	return $date;
}