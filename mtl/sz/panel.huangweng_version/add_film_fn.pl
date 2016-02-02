use strict;
use warnings;
my @layer_line=@{$main::layer_class{line}};
my @time=gmtime;
my ($year, $moon, $date)=($time[5]+1900, $time[4]+1, $time[3]);

my $off_y=0.3;
my $fny=$main::SR_ymin - $off_y;
my ($single_word_width,$single_word_height,$w_factor)=(0.05,0.09,0.8333333);

if ($main::tech_type =~ m/Thick_Cu/i) {
	$w_factor=1.3;
	$single_word_height=0.1;
	$single_word_width=0.065;
}

my $version = "";
if ($main::FN_Version) {
    $version = "-"."$main::FN_Version";
}

###__________________________________/$Customer_code\$FN_Version
foreach  (0..$#layer_line){
	my ($fny,$fnx, $mirror)=($fny+0.135);
	my $text=uc "FN:$main::JOB $layer_line[$_]$version $main::use $year\/$moon\/$date 8888 $main::Customer_code";
	if ( $main::mirror[$_] eq 'M') {
		my $text_long=(length $text)*$single_word_width-0.01;
		$mirror='yes'; 
		$fnx=$main::SR_xmin + 0.6 + $text_long;
	}else{
		$mirror='no';
		$fnx=$main::SR_xmin +0.6;
	}
	##$fny +=0.135;
	##$fnx+=0.60;
	clear($layer_line[$_]);
	add_fn($fnx,$fny,$text,$mirror,$w_factor);
	add_fn($fnx,$fny-0.09,"X:$main::x_scale[$_]%% Y:$main::y_scale[$_]%%",$mirror,$w_factor) if ($main::x_scale[$_] or $main::y_scale[$_]);
}

foreach  (0..$#main::gROWrow) {
	my ($fny,$fnx, $mirror)=($fny,);
	my $text=uc "FN:$main::JOB $main::gROWname[$_]$version $main::use $year\/$moon\/$date 8888 $main::Customer_code";
    next unless ($main::gROWcontext[$_] eq 'board'  
		 and $main::gROWlayer_type[$_]  eq 'solder_mask' 
##	     ||  $main::gROWlayer_type[$_]  eq 'solder_paste'
	     ||  $main::gROWlayer_type[$_]  eq 'silk_screen'
##		 ||  $main::gROWlayer_type[$_]  eq 'document'
	);
	
	if ( $main::gROWside[$_] eq 'bottom') {
    	my $text_long=(length $text)*$single_word_width-0.01;
	   	$mirror='yes'; 
	    $fnx=$main::SR_xmin + $text_long;
    }else{
	   	$mirror='no';
		$fnx=$main::SR_xmin;
	}

	if ($main::gROWlayer_type[$_] eq 'solder_mask') {
		$fny +=0.135;
		$fnx+=0.60;
	}

	clear($main::gROWname[$_]);
	add_fn($fnx,$fny,$text,$mirror,$w_factor);

}##end foreach 


sub add_fn{
	my $x=shift;
	my $y=shift;
	my $text=shift;
	my $mirror=shift||'no';
	my $w_factor=shift||$w_factor;
	my $x_size=shift||$single_word_width;
	my $y_size=shift||$single_word_height;

	$main::f->COM('add_text',
	 attributes=>'no',
	 type=>'string',
	 x=>$x,
	 y=>$y,
     text=>$text,
	 x_size=>$x_size,
	 y_size=>$y_size,  
	 w_factor=>$w_factor,
     polarity=>'positive',
	 angle=>0,
	 mirror=>$mirror,
	 fontname=>'standard',
	 bar_type=>'UPC39',
     bar_char_set=>'full_ascii',
	 bar_checksum=>'no',
	 bar_background=>'yes',
	 bar_add_string=>'yes',
     bar_add_string_pos=>'top',
	 bar_width=>0.008,
	 bar_height=>0.2,
	 ver=>1);
}

clear();
##p__('text ok');
1;
=head


