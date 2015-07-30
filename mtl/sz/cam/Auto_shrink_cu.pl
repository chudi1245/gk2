#!/usr/bin/perl
#**************************************************************
# 程序名称：自动削铜
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-16
#**************************************************************
use strict;
use warnings;
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
#****************************
kysy();

unit_set('inch');
my $value=4;

my $mw = MainWindow->new;
$mw->geometry("+400+250");
my $state='disable';
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);


$mw->title("自动缩铜");
$mw->Label(-text=>"减少值:",-font =>[-size => 12],-width=>10)             ->grid(-column=>0,-row=>0);

$mw->Entry(-textvariable=>\$value,-state =>$state,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>0)->focus;

$mw->Button(-text=>'确定',-command=>\&shrink_cu,-font =>[-size => 14],-width=>10)->grid(-column=>2,-row=>0,-sticky=>"ew",);

$mw->Button(-text=>'修改',-command=>\&inputstat,-font =>[-size => 14],-width=>10)->grid(-column=>3,-row=>0,-sticky=>"ew",);

MainLoop;


sub inputstat{
if ($state eq 'disable') {$state='normal';}
$mw->Entry(-textvariable=>\$value,-state =>$state,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>0)->focus;
}

sub shrink_cu{
    my @line;
	my $info_ref=info('matrix',"$JOB/matrix",'row');
	my (@gROWrow,@gROWlayer_type,@gROWname,@gROWcontext,@line,);

	@gROWrow       =@{$info_ref->{gROWrow}};
	@gROWcontext   =@{$info_ref->{gROWcontext}};
	@gROWlayer_type=@{$info_ref->{gROWlayer_type}};
	@gROWname      =@{$info_ref->{gROWname}};
foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'signal' 
	or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
	push @line,$gROWname[$_];
		} 
	}
	affected_layer('yes', 'single', @line );
	filter({feat_types =>';surface'});
	$f->COM("filter_reset,filter_name=popup");	
	if (get_select_count()) {
	$f->COM("sel_resize,size=-$value,corner_ctl=no");
	}  		
    clear();
exit;
}

#******___________end



=h

our (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,@gROWfoil_side,);
###全局（层数1 2 3 4 5 6一直到后面 ，每一层的板属性，(top inner bootom none)层属性，
###线路阻焊字符属性(silk_screen soldermask signal)，gROWname代表每一层的层名：gROWtype代表layer,empty是否为空。 线路层的top,bootom属性（只与线路层相关）。）


my $info_ref=info('matrix',"$JOB/matrix",'row');
our (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,@gROWfoil_side,);
@gROWrow       =@{$info_ref->{gROWrow}};
@gROWcontext   =@{$info_ref->{gROWcontext}};
@gROWside      =@{$info_ref->{gROWside}};
@gROWlayer_type=@{$info_ref->{gROWlayer_type}};
@gROWname      =@{$info_ref->{gROWname}};
@gROWtype      =@{$info_ref->{gROWtype}};
@gROWfoil_side =@{$info_ref->{gROWfoil_side}};



foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board'){
		push @{$layer_class{board}},$gROWname[$_];
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
			$layer_number++;
			push @{$layer_class{line}},$gROWname[$_];
		    if ($gROWside[$_] eq 'inner'){
			    push @{$layer_class{inner}},$gROWname[$_];
		    }else{
				push @{$layer_class{outer}},$gROWname[$_];
			}
		}elsif ($gROWlayer_type[$_] eq 'solder_mask'){
			push @{$layer_class{solder_mask}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'drill'){
			push @{$layer_class{drill}},$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'silk_screen'){
			push @{$layer_class{silk_screen}},$gROWname[$_];
		}
	}
}





$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=surface\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=surface");
$f->COM("filter_set,filter_name=popup,update_popup=no,polarity=positive");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no,intersect_area=no,lines_only=no,
        ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");

$f->COM("sel_resize,size=-4,corner_ctl=no");
