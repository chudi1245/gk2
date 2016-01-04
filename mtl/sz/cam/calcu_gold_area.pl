#!/usr/bin/perl
#use strict;
use Tk;
use Genesis;
use FBI;
use Win32;
use Win32::API;
use Encode;
use encoding 'euc_cn';

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

my ($topcu,$botcu,$topbi,$botbi);
my ($column,)=(undef,0);
$f->COM(units, type =>"mm");

kysy();

####################################################
if ($STEP ne 'pnl') {
		p__("the step is not pnl"); 
		exit;  
}

$f->INFO(units => 'mm',
	entity_type => 'step',
	entity_path => "$JOB/pnl",);

#**************************
my($pxmax,$pxmin,$pymax,$pymin,$limitx,$limity);

$pxmax = $f->{doinfo}{gSR_LIMITSxmax};
$pxmin = $f->{doinfo}{gSR_LIMITSxmin};
$pymax = $f->{doinfo}{gSR_LIMITSymax};
$pymin = $f->{doinfo}{gSR_LIMITSymin};

#####$f->COM("profile_rect,x1=$pxmin,y1=$pymin,x2=$pxmax,y2=$pymax");

if ( exists_layer('gtl')  eq  'yes' ) {   
	if ( exists_layer('gts')  eq  'yes' ) {	 
	$f->COM("exposed_area,layer1=gtl,mask1=gts,layer2=,mask2=gbs,drills=no,resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");
	$x=$f->{COMANS};
	($topcu,$topbi)=split(' ',$x);
	$topcu = sprintf "%6.2f",$topcu/10000;
	$topbi = sprintf "%6.0f",$topbi;
	$topbi="$topbi"."%";
	}else { 

    $f->COM("profile_rect,x1=$pxmin,y1=$pymin,x2=$pxmax,y2=$pymax");

	$f->COM("copper_area,layer1=gtl,layer2=,drills=no,resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");
	$x=$f->{COMANS};
	($topcu,$topbi)=split(' ',$x);
	$topcu = sprintf "%6.2f",$topcu/10000;
	$topbi = sprintf "%6.0f",$topbi;
	$topbi="$topbi"."%";

	$f->COM("undo");

	}
}

##p__(" $topcu  $topbi");

if ( exists_layer('gbl')  eq  'yes' ) {   
	if ( exists_layer('gbs')  eq  'yes' ) { 
		$f->COM("exposed_area,layer1=,mask1=gts,layer2=gbl,mask2=gbs,drills=no,resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");

	$y=$f->{COMANS};
	($botcu,$botbi)=split(' ',$y);
	$botcu = sprintf "%6.2f",$botcu/10000;
	$botbi = sprintf "%6.0f",$botbi;
	$botbi="$botbi"."%";
	}else{
	$f->COM("profile_rect,x1=$pxmin,y1=$pymin,x2=$pxmax,y2=$pymax");
    $f->COM("copper_area,layer1=,layer2=gbl,drills=no,resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");
	$y=$f->{COMANS};
	($botcu,$botbi)=split(' ',$y);
	$botcu = sprintf "%6.2f",$botcu/10000;
	$botbi = sprintf "%6.0f",$botbi;
	$botbi="$botbi"."%";

    $f->COM("undo");

	}
}

##p__(" $botcu  $botbi");

$mw=MainWindow->new;

$mw->update;
  Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);
#####################
$mw->title("计算沉金面积，Better and better");
$mw->geometry("+350+280");
my @label=qw{层名 沉金面积 百分比};
foreach (@label)  {  $mw->Label(-text=>$_,-width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>$column++, -row=>0);}

$mw->Label(-text=>'Top', -width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>0, -row=>1);
$mw->Label(-text=>$topcu,-width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>1, -row=>1);
$mw->Label(-text=>$topbi,-width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>2, -row=>1);

$mw->Label(-text=>'Bot', -width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>0, -row=>2);
$mw->Label(-text=>$botcu,-width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>1, -row=>2);
$mw->Label(-text=>$botbi,-width=>10,-relief=>'g',-bg => 'turquoise',-font => [-size => 14],)->grid(-column=>2, -row=>2);

MainLoop;


=head
$f->COM("copper_area,layer1=$gROWname[$_],layer2=,drills=yes,consider_rout=no,drills_source=matrix,thickness=0,resolution_value=25.4,x_boxes=3, y_boxes=3,area=no,dist_map=yes");
$x=$f->{COMANS};
($a,$b)=split(' ',$x);
$a = sprintf "%6.2f",$a/10000;
$b = sprintf "%6.2f",$b;
$cu+=$a;
$bi+=$b;


$f->COM("copper_area,layer1=gtl,layer2=,drills=no,resolution_value=25.4,
        x_boxes=3,y_boxes=3,area=no,dist_map=yes");


$f->COM("exposed_area,layer1=gtl,mask1=gts,layer2=,mask2=gbs,drills=no,
        resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");

$f->COM("exposed_area,layer1=,mask1=gts,layer2=gbl,mask2=gbs,drills=no,
        resolution_value=25.4,x_boxes=3,y_boxes=3,area=no,dist_map=yes");


