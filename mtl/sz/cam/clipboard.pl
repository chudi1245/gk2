#!/usr/bin/perl 
use strict;
use Win32::Clipboard;
    my $CLIP = Win32::Clipboard();
    $CLIP->Empty();
    $CLIP->Set("D:/work/pcb/");
  
    