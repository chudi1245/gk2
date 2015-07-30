#!/usr/bin/perl
print "Hello, World...\n";

#!/usr/bin/perl

use FBI;
use Genesis;
use Encode;
use encoding 'euc_cn';

#
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};

#Global Variables
#####________________________

my ($work_layer,@text,@line);
my $work_layer = get_work_layer(); 
unit_set('mm');
if ( get_select_count() ){
	$f->INFO( units => 'mm', entity_type => 'layer', entity_path => "$JOB/$STEP/$work_layer", data_type => 'FEATURES', options => "select");
	@text=@{$f->{doinfo}->{'text'}};
	$f->COM ('sel_clear_feat');
}else{
	p__("not slect any");
	exit;
}

shift @text;  ###the frist line no use
my @pad;
my $init = 0;
foreach  (0..$#text) {  	
	my @tmp=split ' ',$text[$_];  
	$tmp[0] =~ s/\#//; 
	if ($tmp[0] eq 'P') {@pad = @tmp ;}
	if ($tmp[0] eq 'L') {$line[$init]=[@tmp] ;$init++ }
}

#############################################
clear($work_layer);

my ($startx,$starty) = ($pad[1],$pad[2]);
#p__("startx = $startx, starty = $starty");

##左： 小 小  小 大
if ( $pad[1] < $line[0][1] and   $pad[2] < $line[0][2] and   $pad[1] < $line[0][3] and   $pad[2] > $line[0][4] ) {
	
	foreach  (0..$#line) {	
		my $distance = abs( $line[$_][1] - $pad[1] );
		$length = sprintf "%6.2f",$distance ;
		my $text = $length.'MM';
		add_size_text($startx,$starty+5, $text);

       ##加不连续的线
		my $max = $startx + $distance;
		my $statx = $startx;
		while ( $statx < $max-10 ) {
			creat_line($statx,$starty,'rig',10,'r8'); 
			$statx+=20;
		}
		add_pad($startx + $length ,   $starty, 'mark_line_width', 'no',  270); ##加一个箭头
		$starty+=30; ## 往上移30mm
	}
}

##右： 大 小  大 大 
if ( $pad[1] > $line[0][1] and   $pad[2] < $line[0][2] and   $pad[1] > $line[0][3] and   $pad[2] > $line[0][4] ) {
	p__("in rig");
	foreach  (0..$#line) {
		my $distance = abs($pad[1] - $line[$_][1] );
		$length = sprintf "%6.2f",$distance ;
		my $text = $length.'MM';
		add_size_text($startx-25,$starty+5, $text); ##加文字标识
		
		my $max = $startx - $distance;
		my $stax = $startx;
		#p__("stax = $stax, max = $max");
		while ( $stax > $max+10 ) {
			creat_line($stax,$starty,'lef',10,'r8'); 
			$stax-=20;
		}
		add_pad($startx - $length ,   $starty, 'mark_line_width', 'no',  90); ##加一个箭头
		$starty+=30; ## 往上移30mm,再画线
	}
}

##上： 大 大  小 大
if ( $pad[1] > $line[0][1] and   $pad[2] > $line[0][2] and   $pad[1] < $line[0][3] and   $pad[2] > $line[0][4] ) {

	foreach  (0..$#line) {
		my $distance = abs( $pad[2] - $line[$_][2] );
		$length = sprintf "%6.2f",$distance ;
		my $text = $length.'MM';
		add_size_text($startx+5,$starty, $text,'no',90); ##加文字标识

		my $miny = $starty - $distance;
		my $stay = $starty;
		while ( $stay > $miny+10 ) {
			creat_line($startx,$stay,'bot',10,'r8'); 
			$stay-=20;
		}

		add_pad($startx,  $starty - $length, 'mark_line_width', 'no',  0); ##加一个箭头
		$startx+=30; ## 往上移30mm,再画线
	}
}

##下： 大 小  小 小
if ( $pad[1] > $line[0][1] and   $pad[2] < $line[0][2] and   $pad[1] < $line[0][3] and   $pad[2] < $line[0][4] ) {
	p__("in top");
	foreach  (0..$#line) {
		my $distance = abs( $pad[2] - $line[$_][2] );
		$length = sprintf "%6.2f",$distance ;
		my $text = $length.'MM';
		add_size_text($startx+5,$starty, $text,'no',270); ##加文字标识

		my $stay = $starty;
		my $maxy = $starty + $distance;
		while ( $stay < $maxy-10 ) {
			creat_line($startx,$stay,'top',10,'r8'); 
			$stay+=20;
		}

		add_pad($startx,   $starty + $length, 'mark_line_width', 'no',  180); ##加一个箭头
		$startx+=30; ## 往右移30mm,再画线
	}
}


#sub draw_line{
#	my $stax = shift;
#	my $stay = shift;
#	my $length = shift;
#	my $max = $stax + $length;
#	while ( $stax < $max-10 ) {
#		creat_line($stax,$stay,'rig',10,'r8'); 
#		$stax+=20;
#	}
#	add_pad($startx + $length ,   $starty, 'mark_line_width', 'no',  270);
#}


sub add_size_text  {
       my $x=shift||0;
       my $y=shift||0;
       my $text=shift||'nothing';
       my $mirror=shift||'no';
       my $angle=shift||0; 

       $f->COM ('add_text',
       attributes         =>'no',
       type               =>'string',
       x                  =>$x,
       y                  =>$y,
       text               =>$text,
       x_size             =>3,
       y_size             =>3,
       w_factor           =>0.65,
       polarity           =>'positive',
       angle              =>$angle ,
       mirror             =>$mirror,
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

################End 
=head
COM add_text,attributes=no,type=string,
x=36.691675,y=154.6970925,text=69.02MM,x_size=3,y_size=3,
w_factor=0.656167984,polarity=positive,angle=0,mirror=no,
fontname=standard,bar_type=UPC39,bar_char_set=full_ascii,bar128_code=none,bar_checksum=no,bar_background=yes,bar_add_string=yes,bar_add_string_pos=top,bar_width=0.001,bar_height=0.2,ver=1



my $startx = 1.46;
my $starty = 2.56;

clear('vut_map');
draw_line($startx,$starty,12.9);



sub dis_pp {
	my ($x,$y,$xx,$yy)=@_;
	my $dis=sqrt( ($xx-$x)**2 + ($yy-$y)**2  );
	return $dis;
}



sub draw_line{
	my $stax = shift;
	my $stay = shift;
	my $length = shift;
	my $max = $stax + $length;
	while ( $stax < $max-0.4 ) {
		##p__("$stax,$stay");
		creat_line($stax,$stay,'rig',0.4,'r8'); 

		$stax+=0.8;
	}

	add_pad($startx + $length ,   $starty, 'mark_line_width', 'no',  270);
}




=head
my $text=round($dis{$min_key}*$I2M,2).'MM';
			my $k_m=($point[$two]{y}-$point[$one]{y}) / ($point[$two]{x}-$point[$one]{x}) ;

			add_line($point[$one]{x},$point[$one]{y},$point[$two]{x},$point[$two]{y},'r10');
			add_text( $point[$one]{x}/2 + $point[$two]{x}/2 + 0.08, $point[$one]{y}/2+$point[$two]{y}/2, $text,);




