#!/usr/bin/perl 
##    zhouqing 
use strict;
use warnings;
##use lib "D:/all/camp/panel/panel";
use Tk;
use Genesis;
use FBI;
use Encode ;
our $host = shift; our $f = new Genesis($host); our $JOB = $ENV{JOB}; our $STEP = $ENV{STEP};

kysy();

###_________________________________________
my ($mw,$row,$column,$tk_info,$schedule)=(undef,0,0,'MTL');

our ($use,$vcut);
our ($px,$py,$dx,$dy,$Customer_code,$FN_Version,$margin_top,$margin_bot,$margin_rig,$margin_lef,$g_moudel,)=qw( 9 12 2 2);
our $margin={top=>5,bot=>5,lef=>5,rig=>5,};
our (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,@gROWfoil_side,);

our (%grid,$SR_xmin,$SR_ymin,$SR_xmax,$SR_ymax,$cy_area);
our (%layer_class,$layer_number);
our ($face_type,$tech_type,$orientation,$g_board);
our (@polarity,@mirror,@x_scale,@y_scale);
our $addFour = "no";

#将加工具孔的坐标定义为全局变量。
our ($target_tool,$start_point);

our (@sypad,@butfly,@min_line,@silk_ref,%frame);
our ($base_step);
*I_M=\25.397; our $I_M;

###_______________________
my $test_pcb=exists_entity('step',"$JOB/qie");
if ($test_pcb eq 'no') {
    p__("please create the  qie step after run panel !");
	exit;
}

my $test_pcbnet=exists_entity('step',"$JOB/pcb_net");
if ($test_pcbnet eq 'no') {
    p__("The  pcb_net step is not exist!");
	exit;
}
my $test_orignet=exists_entity('step',"$JOB/orig_net");
if ($test_orignet eq 'no') {
    p__("The  orig_net step is not exist!");
	exit;
}

=head
if ( exists_layer('gtl')  eq  'yes' ) {
	my $filepath = "c:/genesis/fw/jobs/$JOB/output/net.log";
	if (-e $filepath) {
		open (FILE,"$filepath");
		my $result = (<FILE>);
		close FILE;
		my @result=split ' ',$result;
		if ($result[0]!=0 || $result[1]!=0 ) {
			p__("please make sure that the net is no problem ");
			exit;
		}
	}else{
		p__("please operation network analysis before output data ");
		exit; 
	}
} 
=cut


