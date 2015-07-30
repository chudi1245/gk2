#!/usr/bin/perl
##zq 20110.01.21
use strict;
use Win32;
use Genesis;
use FBI;
use Encode;
use Encode::CN;
use File::Path;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
###_________________________________
my ($ncset,$column,$row,$xscale,$yscale,@layer_drl,$layer_out,$encode,$result,$flage_scale,$flage_mirror)=($$,0,0,0,0,);
my (@prof_limits,%prof_center,$flage_tgz);
my $out_path="D:/work/output/";
if (not -d  $out_path) { File::Path::mkpath($out_path) or die $! };
###_______________________________________
kysy();
unit_set('inch');

my $ref=info("matrix","$JOB/matrix","row");
my @gROWcontext   =@{$ref->{gROWcontext}};
my @gROWlayer_type=@{$ref->{gROWlayer_type}};
my @gROWname      =@{$ref->{gROWname}};
foreach  (0..$#gROWname) {
	if ($gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] eq 'drill') {	push @layer_drl,$gROWname[$_];  }
}
@prof_limits=prof_limits($STEP);
$prof_center{x}=($prof_limits[2]+$prof_limits[0])/2;
$prof_center{y}=($prof_limits[3]+$prof_limits[1])/2;

###________________________________________
my $mw=MainWindow->new();  $mw->title("Better and better");  $mw->geometry("+200+100");
$mw->Label(-text=>'Drill-Layer',)->grid(-column=>$column,-row=>$row);
$mw->Optionmenu(-options =>\@layer_drl,-textvariable=>\$layer_out,-width=>6)->grid(-column=>++$column,-row=>$row);
$mw->Checkbutton(-text=>"Mirror",-variable =>\$flage_mirror,)->grid(-column=>++$column, -row=>$row,);
$mw->Checkbutton(-text=>"Scale",-variable =>\$flage_scale,-command=>\&dis_scale)->grid(-column=>++$column, -row=>$row,);
$mw->Label(-text=>'Scale_X')->grid(-column=>0,-row=>++$row);
my $engtry_scale_x=$mw->Entry(-textvariable=>\$xscale,-width=>10,-state=>'disabled')->grid(-column=>1,-row=>$row);
$mw->Label(-text=>'Scale_Y')->grid(-column=>2,-row=>$row);
my $engtry_scale_y=$mw->Entry(-textvariable=>\$yscale,-width=>10,-state=>'disabled')->grid(-column=>3,-row=>$row);
$mw->Button(-text=>'Out-path',-width=>10,-relief=>'g',-command=>\&choose_path,)->grid(-column=>0,-row=>++$row);
unless ($encode) {$encode="D:/work/output/"};
unless ($out_path) {$out_path="D:/work/output/"};
$mw->Label(-textvariable=>\$encode,-width=>20,-anchor=>'w')->grid(-column=>1,-row=>$row,-columnspan=>2);
$mw->Checkbutton(-text=>" => TGZ",-variable =>\$flage_tgz,)->grid(-column=>0, -row=>++$row,);
$mw->Label(-text=>'=='x20,-width=>40,-anchor=>'w')->grid(-column=>0,-row=>++$row,-columnspan=>4);
$mw->Button(-text=>'DO',-width=>20,-command=>\&apply)->grid(-column=>1,-row=>++$row,-columnspan=>2);
$mw->Label(-textvariable=>\$result,-width=>44,-anchor=>'w',-relief=>'g')->grid(-column=>0,-row=>++$row,-columnspan=>4);
MainLoop;
###_________________________________________
sub apply {
my $FH_state=open (FH, '>>', "$out_path/out_info.txt") or warn $!;
print FH "=========================== \n" if $FH_state;

#$f->COM ('save_job',job=>$JOB);

$result='';

$layer_out =~ m{drl(.*)}i;
my $name=$JOB.$1.'.drl';

$f->COM ('ncset_cur',job=>$JOB,step=>$STEP,layer=>$layer_out,ncset=>'');
$f->COM ('ncset_create',name=>$ncset);
$f->COM ('ncset_cur',job=>$JOB,step=>$STEP,layer=>$layer_out,ncset=>$ncset);

#p__("is there1 ");
$f->COM ('ncd_set_machine',machine=>'default_excellon',thickness=>100);
#p__("is there2 ");

$f->COM ('ncset_units',units=>'mm');
if ($flage_scale or $flage_mirror) {
	my $mirror;
	my $x=$xscale/10000+1;
	my $y=$yscale/10000+1;
	$flage_mirror ? ($mirror='yes') :( $mirror='no');
	$f->COM ('ncd_register',
		angle=>0,
		mirror=>$mirror,
		xoff=>1.5,
		yoff=>1.5,
		version=>1,
		xorigin=>1.5,
		yorigin=>1.5,
		xscale=>$x,
		yscale=>$y,
		xscale_o=>$prof_center{x},
		yscale_o=>$prof_center{y},);

print FH "JOB==>$JOB  layer==>$layer_out   x-scale==>$x  y-scale==>$y  mirror==>$mirror  name==>$name" if $FH_state;
}
$f->COM ('ncd_cre_drill');
$f->COM ('ncset_units',units=>'mm');
$f->COM ('ncd_ncf_export',
        stage   =>1,
		split   =>1,
		dir     =>$out_path,
		name    =>$name);

$result="$layer_out output to $out_path ok";

if ($flage_tgz){
	export_job($JOB,$out_path);
	#$tgz_info="$JOB.TGZ export to $encode";
	$mw->update();
}

$mw->update();
print FH "=========================== \n" if $FH_state;
close FH;

p__("ADM $layer_out output to $out_path ok ");

exit;

}###__________________________________________end sub apply



sub choose_path {
	$out_path=$mw->chooseDirectory(-initialdir => "D:/work/output/");
	$encode=decode("gbk",odd_decode($out_path)); 
	unless ($encode) {$encode="D:/work/output/"};
    unless ($out_path) {$out_path="D:/work/output/"};
}
sub dis_scale{
	if ($flage_scale) {
		$engtry_scale_x->configure(-state=>'normal');
		$engtry_scale_y->configure(-state=>'normal');
	}else{
		$engtry_scale_x->configure(-state=>'disabled');
		$engtry_scale_y->configure(-state=>'disabled');
	}
}
###____________________________________________________

=head


ncset_units,units=mm