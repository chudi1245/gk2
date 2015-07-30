#!/usr/bin/perl
use strict;
use Genesis;
use FBI;

use File::Path;
use File::Copy::Recursive;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

##___________________________________
my $path = "D:/work/output";
if (not -d "$path/cut") {	mkpath("$path/cut") or die $!; }

if ( exists_layer('v-cut') eq 'yes' ) {

	output_cen('v-cut','D:/work/output/cut');
}else{
    p__("v-cut layer is not exist");
}

my $vut_file = "D:/work/output/${JOB}-v-cut.GBR";



chdir $path or die $!;
if (-d "$path/cut") {
	opendir (DH,"$path/cut") or die $!;
	my @fcut =readdir DH;
	chdir "$path/cut" or die $!;

	if ($#fcut > 1) {
		`d:/xxx/camp/exe/rar.exe  a  "V$JOB" `;
		File::Copy::Recursive::move("$path/cut/V${JOB}.rar","$path/V${JOB}.rar");	
	}
}



sub output_cen {
	my $layer=shift;
	my $path=shift;
	my $mirror=shift||'no' ;
	my $x_scale=shift||1;
	my $y_scale=shift||1;
	my $x_anchor=shift||0;
	my $y_anchor=shift||0;
       my $angle=shift||0;
       my $whel=shift||0;
    my $pre = "$JOB"."-";
   $f->COM ('output_layer_reset');
   $f->COM ('output_layer_set',
	   layer=>$layer,
	   angle=>$angle,
	   mirror=>$mirror,
	   x_scale=>$x_scale,
	   y_scale=>$y_scale,
	   comp=>0,
	   polarity=>'positive',
	   setupfile=>'',
	   setupfiletmp=>'',
	   line_units=>'inch',
	   gscl_file=>'');
   $f->COM ('output',
	   job=>$JOB,
	   step=>$STEP,
	   format=>'Gerber274x',
	   dir_path=>$path,
	   prefix=>$pre,
	   suffix=>'.GBR',
	   break_sr=>'yes',
	   break_symbols=>'yes',
	   break_arc=>'yes',
	   scale_mode=>'nocontrol',
	   surface_mode=>'fill',
	   min_brush=>1,
	   units=>'inch',
	   coordinates=>'absolute',
	   zeroes=>'none',
	   nf1=>2,
	   nf2=>4,
	   x_anchor=>$x_anchor,
	   y_anchor=>$y_anchor,
	   wheel=>'',
	   x_offset=>0,
	   y_offset=>0,
	   line_units=>'inch',
	   override_online=>'yes',
	   film_size_cross_scan=>0,
	   film_size_along_scan=>0,
	   ds_model=>'RG6500');
   $f->COM ('disp_on');
   $f->COM ('origin_on') && return 'ok';
}
