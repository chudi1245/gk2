#!/usr/bin/perl
## zq 2009.08.14
##     v:0.3
## input gerber
## inout drill 2010.07.22
## save-job 2010.08.20
use strict;
use Genesis;
use C;

our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
kysy();
my $gb_path = "E:/work/pcb";
opendir (DH,$gb_path);
my @gb_list=readdir DH;
foreach (@gb_list){
    if ($_ =~ m/\.gbr$/ig){
		my $gb_new=lc $_;
        $gb_new =~ s/\.gbr$//ig;           
        $f->COM ('input_manual_reset');
        $f->COM ( 'input_manual_set',
          path            =>"$gb_path/$_",
          job             =>"$JOB",
          step            =>'pcb',
          format          =>'Gerber274x',
          data_type       =>'ascii',
          units           =>'inch',
          coordinates     =>'absolute',
          zeroes          =>'leading',
          nf1             =>'2',
          nf2             =>'4',
          decimal         =>'no',
          separator       =>'*',
          tool_units      =>'inch',
          layer           =>"$gb_new",
          wheel           =>'',
          wheel_template  =>'',
          nf_comp         =>'0',
          multiplier      =>'1',
          text_line_width =>'0.0024',
          signed_coords   =>'no',
          break_sr        =>'yes',
          drill_only      =>'no',
          merge_by_rule   =>'no',
          threshold       =>'200',
          resolution      =>'3');
        $f->COM ('input_manual',script_path=>'');
###_________________________________________________
	}elsif ($_ =~ m/\.drl$/ig){
		my $drl_new=lc $_;
		if ($drl_new =~ m/[-_]/) {
			my ($x,$y,$z)=($`,$&,$');
            $z =~ /\./;
	        my ($xx,$yy,$zz)=($`,$&,$');
            $drl_new="$zz$y$xx";
		}else{
			$drl_new='drl'
		};	
       $f->COM ('input_manual_reset');
       $f->COM ('input_manual_set',
         path              =>"$gb_path/$_",
         job               =>$JOB,
         step              =>'pcb',
         format            =>'Excellon2',
         data_type         =>'ascii',
         units             =>'mm',
         coordinates       =>'absolute',
         zeroes            =>'none',
         nf1               =>3,
         nf2               =>3,
         decimal           =>'no',
         separator         =>'cr',
         tool_units        =>'mm',
         layer             =>$drl_new,
         wheel             =>'',
         wheel_template    =>'',
         nf_comp           =>0,
         multiplier        =>1,
         text_line_width   =>0.0024,
         signed_coords     =>'no',
         break_sr          =>'yes',
         drill_only        =>'no',
         merge_by_rule     =>'no',
         threshold         =>200,
         resolution        =>3);
       $f->COM ('input_manual',script_path=>'');
	}
}
####_____________________
save_job($JOB);













                  