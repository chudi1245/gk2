#!/usr/bin/perl


foreach (0..80) {
	print;
	}

=head
##�趨һ�����飬�洢100����������-1Ӣ�� �� ��1Ӣ��
my @a;
my $b=-1;
foreach (0..100) {
	push @a,$b;
	$b+=0.02;
	}

my $randtop,
my $randsha; 
my $randxia; 

while ( abs($randtop) < 0.04){
	$randtop=rand(0.5)-0.35;
	}
##��һ��ȡ�����е�ĳһ��ֵ
my $flag=int(rand(100));
my $randsha=$a[$flag];
##�ڶ���ȡ�����е�ĳһ��ֵ
my $flag1=int(rand(100));
my $randxia=$a[$flag1];
##����ı仯ֵ��ΪrandSmall������ı仯ֵΪrandSmall
##�������Ϊ�������򷴷����ƶ����������Ϊ������������ƶ���

if($randsha<=0){ 
	$randxia =   abs($randxia);
}else{  
	$randxia = -(abs($randxia));
}


print "top: $randtop\n";
print "sha: $randsha\n";
print "xia: $randxia\n";
