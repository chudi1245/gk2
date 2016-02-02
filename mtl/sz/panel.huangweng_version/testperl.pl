#!/usr/bin/perl


foreach (0..80) {
	print;
	}

=head
##设定一个数组，存储100个变量，从-1英寸 到 正1英寸
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
##第一次取数组中的某一个值
my $flag=int(rand(100));
my $randsha=$a[$flag];
##第二次取数组中的某一个值
my $flag1=int(rand(100));
my $randxia=$a[$flag1];
##上面的变化值设为randSmall，下面的变化值为randSmall
##如果上面为负数，则反方向移动。如果上面为正数，则相对移动。

if($randsha<=0){ 
	$randxia =   abs($randxia);
}else{  
	$randxia = -(abs($randxia));
}


print "top: $randtop\n";
print "sha: $randsha\n";
print "xia: $randxia\n";
