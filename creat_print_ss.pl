#!/usr/bin/perl
use strict;
use Genesis;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my (@gROWname,@prof_limits);
my $path=("d:/work/output/");
###_________________
kysy();
unless ($STEP) { 
	 $STEP=read_form($JOB,'eng','E102');
	 $f->COM ('close_form',job=>$JOB,form=>'eng');
	 unless ($STEP) { p__('no step');   exit;  };
	 open_step($STEP);
}
###_________________
@gROWname=@{info('matrix',"$JOB/matrix",)->{gROWname}};
@prof_limits=prof_limits($STEP);
my $prof_center_x = ( $prof_limits[2]+$prof_limits[0] )/2;
my $prof_center_y = ( $prof_limits[3]+$prof_limits[1] )/2;
###___________________________
if ( exists_layer('gto')  eq 'yes' ) {
	clear_layer('tmp');
	clear('gto');
	select_out_profile();
	sel_move_other('tmp') if get_select_count();
	if (-d "$path/T") {   
		output_layer('gto',"$path/T");  ###out gto 
	}else{
		p__("not path $path/T"); exit;
	};
	clear('tmp');
	sel_move_other('gto');
	if ( exists_layer('gtl') ) { 
		output_layer('gtl',"$path/T");  ###out gtl 
        clear_layer('ref-t');
		clear('gtl');
		$f->COM ('sel_clear_feat');
        $f->COM ('sel_multi_feat',operation=>'select',feat_types=>'pad',include_syms=>'r59.055');
		sel_copy_other('ref-t') if get_select_count();
		clear('ref-t');
        select_rectangle($prof_center_x,$prof_center_y,$prof_limits[2],$prof_limits[1]);
		$f->COM ('sel_delete') if get_select_count();###del one
		clear('drl');
		filter_zk('.zk','lef');
		sel_copy_other('ref-t') if get_select_count();###add one
		output_layer('ref-t',"$path/T");#### out ref-t
	};
}

if ( exists_layer('gbo') eq 'yes' ) {
	clear_layer('tmp');
	clear('gbo');
	select_out_profile();
	sel_move_other('tmp') if get_select_count();
	if (-d "$path/B") {   
	    output_layer('gbo',"$path/B",'yes');#### out gbo mirror
	}else{
		p__("not path $path/B");exit;
	};
	clear('tmp');
	sel_move_other('gbo');
	if ( exists_layer('gbl') ) { 
		output_layer('gbl',"$path/B",'yes');  ###out gbl
        clear_layer('ref-b');
		clear('gbl');
		$f->COM ('sel_clear_feat');
        $f->COM ('sel_multi_feat',operation=>'select',feat_types=>'pad',include_syms=>'r59.055');
		sel_copy_other('ref-b') if get_select_count();
		clear('ref-b');
        select_rectangle($prof_center_x,$prof_center_y,$prof_limits[0],$prof_limits[1]);
		$f->COM ('sel_delete') if get_select_count();###del one
		clear('drl');
		filter_zk('.zk','rig');
		sel_copy_other('ref-b') if get_select_count();###add one
		output_layer('ref-b',"$path/B",'yes',);#### out ref-b  mirror 
	};
}

####transtion D_code
trans_dcode("$path/T/ref-t.GBR");
trans_dcode("$path/B/ref-b.GBR");
my %re_name=(
  "$path/T/ref-t.GBR" => "$path/T/REF.GBR",
  "$path/T/gto.GBR"   => "$path/T/LEGEND.GBR",
  "$path/T/gtl.GBR"   => "$path/T/LAYER.GBR",
  "$path/B/ref-b.GBR" => "$path/B/REF.GBR",
  "$path/B/gbo.GBR"   => "$path/B/LEGEND.GBR",
  "$path/B/gbl.GBR"   => "$path/B/LAYER.GBR",
);
map { rename $_,$re_name{$_} } keys %re_name;
chdir $path or die $!;  
opendir (DH,"$path/T");  my @f_t =readdir DH;
opendir (DH,"$path/B");  my @f_b =readdir DH;
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
sub clear_layer {
	my $name = shift;
	$f->VOF;
	clear($name);
	$f->COM ('sel_delete');
	$f->VON;
}
sub select_out_profile{
	$f->COM ('filter_set',
	filter_name  =>'popup',
	update_popup =>'no',
	feat_types   =>'line\;pad\;surface\;arc');
    $f->COM ('filter_area_strt');
    $f->COM ('filter_area_end',
	   layer        =>'',
	   filter_name  =>'popup',
	   operation    =>'select',
	   area_type    =>'none',
	   inside_area  =>'no',
	   intersect_area=>'no',
	   lines_only   =>'no',
	   ovals_only   =>'no',
	   min_len      =>0,
	   max_len      =>0,
	   min_angle    =>0,
	   max_angle    =>0);	
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
