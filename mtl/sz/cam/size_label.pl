#!/usr/bin/perl
use strict;
use Genesis;
use Win32;
use POSIX;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
*I2M=\25.397;
our $I2M;
my $pi = atan2(1,1) * 4;
###__________________________
kysy();
unit_set('inch');
my ($work_layer,@text,@line);
my $work_layer=get_work_layer(); 
if ( get_select_count() ){
	$f->INFO(entity_type => 'layer', entity_path => "$JOB/$STEP/$work_layer", data_type => 'FEATURES', options => "select");
	@text=@{$f->{doinfo}->{'text'}};
	$f->COM ('sel_clear_feat');
}else{
	p__("not slect any");
}
shift @text;  ###the frist line no use
foreach  (0..$#text) {   
	my @tmp=split ' ',$text[$_];  
	$tmp[0] =~ s/\#//;   
	$line[$_]=[@tmp]    
}
###_______________________________________________________________one line
if ($#line == 0 and $line[0]->[0] eq 'L') {
	my ($x1,$y1,$x2,$y2)=@{$line[0]}[1..4];
	if ($x1 == $x2) {
		my $text=round(abs($y2-$y1)*$I2M,2).'MM';
		add_wenzi( $x1/2+$x2/2, $y1/2+$y2/2, $text);
		add_pad($x1,$y1,'mark_line_width','no',);
		add_pad($x2,$y2,'mark_line_width','no',180);

	}elsif($y1 == $y2){
		my $text=round(abs($x2-$x1)*$I2M,2).'MM';
		add_wenzi( $x1/2+$x2/2, $y1/2+$y2/2, $text);
		add_pad($x1,$y1,'mark_line_width','no',90);
		add_pad($x2,$y2,'mark_line_width','no',270);
	
	}else{
    	my $distance=dis_pp( $x1,$y1,$x2,$y2 );
	    my $text=round($distance*$I2M,2).'MM';
		my $k=($y2-$y1)/($x2-$x1);
	    add_wenzi( $x1/2+$x2/2, $y1/2+$y2/2, $text);

		add_pad($x1,$y1,'mark_line_width','no',90);
		sel_rectangle($x1,$y1);	
		if ( get_select_count() ){my $ang=fix_360(360-POSIX::atan($k)/$pi*180); sel_transform($x1,$y1,0,0,1,1,$ang,'rotate'); }
		add_pad($x2,$y2,'mark_line_width','no',90);
		sel_rectangle($x2,$y2);	
		if ( get_select_count() ){my $ang=fix_360(180-POSIX::atan($k)/$pi*180); sel_transform($x2,$y2,0,0,1,1,$ang,'rotate'); }
	}
	exit;
}
###_____________________________________________________________line to line 
if ($line[0]->[0] eq 'L' and $line[1]->[0] eq 'L' and  $#line == 1) {
  my @point=(
    {x=>$line[0][1],y=>$line[0][2]},
	{x=>$line[0][3],y=>$line[0][4]},
	{x=>$line[1][1],y=>$line[1][2]},
	{x=>$line[1][3],y=>$line[1][4]},		
  );

    ########$line[0][1]
	if ($point[0]{x} == $point[1]{x} and $point[2]{x} == $point[3]{x}) { 
		my $distance = abs($point[2]{x}-$point[0]{x}) * $I2M;
		$distance=round($distance,2).'MM';
		my $excursion=length($distance)*0.014;
		add_line($point[0]{x}, $point[0]{y}, $point[2]{x}, $point[0]{y}, 'r9');
		add_wenzi( ($point[0]{x}+$point[2]{x})/2-$excursion, $point[0]{y}+0.01 , $distance,  );
		add_pad($point[0]{x}, $point[0]{y},'mark_line_width','no',90);
		add_pad($point[2]{x}, $point[0]{y},'mark_line_width','no',270);

	}elsif($point[0]{y} == $point[1]{y} and $point[2]{y} == $point[3]{y} ){
		my $distance = abs($point[2]{y}-$point[0]{y}) * $I2M;
		$distance=round($distance,2).'MM';
		add_line($point[0]{x}, $point[0]{y}, $point[0]{x}, $point[2]{y}, 'r9');
		add_wenzi($point[0]{x}+0.007, ($point[0]{y}+$point[2]{y})/2,   $distance);
		add_pad($point[0]{x}, $point[0]{y},'mark_line_width','no');
		add_pad($point[0]{x}, $point[2]{y},'mark_line_width','no',180);

	}else{
		my $k= ( $point[1]{y} - $point[0]{y} )  /  ( $point[1]{x} - $point[0]{x} );
    	my $kk=( $point[3]{y} - $point[2]{y} )  /  ( $point[3]{x} - $point[2]{x} );
		my $k_n=-1/$k;  ## tan($+90)

	    if (  round($k,5) == round($kk,5)  ){
	        my $c= ($point[0]{x}*$point[1]{y}-$point[0]{y}*$point[1]{x})/($point[0]{x}-$point[1]{x});
	        my $cc=($point[2]{x}*$point[3]{y}-$point[2]{y}*$point[3]{x})/($point[2]{x}-$point[3]{x});
	        my $distance=abs($c-$cc)/sqrt($k**2 + 1);  ##parallel line distance
		    my $text=round($distance*$I2M,2).'MM';

	    	my ($n_a,$n_b,$n_c,)=($k_n**2+1,  -2*$point[0]{x}*($k_n**2+1),  ($point[0]{x}**2)*($k_n**2+1) - $distance**2 );
            my ($start_x, $start_y, $end_x, $end_y)=( $point[0]{x}, $point[0]{y} );
		    SWITCH_1:{
		        my $sure_add_dec=$kk*( $point[0]{x}-$point[2]{x} ) + $point[2]{y} - $point[0]{y};
		        my $tmp=sqrt($n_b**2 - 4*$n_a*$n_c);
			    if ($sure_add_dec > 0 and $kk > 0){ $end_x=( -$n_b - $tmp ) / (2*$n_a);   last SWITCH_1  };
			    if ($sure_add_dec > 0 and $kk < 0){ $end_x=( -$n_b + $tmp ) / (2*$n_a);   last SWITCH_1  };
			    if ($sure_add_dec < 0 and $kk > 0){ $end_x=( -$n_b + $tmp ) / (2*$n_a);   last SWITCH_1  };
			    if ($sure_add_dec < 0 and $kk < 0){ $end_x=( -$n_b - $tmp ) / (2*$n_a);   last SWITCH_1  };
	    	}
		    $end_y=$k_n*($end_x-$start_x)+$start_y;

		    add_wenzi( ($start_x + $end_x)/2+0.01, ($start_y + $end_y)/2, $text,);
		    add_line($start_x, $start_y, $end_x, $end_y, 'r9',);##9
		    add_pad($start_x, $start_y,'mark_line_width','no',90);
		    sel_rectangle($start_x, $start_y);	
		    if ( get_select_count() ){my $ang=fix_360(360-POSIX::atan($k_n)/$pi*180); sel_transform($start_x, $start_y,0,0,1,1,$ang,'rotate'); }
		    add_pad($end_x, $end_y,'mark_line_width','no',90);
		    sel_rectangle($end_x, $end_y,);
			if ( get_select_count() ){my $ang=fix_360(180-POSIX::atan($k_n)/$pi*180); sel_transform($end_x, $end_y,0,0,1,1,$ang,'rotate'); }
		
		}elsif(  round($k,5) != round($kk,5) ){ 
			my %dis;
			$dis{'0_2'}= dis_pp( $point[0]{x}, $point[0]{y}, $point[2]{x}, $point[2]{y} );
			$dis{'0_3'}= dis_pp( $point[0]{x}, $point[0]{y}, $point[3]{x}, $point[3]{y} );
			$dis{'1_2'}= dis_pp( $point[1]{x}, $point[1]{y}, $point[2]{x}, $point[2]{y} );
			$dis{'1_3'}= dis_pp( $point[1]{x}, $point[1]{y}, $point[3]{x}, $point[3]{y} );
			my $min_key=(sort { $dis{$a} <=> $dis{$b} } keys(%dis))[0];
			my ($one,$two)=split '_', $min_key;
			my $text=round($dis{$min_key}*$I2M,2).'MM';
			my $k_m=($point[$two]{y}-$point[$one]{y}) / ($point[$two]{x}-$point[$one]{x}) ;

			add_line($point[$one]{x},$point[$one]{y},$point[$two]{x},$point[$two]{y},'r10');
			add_wenzi( $point[$one]{x}/2 + $point[$two]{x}/2 + 0.08, $point[$one]{y}/2+$point[$two]{y}/2, $text,);
			add_pad($point[$one]{x},$point[$one]{y},'mark_line_width','no',90);
			sel_rectangle($point[$one]{x},$point[$one]{y});	
			if ( get_select_count() ){my $ang=fix_360(180-POSIX::atan($k_m)/$pi*180); sel_transform($point[$one]{x},$point[$one]{y},0,0,1,1,$ang,'rotate'); }
			add_pad($point[$two]{x},$point[$two]{y},'mark_line_width','no',90);
			sel_rectangle($point[$two]{x},$point[$two]{y});	
			if ( get_select_count() ){my $ang=fix_360(360-POSIX::atan($k_m)/$pi*180); sel_transform($point[$two]{x},$point[$two]{y},0,0,1,1,$ang,'rotate'); }

		}
  
	}

###_____________________________________________________________________________pad to pad
}elsif ( $line[0]->[0] eq 'P' and $line[1]->[0] eq 'P' and $#line == 1 ){  

    my @point=( {x=>$line[0][1],y=>$line[0][2]},  {x=>$line[1][1],y=>$line[1][2]} );

	if ( $point[0]{x} == $point[1]{x} ) {
		my $distance=abs( $point[1]{y}-$point[0]{y} );
		my $text=round($distance*$I2M,2).'MM';
		add_line( $point[0]{x}, $point[0]{y}, $point[1]{x},$point[1]{y},'r10');
		add_wenzi( $point[0]{x}/2 + $point[1]{x}/2 +0.008, $point[0]{y}/2 + $point[1]{y}/2, $text,'no',90 );
		add_pad($point[0]{x},$point[0]{y},'mark_line_width','no',);
		add_pad($point[1]{x},$point[1]{y},'mark_line_width','no',180);

	}else{
	    my $k=($point[1]{y}-$point[0]{y}) / ($point[1]{x}-$point[0]{x}) ;
    	my $distance=dis_pp( $point[0]{x}, $point[0]{y}, $point[1]{x}, $point[1]{y} );
    	my $text=round($distance*$I2M,2).'MM';
    	add_line( $point[0]{x}, $point[0]{y}, $point[1]{x},$point[1]{y},'r10');
    	add_wenzi( $point[0]{x}/2 + $point[1]{x}/2 +0.008, $point[0]{y}/2 + $point[1]{y}/2 +0.08, $text, );
    	add_pad($point[0]{x},$point[0]{y},'mark_line_width','no',90);
    	sel_rectangle($point[0]{x},$point[0]{y});	
    	if ( get_select_count() ){my $ang=fix_360(180-POSIX::atan ($k)/$pi*180); sel_transform($point[0]{x},$point[0]{y},0,0,1,1,$ang,'rotate'); }
	    add_pad($point[1]{x},$point[1]{y},'mark_line_width','no',90);
	    sel_rectangle($point[1]{x},$point[1]{y});	
	    if ( get_select_count() ){my $ang=fix_360(360-POSIX::atan ($k)/$pi*180); sel_transform($point[1]{x},$point[1]{y},0,0,1,1,$ang,'rotate'); }
	}
###__________________________________________________________________pad to line 		
}elsif( $line[0]->[0] eq 'P' && $line[1]->[0] eq 'L'  or  $line[0]->[0] eq 'L' && $line[1]->[0] eq 'P'     ) {
	my (@point,$diameter,$distance,$text,$k,$k_t,$end_x,$end_y,$start_x,$start_y);

	if ($line[0]->[0] eq 'P' ) {
		@point=($line[0]->[1],$line[0]->[2], $line[1]->[1],$line[1]->[2],$line[1]->[3],$line[1]->[4],);
		$diameter=$line[0]->[3];
	}else{
		@point=($line[1]->[1],$line[1]->[2], $line[0]->[1],$line[0]->[2],$line[0]->[3],$line[0]->[4],);
		$diameter=$line[1]->[3];
		$diameter =~ s/r//i;
	}
	$diameter =~ s/r//i;
	my $r=$diameter/2000;
	my ($x1,$y1,$x2,$y2,$x3,$y3)=@point;

	if ($y3 == $y2) {
		($y1 > $y2)?($start_y=$y1):($start_y=$y1);
		$text=round(abs($start_y-$y2)*$I2M,2).'MM';
		add_line($x1, $start_y , $x1, $y2,'r10');
		add_wenzi($x1+0.005 ,$start_y/2+$y2/2,$text);
		add_pad($x1, $start_y,'mark_line_width','no',0);
		add_pad($x1, $y2,'mark_line_width','no',180);

	}elsif($x3 == $x2){
		($x1 > $x2)?($start_x=$x1):($start_x=$x1);
		$text=round(abs($start_x-$x2)*$I2M,2).'MM';
		add_line($start_x, $y1 , $x2, $y1,'r10');
		add_wenzi($start_x/2+$x2/2-0.08 ,$y1+0.008,$text);
		add_pad($start_x, $y1,'mark_line_width','no',90);
		add_pad($x2, $y1,'mark_line_width','no',270);

	}else{
		($end_x,$end_y)=($x1,$y1);
		$k=(  ($point[5] -$point[3])/($point[4]-$point[2])  );
		$k_t=-1/$k;
		$start_x= ($k_t*$x1-$k*$x2+$y2-$y1)/($k_t-$k);
		$start_y= $k*$start_x - $k*$x2 + $y2;
		$distance=dis_pp($start_x,$start_y,$x1,$y1);
		my $text=round( $distance*$I2M,2 ).'MM';
		add_line($start_x,$start_y,$end_x,$end_y,'r10');
		add_wenzi($start_x/2+$end_x/2 ,$start_y/2+$end_y/2,$text);
		add_pad($start_x,$start_y,'mark_line_width','no',90);
		sel_rectangle($start_x,$start_y);
		if ( get_select_count() ){my $ang=fix_360(180-POSIX::atan ($k_t)/$pi*180); sel_transform($start_x,$start_y,0,0,1,1,$ang,'rotate'); }
		add_pad($end_x,$end_y,'mark_line_width','no',90);
		sel_rectangle($end_x,$end_y);
		if ( get_select_count() ){my $ang=fix_360(360-POSIX::atan ($k_t)/$pi*180); sel_transform($end_x,$end_y,0,0,1,1,$ang,'rotate'); }
	}

}else{
	p__('cant identify');
}
#####____________________________________end

sub sel_rectangle {
	my $x=shift;
	my $y=shift;
	$f->COM ('sel_clear_feat');
    $f->COM ('filter_area_strt');
    $f->COM ('filter_area_xy',x=>$x-0.002,y=>$y-0.002);
    $f->COM ('filter_area_xy',x=>$x+0.002,y=>$y+0.002);
    $f->COM ('filter_area_end',
		layer        =>'',
		filter_name  =>'popup',
		operation    =>'select',
		area_type    =>'rectangle',
		inside_area  =>'yes',
		intersect_area=>'no',
		lines_only   =>'no',
		ovals_only   =>'no',
		min_len      =>0,
		max_len      =>0,
		min_angle    =>0,
		max_angle    =>0);
}

sub fix_360 ($) {
	my $angle=shift;
	while ($angle < 0) { $angle+=180 }
	$angle=$angle % 360;
	return $angle
}
sub dis_pp {
	my ($x,$y,$xx,$yy)=@_;
	my $dis=sqrt( ($xx-$x)**2 + ($yy-$y)**2  );
	return $dis;
}


