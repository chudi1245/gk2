#!/usr/bin/perl

# create radio buttons
use Win32;
use strict;
use Tk;

my $mw = MainWindow->new;
$mw->geometry("300x100");
$mw->title("Radio Button Test");

my $color = "Red";

my $radio_frame = $mw->Frame()->pack(-side => "top");
$radio_frame->Label(-text=>"My favorite primary color is ")->pack(-side => "left");

my $radio_blue = $radio_frame->Radiobutton(-text => "Blue", -value => "Blue",                                           -variable=> \$color)->pack(-side => "right");
my $radio_yellow = $radio_frame->Radiobutton(-text => "Yellow", -value => "Yellow",                                             -variable=> \$color)->pack(-side => "right");
my $radio_red = $radio_frame->Radiobutton(-text => "Red", -value => "Red",
                                          -variable=> \$color)->pack(-side => "right");

my $button_frame = $mw->Frame()->pack(-side => "bottom");

my $button_color = $button_frame->Button(-text => "OK",
                                         -command => \&color_sub)->pack(-side => "left");
my $button_exit = $button_frame->Button(-text => "Exit",
                                        -command => sub{exit})->pack(-side => "right");

sub color_sub {
  $mw->messageBox(-message => "You selected $color!", -type => "ok");
}

MainLoop;
 
