#!/usr/bin/perl -w
use lib "C:/genesis/e92/all/perl";
use Genesis;
$f = new Genesis;

$f->COM("units,type=inch");
$f->COM("display_layer,name=drl,display=yes,number=1");
$f->COM("work_layer,name=drl");
$f->COM("chklist_single,action=valor_dfm_pad_snap,show=yes");
$f->COM("chklist_cupd,chklist=valor_dfm_pad_snap,nact=1,params=((pp_layer=drl)(pp_ref_layer=gtl)(pp_max_snapping=4)(pp_max_report=20)(pp_min_spacing=0.1)(pp_include_smds=Yes)),mode=regular");
$f->COM("chklist_run,chklist=valor_dfm_pad_snap,nact=1,area=profile");
$f->COM("chklist_close,chklist=valor_dfm_pad_snap,mode=hide");



