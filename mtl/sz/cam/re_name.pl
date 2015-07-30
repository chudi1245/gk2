#!/usr/bin/perl

use strict;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our ($host,$f,$JOB,$STEP);
my ($mw, $style_pads, $style_protel);
my (@layer_name,@layer_new,@layer_type,@layer_side,@layer_row);
$host = shift;
$f = new Genesis($host);
$JOB = $ENV{JOB};
$STEP = $ENV{STEP};

###___________________________
kysy();

$f->COM ('close_form',job=>"$JOB",form=>"qae");
$f->INFO(entity_type => 'matrix',
         entity_path => "$JOB/matrix",
         data_type   => 'ROW');
@layer_name=@{$f->{doinfo}{gROWname}};
$style_pads = grep m/\.pho$/, @layer_name;
$style_protel = (grep m/\.gko$/, @layer_name)+(grep m/\.gm\d+/,@layer_name);
##__99se
if ($style_pads == 0 and  $style_protel > 0) {
	foreach  (@layer_name){
		if ($_) {
		    my $name_new = $_          ;
		    $name_new =~ s/.*\.//i     ;
		    $name_new =~ s/gtl/l1/i    ;
		    $name_new =~ s/gbl/l99/i   ;
		    $name_new =~ s/gts/sm1/i   ;
		    $name_new =~ s/gbs/sm2/i   ;
		    $name_new =~ s/gto/ss1/i   ;
		    $name_new =~ s/gbo/ss2/i   ;
		    $name_new =~ s/gpt/sp1/i   ;
		    $name_new =~ s/gpb/sp2/i   ;
		    $name_new =~ s/gtp/sp11/i  ;
		    $name_new =~ s/gbp/sp22/i  ;
            $f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$_,new_name=>$name_new);
		}
	}
	$f->COM ('matrix_auto_rows',job=>$JOB,matrix=>'matrix');
}

##__pads
if ($style_pads > 0 and  $style_protel == 0) {
	foreach  (@layer_name){
		if ($_) {
			/\d+/;
			my ($part_left,$part,$part_right)=($`,$&,$');
			$part_left =~ s/art/l/     ;
			$part_left =~ s/pgp/l/     ;
			$part_left =~ s/smd/sp/    ;
			$part_left =~ s/sst/ss1/   ;
			$part_left =~ s/ssb/ss2/   ;
			$part      =~ s/^0+//      ;
			$part_right=~ s/\.pho//    ;
			$part_right=~ s/\.drl//    ;
			$part      =~ s/^0+//; 
			my $name_new = $part_left.$part.$part_right;
            $f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$_,new_name=>$name_new);
		}
	}##end foreach
	$f->COM ('matrix_auto_rows',job=>$JOB,matrix=>'matrix');
	$f->INFO(entity_type => 'matrix',
         entity_path => "$JOB/matrix",
         data_type   => 'ROW');
	@layer_name=@{$f->{doinfo}{gROWname}};
	@layer_type=@{$f->{doinfo}{gROWlayer_type}};
	@layer_side=@{$f->{doinfo}{gROWside}};
	@layer_row=@{$f->{doinfo}{gROWrow}};
	foreach  (@layer_row) {
		my $i=$_-1;
		if ($layer_type[$i] eq 'solder_mask' and $layer_side[$i] eq 'top') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'sm1');		
		}
		if ($layer_type[$i] eq 'solder_mask' and $layer_side[$i] eq 'bottom') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'sm2');			
		}		
		if ($layer_type[$i] eq 'silk_screen' and $layer_side[$i] eq 'top') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'ss1');		
		}		
		if ($layer_type[$i] eq 'silk_screen' and $layer_side[$i] eq 'bottom') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'ss2');
		}	
		if ($layer_type[$i] eq 'solder_paste' and $layer_side[$i] eq 'top') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'sp1');		
		}		
		if ($layer_type[$i] eq 'solder_paste' and $layer_side[$i] eq 'bottom') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'sp2');
		}	
		if ($layer_type[$i] eq 'signal' and $layer_side[$i] eq 'bottom') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'l99');
		}
		if ($layer_name[$i] eq 'drl1') {
			$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$layer_name[$i],new_name=>'drl');
		}
	}##end foreach
}
if ($style_pads > 0 and  $style_protel > 0){
	$f->PAUSE("Canot identify the source file,");
	exit;
}
if ($style_pads == 0 and  $style_protel == 0){
	$f->PAUSE("Canot identify the source file,");
	exit;
}









                    





