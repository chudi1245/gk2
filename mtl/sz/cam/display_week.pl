#!/usr/bin/perl 
#use lib "C:/Perl/site/lib/";
use strict;
use Tk;
#use DateTime::Locale::en_US;
use DateTime();
#use DateTime();

use FBI;
use Win32;
use Encode;
###__________________________________-
my $now = DateTime->now; 

kysy();

print $now;

my $mw = MainWindow->new;  $mw->title("Better and better");  $mw->geometry("+800+20");
foreach  my $i(0..40) {
	my ($text,$text2,$text3);
	my $date=$now->clone->add(days=>$i);
	$i ? (  $text = decode('utf8',"$i天后是")   ) :(   $text = decode('utf8',"今天是")  );
	$text2=decode('utf8',$date->year."年". $date->month."月". $date->day."日");
	$text3=decode('utf8',$date->week_number."周");

	$mw->Label(-text=>$text ,-relief=>'sun',-width=>10,-font=>"courier 10",-anchor=>'w')->grid(-column=>0,-row=>0+$i);
	$mw->Label(-text=>$text2,-relief=>'sun',-width=>15,-font=>"courier 10",-anchor=>'w')->grid(-column=>1,-row=>0+$i);
	$mw->Label(-text=>$text3,-relief=>'sun',-width=>8, -font=>"courier 10",-anchor=>'w')->grid(-column=>2,-row=>0+$i);
	   
}
MainLoop;



=h   

DateTime的是典型的现代方式的Perl处理日期：

use DateTime;

my ($year, $month, $day) = split '-', '2009-09-01';

my $date = DateTime->new( year => $year, month => $month, day => $day );

$date->subtract( days => 3 );

# $date is now three days earlier (2009-08-29T00:00:00)

