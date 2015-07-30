use strict;
use warnings;

my $class=\%main::layer_class;

###________________________________________ 
my %inner_frame=(
  xmin=>0-(5/$main::I_M),
  ymin=>0-(5/$main::I_M),
  xmax=>$main::px+(5/$main::I_M),
  ymax=>$main::py+(5/$main::I_M),
);

if ($main::layer_number > 2) {
    clear();
    affected_layer('yes', 'single', @{$class->{inner}} );
	
    add_line($inner_frame{xmax},$inner_frame{ymax},$inner_frame{xmax},$inner_frame{ymin},'r10');
    add_line($inner_frame{xmax},$inner_frame{ymin},$inner_frame{xmin},$inner_frame{ymin},'r10');
    add_line($inner_frame{xmin},$inner_frame{ymin},$inner_frame{xmin},$inner_frame{ymax},'r10');
    add_line($inner_frame{xmin},$inner_frame{ymax},$inner_frame{xmax},$inner_frame{ymax},'r10');
}

clear();

###p__('line frame ok');

####p__("@{$class->{inner}}");

1;


=head
多层板电镀边 > 18 往里跳5mm
    
			
			< 18 往外跳13mm




			else{
	$dis=0.51187;  ##15mm=0.51187
	($xmin,$ymin,$xmax,$ymax)=($main::SR_xmin-$dis, $main::SR_ymin-$dis, $main::SR_xmax+$dis, $main::SR_ymax+$dis);

}



##($xmin,$ymin,$xmax,$ymax)=($main::SR_xmin, $main::SR_ymin, $main::SR_xmax, $main::SR_ymax);

add_arc($xmax-$arc_size, $ymax-$arc_size,  $frame{rig}, $ymax, $xmax, $frame{top}, $symbol);
add_arc($xmin+$arc_size, $ymax-$arc_size,  $xmin, $frame{top}, $frame{lef}, $ymax, $symbol);
add_arc($xmin+$arc_size, $ymin+$arc_size,  $frame{lef}, $ymin, $xmin, $frame{bot}, $symbol);
add_arc($xmax-$arc_size, $ymin+$arc_size,  $xmax, $frame{bot}, $frame{rig}, $ymin, $symbol);




add_line($xmax,$frame{top},$xmin,$frame{top},$symbol);
add_line($xmax,$frame{bot},$xmin,$frame{bot},$symbol);
add_line($frame{lef},$ymin,$frame{lef},$ymax,$symbol);
add_line($frame{rig},$ymin,$frame{rig},$ymax,$symbol);




my %frame=%main::frame;


add_arc($xmin+$arc_size, $ymax-$arc_size,  $xmin, $frame{top}, $frame{lef}, $ymax, $symbol);
add_arc($xmin+$arc_size, $ymin+$arc_size,  $frame{lef}, $ymin, $xmin, $frame{bot}, $symbol);
add_arc($xmax-$arc_size, $ymin+$arc_size,  $xmax, $frame{bot}, $frame{rig}, $ymin, $symbol);


	%main::frame=(
        top=>$ymax-$arc_size,
	    bot=>$ymin+$arc_size,
	    lef=>$xmin+$arc_size,
	    rig=>$xmax-$arc_size,
	);



if ($res_x >= 18 or $res_y >=18) {
	my $dis=0.1968;  ##5mm=0.1968
	add_arc($main::px-$arc_size-$dis, $main::py-$arc_size-$dis,  
            $main::px-$arc_size-$dis, $main::py-$dis,  
		    $main::px-$dis,           $main::py-$arc_size-$dis, 
		    $symbol);
	add_arc($main::px-$arc_size-$dis, 0+$arc_size+$dis,  
		    $main::px-$dis,           0+$arc_size+$dis, 
			$main::px-$arc_size-$dis, 0+$dis, 
			$symbol	);
	add_arc(0+$arc_size+$dis, 0+$arc_size+$dis,  
		    0+$arc_size+$dis, 0+$dis,          
			0+$dis,           0+$arc_size+$dis,  
			$symbol);
	add_arc(0+$arc_size+$dis, $main::py-$arc_size-$dis,
	        0+$dis,           $main::py-$arc_size-$dis,       
			0+$arc_size+$dis, $main::py-$dis,
			$symbol);
	##用第一个弧的终点向第二个弧的起点画直线
	add_line($main::px-$dis,           $main::py-$arc_size-$dis, 
			 $main::px-$dis,           0+$arc_size+$dis, 
	         $symbol);
	add_line($main::px-$arc_size-$dis, 0+$dis,
		     0+$arc_size+$dis, 0+$dis,    
			 $symbol);
	add_line(0+$dis,           0+$arc_size+$dis,  
	         0+$dis,           $main::py-$arc_size-$dis,    
	         $symbol);
	add_line(0+$arc_size+$dis, $main::py-$dis, 
		     $main::px-$arc_size-$dis, $main::py-$dis,    
			 $symbol);
}else{
	my $dis=0.51187;  ##5mm=0.1968
	add_arc($main::SR_xmax+$dis-$arc_size, $main::SR_ymax+$dis-$arc_size,
			$main::SR_xmax+$dis-$arc_size, $main::SR_ymax+$dis,
			$main::SR_xmax+$dis, $main::SR_ymax+$dis-$arc_size,
		    $symbol);
	add_arc($main::SR_xmax+$dis-$arc_size, $main::SR_ymin-$dis+$arc_size,
			$main::SR_xmax+$dis,           $main::SR_ymin-$dis+$arc_size,
			$main::SR_xmax+$dis-$arc_size, $main::SR_ymin-$dis,
		    $symbol);
	add_arc($main::SR_xmin-$dis+$arc_size, $main::SR_ymin-$dis+$arc_size,
			$main::SR_xmin-$dis+$arc_size, $main::SR_ymin-$dis,
			$main::SR_xmin-$dis,           $main::SR_ymin-$dis+$arc_size,
		    $symbol);
	add_arc($main::SR_xmin-$dis+$arc_size, $main::SR_ymax+$dis-$arc_size,
			$main::SR_xmin-$dis,           $main::SR_ymax+$dis-$arc_size,
			$main::SR_xmin-$dis+$arc_size, $main::SR_ymax+$dis,
		    $symbol);
	add_line($main::SR_xmax+$dis, $main::SR_ymax+$dis-$arc_size,
			$main::SR_xmax+$dis,           $main::SR_ymin-$dis+$arc_size,
		    $symbol);
	add_line($main::SR_xmax+$dis-$arc_size, $main::SR_ymin-$dis,
			$main::SR_xmin-$dis+$arc_size, $main::SR_ymin-$dis,	
		    $symbol);
	add_line($main::SR_xmin-$dis,           $main::SR_ymin-$dis+$arc_size,
			$main::SR_xmin-$dis,           $main::SR_ymax+$dis-$arc_size,
		    $symbol);
	add_line($main::SR_xmin-$dis+$arc_size, $main::SR_ymax+$dis,
			$main::SR_xmax+$dis-$arc_size, $main::SR_ymax+$dis,
		    $symbol);
}
