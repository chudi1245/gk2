#!/usr/bin/perl
#**************************************************************
# 程序名称：选择最小线宽的箭头
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-30
#**************************************************************
use strict;
use warnings;
use Genesis;
use FBI;
##use Encode ;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

#$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=mark_line_width\;xkx\;xky");
#$f->COM("filter_area_strt");
#$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
#        area_type=none,inside_area=no,intersect_area=no,lines_only=no,
#        ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
#$f->COM("filter_reset,filter_name=popup");

 $f->COM ('get_work_layer');
 my $layer=$f->{COMANS};

if ($layer) {
	$f->COM("feat_hist_open,layer=$layer,type=sr");
}

exit;

=head
 $f->COM ('get_select_count');
             my $count=$f->{COMANS};

####include_syms=>'r126\;r52\;zflc\;rect343x145xr82.5'} );