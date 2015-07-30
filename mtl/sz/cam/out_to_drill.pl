#!/usr/bin/perl
use strict;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my $id=$$;
###______________________
kysy();
$f->COM ('close_form',job=>$JOB,form=>'eng');
unit_set('inch');
unless ( get_select_count()  ) {
	p__('Plese select  ');
	exit;
}

sel_copy_other($id);
clear($id);
$f->COM ('sel_break');
$f->COM ('sel_cut_data',
    det_tol=>1,
	con_tol=>1,
	rad_tol=>0.1,
	filter_overlaps=>'no',
	delete_doubles=>'no',
	use_order=>'yes',
	ignore_width=>'yes',
	ignore_holes=>'none',
	start_positive=>'yes',
	polarity_of_touching=>'same');
$f->COM ('sel_cont2pad',
    match_tol=>1.5,
	restriction=>'',
	min_size=>8,
	max_size=>500,
	suffix=>'+++');
$f->VOF;
delete_layer('tmp');
$f->VON;
sel_copy_other('tmp');
delete_layer($id);
delete_layer("${id}+++");
clear('tmp');




##creat_clear_layer('tmp');






=head
sel_copy_other($id);
clear($id);
$f->COM ('sel_break');
$f->COM ('sel_cut_data',
    det_tol=>1,
	con_tol=>1,
	rad_tol=>0.1,
	filter_overlaps=>'no',
	delete_doubles=>'no',
	use_order=>'yes',
	ignore_width=>'yes',
	ignore_holes=>'none',
	start_positive=>'yes',
	polarity_of_touching=>'same');
$f->COM ('sel_cont2pad',
    match_tol=>1.5,
	restriction=>'',
	min_size=>8,
	max_size=>500,
	suffix=>'+++');

$f->VOF;
delete_layer('tmp');
$f->VON;
sel_copy_other('tmp');
delete_layer($id);
delete_layer("${id}+++");
clear('tmp');


















=head
$f->VOF;
delete_layer('tmp');
$f->VON;














