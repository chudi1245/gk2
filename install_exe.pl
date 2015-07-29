#!/usr/bin/perl
use strict;
my $scr_start= << 'EOF';
#!/bin/csh
if($?GENESIS_DIR)then
  set _genesis_root=$GENESIS_DIR
else
  set _genesis_root=/genesis
endif
if($?GENESIS_EDIR)then
  set _genesis_edir=$GENESIS_EDIR
else
  set _genesis_edir=e$GENESIS_VER
endif
if($_genesis_edir =~ /* || $_genesis_edir =~ ?:*)then
  set path=($_genesis_edir/all $path)
else
  set path=($_genesis_root/$_genesis_edir/all $path)
endif
set STATUS=0
set PROG=$1
##$1 the script name
if(! -e $PROG)then
  set PROG_STATUS=1
  goto end
endif
# define aliases
set DIR_PREFIX='@%#%@'
alias VON 'echo "${DIR_PREFIX}VON";'
alias VOF 'echo "${DIR_PREFIX}VOF";'
alias SU_ON  'echo "${DIR_PREFIX}SU_ON";'
alias SU_OFF 'echo "${DIR_PREFIX}SU_OFF";'
alias PAUSE 'echo "${DIR_PREFIX}PAUSE \!:*"; \\
   set STATUS=$<; set READANS=$<; set PAUSANS=$<; \\
   if ($PAUSANS != "OK") exit'
alias MOUSE 'echo "${DIR_PREFIX}MOUSE \!:*"; \\
   set STATUS=$<; set READANS=$<; set MOUSEANS="$<"'
alias COM 'echo "${DIR_PREFIX}COM \!:*"; \\
   set STATUS=$<; set READANS="$<"; set COMANS=($READANS)'
alias AUX 'echo "${DIR_PREFIX}AUX \!:*"; \\
   set STATUS=$<; set READANS="$<"; set COMANS=($READANS)'
set argv = ($2)
#executing hook script
if(-e $_genesis_root/sys/hooks/script_start.csh)then
   source $_genesis_root/sys/hooks/script_start.csh
endif
# check first line of program
#set _HEAD=`head -1 $PROG`    Yefim 02.06.04
set _HEAD=`sed -n 1p $PROG`
##zq
set _EXT=`echo $PROG:e` 
##
##zq
if("$_HEAD" =~ *perl*)then
   echo "Executing Perl Program $PROG $argv"
   perl $PROG $argv
   set PROG_STATUS=$status
else if("$_HEAD" =~ *python*)then
   echo "Executing Python Program $PROG $argv"
   python $PROG $argv
   set PROG_STATUS=$status
##zq
else if ("$_EXT" =~ [Ee][Xx][Ee]) then
   echo "Executing Compiled Program $PROG $argv"
   $PROG $argv
   set PROG_STATUS=$status 
##zq
else if("$_HEAD" =~ *wish*)then
   setenv TCSHONLYSTARTEXES 1
   echo "Executing TCL Program $PROG $argv"
   $_genesis_root/sys/hooks/wish_start.tcl $PROG $argv
   set PROG_STATUS=$status
else
   echo "Executing C Shell Program $PROG"
   source $PROG
   set PROG_STATUS=$status
endif
end:
exit($PROG_STATUS)

EOF
open (FH,"> C:/genesis/e92/all/scr_start.csh") or die "$!";
print FH $scr_start;
close FH;
print "rewrite 1 ok\n";

#####____________________________________________________________
my $bindings= << 'EOF_2';

   BINDING {
       KEY=F2
       SCRIPT=D:/xxx/camp/exe/creat_job.exe
   }
   BINDING {
       KEY=F3
       SCRIPT=D:/xxx/camp/exe/open_job.exe
   }
   BINDING {
       KEY=F9
       SCRIPT=D:/xxx/camp/exe/tk_cam.exe
   }

   BINDING {
       KEY=F12
       SCRIPT=D:/xxx/camp/exe/transformation.exe
   }
   BINDING {
       KEY=F5
       SCRIPT=D:/xxx/camp/exe/dis_next_lay.exe
   }
   BINDING {
       KEY=F10
       SCRIPT=D:/xxx/camp/exe/change_unit.exe
   }
   BINDING {
       KEY=<Shift>F2
       SCRIPT=D:/xxx/camp/exe/break.exe
   }
   BINDING {
       KEY=<Shift>F3
       SCRIPT=D:/xxx/camp/exe/contourize.exe
   }

EOF_2

open (FH_2,"> $ENV{USERPROFILE}/.genesis/bindings") or die "$!";
print FH_2  $bindings;
close FH_2;
print "rewrite 2 ok\n";

####________________________________________________________________
my $userattr = << 'EOF_3';

# Feature attributes 
BOOLEAN {
  NAME   = Date_Code
  ENTITY = FEATURE
}
BOOLEAN {
  NAME   = Gold_Finger
  ENTITY = FEATURE
}

OPTION {
  NAME    = .ZK
  ENTITY  = FEATURE
  OPTIONS = top;bot;rig;lef;lef2
  CATEGORY= FEATURE
}

EOF_3

open ( FH_3,  "> C:/genesis/fw/lib/misc/userattr" ) or die "$!";
print FH_3  $userattr;
close FH_3;
print "rewrite 3 ok\n";
###________________________________________________________________
my $genesispl = << 'EOF_4';

require 5.003;
require Exporter;
require 'shellwords.pl';
my $version = '2.0';

use Socket; 
@ISA       = qw(Exporter);


$socketOpen = 0 ;
$DIR_PREFIX = '@%#%@' ; 

END { 
    if ($socketOpen == 0 ) { 
          return ; 
    }
    send(SOCK, "${DIR_PREFIX}CLOSEDOWN \n", 0);
    close (SOCK) || warn "close: $!";
}

sub new { 
    local $class  = shift; # name
    local $remote = shift;
    local $genesis;

    $remote = 'localhost' unless defined $remote;

    # If standard input is not a terminal then we are a pipe to csh, and hence
    # presumably running under Genesis. In this case use stdin and stdout as is.
    # If, on the other hand, stdin is a tty, then we are running remotely, in which case
    # set up the communications, namely the socket, so that we communicate.  

    $genesis->{remote} = $remote;
    $genesis->{port} = 'genesis'; 

    bless $genesis, $class; 

    $genesis->{comms} = 'pipe';
    if (-t STDIN) { 
	$genesis->{comms} = 'socket'; 
	$genesis->openSocket();
	$genesis->{socketOpen} = 1;
	$genesis->inheritEnvironment();
    }
    binmode(STDOUT);
    return $genesis; 
}
sub closeDown { 
    local ($genesis) = shift;
    $genesis->sendCommand("CLOSEDOWN","");     
}

sub inheritEnvironment {
    local ($genesis) = shift;
    $genesis->sendCommand("GETENVIRONMENT","");     
    while (1) { 
	$reply = $genesis->getReply();
	if ($reply eq 'END') { 
	    last;
	}
	($var,$value) = split('=',$reply,2);
	$ENV{$var} = $value;
    }
    # And here is a patch for LOCALE. IBM AIX defines LC_MESSAGES and LC__FASTMSG
    # which are not right if you are running remotely
    undef $ENV{LC_MESSAGES}; 
    undef $ENV{LC__FASTMSG};
}

=head
sub DESTROY { 
    local ($genesis) = shift;
    $socketOpen -- ; # reduce reference count
    if ($socketOpen) { 
	return ;
    }
    if ($genesis->{socketOpen}) { 
        $genesis->closeDown() ;
	close (SOCK) || warn "close: $!";; 
    }
}
=cut


sub openSocket { 
    local ($genesis) = shift;
    local ($remote,$port, $iaddr, $paddr, $proto);
    $socketOpen ++  ;
    return if $socketOpen != 1 ; 
    $port = $genesis->{port} ;
    $remote = $genesis->{remote};
    
    if ($port =~ /\D/) { 
	$port = getservbyname($port, 'tcp');
    }

    if (! defined $port) {
        $port = 56753;
# The port has not been defined. To define it you need to 
# become root and add the following line in /etc/services 
# genesis     56753/tcp    # Genesis port for debugging perl scripts
    }
    $iaddr = inet_aton($remote) || die "no host: $remote";
    $paddr = sockaddr_in($port, $iaddr);
    $proto = getprotobyname('tcp');
    socket(SOCK, PF_INET, SOCK_STREAM, $proto) || die "socket: $!";
    connect(SOCK, $paddr) || die "connect: $!";
}



# remove excess white space
sub removeNewlines {
    local($command) = shift;
    $command =~ s/\n\s*/ /g;
    return $command;
}

