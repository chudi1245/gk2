use strict;
use warnings;
my($px,$py)=($main::px,$main::py);
my $class=\%main::layer_class;
  
my $coord_unline=[
	{x=>$main::SR_xmin-0.080, y=>$main::SR_ymin-0.080},
];

my $x_base = $main::SR_xmin-0.080;
my $y_base = $main::SR_ymin-0.080;
my $x_bb_count = int($main::silk_ref[0]->{x}  - $x_base - 0.05);
my $y_bb_count = int($main::SR_ymax - $y_base - 0.05 );

my $coord_unline=[
	{x=>$x_base,   y=>$y_base},
	#{x=>$main::SR_xmin-0.080,   y=>int($main::SR_ymax-$main::SR_ymin)+($main::SR_ymin-0.080) }, 
	#{y=>$main::SR_ymin-0.080,   x=>int(  $main::silk_ref[0]->{x} - $main::SR_ymin - 0.1  ) + $main::SR_xmin - 0.080 },
];
foreach(1..$x_bb_count){
    if ( ($x_base + $_) > $main::fn_xmax ){
        push @$coord_unline, {x=>$x_base + $_, y=>$y_base };
    }
}
foreach(1..$y_bb_count){
    push @$coord_unline, {x=>$x_base , y=>$y_base + $_ };
}

##main::silk_ref
cur_atr_set('.out_scale');

if ( exists $class->{outer} ){
	clear();
	affected_layer('yes','single',@{$class->{outer}},);
	map {  add_pad($coord_unline->[$_]{x},$coord_unline->[$_]{y},'bb', 'no', 0, 'yes')  } (0.. $#$coord_unline);
}
###------------------------------------------
my @layer_line=@{$main::layer_class{line}};

foreach  (1..$#layer_line-1 ) {
	if ( $main::polarity[$_] eq '+') {	
		clear($layer_line[$_]);
      map {  add_pad($coord_unline->[$_]{x},$coord_unline->[$_]{y},'bb', 'no', 0, 'yes')  } (0.. $#$coord_unline);
    }
	else {	
		clear($layer_line[$_]);
      map {  add_pad($coord_unline->[$_]{x},$coord_unline->[$_]{y},'bbi', 'no', 0, 'yes')  } (0.. $#$coord_unline);
    }
}

my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\solder_mask silk_screen\);

foreach  (0..$#add_layer ) {
 if (( $add_layer[$_]  eq  'gtl-ir' ) || ( $add_layer[$_]  eq  'gbl-ir' ) ) {
	clear($add_layer[$_]);
  map {add_pad($coord_unline->[$_]{x}, $coord_unline->[$_]{y},'bbi', 'no', 0, 'yes')} (0.. $#$coord_unline );
}
else {
clear($add_layer[$_]);
 map {add_pad($coord_unline->[$_]{x}, $coord_unline->[$_]{y},'bb', 'no', 0, 'yes')} (0.. $#$coord_unline );}

}

cur_atr_set( );



#p__("bei banok");
1;
=head

 cur_atr_set('.out_scale');

 'no', 0, 'yes'

##----------------------------------------

##if ( exists $class->{inner} ){
##	clear();
##	affected_layer('yes','single',@{$class->{inner}},);
##	map {  add_pad($coord_unline->[$_]{x},$coord_unline->[$_]{y},'bbi', 'no', 0, 'yes')  } (0.. $#$coord_unline);
##}
##----------------------------------------

if (@add_layer) {
	if
   clear();
   affected_layer('yes','single',@add_layer,);
   map {add_pad($coord_unline->[$_]{x}, $coord_unline->[$_]{y},'bb', 'no', 0, 'yes')} (0.. $#$coord_unline );
   clear();
}
