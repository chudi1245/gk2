use strict;
use warnings;
goto LABEL_INNER_BOOK_END if ($main::layer_number < 2);
my %grid=%main::grid;
my $laynum = $main::layer_number;
my @layer_line=@{$main::layer_class{line}};
my ($box_origx,$box_origy,) = ($main::SR_xmax+0.18,$grid{y}[5] -0.4);
my ($text_origx,$text_origy,) =($box_origx-0.062,$box_origy+0.049,);

foreach  (1..$laynum) {		
		affected_layer('yes', 'single', @layer_line );
		add_pad($box_origx, $box_origy, 's120', 'no', 0, 'yes','negative' );
		add_pad($box_origx, $box_origy, 'donut_s160x140', 'no', 0, 'yes' );
		$box_origy = $box_origy -0.15;

}

my $sizex;
foreach  (1..$laynum) {	
	if ($_ < 10) {
		$sizex = 0.14;
		clear($layer_line[$_-1]);
		add_layer_text($text_origx, $text_origy, $_,$sizex,);

	} else {
		$sizex = 0.07;
		clear($layer_line[$_-1]);
		add_layer_text($text_origx, $text_origy+0.017, $_,$sizex,);
			
		}	
		$text_origy = $text_origy -0.15;
		
}
clear();
sub add_layer_text  {
       my $x=shift||0;
       my $y=shift||0;
       my $text=shift||'nothing';
	   my $xsize=shift;
	   $main::f->COM ('add_text',
       attributes         =>'no',
       type               =>'string',
       x                  =>$x,
       y                  =>$y,
       text               =>$text,
       x_size             =>$xsize,
       y_size             =>0.12,
       w_factor           =>1.25,
       polarity           =>'positive',
       angle              =>90 ,
       mirror             =>'no',
       fontname           =>'standard',
       bar_type           =>'UPC39',
       bar_char_set       =>'full_ascii',
       bar128_code        =>'none',
       bar_checksum       =>'no',
       bar_background     =>'yes',
       bar_add_string     =>'yes',
       bar_add_string_pos =>'top',
       bar_width          =>0.001,
       bar_height         =>0.2,
       ver               =>1);
}

LABEL_INNER_BOOK_END:  ;
###p__("add layer number ok");

1;


