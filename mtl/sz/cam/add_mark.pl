#! /usr/bin/perl
use strict;
use Tk;
use Win32;
use Tk::Pane;
use Genesis;
use FBI;
use Encode;
use Encode::CN;
###_______________________
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
kysy();

my ($marks,$mouse,@mouse_cord);

###_______________________
my $mw=MainWindow->new;
$mw->geometry("+120+120");
$mw->title("Add mark");
$mw->Optionmenu(-options =>[qw\job jingdian pb rohs mtl-s mtl-d mtl-m mtl-m1 mtl88 8888\],
	-textvariable=>\$marks,-font => [-family=>'ºÚÌå',-size=>14],-width=>8)->grid(-column=>0,-row=>1);
$mw->Button(-text=>'Add',-width=>8,-command=>\&apply,
	-font => [-family=>'ºÚÌå',-size=>14])->grid(-column=>1,-row=>1,);
  
MainLoop;
##$f->PAUSE("IS OK");
sub apply{

	$mouse=$f->MOUSE('p Please select one point');
	@mouse_cord=split m/\s/,$mouse;
	my $work_layer = $f->COM ('get_work_layer');
	my $mirror="no";

	if (!$work_layer) {
        $f->PAUSE('The work_layer is not open');
		exit;
	}else {
		if ($work_layer =~ m/b/ig ) {
			$mirror="yes";
		}
	}

    if ($marks eq "job") {
		#my $text = `echo $JOB | tr '[a-z]' '[A-Z]' `;
		my $text =uc($JOB);
		add_text($mouse_cord[0],$mouse_cord[1],$text,$mirror);
		exit;
    }else{		
		add_pad($mouse_cord[0], $mouse_cord[1],$marks,$mirror);
		exit;
	}
}


sub add_text{
	my $x=shift;
	my $y=shift;
	my $text=shift;
	my $mirror=shift;
	
	$f->COM('add_text',
	 attributes=>'no',
	 type=>'string',
	 x=>$x,
	 y=>$y,
     text=>$text,
	 x_size=>0.05,             
	 y_size=> 0.05,             
	 w_factor=>0.60,          
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


