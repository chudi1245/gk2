#!/usr/bin/perl
use strict;
use Genesis;
use Win32;
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###______________________________
kysy();
my (@layer_solder,@layer_out);
##info
my $ref=info('matrix',"$JOB/matrix",'ROW');
my @gROWname      =@{$ref->{gROWname}};
my @gROWlayer_type=@{$ref->{gROWlayer_type}};
my @gROWcontext   =@{$ref->{gROWcontext}};
my @gROWside      =@{$ref->{gROWside}};
my @gROWfoil_side =@{$ref->{gROWfoil_side}};

foreach my $i (0..$#gROWname) {
	if ($gROWcontext[$i] eq 'board') {
		if ($gROWlayer_type[$i] eq 'solder_mask') { push @layer_solder,$gROWname[$i]; };
		if ($gROWlayer_type[$i] =~ m{(signal)|(power_ground)|(mixed)}i  and  $gROWside[$i] =~ m{(top)|(bottom)}i ) { push @layer_out,$gROWname[$i]; };
	}
}
###_________________________
foreach  my $i (@layer_solder) {
	clear($i);
	creat_pad_auto();
	filter( {feat_types=>'line\;surface\;arc', polarity=>'positive',} );
	if ( get_select_count() ) { creat_pad_ref() };
} 
foreach my $i (@layer_out) { clear($i);  creat_pad_auto('Auto Ref.');  };

####___________________________________________--
sub creat_pad_auto {
	my $pp_auto_re=shift||undef;

	   ##'Auto Ref.'

$f->COM ('chklist_single',
         action=>'valor_cleanup_auto_subst',
		 show=>'yes');
$f->COM ('chklist_cupd',
         chklist=>'valor_cleanup_auto_subst',
		 nact=>1,
		 params=>"((pp_layer=.affected)(pp_in_selected=All)(pp_min_smd=6)(pp_max_smd=500)(pp_tol=0)(pp_ref_sm=)(pp_auto_ref=$pp_auto_re)(pp_sm_margin=0)(pp_drill_margin=0)(pp_work=Features)(pp_construct=Yes))",
		 mode=>'regular');
$f->COM ('chklist_run',
         chklist=>'valor_cleanup_auto_subst',
		 nact=>1,
		 area=>'profile');
$f->COM ('chklist_close',
	     chklist=>'valor_cleanup_auto_subst',
	     mode=>'hide');
}###

sub creat_pad_ref {
$f->COM ('chklist_single',
	     action=>'valor_cleanup_ref_subst',
	     show=>'yes');
$f->COM ('chklist_cupd',
	     chklist=>'valor_cleanup_ref_subst',
	     nact=>1,
	     params=>"((pp_layer=.affected)(pp_in_selected=All)(pp_tol=0)(pp_rot_mode=One)(pp_connected=Yes)(pp_work=Features))",
	     mode=>'regular');
$f->COM ('chklist_run',
	     chklist=>'valor_cleanup_ref_subst',
	     nact=>1,
	     area=>'profile');
$f->COM ('chklist_close',
	     chklist=>'valor_cleanup_ref_subst',
	     mode=>'hide');
}



=head
COM chklist_single,action=valor_cleanup_ref_subst,show=yes
COM chklist_cupd,chklist=valor_cleanup_ref_subst,nact=1,params=((pp_layer=.affected)(pp_in_selected=All)(pp_tol=0)(pp_rot_mode=One)(pp_connected=Yes)(pp_work=Features)),mode=regular
COM chklist_run,chklist=valor_cleanup_ref_subst,nact=1,area=profile
COM chklist_close,chklist=valor_cleanup_ref_subst,mode=hide


