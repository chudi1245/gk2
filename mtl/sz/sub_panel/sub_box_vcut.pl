use strict;
no strict "vars";



#####____________________________________
my $box_symbol='r20';
my $vcut_symbol='r10';
my $overstep=0.03;

clear('box');

##affected_layer();  @{$layer_class{solder_mask}}

SWITCH: {
if ($direction eq "X")  { 
	creat_rectangle(0, 0, $width, $py, $box_symbol);
	creat_rectangle($px-$width, 0, $width, $py, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) {
		creat_line($width, 0-$overstep,  'top', $py+$overstep*2  ,  $vcut_symbol);
		creat_line($px-$width, 0-$overstep,  'top', $py+$overstep*2  ,  $vcut_symbol);
	}
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_+$width+$joint, 0-$overstep, 'top', $py+$overstep*2, $vcut_symbol)  } (1..$nx-1)  }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_, 'rig', $px+$overstep*2, $vcut_symbol)         } (1..$ny-1)  }
	last SWITCH;
}  
if ($direction eq "Y")  { 
	creat_rectangle(0, 0, $px, $width, $box_symbol);
	creat_rectangle(0, $py-$width, $px, $width, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) {
		creat_line(0-$overstep,  $width,  'rig', $px+$overstep*2  ,  $vcut_symbol);
		creat_line(0-$overstep,  $py-$width,  'rig', $px+$overstep*2  ,  $vcut_symbol);
	}
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_, 0-$overstep, 'top', $py+$overstep*2, $vcut_symbol);            }(1..$nx-1)   }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_+$width+$joint,  'rig', $px+$overstep*2,  $vcut_symbol)    }(1..$ny-1)   }
	last SWITCH;
} 
if ($direction eq "N")  { 
	creat_rectangle(0, $py-$width, $px, $width, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) {
		creat_line(0-$overstep,  $py-$width,  'rig', $px+$overstep*2  ,  $vcut_symbol);
	}
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_, 0-$overstep, 'top', $py+$overstep*2,  $vcut_symbol)     }(1..$nx-1)   }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_,  'rig', $px+$overstep*2,  $vcut_symbol)    }(1..$ny-1)   }
	last SWITCH;
} 
if ($direction eq "S")  { 
	creat_rectangle(0, 0, $px, $width, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) {
		creat_line(0-$overstep,  $width,  'rig', $px+$overstep*2  ,  $vcut_symbol);
	}
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_, 0-$overstep, 'top', $py+$overstep*2,  $vcut_symbol);            }(1..$nx-1)   }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_+$width+$joint,  'rig', $px+$overstep*2,  $vcut_symbol);    }(1..$ny-1)   }
	last SWITCH;
} 
if ($direction eq "W")  { 
	creat_rectangle(0, 0, $width, $py, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) { creat_line($width, 0-$overstep,  'top', $py+$overstep*2  ,  $vcut_symbol); }
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_+$joint+$width, 0-$overstep, 'top', $py+$overstep*2,  $vcut_symbol);            }(1..$nx-1)   }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_,  'rig', $px+$overstep*2,  $vcut_symbol);    }(1..$ny-1)   }
	last SWITCH;
} 
if ($direction eq "E")  { 
	creat_rectangle($px-$width, 0, $width, $py, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) {creat_line($px-$width, 0-$overstep,  'top', $py+$overstep*2  ,  $vcut_symbol);}
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_, 0-$overstep, 'top', $py+$overstep*2,  $vcut_symbol);            }(1..$nx-1)   }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_,  'rig', $px+$overstep*2,  $vcut_symbol);    }(1..$ny-1)   }
	last SWITCH;
} 
if ($direction eq "ALL")  { 
	creat_rectangle(0+$width, 0+$width, $px-$width*2, $py-$width*2, $box_symbol);
	creat_rectangle(0, 0, $px, $py, $box_symbol);
	affected_layer('yes','single',@{$layer_class{solder_mask}});
	unless ($joint) {
		creat_line($width, 0-$overstep,  'top', $py+$overstep*2  ,  $vcut_symbol);
		creat_line($px-$width, 0-$overstep,  'top', $py+$overstep*2  ,  $vcut_symbol);
		creat_line(0-$overstep,  $width,  'rig', $px+$overstep*2  ,  $vcut_symbol);
		creat_line(0-$overstep,  $py-$width,  'rig', $px+$overstep*2  ,  $vcut_symbol);
	}
	if (! $dx and $nx > 1) { map { creat_line($pcbx*$_+$width+$joint, 0-$overstep, 'top', $py+$overstep*2,  $vcut_symbol);            }(1..$nx-1)   }
	if (! $dy and $ny > 1) { map { creat_line(0-$overstep, $pcby*$_+$width+$joint,  'rig', $px+$overstep*2,  $vcut_symbol);    }(1..$ny-1)   }
	last SWITCH;
} 
}#####end switch
clear();



###________________________________________________________sub
sub creat_rectangle{
	my $x=shift;
	my $y=shift;
	my $width=shift;
	my $height=shift;
	my $symbol=shift||'r20';
	creat_line($x, $y, 'top', $height,  $symbol);
	creat_line($x, $y, 'rig', $width,   $symbol);
	creat_line($x+$width,  $y+$height,  'lef',  $width,   $symbol);
	creat_line($x+$width,  $y+$height,  'bot',  $height,  $symbol);
}

1;

