use strict;
use warnings;

if ($main::layer_number > 4  
        or    ($main::layer_number == 4 and @{$main::layer_class{inner}}[0] =~ m/l2b/i )     
		                                            ){
	my %grid=%main::grid;

	##my @add_layer=@{$main::layer_class{inner}};

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
#######打开所有内层加铆钉。
	clear();
	affected_layer('yes','single',  @{$main::layer_class{inner}}   );
	cur_atr_set('.out_scale');
	_add_rivet('md');
	cur_atr_set();
	clear();
#######外层线路加避开的物件。
	affected_layer('yes','single',  @{$main::layer_class{outer}}   );
	_add_rivet('rect343x145xr82.5');
	clear();

#######CY层加 锣槽。
	clear('cy');
	_add_rivet('rect323x125xr62.5');
	clear();


	sub _add_rivet {
		my $symbol=shift;
	add_pad($target_rivet{rig}, $grid{y}[10], $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{rig}, $grid{y}[3] , $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{lef}, $grid{y}[11], $symbol, 'no', 90, 'yes');
	add_pad($target_rivet{lef}, $grid{y}[3] , $symbol, 'no', 90, 'yes');
	add_pad($grid{x}[3],  $target_rivet{top}, $symbol, 'no', 0,  'yes');
	add_pad($grid{x}[11], $target_rivet{top}, $symbol, 'no', 0,  'yes');
	add_pad($grid{x}[3],  $target_rivet{bot}, $symbol, 'no', 0,  'yes');
	add_pad($grid{x}[10], $target_rivet{bot}, $symbol, 'no', 0,  'yes');

	}

}

##LABEL_TARGET_RIVET_END:  ;

1;

=head
add_pad($target_rivet{rig}, $grid{y}[10], 'md', 'no', 90, 'yes');
add_pad($target_rivet{rig}, $grid{y}[3] , 'md', 'no', 90, 'yes');
add_pad($target_rivet{lef}, $grid{y}[11], 'md', 'no', 90, 'yes');
add_pad($target_rivet{lef}, $grid{y}[3] , 'md', 'no', 90, 'yes');
add_pad($grid{x}[3],  $target_rivet{top}, 'md', 'no', 0,  'yes');
add_pad($grid{x}[11], $target_rivet{top}, 'md', 'no', 0,  'yes');
add_pad($grid{x}[3],  $target_rivet{bot}, 'md', 'no', 0,  'yes');
add_pad($grid{x}[10], $target_rivet{bot}, 'md', 'no', 0,  'yes');
