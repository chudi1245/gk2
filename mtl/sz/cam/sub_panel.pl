#!/usr/bin/perl 
##    zhouqing 
##    2010.05.27
use strict;
use Tk;
use Win32;
use Genesis;
use FBI;

our $host = shift; our $f=new Genesis($host); our $JOB=$ENV{JOB}; our $STEP=$ENV{STEP};
our ($mw,$dx,$dy,$nx,$ny,$width,$direction,$joint,$size_fiducial,$size_ring,$size_mask,$size_tool,$px,$py);
our ($pcbx,$pcby,);
our (@grid_fiducial_entry, @grid_fiducial_button,@grid_tool_entry, @grid_tool_button,
%entry_fiducial,%entry_tool,%button_fiducial,%button_tool,%fiducial,%tool,%layer_class);
*I2M=\25.397;our $I2M;
###___________________________________________________________________________

kysy();

$f->COM ('close_form',job=>$JOB,form=>'eng');
$mw=MainWindow->new;
$mw->geometry("+200+100");
foreach  my $i(0..12) {
	foreach my $ii (0..20) {
		my $text;
		($ii == 3 or $ii == 11 or $ii == 19 )?($text='============'):($text=""); 
		$mw->Label(-text=>$text,-width=>4,-height=>2,)->grid(-column=>$i, -row=>$ii);
	}
}
###_______
$mw->title("Better and better");
$mw->Label(-text=>'DX::MM',-width=>8,-height=>2)->grid(-column=>0, -row=>0,-columnspan=>2);
$mw->Entry(-textvariable=>\$dx,-width=>8,)->grid(-column=>2, -row=>0,-columnspan=>2);
$mw->Label(-text=>"DY::MM",-width=>8,-height=>2)->grid(-column=>4, -row=>0,-columnspan=>2);
$mw->Entry(-textvariable=>\$dy,-width=>8,)->grid(-column=>6, -row=>0,-columnspan=>2);
$mw->Label(-text=>"Num-X",-width=>8,-height=>2)->grid(-column=>0, -row=>1,-columnspan=>2);
$mw->Entry(-textvariable=>\$nx,-width=>8,)->grid(-column=>2, -row=>1,-columnspan=>2);
$mw->Label(-text=>"Num-Y",-width=>8,-height=>2)->grid(-column=>4, -row=>1,-columnspan=>2);
$mw->Entry(-textvariable=>\$ny,-width=>8,)->grid(-column=>6, -row=>1,-columnspan=>2);
$mw->Label(-text=>"Width",-width=>8,-height=>2)->grid(-column=>0, -row=>2,-columnspan=>2);
$mw->Entry(-textvariable=>\$width,-width=>8,)->grid(-column=>2, -row=>2,-columnspan=>2);
$mw->Label(-text=>"Direction",-width=>8,-height=>2)->grid(-column=>4, -row=>2,-columnspan=>2);
$mw->Optionmenu(-options =>[qw/X Y N S W E ALL/],-width=>2,-textvariable=>\$direction)->grid(-column=>6, -row=>2,-columnspan=>2);
$mw->Label(-text=>"Joint",-width=>8,-height=>2)->grid(-column=>8, -row=>2,-columnspan=>2);
$mw->Entry(-textvariable=>\$joint,-width=>8,)->grid(-column=>10, -row=>2,-columnspan=>2);
$mw->Label(-text=>"Size_fidu",-width=>10,-height=>2)->grid(-column=>3, -row=>6,-columnspan=>2);
$mw->Entry(-textvariable=>\$size_fiducial,-width=>8,)->grid(-column=>5, -row=>6,-columnspan=>2);
$mw->Label(-text=>"Size_ring",-width=>8,-height=>2)->grid(-column=>3, -row=>7,-columnspan=>2);
$mw->Entry(-textvariable=>\$size_ring,-width=>8,)->grid(-column=>5, -row=>7,-columnspan=>2);
$mw->Label(-text=>"Size_mask",-width=>8,-height=>2)->grid(-column=>3, -row=>8,-columnspan=>2);
$mw->Entry(-textvariable=>\$size_mask,-width=>8,)->grid(-column=>5, -row=>8,-columnspan=>2);
$mw->Label(-text=>"Size_tool",-width=>8,-height=>2)->grid(-column=>3, -row=>14,-columnspan=>2);
$mw->Entry(-textvariable=>\$size_tool,-width=>8,)->grid(-column=>5, -row=>14,-columnspan=>2);
##________________________________________________fiducial
@grid_fiducial_entry=(
     {col=>1,row=>4},  {col=>11,row=>4}, {col=>1,row=>10}, {col=>11,row=>10},
	 {col=>0,row=>5},  {col=>0,row=>9},    {col=>12,row=>5}, {col=>12,row=>9},    );
