#!/usr/bin/perl
use strict;
use Tk;
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

$f->INFO(units=>'mm',entity_type => 'layer',entity_path => "$JOB/pcb/drl");

my @Drl = @{$f->{doinfo}{gTOOLdrill_size}};

@Drl = sort{$a<=>$b} @Drl;

my $minhole = $Drl[0]; ##求最小孔尺寸。


my $info_ref=info('matrix',"$JOB/matrix",'row');
my (@gROWrow,@gROWcontext,@gROWside,@gROWlayer_type,@gROWname,@gROWtype,@gROWfoil_side,);

my (@line,@outer,@inner,@solder_mask,@silk_screen,@drill);

@gROWrow       =@{$info_ref->{gROWrow}};
@gROWcontext   =@{$info_ref->{gROWcontext}};
@gROWside      =@{$info_ref->{gROWside}};
@gROWlayer_type=@{$info_ref->{gROWlayer_type}};
@gROWname      =@{$info_ref->{gROWname}};
@gROWtype      =@{$info_ref->{gROWtype}};
@gROWfoil_side =@{$info_ref->{gROWfoil_side}};

foreach  (0..$#gROWrow) {

	if ($gROWcontext[$_] eq 'board'){
		
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {		
			push @line,$gROWname[$_];

		    if ($gROWside[$_] eq 'inner'){
			    push @inner,$gROWname[$_];
		    }else{
				push @outer,$gROWname[$_];
			}
		}elsif ($gROWlayer_type[$_] eq 'solder_mask'){
			push @solder_mask,$gROWname[$_];

		}elsif ($gROWlayer_type[$_] eq 'silk_screen'){

			push @silk_screen,$gROWname[$_];
		}elsif ($gROWlayer_type[$_] eq 'drill'){

			push @drill,$gROWname[$_];
		}
	 }
}

unit_set('inch');
my $value=10;

my $mw = MainWindow->new;
$mw->geometry("+400+250");

my $state='disable';
my $size_type;

my $font=[-family => 'Courier',-size=>16,];
$mw->update;
Win32::API->new("user32","SetWindowPos",[qw(N N N N N N N)],'N')->Call(hex($mw->frame()),-1,0,0,0,0,3);


$mw->title("添加切片图形");

##$mw->Label(-text=>"线宽:",-font =>$font,-width=>10) ->grid(-column=>0,-row=>0);

##$mw->Entry(-textvariable=>\$value,-font =>$font, -width=>8)   ->grid(-column=>1,-row=>0)->focus;

##$mw->Label(-text=>"尺寸:",-font =>$font,-width=>10) ->grid(-column=>0,-row=>1);

##$mw->Optionmenu(-options =>[qw\16x8mm 22x16mm\],-textvariable=>\$size_type,-font =>$font,-width=>8,)->grid(-column=>1,-row=>1);

$mw->Label(-text=>'='x30,-font =>$font)->grid(-column=>0, -row=>2,-columnspan=>2,);

$mw->Button(-text=>'确定',-command=>\&shrink_cu,-font =>$font,-width=>10)->grid(-column=>1,-columnspan=>2,-row=>3,-sticky=>"ew",);

MainLoop;

#my @qian_zuo=(
#	{x=>3,   y=>4 },
#	{x=>8,   y=>4 },
#	{y=>13,  x=>4 },
#);
my ($x1,$y1,$x2,$y2,$x3,$y3)=(3,4,8,4,13,4);

sub shrink_cu{

   clear_creat_step('qie');	  #创建Step
   unit_set('mm');
##box层画一个16x8mm的框。
if ( exists_layer('box') eq 'yes' ){
	clear('box');
$f->COM("add_polyline_strt");
$f->COM("add_polyline_xy,x=0,y=0");
$f->COM("add_polyline_xy,x=16,y=0");
$f->COM("add_polyline_xy,x=16,y=8");
$f->COM("add_polyline_xy,x=0,y=8");
$f->COM("add_polyline_xy,x=0,y=0");
$f->COM("add_polyline_end,attributes=no,symbol=r254,polarity=positive");
##建好profile
$f->COM ('sel_reverse');
$f->COM ('sel_create_profile');
}

##线路层加1个自定义pad,加三个pad
if ($line[0]) {
	 my $pad=$minhole+400;
	 my $symbo="r"."$pad";

	 clear(); affected_layer('yes', 'single', @line, );

	 add_pad(8,4,'qpad'); $f->COM ('sel_break');
	 add_qianpian($symbo);  

}
#孔层加三个pad
if (exists_layer ('drl') eq 'yes') {
	 clear('drl');
	 my $symbo="r"."$minhole";
	 add_qianpian($symbo);   
}

#外层线路加三个pad
#if ($outer[0]) {
#	 my $pad=$minhole+400;
#	 my $symbo="r"."$pad";
#	 clear();
#	 affected_layer('yes', 'single', @outer, );
#	 add_qianpian($symbo);   
#}

#阻焊层加三个pad
if ($solder_mask[0]) {
	 my $pad=$minhole+600;
	 my $symbo="r"."$pad";

	 clear();
	 affected_layer('yes', 'single', @solder_mask, );
	 add_qianpian($symbo);   
}
##gtl层加档案号
if (exists_layer ('gtl') eq 'yes') {
	  clear('gtl');
      $f->COM("add_text,attributes=no,type=string,x=4.98585,y=0.300815,text=$JOB,x_size=1.016,y_size=1.016,w_factor=0.5,polarity=positive,angle=0,mirror=no,fontname=standard,ver=1");
}
##gbl层加字符‘切片’
if (exists_layer ('gbl') eq 'yes') {
	  clear('gbl');
      add_pad(8.1,6.6,'qstr');
}
exit;
}


sub add_qianpian {
	 my $symbol=shift;
	 add_pad(3,4,$symbol);
	 add_pad(8,4,$symbol);
	 add_pad(13,4,$symbol);
}


=head
C:\Perl\site\bin;
C:\Perl\bin;%SystemRoot%;
%SystemRoot%\System32\Wbem;
C:\bin;C:\usr\local\bin;
%SystemRoot%\system32