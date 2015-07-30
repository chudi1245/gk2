#!/usr/bin/perl
use strict;
use Genesis;
use FBI;
use File::Path; 
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my (@gROWname,@prof_limits);
my $path=("d:/work/output/");
###_________________
kysy();

if ($STEP ne 'pnl') { p__("the step not pnl");  exit;  }
@gROWname=@{info('matrix',"$JOB/matrix",)->{gROWname}};
@prof_limits=prof_limits($STEP);
my $prof_center_x = ( $prof_limits[2]+$prof_limits[0] )/2;
my $prof_center_y = ( $prof_limits[3]+$prof_limits[1] )/2;
###___________________________
if ( exists_layer('gto')  eq  'yes' ) {
	creat_clear_layer('tmp');
	clear('gto');
	filter({feat_types =>'line\;pad\;surface\;arc'});  ##dont select text "FN/gtl...."
    get_select_count()  ?  ( sel_move_other('tmp') )  :  ( p__('error cant select anything gto'), exit);

	if (not -d "$path/T") {	mkpath("$path/T") or die $!; }
	output_layer('gto',"$path/T",'no',1,1,0,0,270);  ###out gto

	clear('tmp');
	sel_move_other('gto');

	if ( exists_layer('gtl') ) { 
		output_layer('gtl',"$path/T",'no',1,1,0,0,270);  ###out gtl 
        creat_clear_layer('ref-t');

		clear('gtl');
		filter( {feat_types=>'pad', polarity=>'positive', include_syms=>'r59.055'} );
        get_select_count()  ?  ( sel_copy_other('ref-t') )  :  (p__('error cant select anything gtl'), exit);

		clear('ref-t');
        select_rectangle($prof_center_x,$prof_center_y,$prof_limits[2],$prof_limits[1]);
		get_select_count()  ?  ( $f->COM ('sel_delete') )  :  (p__('error cant select anything ref-t'), exit);

		clear('drl');
		filter_zk('.zk','top');
		get_select_count()  ?  ( sel_copy_other('ref-t') )  :  (p__('error cant select anything drl'), exit);###add one
		output_layer('ref-t',"$path/T",'no',1,1,0,0,270);#### out ref-t
	};
}


if ( exists_layer('gbo') eq 'yes' ) {
	creat_clear_layer('tmp');
	clear('gbo');
	filter({feat_types =>'line\;pad\;surface\;arc'});  ##dont select text "FN/gtl...."
	get_select_count()  ?  ( sel_move_other('tmp') )  :  ( p__('error cant select anything gbo'), exit );

	if (not -d "$path/B") { mkpath("$path/B") or die $!;}
	output_layer('gbo',"$path/B",'yes',1,1,0,0,270);#### out gbo mirror

	clear('tmp');
	sel_move_other('gbo');

	if ( exists_layer('gbl') ) { 
		output_layer('gbl',"$path/B",'yes',1,1,0,0,270);  ###out gbl
        creat_clear_layer('ref-b');

		clear('gbl');
		filter( {feat_types=>'pad', polarity=>'positive', include_syms=>'r59.055'} );
		get_select_count()  ?  ( sel_copy_other('ref-b') )  :  (p__('error cant select anything gbl'), exit);

		clear('ref-b');
        select_rectangle($prof_center_x,$prof_center_y,$prof_limits[0],$prof_limits[1]);
		get_select_count()  ?  ( $f->COM ('sel_delete') )  :  (p__('error cant select anything ref-b'), exit);###del one

		clear('drl');
		filter_zk('.zk','bot');
		get_select_count()  ?  ( sel_copy_other('ref-b') )  :  (p__('error cant select anything drl'), exit);###add one
		output_layer('ref-b',"$path/B",'yes',1,1,0,0,270);#### out ref-b  mirror 
	};
}

####transtion D_code
trans_dcode("$path/T/ref-t.GBR") if (-e "$path/T/ref-t.GBR");
trans_dcode("$path/B/ref-b.GBR") if (-e "$path/B/ref-b.GBR");

my %re_name=(
  "$path/T/ref-t.GBR" => "$path/T/REF.GBR",
  "$path/T/gto.GBR"   => "$path/T/LEGEND.GBR",
  "$path/T/gtl.GBR"   => "$path/T/LAYER.GBR",
  "$path/B/ref-b.GBR" => "$path/B/REF.GBR",
  "$path/B/gbo.GBR"   => "$path/B/LEGEND.GBR",
  "$path/B/gbl.GBR"   => "$path/B/LAYER.GBR",
);
##reanme file
foreach  (keys %re_name) {
	if (-e $_) {
		rename($_, $re_name{$_})  or warn $!;
	}
}

chdir $path or die $!;
my (@f_t, @f_b);
if (-d "$path/T") {
	opendir (DH,"$path/T") or die $!;  @f_t =readdir DH;
}
if (-d "$path/B") {
	opendir (DH,"$path/B") or die $!;  @f_b =readdir DH;
}

if ($#f_t > 1) {`d:/xxx/camp/exe/rar.exe  a  "s$JOB" "T"`;};
if ($#f_b > 1) {`d:/xxx/camp/exe/rar.exe  a  "s$JOB" "B"`;};
####
p__('output print ss ok,exit');
exit;
###________________________________________________________________________________________________________sub 
sub trans_dcode{
	my $file=shift;
	my $content;
    open(FH_R,$file) or return $!;
    while (<FH_R>) { $content.=$_; };
    close FH_R;
    my @line=split "\n",$content;
    my $number= grep m{\bG54D1[10]}ig, @line ;
    if ($number == 2 ) {
		open(FH_W,">$file") or die $!;
		print FH_W number_2($content);
		close FH_W;
    }elsif ($number == 4 ) {
		open(FH_W,">$file") or die $!;
		foreach  (  number_4($content)  ) {   print FH_W $_,"\n";   }
		close FH_W;
	}
}

sub number_2 {
	my $cont=shift;
	my $regx=$cont =~ m{G54(D1[01])\*([^<]*?)G54(D1[01])\*}i;
    if ($regx) {
		 my ($flag,$mid_word,$flag_2)=($1,$2,$3);
		 my @line_mid_word=$mid_word =~ m{\n}g;
		 if ($#line_mid_word > 2) {
			 $cont =~ s/$flag/D233/g;
			 $cont =~ s/$flag_2/D226/g;
		 }else{
			 $cont =~ s/$flag/D226/g;
			 $cont =~ s/$flag_2/D233/g;
		 }
		 return  $cont;
	}
}

sub number_4 {
	my ($s_d11,$s_d10);
	my @line=split "\n",shift;
	my $id=grep m{\bG54D11}ig,@line;
	if ($id == 3) {
		$s_d11='D233';
		$s_d10='D226';
	}else{
		$s_d11='D226';
		$s_d10='D233';
	}
	foreach  (@line) {
		$_ =~ s/[dD]10/$s_d10/;
		$_ =~ s/[dD]11/$s_d11/;
	}
	return @line;
}

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

sub filter_zk {
	my $attribute=shift;
	my $option=shift;
    $f->COM ('filter_reset',filter_name=>'popup');
    $f->COM ('filter_atr_set',filter_name=>'popup',condition=>'yes',attribute=>$attribute,option=>$option);
    $f->COM ('filter_area_strt');
    $f->COM ('filter_area_end',
    layer=>'',
	filter_name=>'popup',
	operation=>'select',
	area_type=>'none',
	inside_area=>'no',
	intersect_area=>'no',
	lines_only=>'no',
	ovals_only=>'no',
	min_len=>0,
	max_len=>0,
	min_angle=>0,
	max_angle=>0);
}

=head


