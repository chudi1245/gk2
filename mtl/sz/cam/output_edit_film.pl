#! /usr/bin/perl 
use strict;
use Tk;
use Win32;
use Tk::Pane;
use Genesis;
use FBI;
use Encode;
use Encode::CN;
use File::Path; 
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________
kysy();
unit_set('inch');

my (@gROWrow,@gROWside,@gROWcontext,@gROWlayer_type,@gROWname,@gROWtype,@prof_limits,%prof_center);
my ($flage_tgz,$out_path,$mw,$encode,$tgz_info,$value)=(1, "D:/work/output/");
my (%mirror,%button_mirror,%checkbutton_out,%checkbutton_value,%entry_scale_x,%entry_scale_y,%scale_x,%scale_y,%button_scalxy,%label_info,%out_info);
my ($column, $row,$number_set_all,$inner_num)=(0,0,0);
@gROWname      =@{info("matrix","$JOB/matrix","row")->{gROWname}};
@gROWlayer_type=@{info("matrix","$JOB/matrix","row")->{gROWlayer_type}};
@gROWcontext   =@{info("matrix","$JOB/matrix","row")->{gROWcontext}};
@gROWside      =@{info("matrix","$JOB/matrix","row")->{gROWside}};
@prof_limits=prof_limits($STEP);
$prof_center{x}=($prof_limits[2]+$prof_limits[0])/2;
$prof_center{y}=($prof_limits[3]+$prof_limits[1])/2;
if (not -d  $out_path) { File::Path::mkpath($out_path) or die $! }
###______________________
my $franm=MainWindow->new;
$franm->title("Better and better");   $franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>600 )->pack();
###定义列的变量。
my $cenname = "层名";
$cenname=decode("cp936",$cenname);
my $mirrorc = "镜像";
$mirrorc=decode("cp936",$mirrorc);
my $pathNmae = "路径";
$pathNmae=decode("cp936",$pathNmae);
my $edit = "修改";
$edit=decode("cp936",$edit);

$mw->Label(-text=>$cenname,  -width=>5,-font=>[-size=>12],)->grid(-column=>$column++, -row=>$row,); 
$mw->Button(-text=>'all',    -width=>5,-font=>[-size=>12],-command=>\&set_all,)->grid(-column=>$column++, -row=>$row,); 
$mw->Label(-text=>$mirrorc,  -width=>5,-font=>[-size=>12],)->grid(-column=>$column++, -row=>$row,); 
$mw->Label(-text=>'%%-x',    -width=>5,-font=>[-size=>12],)->grid(-column=>$column++, -row=>$row,);
$mw->Label(-text=>'%%-y',    -width=>5,-font=>[-size=>12],)->grid(-column=>$column++, -row=>$row,); 
$mw->Button(-text=>$pathNmae,-width=>5,-font=>[-size=>12],-command=>\&choose_path,)->grid(-column=>$column++,-row=>$row,);

unless ($encode) {$encode="D:/work/output/"};
unless ($out_path) {$out_path="D:/work/output/"};

my @layerName=undef;
my $scalefile="c:/genesis/fw/jobs/$JOB/output/scal.log";
if (-e $scalefile ){
	open (FILE,"c:/genesis/fw/jobs/$JOB/output/scal.log") or die "cant open file : $!";
	@layerName=(<FILE>);
	close FILE;	
}

$mw->Label(-textvariable=>\$encode,-width=>16,-font=>[-size=>12],-relief=>'groove')->grid(-column=>++$column, -row=>$row,);

