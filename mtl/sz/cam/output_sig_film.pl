#! /usr/bin/perl 
use strict;
use Tk;
use Win32;
use Tk::Pane;
use Genesis;
use FBI;
use Win32::API;
use Encode;
use Encode::CN;
use File::Path; 
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________

kysy();

my $test_orig=exists_entity('step',"$JOB/orig");
my $test_pcb =exists_entity('step',"$JOB/pcb");
my $test_pnl =exists_entity('step',"$JOB/pnl");

if ($test_orig eq 'no' or $test_pcb eq 'no' or $test_pnl eq 'no' 
	  or $STEP eq 'pnl' ){exit}
unit_set('inch');
#___________________________________
my (@gROWrow,@gROWside,@gROWcontext,@gROWlayer_type,@gROWname,@gROWtype,@prof_limits,%prof_center);
my ($flage_tgz,$out_path,$mw,$encode,$tgz_info,$value)=(1, "D:/work/output/");
my (%mirror,%button_mirror,%checkbutton_out,%checkbutton_value,%entry_scale_x,%entry_scale_y,%scale_x,%scale_y,%button_scalxy,%label_info,%out_info);
my ($column, $row,$number_set_all,$inner_num)=(0,0,0);
@gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
@gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
@gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
@gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};
@prof_limits=prof_limits($STEP);

$prof_center{x}=($prof_limits[2]+$prof_limits[0])/2;
$prof_center{y}=($prof_limits[3]+$prof_limits[1])/2;
#____________________________________
if (not -d  $out_path) { File::Path::mkpath($out_path) or die $! }
my $franm=MainWindow->new;
#____________________________________保证程序置顶显示
$franm->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($franm->frame()),-1,0,0,0,0,3);


my $title = "输出单只(在pcb或orig或pcs下运行)";
$title=decode("cp936",$title);

$franm->title($title);   
$franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>450 )->pack();
###定义列名
my $cenname  = "层名";
$cenname=decode("cp936",$cenname);
my $pathNmae = "路径";
$pathNmae=decode("cp936",$pathNmae);

$mw->Label(-text=>$cenname,  -width=>5,-font=>[-size=>12],)->grid(-column=>$column++, -row=>$row,); 
$mw->Button(-text=>'all',    -width=>5,-font=>[-size=>12],-command=>\&set_all,)->grid(-column=>$column++, -row=>$row,); 
$mw->Button(-text=>$pathNmae,-width=>5,-font=>[-size=>12],-command=>\&choose_path,)->grid(-column=>$column++,-row=>$row,);

unless ($encode) {$encode="D:/work/output/"};
unless ($out_path) {$out_path="D:/work/output/"};

$mw->Label(-textvariable=>\$encode,-width=>16,-font=>[-size=>12],-relief=>'groove')->grid(-column=>++$column, -row=>$row,);

foreach  (0..@gROWname) {
if ($gROWname[$_] ){
	$mw->Label(-text=>$gROWname[$_],-font=>[-size=>12],-width=>10,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	$checkbutton_out{$_}=$mw->Checkbutton(-variable=>\$checkbutton_value{$_})->grid(-column=>1, -row=>$row,);  
	}
}

#my $mystep = 'pcb'; # set default value 
#foreach (qw/pcb orig pcs/) { 
#$mw->Radiobutton(-text =>$_, -variable => \$mystep, -font=>[-size=>12], 
#	             -foreground => "blue",-background => "green", )->pack(-side => 'left');
#}

my $quitp = "退出";$quitp=decode("cp936",$quitp);
#my $defaultp = "默认";$defaultp=decode("cp936",$defaultp);

my $outputp = "菲林输出";$outputp=decode("cp936",$outputp);

$franm->Button(-text=>$quitp,   -font=>[-size=>12],-command=>sub{exit},-width=>10,)->pack(-side =>'left'); 
#$franm->Button(-text=>$defaultp,-font=>[-size=>12],-command=>\&default,-width=>10,)->pack(-side => 'left');
$franm->Button(-text=>$outputp, -font=>[-size=>12],-command=>\&out_put,-width=>18,)->pack(-side => 'right');
&brush();
&default();
MainLoop;

#————————————————————窗口完毕，下面是子程序！
sub set_all {
	$value=not $value;
	foreach  (keys %checkbutton_value) { 
			  $checkbutton_value{$_}=$value;	
	}
}

sub default {
     foreach  (0..@gROWname) {
		if ($gROWname[$_] ){
		if (  $gROWlayer_type[$_] !~ m{solder_paste|document}  and  $gROWcontext[$_] eq 'board' ) {
		$checkbutton_value{$_}=1;
			}else{
				 $checkbutton_value{$_}=0;
			    }
		if( $gROWlayer_type[$_] eq 'rout' or $gROWlayer_type[$_] eq 'drill'  ){
				 $checkbutton_value{$_}=0;
			 }	
		}
    }
}

sub choose_path {
	$out_path=$mw->chooseDirectory(-initialdir => "D:/work/output/");
	$encode=decode("gbk",odd_decode($out_path)); 
	unless ($encode) {$encode="D:/work/output/"};
    unless ($out_path) {$out_path="D:/work/output/"}
}

sub brush {
	foreach  (0..@gROWname) {
		if ($gROWname[$_] ) {
		 $checkbutton_value{$_}=0;
		}
	}
}

sub out_put {
	foreach  (keys %checkbutton_value) {
		if ($checkbutton_value{$_}) {
		    output_layer($gROWname[$_],$out_path,$prof_center{x},$prof_center{y});
			$mw->update();
		}
	}
	exit;
}

sub output_layer {
	my $layer=shift;
	my $path=shift||'D:/work/output';
	my $x_anchor=shift||0;
	my $y_anchor=shift||0;
	my $mirror=shift||'no' ;
	my $x_scale=shift||1;
	my $y_scale=shift||1;

    my $angle=shift||0;
    my $whel=shift||0;
    my $pre = "$JOB"."-";

$f->COM ('output_layer_reset');
$f->COM ('output_layer_set',
	   layer=>$layer,
	   angle=>$angle,
	   mirror=>$mirror,
	   x_scale=>$x_scale,
	   y_scale=>$y_scale,
	   comp=>0,
	   polarity=>'positive',
	   setupfile=>'',
	   setupfiletmp=>'',
	   line_units=>'inch',
	   gscl_file=>'');
$f->COM ('output',
	   job=>$JOB,
	   step=>$STEP,
	   format=>'Gerber274x',
	   dir_path=>$path,
	   prefix=>$pre,
	   suffix=>'.GBR',
	   break_sr=>'yes',
	   break_symbols=>'yes',
	   break_arc=>'yes',
	   scale_mode=>'nocontrol',
	   surface_mode=>'fill',
	   min_brush=>1,
	   units=>'inch',
	   coordinates=>'absolute',
	   zeroes=>'none',
	   nf1=>2,
	   nf2=>4,
	   x_anchor=>$x_anchor,
	   y_anchor=>$y_anchor,
	   wheel=>'',
	   x_offset=>0,
	   y_offset=>0,
	   line_units=>'inch',
	   override_online=>'yes',
	   film_size_cross_scan=>0,
	   film_size_along_scan=>0,
	   ds_model=>'RG6500');
$f->COM ('disp_on');
$f->COM ('origin_on') && return 'ok';
}

1;
