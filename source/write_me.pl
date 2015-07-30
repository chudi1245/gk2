#! /usr/bin/perl
##   zq
##   2010.12.30
use strict;
use Tk;
use Tk::Pane;
use Genesis;
use Encode;
use Encode::CN;
use C;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($column,$row,$mw,$ref,@gROWname,@gROWlayer_type,@gROWlayer_type,@gROWcontext,
    @gROWside,@gROWfoil_side,$text,@layers,%layer_class )=(0,0);
my (@but_pol,@but_mir,@ent_s_x,@ent_s_y,@val_sca_x,@val_sca_y);
###__________________________
kysy();
my $ref=info("matrix","$JOB/matrix","row");
@gROWname      =@{$ref->{gROWname}};
@gROWlayer_type=@{$ref->{gROWlayer_type}};
@gROWcontext   =@{$ref->{gROWcontext}};
@gROWside      =@{$ref->{gROWside}};
@gROWfoil_side =@{$ref->{gROWfoil_side}};
@gROWlayer_type=@{$ref->{gROWlayer_type}};
foreach  (0..$#gROWname) {
	if ($gROWcontext[$_] eq 'board'){
		push @{$layer_class{board}},$gROWname[$_];
		if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
			push @{$layer_class{route}},$gROWname[$_];
		    if ($gROWside[$_] eq 'inner'){
			    push @{$layer_class{inner}},$gROWname[$_];
		    }else{
				push @{$layer_class{outer}},$gROWname[$_];
			}
		}
	}
}
my $franm=MainWindow->new;
$franm->title("Better and better QQ_190170444");
$franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>600 )->pack();
foreach  (qw\layer  polarity   mirror   x-scale  y-scale \) {
	my $width;
	($_ eq 'layer')?($width=14):($width=7);
	$mw->Button(-text=>$_,-width=>$width,-relief=>'g',-command=>[\&all_set,$_],)->grid(-column=>$column++,-row=>$row);
}

foreach  (0..$#gROWname ) {
	if ($gROWname[$_]) {
	    $mw->Label(-text=>$gROWname[$_],-width=>12,-relief=>'f')->grid(-column=>0,-row=>++$row);
		$but_pol[$_]=$mw->Button(-text=>'+',-width=>7,-relief=>'g',-command=>[\&pol_set,$_,])->grid(-column=>1,-row=>$row);
		$but_mir[$_]=$mw->Button(-text=>'',-width=>7,-relief=>'g',-command=>[\&mir_set,$_,])->grid(-column=>2,-row=>$row);
		$ent_s_x[$_]=$mw->Entry(-textvariable=>\$val_sca_x[$_],-width=>7,)->grid(-column=>3,-row=>$row);
	    $ent_s_y[$_]=$mw->Entry(-textvariable=>\$val_sca_y[$_],-width=>7,)->grid(-column=>4,-row=>$row);
		if ( $gROWside[$_] eq 'inner') {
			$ent_s_x[$_]->configure(-background=>'green');
			$ent_s_y[$_]->configure(-background=>'green');
		}
	}
}
$text=$mw->Text(-width=>40,-height=>20,-font=>[-size=>12],)->grid(-column=>$column++,-row=>1,-rowspan=>100,-sticky=>'news');
tie *STDOUT, ref $text, $text;
my $clip=$mw->Text(-width=>26,-height=>40,-font=>[-size=>12],)->grid(-column=>$column++,-row=>1,-rowspan=>100,-sticky=>'news');
#$mw->Button(-text=>'Default',-command=>\&default,-width=>14)->grid(-column=>0,-row=>++$row);
#$mw->Button(-text=>'Brush',-command=>\&brush,-width=>14)->grid(-column=>0,-row=>++$row);
#$mw->Button(-text=>'Write ME=>',-command=>\&write_me,-width=>14)->grid(-column=>3,-row=>$row,-columnspan=>2);
$mw->Label(-text=>'='x48,)->grid(-column=>0,-row=>++$row,-columnspan=>5,-sticky=>'news');
#$mw->Button(-text=>'Save',-width=>14,-command=>\&save,)->grid(-column=>3,-row=>++$row,-columnspan=>2);
$franm->Button(-text=>'Default',-command=>\&default,-width=>14)->pack(-side => 'left' );
$franm->Button(-text=>'Brush',-command=>\&brush,-width=>14)->pack(-side => 'left');
$franm->Button(-text=>'Write ME=>',-command=>\&write_me,-width=>14)->pack(-side => 'left');
$franm->Button(-text=>'Save',-width=>14,-command=>\&save,)->pack();
#default();
my @line=('仅出内层', '阻焊字符不出', '字符不出', '工程问题待与客户确认', '请复单只菲林',);
foreach  (@line) {
	my $tmp=decode('gb2312',$_);
	$clip->insert('end',"$tmp\n\n");
}
MainLoop;
###_____________________________________________________________________________________________________
sub mir_set {
	my $id=shift;
	($but_mir[$id]->cget(-text) eq 'M')?( $but_mir[$id]->configure(-text=>'')  ):(  $but_mir[$id]->configure(-text=>'M')  );
}

