#!/usr/bin/perl 

##Modified Step: pcb   @filepath=split m{ },$jobfile;
##Modified Layer: l13b
my $str = "Modified Step: orig ";

my @arr = split (/ /,$str);

print $arr[2];


=head

open (FILE,"d:/a.txt" )or die "$!";
my @arr=<FILE>;
close FILE;
my $last=$arr[$#arr];
print $last;

open (FILE,"file.txt") or die "$!";
while (<FILE>;)
{
    open (TMP,">;","tmp.txt") or die "$!";
    print TMP $_;
    close TMP;
}
close FILE;



$text = "T01C003175\\18";

$text =~ m/(^T\d{2})(C\d{2})(\d{4})/ig;  
print $1;print "\n";
print $2;print "\n";
print $3;print "\n";

$a = ' bedbugs bite';
$a =~ m" (bedbug)"; # sets $1 to be bedbug.
$b = ' this is nasty';
$b =~ m" (nasti)"; # does NOT set $1 (nasti is not in ' this is nasty' ).
# BUT $1 is still set to bedbug!
print $1; # prints ' bedbug'.
$jobfile = "D:/worut/output/m51560-2.drl";

$jobfile =~ s/[\/\\]/ /ig; 

@filepath=split m{ },$jobfile;

$bfile = $filepath[$#filepath];
$bfile =~ s/[.drl]//ig;
$bfile =~ s/m51560/drl/ig;

	print $bfile;

if ($bfile =~ m/[m51560]/ig) {

	print $bfile;

	}
 $text[$_] =~ s/[\\\/c]/ /ig;   
	my @word=split m{ },$text[$_];

my @k = qw(1 2 3 4 5);
my @v = qw(a b c d e);

my %h = map {$k[$_], $v[$_]} (0..$#k);

for

$text = "T01C003175\\18";
$text =~ s/[\\\/c]/ /ig;   
my @word=split m{ },$text;
$word[1]/=1000;
print "$text\n";
print "$word[1]\n";

$str = "r808";
$a = substr $str, 1, 4;         # �ɵ�һ����Ԫ�_ʼ��ȡ 5 ����Ԫ�L��
print $a;                       # �ã�ABCDE




 34���ڱ���hash������:$info="Caine:Michael:Actor:14,LeafyDrive"; 
 @personal=split(/:/,$info);    #@personal=("Caine","Michael","Actor","14,LeafyDrive");
 
 @personal=split(/:/);   #��������Ѿ�����Ϣ�����$_�����У���ô����������
 
 $_="Capes:Geoff::Shotputter:::BigAvenue";    #����������κ�������ð�ŷָ���������RE������зָ 
 
 @personal=split(/:+/);  # �����ǣ�@personal=("Capes","Geoff","Shotputter","BigAvenue");
 print $personal[0];
 print $personal[1];
 =head
 //֮��Ĳ��ֱ�ʾsplit�õ���������ʽ������˵�ָ�����
 \s��һ��ͨ���������ո�
 +�����ظ�һ�λ���һ�����ϡ�
 ���ԣ�\s+����һ������һ�����ϵĿո�
 split(/\s+/,$line)��ʾ���ַ���$line,���ո�Ϊ��ֿ���
 ����˵��$line="������ѻ�ӭ�����ҵĲ���61dh.com"��
 split(/\s+/,$line)��õ�
 33. []
 ��ο�OReilly.Intermediate.Perl.Mar.2006��5.5. Creating an Anonymous Array Directly
 
 34. About keys
 Please refer to: http://perldoc.perl.org/functions/keys.html 
 Here comes some sample code:
 1.	    @keys = keys %ENV;
 2.	    @values = values %ENV;
 3.	    while (@keys) {
 4.	        print pop(@keys), '=', pop(@values), "\n";
 5.	    }
 or how about sorted by key:
 1.	    foreach $key (sort(keys %ENV)) {
 2.	        print $key, '=', $ENV{$key}, "\n";
 3.	    }
 
 