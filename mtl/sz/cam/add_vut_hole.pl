#!/usr/bin/perl
use Win32;
use FBI;
use Genesis;
use Encode;
use encoding 'euc_cn';

#
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
#Global Variables
my $vcut = "dircy";


# Main Window
my $mw = new MainWindow;
$mw -> title( "添加VUT工具孔" );
$mw->geometry("320x100+200+100");

#Directory  x  or y
my $frm_vut = $mw -> Frame();
my $lbl_vut = $frm_vut -> Label(-text=>"选择方向",-font => [-size => 12],);

my $rdb_x = $frm_vut -> Radiobutton(-text=>"Y 方向",  -value=>"dircy", -variable=>\$vcut,-font => [-size => 12],);
my $rdb_y = $frm_vut -> Radiobutton(-text=>"X 方向",  -value=>"dircx", -variable=>\$vcut,-font => [-size => 12],);
my $rdb_b = $frm_vut -> Radiobutton(-text=>"Y_and_X", -value=>"dircb", -variable=>\$vcut,-font => [-size => 12],);

my $but = $mw -> Button(-text=>"添加",-width=>15, -command =>\&apply,-font => [-size => 12],);

#Geometry Management
$frm_vut -> grid(-row=>1,-column=>1);
$rdb_x -> grid(-row=>1,-column=>2);
$rdb_y -> grid(-row=>1,-column=>3);
$rdb_b -> grid(-row=>1,-column=>4);

$frm_vut -> grid(-row=>3,-column=>1,-columnspan=>2);
$but -> grid(-row=>4,-column=>1,-columnspan=>2);

MainLoop;

sub apply{

##init variable global
unit_set('inch');
my $SR_info=info('step',"$JOB/pnl","SR_LIMITS");
my ($SR_xmin,$SR_ymin,$SR_xmax,$SR_ymax);
$SR_xmin=$SR_info->{gSR_LIMITSxmin};
$SR_ymin=$SR_info->{gSR_LIMITSymin};
$SR_xmax=$SR_info->{gSR_LIMITSxmax};
$SR_ymax=$SR_info->{gSR_LIMITSymax};


my $PROF_ref = info('step',"$JOB/pnl",'PROF_LIMITS');
my ($Prof_xmin,$Prof_ymin,$Prof_xmax,$Prof_ymax);
$Prof_xmin = $PROF_ref->{gPROF_LIMITSxmin};
$Prof_xmax = $PROF_ref->{gPROF_LIMITSxmax};
$Prof_ymax = $PROF_ref->{gPROF_LIMITSymax};
$Prof_ymin = $PROF_ref->{gPROF_LIMITSymin};
my($px,$py)=($Prof_xmax - $Prof_xmin, $Prof_ymax - $Prof_ymin);

my $res_x = ($px - $SR_xmax) * 25.397;
my $res_y = ($py  -$SR_ymax) * 25.397;


#if (exists_layer('cy') eq 'yes') {
#	my $Limit_ref = info('layer',"$JOB/pnl/cy",'LIMITS');
#	$orig_xmin = $Limit_ref->{gLIMITSxmin};
#	$orig_ymin = $Limit_ref->{gLIMITSymin};
#}


##25.397
$layer_number=0;
my $info_ref=info('matrix',"$JOB/matrix",'row');
my @gROWrow       =@{$info_ref->{gROWrow}};
my @gROWcontext   =@{$info_ref->{gROWcontext}};
my @gROWlayer_type=@{$info_ref->{gROWlayer_type}};
foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board'){
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
			$layer_number++;
		}
	}
}
## my $dis_2=0.5118;   my $dis=0.1968;

#####
my ($orig_xmin ,$orig_ymin) = (0,0);
if ($layer_number > 2) {
	if ($res_y >= 18) { $orig_ymin = 0.1968;}else{ $orig_ymin = $SR_ymin - 0.5118;}
	if ($res_x >= 18) { $orig_xmin = 0.1968;}else{ $orig_xmin = $SR_xmin - 0.5118;}
}