# send the command to be executed
sub sendCommand { 
    local($genesis) = shift; 
    local $commandType = shift;
    local $command = shift;
    
    $genesis->blankStatusResults();
    if ($genesis->{comms} eq 'pipe') { 
	$genesis->sendCommandToPipe($commandType,$command); 
    } elsif ($genesis->{comms} eq 'socket') { 
	$genesis->sendCommandToSocket($commandType,$command); 
    }
}

sub sendCommandToPipe { 
    local($genesis) = shift; 
    local $commandType = shift;
    local $command = shift;
    local $old_select = select (STDOUT);
    local $flush_status = $|;	          # save the flushing status
    $| = 1;			          # force flushing of the io buffer
    print $DIR_PREFIX, "$commandType $command\n";
    $| = $flush_status;		          # restore the original flush status
    select ($old_select);    
}

sub sendCommandToSocket { 
    local($genesis) = shift; 
    local $commandType = shift;
    local $command = shift;
    send(SOCK, "${DIR_PREFIX}$commandType $command\n", 0);
    # should check for errors here !!!
}

# wait for the reply
sub getReply {
    local $reply; 
    if ($genesis->{comms} eq 'pipe') { 
	chomp ($reply = <STDIN>);  # chop new line character
    } elsif ($genesis->{comms} eq 'socket') { 
	chomp ($reply = <SOCK>);  # chop new line character
    }
    return $reply;
}

