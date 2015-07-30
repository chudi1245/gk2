#!/usr/bin/perl 
##    mzb 2013.6.30
use strict;
use warnings;
##use lib "D:/all/camp/panel/panel";
use Win32;
use Genesis;
use FBI;
use Encode ;
our $host = shift; 
our $f = new Genesis($host); 
our $JOB = $ENV{JOB}; 
our $STEP = $ENV{STEP};

###_________________________________________
my ($mw,$row,$column,$tk_info,$schedule)=(undef,0,0,'MTL');
###局部变量（主窗口，行，列，窗口信息，时间计划表？？？？）
our $use = 'mtl';
###全局变量 用户。

our ($px,$py,$dx,$dy,$cyx,$cyy,$drl_Version,$margin_top,$margin_bot,$margin_rig,$margin_lef)=qw( 12 16 2 2 12 16 );
###全局（拼板长，拼板高，间距X，间距Y,客户代号，上边边缘，下边边缘，右边边缘，左边边缘）

our $margin={top=>5,bot=>5,lef=>5,rig=>5,};
###全局（上，下，左，右都设为5）

our (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,@gROWfoil_side,);
###全局（层数1 2 3 4 5 6一直到后面 ，每一层的板属性，(top inner bootom none)层属性，
###线路阻焊字符属性(silk_screen soldermask signal)，gROWname代表每一层的层名：gROWtype代表layer,empty是否为空。 线路层的top,bootom属性（只与线路层相关）。）
our ($Prof_xmin,$Prof_ymin,$Prof_xmax,$Prof_ymax,);
our (%grid,$SR_xmin,$SR_ymin,$SR_xmax,$SR_ymax,$cy_area);
###全局（网格，X最小，Y最小，X最大，Y最大，CY区域） %grid 把有效尺寸分成13等份，

our (%layer_class,$layer_number);
###全局（层列表，板层数）

our ($face_type,$tech_type,$orientation,$g_board,$vcut,);
###全局（表面处理类型，技术工艺类型，拼板方向, 光板）

our (@polarity,@mirror,@x_scale,@y_scale);
###全局（正负性，镜向，X缩放系数，Y缩放系数）

our (@sypad,@jiaopad,@butfly,@min_line,@silk_ref,%frame);
###全局（丝印定位PAD，蝴蝶PAD，最小线宽标识，打印字符对位点，框标识）

our ($ope_lefx,$ope_lefy,$ope_botx,$ope_boty,$ope_rigx,$ope_rigy,$ope_topx,$ope_topy);

our ($base_step);
###全局（基本STEP，PCB,PCS）

our (@end_drill);

*I_M=\25.397; our $I_M;   ###MM转英制。
unit_set('inch');         ###将单位设为英制。

###运行 "info_pre.pl"程序。此程序定义上面这些变量的具体值
require "info_pre.pl"; 

### 每层都加一个同心圆。
my $outd = $layer_number * 18;  
my $innd = ($layer_number-1)*18 + 4;
our $same_heart= "donut_r"."$outd"."x"."$innd";

$mw=MainWindow->new;  
$mw->geometry("+200+100");  
my $title = decode('utf8',"The best automation pnl");
$mw->title("$title");

##窗口第1行显示内容
$mw->Label('-text'=>decode('utf8','X拼版'),-font => [-size => 14],-width=>10,)->grid(-column=>0, -row=>0);
$mw->Entry('-textvariable'=>\$px,-font => [-size => 14],-width=>10,)->grid(-column=>1, -row=>0);
$mw->Label('-text'=>decode('utf8','Y拼版'),-font => [-size => 14],-width=>10,)->grid(-column=>2, -row=>0);
$mw->Entry('-textvariable'=>\$py,-font => [-size => 14],-width=>10,)->grid(-column=>3, -row=>0);

##窗口第2行显示内容
$mw->Label('-text'=>decode('utf8','X锣边'),-font => [-size => 14],-width=>10,)->grid(-column=>0, -row=>1);
$mw->Entry('-textvariable'=>\$cyx,         -font => [-size => 14],-width=>10,)->grid(-column=>1, -row=>1);
$mw->Label('-text'=>decode('utf8','Y锣边'),-font => [-size => 14],-width=>10,)->grid(-column=>2, -row=>1);
$mw->Entry('-textvariable'=>\$cyy,         -font => [-size => 14],-width=>10,)->grid(-column=>3, -row=>1);
$mw->Label('-text'=>decode('utf8','用户'), -font => [-size => 14],-width=>10,)->grid(-column=>4, -row=>1);
$mw->Entry('-textvariable'=>\$use,         -font => [-size => 14],-width=>8, )->grid(-column=>5, -row=>1);