#p__('test 1');
my @time=gmtime;
my $year=$time[5]+1990;
my $moon=$time[4]+1;
my $date=$time[3];
my ($fny,$fnx,$mirror,$layer_name,$job,$length)=($gSR_LIMITSymin -0.3);
###__________________________________
foreach  (0..$#gROWrow) {
    if ( $gROWcontext[$_] eq 'board' and $gROWlayer_type[$_] ne 'drill' and $gROWlayer_type[$_] ne 'rout' and $gROWlayer_type[$_] ne 'solder_paste' ) {	
		$layer_name=uc $gROWname[$_]; 
		$job=uc $JOB;
		$length=$job.$user.$gROWname[$_];
		$length=length $length;
		$length=($length+21)*0.040;
###__________________________________
		if ($gROWside[$_] eq 'top') {
			$fnx=$gSR_LIMITSxmin;
			$mirror='no'
		}elsif($gROWside[$_] eq 'bottom'){
			$fnx=$gSR_LIMITSxmin + $length;
			$mirror='yes'
		}elsif($gROWside[$_] eq 'inner'){
			if ($_ % 2) {
			    $fnx=$gSR_LIMITSxmin;
			    $mirror='no'
			}else{
			    $fnx=$gSR_LIMITSxmin + $length;
			    $mirror='yes'
			}
		}
###__________________________________
clear($gROWname[$_]);
$f->COM('add_text',
	 attributes=>'no',
	 type=>'string',
	 x=>$fnx,
	 y=>$fny,
     text=>"FN:$job $layer_name $user $year\/$moon\/$date 8888",
	 x_size=>0.04,
	 y_size=>0.08,
	 w_factor=>0.8333333135,
     polarity=>'positive',
	 angle=>0,
	 mirror=>$mirror,
	 fontname=>'standard',
	 bar_type=>'UPC39',
     bar_char_set=>'full_ascii',
	 bar_checksum=>'no',
	 bar_background=>'yes',
	 bar_add_string=>'yes',
     bar_add_string_pos=>'top',
	 bar_width=>0.008,
	 bar_height=>0.2,
	 ver=>1);
	}
}
#p__("fn ok");
1;
=head
#######################################################################################################
foreach i ($gROWrow)
set fny = `echo "scale=10;$gSR_LIMITSymin -0.3" | bc`
set date = `date +%Y/%m/%d`
set filename = `echo FN:$job $gROWname[$i] $usename $date '8888' | tr '[a-z]' '[A-Z]'`
set fnc = `echo $filename | wc -c`
set fnlong = `echo "scale=10;($fnc-1)*0.04" | bc`
########
if ( $gROWcontext[$i] == 'board' && $gROWlayer_type[$i] != 'drill' && $gROWlayer_type[$i] != 'rout' && $gROWlayer_type[$i] != 'solder_paste' ) then
switch ($gROWside[$i])
case top:
set mirr = no
set fnx = `echo "scale=10;$gSR_LIMITSxmin" | bc`
breaksw
case bottom:
set mirr = yes
set fnx = `echo "scale=10;$gSR_LIMITSxmin + $fnlong" | bc`
breaksw
case inner:
if ( $gROWfoil_side[$i] == bottom ) then
set mirr = yes
set fnx = `echo "scale=10;$gSR_LIMITSxmin + $fnlong" | bc`
else 
set mirr = no
set fnx = `echo "scale=10;$gSR_LIMITSxmin" | bc`
endif
breaksw
endsw
###################################
COM affected_layer,name=$gROWname[$i],mode=single,affected=yes
COM add_text,attributes=no,type=string,x=$fnx,y=$fny,\
text=$filename,x_size=0.04,y_size=0.08,w_factor=0.8333333135,\
polarity=positive,angle=0,mirror=$mirr,fontname=mtl,bar_type=UPC39,\
bar_char_set=full_ascii,bar_checksum=no,bar_background=yes,bar_add_string=yes,\
bar_add_string_pos=top,bar_width=0.008,bar_height=0.2,ver=1
clear
endif
end
##################################

    next unless ($main::gROWcontext[$_] eq 'board'  
		 and $main::gROWlayer_type[$_]  eq 'solder_mask' 
	     ||  $main::gROWlayer_type[$_]  eq 'solder_paste'
	     ||  $main::gROWlayer_type[$_]  eq 'silk_screen'
		 ||  $main::gROWlayer_type[$_]  eq 'document'
	);



COM add_text,attributes=no,
type=string,
x=2.163699311,
y=2.0919609252,
text=A,

x_size=0.2,

y_size=0.2,

w_factor=1,polarity=positive,angle=0,mirror=no,fontname=standard,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=yes,bar_add_string_pos=top,bar_width=0.008,bar_height=0.2,ver=1