foreach  (@grid_fiducial_entry) {                              
	my ($col,$row)=($_->{col}, $_->{row});
	$entry_fiducial{$col}{$row}=$mw->Entry(-width=>4,-textvariable=>\$fiducial{$col}{$row})->grid(-column=>$col, -row=>$row);
}
@grid_fiducial_button=({col=>1,row=>5},  {col=>11,row=>5},  {col=>1,row=>9},  {col=>11,row=>9},);
foreach  (@grid_fiducial_button) {                              
	my ($col,$row)=($_->{col}, $_->{row});
	$button_fiducial{$col}{$row}=$mw->Button(-width=>2,-command=>[\&switch,$col,$row])->grid(-column=>$col, -row=>$row);
};
###__________________________________________________tool
 @grid_tool_entry=(
     {col=>1,row=>12},   {col=>1,row=>18},   {col=>11,row=>12},   {col=>11,row=>18},
	 {col=>0,row=>13},   {col=>0,row=>17},   {col=>12,row=>17},   {col=>12,row=>13}, );
foreach  ( @grid_tool_entry) {                              
	my ($col,$row)=($_->{col}, $_->{row});
	$entry_tool{$col}{$row}=$mw->Entry(-width=>4,-textvariable=>\$tool{$col}{$row})->grid(-column=>$col, -row=>$row);
}
@grid_tool_button=({col=>1,row=>13},   {col=>11,row=>13},   {col=>1,row=>17},   {col=>11,row=>17},);
foreach  (@grid_tool_button) {                              
	my ($col,$row)=($_->{col}, $_->{row});
	$button_tool{$col}{$row}=$mw->Button(-width=>2,-command=>[\&switch,$col,$row])->grid(-column=>$col, -row=>$row);
}
###_________________________________________________________________
$mw->Label(-text=>"<========",-width=>8,-height=>2)->grid(-column=>2, -row=>5,);
$mw->Button(-text=>'All the sanme',-width=>12,-command=>[\&all_the_same,'fiducial'])->grid(-column=>2,-row=>5,-columnspan=>3);
$mw->Label(-text=>"<========",-width=>8,-height=>2)->grid(-column=>2, -row=>13,);
$mw->Button(-text=>'All the sanme',-width=>12,-command=>[\&all_the_same,'tool'])->grid(-column=>2,-row=>13,-columnspan=>3);
$mw->Button(-text=>'Default',-width=>12,-command=>[\&parameter_set,'default'])->grid(-column=>0,-row=>20,-columnspan=>3);
$mw->Button(-text=>'Clear',-width=>12,-command=>[\&parameter_set,'clear'])->grid(-column=>3,-row=>20,-columnspan=>3);
$mw->Button(-text=>'DO',-width=>12,-command=>\&apply,)->grid(-column=>8,-row=>20,-columnspan=>4);
parameter_set('default');
MainLoop;
sub switch{
	my ($col,$row)=@_;
	if ($row < 11) {
	    my $text=$button_fiducial{$col}{$row}->cget(-text);
	    if ($text eq '@') {$button_fiducial{$col}{$row}->configure(-text=>' ')
	    }else             {$button_fiducial{$col}{$row}->configure(-text=>'@')
	    };
	}elsif($row > 11){
		my ($col,$row)=@_;
	    my $text=$button_tool{$col}{$row}->cget(-text);
	    if ($text eq 'D') {$button_tool{$col}{$row}->configure(-text=>' ')
	    }else             {$button_tool{$col}{$row}->configure(-text=>'D')
	    };
	}
}#####end switch
sub all_the_same{
	my $id=shift;
	if ($id eq 'fiducial') {
		my $text=$button_fiducial{  $grid_fiducial_button[0]->{col}    }{    $grid_fiducial_button[0]->{row}   }->cget(-text);
		foreach  (@grid_fiducial_button[1..3]) {
			my ($col,$row)=($_->{col}, $_->{row});
			$button_fiducial{$col}{$row}->configure(-text=>$text);			
		}
		foreach  (@grid_fiducial_entry[1..3]) {
			my ($col,$row)=($_->{col}, $_->{row});
			$fiducial{$col}{$row}=$fiducial{  $grid_fiducial_entry[0]->{col}  }{  $grid_fiducial_entry[0]->{row}  };
		}	
		foreach  (@grid_fiducial_entry[5..7]) {
			my ($col,$row)=($_->{col}, $_->{row});
			$fiducial{$col}{$row}=$fiducial{  $grid_fiducial_entry[4]->{col}  }{  $grid_fiducial_entry[4]->{row}  };
		}
	}
    ##____________
	if ($id eq 'tool') {
		my $text=$button_tool{  $grid_tool_button[0]->{col}    }{    $grid_tool_button[0]->{row}   }->cget(-text);
		foreach  (@grid_tool_button[1..3]) {
			my ($col,$row)=($_->{col}, $_->{row});
			$button_tool{$col}{$row}->configure(-text=>$text);			
		}
		foreach  (@grid_tool_entry[1..3]) {
			my ($col,$row)=($_->{col}, $_->{row});
			$tool{$col}{$row}=$tool{  $grid_tool_entry[0]->{col}  }{  $grid_tool_entry[0]->{row}  };
		}	
		foreach  (@grid_tool_entry[5..7]) {
			my ($col,$row)=($_->{col}, $_->{row});
			$tool{$col}{$row}=$tool{  $grid_tool_entry[4]->{col}  }{  $grid_tool_entry[4]->{row}  };
		}
	}
}###end all the same
sub parameter_set {
	my $id =shift;
	my ($text_fiducial,$text_tool,$fiducial_x,$fiducial_y,$tool);
	if ($id eq 'default') {
		($text_fiducial,$text_tool,$fiducial_x,$fiducial_y,$tool,$size_fiducial,$size_ring,$size_mask,$size_tool,$nx,$ny,$dx,$dy,$width,$joint)=
		(    '@',          'D',         10,       5,         5,       1.0,       "4.0x3.1",    3.0,      2.05,     2,  2,  0,  2,  10,     0,);
	}
	if ($id eq 'clear') {
		map {$_=''}($text_fiducial,$text_tool,$fiducial_x,$fiducial_y,$tool,$size_fiducial,$size_ring,$size_mask,$size_tool,$nx,$ny,$dx,$dy,$width,$joint);
	}
	foreach  (@grid_fiducial_button) {
		my ($col,$row)=($_->{col}, $_->{row});
		$button_fiducial{$col}{$row}->configure(-text=>$text_fiducial);			
	}
	foreach  (@grid_tool_button) {
		my ($col,$row)=($_->{col}, $_->{row});
		$button_tool{$col}{$row}->configure(-text=>$text_tool);			
	}
	foreach  (@grid_fiducial_entry[0..3]) {
		my ($col,$row)=($_->{col}, $_->{row});
		$fiducial{$col}{$row}=$fiducial_x;			
	}
	foreach  (@grid_fiducial_entry[4..7]) {
		my ($col,$row)=($_->{col}, $_->{row});
		$fiducial{$col}{$row}=$fiducial_y;			
	}
	foreach  (@grid_tool_entry) {
		my ($col,$row)=($_->{col}, $_->{row});
		$tool{$col}{$row}=$tool;			
	}
}
####mian
sub apply {
    $f->COM('disp_off');
	unit_set('inch');
	#do "d:/xxx/camp/sub_panel/sub_do.pl";
	#do "d:/xxx/camp/sub_panel/add_fiducial_tool.pl";
	#do "d:/xxx/camp/sub_panel/sub_box_vcut.pl";
	#do "d:/xxx/camp/sub_panel/sub_fill.pl";
	require "sub_do.pl";
	require "add_fiducial_tool.pl";
	require "sub_box_vcut.pl";
	require "sub_fill.pl";

    $f->COM('disp_on');
	clear('box','drl');
	p__('sub panel ok');

	exit;
}
###________end
=head







