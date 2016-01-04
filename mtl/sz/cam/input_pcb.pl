#!/usr/bin/perl
## zq 2009.08.14
use strict;
use Genesis;
use FBI;
use Tk;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###________________________
kysy();

##if not step pcb ,creat it;
if ( exists_entity('step',"$JOB/pcb") eq 'no' ) {
	creat_step($JOB,'pcb');
}

my $gb_path = "D:/work/pcb";
opendir (DH,$gb_path);
my @gb_list=readdir DH;
foreach (@gb_list){
    if ($_ =~ m/\.gbr$/ig){
		my $gb_new=lc $_;
		my $pre = "$JOB"."-";
	
        $gb_new =~ s/^$pre//ig; 
        $gb_new =~ s/\.gbr$//ig;  
		$gb_new =~ s/[tb]$//ig;  
		##p__("$gb_new");
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













                  