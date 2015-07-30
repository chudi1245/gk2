#!/usr/bin/perl -w
use Genesis;
$f = new Genesis;

$f->COM("display_layer,name=drl,display=yes,number=1");

$f->COM("work_layer,name=drl");

$f->COM("chklist_single,action=valor_dfm_nfpr,show=yes");

$f->COM("chklist_cupd,chklist=valor_dfm_nfpr,nact=1,params=((pp_layer=drl)(pp_delete=Duplicate)(pp_work=Copper)(pp_drill=PTH\;NPTH\;Via\;PTH - Pressfit\;Via - Laser\;Via - Photo)(pp_non_drilled=Yes)(pp_in_selected=All)(pp_remove_mark=Remove)),mode=regular");

$f->COM("chklist_run,chklist=valor_dfm_nfpr,nact=1,area=profile");

$f->COM("chklist_close,chklist=valor_dfm_nfpr,mode=hide");

$f->COM("chklist_single,action=valor_analysis_drill,show=yes");

$f->COM("chklist_cupd,chklist=valor_analysis_drill,nact=1,params=((pp_drill_layer=.type=drill  & context=board)(pp_rout_distance=400)(pp_tests=Hole Size\;Hole Separation\;Missing Holes\;Extra Holes\;Power/Ground Shorts\;NPTH to Rout)(pp_extra_hole_type=Pth)(pp_use_compensated_rout=Skeleton)),mode=regular");

$f->COM("chklist_run,chklist=valor_analysis_drill,nact=1,area=profile");

$f->COM("chklist_res_show,chklist=valor_analysis_drill,nact=1,x=0,y=0,w=0,h=0");

$f->COM("chklist_close,chklist=valor_analysis_drill,mode=hide");












