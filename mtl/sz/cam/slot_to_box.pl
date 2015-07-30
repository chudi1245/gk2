#!/usr/bin/perl
#**************************************************************
# 程序名称：槽转成外形
# 程序版本：v1.0
# 程序功能描述: 
# 开发人员：莫志兵
# 创建时间：2012-3-30
#**************************************************************
use FBI;
use Genesis;
$f = new Genesis;

kysy();

if (  get_select_count()  ) {
    unit_set('inch');
	$f->COM("sel_contourize,clean_hole_mode=x_and_y,clean_hole_size=3,break_to_islands=yes,accuracy=0.25");
	filter({feat_types =>';surface'});
	$f->COM("filter_reset,filter_name=popup");	
	$f->COM("sel_surf2outline,width=10");

	}  


=h
$f->COM("disp_on");
$f->COM("origin_on");