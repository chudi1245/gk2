=head
Package for running Perl programs in a Genesis/Enterprise environment.

Usage 
    use Genesis; 
    use Genesis('122.12.1.87');
    $f = new Genesis;

    $f->COM($command);

This module enables Genesis/Enterprise scripts in perl. 
It also supports debugging from an xterm, or remote terminal. When running the perl 
script from inside Genesis, simply choose the relevant script from the 
"Script Run" screen. 

To run or debugging a script from an xterm, go the "Script Run" screen, 
and choose the  script called server.pl.  This script sets up a socket which waits
for commands from the perl script to be debugged. 
Having started the script server.pl, open up an xterm and start debugging the script. 

The conventions in the Perl script are slightly different from the csh equivalent.
 
The start of the each perl script must begin with

use Genesis;

To access this library do *one* of the following:
The options appear in the order of recommendation.

* Copy Genesis.pm into the normal Perl library
* Add the path of Genesis.pm to PERL5LIB
* Type "use lib qw(/pathname)" -- where /pathname must be the directory where the file
  Genesis.pm resides -- in each of your genesis scripts.
  The line 'use lib' must appear before the line 'use Genesis'.

The next line should be

    $f = new Genesis;

$f is simply a variable that you can choose.

The public functions are:
   VON, VOF, SU_ON, SU_OFF, PAUSE, MOUSE, COM, AUX, DO_INFO, and INFO

They are invoked in the object oriented way. Here is an example of the PAUSE command 
    $f->PAUSE($text); 

Now let's deal with variables created when using DO_INFO.
Unlike the csh, the variables are put into the the structure
pointed to by $f.

A call to "DOINFO" which reutnrs a value of "gEXISTS" would be referenced as
$f->{doinfo}{gEXISTS}. If an array were to be received, the elements could be referenced as
$f->{doinfo}{gWIDTHS}[$i].

Similary, the return results are called STATUS, READANS, PAUSANS, MOUSEANS and COMANS.
For the meantime these can be read using $f->{STATUS} etc.

BUGS

1. In debug mode: If the Abort button is pressed in Pause, the script does not terminate.

2. Every time an external script is started the Apply button has to be pressed to 
   restart the server side.

3. During debugging of the Perl script the Genesis editor is not updated.

Split into two files & revamped: 3 July 1997, Ben Michelson
Hacked out of all reconition, Peter Gordon
Original Version: 8 Nov 1996,  Herzl Rejwan
=cut
package Genesis;

if (defined $ENV{GENESIS_DIR}) {
   $_genesis_root = $ENV{GENESIS_DIR};
} else {
   $_genesis_root = "/genesis";
}

if (defined $ENV{GENESIS_EDIR}) {
   $_genesis_edir = $ENV{GENESIS_EDIR};
} else {
   $_genesis_edir = "e$ENV{GENESIS_VER}";
}

if ($_genesis_edir !~ m#^([A-Z]:)?[/\\]#i) {
   $_genesis_edir = "$_genesis_root/$_genesis_edir";
}

require "$_genesis_edir/all/perl/Genesis.pl";
