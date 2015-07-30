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
###################
kysy();

$f->COM('units', type => 'mm');
if ($STEP ne 'pnl') { p__("the step not pnl");  exit;  }

my $path=("d:/work/output/");

if (not -d "$path/cy") {	mkpath("$path/cy") or die $!; }
my $path2="d:/work/output/cy";
my $fix=gmtime();$fix =~ s/[ :]//g;

if (-d $path){ File::Copy::Recursive::dirmove($path2, "c:/tmp/work.$fix") or dis_erro($!);}

my $dr_layer =$JOB."-cy.drl";
my $cy_layer =$JOB."-cy.rou";
############# ######
if ( exists_layer($dr_layer) eq 'yes' ) {$f->COM("delete_layer,layer=$dr_layer");}
if ( exists_layer('drl') eq 'yes' ) {
	 clear('drl');
	 filter( {feat_types=>'pad', polarity=>'positive', include_syms=>'r3176'} );
	 get_select_count()  ?  ( sel_copy_other($dr_layer) )  :  (p__('error cant select anything drl'), exit);
	
	#$f->COM('open_entity', job => $JOB,type => 'matrix',name => 'matrix',iconic => 'no');
	 $f->COM('matrix_layer_context', job => $JOB,matrix  => 'matrix',layer   => $dr_layer,context => 'board');
     $f->COM('matrix_layer_type', job => $JOB,matrix => 'matrix',layer  => $dr_layer,type   => 'drill');
	#$f->COM('matrix_page_close', job => $JOB, matrix => 'matrix');
}


if ( exists_layer($cy_layer) eq 'yes' ) {$f->COM("delete_layer,layer=$cy_layer");}

if ( exists_layer('cy') eq 'yes' ) {
	clear('cy');
	$f->COM ('sel_reverse');
	#filter( {feat_types=>'line\;arc', polarity=>'positive', include_syms=>'r254'} );
	get_select_count()  ?  ( sel_copy_other($cy_layer) )  :  (p__('error cant select anything 10mil line'), exit);
	
	#$f->COM('open_entity', job => $JOB, type   => 'matrix',name   => 'matrix',iconic => 'no');
	##设置层属性为rout层
	$f->COM('matrix_layer_context', job => $JOB,matrix  => 'matrix',layer   => $cy_layer,context => 'board');
	$f->COM('matrix_layer_type', job => $JOB,matrix => 'matrix',layer  => $cy_layer,type   => 'rout');
	
	#$f->COM('matrix_page_close', job => $JOB, matrix => 'matrix');	
    
	clear($cy_layer);
	$f->COM('sel_break');   ##执行打散
	$f->COM('units', type => 'mm');
	
##先锣槽
	$f->COM('filter_set', filter_name  => 'popup',update_popup => 'no',include_syms => 'r3175');
	$f->COM('filter_area_strt');
	$f->COM('filter_area_end', layer => '',filter_name=> 'popup', operation  => 'select',area_type=> 'none',inside_area=> 'no',intersect_area => 'no');
	$f->COM('filter_reset', filter_name => 'popup');
	if (get_select_count() > 0) {
	$f->COM('chain_add', layer => $cy_layer, chain => 1,size  => '1.45',comp  => 'none',flag  => 0,feed  => 0,speed => 0);
	}	

	$f->COM('filter_set', filter_name  => 'popup',update_popup => 'no',include_syms => 'r254');
	$f->COM('filter_area_strt');
	$f->COM('filter_area_end', layer => '',filter_name=> 'popup',operation => 'select',area_type => 'none',inside_area => 'no',intersect_area => 'no');
	$f->COM('filter_reset', filter_name => 'popup');

	if (get_select_count() > 0) {
	#$f->COM('chain_add', layer => $cy_layer,chain => 2,size  => '1.60',comp  => 'none',flag  => 0,feed  => 0,speed => 0, first=>2,chng_direction=>1);
    $f->COM('chain_add', layer => $cy_layer, chain => 2,size  => '1.45',comp  => 'none',flag  => 0,feed  => 0,speed => 0);
   #输出CY和定位孔
    outputcy();
	}	
}

chdir $path or die $!;
my @fcy;
if (-d "$path/cy") {
	opendir (DH,"$path/cy") or die $!;
	@fcy =readdir DH;
	##p__("$fcy[2],$fcy[3],$#fcy");
	chdir "$path/cy" or die $!;
	if ($#fcy > 1) {
		`d:/xxx/camp/exe/rar.exe  a  "r${JOB}-cy" `;
		##p__("is ok");
		File::Copy::Recursive::move("$path/cy/r${JOB}-cy.rar","$path/r${JOB}-cy.rar");	
	}
}

p__("cy_rout ouput to $path is ok, exit");
#################end
sub outputcy{
	$f->COM('output_layer_reset');
	$f->COM('output_layer_set', layer  => $dr_layer,
                          angle        => 0,
                          mirror       => 'no',
                          x_scale      => 1,
                          y_scale      => 1,
                          comp         => 0,
                          polarity     => 'positive',
                          setupfile    => '',
                          setupfiletmp => '',
                          line_units   => 'mm',
                          gscl_file    => '',
                          step_scale   => 'no');

$f->COM('output_layer_set', layer        => $cy_layer,
                          angle        => 0,
                          mirror       => 'no',
                          x_scale      => 1,
                          y_scale      => 1,
                          comp         => 0,
                          polarity     => 'positive',
                          setupfile    => '',
                          setupfiletmp => '',
                          line_units   => 'mm',
                          gscl_file    => '',
                          step_scale   => 'no');


$f->COM('output', job             => $JOB,
                step              => $STEP,
                format            => 'Excellon2',
                dir_path          => "$path/cy",
                prefix            => '',
                suffix            => '',
                break_sr          => 'yes',
                break_symbols     => 'yes',
                break_arc         => 'no',
                scale_mode        => 'all',
                surface_mode      => 'fill',
                min_brush         => 1,
                units             => 'mm',
                coordinates       => 'absolute',
                decimal           => 'no',
                zeroes            => 'trailing',
                nf1               => 3,
                nf2               => 3,
                modal             => 'yes',
                tool_units        => 'mm',
                optimize          => 'no',
                iterations        => 5,
                reduction_percent => 1,
                cool_spread       => 0,
                x_anchor          => 0,
                y_anchor          => 0,
                x_offset          => 0,
                y_offset          => 0,
                line_units        => 'mm',
                override_online   => 'yes',
                canned_text_mode  => 'break');

$f->COM('ncset_create', name => '_1_tmp__+++_');
$f->COM('ncset_cur', job   => $JOB,
                   step  => $STEP,
                   layer => $dr_layer,
                   ncset => '');
$f->COM('ncrset_create', name => '_1_tmp__+++_');
$f->COM('ncrset_cur', job   => $JOB,
                    step  => $STEP,
                    layer => $cy_layer,
                    ncset => '');
$f->COM('disp_on');
$f->COM('origin_on');
}

sub getdate{
	my $date = &getTime();#获取当前系统时间的Hash
	my $year=$date->{year}-2000;#获取年
	my $month=$date->{month};#获取月
	my $day=$date->{day};#获取日
	my $alldate= "$year$month$day";
	return $alldate;
}

