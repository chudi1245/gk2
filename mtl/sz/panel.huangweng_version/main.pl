#!/usr/bin/perl 
##    zhouqing 
use strict;
use Tk;
use warnings;
use Cwd qw/abs_path/;
use File::Basename;
use lib abs_path(dirname(__FILE__));
use Win32;
use Genesis;
use FBI;
use Encode ;
our $host = shift; our $f = new Genesis($host); our $JOB = $ENV{JOB}; our $STEP = $ENV{STEP};
my $p_path = abs_path(dirname(__FILE__));
print "$p_path\n";
###_________________________________________
my ($mw,$row,$column,$tk_info,$schedule)=(undef,0,0);
our ($use,$px,$py,$dx,$dy,$margin_top,$margin_bot,$margin_rig,$margin_lef)=qw(zq 12 19 2 2);

our $margin={top=>5,bot=>5,lef=>5,rig=>5,};
our (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,@gROWfoil_side,);
our (%grid,$SR_xmin,$SR_ymin,$SR_xmax,$SR_ymax);
our (%layer_class,$layer_number);
our ($face_type,$tech_type,$orientation);
our (@polarity,@mirror,@x_scale,@y_scale);
our (@sypad,@butfly,@min_line,@silk_ref,%frame);
our ($base_step);
our $fn_xmax = 1.11;

*I_M=\25.397; our $I_M;
###_________________________________________
unit_set('inch');
require "$p_path/info_pre.pl"; 
###____________________________________________
$mw=Tk::MainWindow->new;  $mw->geometry("+200+100");  $mw->title("Better and better QQ-190170444");
my %title=(
   use              =>['Label',   0,  0,  '-text',          '用户',       ],
   use_entry        =>['Entry',   1,  0,  '-textvariable',  \$use,       ],
   px               =>['Label',   2,  0,  '-text',          'X拼版尺寸',  ],
   px_entry         =>['Entry',   3,  0,  '-textvariable',  \$px,        ],
   py               =>['Label',   4,  0,  '-text',          'Y拼版尺寸',  ],
   py_entry         =>['Entry',   5,  0,  '-textvariable',  \$py,        ],
   dx               =>['Label',   0,  2,  '-text',          'X间距',    ],
   dx_entry         =>['Entry',   1,  2,  '-textvariable',  \$dx,        ],
   dy               =>['Label',   2,  2,  '-text',          'Y间距',    ],
   dy_entry         =>['Entry',   3,  2,  '-textvariable',  \$dy,        ],
##===========================================================================================
   margin_top       =>['Label',   0,  4,  '-text',         '顶边间距',       ],
   margin_top_entry =>['Entry',   1,  4,  '-textvariable',  \$margin->{top}, ],
   margin_bot       =>['Label',   2,  4,  '-text',         '底边间距',       ],
   margin_bot_entry =>['Entry',   3,  4,  '-textvariable',  \$margin->{bot}, ],
   margin_lef       =>['Label',   0,  5,  '-text',         '左边间距',       ],
   margin_lef_entry =>['Entry',   1,  5,  '-textvariable',  \$margin->{lef}, ],
   margin_rig       =>['Label',   2,  5,  '-text',         '右边间距',       ],
   margin_rig_entry =>['Entry',   3,  5,  '-textvariable',  \$margin->{rig}, ],
##===========================================================================================
);
foreach  (keys %title) { 
	my ($wid_type, $text_type)=($title{$_}[0], $title{$_}[3]);
	if (not ref $title{$_}[4]) { $title{$_}[4]=decode('utf8',$title{$_}[4]); }
	$mw->$wid_type($text_type=>$title{$_}[4],-width=>10,)->grid(-column=>$title{$_}[1], -row=>$title{$_}[2]);
};
$mw->Label(-text=>'='x70,)->grid(-column=>0, -row=>3,-columnspan=>6,);

$mw->Optionmenu(-options =>[qw\any horizontal vertical\],-textvariable=>\$orientation,-width=>5)->grid(-column=>0,-row=>1);
$mw->Optionmenu(-options =>[qw\Im_AU Hasl OSP\],-textvariable=>\$face_type,-width=>5,)->grid(-column=>1,-row=>1);
$mw->Optionmenu(-options =>[qw\_  CU\],-textvariable=>\$tech_type,-width=>5)->grid(-column=>2,-row=>1);
$mw->Label(-text=>"$layer_number L",-width=>5)->grid(-column=>5,-row=>1);

$mw->Label(-text=>'='x70,)->grid(-column=>0, -row=>6,-columnspan=>6,);