foreach  (0..@gROWname) {
if ($gROWname[$_] ){
	$out_info{$_}='-'x36;
	$mw->Label(-text=>$gROWname[$_],-font=>[-size=>12],-width=>10,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	$checkbutton_out{$_}=$mw->Checkbutton(-variable=>\$checkbutton_value{$_})->grid(-column=>1, -row=>$row,);  
    $button_mirror{$_}=$mw->Button(-text=>"---",-command=>[\&set_mirror,$_],-width=>4,)->grid(-column=>2, -row=>$row,);
	$entry_scale_x{$_}=$mw->Entry(-textvariable=>\$scale_x{$_},-state =>'disable',-width=>7,)->grid(-column=>3, -row=>$row,);
	$entry_scale_y{$_}=$mw->Entry(-textvariable=>\$scale_y{$_},-state =>'disable',-width=>7,)->grid(-column=>4, -row=>$row,);
	$button_scalxy{$_}=$mw->Button(-text=>$edit,-command=>[\&set_scale,$_],-font=>[-size=>10],-width=>5,)->grid(-column=>5, -row=>$row,);
	$label_info{$_}=$mw->Label(-textvariable=>\$out_info{$_},-font=>[-size=>12],-width=>40,-anchor=>'w')->grid(-column=>6,-columnspan=>8, -row=>$row,);
	if($gROWside[$_] eq 'inner') {
	$entry_scale_x{$_}->configure(-background=>'green');
	$entry_scale_y{$_}->configure(-background=>'green');
	}
	if ($gROWname[$_] =~m/l2[tb]/ig) {$inner_num=$_;}	
	}
}
$tgz_info='-'x20;

#-columnspan=>6,
#$mw->Label(-textvariable =>\$tgz_info,-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>++$row,);
#$franm->Button(-text=>"Set Ref",-command=>\&set_ref,-width=>6,)->pack(-side => 'left',);

my $quitp = "退出";
$quitp=decode("cp936",$quitp);

my $defaultp = "默认";
$defaultp=decode("cp936",$defaultp);

my $outputp = "输出";
$outputp=decode("cp936",$outputp);

my $samecle= "缩放相同";
$samecle=decode("cp936",$samecle);

$franm->Button(-text=>$quitp,   -font=>[-size=>12],-command=>sub{exit},-width=>10,)->pack(-side =>'left'); 
$franm->Button(-text=>$defaultp,-font=>[-size=>12],-command=>\&default,-width=>10,)->pack(-side => 'left');
if ($inner_num!=0) {
$franm->Button(-text=>$samecle, -font=>[-size=>12],-command=>\&same_scale,-width=>18,)->pack(-side => 'left' );
}
$franm->Button(-text=>$outputp, -font=>[-size=>12],-command=>\&out_put,-width=>18,)->pack(-side => 'right');
#$franm->Button(-text=>"Brush",-command=>\&brush,-width=>8,)->pack(-side => 'left');
#$franm->Checkbutton(-text=>" => TGZ",-variable =>\$flage_tgz,)->pack(-side => 'left');
&brush();
&scale();
MainLoop;

###________________________________________________
#sub set_mirror{
#	my $id=shift;
#	($button_mirror{$id}->cget(-text)  eq  '---' ) ? ( $button_mirror{$id}->configure(-text=>'M') ) : ( $button_mirror{$id}->configure(-text=>'---') ) ;
#
#}
sub set_scale{
my $flag=shift;
$scale_x{$flag}=' ';
$scale_y{$flag}=' ';
$entry_scale_x{$flag}=$mw->Entry(-textvariable=>\$scale_x{$flag},-width=>7,)->grid(-column=>3, -row=>$flag+1,);
$entry_scale_y{$flag}=$mw->Entry(-textvariable=>\$scale_y{$flag},-width=>7,)->grid(-column=>4, -row=>$flag+1,);
	
}

sub same_scale {
foreach  (0..@gROWname) {
if ($gROWside[$_] eq 'inner') {
	$scale_x{$_}=$scale_x{$inner_num};
	$scale_y{$_}=$scale_y{$inner_num};
}
}
}

sub set_all {
	$value=not $value;
	foreach  (keys %checkbutton_value) { 
			  $checkbutton_value{$_}=$value;	
	}
}
###________________________________________________________end set all

sub scale {
   foreach  (0..@gROWname) {
	if ($gROWname[$_] ){
		my ($cen,$cenx,$ceny,$name);
		if (@layerName!=undef) {
		  foreach $name(@layerName) {
		  ($cen,$cenx,$ceny)=split ' ', $name;
		    if ($cen eq $gROWname[$_]) {
				$scale_x{$_}=$cenx;
				$scale_y{$_}=$ceny;
		    }
	      }
		}
     }
   }
 }###________________________________________________________end scale

sub out_put {
	my $FH_state=open (FH, '>>', "$out_path/out_info.txt") or warn $!;
	print FH "=========================== \n" if $FH_state;

	$f->COM ('save_job',job=>$JOB);
	my ($mirror,$x,$y);
	foreach  (keys %checkbutton_value) {
		if ($checkbutton_value{$_}) {
			$mirror=$button_mirror{$_}->cget(-text);
			($mirror eq 'M')?($mirror='yes'):($mirror='no'); 
			$scale_x{$_} ? ($x=1+$scale_x{$_}/10000) : ($x=1.0000);
			$scale_y{$_} ? ($y=1+$scale_y{$_}/10000) : ($y=1.0000);
		    output_cen($gROWname[$_],$out_path,$mirror,$x,$y,$prof_center{x},$prof_center{y});
			print FH "JOB==>$JOB   name==>$gROWname[$_]     x-scale==>$x    y-xcale==>$y    mirror==>$mirror \n" if $FH_state;
			
			$out_info{$_}="$gROWname[$_] $mirror $x $y $encode";
			
			$mw->update();
		}
	}

#	if ($flage_tgz){
#		export_job($JOB,$out_path);
#		$tgz_info="$JOB.TGZ export to $encode";
#		$mw->update();
#	}

	print FH "=========================== \n" if $FH_state;
	close FH;
	exit;
}###___________________________________________________________end output

###___________________________________
sub output_cen {
	my $layer=shift;
	my $path=shift||'D:/work/output';
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
#********************************************
sub default {
     foreach  (0..@gROWname) {
		if ($gROWname[$_] ){
		if (  $gROWlayer_type[$_] !~ m{solder_paste|document}  and  $gROWcontext[$_] eq 'board' ) {
		$checkbutton_value{$_}=1;
			}else{
				 $checkbutton_value{$_}=0;
			    }
		if( $gROWlayer_type[$_] eq 'rout' or $gROWlayer_type[$_] eq 'drill'  ){
				 $checkbutton_value{$_}=0;
			 }	
		}
    }
}
###____________________________________________________________###end default
sub choose_path {
	$out_path=$mw->chooseDirectory(-initialdir => "D:/work/output/");
	$encode=decode("gbk",odd_decode($out_path)); 
	unless ($encode) {$encode="D:/work/output/"};
    unless ($out_path) {$out_path="D:/work/output/"}
}

sub brush {
foreach  (0..@gROWname) {
    if ($gROWname[$_] ){
	    $scale_x{$_}='';
	    $scale_y{$_}='';
        $button_mirror{$_}->configure(-text=>"---");
        $checkbutton_value{$_}=0;
	}
}
}

1;