##窗口第3行显示内容
$mw->Label(-text=>'='x70,-font => [-size => 14],)->grid(-column=>0, -columnspan=>8,-row=>2,);    ####输出70个‘ =’

##窗口第4行显示内容

$mw->Label('-text'=>decode('utf8','版本'), -font => [-size => 14],-width=>10,)->grid(-column=>4, -row=>5);
$mw->Entry('-textvariable'=>\$drl_Version, -font => [-size => 14],-width=>8, )->grid(-column=>5, -row=>5);

$mw->Label('-text'=>decode('utf8','X间距'),-font => [-size => 14],-width=>10,)->grid(-column=>0, -row=>3);
$mw->Entry('-textvariable'=>\$dx,		   -font => [-size => 14],-width=>10,)->grid(-column=>1, -row=>3);
$mw->Label('-text'=>decode('utf8','Y间距'),-font => [-size => 14],-width=>10,)->grid(-column=>2, -row=>3);
$mw->Entry('-textvariable'=>\$dy,		   -font => [-size => 14],-width=>10,)->grid(-column=>3, -row=>3);

##窗口第5行显示内容

$mw->Label('-text'=>decode('utf8','顶边距'),-font => [-size => 14],-width=>10,)->grid(-column=>0, -row=>4);
$mw->Entry('-textvariable'=>\$margin->{top},-font => [-size => 14],-width=>10,)->grid(-column=>1, -row=>4);
$mw->Label('-text'=>decode('utf8','底边距'),-font => [-size => 14],-width=>10,)->grid(-column=>2, -row=>4);
$mw->Entry('-textvariable'=>\$margin->{bot},-font => [-size => 14],-width=>10,)->grid(-column=>3, -row=>4);

##窗口第6行显示内容
$mw->Label('-text'=>decode('utf8','左边距'),-font => [-size => 14],-width=>10,)->grid(-column=>0, -row=>5);
$mw->Entry('-textvariable'=>\$margin->{lef},-font => [-size => 14],-width=>10,)->grid(-column=>1, -row=>5);
$mw->Label('-text'=>decode('utf8','右边距'),-font => [-size => 14],-width=>10,)->grid(-column=>2, -row=>5);
$mw->Entry('-textvariable'=>\$margin->{rig},-font => [-size => 14],-width=>10,)->grid(-column=>3, -row=>5);

##窗口第7行显示内容
$mw->Optionmenu(-options =>[qw\any horizontal vertical\],		-font => [-size => 14],-textvariable=>\$orientation,-width=>5)	->grid(-column=>0,-row=>6); ###拼板方向，任意，水平，垂直
$mw->Optionmenu(-options =>[qw\hasl nled iau iag osp iti pau\],	-font => [-size => 14],-textvariable=>\$face_type,-width=>5,)	->grid(-column=>1,-row=>6); ###沉金，喷锡，防氧化处理
$mw->Optionmenu(-options =>[qw\no  Thick_Cu\],					-font => [-size => 14],-textvariable=>\$tech_type,-width=>5)	->grid(-column=>2,-row=>6); ###工艺类型(_, 厚铜板。)
$mw->Optionmenu(-options =>[qw\no  Bare\],						-font => [-size => 14],-textvariable=>\$g_board,-width=>5)		->grid(-column=>3,-row=>6); ###多层板，是否有光板
$mw->Optionmenu(-options =>[qw\no Horiz Vert Both\],			-font => [-size => 14],-textvariable=>\$vcut,-width=>5)			->grid(-column=>4,-row=>6);
$mw->Label(-text=>"$layer_number L",							-font => [-size => 14],-width=>5)								->grid(-column=>5,-row=>6); ### 显示，板的层数

##窗口第8行显示内容
$mw->Label(-text=>'='x70,-font => [-size => 14],)->grid(-column=>0, -columnspan=>6,-row=>7,);   ###  显示  70个等号