# Checking is on. If a command fails, the script fail
sub VON {
    local ($genesis) = shift;
    $genesis->sendCommand("VON", "");
}


# Checking is off. If a command fails, the script continues
sub VOF {
    local ($genesis) = shift;
    $genesis->sendCommand("VOF", "");
}


# Allow Genesis privileged activities. Normally this is executed at the 
# start of each script.
sub SU_ON {
    local ($genesis) = shift;
    $genesis->sendCommand("SU_ON", "");
}

sub SU_OFF {
    local ($genesis) = shift;
    $genesis->sendCommand("SU_OFF", "");
}
sub blankStatusResults {
    local ($genesis) = shift;
    undef $genesis->{STATUS}; 
    undef $genesis->{READANS}; 
    undef $genesis->{PAUSANS}; 
    undef $genesis->{MOUSEANS}; 
    undef $genesis->{COMANS}; 
}

# Wait for a reply from a popup
sub PAUSE {
    local ($genesis) = shift;
    local ($command) = @_;
    $genesis->sendCommand("PAUSE", removeNewlines($command));
    $genesis->{STATUS}  = getReply();
    $genesis->{READANS} = getReply();
    $genesis->{PAUSANS} = getReply();
}

# Get the mouse position
sub MOUSE {
    local ($genesis) = shift;
    local ($command) = @_;
    $genesis->sendCommand("MOUSE", removeNewlines($command));
    $genesis->{STATUS}   = getReply();
    $genesis->{READANS}  = getReply();
    $genesis->{MOUSEANS} = getReply();
}

# Send a command
sub COM {
    local ($genesis) = shift;
    local $command;
    if (@_ == 1) {
       ($command) = @_;
       $genesis->sendCommand("COM",removeNewlines($command));
    } else {
       $command = shift;
       local %args = @_;
       foreach (keys %args) {
          $command .= ",$_=$args{$_}";
       }
       $genesis->sendCommand("COM", $command);
    }
    $genesis->{STATUS}  = getReply();
    $genesis->{READANS} = getReply();
    $genesis->{COMANS}  = $genesis->{READANS};
}

