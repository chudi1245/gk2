#! perl -w

#use strict;
use warnings;
use Win32::GUI qw(BS_NOTIFY);

#TODO  Genesisi action
sub butt_click {	 
	my $check_name = $_[0]->{-name};
	$check_name =~ s/button/check/;
	my $check = $_[0]->GetParent()->{$check_name};
	$check->Checked(! $check->Checked());
};

#界面定义的数组
my @button_list=(
{name=>'name_1', pos=>[5,20], text=>'制作ppt', onclick=>\&butt_click },
{name=>'name_2', pos=>[5,40], text=>'检查焊盘', onclick=>\&butt_click },
{name=>'name_3', pos=>[5,60], text=>'检查盘中孔', onclick=>\&butt_click },
{name=>'name_4', pos=>[5,80], text=>'内层处理', onclick=>\&butt_click },
{name=>'name_5', pos=>[5,100], text=>'非金属盘', onclick=>\&butt_click },
{name=>'name_6', pos=>[5,120], text=>'输出光绘', onclick=>\&butt_click },
{name=>'name_7', pos=>[5,140], text=>'跑测试点', onclick=>\&butt_click },
{name=>'name_8', pos=>[5,160], text=>'输出文件', onclick=>\&butt_click },
{name=>'name_9', pos=>[5,180], text=>'关闭文件', onclick=>\&butt_click },
);

#GUI
my $Window = new Win32::GUI::Window(
    -name   => "Window",                    # Window name (important for OEM event)
    -title  => "测试点制作",           # Title window
    -pos    => [100,100],                   # Default position
    -size   => [400,400],                   # Default siz
    -dialogui => 1,                         # Enable keyboard navigation like DialogBox
);

foreach (@button_list) {
	$Window->AddButton (
		-name    => 'button' . $_->{name},
		-pos     => $_->{pos},
		-text    => $_->{text},
		-onClick =>  $_->{onclick},
		-tabstop  => 1,  
		-size  => [120, 20],
	);	
	$Window->AddCheckbox(
		-name => 'check' . $_->{name},
		-text    => "已处理",
		-pos     => [$_->{pos}[0] + 120, $_->{pos}[1] ], 
		-tabstop => 1,
	);
};

$Window->Show();
Win32::GUI::Dialog();



