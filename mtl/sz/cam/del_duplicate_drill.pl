#!/usr/bin/perl
use strict;
use Genesis;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($ref,);
my (@gROWcontext,@gROWname,@gROWlayer_type,@drill_layer);
###_____________________________________________________________
kysy();

unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 open_step($STEP);
	 $f->COM ('close_form',job=>$JOB,form=>'eng');
	 unless ($STEP) {
		 p__('no step');
		 exit;
	 }
}

$ref=info("matrix","$JOB/matrix","row");
@gROWcontext   =@{$ref->{gROWcontext}};
@gROWlayer_type=@{$ref->{gROWlayer_type}};
@gROWname      =@{$ref->{gROWname}};
foreach  (0..$#gROWcontext) {
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'drill'){
		push @drill_layer,$gROWname[$_];
	}	
}

foreach  (@drill_layer) {
	clear($_);
	$f->COM ('chklist_single',action=>'valor_dfm_nfpr',show=>'yes');
	$f->COM ('chklist_cupd',
		chklist   =>'valor_dfm_nfpr',
		nact      =>1,
		params    =>"((pp_layer=$_)(pp_delete=Duplicate)(pp_work=Copper)(pp_drill=PTH\;NPTH\;Via\;PTH - Pressfit\;Via - Laser\;Via - Photo)(pp_non_drilled=Yes)(pp_in_selected=All)(pp_remove_mark=Remove))",
		mode      =>'regular');
	$f->COM ('chklist_run',
		chklist =>'valor_dfm_nfpr',
		nact    =>1,
		area    =>'profile');
	$->COM ('chklist_close',chklist=>'valor_dfm_nfpr',mode=>'hide');
}

my $result=$f->{COMANS};

##p__("$result ok");












##$f->COM ('chklist_res_show',chklist=>'valor_dfm_nfpr',nact=>1,x=>0,y=>0,w=>0,h=>0);





=head
是否需要报告去重孔的结果
COM chklist_cupd,chklist=valor_dfm_nfpr,nact=1,params=((pp_layer=drl)(pp_delete=Duplicate)(pp_work=Copper)(pp_drill=PTH\;NPTH\;Via\;PTH - Pressfit\;Via - Laser\;Via - Photo)(pp_non_drilled=Yes)(pp_in_selected=All)(pp_remove_mark=Remove)),mode=regular
COM chklist_run,chklist=valor_dfm_nfpr,nact=1,area=profile