my @layer_line=@{$layer_class{'line'}};
###  线路层。（包括外层，内层。）
foreach  (0..$#layer_line) {   my $add=8;
	$mw->Label(-text=>$layer_line[$_],-font => [-size => 12],-width=>10,-relief=>'sunken')->grid(-column=>0, -row=>$_+$add);
	###层名，
	$mw->Button(-textvariable=>\$polarity[$_],-font => [-size => 12],-width=>10,-command=>[\&chang_polarity,$_],-relief=>'groove')->grid(-column=>1, -row=>$_+$add);
	###正负，
	$mw->Button(-textvariable=>\$mirror[$_],-font => [-size => 12],-width=>10,-command=>[\&chang_mirror,$_],-relief=>'groove')->grid(-column=>2, -row=>$_+$add);
    ###镜像，
	if ($layer_number > 2) {
		$x_scale[1]=0;
		$y_scale[1]=0;
	}
	foreach  (0..$#layer_line) {
		$mw->Entry(-textvariable=>\$x_scale[$_],-font => [-size => 12],-width=>10,)->grid(-column=>3, -row=>$_+$add);
		###，输X缩放系数。
		$mw->Entry(-textvariable=>\$y_scale[$_],-font => [-size => 12],-width=>10,)->grid(-column=>4, -row=>$_+$add);
	    ###，输Y缩放系数。
	} 
}	
$mw->Button(-text=>decode('utf8','缩放相同'),-font => [-size => 12],-width=>10,-command=>\&same_scale)->grid(-column=>5, -row=>9);
        ###缩放相同
$mw->Button(-text=>decode('utf8','刷新'),-font => [-size => 12],-width=>10,-command=>\&brush)->grid(-column=>0, -row=>50);
        ###刷新
$mw->Button(-text=>decode('utf8','缺省'),-font => [-size => 12],-width=>10,-command=>\&default)->grid(-column=>1, -row=>50);
        ###缺省
##$mw->Button(-text=>decode('utf8','全设置'),-width=>10,-command=>\&brush)->grid(-column=>3, -row=>50);
##$mw->Button(-text=>decode('utf8','全设置'),-width=>10,-command=>\&default)->grid(-column=>4, -row=>50);
$mw->Button(-text=>decode('utf8','Apply'),-font => [-size => 12],-width=>10,-command=>\&apply)->grid(-column=>5, -row=>51);
$mw->Label(-textvariable=>\$tk_info,-font => [-size => 12],-width=>70,-relief=>'groo')->grid(-column=>0, -row=>52,-columnspan=>6);
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
###函数，使数组的值统一
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
######默认值，T就不镜像，B就镜像。内层出负片，其它出正片。
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

###############使缩放系数相同。

