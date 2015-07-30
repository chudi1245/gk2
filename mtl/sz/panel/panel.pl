use strict;
##no strict 'vars';
use warnings;
my $JOB=$main::JOB;
my $f=\$main::f;
my $panel='pnl';

unit_set('inch');
my ($layer_number,$step_xy_margin,$step_margin_x,$step_margin_y);
my $addition=0;
if ($main::g_moudel eq "Steel" ){$addition = 3;}
my %blank=(
top =>   ($main::margin->{top} + $addition) / $main::I_M,
bot =>   ($main::margin->{bot} + $addition) / $main::I_M,
rig =>   ($main::margin->{rig} + $addition) / $main::I_M,
lef =>   ($main::margin->{lef} + $addition) / $main::I_M,
);

###____________________________________
if ($main::dx or $main::dy ) {
	$step_xy_margin='yes';
	($step_margin_x, $step_margin_y)=($main::dx/$main::I_M, $main::dy / $main::I_M);
}else{
	$step_xy_margin='no';
	($step_margin_x,$step_margin_y)=(0.0787401575,0.0787401575,);
}
###____________________________________________________________

clear();
clear_creat_step($panel);
clear();

( exists_entity('step',"$JOB/pcs") eq 'yes' ) ? ($main::base_step='pcs') : ($main::base_step='pcb') ;


##判断是否能至少拼一个单元
my $ref = info('step',  "$main::JOB//$main::base_step",  'PROF_LIMITS');
my ($step_short, $step_long) = sort{$a<=>$b}( $ref->{gPROF_LIMITSxmax} - $ref->{gPROF_LIMITSxmin},  $ref->{gPROF_LIMITSymax} - $ref->{gPROF_LIMITSymin}, );
my ($p_short, $p_long) = sort{$a<=>$b}( $main::px-$blank{lef}-$blank{rig}, $main::py-$blank{top}-$blank{bot}  ); 
##unless ($p_short > $step_short and $p_long > $step_long) {
##	return 501;
##}


$$f->COM ('sr_auto',
         step                =>$main::base_step,
         num_mode            =>'multiple',
         xmin                =>0,
         ymin                =>0,
         width               =>$main::px,
         height              =>$main::py,
         panel_margin        =>0,
         step_margin         =>0.0787401575,
         gold_plate          =>'no',
         gold_side           =>'right',
         orientation         =>$main::orientation,  ###
         evaluate            =>'no',
         active_margins      =>'yes',
         top_active          =>$blank{top},
         bottom_active       =>$blank{bot},
         left_active         =>$blank{lef},
         right_active        =>$blank{rig},
         step_xy_margin      =>$step_xy_margin,
         step_margin_x       =>$step_margin_x,   ##dx
         step_margin_y       =>$step_margin_y);  ##dy
$$f->COM ('set_attribute',
         type                         =>'step',
         job                          =>$JOB,
         name1                        =>$panel,
         name2                        =>'',
         name3                        =>'',
         attribute                    =>'.pnl_class',
         value                        =>'',
         units                        =>'inch');
$$f->COM ('set_attribute',
         type                         =>'step',
         job                          =>$JOB,
         name1                        =>$panel,
         name2                        =>'',
         name3                        =>'',
         attribute                    =>".pnl_pcb",
         value                        =>$main::base_step,
         units                        =>'inch');

open_step($panel);


$$f->COM ('sredit_popup');
unit_set('mm');
p__('PLS adjust makeup');

$$f->COM ('sredit_close');
unit_set('inch');;
#p__('panel ok');
1;






=head
$layer_number= scalar @{$main::layer_class{line}};
($layer_number <= 2)  ?  (  map{ $blank{$_}=0.3 }@blank_key  )  :
($layer_number <= 5)  ?  (  map{ $blank{$_}=0.4 }@blank_key  )  :
                         (  map{ $blank{$_}=0.6 }@blank_key  );

