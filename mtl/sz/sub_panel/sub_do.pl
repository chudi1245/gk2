use strict;
no strict "vars";

###_______________________________________________new panel
$f->VOF;
creat_step($JOB,'pcs');
$f->VON;
$f->COM ('open_entity',
	    job=>$JOB,
		type=>'step',
		name=>'pcs',
		iconic=>'no');
$f->AUX ('set_group',group=>$f->{COMANS});
clear();
$f->COM('affected_layer',mode=>'all',affected=>'yes');
$f->COM('sel_delete');
##____________________________________________________transtform unit
map {$_=$_/$I2M}($dx,$dy,$width,$joint,);

foreach  ( @grid_tool_entry) {                              
	my ($col,$row)=($_->{col}, $_->{row});
	$tool{$col}{$row}/=$I2M;
}
foreach  ( @grid_fiducial_entry) {                              
	my ($col,$row)=($_->{col}, $_->{row});
	$fiducial{$col}{$row}/=$I2M;
}
###___________________________________________________________set parameter
my(@prof_limits,$nub_blank);
my($blankt,$blankb,$blankr,$blankl,); 
@prof_limits=prof_limits('pcb');
#####p__("@prof_limits");
($pcbx,$pcby)=($prof_limits[2]-$prof_limits[0],$prof_limits[3]-$prof_limits[1]);

###p__("$pcbx,$pcby");
if ($direction eq "X"  ) {
	$blankt=$blankb=0;
	$blankr=$blankl=$width;
	$px=$pcbx*$nx + $dx*($nx-1) + ($width+$joint)*2;
	$py=$pcby*$ny + $dy*($ny-1);
}
if ($direction eq "Y") {
	$blankt=$blankb=$width;
	$blankr=$blankl=0;
	$px=$pcbx*$nx + $dx*($nx-1);
	$py=$pcby*$ny + $dy*($ny-1) + ($width+$joint)*2;
}
if ($direction eq "ALL") {
	$blankt=$blankb=$width;
	$blankr=$blankl=$width;
	$px=$pcbx*$nx + $dx*($nx-1) + ($width+$joint)*2;
	$py=$pcby*$ny + $dy*($ny-1) + ($width+$joint)*2;
}
if ($direction eq "N") {
	$blankt=$width+$joint;
	$blankr=$blankl=$blankb=0;
	$px=$pcbx*$nx + $dx*($nx-1) + ($width+$joint)*0;
	$py=$pcby*$ny + $dy*($ny-1) + ($width+$joint)*1;
}
if ($direction eq "S") {
	$blankb=$width+$joint;
	$blankr=$blankl=$blankt=0;
	$px=$pcbx*$nx + $dx*($nx-1) + ($width+$joint)*0;
	$py=$pcby*$ny + $dy*($ny-1) + ($width+$joint)*1;
}
if ($direction eq "W") {
	$blankl=$width+$joint;
	$blankb=$blankr=$blankt=0;
	$px=$pcbx*$nx + $dx*($nx-1) + ($width+$joint)*1;
	$py=$pcby*$ny + $dy*($ny-1) + ($width+$joint)*0;
}
if ($direction eq "E") {
	$blankr=$width+$joint;
	$blankb=$blankl=$blankt=0;
	$px=$pcbx*$nx + $dx*($nx-1) + ($width+$joint)*1;
	$py=$pcby*$ny + $dy*($ny-1) + ($width+$joint)*0;
}
######p__("$px   $py");
$px+=0.0001;
$py+=0.0001;
###______________________________________________________
$f->COM ('sr_auto',
         step                =>'pcb',
         num_mode            =>'multiple',
         xmin                =>0,
         ymin                =>0,
         width               =>$px,
         height              =>$py,
         panel_margin        =>0,
         step_margin         =>0,
         gold_plate          =>'no',
         gold_side           =>'right',
         orientation         =>'horizontal', ##'any'
         evaluate            =>'no',
         active_margins      =>'yes',
         top_active          =>$blankt,
         bottom_active       =>$blankb,
         left_active         =>$blankl,
         right_active        =>$blankr,
         step_xy_margin      =>'yes',
         step_margin_x       =>$dx,
         step_margin_y       =>$dy);
$f->COM ('set_attribute',
         type                         =>'step',
         job                          =>$JOB,
         name1                        =>'pcs',
         name2                        =>'',
         name3                        =>'',
         attribute                    =>'.pnl_class',
         value                        =>'',
         units                        =>'inch');
$f->COM ('set_attribute',
         type                         =>'step',
         job                          =>$JOB,
         name1                        =>'pcs',
         name2                        =>'',
         name3                        =>'',
         attribute                    =>'.pnl_pcb',
         value                        =>'pcb',
         units                        =>'inch');
###______________________________________________________creat_box
##$f->COM ('profile_to_rout',layer=>'box',width=>10);
1;