sub pol_set {
	my $id=shift;
	($but_pol[$id]->cget(-text) eq '+')?( $but_pol[$id]->configure(-text=>'-')  ):(  $but_pol[$id]->configure(-text=>'+')  );
}

sub all_set{
	my $id=shift;
	if ($id eq 'polarity') {
		foreach  (0..$#gROWname) {    $but_pol[$_]->configure(-text=>'+') if $but_pol[$_]    }
	}
	if ($id eq 'mirror') {
		foreach  (0..$#gROWname) {    $but_mir[$_]->configure(-text=>'') if $but_mir[$_]     }
	}
	if ($id eq 'x-scale') {  foreach (@val_sca_x) {$_=''}  }
	if ($id eq 'y-scale') {  foreach (@val_sca_y) {$_=''}  }
}

sub write_me{   $text->delete("1.0", 'end');
foreach  (0..$#gROWname) {
	if ($gROWname[$_]) {
		my ($pol,$mir,$x,$y);
		$pol=$but_pol[$_]->cget(-text);
		$mir=$but_mir[$_]->cget(-text);
		printf '%-12s',$gROWname[$_];
		printf '%-4s',$pol;
		printf '%-4s',$mir;
		$val_sca_x[$_] ? ( printf '%-8s',"X:$val_sca_x[$_]%%" ):(printf '%-8s'," ");
		$val_sca_y[$_] ? ( printf '%-8s',"Y:$val_sca_y[$_]%%" ):(printf '%-8s'," ");
		print "\n";
	}
}
print '='x30,"\n";
my @layer_all=@{$layer_class{route}};
my @layer_inner=@{$layer_class{inner}};
if ( grep m{^l2[Bb]},@layer_inner ) {
	while (@layer_all) {
		my $tmp=shift @layer_all;
		my $tmp2=shift @layer_all;
		printf '%-6s', $tmp;
		printf '%-6s', '<->';
		printf '%-6s', "$tmp2   ? MM";
		print "\n";
	}
}elsif ( grep m{^l2[Tt]},@layer_inner ){
	while (@layer_inner) {
		my $tmp=shift @layer_inner;
		my $tmp2=shift @layer_inner;
		printf '%-6s', $tmp;
		printf '%-6s', '<->';
		printf '%-6s', "$tmp2   ? MM";
		print "\n";
	}
}
print '='x30,"\n";
}###end sub

sub default {
foreach  (0..$#gROWname) {
	if ($gROWname[$_] ) {
		$val_sca_x[$_]='';
		$val_sca_y[$_]='';
		if ($gROWside[$_] eq 'top') {
			$but_pol[$_]->configure(-text=>'+',);
		}elsif ($gROWside[$_] eq 'bottom') {	
			$but_pol[$_]->configure(-text=>'+',);
		}elsif (   $gROWside[$_] eq 'inner'  ){
			$but_pol[$_]->configure(-text=>'-',);     
		}elsif (   $gROWside[$_] eq 'none'  ){
			$but_pol[$_]->configure(-text=>'+',);
		}
		($gROWname[$_] =~ m\.+[Bb]\  ) ? (  $but_mir[$_]->configure(-text=>'M',)  ) : (  $but_mir[$_]->configure(-text=>'',)  );
	}
}
}##end default

sub brush {  $text->delete("1.0", "end");
foreach  (0..$#gROWname) {
if ($gROWname[$_] ) {
	$but_pol[$_]->configure(-text=>'+',);
	$but_mir[$_]->configure(-text=>'',);
	$val_sca_x[$_]='';
	$val_sca_y[$_]='';
}
}
}

sub save {
	my $file = $mw->getSaveFile(-initialdir=>"D:/work/output",-initialfile => "$JOB.ME",);
	$file=encode('gb2312',$file);
	open (FH,'>',$file) or die $!;
	my $content=$text->get("1.0", "end");
	$content=encode('gb2312',$content);
	print FH $content;
	close FH;
	exit;
}



