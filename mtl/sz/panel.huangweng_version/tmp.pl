###############################��BB�滻ΪBBI��
foreach  (0..2) {
	print;
}

=head
my $rand;
while ( abs($rand) < 0.12) { $rand=rand(0.5)-0.35; }

$rand = sprintf "%6.2f",$rand;
#print "$rand\n";

$b=-1;
foreach (0..100) {
push @a,$b;
	$b+=0.02;
}
print $a[2];
my $randBig=int(rand(101));

#print $randBig;

=head

my $filepath = "c:/genesis/fw/jobs/m45308/output/net.log";


###print $filepath;
if (-e $filepath) {
open (FILE,"$filepath");
my $result = (<FILE>);
my @result=split ' ',$result;
close FILE;
print $result[0];
if ($result[0]!=0 and $result[1]!=0 ) {
	
	exit;
  }
	} else{
	    exit;
}

print "what is your name";


###############################


=head 
open IN,"<","E:\\��ҩ\\drugBank\\DB_name_cas_2324.txt"or die "$!";
open IN_2,"<","E:\\��ҩ\\drugBank\\a.txt"or die "$!";
my $text = do{$/=undef;open IN_2,"<","E:\\��ҩ\\drugBank\\a.txt";<IN_2>};
open OUT,">","E:\\��ҩ\\drugBank\\cas_cas.txt"or die "$!";
	while (<IN>) {
		chomp;
		my @a = split /;/,$_;
		print "$a[1]\->$a[2]\n";
		$text =~ s/$a[1]/$a[2]/gi;
	}
print OUT $text;
close IN;
close IN_2;
close OUT;
���ǿ�����һ��
����д�Ͳ�����
1;


