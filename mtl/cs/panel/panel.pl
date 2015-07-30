use strict;
##no strict 'vars';
use warnings;
my $JOB=$main::JOB;
my $f=\$main::f;
my $panel='pnl';

unit_set('inch');
my ($layer_number,$step_xy_margin,$step_margin_x,$step_margin_y);
####（层数，？，stepX宽度,stepY宽度）
my %blank=(
top =>   $main::margin->{top}/$main::I_M,
bot =>   $main::margin->{bot}/$main::I_M,
rig =>   $main::margin->{rig}/$main::I_M,
lef =>   $main::margin->{lef}/$main::I_M,
);
#############电镀边，上下左右由MM转为英制。
###____________________________________
if ($main::dx or $main::dy ) {
	$step_xy_margin='yes';
	($step_margin_x, $step_margin_y)=($main::dx/$main::I_M, $main::dy / $main::I_M);
}else{
	$step_xy_margin='no';
	($step_margin_x,$step_margin_y)=(0.0787401575,0.0787401575,);
}
### 拼板间距为DX。Dy，可手动输入，如果没输，按2MM。也就是0.0787401575 
###____________________________________________________________

p__("panel is not exist");
clear();
clear_creat_step($panel);    ###创建pnl
clear();

( exists_entity('step',"$JOB/pcs") eq 'yes' ) ? ($main::base_step='pcs') : ($main::base_step='pcb') ;
###如果存在pcs，拼板以pcs拼，否则以pcb拼。

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

#####打开pnl 

$$f->COM ('sredit_popup');
p__('PLS adjust makeup');

### 暂停：请调整结构。

$$f->COM ('sredit_close');
unit_set('inch');;
#p__('panel ok');
1;






=head
$layer_number= scalar @{$main::layer_class{line}};
($layer_number <= 2)  ?  (  map{ $blank{$_}=0.3 }@blank_key  )  :
($layer_number <= 5)  ?  (  map{ $blank{$_}=0.4 }@blank_key  )  :
                         (  map{ $blank{$_}=0.6 }@blank_key  );

COM {sr_auto,
step=pcb,
num_mode=multiple,
xmin=0,
ymin=0,
width=14,
height=18,
panel_margin=0,
step_margin=0.25,
gold_plate=no,
gold_side=right,
orientation=horizontal,
evaluate=no,
active_margins=yes,
top_active=0.6,
bottom_active=0.6,
left_active=0.5,
right_active=0.5,
step_xy_margin=no,
step_margin_x=0.25,
step_margin_y=0.25
}
COM set_attribute,type=step,job=d33716,name1=pnl,name2=,name3=,attribute=.pnl_class,value=,units=inch
COM set_attribute,type=step,job=d33716,name1=pnl,name2=,name3=,attribute=.pnl_pcb,value=pcb,units=inch
