#!/usr/bin/perl
##transform the words in the select file "D10 D11" to "one-D226 four-D233"
##zq 2010.12.28
use strict;
use Tk;
use Encode;
use Encode::CN;
use Win32;
my ($mw,$text,$select_file,$encode,$flag);

kysy();

####______________________________
$mw=MainWindow->new;
$mw->title('Better and better');
$mw->Button(-text=>'Select file',-command=>\&transf,-width=>20)->grid(-column=>0,-row=>0);
$mw->Entry(-textvariable=>\$select_file,-width=>46,-state=>'disabled')->grid(-column=>0,-row=>1);
$text=$mw->Text(-width=>40)->grid(-column=>0,-row=>2);
tie *STDOUT, ref $text, $text;
$mw->Button(-text=>'Apply',-command=>\&apply)->grid(-column=>0,-row=>3);
MainLoop;
###_________________________________
sub apply {
	if ($select_file) {
        open(FHW,">$encode") or die $!;
		print FHW $text->get("1.0", "end");
	    close FHW;
	    return;
	}else{
		$text->delete("1.0", 'end');
		$text->insert('end',"cant open the select file");
	}
}

sub transf {
	my $content=get_content();
	my @line=split "\n",$content;
	my $number= grep m{\bG54D1[10]}ig, @line ;
	if ($number == 2 ) {
		number_2($content);  
	}elsif ($number == 4 ) {
		number_4($content); 
	}else{
		$text->delete("1.0", 'end');
		print $content;
	}
}


sub get_content {
	$select_file =$mw->getOpenFile;
    $encode=encode('gb2312',$select_file);
	open(FHR,"$encode") or die $!;
	my $line;
	while (<FHR>) {
	    $line.=$_;
	}
	return $line;
}



sub number_2 {
	my $cont=shift;
	my $regx=$cont =~ m{G54(D1[01])\*([^<]*?)G54(D1[01])\*}i;
    if ($regx) {
		 my ($flag,$mid_word,$flag_2)=($1,$2,$3);
		 my @line_mid_word=$mid_word =~ m{\n}g;
		 if ($#line_mid_word > 2) {
			 $cont =~ s/$flag/D233/g;
			 $cont =~ s/$flag_2/D226/g;
		 }else{
			 $cont =~ s/$flag/D226/g;
			 $cont =~ s/$flag_2/D233/g;
		 }
		 $text->delete("1.0", 'end');
		 my $ii=1;
		 foreach  (split "\n",$cont) {
			 $text->insert('end',"$_\n",$ii);
			 ( $_=~m{D226} or $_=~m{D233} ) ? ( $text->tagConfigure($ii,-foreground =>"red") ) : ( $text->tagConfigure($ii,-foreground =>"black") );
			 $ii++;
		 }
	}
}


sub number_4 {
	my ($s_d11,$s_d10);
	my $cont=shift;
	my @line=split "\n",$cont;
	my $id=grep m{\bG54D11}ig,@line;
	if ($id == 3) {
		$s_d11='D233';
		$s_d10='D226';
	}else{
		$s_d11='D226';
		$s_d10='D233';
	}
	$text->delete("1.0", 'end');
	my $i=1;
	foreach  (@line) {
		my $tmp=$_;
		$tmp =~ s/[dD]10/$s_d10/;
		$tmp =~ s/[dD]11/$s_d11/;
		$text->insert('end',"$tmp\n",$i);
		( $tmp=~m{D2[23][36]} ) ? (  $text->tagConfigure($i,-foreground =>"red")  ) : (  $text->tagConfigure($i,-foreground => "black")  );
		$i++;
	}
}

 


=head


