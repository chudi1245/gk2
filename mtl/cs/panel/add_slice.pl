use strict;
use warnings;

my $class=\%main::layer_class;
my @min_line=@main::min_line;

###$slice->[0]{x}
my ($nx,$ny,$dx,$dy)=(5,2,118,75);           ###切片孔数量，X方向5个，Y方向2个。X间距118MIL，Y方向７５mil。
my $symbol_half_long=$dx*2/1000;             ### 半个长度，118 * 2 /1000 转成英寸。

my $slice;
my $mm1_5=0.10;

if ($main::layer_number <= 2) {
	my $off_x=0.75;
	my $off_y=($dy/1000)/2 ;
	$slice=[
	  {x=>$min_line[0]{x}-$off_x - $symbol_half_long,  y=>$min_line[3]{y}-$off_y+$mm1_5,},
	  {x=>$min_line[3]{x}+$off_x - $symbol_half_long,   y=>$min_line[1]{y}-$off_y-$mm1_5,},
	];
}else{
	my $off_x=0.50;
	my $off_y=0.15;
	$slice=[
	  {x=>$min_line[0]{x}-$off_x-$symbol_half_long,  y=>$min_line[3]{y}+$off_y-0.18,},
	  {x=>$min_line[2]{x}+$off_x-$symbol_half_long,  y=>$min_line[1]{y}-$off_y+0.10,},
	  
	];
}

my($slice_drill_size)=sort{$a<=>$b}@{info('layer',"$main::JOB/pcb/drl",'tool')->{gTOOLdrill_size}};

#$slice_drill_size+=0.0394; 2014-5-25 changed by Mobin
##0.0394mil = 0.01mm
###切片孔尺寸，为最小孔，然后再加0.01mm；
clear('drl');
_add_slice("r$slice_drill_size",$nx,$ny,$dx,$dy);
clear();

if ( exists $class->{line}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{line}} );
	my $symbol='r'.($slice_drill_size+12);
	_add_slice($symbol,$nx,$ny,$dx,$dy);
	my $r_line='r20';
	add_line($slice->[0]{x} , $slice->[0]{y}, $slice->[0]{x}+$symbol_half_long*2 , $slice->[0]{y},$r_line);
	add_line($slice->[0]{x} , $slice->[0]{y}+$dy/1000, $slice->[0]{x}+$symbol_half_long*2 , $slice->[0]{y}+$dy/1000,$r_line);
	add_line($slice->[1]{x} , $slice->[1]{y}, $slice->[1]{x}+$symbol_half_long*2 , $slice->[1]{y},$r_line);
	add_line($slice->[1]{x} , $slice->[1]{y}+$dy/1000, $slice->[1]{x}+$symbol_half_long*2 , $slice->[1]{y}+$dy/1000,$r_line);

}
if ( exists $class->{solder_mask}  ){
    clear();
    affected_layer('yes', 'single', @{$class->{solder_mask}} );
	my $symbol='r'.($slice_drill_size+20);
	_add_slice($symbol,$nx,$ny,$dx,$dy);
}

sub _add_slice {
	my $symbol=shift;
	my ($nx,$ny,$dx,$dy)=@_;
	add_pad($slice->[0]{x},$slice->[0]{y},$symbol,'no',0,'no','positive',$nx,$ny,$dx,$dy);
	add_pad($slice->[1]{x},$slice->[1]{y},$symbol,'no',0,'no','positive',$nx,$ny,$dx,$dy);
}
###

1;
=head
if ($main::layer_number <= 2) {
	my $off_x=0.6;
	my $off_y=($dy/1000)/2 ;
	$slice=[
	  {x=>$min_line[3]{x}+$off_x-$symbol_half_long,  y=>$min_line[3]{y}-$off_y+$mm1_5,},
	  {x=>$min_line[1]{x}-0.5-$off_x-$symbol_half_long,  y=>$min_line[1]{y}-$off_y-$mm1_5,},
	];
}else{
	my $off_x=0.2;
	my $off_y=0.25;
	$slice=[
	  {x=>$min_line[3]{x}+$off_x-$symbol_half_long,  y=>$min_line[1]{y}-$off_y,},
	  {x=>$min_line[1]{x}-0.5-$off_x-$symbol_half_long,  y=>$min_line[3]{y}+$off_y,},
	];
}



@main::min_line=(
  { x=>$main::SR_xmax-0.52, y=>$main::SR_ymax+0.12},
  { x=>$main::SR_xmax-0.20, y=>$main::SR_ymin-0.12},
  { x=>$main::SR_xmin+0.20, y=>$main::SR_ymin-0.12},
  { x=>$main::SR_xmin+0.52, y=>$main::SR_ymax+0.12},
);
my