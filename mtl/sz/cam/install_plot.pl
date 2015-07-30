#!/usr/bin/perl
#**************************************************************
# 程序名称：统一配置文件
#**************************************************************
use strict;
#####____________________________________________________________
my $bindings= << 'EOF_2';

   BINDING {
       KEY=F5
       SCRIPT=C:/genesis/sys/scripts/plot/output_auto_scale.exe
   }
   BINDING {
       KEY=F8
       SCRIPT=C:/genesis/sys/scripts/plot/output_scale.exe
   }
   BINDING {
       KEY=F12
       SCRIPT=C:/genesis/sys/scripts/plot/output_sig_film.exe
   }

EOF_2

open (FH_2,"> $ENV{USERPROFILE}/.genesis/bindings") or warn "$!";
print FH_2  $bindings;
close FH_2;

open (FH_2,"> C:/genesis/sys/bindings") or warn "$!";
print FH_2  $bindings;
close FH_2;

print "绑定快键OK!!.....2012-5-31........休息3秒自动关闭\n";
sleep 3;


