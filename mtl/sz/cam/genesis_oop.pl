#!/usr/bin/perl

use strict;
use Tk;
####________new
sub new {
	my @default=('x-name',0,0,'di20x20','no','no');
	my $long=$#_;
	@default[0..$long]=@_;
	my ($name,$x,$y,$symbol,$mirror,$rotate)=@default;
	my $element={
		    'name'  =>$name,
			'x'     =>$x,
			'y'     =>$y,
			'symbol'=>$symbol,
			'mirror'=>$mirror,
			'rotate'=>$rotate,
	};
		bless $element;
		return $element;
}
####__________get
sub get {
	my $oop=shift;
	my $attribute=shift;
	my $value=$oop->{$attribute};
	return $value;
}
####__________change
sub change {
	my $oop=shift;
	my $attribute=shift;
	my $new_value=shift;
	$oop->{$attribute}=$new_value;
}
###____________________________________________________________________________________________________



my $sypad=new ('sypad',10,20,'r654');
print $sypad->get("symbol"),"\n";
$sypad->change("symbol","xsdfg",'fgh');
print $sypad->get("symbol");