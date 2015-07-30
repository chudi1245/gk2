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
my (@gROWname,@prof_limits);
my $path=("d:/work/output/");
###_________________
kysy();
unit_set('inch');
if ($STEP ne 'pnl') { p__("the step not pnl");  exit;  }
@gROWname=@{info('matrix',"$JOB/matrix",)->{gROWname}};
@prof_limits=prof_limits($STEP);
my $prof_center_x = ( $prof_limits[2]+$prof_limits[0] )/2;
my $prof_center_y = ( $prof_limits[3]+$prof_limits[1] )/2;

if (not -d "$path/ps") {	mkpath("$path/ps") or die $!; }
my $path2="d:/work/output/ps";
my $fix=gmtime();
$fix =~ s/[ :]//g;

if (-d $path){ 
	File::Copy::Recursive::dirmove($path2, "c:/tmp/work.$fix") or dis_erro($!);
}
####if (not -d "$path/ps") {	mkpath("$path/ps") or die $!; }
$f->COM("copy_entity,type=wheel,source_job=genesislib,source_name=230.apr,dest_job=$JOB,dest_name=230.apr,dest_database=");

if ( exists_layer('ref-t') eq 'yes' ) {$f->COM("delete_layer,layer=ref-t");}
if ( exists_layer('ref-b') eq 'yes' ) {$f->COM("delete_layer,layer=ref-b");}
if ( exists_layer('c') eq 'yes' ) {$f->COM("delete_layer,layer=c");}
if ( exists_layer('s') eq 'yes' ) {$f->COM("delete_layer,layer=s");}



###___________________________ַ
if ( exists_layer('gto')  eq  'yes' ) {
	creat_clear_layer('pmt');
	clear('gto');
	filter({feat_types =>'line\;pad\;surface\;arc'});  ##dont select text "FN/gtl...."
    get_select_count()  ?  ( sel_move_other('pmt') )  :  ( p__('error cant select anything gto'), exit);    
	$f->COM("flatten_layer,source_layer=gto,target_layer=c");
	clear('pmt');
	sel_move_other('gto');

	if ( exists_layer('gtl') ) { 
    	creat_clear_layer('ref-t');
		clear('gtl');
		filter( {feat_types=>'pad', polarity=>'positive', include_syms=>'r59.055'} );
        get_select_count()  ?  ( sel_copy_other('ref-t') )  :  (p__('error cant select anything gtl'), exit);

		clear('ref-t');
		#2014-5-24
        #select_rectangle($prof_center_x,$prof_center_y,$prof_limits[0],$prof_limits[3]);
		#get_select_count()  ?  ( $f->COM ('sel_delete') )  :  (p__('error cant select anything c'), exit);

		$f->COM("filter_reset,filter_name=popup");
		$f->COM("cur_atr_set,attribute=.out_flag,int=233");
		$f->COM("sel_change_atr,mode=add");                     #####233
			  
	    clear('ref-t');
	    sel_move_other('c');
        output_layer('c',"$path/ps",'no',1,1,0,0,270,'230.apr');#### out c
	};
}

######ײַ
if ( exists_layer('gbo') eq 'yes' ) {
	creat_clear_layer('pmt');
	clear('gbo');
	filter({feat_types =>'line\;pad\;surface\;arc'});  ##dont select text "FN/gtl...."
	get_select_count()  ?  ( sel_move_other('pmt') )  :  ( p__('error cant select anything gbo'), exit );
    $f->COM("flatten_layer,source_layer=gbo,target_layer=s");
	
	clear('pmt');
	sel_move_other('gbo');

	if ( exists_layer('gbl') ) { 
        creat_clear_layer('ref-b');
		clear('gbl');
		filter( {feat_types=>'pad', polarity=>'positive', include_syms=>'r59.055'} );
		get_select_count()  ?  ( sel_copy_other('ref-b') )  :  (p__('error cant select anything gbl'), exit);

		clear('ref-b');
		#2014-5-24
        #select_rectangle($prof_center_x,$prof_center_y,$prof_limits[0],$prof_limits[3]);	
		#get_select_count()  ?  ( $f->COM ('sel_delete') )  :  (p__('error cant select anything ref-b'), exit);###del one
	    
		$f->COM("filter_reset,filter_name=popup");
		$f->COM("cur_atr_set,attribute=.out_flag,int=233");
		$f->COM("sel_change_atr,mode=add");                             #####233

	    clear('ref-b');
	    sel_move_other('s');
        output_layer('s',"$path/ps",'yes',1,1,0,0,270,'230.apr');#### out s mirror ײӡַ
	
	};
}
chdir $path or die $!;
my (@f_t, @f_b);

if (-d "$path/ps") {
	opendir (DH,"$path/ps") or die $!;  @f_b =readdir DH;
}
if ($#f_b > 1) {`d:/xxx/camp/exe/rar.exe  a  "s$JOB" "ps"`;};

if ( exists_layer('ref-t') eq 'yes' ) {$f->COM("delete_layer,layer=ref-t");}
if ( exists_layer('ref-b') eq 'yes' ) {$f->COM("delete_layer,layer=ref-b");}
p__('output print ss ok,exit');
exit;
######________________________________________sub
sub select_rectangle ($$$$) {
	my ($x1,$y1,$x2,$y2)=@_;
	$f->COM ('filter_area_strt');
    $f->COM ('filter_area_xy',x=>$x1,y=>$y1,);
    $f->COM ('filter_area_xy',x=>$x2,y=>$y2);
    $f->COM ('filter_area_end',
		layer         =>'',
		filter_name   =>'popup',
		operation     =>'select',
		area_type     =>'rectangle',
		inside_area   =>'yes',
		intersect_area=>'no',
		lines_only    =>'no',
		ovals_only    =>'no',
		min_len       =>0,
		max_len       =>0,
		min_angle     =>0,
		max_angle     =>0);
}

=head


#!/usr/bin/perl
use strict;
use Win32;
use File::Copy::Recursive;
use File::Path; 

my $path="d:/work";
my $fix=gmtime();
$fix =~ s/[ :]//g;

if (-d $path){ 
	File::Copy::Recursive::dirmove($path, "c:/tmp/work.$fix") or dis_erro($!);
}

mkpath("$path/input") or dis_erro($!);
mkpath("$path/output/K_file" ) or dis_erro($!);
mkpath("$path/output/D_file" ) or dis_erro($!);
mkpath("$path/output/M_file" ) or dis_erro($!);
mkpath("$path/output/T" ) or dis_erro($!);
mkpath("$path/output/B" ) or dis_erro($!);
mkpath("$path/output/ps" ) or dis_erro($!);
mkpath("$path/pcb" ) or dis_erro($!);