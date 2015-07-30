#!perl -w
use strict;
use warnings;

# Show off window animation

use Win32::GUI qw(CW_USEDEFAULT);
use Win32::GUI::BitmapInline();

my @directions = qw(tlbr tb trbl rl brtl bt bltr lr);
my $ico = arrow_icon();

my $mw = Win32::GUI::Window->new(
    -title => "Animation Demo",
    -left => CW_USEDEFAULT,
    -size => [180,280],
);

my $aw = Win32::GUI::Window->new(
    -title => "Animated Window",
    -left => CW_USEDEFAULT,
    -size => [400,300],
    -toolwindow => 1,
    -onTerminate => sub { do_animation(); 0; },
);

$mw->AddTextfield(
    -name => 'time',
    -text => 200,
    -prompt => [ "Animation time:", 80 ],
    -pos => [10,10],
    -size => [45,20],
    -align => 'right',
    -number => 1,
);

$mw->AddLabel(
    -text => "ms",
    -left => $mw->time->Left() + $mw->time->Width() + 5,
    -top  => $mw->time_Prompt->Top(),
);

$mw->AddCombobox(
    -name => 'animation',
    -dropdownlist => 1,
    -left => $mw->time->Left(),
    -top  => $mw->time->Top() + $mw->time->Height() + 10,
    -width => 60,
    -height => 100,
);
$mw->animation->Add('roll', 'slide', 'blend', 'center');
$mw->animation->Select(0);

$mw->AddLabel(
    -text => "Animation Type:",
    -left => $mw->time_Prompt->Left(),
    -top => $mw->animation->Top() + 3,
);

my $size = 15;
my $dim = 100;
my $left = 25;
my $top   = $mw->animation->Top() + $mw->animation->Height() + 20;

$mw->AddLabel(
    -pos => [$left+$size+3, $top+$size+3],
    -size => [80,80],
    -icon => $ico,
);

$mw->AddRadioButton(
    -name => $directions[0],
    -pos  => [$left, $top],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[1],
    -pos  => [$left+($dim/2), $top],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[2],
    -pos  => [$left+$dim, $top],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[3],
    -pos  => [$left+$dim, $top+($dim/2)],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[4],
    -pos  => [$left+$dim, $top+$dim],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[5],
    -pos  => [$left+($dim/2), $top+$dim],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[6],
    -pos  => [$left, $top+$dim],
    -size => [$size,$size],
);
    
$mw->AddRadioButton(
    -name => $directions[7],
    -pos  => [$left, $top+($dim/2)],
    -size => [$size,$size],
);
$mw->{$directions[7]}->Checked(1);

$mw->AddButton(
    -text => "Show/Hide",
    -left => $mw->Width() - 90,
    -top  => $mw->Height() - 60,
    -onClick => \&do_animation,
);

$mw->Show();
Win32::GUI::Dialog();
$mw->Hide();
undef $mw;
exit(0);

sub do_animation {
    my $d;
    for (@directions) {
        $d = $_,last if $mw->{$_}->Checked();
    }

    $aw->Animate(
        -show => !$aw->IsVisible(),
        -activate => 1,
        -animation => $mw->animation->Text(),
        -direction => $d,
        -time => $mw->time->Text(),
    );
}

sub arrow_icon { newIcon Win32::GUI::BitmapInline( q(
AAABAAEAUFAQAAEABACoEAAAFgAAACgAAABQAAAAoAAAAAEABAAAAAAAAAAAAEgAAABIAAAAEAAA
AAAAAAAAAAAAAACAAACAAAAAgIAAgAAAAIAAgACAgAAAwMDAAICAgAAAAP8AAP8AAAD//wD/AAAA
/wD/AP//AAD///8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB//+AAAAAAAAAAAAD///AAAAAAAAAAAAH///gAAAAAAAA
AAAP///wAAAAAAAAAAAf///4AAAAAAAAAAA////8AAAAAAAAAAB////+AAAAAAAAAAA////8AAAA
AAAAAAAf///4AAAAAAAAAAAP///wAAAAAAAAAAAH///gAAAAAAAAAAAD///AAAAAAAAAAAAB//+A
AAAAAAAAAAAA//8AAAAAAAAAAAAAf/8AAAAAAAAAAAAAf/4AAAAAAAAAAAAAP/wAAAAAAAAAAAAA
H/gAAAAAAAAAAAAAD/AAAAAAAAAAAAAAB+AAAAAAAAAAAAAAA8AAAAAAAAAAAAAAAYAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABgAAAAAAAAAGAAAADwAAAAAAAAAPAAAAH4AAAAAAAAAfg
AAAP8AAAAAAAAA/wAAAP+AAAAAAAAB/wAAAf/AAAAAAAAD/4AAA//gAAAAAAAH/8AAB//wAAAAAA
AH/+AAD//wAAAAAAAP//AAD//4AAAAAAAf//AAD//8AAAAAAA///AAD//+AAAAAAB///AAD///AA
AAAAD///AAD///gAAAAAH///AAD///wAAAAAP///AAD///4AAAAAf///AAD///wAAAAAP///AAD/
//gAAAAAH///AAD///AAAAAAD///AAD//+AAAAAAB///AAD//8AAAAAAA///AAD//4AAAAAAAf//
AAD//wAAAAAAAP//AAB//gAAAAAAAH/+AAA//AAAAAAAAD/8AAAf+AAAAAAAAB/4AAAP8AAAAAAA
AA/wAAAH4AAAAAAAAAfgAAADwAAAAAAAAAPAAAABgAAAAAAAAAGAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAYAAAAAAAAAAAAAAA8AAAAAAAAAAAAAAB+AAAAAAAAAA
AAAAD/AAAAAAAAAAAAAAH/gAAAAAAAAAAAAAP/wAAAAAAAAAAAAAf/4AAAAAAAAAAAAA//8AAAAA
AAAAAAAB//+AAAAAAAAAAAAD///AAAAAAAAAAAAH///gAAAAAAAAAAAP///wAAAAAAAAAAAf///4
AAAAAAAAAAA////8AAAAAAAAAAB////+AAAAAAAAAAA////8AAAAAAAAAAAf///4AAAAAAAAAAAP
///wAAAAAAAAAAAH///gAAAAAAAAAAAD///AAAAAAAAAAAAB//+AAAAAAAAAAAAA//8AAAAAAAAA
AAAAf/4AAAAAAAA=
) );
}