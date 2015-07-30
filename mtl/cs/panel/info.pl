use strict;
use warnings;
my $JOB=$main::JOB;

my $ref_info=info('step',"$JOB/pnl","SR_LIMITS");
$main::SR_xmin=$ref_info->{gSR_LIMITSxmin};
$main::SR_ymin=$ref_info->{gSR_LIMITSymin};
$main::SR_xmax=$ref_info->{gSR_LIMITSxmax};
$main::SR_ymax=$ref_info->{gSR_LIMITSymax};

my $profile_info=info('step',"$JOB/pnl","PROF_LIMITS");
$main::Prof_xmin=$profile_info->{gPROF_LIMITSxmin};
$main::Prof_ymin=$profile_info->{gPROF_LIMITSymin};
$main::Prof_xmax=$profile_info->{gPROF_LIMITSxmax};
$main::Prof_ymax=$profile_info->{gPROF_LIMITSymax};

##########有效边X，Y最小最大。四个值。 0.157480

foreach (1..13) {
	$main::grid{x}[$_]=$main::SR_xmin + ($_*2-1)*($main::SR_xmax - $main::SR_xmin)/26;
	$main::grid{y}[$_]=$main::SR_ymin + ($_*2-1)*($main::SR_ymax - $main::SR_ymin)/26;
}


=head
if ($main::layer_number < 3){
	@main::sypad=( 
	 {x=>$main::Prof_xmax - 0.157480,  y=>$main::Prof_ymax - 0.157480},
     {x=>$main::Prof_xmax - 0.157480,  y=>$main::Prof_ymax - 0.3937  },
	 {x=>$main::Prof_xmin + 0.157480,  y=>$main::Prof_ymax - 0.157480},
     {x=>$main::Prof_xmin + 0.157480,  y=>$main::Prof_ymin + 0.157480},
     {x=>$main::Prof_xmax - 0.157480,  y=>$main::Prof_ymin + 0.157480}, 

);}else{
@main::sypad=( 
	 {x=>$main::SR_xmax + 0.236220,  y=>$main::SR_ymax + 0.236220},
     {x=>$main::SR_xmax + 0.236220,  y=>$main::SR_ymax + 0       },
	 {x=>$main::SR_xmin - 0.236220,  y=>$main::SR_ymax + 0.236220},
     {x=>$main::SR_xmin - 0.236220,  y=>$main::SR_ymin - 0.236220},
     {x=>$main::SR_xmax + 0.236220,  y=>$main::SR_ymin - 0.236220},      
);}
##########设置5个丝印定位pad座标点。  2014-5-25 changed by Mobin
=cut
my $dis_x = ($main::px - $main::cyx) / 2;    
my $dis_y = ($main::py - $main::cyy) / 2;

my $offset = 0.19685;
if ($main::layer_number < 3){
	@main::sypad=( 
	 {x=>$main::SR_xmax + $offset,  y=>$main::SR_ymax + $offset},
     {x=>$main::SR_xmax + $offset,  y=>$main::SR_ymax + 0       },
	 {x=>$main::SR_xmin - $offset,  y=>$main::SR_ymax + $offset},
     {x=>$main::SR_xmin - $offset,  y=>$main::SR_ymin - $offset},
     {x=>$main::SR_xmax + $offset,  y=>$main::SR_ymin - $offset},      
	);
}else{
	@main::sypad=( 
	 {x=>$main::Prof_xmax - $dis_x - 0.23622,  y=>$main::Prof_ymax - $dis_y - 0.23622},
     {x=>$main::Prof_xmax - $dis_x - 0.23622,  y=>$main::Prof_ymax - $dis_y - 0.47244},
	 {x=>$main::Prof_xmin + $dis_x + 0.23622,  y=>$main::Prof_ymax - $dis_y - 0.23622},
     {x=>$main::Prof_xmin + $dis_x + 0.23622,  y=>$main::Prof_ymin + $dis_y + 0.23622},
     {x=>$main::Prof_xmax - $dis_x - 0.23622,  y=>$main::Prof_ymin + $dis_y + 0.23622}, 
	);

	@main::jiaopad=( 
	 {x=>$main::Prof_xmin + $dis_x + 0.45,  y=>$main::Prof_ymin + $dis_y + 0.32},
	 {x=>$main::Prof_xmax - $dis_x - 0.45,  y=>$main::Prof_ymin + $dis_y + 0.32},
	 {x=>$main::Prof_xmax - $dis_x - 0.45,  y=>$main::Prof_ymax - $dis_y - 0.32},
	 {x=>$main::Prof_xmin + $dis_x + 0.45,  y=>$main::Prof_ymax - $dis_y - 0.32},   
	);

}

1;


