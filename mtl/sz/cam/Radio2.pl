#!/usr/bin/perl

use Win32;

#Global Variables
my $age = 10;
my $gender = "Male";
my $occupied = 1;

# Main Window
my $mw = new MainWindow;

#GUI Building Area
my $frm_name = $mw -> Frame();
my $lab = $frm_name -> Label(-text=>"Name:");
my $ent = $frm_name -> Entry();
#Age
my $scl = $mw -> Scale(-label=>"Age :",
	 -orient=>'v',	 	-digit=>1,
	 -from=>10,		-to=>50,
	 -variable=>\$age,	-tickinterval=>10);
	
#Jobs
my $chk = $mw -> Checkbutton(-text=>"Occupied",
	-variable=>\$occupied);
$chk -> deselect();

#Gender
my $frm_gender = $mw -> Frame();
my $lbl_gender = $frm_gender -> Label(-text=>"Sex ");
my $rdb_m = $frm_gender -> Radiobutton(-text=>"Male",  -value=>"Male",  -variable=>\$gender);
my $rdb_f = $frm_gender -> Radiobutton(-text=>"Female",-value=>"Female",-variable=>\$gender);

my $but = $mw -> Button(-text=>"Push Me", -command =>\&push_button);

#Text Area
my $textarea = $mw -> Frame();
my $txt = $textarea -> Text(-width=>40, -height=>10);
my $srl_y = $textarea -> Scrollbar(-orient=>'v',-command=>[yview => $txt]);
my $srl_x = $textarea -> Scrollbar(-orient=>'h',-command=>[xview => $txt]);
$txt -> configure(-yscrollcommand=>['set', $srl_y], 
		-xscrollcommand=>['set',$srl_x]);

#Geometry Management
$lab -> grid(-row=>1,-column=>1);
$ent -> grid(-row=>1,-column=>2);
$frm_name -> grid(-row=>1,-column=>1,-columnspan=>2);

$scl -> grid(-row=>2,-column=>1);
$chk -> grid(-row=>2,-column=>2,-sticky=>'w');

$lbl_gender -> grid(-row=>1,-column=>1);
$rdb_m -> grid(-row=>1,-column=>2);
$rdb_f -> grid(-row=>1,-column=>3);
$frm_gender -> grid(-row=>3,-column=>1,-columnspan=>2);

$but -> grid(-row=>4,-column=>1,-columnspan=>2);

$txt -> grid(-row=>1,-column=>1);
$srl_y -> grid(-row=>1,-column=>2,-sticky=>"ns");
$srl_x -> grid(-row=>2,-column=>1,-sticky=>"ew");
$textarea -> grid(-row=>5,-column=>1,-columnspan=>2);

MainLoop;

## Functions
#This function will be executed when the button is pushed
sub push_button {
	my $name = $ent -> get();
	$txt -> insert('end',"$name\($gender\) is $age years old.");
}
