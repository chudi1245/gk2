#!/usr/bin/perl
##ɾ���û�Ŀ¼�µ������ļ�
##Ȼ�����sys�µ������ļ�

my $username;
my  $Sys_name = $^O;
if ($Sys_name =~ /MSWin32/){
   print $ENV{'USERNAME'},"\n";
   $username = $ENV{'USERNAME'};
}
else {
     if($Sys_name =~ /linux/){
          print $ENV{'USER'},"\n";
		  $username =  $ENV{'USER'};
     }
    else
    {
         print "Unknow\n";
     }
}

$configfile = "C:/Documents and Settings/$username/.genesis/config";
if (-f $configfile ) {
	print "$configfile is exist";
	unlink $configfile;
}

my $hgap = 0;
my $vgap = 0;
my $contect;

my $sysconfig = "C:/genesis/sys/config";
open (IN, "<$sysconfig") or die "can't open  the $sysconfig:$!";
my @lines = <IN>;
foreach my $line (@lines) {
	if ($line =~ /edt_sredit_hgap=.*/ig) {
		$line =~ s/(edt_sredit_hgap)=(\d.*)/$1=78.74/ig;
		$hgap = 1;
	}	
		if ($line =~ /edt_sredit_vgap=.*/ig) {
		$line =~ s/(edt_sredit_vgap)=(\d.*)/$1=78.74/ig;
		$vgap = 1;
	}
	$contect.=$line;
}
close IN;

if ($hgap == 0) {
  $contect.="edt_sredit_hgap=78.74\n";
}
if ($vgap == 0) {
  $contect.="edt_sredit_vgap=78.74\n";
}
print $contect;


open (WF, ">$sysconfig") or die "can't write the $sysconfig:$!";
print WF $contect;
close WF;

&vigui();

sub vigui {
	use Win32;
	use  encoding  'euc_cn' ; 
	my $mw = MainWindow->new(-title => "Write by Mobin" ); 
	$mw->geometry("280x50+200+180");
	$code_font = $mw->fontCreate(-family =>  '����',-size =>  16); 
	$mw->Button(-text => "�����ļ����³ɹ�!", -font => $code_font,-command => sub { exit })->pack( -fill => 'both'); 
	MainLoop
}
=head

#open (OUT,">>$sysconfig") or die "can't write the $sysconfig: $!";
#while (<IN>) {
#	print ;
#	s/(edt_sredit_hgap)=(\d.*)/$1=78.74/ig;
#	s/(edt_sredit_vgap)=(\d.*)/$1=78.74/ig;
#	#print OUT $_;
#}
