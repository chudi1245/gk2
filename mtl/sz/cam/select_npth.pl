#!/usr/bin/perl
#**************************************************************
# �������ƣ�ѡ��npth��
# ����汾��v1.0
# ����������: 
# ������Ա��Ī־��
# ����ʱ�䣺2012-3-30
#**************************************************************
use FBI;
use Genesis;
$f = new Genesis;

kysy();

##clear('drl');
$f->COM("filter_reset,filter_name=popup");
$f->COM("sel_clear_feat");

$f->COM("filter_set,filter_name=popup,update_popup=yes,feat_types=pad;line");
$f->COM("filter_atr_set,filter_name=popup,condition=yes,attribute=.drill,option=non_plated");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no, intersect_area=no,lines_only=no,
        ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("disp_on");
$f->COM("origin_on");
$f->COM("filter_reset,filter_name=popup");


##if (get_select_count()) {
##	sel_move_other('22');
##}
##clear();