my @layer_line=@{$layer_class{line}};
foreach  (0..$#layer_line) {   my $add=8;
	$mw->Label(-text=>$layer_line[$_],-width=>10,-relief=>'sunken')->grid(-column=>0, -row=>$_+$add);
	$mw->Button(-textvariable=>\$polarity[$_],-width=>10,-command=>[\&chang_polarity,$_],-relief=>'groove')->grid(-column=>1, -row=>$_+$add);
	$mw->Button(-textvariable=>\$mirror[$_],-width=>10,-command=>[\&chang_mirror,$_],-relief=>'groove')->grid(-column=>2, -row=>$_+$add);
	$mw->Entry(-textvariable=>\$x_scale[$_],-width=>10,)->grid(-column=>3, -row=>$_+$add);
	$mw->Entry(-textvariable=>\$y_scale[$_],-width=>10,)->grid(-column=>4, -row=>$_+$add);
}
$mw->Button(-text=>decode('utf8','刷新'),-width=>10,-command=>\&brush)->grid(-column=>0, -row=>50);
$mw->Button(-text=>decode('utf8','缺省'),-width=>10,-command=>\&default)->grid(-column=>1, -row=>50);
$mw->Button(-text=>decode('utf8','Apply'),-width=>10,-command=>\&apply)->grid(-column=>5, -row=>50);

$mw->Label(-textvariable=>\$tk_info,-width=>70,-relief=>'groo')->grid(-column=>0, -row=>51,-columnspan=>6);
$mw->ProgressBar(-borderwidth=>1, -colors=>[0,'#009900'], -length=>420,-variable=>\$schedule )->grid(-column=>0,-row=>52,-columnspan=>8); #

default();
MainLoop;
###______________________________________________sub
sub chang_mirror   {my $id=shift;  $mirror[$id] eq 'M' ? ( $mirror[$id]='--' ) : ( $mirror[$id]='M' );       }
sub chang_polarity {my $id=shift;  $polarity[$id] eq '+' ? ( $polarity[$id]='--' ) : ( $polarity[$id]='+' ); }
sub brush { 
	map {$_='+'}   @polarity;   
	map {$_='--'}  @mirror;  
	map {$_=undef} @x_scale;
	map {$_=undef} @y_scale;
}
sub default {
	foreach  (0..$#layer_line) {
		my $id =$_;
		foreach  (0..$#gROWrow) {
			if ($gROWname[$_] eq $layer_line[$id]) {
				if	($gROWfoil_side[$_] eq 'top') { $mirror[$id] = '--';  } else { $mirror[$id] = 'M'; }
				if ($gROWside[$_] eq 'inner') { $polarity[$id] = '--';  } else { $polarity[$id] = '+'; }
				last;
			}
		}
	}
	return;
}

sub _schedule{
	$schedule=shift;
	$mw->update();
}

sub apply {
	$f->COM('disp_off');
	##check entry
	require "$p_path/panel.pl";
	require "$p_path/info.pl";
	require "$p_path/add_sypad.pl";
	require "$p_path/add_inner_book.pl";
	require "$p_path/add_line_frame.pl"; 
	require "$p_path/add_film_fn.pl"; 
	require "$p_path/add_target_drill.pl"; 
	require "$p_path/add_target_rivet.pl"; 
	require "$p_path/add_target_tool.pl";
	require "$p_path/add_confine_line.pl";
	require "$p_path/add_butfly_pad.pl";
	require "$p_path/add_min_line.pl";
	require "$p_path/add_silk_ref.pl";
	require "$p_path/add_scale_test.pl";
	require "$p_path/add_slice.pl";
	require "$p_path/add_black_film_solder.pl";
	require "$p_path/add_lyaer_warp.pl";
	require "$p_path/fill_copper.pl";
	require "$p_path/add_drill_fn.pl";
	require "$p_path/add_end_drill.pl";
	##require "report_result.pl";
    $f->COM('disp_on');
	_schedule(100);  
	sleep 1;
exit;
}
1;



=head
	require "$son_path/panel.pl"; 
	require "$son_path/info.pl";
	#require "$son_path/grid.pl"; 
       require "$son_path/add_sypad.pl";
	require "$son_path/add_inner_book.pl";
	require "$son_path/add_scale_test.pl";
	require "$son_path/add_router_frame.pl";
	require "$son_path/add_film_fn.pl";
	require "$son_path/add_drill_fn.pl";
	require "$son_path/add_target_drill.pl";
	require "$son_path/add_target_rivet.pl";
	require "$son_path/add_target_tool.pl";
	require "$son_path/add_confine_line.pl";
	require "$son_path/add_butfly_pad.pl";
	require "$son_path/add_min_line.pl";
	require "$son_path/add_silk_ref.pl";
	require "$son_path/fill_copper_inner.pl";
	require "$son_path/report_result.pl";
	require "$son_path/add_drill_fn.pl";

