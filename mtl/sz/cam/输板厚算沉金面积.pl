#! /usr/bin/perl5 -w 
use strict; 
use Win32; 
my $main = new MainWindow; 
$main->Label(-text => 'Hello, world!')->pack; 
$main->Button(-text =>'Quit', -command =>sub{exit} )->pack; 
MainLoop; 
