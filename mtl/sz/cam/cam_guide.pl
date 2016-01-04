#!/usr/bin/perl
use strict;
use Tk;
use lib "D:/xxx/camp/lib";
use Win32;
use Encode;
use POSIX qw/strftime/;

####____________________________________
my ($column,$row,);

require "D:/xxx/camp/lib/data_name.pl";
my %data_name=%DATA_NAME::data_name;
my %name_data;
map {  $name_data{$data_name{$_}[0]}=$_   }( keys %data_name );

use encoding 'utf8';



my %label_cn=(order=>   ['序号',    0, 4, ],
              
              name=>    ['名称',    1, 15,],
			  state=>   ['状态',    2, 4, ],
			  user=>    ['用户',    3, 8, ],
			  str_time=>['开始时间',4, 10,],
			  end_time=>['结束时间',5, 10,] , 
			  result=>  ['结果',    6, 10,],
);

no encoding 'utf8';



##___________________________________
my $mw=MainWindow->new;
$mw->configure(-menu => my $menubar = $mw->Menu);
my $file = $menubar->cascade(-label => '~File');
my $edit = $menubar->cascade(-label => '~Edit');
my $help = $menubar->cascade(-label => '~Help');

map {$mw->Label(-text => $label_cn{$_}[0],-width=>$label_cn{$_}[2] )->grid(-column=>$label_cn{$_}[1],-row=>0)} (keys %label_cn);

my $t = $mw->Scrolled("Text", -width => 90, -wrap => 'none')->grid(-column=>0,-row=>1,-columnspan=>8);

my $wid;
foreach  ( sort{$a<=>$b} keys %name_data ) {
	
	my $key=$name_data{$_};
	my $arr_ref=$data_name {$key};
	my $name=decode('utf8',$arr_ref->[1]);

	my $w = $t->Label(-text => $_,-width=>2 );
	$t->windowCreate('end', -window => $w);

	$wid->{name}{$key} = $t->Button(-text => $name,-width=>16 ,-font=>"courier 9",-command=>[\&run_script,'name',$key,$arr_ref],
		              -activebackground=>'#990000',-background=>'#009900');
	$t->windowCreate('end', -window => $wid->{name}{$key});     ####   script name



    $arr_ref->[2]=1;
	$w= $t->Optionmenu(-options=>[1,2,5], -variable => \$arr_ref->[2],  -command=>[\&set_state,$key,$arr_ref] );  ###state
    $t->windowCreate('end', -window => $w);



	$w = $t->Label(-textvariable => \$arr_ref->[3] ,-width=>7 ,-relief=>'sun');  ###[3] record user
	$t->windowCreate('end', -window => $w);

	$w = $t->Label(-textvariable => \$arr_ref->[4] ,-width=>20 ,-relief=>'sun');  ###[4] record stratr time
	$t->windowCreate('end', -window => $w);

	$w = $t->Label(-textvariable => \$arr_ref->[5] ,-width=>20 ,-relief=>'sun');  ###[5] record end time
	$t->windowCreate('end', -window => $w);

	$w = $t->Entry(-textvariable => \$arr_ref->[6] ,-width=>20 ,);  ###[6] record end time
	$t->windowCreate('end', -window => $w);

    $t->insert('end', "\n");
}

MainLoop;
sub run_script{
	my $id=shift;
	my $key=shift;
	my $ref=shift;
	$wid->{$id}{$key}->configure(-background=>'#999999');
	$ref->[2]=5;






	$ref->[4]= localtime();

}
sub set_state{
	my $key=shift;
	my $ref=shift;

	if ($ref->[2] == 1) {
		$wid->{name}{$key}->configure(-background=>'#009900');

	}
	
	print $ref->[2],"\n";


}

