use strict;
use warnings;
my($px,$py)=($main::px,$main::py);
my $class=\%main::layer_class;
my @min_line = @main::min_line;

###给线路层和非线路层定义了不同位置，加背板标记。
#my $coord_line=[
#	{x=>0.158,   y=>0.158              },
#	{x=>0.158,   y=>int($py-0.4)+0.158 },
#	{y=>0.158,   x=>int($px-0.4)+0.158 },
#];

#my $coord_line=[
#	{x=>$main::Prof_xmax - 0.158,   y=>0.158              },
#	{x=>$main::Prof_xmax - 0.158,   y=>int($py-0.4) - 0.158 },
#	{y=>0.158,   x=>$px - (int($px-0.4) + 0.158) },
#];

my $coord_line=[
	{x=>$main::Prof_xmax - 0.11811,   y=> 0.11811                        },
	{x=>$main::Prof_xmax - 0.11811,   y=> int($py-0.4) + 0.11811         },
	{y=> 0.11811,				      x=> $px - (int($px-0.4) + 0.11811) },
];

############ ----------------------------2013-01-03 Modified
if ($main::layer_number < 3) {
	$coord_line=[
	{x=>$main::Prof_xmax + 0.11811,   y=> -0.11811 },
	{x=>$main::Prof_xmax + 0.11811,   y=>int($py-0.4) - 0.11811 },
	{y=> -0.11811,				      x=>$px - (int($px-0.4) - 0.11811) },
];
}


##

my $coord_unline=[
	{x=>$main::SR_xmin-0.140,   y=>$main::SR_ymin-0.120              },
	{x=>$main::SR_xmin-0.140,   y=>int($main::SR_ymax - $main::SR_ymin) +($main::SR_ymin-0.120) },
	
	{y=>$main::SR_ymin-0.120,   x=>int($main::SR_xmax-$main::SR_xmin - 0.3 ) + $main::SR_xmin - 0.140 }, 
];


###p__("$coord_unline->[2]{x},$coord_unline->[2]{y}");
##########
##main::silk_ref
###加不缩放属性；

cur_atr_set('.out_scale');

if ( exists $class->{outer} ){
	clear();
	affected_layer('yes','single',@{$class->{outer}},);
	map {  add_pad($coord_line->[$_]{x},$coord_line->[$_]{y},'bb', 'no', 0, 'yes')  } (0.. $#$coord_line);
}
###------------------------------------------

my @layer_line=@{$main::layer_class{line}};


foreach  (1..$#layer_line-1 ) {
	if ( $main::polarity[$_] eq '+') {	
		clear($layer_line[$_]);
      map {  add_pad($coord_line->[$_]{x},$coord_line->[$_]{y},'bb', 'no', 0, 'yes')  } (0.. $#$coord_line);
    }
	else {	
		clear($layer_line[$_]);
      map {  add_pad($coord_line->[$_]{x},$coord_line->[$_]{y},'bbi', 'no', 0, 'yes')  } (0.. $#$coord_line);
    }
}


my @add_layer;
map {   @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\solder_mask silk_screen\);


foreach  (0..$#add_layer ) {
 
 if (( $add_layer[$_]  eq  'gtl-ir' ) || ( $add_layer[$_]  eq  'gbl-ir' ) ) {
	 clear($add_layer[$_]);
	 map {add_pad($coord_line->[$_]{x}, $coord_line->[$_]{y},'bbi', 'no', 0, 'yes')} (0.. $#$coord_line );}
else {
     clear($add_layer[$_]);
	 map {add_pad($coord_line->[$_]{x}, $coord_line->[$_]{y},'bb',  'no', 0, 'yes')} (0.. $#$coord_line );}
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
