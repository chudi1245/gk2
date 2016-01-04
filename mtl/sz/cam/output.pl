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

my $layernum = getlayernum();
my @linelayer;


if ($STEP eq 'pnl') {

#检查是否进行层比对，然后再输出Gerber
if ( exists_layer('gtl')  eq  'yes' ) {
	my %layer;
	my $comfile = "c:/genesis/fw/jobs/$JOB/output/compare.log";
	if (-e $comfile) {
		open (FILE,"$comfile");
		my $result = (<FILE>);
		close FILE;
	    my @layers = split ' ',$result;
		foreach my $cen (@layers) {
			$layer{$cen} +=1;
		}
		
		#my $falgLayer = 1;
		foreach  (@linelayer) {
			if (not exists $layer{$_}  ) {
				p__("$_ is not Compare,Don't forget Compare $_ ");
			    exit;
			}
		}
	}else{
		p__("please run layer compare, ");
		exit; 
	}
}

#检查是否存在开短路，再输出。
if ( exists_layer('gtl')  eq  'yes' ) {

	my $filepath = "c:/genesis/fw/jobs/$JOB/output/net.log";
	if (-e $filepath) {
		open (FILE,"$filepath");
		my $result = (<FILE>);
		close FILE;
		my @result=split ' ',$result;
		if ($result[0]!=0 || $result[1]!=0 ) {
			p__("please make sure that the net is no problem ");
			exit;
		}
	}else{
		p__("please operation network analysis before output data ");
		exit; 
	}
} 

##先输出CY，再输出Gerber
if ($layernum > 2) {
	my $cyflag = "c:/genesis/fw/jobs/$JOB/output/cy.log";
	if (not -e $cyflag){
	p__("Please Output CY, then output GERBER");
	exit;
	}
}


}

$f->COM ('save_job',job=>$JOB);

my (@gROWrow,@gROWside,@gROWcontext,@gROWlayer_type,@gROWname,@gROWtype,@prof_limits,%prof_center);
my ($flage_tgz,$out_path,$mw,$encode,$tgz_info,$value)=(1, "D:/work/output/");
my (%mirror,%button_mirror,%checkbutton_out,%checkbutton_value,%entry_scale_x,%entry_scale_y,%scale_x,%scale_y,%label_info,%out_info);
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

my @head_text=('layer','out','mirror','%%-x','%%-y');
foreach  (@head_text) {   $mw->Button(-text=>$_,-width=>5,-command=>[\&set_all,$_])->grid(-column=>$column++, -row=>$row,)   };

$mw->Button(-text=>'Path',-width=>4,-command=>\&choose_path,)->grid(-column=>++$column,-row=>$row,);

unless ($encode) {$encode="D:/work/output/"};
unless ($out_path) {$out_path="D:/work/output/"};

$mw->Label(-textvariable=>\$encode,-width=>16,-relief=>'groove')->grid(-column=>++$column, -row=>$row,);
foreach  (0..@gROWname) {
	if ($gROWname[$_] ){
	    $mw->Label(-text=>$gROWname[$_],-width=>20,-anchor=>'c')->grid(-column=>0, -row=>++$row,);
	    $checkbutton_out{$_}=$mw->Checkbutton(-variable=>\$checkbutton_value{$_})->grid(-column=>1, -row=>$row,);
	    $button_mirror{$_}=$mw->Button(-text=>"---",-command=>[\&set_mirror,$_],-width=>4,)->grid(-column=>2, -row=>$row,);
		$entry_scale_x{$_}=$mw->Entry(-textvariable=>\$scale_x{$_},-width=>7,)->grid(-column=>3, -row=>$row,);
		$entry_scale_y{$_}=$mw->Entry(-textvariable=>\$scale_y{$_},-width=>7,)->grid(-column=>4, -row=>$row,);
		
		if ($gROWside[$_] eq 'inner') {
			$entry_scale_x{$_}->configure(-background=>'green');
			$entry_scale_y{$_}->configure(-background=>'green');
		}
		
		$out_info{$_}='-'x20;
		$label_info{$_}=$mw->Label(-textvariable=>\$out_info{$_},-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>$row,);
		
		if ($gROWname[$_] =~m/l2[tb]/ig) {
        $inner_num=$_;
		$mw->Button(-text=>'same',-font=>[-size=>12],-width=>6,-command=>\&same_scale)->grid(-column=>6, -row=>$inner_num+1);
		}	
	}
}
$tgz_info='-'x20;
$mw->Label(-textvariable =>\$tgz_info,-width=>22,-anchor=>'w')->grid(-column=>5,-columnspan=>5, -row=>++$row,);

