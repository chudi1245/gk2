#!/usr/bin/perl
use strict;
use Tk;
use Genesis;
use C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________
kysy();
my $mw= MainWindow->new();
$mw->title("Better and better");
$mw->geometry("+200+100");
my $xbm = $mw->Bitmap(-file       => 'C:/genesis/fw/lib/symbols/yyww.xbm',
                    -foreground => 'black',
                    -background => 'white',
);
my $l = $mw->Label(-image => $xbm,)->pack;
MainLoop;





