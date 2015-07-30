#!/usr/bin/perl
use strict;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};

###____
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
unit_set('inch');
clear();
$f->COM ('chklist_single',action=>'valor_dfm_nfpr',show=>'yes');
$f->COM ('chklist_cupd',
    chklist=>'valor_dfm_nfpr',
    nact=>1,
    params=>'((pp_layer=.type=signal|mixed&context=board&pol=positive&side=inner)(pp_delete=Isolated)(pp_work=Copper)(pp_drill=PTH\;NPTH\;Via\;PTH - Pressfit\;Via - Laser\;Via - Photo)(pp_non_drilled=Yes)(pp_in_selected=All)(pp_remove_mark=Remove))',
    mode=>'regular');
$f->COM ('chklist_run',chklist=>'valor_dfm_nfpr',nact=>1,area=>'profile');
$f->COM ('chklist_close',chklist=>'valor_dfm_nfpr',mode=>'hide');




=head
COM chklist_single,action=valor_dfm_nfpr,show=yes
COM chklist_cupd,chklist=valor_dfm_nfpr,nact=1,params=((pp_layer=.type=signal|mixed&context=board&pol=positive&side=inner)(pp_delete=Isolated)(pp_work=Copper)(pp_drill=PTH\;NPTH\;Via\;PTH - Pressfit\;Via - Laser\;Via - Photo)(pp_non_drilled=Yes)(pp_in_selected=All)(pp_remove_mark=Remove)),mode=regular
COM chklist_run,chklist=valor_dfm_nfpr,nact=1,area=profile
COM chklist_close,chklist=valor_dfm_nfpr,mode=hide


