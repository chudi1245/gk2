use strict;
use warnings;
my $class=\%main::layer_class;
my @layer_line=@{$main::layer_class{line}};
my @time=gmtime;

my ($year, $moon, $date)=($time[5]+1900, $time[4]+1, $time[3]);
my $fny=$main::SR_ymin - 0.40;

my ($single_word_width,$single_word_height,$w_factor,$fneg8x)=(0.05,0.09,0.8333333);

if ($main::tech_type =~ m/Thick_Cu/i) {
	$w_factor=1.3;
	$single_word_height=0.1;
	$single_word_width=0.065;
}

#********************************************************########
foreach  (0..$#layer_line){
	 my ($fny,$fnx, $mirror,$fn8)=($fny+0.135);  
	($layer_line[$_]=~ m/[tb]$/ig)?($fn8=''):($fn8='8888');

	my $text=uc "FN:$main::JOB $layer_line[$_] $main::use $year\/$moon\/$date $fn8";
	
	if ( $main::mirror[$_] eq 'M') {
		my $text_long=(length $text)*$single_word_width-0.01;	
		$mirror='yes'; 
		#$fnx=$main::grid{x}[4]-0.2 + $text_long;
		$fnx=$main::grid{x}[5] + $text_long;
		$fneg8x = $fnx;
	}else{
		$mirror='no';
		#$fnx=$main::grid{x}[4]-0.2;
		$fnx=$main::grid{x}[5];
	}
	 clear($layer_line[$_]); 
    add_fn($fnx,$fny,$text,$mirror,$w_factor);
###	p__(" $layer_line[$_],$fnx,$fny,$text,$mirror,$w_factor ");
	add_fn($fnx,$fny-0.09,"X:$main::x_scale[$_]%% Y:$main::y_scale[$_]%%",$mirror,$w_factor) if ($main::x_scale[$_] or $main::y_scale[$_]);
	}

#********************************************
	if ( exists $class->{inner}  ){
    my $neg8x = $fneg8x - 0.02 ;
    my $neg8y = $main::SR_ymin - 0.22;
    clear();
    affected_layer('yes', 'single', @{$class->{inner}}, );
    add_pad($neg8x,$neg8y,'neg8') ;
    clear();
 }

#********************************************
foreach  (0..$#main::gROWrow) {
	my ($fny,$fnx, $mirror)=($fny+0.135,);
	my $text=uc "FN:$main::JOB $main::gROWname[$_] $main::use $year\/$moon\/$date 8888";
    next unless ($main::gROWcontext[$_] eq 'board'  
		 and $main::gROWlayer_type[$_]  eq 'solder_mask' 
	     ||  $main::gROWlayer_type[$_]  eq 'solder_paste'
	     ||  $main::gROWlayer_type[$_]  eq 'silk_screen'
		 ||  $main::gROWlayer_type[$_]  eq 'document'
	);	
	if ( $main::gROWside[$_] eq 'bottom') {
    	my $text_long=(length $text)*$single_word_width-0.01;
	   	$mirror='yes'; 
	    $fnx=$main::grid{x}[5] + $text_long;
    }else{
	   	$mirror='no';
		$fnx=$main::grid{x}[5];
	}
		clear($main::gROWname[$_]);
		add_fn($fnx,$fny,$text,$mirror,$w_factor);

}  ##end foreach

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

1;
=head

#	if ($main::gROWlayer_type[$_] eq 'solder_mask') {
#		$fny +=0.135;
#		$fnx+=0.60;
#	}

##p__('text ok');