# Send an auxiliary command
sub AUX {
    local ($genesis) = shift;
    local $command;
    if (@_ == 1) {
       ($command) = @_;
       $genesis->sendCommand("AUX", removeNewlines($command));
    } else {
       $command = shift;
       local %args = @_;
       foreach (keys %args) {
          $command .= ",$_=$args{$_}";
       }
       $genesis->sendCommand("AUX", $command);
    }
    $genesis->{STATUS}  = getReply();
    $genesis->{READANS} = getReply();
    $genesis->{COMANS}  = $genesis->{READANS};
}

# Get some basic info
# It is received in the form of a csh script, so the information needs 
# hacking to get into a form suitable for perl

sub DO_INFO {
    local ($genesis) = shift;
    local $info_pre = "info,out_file=\$csh_file,write_mode=replace,args=";
    local $info_com = "$info_pre @_ -m SCRIPT";
    $genesis->parse($info_com);
}


sub parse {
	my @text;
    local ($genesis) = shift;
    local($request) = shift;
    local $csh_file  = "$ENV{GENESIS_DIR}/share/tmp/info_csh.$$";
    $request =~ s/\$csh_file/$csh_file/; 

    $genesis->COM ($request);

    open (CSH_FILE,  "$csh_file") or warn "Cannot open info file - $csh_file: $!\n";
    while (<CSH_FILE>) {
	chomp;
	next if /^\s*$/; # ignore blank lines 

	($var,$value) = /set\s+(\S+)\s*=\s*(.*)\s*/; # extract the name and value 

	$value =~ s/^\s*|\s*$//g; # remove leading and trailing spaces from the value
	$value =~ s/\cM/<^M>/g;   # change ^M temporarily to something else
	                           # This happens mainly in giSEP, and shellwords makes it disappear

	@value = shellwords($_);			   
				   
	# Deal with an csh array differently from a csh scalar
	    if ($value =~ /^\(/ ) {
	        $value =~ s/^\(|\)$//g; # remove leading and trailing () from the value
	        @words = shellwords($value); # This is a standard part of the Perl library
	        grep {s/\Q<^M>/\cM/g} @words;
	        $genesis->{doinfo}{$var} = [@words];
	    } else {
	        $value =~ s/\Q<^M>/\cM/g;
	        $value =~ s/^'|'$//g;
	        $genesis->{doinfo}{$var} = $value;
		}
    ###zq

	if ($_ =~ m{^\#}) {  push @text,$_ };
    }###end while
	if ( @text ) { $genesis->{doinfo}{'text'} = [@text] };

	###zq
    close (CSH_FILE);
    unlink ($csh_file);
}

sub INFO {
    local ($genesis) = shift;
    local %args      = @_;
    local ($entity_path, $data_type, $parameters, 
           $serial_number, $options, $help, $entity_type, $units) = ("","","","","","","","");
    local $i;
    foreach (keys %args) {
       $i = $args{$_};
       if ($_ eq "entity_type") {
          $entity_type = "-t $i";
       } elsif ($_ eq "entity_path") {
          $entity_path = "-e $i";
       } elsif ($_ eq "data_type") {
          $data_type = "-d $i";
       } elsif ($_ eq "parameters") {
          $parameters = "-p $i"; 
       } elsif ($_ eq "serial_number") {
          $serial_number = "-s $i";
       } elsif ($_ eq "options") {
          $options = "-o $i";
       } elsif ($_ eq "help") {
          $help = "-help";
       } elsif ($_ eq "units") {
          $units = "units=$i,";
       }       
    }

    local $info_pre = "info,out_file=\$csh_file,write_mode=replace,${units}args=";
    local $info_com = "$info_pre $entity_type $entity_path $data_type "
                    . "$parameters $serial_number $options $help";
                    
    $genesis->parse($info_com);
}


sub clearDoinfo { 
    local ($me) = shift;
    undef $me->{doinfo};
}

1;

EOF_4
open ( FH_4,  "> C:/genesis/e92/all/perl/Genesis.pl" ) or die "$!";
print FH_4  $genesispl;
close FH_4;
print "rewrite 4 ok\n";

####____________________________________________-




 




