use strict;
use warnings;

my %grid=%main::grid;
my $target_tool=$main::target_tool;
my $text ="$main::JOB"."-G";

my ($anger,$moudel);

($main::px < $main::py) ? ($anger=90) : ($anger=0);
##加钢板定位的座标。
if ($main::px < $main::py ) {
	$moudel=[
    { x=>$main::px-0.5,  y=>$main::py-1.5 },
	{ x=>0.5,			 y=>$main::py-0.5 },
	{ x=>0.5,            y=>0.5     },
	{ x=>$main::px-0.5,  y=>0.5     },
];}else {
	$moudel=[
    { x=>$main::px-0.5,  y=>$main::py-0.5 },
	{ x=>1.5,			 y=>$main::py-0.5 },
	{ x=>0.5,            y=>0.5     },
	{ x=>$main::px-0.5,  y=>0.5     },
]; }
##加铆钉孔的座标。
my %target_rivet=(
	  top=>$main::SR_ymax+0.512,   ###0.512inch=13mm
	  bot=>$main::SR_ymin-0.512,
	  rig=>$main::SR_xmax+0.512,
	  lef=>$main::SR_xmin-0.512,
	);
	if ( $main::py-$main::SR_ymax > 0.7) {  $target_rivet{top}=$main::py-0.25; };
	if ( $main::px-$main::SR_xmax > 0.7) {  $target_rivet{rig}=$main::px-0.25  };
	if ( $main::SR_ymin > 0.7) {  $target_rivet{bot}=0.25  };
	if ( $main::SR_xmin > 0.7) {  $target_rivet{lef}=0.25  };

my $start_point=$main::start_point;

my ($mdleft_top,$mdleft_bot,$mdrigt_top,$mdrigt_bot);

$mdleft_top=$start_point + 5.21;
$mdrigt_top=$start_point + 4.71;

if ($main::py >= 16) {
	$mdleft_bot=$start_point - 5.65;
	$mdrigt_bot=$start_point - 5.25;
}else{
	$mdleft_bot=$start_point - 2.02;
	$mdrigt_bot=$start_point - 1.72;
}


if ($main::layer_number > 4  
        or ($main::layer_number == 4 and @{$main::layer_class{inner}}[0] =~ m/l2b/i ) ){

#######打开所有内层加铆钉。
	clear();
	affected_layer('yes','single',  @{$main::layer_class{inner}}   );
	cur_atr_set('.out_scale');
	_add_rivet('md');
	cur_atr_set();
	clear();

#######外层线路加避开的物件。
#	affected_layer('yes','single',  @{$main::layer_class{outer}}   );
#	_add_rivet('rect343x145xr82.5');
#	clear();

#######CY层加 锣槽。
	clear('cy');
	_add_rivet('rect323x125xr62.5');
	clear();
#######内层使用光板，在drl-g层加钻铆钉的孔。

if ($main::g_board eq 'Bare') {
      if ( exists_layer('drl-g') eq 'yes'  ) { $main::f->COM("delete_layer,layer=drl-g");}
       creat_clear_layer('drl-g');
       _add_rivet('r125');
	   add_pad($target_tool->[0]{x},$target_tool->[0]{y},'r126', 'no', 0, 'yes');
	   add_pad($target_tool->[1]{x},$target_tool->[1]{y},'r126', 'no', 0, 'yes');
	   add_pad($target_tool->[2]{x},$target_tool->[2]{y},'r126', 'no', 0, 'yes');
	   add_pad($target_tool->[3]{x},$target_tool->[3]{y},'r126', 'no', 0, 'yes');

       add_pad(0.03937,                          0.03937, 'r39.606',);
	   add_pad(0.03937,              $main::py - 0.03937, 'r39.606',);
	   add_pad($main::px - 0.03937,  $main::py - 0.03937, 'r39.606',);
	   add_pad($main::px - 0.03937,              0.03937, 'r39.606',);

###在drl-g层加钻孔档案号

$main::f->COM ('add_text',
		attributes=>'no',
		type=>'canned_text',
		x=>$main::SR_xmin-0.58,
		y=>$main::SR_ymax+0.1,
		text=>$text,
		x_size=>0.227,
		y_size=>0.265,
	  ##w_factor=>2.62467,
		w_factor=>2.6570,
		polarity=>'positive',
		angle=>90,
		mirror=>'no',
		fontname=>'canned_57',
		bar_type=>'UPC39',
		bar_char_set=>'full_ascii',
		bar128_code=>'none',
		bar_checksum=>'no',
		bar_background=>'yes',
		bar_add_string=>'no',
		bar_add_string_pos=>'top',
		bar_width=>0.008,
		bar_height=>0.175,
		ver=>1
		);
		$main::f->COM ('sel_break');
		}
}

# $mdleft_top,$mdleft_bot,$mdrigt_top,$mdrigt_bot
#————————————————————加铆钉的子程序！！！
sub _add_rivet {
    my $symbol=shift;
	add_pad($target_rivet{rig}, $mdrigt_top, $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{rig}, $mdrigt_bot, $symbol, 'no', 90, 'yes');

	add_pad($target_rivet{lef}, $mdleft_top, $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{lef}, $mdleft_bot, $symbol, 'no', 90, 'yes');

	add_pad($grid{x}[3],  $target_rivet{top}, $symbol, 'no', 0, 'yes');
	add_pad($grid{x}[11], $target_rivet{top}, $symbol, 'no', 0, 'yes');
	add_pad($grid{x}[3],  $target_rivet{bot}, $symbol, 'no', 0, 'yes');
	add_pad($grid{x}[10], $target_rivet{bot}, $symbol, 'no', 0, 'yes');

if ($main::g_moudel eq "Steel" ){
	add_pad($moudel->[0]{x}, $moudel->[0]{y},$symbol, 'no', $anger, 'yes' );
	add_pad($moudel->[1]{x}, $moudel->[1]{y},$symbol, 'no', $anger, 'yes' );
	add_pad($moudel->[2]{x}, $moudel->[2]{y},$symbol, 'no', $anger, 'yes' );
	add_pad($moudel->[3]{x}, $moudel->[3]{y},$symbol, 'no', $anger, 'yes' );
	}
}	 




##LABEL_TARGET_RIVET_END:  ;

1;

=head 

sub _add_rivet {
    my $symbol=shift;
	add_pad($target_rivet{rig}, $grid{y}[11]+0.15, $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{rig}, $grid{y}[3], $symbol, 'no', 90, 'yes');

	add_pad($target_rivet{lef}, $grid{y}[11], $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{lef}, $grid{y}[3], $symbol, 'no', 90, 'yes');

	add_pad($grid{x}[3],  $target_rivet{top}, $symbol, 'no', 0,  'yes');
	add_pad($grid{x}[11], $target_rivet{top}, $symbol, 'no', 0,  'yes');
	add_pad($grid{x}[3],  $target_rivet{bot}, $symbol, 'no', 0,  'yes');
	add_pad($grid{x}[10], $target_rivet{bot}, $symbol, 'no', 0,  'yes');

if ($main::g_moudel eq "Steel" ){
	add_pad($moudel->[0]{x}, $moudel->[0]{y},$symbol, 'no', $anger, 'yes' );
	add_pad($moudel->[1]{x}, $moudel->[1]{y},$symbol, 'no', $anger, 'yes' );
	add_pad($moudel->[2]{x}, $moudel->[2]{y},$symbol, 'no', $anger, 'yes' );
	add_pad($moudel->[3]{x}, $moudel->[3]{y},$symbol, 'no', $anger, 'yes' );
	}
}