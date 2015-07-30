use strict;
use warnings;
my($px,$py)=($main::px,$main::py);
my $class=\%main::layer_class;

my $coord_line=[
	{x=>0.158,   y=>0.158              },
	{x=>0.158,   y=>int($py-0.4)+0.158 },
	{y=>0.158,   x=>int($px-0.4)+0.158 },
];   
my $coord_unline=[
	{x=>$main::SR_xmin-0.080,   y=>$main::SR_ymin-0.080              },
	{x=>$main::SR_xmin-0.080,   y=>int($main::SR_ymax-$main::SR_ymin)+($main::SR_ymin-0.080) }, 
	{y=>$main::SR_ymin-0.080,   x=>int(  $main::silk_ref[0]->{x} - $main::SR_ymin - 0.1  ) + $main::SR_xmin - 0.080 }, 
];
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
