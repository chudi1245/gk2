#!/usr/bin/perl 
##    zhouqing 
use strict;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
my ($t,@display,$ref,@row,@row_name,@row_type)=(1,);

##______________________

kysy();


$f->COM ('get_disp_layers'); 
@display = split  ' ',$f->{COMANS};
exit unless @display;
$ref=info('matrix', "$JOB/matrix",'ROW');
@row_name =@{$ref->{gROWname}};
@row=@{$ref->{gROWrow}};
clear();
foreach  (0..@row_name) {
	my $i=$_;
	foreach  (@display) {
		if ($_ eq $row_name[$i]) {
			 $f->COM ("display_layer",name=>$row_name[$i+1],display=>'yes',number=>$t++) if $row_name[$i+1];
		};	
	}
}

=head