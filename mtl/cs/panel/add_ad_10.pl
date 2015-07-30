use strict;
use warnings;

my $class=\%main::layer_class;
my @layer_line=@{$main::layer_class{line}};

my (@layer_solder,@layer_silk);
if ( exists $class->{solder_mask}  ){@layer_solder = @{$class->{solder_mask}};}

if ( exists $class->{silk_screen}  ){@layer_silk   = @{$class->{silk_screen}};}


my @adname = (@layer_line,@layer_solder,@layer_silk);

my $adx=$main::SR_xmax + 0.27;

###__________________________________$name =~ m/ts/i
foreach  (0..$#adname){
	my ($ady, $mirror,$angle);
	my $text=uc "ABCD-1234567890";
	
	if ( $adname[$_] =~m/t/i) {

		$mirror='no';
		$ady=$main::grid{y}[11] ;
		$angle = 270;
	}
	else{ my $text_long=(length $text)*0.1;
		$mirror='yes'; 
		$ady=$main::grid{y}[11]+$text_long-0.03 ;	
		$angle = 90;
	}
	
	clear($adname[$_]);
	add_ad10 ($adx,$ady,$text,$mirror,$angle,);
}

sub add_ad10{
	my $x=shift;
	my $y=shift;
	my $text=shift;
	my $mirror=shift||'no';
	my $angle=shift;
	$main::f->COM('add_text',
	 attributes=>'no',
	 type=>'string',
	 x=>$x,
	 y=>$y,
     text=>$text,
	 x_size=>0.10,
	 y_size=>0.08,  
	 w_factor=>0.85,
     polarity=>'positive',
	 angle=>$angle,
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

