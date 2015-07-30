use strict;
use warnings;

goto LABEL_GUANG_BOARD_END if ($main::g_moudel ne "Steel" or $main::layer_number < 4 
         or ($main::layer_number == 4 and @{$main::layer_class{inner}}[0] !=~ m/l2b/i )     );

#my @layer_line=@{$main::layer_class{line}};

my @inner=@{$main::layer_class{inner}};
my ($ganger);

if ($main::px < $main::py ) {
	$main::moudel=[
    { x=>$main::px-0.5,  y=>$main::py-1.5 },
	{ x=>0.5,			 y=>$main::py-0.5 },
	{ x=>0.5,            y=>0.5     },
	{ x=>$main::px-0.5,  y=>0.5     },
];
}else {
	$main::moudel=[
    { x=>$main::px-0.5,  y=>$main::py-0.5 },
	{ x=>1.5,			 y=>$main::py-0.5 },
	{ x=>0.5,            y=>0.5     },
	{ x=>$main::px-0.5,  y=>0.5     },
];
}

($main::px < $main::py) ? ($ganger=90) : ($ganger=0);

cur_atr_set('.out_scale');

foreach  (0..$#inner ) {
		clear($inner[$_]);
		add_pad($main::moudel->[0]{x}, $main::moudel->[0]{y}, 'md', 'no', $ganger, 'yes' );
		add_pad($main::moudel->[1]{x}, $main::moudel->[1]{y}, 'md', 'no', $ganger, 'yes' );
		add_pad($main::moudel->[2]{x}, $main::moudel->[2]{y}, 'md', 'no', $ganger, 'yes' );
		add_pad($main::moudel->[3]{x}, $main::moudel->[3]{y}, 'md', 'no', $ganger, 'yes' );
}

cur_atr_set();
clear();

LABEL_GUANG_BOARD_END:  ;

##p__("add guang board ok");

1;



