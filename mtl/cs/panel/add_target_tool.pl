use strict;
use warnings;
goto LABEL_TARGET_RIVET_TOOL if ($main::layer_number < 8);
my @add_layer=@{$main::layer_class{inner}};
my %grid=%main::grid;

my $off_set=0.28;


my $target_tool=[ 
	{x=>$main::px-$off_set, y=>$grid{y}[7]  }, 
	{x=>$off_set, y=>$grid{y}[7]  }, 
	{x=>$grid{x}[7], y=>$main::py-$off_set  }, 
 	{x=>$grid{x}[7]+0.2, y=>$off_set  }, 
];

clear();

affected_layer('yes','single',@add_layer);
cur_atr_set('.out_scale');
add_target_tool('gj');
cur_atr_set();

###clear('drl');
##add_target_tool('r125');

clear();

sub add_target_tool{
	my $symbol=shift;
	add_pad($target_tool->[0]{x},$target_tool->[0]{y},$symbol, 'no', 0, 'yes');
	add_pad($target_tool->[1]{x},$target_tool->[1]{y},$symbol, 'no', 0, 'yes');
	add_pad($target_tool->[2]{x},$target_tool->[2]{y},$symbol, 'no', 0, 'yes');
	add_pad($target_tool->[3]{x},$target_tool->[3]{y},$symbol, 'no', 0, 'yes');
}

LABEL_TARGET_RIVET_TOOL:  ;
1;

=head
my %target_tool=(
  top=>$main::SR_ymax+0.65,
  bot=>$main::SR_ymin-0.65,
  rig=>$main::SR_xmax+0.65,
  lef=>$main::SR_xmin-0.65,
);


if ($main::px =~ m/12/ and  $main::py =~ m/16/) {
    $target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>15.5}, {x=>11.5,y=>14  }, {x=>11.5,y=>0.5 }, ];
}elsif ($main::px =~ m/12/ and  $main::py =~ m/18/){
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>17.5}, {x=>11.5,y=>16  }, {x=>11.5,y=>0.5 }, ];
}else{
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>$main::py-0.5}, {x=>$main::px-0.5,y=>$main::py-0.5  }, {x=>$main::px-0.5,y=>0.5 }, ];
}


=head
if ($main::px =~ m/12/ and  $main::py =~ m/16/) {
    $target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>15.5}, {x=>11.5,y=>14  }, {x=>11.5,y=>0.5 }, ];
}elsif ($main::px =~ m/12/ and  $main::py =~ m/18/){
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>17.5}, {x=>11.5,y=>16  }, {x=>11.5,y=>0.5 }, ];
}else{
	$target_tool=[ {x=>0.5, y=>0.5 }, {x=>0.5, y=>$main::py-0.5}, {x=>$main::px-0.5,y=>$main::py-0.5  }, {x=>$main::px-0.5,y=>0.5 }, ];
}