#! /usr/bin/perl 
use strict;
use Win32;
use Tk::Pane;
use Genesis;
use FBI;
use encoding 'euc_cn';
##use Encode;
##use Encode::CN;
use File::Path; 
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();
###__________________________
unit_set('inch');

my (@gROWrow,@gROWside,@gROWcontext,@gROWlayer_type,@gROWname,@gROWtype,@prof_limits,%prof_center);
my ($flage_tgz,$out_path,$mw,$encode,$tgz_info,$value)=(1, "D:/work/output/");
my (%mirror,%button_mirror,%checkbutton_out,%checkbutton_value,%entry_scale_x,%entry_scale_y,%label_info,%scale_x,%scale_y,%out_info);
my ($column, $row,$number_set_all)=(0,0,0);
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
$franm->title("菲林输出");  
$franm->geometry("+200+100");
$mw=$franm->Scrolled("Frame", -scrollbars => 'w',-height=>600 )->pack();

my @head_text=('层次','全选','镜像','%%-x','%%-y');
foreach  (@head_text) {   $mw->Button(-text=>$_,-font=>[-size=>12],-width=>5,-command=>[\&set_all,$_])->grid(-column=>$column++, -row=>$row,)   };
$mw->Button(-text=>'路径',-width=>4,-font=>[-size=>12],-command=>\&choose_path,)->grid(-column=>++$column,-row=>$row,);
unless ($encode) {$encode="D:/work/output/"};
unless ($out_path) {$out_path="D:/work/output/"};
#*************************************	
my @layerName=undef;
my $scalefile="c:/genesis/fw/jobs/$JOB/output/scal.log";
	if (-e $scalefile ){
open (FILE,"c:/genesis/fw/jobs/$JOB/output/scal.log") or die "cant open file : $!";
@layerName=(<FILE>);
close FILE;	
		}