###_________________________________________
#kysy();
unit_set('inch');
require "info_pre.pl"; 
###____________________________________________
$mw=MainWindow->new;  $mw->geometry("+200+100");  
$mw->title("Better and better QQ-214284213");
my %title=(
   use              =>['Label',   0,  0,  '-text',          '用户',       ],
   use_entry        =>['Entry',   1,  0,  '-textvariable',  \$use,       ],
   px               =>['Label',   2,  0,  '-text',          'X拼版尺寸',  ],
   px_entry         =>['Entry',   3,  0,  '-textvariable',  \$px,        ],
   py               =>['Label',   4,  0,  '-text',          'Y拼版尺寸',  ],
   py_entry         =>['Entry',   5,  0,  '-textvariable',  \$py,        ],
   code             =>['Label',   4,  2,  '-text',          '客户代号',  ],
   code_entry       =>['Entry',   5,  2,  '-textvariable',  \$Customer_code,],
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
$mw->Label(-text=>'='x70,)->grid(-column=>0, -row=>3,-columnspan=>8,);
##拼版方向
$mw->Optionmenu(-options =>[qw\any horizontal vertical\],-textvariable=>\$orientation,-width=>5)->grid(-column=>0,-row=>1);
##表面处理
$mw->Optionmenu(-options =>[qw\Im_AU Hasl OSP\],-textvariable=>\$face_type,-width=>5,)->grid(-column=>1,-row=>1);
##厚铜处理
$mw->Optionmenu(-options =>[qw\_  Thick_Cu\],-textvariable=>\$tech_type,-width=>5)->grid(-column=>2,-row=>1);
###多层板，是否有光板
$mw->Optionmenu(-options =>[qw\_  Bare\],-textvariable=>\$g_board,-width=>5)->grid(-column=>3,-row=>1);
###多层板，是否用钢板模具
$mw->Optionmenu(-options =>[qw\_ Steel\],-textvariable=>\$g_moudel, -width=>5)->grid(-column=>4,-row=>1);
###vut处理
$mw->Optionmenu(-options =>[qw\no Horiz Vert Both\],-textvariable=>\$vcut,-width=>5)->grid(-column=>5,-row=>1);

$mw->Label(-text=>"$layer_number Lay",-width=>5)->grid(-column=>5,-row=>5);

$mw->Label(-text=>'='x70,)->grid(-column=>0, -row=>6,-columnspan=>6,);

my @layer_line=@{$layer_class{'line'}};
foreach  (0..$#layer_line) {   my $add=8;
	$mw->Label(-text=>$layer_line[$_],-width=>10,-relief=>'sunken')->grid(-column=>0, -row=>$_+$add);
	$mw->Button(-textvariable=>\$polarity[$_],-width=>10,-command=>[\&chang_polarity,$_],-relief=>'groove')->grid(-column=>1, -row=>$_+$add);
	$mw->Button(-textvariable=>\$mirror[$_],-width=>10,-command=>[\&chang_mirror,$_],-relief=>'groove')->grid(-column=>2, -row=>$_+$add);
if ($layer_number > 2) {
	$x_scale[1]=0;
    $y_scale[1]=0;
}
	foreach  (0..$#layer_line) {
		$mw->Entry(-textvariable=>\$x_scale[$_],-width=>10,)->grid(-column=>3, -row=>$_+$add);
		$mw->Entry(-textvariable=>\$y_scale[$_],-width=>10,)->grid(-column=>4, -row=>$_+$add);
	} 
}	
$mw->Button(-text=>decode('utf8','same scale'),-width=>10,-command=>\&same_scale)->grid(-column=>5, -row=>9);

$mw->Button(-text=>decode('utf8','rush'),-width=>10,-command=>\&brush)->grid(-column=>0, -row=>50);
$mw->Button(-text=>decode('utf8','default'),-width=>10,-command=>\&default)->grid(-column=>1, -row=>50);

##$mw->Button(-text=>decode('utf8','全设置'),-width=>10,-command=>\&brush)->grid(-column=>3, -row=>50);
##$mw->Button(-text=>decode('utf8','全设置'),-width=>10,-command=>\&default)->grid(-column=>4, -row=>50);
$mw->Entry(-textvariable =>\$FN_Version,  -width=>10,)->grid(-column=>0, -row=>51);
$mw->Label(-text=>decode('utf8','version'),-width=>10,)->grid(-column=>1, -row=>51);

$mw->Button(-text=>decode('utf8','Apply'),-width=>10,-command=>\&apply)->grid(-column=>5, -row=>51);
$mw->Label(-textvariable=>\$tk_info,-width=>70,-relief=>'groo')->grid(-column=>0, -row=>52,-columnspan=>6);
$mw->ProgressBar(-borderwidth=>1, -colors=>[0,'#009900'], -length=>420,-variable=>\$schedule )->grid(-column=>0,-row=>53,-columnspan=>8); #

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

				if ($layer_line[$id] =~ m/\d[t]/i) {
					$mirror[$id] = '--'; 
				}elsif($layer_line[$id] =~ m/\d[b]/i){
					$mirror[$id] = 'M'; 
				}elsif	($gROWfoil_side[$_] eq 'top') { 
					$mirror[$id] = '--';  
				} else { 
					$mirror[$id] = 'M'; 
				}

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
sub same_scale  {
	foreach  (2..$#layer_line-1) {
$x_scale[$_]=$x_scale[1];
$y_scale[$_]=$y_scale[1];
}
}

sub apply {
	if (not ($Customer_code and $use) ){ return;}
	if ($g_moudel eq "Steel" ) {
		unless ( ($px==9 and $py==12) or ($px==10 and $py==12)  or ($px==12 and $py==16)  or ($px==12 and $py==18)  ){
		return;}
	}
    my $yesno_button = $mw->messageBox(-message =>decode('utf8',"外形大于30*30mm,板边一定记得倒角？是否继续?") ,
		-type => "yesno", -icon => "question");
    if ($yesno_button eq "No") {return};

	##check entry
	my $state=require "panel.pl";
	$f->COM('disp_off');
    ##if ($state > 500) {  $tk_info=$state; $mw->update();return 0; };                
	require "info.pl";    ## 定义丝印定位pad变量。
	require "add_sypad.pl";  ## 加丝印定位pad
	require "add_inner_book.pl";  ##加内层book对位图形
	require "add_line_frame.pl";  ##加内层大的大5MM 边框线。
	require "add_cy.pl";          ## 加CY图形。
	require "add_second_sypad.pl";  ##加第二套丝印定位pad
	require "add_film_fn.pl";       ##加菲林上面的FN标识。
	require "add_target_drill.pl";  ##加靶孔。
	require "add_target_rivet.pl";  ##加铆钉孔。
	require "add_target_tool.pl";   ##加工具孔。
	require "add_confine_line.pl";  ## 加边角线。

	require "add_layer_number.pl";     ###加层数字；

	require "add_vut_toolhole.pl";       ###加vut定位孔；

	##require "add_butfly_pad.pl";		 ##加蝴蝶对位图形。
	require "add_smrs_pad.pl";           ##加防爆对位pad 修改于2014-10-07日。

	require "add_min_line.pl";		 	 ##加最小线宽标识。
	require "add_silk_ref.pl";			 ##加打印字符对位图形。       
	require "add_scale_test.pl";         #加整英寸的背板标记

	##6.23修改。   2、原来板边的切片模块需要恢复，不能删
	require "add_slice.pl";              #加切片孔
	require "add_black_film_solder.pl";  #加黑片对位孔
	require "add_lyaer_warp.pl";         #加层对位图形。
	require "add_end_silk_drill.pl";     #加尾孔
	require "fill_copper.pl";			 #电镀边铺铜
	##MOdify mzb 2013.6.30 
	
	require "add_drill_fn.pl";			 #添加钻孔档案号
#############________________________________________________________删除一些避开的物体。	
$f->COM("affected_layer,name=gtl,mode=single,affected=yes");
$f->COM("affected_layer,name=gbl,mode=single,affected=yes");

$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=r126\;zflc");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no,intersect_area=no,lines_only=no,
        ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");

$f->COM("sel_delete");
$f->COM("affected_layer,name=gbl,mode=all,affected=no");
#############
	##require "report_result.pl";
    $f->COM('disp_on');

p__('The pnl is ok,Good luck to you!');
	
	_schedule(100);  
	#sleep 1;
exit;
}
1;


