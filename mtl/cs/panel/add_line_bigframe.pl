use strict;
use warnings;

my @sypad=@main::sypad;
my $class=\%main::layer_class;
my @add_layer;
map {  @add_layer=(@add_layer, @{$class->{$_}}, ) if exists $class->{$_}  } (qw\outer solder_mask\);

#	$pin_cent = $main::py /2;
#	$pin1_x= $main::SR_xmin - 0.27559;
###________________________________________ $sypad[2]{x}
my %big_frame=(
  xmin=>$sypad[2]{x} - 0.55118,        ## xmin=>$main::SR_xmin - 0.82677,  2014-6-10修改
  ymin=>$main::py /2 - 12.95,
  xmax=>$sypad[2]{x} - 0.55118 + 21.9, ## xmax=>$main::SR_xmin - 0.82677 + 21.9, 2014-6-10 修改
  ymax=>$main::py /2 - 12.95 + 25.9,
);

if ($main::layer_number > 1) {
    clear();
    affected_layer('yes', 'single', @add_layer );
    add_line($big_frame{xmax},$big_frame{ymax},$big_frame{xmax},$big_frame{ymin},'r10');
    add_line($big_frame{xmax},$big_frame{ymin},$big_frame{xmin},$big_frame{ymin},'r10');
    add_line($big_frame{xmin},$big_frame{ymin},$big_frame{xmin},$big_frame{ymax},'r10');
    add_line($big_frame{xmin},$big_frame{ymax},$big_frame{xmax},$big_frame{ymax},'r10');
}

clear();

###p__('line frame ok');

1;


=head
###  6.30 增加此子程序
四、线路阻焊外大边框的添加
1、大边框尺寸：21.9*25.9inch  
2、边框线宽设计为10mil
3、大边框居中设计，即21.9inch所在一边到板中间的距离相等（下图中的上下边））
4、25.9inch所在一边距离销钉孔中心14mm。

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
