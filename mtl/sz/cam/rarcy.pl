#!/usr/bin/perl

use File::Path;
my $fix=gmtime();
$fix =~ s/[ :]//g;
print $fix;
#my $path = "d:/work//pcb/";

#if (-d "d:/work/pcb/cy") {opendir (DH,"d:/work/pcb/cy") or die $!; @fcy =readdir DH;}

opendir (DH,"d:/work/pcb/cy") or die $!;
my @fcy =readdir DH;
#print @fcy
if ($#fcy > 1) {`d:/xxx/camp/exe/rar.exe  a  "s$JOB" "cy"`;};

