use strict;
use warnings;
my $class=\%main::layer_class;

foreach  ( @{$class->{drill}} ) {
	my $text=$_;
	next if ($text eq 'drl-2' or $text eq 'drl_2');
	$text =~ s/drl/$main::JOB/;
	clear($_);
	$main::f->COM ('add_text',
		attributes=>'no',
		type=>'canned_text',
		x=>$main::SR_xmin - 0.38,
		y=>$main::SR_ymax - 0.4,
		text=>$text,

		x_size=>0.199,
		y_size=>0.233,
		w_factor=>2.3031497002,

		#x_size=>0.227,
		#y_size=>0.265,	##w_factor=>2.62467, ###x_size=0.166,y_size=0.232,w_factor=2.296587944
                               
		#w_factor=>2.6570,
		polarity=>'positive',
		angle=>90,
		mirror=>'no',
		fontname=>'canned_57',
		bar_type=>'UPC39',
		bar_char_set=>'full_ascii',
		bar128_code=>'none',
		bar_checksum=>'no',
		bar_background=>'yes',
		bar_add_string=>'no',
		bar_add_string_pos=>'top',
		bar_width=>0.008,
		bar_height=>0.175,
		ver=>1);
	$main::f->COM ('sel_break');
	##breake the drill fn
}

clear();
1;

=head

COM add_text,attributes=no,type=canned_text,x=10.1347825,y=82.756365,text=$$JOB,x_size=4.2164,y_size=5.8928,w_factor=2.296587944,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1
COM units,type=inch
COM add_text,attributes=no,type=canned_text,x=0.3934148622,y=2.9962192913,text=$$JOB,x_size=0.166,y_size=0.232,w_factor=2.296587944,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1
COM add_text,attributes=no,type=canned_text,x=0.3980750984,y=3.0027436024,text=$$JOB,x_size=0.166,y_size=0.232,w_factor=2.296587944,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1
COM add_text,attributes=no,type=canned_text,x=0.0653341535,y=4.3514163386,text=$$JOB,x_size=0.237,y_size=0.331,w_factor=3.28083992,polarity=positive,angle=0,mirror=no,fontname=canned_57,ver=1


COM add_text,attributes=no,type=canned_text,x=3.6735649606,y=11.3906432087,text=$$JOB,x_size=0.199,y_size=0.233,w_factor=2.3031497002,polarity=positive,angle=0,mirror=no,fontname=canned_67,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=no,bar_add_string_pos=top,bar_width=0.008,bar_height=0.175,ver=1

