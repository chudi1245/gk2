#! /usr/bin/perl 
my (%scale_x,%scale_y);

open (FILE,"c:/genesis/fw/jobs/m46929/output/scal.log") or die "cant open file : $!";
my @layerName=(<FILE>);
close FILE;


my ($cen,$cenx,$ceny,$name);
			
foreach (0..$#layerName)
  {
($cen,$cenx,$ceny)=split ' ', $layerName[$_];

$scale_x{$_}=$cenx;
$scale_y{$_}=$ceny;

#print "$cen $cenx $ceny \n";

print "$scale_x{$_} $scale_y{$_} \n";

  }

#foreach my $value (values %scale_x) {
#	print "$value\n";
#}

#foreach my $key (keys %scale_x) {
#	print "$key\n";
#}
=head


pcb�����Ż�


��������

ɾ�����в�������

��ת����

���������߿�

���ѣ����ε���0.5MM������

�����ڲ㸺Ƭ����



