#!/usr/bin/perl
##
## zq 2011.01.13
use strict;
use Genesis;
use C;
use strict;
use Encode;
use Encode::CN;
use Tk;
my($mw,$listbox,$curselection,$ref,@drill_list,$select_file,$encode);
my (@gROWrow,@gROWlayer_type,@gROWname,@gROWcontext);
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###___________________
kysy();
$ref=info('matrix',"$JOB/matrix",'row');
@gROWrow=        @{$ref->{gROWrow}};
@gROWlayer_type= @{$ref->{gROWlayer_type}};
@gROWname=       @{$ref->{gROWname}};
@gROWcontext=    @{$ref->{gROWcontext}};
foreach  (@gROWrow) {
	push @drill_list,$gROWname[$_] if ($gROWlayer_type[$_] eq 'drill' and  $gROWcontext[$_] eq 'board');
}
####______________________________
$mw=MainWindow->new;
$mw->geometry("+200+100");
$mw->Button(-text=>'Select file',-command=>sub{
           $select_file =$mw->getOpenFile(-initialdir=>"D:/work"); 
           $encode=encode('gb2312',$select_file);
},-width=>20)->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$select_file,-width=>20,-state=>'disabled')->grid(-column=>0,-row=>1);
$listbox=$mw->Listbox->grid(-column=>0,-row=>2);
$listbox->insert('end', @drill_list);
$mw->Button(-text=>'Apply',-command=>\&apply)->grid(-column=>0,-row=>3);
MainLoop;
###_______________________________________________________________
sub apply {
	my ($curselection)=$listbox->curselection();
    open(FH,"$encode") or die $!;
	my @text=<FH>;
	@text=grep /\bHolesize\b/,@text;
	exit unless @text;
	$f->COM ('tools_tab_reset',);
    foreach (@text){
		my $tool;
        my @line=split " ",$_;
        my ($tool_1,$tool_3,$size,$attribute,$units)=@line[0,2,4,8,9];
        $tool_1 =~ s/;//g;
        $tool_3 =~ s/\.//g;
        $attribute =~ s/NON_/n/g;
    	$attribute =~ s/PLATED/plate/g;
        ($tool_1=~/T/) ? (($tool)=grep s/T//g,$tool_1) : ($tool=$tool_3) ;
        $units =~/MM/ and $size *= 39.37;  
        #p__ ("$tool  $size  $attribute $units  $drill_list[$curselection]");
        $f->COM ('tools_tab_add',
	    	     num         =>$tool,
	    	     type        =>$attribute,
	    	     type2       =>"standard",
	    	     min_tol     =>0,
	    	     max_tol     =>0,
                 bit         =>'',
			     finish_size =>$size,
			     drill_size  =>$size);
		$f->COM ('tools_set',
			     layer       =>$drill_list[$curselection],
			     thickness   =>0,
			     user_params =>'');
	}
	clear($drill_list[$curselection]);
    $f->COM ('filter_reset',filter_name=>'popup');
    $f->COM ('clear_highlight');
    $f->COM ('filter_set',filter_name=>'popup', update_popup=>'yes', feat_types=>'pad');
    $f->COM ('filter_atr_set',filter_name=>'popup',condition=>'yes',attribute=>'.drill',option=>'non_plated');
    $f->COM ('filter_area_strt');
	$f->COM ('filter_highlight');

    exit;
}

=head
    #$f->COM ('filter_area_end',
	#         layer          =>'',
	#         filter_name    =>'popup',
    #       	 operation      =>'select',
    # 	     area_type      =>'none',
    #     	 inside_area    =>'no',
    #    	 intersect_area =>'no',
    #    	 lines_only     =>'no',
    #     	 ovals_only     =>'no',
    #    	 min_len        =>0,
	#         max_len        =>0,
    #     	 min_angle      =>0,
	#         max_angle      =>0);