$mw->Optionmenu(-options =>\@layer_drl,-textvariable=>\$layer_out,-width=>6)->grid(-column=>++$column,-row=>$row);

#foreach  (0..$#layer) {
#	$mw->Label(-text=>$layer[$_],-width=>10)->grid(-column=>$column, -row=>$_);
#	$mw->Button(-text=>'',-width=>10)->grid(-column=>$column+1, -row=>$_);
#}



=head
my @layer=qw\gtl l2 l3 l4 l5 l6 gbl gts gbs\;
foreach  (qw\layer +- mirror x_scale y_scale\) {
	$mw->Label(-text=>$_,-width=>10,-relief=>'sunken')->grid(-column=>$column++, -row=>0);
	foreach  (0..$#layer) {
		$mw->Label(-text=>$layer[$_],-width=>10)->grid(-column=>$column, -row=>$_);
    	$mw->Button(-text=>'',-width=>10)->grid(-column=>$column+1, -row=>$_);
	}
}

###______
my ($row,$column)=(0,0);
our ($son_path,$mw,)=("D:/xxx/camp/pnl",);
our ($user,$px,$py,$layer_number,$dirction,$coupon,$coupon_width,
    $surface,$slice,$scale_x,$scale_y,$text_report,)=('QAE',12,9);
our($gSR_LIMITSxmin,$gSR_LIMITSxmax,$gSR_LIMITSymin,$gSR_LIMITSymax);
our (%grid,@sypad,@butfly,@min_line,@silk_ref,);
our (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,%layer_class,);
####____________________________________________________________

$layer_number=layer_count($JOB);
###_________________________________
$mw=MainWindow->new;
$mw->title("Better and better");
$mw->Label(-text=>"USER",)->grid(-column=>$column++, -row=>$row);
$mw->Entry(-textvariable=>\$user, -width=>8)->grid(-column=>$column++, -row=>$row);
$mw->Label(-text=>"layer",)->grid(-column=>$column++, -row=>$row);
$mw->Label(-textvariable=>\$layer_number,-width=>8, -relief=>'sunken')->grid(-column=>$column++, -row=>$row++);
$mw->Label(-text=>"PX:INCH",)->grid(-column=>0, -row=>$row);
$mw->Entry(-textvariable=>\$px, -width=>8)->grid(-column=>1, -row=>$row);
$mw->Label(-text=>"PY:INCH",)->grid(-column=>2, -row=>$row);
$mw->Entry(-textvariable=>\$py, -width=>8)->grid(-column=>3, -row=>$row++);
##$mw->Label(-text=>"unit::INCH",)->grid(-column=>4, -row=>$row++);

$mw->Label(-text=>"DIRECTION",)->grid(-column=>0, -row=>$row);
$mw->Optionmenu(-options =>  [qw/ANY Horizontal Vertical/],-textvariable=>\$dirction,-width=>6)->grid(-column=>1, -row=>$row);
$mw->Label(-text=>"COUPON",)->grid(-column=>2, -row=>$row);
$mw->Optionmenu(-options =>  [qw/NO X Y/],-textvariable=>\$coupon,-width=>6)->grid(-column=>3, -row=>$row);
$mw->Entry(-textvariable=>\$coupon_width, -width=>8)->grid(-column=>4, -row=>$row++);

$mw->Label(-text=>"SurfaceTechnic",)->grid(-column=>0, -row=>$row);
$mw->Optionmenu(-options =>  [qw/HASL  IM_AU OTHER/],-textvariable=>\$surface,-width=>6)->grid(-column=>1, -row=>$row);
$mw->Label(-text=>"SLICE",)->grid(-column=>2,-row=>$row);
$mw->Optionmenu(-options =>  [qw(0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8)],-textvariable=>\$slice,-width=>6)->grid(-column=>3, -row=>$row++);
#$mw->Label(-text=>"Xscale %%",)->grid(-column=>0, -row=>4);
#$mw->Entry(-textvariable=>\$scale_x, -width=>8)->grid(-column=>1, -row=>4);
#$mw->Label(-text=>"Yscale %%",)->grid(-column=>2, -row=>4);
#$mw->Entry(-textvariable=>\$scale_y, -width=>8)->grid(-column=>3, -row=>4);
$mw->Button(-text=>"DO",-command=>\&main,-width=>50)->grid(-column=>0, -row=>$row,-columnspan=>5);
##$text_report=$mw->Text(-width=>44,-height=>15)->grid(-column=>0, -row=>6,-columnspan=>$row);
#$text_report->insert('end', "~~~~~~~~~~~~~~~~~~~~~");

MainLoop;


