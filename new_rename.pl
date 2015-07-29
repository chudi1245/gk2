#! /usr/bin/perl
##
use strict;
use Tk;
use Genesis;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my (@gROWname,@prof_limits,@old_name,@new_name,%entry);
my ($row,$column,$mw,$style_pads,$style_protel,$style_aligo)=(0,0);
###__________________________
kysy();
@gROWname=@{info("matrix","$JOB/matrix","row")->{gROWname}};
$style_pads = grep m/\.pho$/i, @gROWname;
my $style_pads_art = grep m{art}i, @gROWname; 
$style_aligo= grep m/\.art$/i, @gROWname;
$style_protel = (grep m{\.gko$}i, @gROWname)+(grep m{\.gm.+},@gROWname);

foreach  (@gROWname) {push @old_name,$_    if    $_ };
###p__(" $style_aligo $style_pads_art  $style_protel $style_pads");
###______________________
if ($style_pads == 0 and  $style_protel > 0) {###__________________is 99se
	foreach  (@old_name) {
		my $name_new = $_      ;
		$name_new =~ s/.*\.//i ; 
		push @new_name,$name_new;
		$entry{$_}=$name_new;
	}
}elsif($style_pads>0 and  $style_protel == 0 and $style_pads_art > 1) {###_______________is power_pcb pho
	my (@p_h,@p,@p_e);
	my (%hash_p,%hash_sort,$i);
	my (%hash_p_m,%hash_sort_m,$i_m);
	my (%hash_p_p,%hash_sort_p,$i_p);
	foreach  (@old_name){
		$_ =~ m{\d+};
		my ($part_h,$part,$part_e)=($`,$&,$');
		$part_h =~ s/art/l/     ;
		$part_h =~ s/pgp/l/     ;
		$part_h =~ s/smd/sp/    ;
		$part_h =~ s/sst/gto/   ;
		$part_h =~ s/ssb/gbo/   ;
		$part   =~ s/^0+//      ;
		$part_e=~ s/\.pho//     ;
		$part_e=~ s/\.drl//     ;
		$part      =~ s/^0+//   ; 
		push  @p_h,$part_h      ;
		push  @p,$part          ;
		push  @p_e,$part_e      ;	
	}
	foreach (0..$#old_name) { $hash_p{$p[$_]}=$old_name[$_]  if  $p_h[$_]=~m{^l}i  }
    foreach (sort_b(keys %hash_p)){ $hash_sort{$_} = ++$i;}
	foreach  (0..$#old_name) {  $new_name[$_] = $p_h[$_].$hash_sort{$p[$_]}   if   $p_h[$_]=~m{^l}i ;}###____
	foreach (0..$#old_name) { $hash_p_m{$p[$_]}=$old_name[$_]  if  $p_h[$_]=~m{^sm}i  }
    foreach (sort_b(keys %hash_p_m)){ $hash_sort_m{$_} = ++$i_m;}
	foreach  (0..$#old_name) {  $new_name[$_] = $p_h[$_].$hash_sort_m{$p[$_]}   if   $p_h[$_]=~m{^sm}i ;}###___
	foreach (0..$#old_name) { $hash_p_p{$p[$_]}=$old_name[$_]  if  $p_h[$_]=~m{^sp}i  }
    foreach (sort_b(keys %hash_p_p)){ $hash_sort_p{$_} = ++$i_p;}
	foreach  (0..$#old_name) {  $new_name[$_] = $p_h[$_].$hash_sort_p{$p[$_]}   if   $p_h[$_]=~m{^sp}i ;}###___
	foreach  (0..$#old_name) {
		if  ($p_h[$_]=~m{^g[tb]o}i ){$new_name[$_] = $p_h[$_];}
		if  ($p_h[$_]=~m{^drl}i  and  !$p_e[$_]){$new_name[$_] = $p_h[$_];}
	}
	foreach  (0..$#old_name) {$new_name[$_] = $p_h[$_].$p[$_]  unless $new_name[$_]	}
	my $flage=-1;
	foreach  (@new_name) {
		if ($_ =~ m{^l\d}) {$flage++};
		$_ =~ s/^l1/gtl/i;
		$_ =~ s/^sm1/gts/i;
		$_ =~ s/^sm2/gbs/i;
		$_ =~ s/^sp2/gbp/i;
		$_ =~ s/^sp1/gtp/i;
	}
	$new_name[$flage]='gbl';
}elsif ($style_aligo > 0){###_______________is power_aligo
p__('alga');
	foreach  (@old_name){
		my $name_new=$_;
		if ($name_new =~ m{\.dr}i ) {  $name_new =~ s/.*\.//i;  }
		$name_new =~ s/\.art$//i ; 
		$name_new =~ s/^top$/gtl/i ;

		$name_new =~ s/^bottom$/gbl/i ;
		$name_new =~ s/^soldtop$/gts/i ;
		$name_new =~ s/^soldbot$/gbs/i ;
		$name_new =~ s/silktop/gto/i ;
		$name_new =~ s/silkbot/gbo/i ;
		$name_new =~ s/^outline$/box/i ;
		push @new_name,$name_new;
	}
}else{###__________________________________________________________not 99se or powerpcb
    @new_name=@old_name;
}####______________________________________________________________end  style judgement
$mw=MainWindow->new;
$mw->title('Better and better');
$mw->geometry("+200+100");
foreach  (0..$#old_name) {
	$mw->Label(-text=>$old_name[$_],-width=>26,-anchor=>'w',-relief=>'sunken')->grid(-column=>0, -row=>++$row);
	$mw->Label(-text=>'====>',-width=>12,)->grid(-column=>1, -row=>$row);
	$mw->Entry(-textvariable=>\$new_name[$_],-width=>20,)->grid(-column=>2, -row=>$row);
}
$mw->Button(-text=>'Apply',-width=>12,-command=>\&apply)->grid(-column=>1, -row=>++$row);
MainLoop;
#####____________________sub
sub apply {
	foreach  (0..$#old_name) {
		$f->COM ('matrix_rename_layer',job=>$JOB,matrix=>'matrix',layer=>$old_name[$_],new_name=>$new_name[$_]);
	}
	$f->COM ('matrix_auto_rows',job=>$JOB,matrix=>'matrix');
	exit;
}