#*************************************
$mw->Label(-textvariable=>\$encode,-width=>16,-relief=>'groove')->grid(-column=>++$column, -row=>$row,);
#   p__("$_ $scale_x[$_] $scale_y{$_}");	
#
foreach  $_ (0..@gROWname) {
	        if ($gROWname[$_] ){  
		$mw->Label(-text=>$gROWname[$_],-font=>[-size=>12],-width=>20,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	    $checkbutton_out{$_}=$mw->Checkbutton(-variable=>\$checkbutton_value{$_})->grid(-column=>1, -row=>$row,);
	    $button_mirror{$_}=$mw->Button(-text=>"---",-command=>[\&set_mirror,$_],-width=>4,)->grid(-column=>2, -row=>$row,);
		$entry_scale_x{$_}=$mw->Entry(-textvariable=>\$scale_x{$_},-width=>7,)->grid(-column=>3, -row=>$row,);
		$entry_scale_y{$_}=$mw->Entry(-textvariable=>\$scale_y{$_},-width=>7,)->grid(-column=>4, -row=>$row,);
		if ($gROWside[$_] eq 'inner') {
			$entry_scale_x{$_}->configure(-background=>'green');
			$entry_scale_y{$_}->configure(-background=>'green');
		    }
	    }		
		$out_info{$_}='-'x20;
		$label_info{$_}=$mw->Label(-textvariable=>\$out_info{$_},-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>$row,);
}

$tgz_info='-'x20;
$mw->Label(-textvariable =>\$tgz_info,-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>++$row,);
##$franm->Button(-text=>"Set Ref",-command=>\&set_ref,-width=>6,)->pack(-side => 'left',);
##$franm->Button(-text=>"默认参数", -font=>[-size=>14],-command=>\&default,-width=>12,)->pack(-side => 'left');
##$franm->Button(-text=>"Brush",-command=>\&brush,-width=>8,)->pack(-side => 'left');
##$franm->Checkbutton(-text=>" => TGZ",-variable =>\$flage_tgz,)->pack(-side => 'left');
$franm->Button(-text=>"退出",-font=>[-size=>14],-command=>sub{exit},,-width=>12,)->pack(-side =>'left'); 
$franm->Button(-text=>"输出菲林",-font=>[-size=>14],-command=>\&out_put,-width=>16,)->pack(-side =>'right');

&scale();
##&brush();
MainLoop;

###______________________________________________

sub set_all {
	my $id=shift;
	$value=not $value;
	if ($id eq '全选') {
		foreach  (keys %checkbutton_value) {   $checkbutton_value{$_}=$value;	}
	}elsif ($id eq 'mirror'){
		foreach  (keys %button_mirror) {  $button_mirror{$_}->configure(-text=>"---");  }
	}elsif ($id eq '%%-x'){
		foreach  (keys %scale_x) {  $scale_x{$_}='';  }
	}elsif ($id eq '%%-y'){
		foreach  (keys %scale_y) {  $scale_y{$_}='';  }
	}

}
###________________________________________________________end set all

sub out_put {
	my $FH_state=open (FH, '>>', "$out_path/out_info.txt") or warn $!;
	print FH "=========================== \n" if $FH_state;
	
	
	$f->COM ('save_job',job=>$JOB);
	
	my ($mirror,$x,$y);
	foreach  (keys %checkbutton_value) {
		
			p__("1ok");
		if ($checkbutton_value{$_}) {
			p__("2ok");
			$mirror=$button_mirror{$_}->cget(-text);
			($mirror eq 'M')?($mirror='yes'):($mirror='no'); 
			$scale_x{$_} ? ($x=1+$scale_x{$_}/10000) : ($x=1);
			$scale_y{$_} ? ($y=1+$scale_y{$_}/10000) : ($y=1);
			
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
}

###___________________________________________________________end output

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
 }

sub default {
     foreach  (0..@gROWname) {
		if ($gROWname[$_] ){
		if (  $gROWlayer_type[$_] !~ m{solder_paste|document}  and  $gROWcontext[$_] eq 'board' ) {
		$checkbutton_value{$_}=1;
			}else{
				 $checkbutton_value{$_}=0;
			    }
		if( $gROWname[$_]eq"box" or $gROWname[$_]eq"drl"){
				 $checkbutton_value{$_}=0;
			 }	
		}
    }
}

###____________________________________________________________###ebd default
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

sub output_film {
	my $layer=shift;
	my $path=shift||'D:/work/output';
	my $mirror=shift||'no' ;
	my $x_scale=shift||1;
	my $y_scale=shift||1;
	my $x_anchor=shift||0;
	my $y_anchor=shift||0;
       my $angle=shift||0;
        my $whel=shift||'';
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
	   wheel=>$whel,
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


1;


=head
sub default {
     foreach  (0..@gROWname) {
		if ($gROWname[$_] ){
		open (FILE,"c:/genesis/fw/jobs/$JOB/output/scal.log") or die "cant open file : $!";
		my @layerName=(<FILE>);
		close FILE;
		my ($cen,$cenx,$ceny,$name);
		foreach $name(@layerName) {
		($cen,$cenx,$ceny)=split ' ', $name;
		    if ($cen eq $gROWname[$_]) {
			$scale_x{$_}=$cenx;
			$scale_y{$_}=$ceny;
		    }
	    }

		if (  $gROWlayer_type[$_] !~ m{solder_paste|document}  and  $gROWcontext[$_] eq 'board' ) {
		$checkbutton_value{$_}=1;
			}else{
				 $checkbutton_value{$_}=0;
			    }
		if( $gROWname[$_]eq"box" or $gROWname[$_]eq"drl"){
				 $checkbutton_value{$_}=0;
			 }	
		}
    }
}

###____________________________________________________________###ebd default



foreach  (0..@gROWname) {
	  if ($gROWname[$_] ){
				my ($cen,$cenx,$ceny,$name);
				foreach $name(@layerName) {($cen,$cenx,$ceny)=split ' ', $name;
				if ($cen eq $gROWname[$_]) {
				$scale_x{$_}=$cenx;
				$scale_y{$_}=$ceny;
                }
			    }


	  }
}

##	if ($flage_tgz){
##		export_job($JOB,$out_path);
##		$tgz_info="$JOB.TGZ export to $encode";
##		$mw->update();
##	}

foreach  $_ (0..@gROWname) {
		
	    if ($gROWname[$_] ){  

 ##$mw->Entry(-textvariable=>\$value,-font =>[-size => 14], -width=>6)   ->grid(-column=>1,-row=>0)->focus;
    
		$mw->Label(-text=>$gROWname[$_],-font=>[-size=>12],-width=>20,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	    $checkbutton_out{$_}=$mw->Checkbutton(-variable=>\$checkbutton_value{$_})->grid(-column=>1, -row=>$row,);
	    $button_mirror{$_}=$mw->Button(-text=>"---",-command=>[\&set_mirror,$_],-width=>4,)->grid(-column=>2, -row=>$row,);
		$entry_scale_x{$_}=$mw->Entry(-textvariable=>\$scale_x{$_},-width=>7,)->grid(-column=>3, -row=>$row,);
		$entry_scale_y{$_}=$mw->Entry(-textvariable=>\$scale_y{$_},-width=>7,)->grid(-column=>4, -row=>$row,);
		
		if ($gROWside[$_] eq 'inner') {
			$entry_scale_x{$_}->configure(-background=>'green');
			$entry_scale_y{$_}->configure(-background=>'green');
		    }
	    }		
		$out_info{$_}='-'x20;
		$label_info{$_}=$mw->Label(-textvariable=>\$out_info{$_},-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>$row,);
}


foreach  $_ (0..@gROWname) {
	my ($cen,$cenx,$ceny,$name,$sca_x,$sca_y);	
	    if ($gROWname[$_] ){  
		
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











