#!/usr/bin/perl  
use strict;
use Tk;
use Win32;
use Genesis;
use  C;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($mw,$text,$text2,$ref_orig,$ref_pcb);
my (@num_orig,@count_orig,@shape_orig,@size_orig,$HISTline_orig,$HISTpad_orig );
my (@num_pcb,@count_pcb,@shape_pcb,@size_pcb,$HISTline_pcb,$HISTpad_pcb );
###_______________________________________
###$f->COM ('close_form',job=>$JOB,form=>'qae');

kysy();

$ref_orig=info('layer',"$JOB/orig/drl",);
@num_orig   =@{$ref_orig->{gTOOLnum}};
@count_orig =@{$ref_orig->{gTOOLcount}}; 
@shape_orig =@{$ref_orig->{gTOOLshape}}; 
@size_orig  =@{$ref_orig->{gTOOLdrill_size}};
$HISTline_orig =$ref_orig->{gFEAT_HISTline};
$HISTpad_orig  =$ref_orig->{gFEAT_HISTpad};

$ref_pcb =info('layer',"$JOB/pcb/drl", );
@num_pcb  =@{$ref_pcb->{gTOOLnum}};
@count_pcb=@{$ref_pcb->{gTOOLcount}}; 
@shape_pcb=@{$ref_pcb->{gTOOLshape}}; 
@size_pcb= @{$ref_pcb->{gTOOLdrill_size}}; 
$HISTline_pcb =$ref_pcb->  {gFEAT_HISTline};
$HISTpad_pcb  =$ref_pcb->  {gFEAT_HISTpad};
###_________________________________________
$mw=MainWindow->new;
$mw->geometry("+200+100");
$text=$mw->Text(-width=>32,-font=>'large')->grid(-column=>1,-row=>1);
foreach  (0..$#num_orig) {
	$num_orig[$_]  =  sprintf'%-4s',$num_orig[$_];
    $size_orig[$_] =  $size_orig[$_]*25.4/1000;
    $size_orig[$_] =  sprintf'%-10s',$size_orig[$_];
	$count_orig[$_]=  sprintf'%-5s',$count_orig[$_];
    $shape_orig[$_]=  sprintf'%-6s',$shape_orig[$_];
	$text->insert('end',"T$num_orig[$_] $size_orig[$_] $shape_orig[$_] $count_orig[$_] \n");
}
$text->insert('end',"\n Total_pad    $HISTpad_orig\n");  
$text->insert('end'," Total_line   $HISTline_orig\n");
$text2=$mw->Text(-width=>32,-font=>'large')->grid(-column=>2,-row=>1);
foreach  (0..$#num_pcb) {
	$num_pcb[$_]  =  sprintf'%-4s',$num_pcb[$_];
         $size_pcb[$_]= $size_pcb[$_]*25.4/1000;
        $size_pcb[$_]=sprintf'%-10s',$size_pcb[$_];
	$count_pcb[$_]=  sprintf'%-5s',$count_pcb[$_];
        $shape_pcb[$_]=  sprintf'%-6s',$shape_pcb[$_];
	$text2->insert('end',"T$num_pcb[$_] $size_pcb[$_] $shape_pcb[$_] $count_pcb[$_] \n");
}
$text2->insert('end',"\n Total_pad    $HISTpad_pcb\n");  
$text2->insert('end'," Total_line   $HISTline_pcb\n");
MainLoop;