sub apply {
	##if (not $Customer_code ){ return;}  ###检查如果没有输入客户代码，就返回。
	##check entry
	#p__("panel is not exist");
	require "add_drill_point.pl"; 
	
	my $state=require "panel.pl";
	$f->COM('disp_off');
	##if ($state > 500) {  
	##	$tk_info=$state; 
	##	$mw->update();
	##	return 0; 
	##};
	require "info.pl";                 ###有效边四个值，xy最小，xy最大:丝印定位点座标。

    require "add_cyrout.pl";           ###加CY线； 2014-5-25 changed by Mobin
	require "add_sypad.pl";            ###加丝印定位PAD；
	require "add_inner_book.pl";       ###加ｂｏｏｋ对位点；add_parallel_exposure.pl
	require "add_parallel_exposure.pl";###加平行曝光机图形：  
   #require "add_line_frame.pl";       ###加内层5MM框线； 2014-5-25 取消加内存5MM 框线.
	
	

##	require "add_second_sypad.pl";     ###加第二套丝印定位PAD；
	require "add_film_fn.pl";          ###加FN标识；
    require "add_ad_10.pl";   
	require "add_target_drill.pl";     ###加靶孔；
	require "add_jiao_drill.pl";       ###加2.9mm板角孔,加在固定流胶点上 2014-5-28 add by Mobin 

##	require "add_target_rivet.pl";     ###加铆钉孔；
	require "add_auto_punching.pl";    ###加自动冲孔机图形；

##	require "add_target_tool.pl";      ###加工具孔；
    require "add_SameHeart_circles.pl";###加同心圆；
	require "add_layer_number.pl";     ###加层数字；
	require "add_vut_toolhole.pl";     ###加vut定位孔；

##	require "add_butfly_pad.pl";       ###加蝴蝶对位图形
	require "add_min_line.pl";         ###加最小线宽图形，蚀刻用

##	require "add_silk_ref.pl";         ###加打印字符 对位图形
	require "add_scale_test.pl";       ###加测整英寸图形；即背板标记
	require "add_slice.pl";            ###加切片孔图形
##	require "add_lyaer_warp.pl";       ###多层板，层偏检测孔，钻孔，线路，阻焊	
	require "add_end_silk_drill.pl";   ###加尾孔
	require "add_drill_fn.pl";         ###加钻孔档案号；

    require "add_surface_silk.pl";     ###加表面处理中文字

    require "add_confine_line.pl";     ###加边界线；有效边往外1MM	 add_layer_corfine.pl	

	require "fill_copper.pl";          ###板边铺铜

	#require "add_layer_corfine.pl";    ###加边界线；有效边往外1MM 改为加角线。2014-05-25更改。 2014-6-10 先铺铜,再加板边框.2014-08-16修改.
	
    
    require "add_inner_jiaxian.pl";    ###加内层角线；
	require "add_line_bigframe.pl";    ###大边框尺寸： 21.9 x 25.9 inch  2013.6.30更改

 

#   require "add_black_film_solder.pl";###加黑片对位图形，阻焊字符，2013/6/29  去掉黑片对位孔。
	

if ( exists_layer('drlp') eq 'yes' ) {
	clear('drl');
	sel_copy_other('drlp','no','4');
	sel_copy_other('drlp','yes',0);
	clear();	
}
#############________________________________________________________给FN和 AD1234 加阻流条。
####my @inner = my @outer=@{$layer_class{'inner'}};
my @inner =  @{$layer_class{'inner'}};
if ( $layer_number > 2 )  {

affected_layer('yes','single',  @inner);
my ($adnx,$adny)=($SR_xmax + 0.15,    $grid{y}[11] + 0.74,);
my ($fnax,$fnay)=($grid{x}[5] + 0.88, $SR_ymin - 0.14);
    add_pad($adnx,$adny,  'rect2000x40', 'no', 90,  'yes');
	add_pad($fnax,$fnay,  'rect2200x40', 'no', 0,   'yes');
}

#############________________________________________________________给OPE加阻流条。	
if ( $layer_number > 4 or ( $layer_number == 4 and $inner[0] =~ m/l2b/i ) ){
	
	affected_layer('yes','single',  @inner);
	add_pad($ope_lefx -0.2 , $ope_lefy,  'oval39.37x1600', 'no', 0,  'yes');
	add_pad($ope_botx, $ope_boty -0.2,   'oval39.37x1600', 'no', 90, 'yes');
	add_pad($ope_rigx + 0.2, $ope_rigy,  'oval39.37x1600', 'no', 0,  'yes');
	add_pad($ope_topx, $ope_topy + 0.2,  'oval39.37x1600', 'no', 90, 'yes');
}

#############________________________________________________________*************
my @line=@{$layer_class{'line'}};
affected_layer('yes', 'single', @line );


filter( {feat_types=>'pad', 
	     polarity=>'positive', 
	     include_syms=>"r126\;r118.11\;r187.05\;$same_heart\;r200.75\;r52\;zflc\;rect343x145xr82.5"} 
      );

##p__("PAUSE ,please check ! $same_heart");

if (get_select_count()) {
	$f->COM("sel_delete");
}

clear();
  
   $f->COM('disp_on');
p__('The pnl is ok!');
	_schedule(100);  	

exit;

}
1;


=h
##2014-05-25修改。
my %title=(
   use              =>['Label',   0,  0,  '-text',          '用户',       ],
   use_entry        =>['Entry',   1,  0,  '-textvariable',  \$use,       ],
   px               =>['Label',   2,  0,  '-text',          'X拼版尺寸',  ],
   px_entry         =>['Entry',   3,  0,  '-textvariable',  \$px,        ],
   py               =>['Label',   4,  0,  '-text',          'Y拼版尺寸',  ],
   py_entry         =>['Entry',   5,  0,  '-textvariable',  \$py,        ],

#  code             =>['Label',   4,  2,  '-text',          '客户代号',  ],
#  code_entry       =>['Entry',   5,  2,  '-textvariable',  \$Customer_code,],
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
	   my ($wid_type, $text_type)=($title{$_}[0], $title{$_}[3]);  ###窗口类型，文字类型，（标签/实体，）
	
if (not ref $title{$_}[4])  { $title{$_}[4]=decode('utf8',$title{$_}[4]); }  ###如果不是 英文字符，就进行转码。
$mw->$wid_type($text_type=>$title{$_}[4],-width=>10,-font => [-size => 10],)->grid(-column=>$title{$_}[1], -row=>$title{$_}[2]);
 };

=cut

