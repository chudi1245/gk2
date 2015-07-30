#!/usr/bin/perl
#**************************************************************
# 程序名称：自动转铜皮
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-16
#************************************************************** 
use strict;
use warnings;
use Genesis;
use FBI;
use Encode ;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
#################################
kysy();

unit_set('inch');

$f->COM("affected_filter,filter=(type=signal|power_ground&context=board)");

$f->COM("drawn_to_surface,type=mixed,therm_analyze=no,accuracy=0.25,prevent_complication=yes,clean_hole_size=0,clean_hole_mode=x_and_y");


$f->COM ('affected_layer',mode=>'all',affected=>'no');

=head

unit_set('inch');


my $info_ref=info('matrix',"$JOB/matrix",'row');
my (@gROWrow,@gROWlayer_type,@gROWname,@gROWcontext,@line,);

@gROWrow       =@{$info_ref->{gROWrow}};
@gROWcontext   =@{$info_ref->{gROWcontext}};
@gROWlayer_type=@{$info_ref->{gROWlayer_type}};
@gROWname      =@{$info_ref->{gROWname}};

foreach  (0..$#gROWrow) {
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'signal' 
	or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
	
	clear($gROWname[$_]);

	
	$f->COM("sel_drawn,type=mixed,therm_analyze=no");
	
	if (get_select_count()) {
	
	$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,clean_hole_mode=x_and_y");
	}  		
} 

}

clear();


COM affected_filter,filter=(type=signal|power_ground&context=board)

COM drawn_to_surface,type=mixed,therm_analyze=no,accuracy=0.25,prevent_complication=yes,clean_hole_size=0,clean_hole_mode=x_and_y

