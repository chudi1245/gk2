use strict;
use warnings;
my $JOB=$main::JOB;
my $sys_offset;

my $ref_info=info('step',"$JOB/pnl","SR_LIMITS");
$main::SR_xmin=$ref_info->{gSR_LIMITSxmin};
$main::SR_ymin=$ref_info->{gSR_LIMITSymin};
$main::SR_xmax=$ref_info->{gSR_LIMITSxmax};
$main::SR_ymax=$ref_info->{gSR_LIMITSymax};

foreach (1..13) {
	$main::grid{x}[$_]=$main::SR_xmin + ($_*2-1)*($main::SR_xmax - $main::SR_xmin)/26;
	$main::grid{y}[$_]=$main::SR_ymin + ($_*2-1)*($main::SR_ymax - $main::SR_ymin)/26;
}

if    ($main::px-$main::SR_xmax >= 0.39370 and $main::py-$main::SR_ymax >= 0.39370){
	$sys_offset = 0.23622;
}elsif($main::px-$main::SR_xmax >= 0.35433 and $main::py-$main::SR_ymax >= 0.35433){
	$sys_offset = 0.19685;
}else{
	$sys_offset = 0.15748;
}

@main::sypad=( 
     {x=>$main::SR_xmax + $sys_offset,  y=>$main::SR_ymax + $sys_offset - 0.23622},
     {x=>$main::SR_xmax + $sys_offset,  y=>$main::SR_ymax + $sys_offset},
	 {x=>$main::SR_xmin - $sys_offset,  y=>$main::SR_ymax + $sys_offset},
     {x=>$main::SR_xmin - $sys_offset,  y=>$main::SR_ymin - $sys_offset},
     {x=>$main::SR_xmax + $sys_offset,  y=>$main::SR_ymin - $sys_offset},      
);


my $off_set=0.28;
#my $target_tool;
#my $start_point; 
##定义工具孔的中心点位置。
if ($main::px <= $main::py) {
	if ($main::py <13) {
		$main::start_point = $main::grid{y}[7] - 1.5;
	}elsif  ($main::py <15) {
		$main::start_point = $main::grid{y}[7] - 1;
	}elsif  ($main::py <17) {
		$main::start_point = $main::grid{y}[7] + 0.25;
	}else{
		$main::start_point = $main::grid{y}[7];
	}
}else{
	if ($main::px <13) {
		$main::start_point = $main::grid{x}[7] + 1.5;
	}elsif  ($main::px <15) {
		$main::start_point = $main::grid{x}[7] + 1;
	}elsif  ($main::px <17) {
		$main::start_point = $main::grid{x}[7] - 0.25;
	}else{
		$main::start_point = $main::grid{x}[7];
	}
}

#定义加工具孔的坐标
if ($main::px <= $main::py) {
	$main::target_tool=[ 
	{x=>$main::px-$off_set,    y=>$main::start_point + 0.188 }, 
	{x=>$off_set,              y=>$main::start_point  }, 
	{x=>$main::grid{x}[7],     y=>$main::py-$off_set  }, 
 	{x=>$main::grid{x}[7],     y=>$off_set  }, 
];

}else{
	$main::target_tool=[ 
	{x=>$main::px-$off_set,       y=>$main::grid{y}[7]  }, 
	{x=>$off_set,                 y=>$main::grid{y}[7]  }, 
	{x=>$main::start_point-0.188, y=>$main::py-$off_set  }, 
 	{x=>$main::start_point,       y=>$off_set  }, 
];

}

1;

##2012-6-7修改。
=head 
#定义加工具孔的坐标
if ($main::px <= $main::py) {
	$main::target_tool=[ 
	{x=>$main::px-$off_set,    y=>$main::start_point + 0.188 }, 
	{x=>$off_set,              y=>$main::start_point  }, 
	{x=>$main::grid{x}[7],     y=>$main::py-$off_set  }, 
 	{x=>$main::grid{x}[7]+0.2, y=>$off_set  }, 
];

}else{
	$main::target_tool=[ 
	{x=>$main::px-$off_set,       y=>$main::grid{y}[7]  }, 
	{x=>$off_set,                 y=>$main::grid{y}[7]  }, 
	{x=>$main::start_point-0.188, y=>$main::py-$off_set  }, 
 	{x=>$main::start_point,       y=>$off_set  }, 
];