##$franm->Button(-text=>"Set Ref",-command=>\&set_ref,-width=>6,)->pack(-side => 'left',);
$franm->Button(-text=>"Defualt",-command=>\&default,-width=>8,)->pack(-side => 'left');
$franm->Button(-text=>"Brush",-command=>\&brush,-width=>8,)->pack(-side => 'left');
$franm->Checkbutton(-text=>" => TGZ",-variable =>\$flage_tgz,)->pack(-side => 'left');
$franm->Button(-text=>"OK OUTPUT",-command=>\&out_put,-width=>15,)->pack(-side => 'left');
$franm->Button(-text=>"EXIT",-command=>sub{exit})->pack(-side =>'right'); 

&brush();
MainLoop;

###________________________________________________
#sub set_mirror{
#	my $id=shift;
#	($button_mirror{$id}->cget(-text)  eq  '---' ) ? ( $button_mirror{$id}->configure(-text=>'M') ) : ( $button_mirror{$id}->configure(-text=>'---') ) ;
#
#}

sub same_scale {
	foreach  (0..@gROWname) {
		if ($gROWside[$_] eq 'inner') {
			$scale_x{$_}=$scale_x{$inner_num};
			$scale_y{$_}=$scale_y{$inner_num};
		}
	}
}

sub set_all {
	my $id=shift;
	$value=not $value;
	if ($id eq 'out') {
		foreach  (keys %checkbutton_value) {   $checkbutton_value{$_}=$value;	}
	}elsif ($id eq 'mirror'){
		foreach  (keys %button_mirror) {  $button_mirror{$_}->configure(-text=>"---");  }
	}elsif ($id eq '%%-x'){
		foreach  (keys %scale_x) {  $scale_x{$_}='';  }
	}elsif ($id eq '%%-y'){
		foreach  (keys %scale_y) {  $scale_y{$_}='';  }
	}

}###________________________________________________________end set all
sub out_put {
	my $FH_state=open (FH, '>>', "$out_path/out_info.txt") or warn $!;
	print FH "=========================== \n" if $FH_state;
  ##$f->COM ('save_job',job=>$JOB);
	my ($mirror,$x,$y);
	foreach  (keys %checkbutton_value) {
		if ($checkbutton_value{$_}) {
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
	if ($flage_tgz){
		my $ignoreHooksFile = "$ENV{GENESIS_TMP}/ignoreHooks";
		open OUT,">$ignoreHooksFile";
		close OUT;
		export_tgz($JOB,$out_path);
		unlink("$ignoreHooksFile");
		$tgz_info="$JOB.TGZ export to $encode";
		$mw->update();
	}

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
sub export_tgz {
    my $job=shift || $JOB;
    my $path=shift || 'D:/work/output';
    $f->COM ('export_job',
		job       =>$job,
		path      =>$path,
		mode      =>'tar_gzip',
		submode   =>'partial',
		steps_mode=>'exclude',
		steps     =>'orig_net\;pcb_net',
		overwrite =>'yes');
}

sub default {
foreach  (0..@gROWname) {
if ($gROWname[$_] ){
	$scale_x{$_}='';
	$scale_y{$_}='';
	if (  $gROWlayer_type[$_] !~ m{solder_paste|document}  and  $gROWcontext[$_] eq 'board'  or  $gROWname[$_] =~ m{cy}i ) {
		$checkbutton_value{$_}=1;
	}else{
		$checkbutton_value{$_}=0;
	}
}
}
}###____________________________________________________________###ebd default
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




sub getlayernum{
	my $layer_number=0;
	my $info_ref=info('matrix',"$JOB/matrix",'row');
	my @gROWname      =@{$info_ref->{gROWname}};
	my @gROWrow       =@{$info_ref->{gROWrow}};
	my @gROWcontext   =@{$info_ref->{gROWcontext}};
	my @gROWlayer_type=@{$info_ref->{gROWlayer_type}};
	foreach  (0..$#gROWrow) {
		if ($gROWcontext[$_] eq 'board'){
			if ($gROWlayer_type[$_] eq 'signal' or $gROWlayer_type[$_] eq 'power_ground' or $gROWlayer_type[$_] eq 'mixed') {
				$layer_number++;
				push @linelayer,$gROWname[$_];
			}
		}
	}
	return $layer_number;
}


1;






=head
sub set_ref{
	my $print_silk_layer='gtl gbl gto gbo ref_t ref_b ref-t ref-b';
    foreach  (keys %checkbutton_value) {
		$scale_x{$_}='';
		$scale_y{$_}='';
		if ($print_silk_layer =~ m/$gROWname[$_]/){
			$checkbutton_value{$_}=1;
			###($gROWname[$_] =~ m/.+[Bb]/)?($button_mirror{$_}->configure(-text=>"M")):($button_mirror{$_}->configure(-text=>"---"));
		}else{
			$checkbutton_value{$_}=0;
			###$button_mirror{$_}->configure(-text=>"---");
		}
	}
}####___________________________________________________________end set_ref


sub adjust {
	my $widget=shift;
	my $value=shift;
	my $event=$widget->XEvent;
	my $keysym =$event->K;
	if ($keysym eq 'F9') {
		$$value++;
	}elsif($keysym eq '0'){
		$$value-- if  $$value>0;	
	}
}

 $gROWlayer_type[$_] ne 'solder_paste' and  $gROWlayer_type[$_] ne 'document'   

###($gROWname[$_] =~ m/.+[Bb]/)?($button_mirror{$_}->configure(-text=>"M")):($button_mirror{$_}->configure(-text=>"---"));

		###$button_mirror{$_}->configure(-text=>"---");

COM output_layer_reset
COM output_layer_set,layer=gpt,angle=0,mirror=no,x_scale=1,y_scale=1,comp=0,polarity=positive,setupfile=,setupfiletmp=,line_units=inch,gscl_file=
COM output_layer_set,layer=gto,angle=0,mirror=no,x_scale=1,y_scale=1,comp=0,polarity=positive,setupfile=,setupfiletmp=,line_units=inch,gscl_file=
COM output_layer_set,layer=gts,angle=0,mirror=no,x_scale=1,y_scale=1,comp=0,polarity=positive,setupfile=,setupfiletmp=,line_units=inch,gscl_file=
COM output,job=m36888,step=pcb,format=Gerber274x,dir_path=D:/work,prefix=,suffix=.gbx,break_sr=yes,break_symbols=yes,break_arc=yes,scale_mode=all,surface_mode=fill,min_brush=1,units=inch,coordinates=absolute,zeroes=none,nf1=2,nf2=4,x_anchor=0,y_anchor=0,wheel=,x_offset=0,y_offset=0,line_units=inch,override_online=yes,film_size_cross_scan=0,film_size_along_scan=0,ds_model=RG6500
COM disp_on
COM origin_on
2012-09-29

#$f->INFO( entity_type => 'job',
#          entity_path => "$JOB",
#            data_type => 'IS_CHANGED');

#if ($f->{doinfo}{gIS_CHANGED} eq 'yes') {
#	$f->PAUSE("You have changed the job!");
#	$f->COM ('save_job',job=>$JOB);
#	exit;
#}
##c:/genesis/fw/lib/output/$JOB.net

if ( exists_layer('gtl')  eq  'yes' ) {

	my $filepath = "c:/genesis/fw/lib/output/$JOB.net";
	if (-e $filepath) {
		open (FILE,"$filepath");
		my $result = (<FILE>);
		close FILE;
		my @result=split ' ',$result;
		if ($result[0]!=0 || $result[1]!=0 ) {
			p__("please make sure that the net is no problem ");
			exit;
		}
	}else{
		p__("please operation network analysis before output data ");
		exit; 
	}
} 