###################离板边距离。
#my ($origx,$origy);  
#if ($res_x < 10) { $origx = $SR_xmin - 0.19685; } else { $origx = $SR_xmin - 0.27559;}
#if ($res_y < 10) { $origy = $SR_ymin - 0.19685; } else { $origy = $SR_ymin - 0.27559;}

my ($origx,$origy) = (0.19685,0.19685);
if ($layer_number > 2) {
	$origx = $orig_xmin + 0.19685;
	$origy = $orig_ymin + 0.19685;
}
###############################计算X方向与Y方向添加vut定位孔的个数。
#my $vut_holeNunberx = int(($px - $origx )/3.9370078740 );
#my $vut_holeNunbery = int(($py - $origy )/3.9370078740 );

my $vut_holeNunberx = int(($px )/3.9370078740 ) - 1;
my $vut_holeNunbery = int(($py )/3.9370078740 ) - 1;
my ($vut_holex,$vut_holey) = ($orig_xmin + 1.9685039,$orig_ymin + 1.9685039,);


if ( exists_layer('vut_map') eq 'yes' ) {$f->COM("delete_layer,layer=vut_map");}
creat_clear_layer('vut_map');

p__("type = $vcut y= $vut_holeNunbery");

if ($vcut eq 'dircy') {
	foreach  (0..$vut_holeNunbery ) {
		clear('vut_map'); 
		add_pad($origx,$vut_holey,'r126.14173228346'); 
		$vut_holey+=3.9370078740;  
    }
}
elsif ($vcut eq 'dircx') {
	foreach  (0..$vut_holeNunberx ) {
		clear('vut_map'); 
		add_pad($vut_holex,$origy,'r126.14173228346'); 
	    $vut_holex+=3.9370078740;  
	}
}
elsif ($vcut eq 'dircb') {   
	foreach  (0..$vut_holeNunbery ) {
		clear('vut_map'); 
		add_pad($origx,$vut_holey,'r126.14173228346'); 	
		$vut_holey+=3.9370078740;  
	}

	foreach  (0..$vut_holeNunberx ) {
		clear('vut_map'); 
		add_pad($vut_holex,$origy,'r126.14173228346');
		$vut_holex+=3.9370078740;  
	}
}else{exit;}


##请确认是否OK！！
p__("add vut_hole is ok,Please check!");

clear(vut_map);
foreach my $layerName (qw/drl gtl gbl gts gbs/) {
	my($invert , $size);

	($layerName =~ m/(g[tb]l)/i) ? ($invert='yes',$size =40) :
	($layerName =~ m/(g[tb]s)/i) ? ($invert='no', $size =12) :
	($layerName =~ m/drl/i)		 ? ($invert='no', $size =0 ) : ();

	##p__("$layerName,$invert,$size");

	copy_other($layerName,$invert,$size);
}

exit;

}


sub copy_other{
    my $target_layer=shift || 'tmp';
    my $invert =shift || 'no';
    my $size =shift || 0;

    $f->COM ('sel_copy_other',
		dest          =>'layer_name',
		target_layer  =>$target_layer,
		invert        =>$invert,
		dx            =>0,
		dy            =>0,
		size          =>$size,
		x_anchor      =>0,
		y_anchor      =>0,
		rotation      =>0,
		mirror        =>'none');

}

=head

#my $vut_holeNunberx = int(($px - 0.3 )/3.9370078740 );
#my $vut_holeNunbery = int(($py - 0.3 )/3.9370078740 );


#my ($vut_holex,$vut_holey);
#if ($vut_holeNunberx % 2 == 0) {
#   $vut_holex= ($px /2 )- (int($vut_holeNunberx / 2)) * 3.9370078740 + (3.9370078740/2); 
#}else{
#   $vut_holex= ($px /2) - (int($vut_holeNunberx / 2)) * 3.9370078740; 
#}

#if ($vut_holeNunbery % 2 == 0) {
#   $vut_holey= ($py /2) - (int($vut_holeNunbery / 2)) * 3.9370078740 + (3.9370078740/2); 
#}else{
#   $vut_holey= ($py /2) - (int($vut_holeNunbery / 2)) * 3.9370078740; 
#}