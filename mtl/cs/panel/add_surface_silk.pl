use strict;
use warnings;

my ($face_type,$surface_x,$sufrace_y) = ($main::face_type,$main::grid{x}[11]+0.4,$main::SR_ymin - 0.3,);

clear('gtl');

add_pad($surface_x,$sufrace_y,$face_type);

clear();
#p__("butfly ok");
1;


=head

my $ref_info=info('step',"$JOB/pnl","SR_LIMITS");
$main::SR_xmin=$ref_info->{gSR_LIMITSxmin};
$main::SR_ymin=$ref_info->{gSR_LIMITSymin};
$main::SR_xmax=$ref_info->{gSR_LIMITSxmax};
$main::SR_ymax=$ref_info->{gSR_LIMITSymax};


add_pad(   $main::grid{x}[$_],   0.3,                'r128');
   add_pad(   0.3,                 $main::grid{y}[$_],  'r128');