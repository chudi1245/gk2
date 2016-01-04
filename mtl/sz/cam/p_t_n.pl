#!/usr/bin/perl  
use strict;
use Tk;
use Win32;
use Genesis;
use lib "D:/xxx/camp/lib";
use FBI;
our $host = shift;
our $f    = new Genesis($host);
our $JOB  = $ENV{JOB};
our $STEP = $ENV{STEP};

kysy();

my (@row_name,@row_row,@row_side,$mw,$gLIMITSxmin,$gLIMITSymin,$gLIMITSxmax,$gLIMITSymax,$run_step,$ref,$tst);
###_____________________________________________________________
$run_step = read_form($JOB,'E21');
$f->COM ('close_form',job=>$JOB,form=>'qae');
@row_row=@{info('matrix',"$JOB/matrix",'ROW')->{gROWrow}};
@row_name=@{info('matrix',"$JOB/matrix",'ROW')->{gROWname}};
@row_side=@{info('matrix',"$JOB/matrix",'ROW')->{gROWside}};
$tst=exists_entity('layer',"$JOB/$run_step/box");
if ($tst eq 'no') {
	p__('box layer not exitst');
	exit;
}
$ref=info('layer',"$JOB/$run_step/box",'limits');
$gLIMITSxmin=$ref->{gLIMITSxmin};
$gLIMITSxmax=$ref->{gLIMITSxmax};
$gLIMITSymin=$ref->{gLIMITSymin};
$gLIMITSymax=$ref->{gLIMITSymax};
###___________________________________________________________
kysy();
$mw=MainWindow->new;
$mw->title('positive_to_negative');  
my $lb = $mw->Listbox(-selectmode => "multiple")->pack( );
foreach (@row_row) {
	if ($row_side[$_] eq 'inner' ) {	
             $lb->insert('end',$row_name[$_]);               	
	}  
}
$mw->Button(-text=>'DO',-command=>\&p_t_n)->pack();
MainLoop;
###_______________________________________________________________
sub p_t_n {
	my $name=$lb->SelectionGet;
	my @name=split ' ',$name;
        foreach  (@name) {
	    clear ($_);
        $f->COM ('add_surf_strt');
        $f->COM ('add_surf_poly_strt',x=>$gLIMITSxmin, y=>$gLIMITSymin);
        $f->COM ('add_surf_poly_seg', x=>$gLIMITSxmax, y=>$gLIMITSymin);
        $f->COM ('add_surf_poly_seg', x=>$gLIMITSxmax, y=>$gLIMITSymax);
        $f->COM ('add_surf_poly_seg', x=>$gLIMITSxmin, y=>$gLIMITSymax);
        $f->COM ('add_surf_poly_seg', x=>$gLIMITSxmin, y=>$gLIMITSymin);
        $f->COM ('add_surf_poly_end');
        $f->COM ('add_surf_end',attributes=>'no',polarity=>'negative');
        $f->COM ('filter_set',filter_name=>'popup',update_popup=>'no',polarity=>'positive');
        $f->COM ('filter_area_strt');
        $f->COM ('filter_area_end',
	    	layer           =>'',
		filter_name     =>'popup',
  		operation       =>'select',
    		area_type       =>'none',
	    	inside_area     =>'no',
    		intersect_area  =>'no',
    		lines_only      =>'no',
    		ovals_only      =>'no',
    		min_len         =>0,
    		max_len         =>0,
    		min_angle       =>0,
    		max_angle       =>0);
        $f->COM ('sel_copy',dx=>0,dy=>0);
        $f->COM ('sel_invert');
	}
	exit;
}















