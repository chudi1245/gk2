#!/bin/perl -w


$a = 'l2t';
($a=~ m/\d[tb]$/g)  ? ($fn8=''):($fn8='8888');

print $fn8;

=h
##############################start
$a = 'l10t';

if ($a gt 9) {print $a;
}


my @bb = (25,35,45);
my $aa = \@bb;
print "@{$aa}";
零件号，CustmerGoodsCode
原文件名：goodsName

my $book=[
    { x=>$main::px-0.18,  y=>$main::py-0.18 },
	{ x=>0.18,			  y=>$main::py-0.18 },
	{ x=>0.18,            y=>0.5      },
	{ x=>$main::px-0.18,  y=>0.18     },
];

print $book->[2]{y};

##############################end

##############################start
my($margin_top,$margin_bot,$margin_rig,$margin_lef)=qw(5 5 5 5);

$margin={top=>5,bot=>5,lef=>5,rig=>5,};

print "$margin_top";
##############################end

##############################start
my @time=gmtime;
my ($year, $moon, $date)=($time[5]+1900, $time[4]+1, $time[3]);


	print "$time[3]";
##############################end

##############################start
$name = "gts-1";
if ($name =~ m/ts/i ) {

	print "is ok!";
}
##############################end


##############################start
@Aoa = (    ["fred", "barney" ],
			["george", "jane", "elroy" ],
			["homer", "marge", "bart" ], );

				print "$Aoa[2][1]";     
				
# 打印 "marge"
 
##############################end


##############################start
@sypad=( 
     {x=>1,  y=>2},
     {x=>3,  y=>4},
	 {x=>5,  y=>6},
     {x=>7,  y=>8},
     {x=>9,  y=>0},      
);

print $sypad[0]{y};
###############################end


##############################start
$sypad=[
 
     {x=>1,  y=>2},
     {x=>3,  y=>4},
	 {x=>5,  y=>6},
     {x=>7,  y=>8},
     {x=>9,  y=>0},      
];

print $sypad->[3]{x};


###############################end

###############################start
  @AoA = ([2, 3], [4, 5, 7], [0] );
  
  
  print "@AoA\n";

  print $AoA[1][1];
##############################end


##############################start
##@_ 在某个函数内，数组 @_ 包含传递给该函数的所有参数。
##$_ 默认的输入/输出和格式匹配空间
##--------------------------------------------------------------------------------------------------------
###@_的示例：

use strict;
&fun( 111,222,333 );
sub fun()
{
 print @_; #####这里会把传入函数的参数111222333打印出来
}
##############################end


##############################start
$question = "expleaseding";

if ($question =~ /ding/) 
{  print"Thank you for being polite";   }
   
   else 
   
   { print"That was not very polite";   }

##############################end

##############################start
$a = %12.8;

$b = ($a - int("$a"))/2;


###$b=$a/2;


print $b;
##############################end

=h


=head

###&File::Find::find(\&wanted,"C:\\httpd", "C:\\testing");
###sub wanted{
###      (Win32::File::GetAttributes($_,$attr)) &&
###      ($attr & DIRECTORY) &&
###      print "$File::Find::name\n";
###}

####__________
####windows

$dir_name= <> ; 
opendir(DIR,   $dir_name)   ||   die   "Can 't   open   directory   $dir_name "; 
@dots   =   readdir(DIR); 
foreach   (@dots){ 
print; 
print   "\n "; 
} 
closedir   DIR;
###_____________

opendir(DIR,   $dir_name)   ||   die   "Can 't   open   directory   $dir_name "; 
@dots   =   readdir(DIR); 
foreach     (@dots){ 
                print; 
                print   "\n "; 
} 
closedir   DIR;
##________________

##____
$destdir="d://xiaowang"; 
$sourfilename="tuo.plx";
$destfilename="tuohuang.plx";

print "$destdir and $sourfilename and $destfilename<br>;";

opendir (TMP, "$destdir") or die "cant open c:/temp : $!"; 
@dirname=readdir(TMP);
foreach (@dirname)
{
        print "$_ <br>;";
        if ($_ =~ "$sourfilename") 
        {
                print "$sourfilename and $destfilename<br>;";
                rename ($sourfilename,$destfilename) or die "Cannot rename file: $!";
                print "Changed OK \n";
        }
}
closedir (TMP);

##_______________


#!/usr/bin/perl
# This Perl srcipt writen by forrest.w
# usage: chname.pl c:\\temp file1.txt  mynamefile.txt
$destdir=shift;
$sourfilename=shift;
$destfilename=shift;

opendir (TMP, "$destdir" or die "cant open c:/temp : $!";
@dirname=readdir(TMP);
foreach (@dirname) {
        print "$_ \n";
        if ($_ =~ "$sourfilename" {
                rename ( $sourfilename ,  $destfilename )  or die "Cannot rename file: $!";
                print "Changed OK \n";
        }
        
}
closedir (TMP);

##________________________