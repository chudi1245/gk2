#!/usr/bin/perl -w
##use lib "$ENV{GENESIS_DIR}/sys/scripts/CAM_POU/perl";####
use perl_gen;
use Genesis;
use FBI;
use Win32::GUI();
use Win32::Env;
use Win32::GUI::DIBitmap();
use Win32::GUI::BitmapInline;
use Win32::GUI qw(MB_OK MB_ICONINFORMATION MB_ICONQUESTION HWND_TOP SWP_SHOWWINDOW SWP_NOMOVE SWP_NOSIZE SWP_SHOWWINDOW MB_YESNOCANCEL MB_YESNO);
###_______________________
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};


my $font = Win32::GUI::Font->new(-name => "宋体",-bold => 1,-size => 28,);     #lap#
my $font1 = Win32::GUI::Font->new(-name => "宋体",-bold => 1,-size => 14,);     #lap#
my $font2 = Win32::GUI::Font->new(-name => "宋体",-bold => 0,-size => 14,);     #lap#
my $font3 = Win32::GUI::Font->new(-name => "宋体",-bold => 1,-size => 16,);     #lap#
my $font4 = Win32::GUI::Font->new(-name => "宋体",-bold => 0,-size => 14,);     #lap#
my $font5 = Win32::GUI::Font->new(-name => "Tahoma",-bold => 1,-size => 16,);     #lap#
my $font6 = Win32::GUI::Font->new(-name => "Tahoma",-bold => 1,-size => 12,);     #lap#
my $fg1            = [0,0,255];##文字
my $bg1            = [240,240,240];##标题
my $bg2            = [240,240,240];##窗体
my $bg3            = [230,230,250];##文本框
my $bg5            = [191,191,191];##文本框只读取
my $bg4            = [230,230,250];##下拉框
my $fg2            = [0,0,0];##文字
my $fg3            = [88,88,88];##文本框只读取
my $fg4            = [0,0,0];##lab
my $f   	         = new perl_gen;
my $GENESIS_DIR    = GetEnv(ENV_SYSTEM, 'GENESIS_DIR');



$f->INFO(entity_type=>"job",
		 entity_path=>"$JOB",
	     data_type=>"STEPS_LIST");
$f->INFO(entity_type => 'matrix',
         entity_path => "$JOB/matrix");
my $gROWcount = $f->{doinfo}{gNUM_LAYERS};

my $i = 0;
while ($i < $gROWcount){
my $gROWlayername = $f->{doinfo}{gROWname}[$i];
my $gROWlayerboard = $f->{doinfo}{gROWlayer_type}[$i];
my $gROWlayerboard_misc = $f->{doinfo}{gROWcontext}[$i];
###$f->PAUSE($gROWlayerboard);
if($gROWlayerboard eq "signal" && $gROWlayerboard_misc eq "board"){
	push @box,$gROWlayername;
}
$i++;
}


#open (FILES1, "$ENV{GENESIS_DIR}/sys/scripts/CAM_POU/ini/SHAVE_CPOOER1.ini");
#my $JOB=<FILES1>;
#close(FILES1);
#open (FILES2, "$ENV{GENESIS_DIR}/sys/scripts/CAM_POU/ini/SHAVE_CPOOER2.ini");
#my $STEP=<FILES2>;
#close(FILES2);


$f->COM("open_entity,job=$JOB,type=step,name=$STEP,iconic=no");

my $group = $f->{COMANS};
$f->COM("set_group,group=$group");



my $main_ico = Win32::GUI::BitmapInline->newIcon( q(
												AAABAAEAMDsAAAEAIABALgAAFgAAACgAAAAwAAAAdgAAAAEAIAAAAAAAAAAAABMLAAATCwAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACMf8Q8kIPM+FxX3dBEO+aMHBv3MAQL/7QcG/dcX
													E/d9KybxIQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKyXwCCMe8zUYFfZzDgz6sAQD/ucAAP/+
													AAD//wAA//8AAP//AAD//wAA//8AAP//BAP+8RQR+JsnIvIxAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwKu8BKCPyIRwY9V0VE/icBgb9
													2gEA//wAAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8BAf/6
													DAv6rCgi8TsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAzLe8FKCPxNxYT
													930MC/vCAgL/9QAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//AAD//wEB//0TEfikMizuGwAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAr
													Je8GIR7yPRYU94cJCPzRAQH//QAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//CAb9
													31RL7TMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAqJPAEIBzzNxgU94YIB/zUAAD//gAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//yIe94oAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAODHtFxgV9nAJB/zNAAD//gAA//8AAP//AAD//wAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP/+AQH/+gEB//UDAv7rCQj81AwL+7cODPmUGRX1Xl5W7RAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgHfR1BQT+8QAA//8AAP//AQD/
													/gIB//gCAv7zAwP+7gUF/eMIB/3XCgn8zQwL+8QMCfu7Dw36sw0L+qsQDfqjExD4mw0M+p8YFviX
													Gxn2eiAd9nAiH/RrHRr1ZCMg81wgHPRUIx7zSygk80AqJ/E0NC/vJSom8hUyLe4FAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAhHvRbIh7xbhsX9loeGvRJIBz0OCYh8ikmIvIbJiHyDyok8QsrJfEILinwBS0o7wMAAAAAAAAA
													AAAAAAAAAAAAAAAAAC0o8EsuKvR1RELvQDUz8WE3NfBVOjjxUDw570w/PO9GPzztQ0pI7z8/Pes8
													T0zuPExK7jlAPeo3SUbrOFZU7ThgYO85VlTsNkI/6DJCP+kyRUPpMl1c7zhdXO85UE/sO0NA6jxO
													S+s9VFLuREA+60dHRe5NQT/uWUdF7kwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAGto6AttaesEAAAAAEM87B4iHvegKSf2nwAA//8AAP//AAD/
													/wAA//8AAP//AQH//wEB//8BAf//AQH//wIC//4CAv/9AgL//QIC//wCAv/8AgL/+wIC/voCAv76
													AgL++gIC//wCAv/8AQH//AEB//0BAf/+AAD//wAA//8AAP//AAD//zc29YMAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAXVvrKCkn9qdhX+kSAAAAAAAA
													AAAkIfaSMi/zggIC//wAAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													DQz95W5r7BsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABG
													RO5QCQn97AwM/OFYVeYKAAAAAAAAAAAsJ/JpMS/zfw8P+9oAAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//NTP0gwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAaGPoBjEv9IgBAf/9AAD//wwL/OFXVOcLAAAAAAAAAAA9N+0wJSL1kCQj96YA
													AP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8KCf3qYV7sIAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABaV+kaHh34uAAA//8AAP//AAD//wcH/e5YVOcT
													AAAAAAAAAABKQukJIR31lzEu838AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8yL/WSAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAE1J7DgQD/vXAAD/
													/wAA//8AAP//AAD//wMD/vlUT+wuAAAAAAAAAAAAAAAAJiH0gDEt8noKCv3pAAD//wAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wQE/vdaVuwyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAPjvvYAQE/vMAAP//AAD//wAA//8AAP//AAD//wAA//9CPu5UAAAAAAAAAAAAAAAAOTPw
													Tyon9IweHPi0AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//yUj96wAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAuK/J8AQH//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8yMPODAAAAAAAAAAAAAAAAPzjsFh8c9p4uK/SIAAD//wAA//8AAP//AAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													AAD//0hE7U4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADY09IkAAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wAA//8aGPi6AAAAAAAAAAAAAAAAAAAAACMg9Y8zL/J3BgX+9AAA
													//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//ExL60GFc6AkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													S0jybgAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8HBv7wXFfrHwAAAAAA
													AAAAAAAAADMu8WMsKPSCFhX5xgAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//PjvzdwAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAABcVukTDAz84gAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													AAD//wAA//8AAP//PDfvYgAAAAAAAAAAAAAAAEY+7CYlIfaaKyn1lQAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8FBP70U0/rKAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABAO+wsAgL++AAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//IR/3rwAAAAAAAAAAAAAAAFFK6QIiH/aY
													Mi/ydwIC//wAAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wAA//8fHfexAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AABMR+obBQT+8wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//BQT+
													81VO6ygAAAAAAAAAAAAAAAAsJ/NzLSnyfA8O+9gAAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8/O+5aAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAABfV+gDGRf5xAAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//zk08n4AAAAAAAAAAAAAAAA0Lu47Ih/1kyMh9qMAAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													AAD//wsK++FTTecTAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAV1LvRgIC/vgA
													AP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//xAP+9heVukPAAAAAAAA
													AABFPeoLHxz2nTAs838AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//AAD//ysp9ZUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAEpF8WUAAP7+AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//89OO9lAAAAAAAAAAAAAAAAJiL0gC4q834IB/3rAAD//wAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//0xH7UMAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAmIe9nAwP++wAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8UEvrLYVnnBwAAAAAAAAAAMy3wUCck9Iwa
													GPi9AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA
													//8AAP//FBL71Ghi6AkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAANDDvVgQE/e4AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													TEfwVgAAAAAAAAAAMyztFx8c9ZgpJvONAAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8A
													AP//AAD//wAA//8AAP//AAD//wAA//8AAP//Mi/0hwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADs17DINDPvWAAD//wAA//8AAP//AAD/
													/wAA//8AAP//AAD//wAA//8AAP//GBb5xWdg6AYAAAAAAAAAACIf9IkvK/F1BAT+9gAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8BAf/8Uk3tOgAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AABEPeoZEhD4tgAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//z05710AAAAAAAAA
													ADAs8mQtKPN7EhH6zgAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8AAP//
													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
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAADEr7gMjH/NUIx/1dh8b9pYvKvFuBAP+9gAA//8AAP//AAD//wAA
													//8AAP//AAD//wAA//8BAf/9QzztPgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACci820t
													KPJ8FBL5yAAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8LCvzfU0zqDgAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAEM87S8lIPWWJyT0lAAA//8AAP//AAD//wAA//8AAP//AAD//wAA//8g
													HfeoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEU96gYbGPacKSTydQAA//8AAP//
													AAD//wAA//8AAP//AAD//wAA//8uKvJxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAmIfN6KyfyewsK/OEAAP//AAD//wAA//8AAP//AAD//wEB//w+N+07AAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2L+9EJyP1jhwa96wAAP//AAD//wAA//8AAP//AAD/
													/wkI/ORFPuoPAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABJQuoRIR71lyom
													838AAP//AAD//wAA//8AAP//AAD//xYU+LYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAIx/0hDIt8W4FBf7vAAD//wAA//8AAP//AAD//yUh9IUAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAKyXxXCwo834WFPm8AAD//wAA//8A
													AP//AAD//zAr8VgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													PjbsJR8c9pgmI/SKAAD//wAA//8AAP//AgL++D427S0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAATETpAiEd9pkzLvFsAgL++AAA//8AAP//CQj84kE66w0AAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwm83QtKPN3EA76
													zwAA//8AAP//ExD5vkU+6wEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAADYx7zsiH/WQIh/1lwAA//8AAP//Gxj3mwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADoz6wscGPaeLinycAAA//8AAP//IR71ewAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAg
													HfSCKybybwoJ/OEAAP//KCTyXgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAABBO+9QJyP0hxsY96gAAP//LCfyRQAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABIQOwWHhv2niom83sAAP//
													MSzvMQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAIh71jyom8m0GBv3iJSDyIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALirxZCYi84IaF/eqNS/wHQAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPjjsJiAd
													9p0pJPN0Cwn3GwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAVEzqAiEe9p8tKfFfFhP2CQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAC4p824zLvBaAAAAAAAAAAAA
													AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAD///4f//8AAP//
													4AP//wAA//4AAP//AAD/8AAAP/8AAP8AAAAf/wAA+AAAAA//AADgAAAAP/8AAIAAH////wAA////
													////AAD//8AAAAAAAP/9wAAAAQAA//nwAAABAAD/4eAAAAMAAP/B6AAAAwAA/4HoAAAHAAD/AfAA
													AAcAAP4A8AAADwAA+AD0AAAPAAD4APgAAB8AAPAA+AAAHwAA8AB6AAAfAADwAH4AAD8AAPAAfAAA
													PwAA+AA9AAA/AAD8AD0AAH8AAP4AHgAAfwAA/wAeAAB/AAD/gA6AAP8AAP/AD4AA/wAA//AHAAD/
													AAD/+AdAAf8AAP/8A8AB/wAA//8BgAH/AAD//8GgA/8AAP//4KAD/wAA///4wAP/AAD///5AB/8A
													AP///9AH/wAA////8Af/AAD////gB/8AAP///+gP/wAA////+A//AAD////wD/8AAP////QP/wAA
													////9A//AAD////8H/8AAP////gf/wAA////+h//AAD////+H/8AAP////wf/wAA/////T//AAD/
													///9P/90af////4//3Jt/////r//ZGX////+v/9Uc/////8//0No/////3//AAD/////f/8AAP//
													/////wAA
												) );
my @menu_defn = ("文件(&F)"  => "File",
       ">打开(&S) "   => { -name => "Save",},
       ">保存(&I) "   => { -name => "input_date",},
       ">退出(&Q)"    => { -name => "File_Exit",},
          "编辑(&E)"  => "edit",
       ">复制(&C) "   => { -name => "Copy", },
       ">粘贴(&V) "   => { -name => "Covy", },
          "帮助(&H)"  => "Help",
       ">使用手册 "   => { -name => "shouce", },
       ">关于(&B) "   => { -name => "About", -onClick => \&Notepad_OnAbout },
       );
my $menu = Win32::GUI::Menu->new(@menu_defn);
my $main = Win32::GUI::Window->new(
                   -name                  => 'Main',
                   -width                 => 407,
                   -height                => 440,
                   -background            => $bg2,
	                 -topmost               => 1,
	                 -toolwindow            => 0,
	                 -dialogui              => 1,
                   -resizable             => 0,
                   -text                  => "掏铜程序   <<<<MTL自动程序>>>>",
                   -menu                  => $menu,
                   -maximizebox           => 0,
                   -onTerminate	          => sub{&fasuo();return -1;},
                   );
$main->AddLabel(
                   -name                  => "lab1",
                   -background            => $bg1,
                   -font                  => $font,
	                 -foreground            => $fg1,
                   -text                  => "自动叠铜程序",
                   -left                  => 70,
                   -top                   => 10,
                   );
$main->AddGroupbox(-name                  => 'T4',
                   -title                 => "参数信息",
                   -background            => $bg2,
                   -left		              => 0,
                   -top		                => $main->lab1->Top + $main->lab1->Height + 10,
                   -size                  => [$main->ScaleWidth(), 113],);###参数信息###
$main->AddLabel(   -name 	                => "T5",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "SMD到铜皮:",
                   -left		              => $main->T4->Left + 7,
                   -top		                => $main->T4->Top + 20,
		               );
$main->AddTextfield(
                  -name 	                => "T6",
		              -font		                => $font6,
	                -foreground             => $fg1,
	                -background             => $bg3,
	 	              -text 		              => "6",
	 	              -onClick                => \&T6_CHECK,
		              -tabstop	              => 1,
		              -onKeyUp                => sub{
  		$main->T9->SetFocus,
  		$main->T9->SelectAll(),
	 		if($_[2] == 13)},
		              -height                 => 28,
		              -width                  => 60,
                  -left		                => $main->T5->Left + $main->T5->Width,
                  -top		                => $main->T5->Top - 4,
		              -align 		              => 'left');
$main->AddLabel(   -name 	                => "T7",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "mi",
                   -left		              => $main->T6->Left + $main->T6->Width + 5,
                   -top		                => $main->T5->Top,
		               );
$main->AddLabel(   -name 	                => "T8",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "PAD到铜皮:",
                   -left		              => $main->T7->Left + $main->T7->Width + 15,
                   -top		                => $main->T5->Top,
		               );
$main->AddTextfield(
                  -name 	                => "T9",
		              -font		                => $font6,
	                -foreground             => $fg1,
	                -background             => $bg3,
	 	              -text 		              => "6",
		              -tabstop	              => 1,
		              -onKeyUp                => sub{
  		$main->T12->SetFocus,
  		$main->T12->SelectAll(),
	 		if($_[2] == 13)},
		              -height                 => 28,
		              -width                  => 60,
                  -left		                => $main->T8->Left + $main->T8->Width,
                  -top		                => $main->T8->Top - 4,
		              -align 		              => 'left');
$main->AddLabel(   -name 	                => "T10",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "mi",
                   -left		              => $main->T9->Left + $main->T9->Width + 5,
                   -top		                => $main->T5->Top,
		               );
$main->AddLabel(   -name 	                => "T11",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "线到铜皮 :",
                   -left		              => $main->T5->Left,
                   -top		                => $main->T5->Top + $main->T5->Height + 10,
		               );
$main->AddTextfield(
                  -name 	                => "T12",
		              -font		                => $font6,
	                -foreground             => $fg1,
	                -background             => $bg3,
	 	              -text 		              => "6",
		              -tabstop	              => 1,
		              -onKeyUp                => sub{
  		$main->T15->SetFocus,
  		$main->T15->SelectAll(),
	 		if($_[2] == 13)},
		              -height                 => 28,
		              -width                  => 60,
                  -left		                => $main->T6->Left,
                  -top		                => $main->T11->Top - 4,
		              -align 		              => 'left');
$main->AddLabel(   -name 	                => "T13",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "mi",
                   -left		              => $main->T7->Left,
                   -top		                => $main->T5->Top + $main->T5->Height + 10,
		               );
$main->AddLabel(   -name 	                => "T14",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "孔到铜皮 :",
                   -left		              => $main->T8->Left,
                   -top		                => $main->T5->Top + $main->T5->Height + 10,
		               );
$main->AddTextfield(-name 	                => "T15",
	 	               -font		              => $font6,
	                 -foreground            => $fg1,
	                 -background             => $bg3,
	 	               -text 		              => "10",
		               -tabstop	              => 1,
		              -onKeyUp                => sub{
  		$main->T18->SetFocus,
  		$main->T18->SelectAll(),
	 		if($_[2] == 13)},
		               -height                => 28,
		               -width                 => 60,
                  -left		                => $main->T9->Left,
                  -top		                => $main->T14->Top - 4,
		               -align 		            => 'left'
		               );
$main->AddLabel(   -name 	                => "T16",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "mi",
                   -left		              => $main->T10->Left,
                   -top		                => $main->T5->Top + $main->T5->Height + 10,
		               );
$main->AddLabel(   -name 	                => "T17",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "最小细丝 :",
                   -left		              => $main->T5->Left,
                   -top		                => $main->T11->Top + $main->T11->Height + 10,
		               );
$main->AddTextfield(
                  -name 	                => "T18",
		              -font		                => $font6,
	                -foreground             => $fg1,
	                -background             => $bg3,
	 	              -text 		              => "6",
		              -tabstop	              => 1,
		              -onKeyUp                => sub{
  		$main->T6->SetFocus,
  		$main->T6->SelectAll(),
	 		if($_[2] == 13)},
		              -height                 => 28,
		              -width                  => 60,
                  -left		                => $main->T6->Left,
                  -top		                => $main->T17->Top - 4,
		              -align 		              => 'left');
$main->AddLabel(   -name 	                => "T19",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "mi",
                   -left		              => $main->T7->Left,
                   -top		                => $main->T11->Top + $main->T11->Height + 10,
		               );
$main->AddLabel(   -name 	                => "T25",
                   -font                  => $font2,
                   -background            => $bg2,
                   -foreground            => $fg4,
		               -text 		              => "<=",
                   -left		              => $main->T19->Left + $main->T19->Width + 10,
                   -top		                => $main->T19->Top + 2,
		               );
$main->AddRadioButton(
        -text         => "填",
        -background   => $bg1,
        -foreground   => $fg1,
        -font         => $font3,
        -name         => "FILL1",
        -size         => [45,30],
        -left		      => $main->T25->Left + $main->T25->Width + 3,
        -top		      => $main->T25->Top - 5,
        );
$main->AddRadioButton(
        -text         => "削",
        -background   => $bg1,
        -foreground   => $fg1,
        -font         => $font3,
        -name         => "FILL2",
        -size         => [45,30],
        -left		      => $main->FILL1->Left + $main->FILL1->Width + 1,
        -top		      => $main->T25->Top - 5,
        );  
$main->AddRadioButton(
        -text         => "填/削",
        -font         => $font3,
        -background   => $bg1,
        -foreground   => $fg1,
        -name         => "FILL3",
        -size         => [95,30],
        -left		      => $main->FILL2->Left + $main->FILL2->Width + 1,
        -top		      => $main->T25->Top - 5,
        );
$main->FILL1->Checked(0);
$main->FILL2->Checked(0);
$main->FILL3->Checked(1);
my $fill_mode = 3;
$main->AddGroupbox(-name                  => 'T1',
                   -title                 => "选择操作层",
                   -background            => $bg2,
                   -left		              => $main->T4->Left,
                   -top		                => $main->T4->Top + $main->T4->Height + 4,
                   -size                  => [$main->ScaleWidth(), 160],);
my $box = $main->AddListbox(
                   -name                  => 'BOX',
                   -multisel              => 1,
                   -autohscroll           => 1,
	                 -vscroll               => 1,
	                 -hscroll               => 1,
                   -left                  => $main->T1->Left + 10,
                   -top                   => $main->T1->Top + 20,
                  #-size                  => [380,150],
                   -width                 => 380,
                   -height                => 150,
                   -font                  => $font5,
                   -foreground            => $fg1,
                   -background             => $bg3,
                  );




$main->BOX->Add(@box);
$main->AddButton(  -name         => "Default",
	                 -text         => "执  行",
	                 -default      => 1,
	                 -ok           => 0,              
                   -font         => $font3,
	                 -width        => 120,
	                 -height       => 33,
                   -left		     => 10,
                   -top		       => $main->T1->Top + $main->T1->Height + 12,
                   );
$main->AddButton(  -name         => "Help",
	                 -text         => "帮  助",
	                 -default      => 1,
	                 -ok           => 0,
                   -font         => $font3,
                   -width        => 120,
	                 -height       => 33,
                   -left		     => $main->Default->Left + $main->Default->Width + 10,
                   -top		       => $main->T1->Top + $main->T1->Height + 12,
                   );
$main->AddButton(  -name         => "QX_xt",
	                 -text         => "退  出",
	                 -default      => 0,
	                 -ok           => 0,
                   -font         => $font3,
                   -width        => 120,
	                 -height       => 33,
                   -left		     => $main->Help->Left + $main->Help->Width + 10,
                   -top		       => $main->T1->Top + $main->T1->Height + 12,
                   );
my $ceok12 = "0";
my $w = $main->Width()  + $main->Width()  - $main->ScaleWidth();
my $h = $main->Height() + $main->Height() - $main->ScaleHeight();
my $desk = Win32::GUI::GetDesktopWindow();
my $dw = Win32::GUI::Width($desk);
my $dh = Win32::GUI::Height($desk);
my $x = ($dw - $w) / 2;
my $y = ($dh - $h) / 2;
$main->Move($x, $y);
$main->SetIcon($main_ico);
&fasuo();
$main->Show();
Win32::GUI::Dialog();
exit(0);
sub fasuo{
$main->Animate(
        -show => !$main->IsVisible(),
        -activate => 1,
        -animation => "center",
        -direction => "tlbr",
        -time => "150",
        );
}
sub QX_xt_Click {
&fasuo();
return -1;
}

sub Help_Click{
$main->MessageBox("说明:\n
(1)在参数信息中输入数值!\n
(2)<最小细丝>分为3中模式,请按照板的难易程度选择!\n
(3)请选中需要执行的层!","帮助^_^",MB_ICONINFORMATION | MB_OK,);
}
sub FILL1_Click{
$fill_mode = "1";
}
sub FILL2_Click{
$fill_mode = "2";
}
sub FILL3_Click{
$fill_mode = "3";
}
sub T6{
my $smd = $main ->T6 ->Text();#SMD
$smd =~ s/\W//g;
$main ->T6 ->Text($smd);#SMD
}

sub Default_Click {
$ceok12 = "0";
my @box_yesno = $box->GetSelItems();
foreach (@box_yesno) {
my $gROWname_yesno = $box->GetString($_);####选取的文字##
my $muner_yesno = $box->GetSelCount();########选取的个数##
if($muner_yesno <= 0){
$main->MessageBox("请选择层!","^_^",0x0010);
return 0;
$ceok12 = "0";
}else{
##测试是否有层被选中##
}
##测试是否有层被选中循环结束##
}
my $smd = $main ->T6 ->Text();#SMD
my $pad = $main ->T9 ->Text();#焊盘
my $line = $main ->T12 ->Text();#线
my $Spr_sil = $main ->T18 ->Text();#细丝
my $shave_drl = $main ->T15 ->Text();#PTH
$smd =~ s/\W//g;
$pad =~ s/\W//g;
$line =~ s/\W//g;
$shave_drl =~ s/\W//g;
$Spr_sil =~ s/\W//g;
$smd = $smd*2;
$pad = $pad*2;
$line = $line*2;
$shave_drl = $shave_drl*2;
if($smd eq ' ' || $pad eq ' ' || $line eq ' ' || $Spr_sil eq ' ' || $shave_drl eq " "){
$main->MessageBox("数据不足,请检查!","^_^",0x0010);
return 0;
$ceok12 = "0";
}else{
if($fill_mode eq 1){
$fill_mode3 = "填";
}
if($fill_mode eq 2){
$fill_mode3 = "削";
}
if($fill_mode eq 3){
$fill_mode3 = "填/削";
}
##########################提取层名----循环#########################
&fasuo();
$main->Hide();
my $ceshi_yesno = $main -> MessageBox ("确认数据开始执行:\n
SMD到铜皮的距离(整体):$smd mil------PAD到铜皮的距离(整体):$pad mil\n
线到铜皮的距离(整体):$line mil------孔到铜皮的距离(整体):$shave_drl mil\n
最小细丝/缝隙(整体):$Spr_sil mil------处理细丝的模式:$fill_mode3","提示", MB_ICONQUESTION |MB_YESNO);
if($ceshi_yesno eq 7){
$ceok12 = "2";
$main->Show();}
if($ceshi_yesno eq 6){
my @box = $box->GetSelItems();
foreach (@box) {
my $gROWname = $box->GetString($_);####选取的文字##
$ceok12 = "1";
$f->COM("units,type=inch");
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname,display=yes,number=1");
$f->COM("work_layer,name=$gROWname");
###备份backup###
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/backup.$gROWname+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=backup.$gROWname+++");}
$f->COM("sel_copy_other,dest=layer_name,target_layer=backup.$gROWname+++,invert=no,dx=0,dy=0,size=0,\n
         x_anchor=0,y_anchor=0,rotation=0,mirror=none");
###备份完毕###
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(1).选取铜皮@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(1).选取铜皮@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(1).选取铜皮@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=surface\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=surface");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no,intersect_area=no,lines_only=no,
        ovals_only=no,min_len=0,max_len=0,min_angle=0,max_angle=0");
$f->COM("filter_reset,filter_name=popup");
$f->COM("get_select_count");
##....检测是否选中铜皮##
my $select_yes_no=$f->{COMANS};
if($select_yes_no eq "0"){
$main->MessageBox("$gROWname 层中没有铜皮，$gROWname 层操作被停止!","^_^",0x0010);
}else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.surface+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.surface+++");}
##....移动到surface层中
$f->COM("sel_move_other,target_layer=$gROWname.surface+++,invert=no,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
##去除细丝##
if($fill_mode eq 1){
$fill_mode2 = "Cover islands";
}
if($fill_mode eq 2){
$fill_mode2 = "Cover holes";
}
if($fill_mode eq 3){
$fill_mode2 = "Cover islands\;Cover holes";
}
$f->COM("chklist_single,action=valor_dfm_clean_holes,show=yes");
$f->COM("chklist_close,chklist=valor_dfm_clean_holes,mode=hide");
$f->COM("chklist_cupd,chklist=valor_dfm_clean_holes,nact=1,params=((pp_layer=$gROWname.surface+++)(pp_size=$Spr_sil)(pp_overlap=1)(pp_mode=X or Y)(pp_hi=$fill_mode2)(pp_cover_f=Lines\;Surfaces)),
        mode=regular");
$f->COM("chklist_run,chklist=valor_dfm_clean_holes,nact=1,area=global");
$f->COM("display_layer,name=$gROWname.surface+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.surface+++");
$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,clean_hole_mode=x_and_y");
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.surface++++++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.surface++++++");}
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(2).选取SMD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(2).选取SMD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(2).选取SMD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname,display=yes,number=1");
$f->COM("work_layer,name=$gROWname");
$f->COM("filter_set,filter_name=popup,update_popup=no,include_syms=s*\;rect*\;oval*\;");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no,intersect_area=no");
$f->COM("filter_reset,filter_name=popup");
$f->COM("get_select_count");
my $select_yes_no1=$f->{COMANS};
if($select_yes_no1 eq "0"){
##没有发现smd##
}else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.smd+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.smd+++");}
##移动到smd层中
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.smd+++,invert=no,
        dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
##选择与铜皮不相连的SMD削铜皮##
$f->COM("display_layer,name=$gROWname.smd+++,display=yes,number=4");
$f->COM("work_layer,name=$gROWname.smd+++");
$f->COM("sel_ref_feat,layers=$gROWname.surface+++,use=filter,mode=disjoint,
        pads_as=shape,f_types=line\;pad\;surface\;arc\;text,polarity=positive\;negative,
        include_syms=,exclude_syms=");
$f->COM("get_select_count");
my $select_yes_no2=$f->{COMANS};
if($select_yes_no2 eq "0"){
##没有发现不相连的SMD##
}else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.shave_smd+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.shave_smd+++");}
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.shave_smd+++,invert=no,dx=0,dy=0,size=$smd,\n
         x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=$gROWname.shave_smd+++,display=yes,number=4");
$f->COM("work_layer,name=$gROWname.shave_smd+++");
$f->COM("sel_polarity,polarity=positive");
$f->COM("sel_move_other,target_layer=$gROWname.surface+++,invert=yes,dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("delete_layer,layer=$gROWname.shave_smd+++");
$f->COM("delete_layer,layer=$gROWname.smd+++");
$f->COM("display_layer,name=$gROWname.surface+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.surface+++");
$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,clean_hole_mode=x_and_y");
##不相连的smd削铜皮已完成##
}
##SMD操作完成##
}
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(3).选取PAD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(3).选取PAD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(3).选取PAD@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname,display=yes,number=1");
$f->COM("work_layer,name=$gROWname");
$f->COM("filter_set,filter_name=popup,update_popup=no,exclude_syms=s*\;rect*\;oval*\;");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=pad\;text");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no,intersect_area=no");
$f->COM("filter_reset,filter_name=popup");
$f->COM("get_select_count");
my $select_yes_no3=$f->{COMANS};
if($select_yes_no3 eq "0"){
##没有发现pad##
}else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.pad+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.pad+++");}
##复制到pad层中
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.pad+++,invert=no,
        dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=$gROWname.pad+++,display=yes,number=4");
$f->COM("work_layer,name=$gROWname.pad+++");
##参考选出不相连的pad##
$f->COM("sel_ref_feat,layers=$gROWname.surface+++,use=filter,mode=disjoint,
        pads_as=shape,f_types=line\;pad\;surface\;arc\;text,polarity=positive\;negative,
        include_syms=,exclude_syms=");
$f->COM("get_select_count");
my $select_yes_no3=$f->{COMANS};
if($select_yes_no3 eq "0"){
##没有发现不相连的pad##
}else{
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.shave_pad+++,
        invert=no,dx=0,dy=0,size=$pad,x_anchor=0,y_anchor=0,rotation=0,
        mirror=none");
$f->COM("display_layer,name=$gROWname.shave_pad+++,display=yes,number=3");
$f->COM("work_layer,name=$gROWname.shave_pad+++");
$f->COM("sel_polarity,polarity=positive");
$f->COM("sel_move_other,target_layer=$gROWname.surface+++,invert=yes,dx=0,
        dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("delete_layer,layer=$gROWname.shave_pad+++");
$f->COM("delete_layer,layer=$gROWname.pad+++");
$f->COM("display_layer,name=$gROWname.surface+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.surface+++");
$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,clean_hole_mode=x_and_y");
##不相连的pad削铜完成##
}
##PAD操作完成##
}
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(4).选取line@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(4).选取line@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(4).选取line@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname,display=yes,number=1");
$f->COM("work_layer,name=$gROWname");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=line\;surface\;arc\;text");
$f->COM("filter_set,filter_name=popup,update_popup=no,feat_types=line\;arc\;text");
$f->COM("filter_area_strt");
$f->COM("filter_area_end,layer=,filter_name=popup,operation=select,
        area_type=none,inside_area=no,intersect_area=no");
$f->COM("filter_reset,filter_name=popup");
$f->COM("get_select_count");
my $select_yes_no4=$f->{COMANS};
if($select_yes_no4 eq "0"){
##没有发现line##
}else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.line+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.line+++");}
##选取线条复制到line层##
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.line+++,invert=no,
        dx=0,dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname.line+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.line+++");
##参考选出不相连的line##
$f->COM("sel_ref_feat,layers=$gROWname.surface+++,use=filter,mode=disjoint,
        pads_as=shape,f_types=line\;pad\;surface\;arc\;text,polarity=positive\;negative,
        include_syms=,exclude_syms=");
$f->COM("get_select_count");
my $select_yes_no5=$f->{COMANS};
if($select_yes_no5 eq "0"){
##没有发现不相连的line##
}else{
$f->INFO(entity_type => "layer",entity_path => "$JOB/$STEP/$gROWname.shave_line+++",data_type=>"exists");
if ($f->{doinfo}{gEXISTS} eq "yes") {
$f->COM("delete_layer,layer=$gROWname.shave_line+++");}
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.shave_line+++,
        invert=no,dx=0,dy=0,size=$line,x_anchor=0,y_anchor=0,rotation=0,
        mirror=none");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname.shave_line+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.shave_line+++");
$f->COM("sel_polarity,polarity=positive");
$f->COM("sel_move_other,target_layer=$gROWname.surface+++,invert=yes,dx=0,
        dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("clear_layers");
$f->COM("delete_layer,layer=$gROWname.shave_line+++");
$f->COM("delete_layer,layer=$gROWname.line+++");
$f->COM("display_layer,name=$gROWname.surface+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.surface+++");
$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,
        clean_hole_mode=x_and_y");
##不相连的line削铜完成##
}
##line操作完成##
}
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(5).选取DRL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(5).选取DRL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(5).选取DRL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
$f->INFO(entity_type=>"job",entity_path=>"$JOB",data_type=>"STEPS_LIST");
$f->INFO(entity_type => 'matrix',entity_path => "$JOB/matrix");
my $gcount = $f->{doinfo}{gNUM_LAYERS};
my $o = $_;
while ($o < $gcount){
my $glayername =$f->{doinfo}{gROWname}[$o];
my $glayerboard = $f->{doinfo}{gROWlayer_type}[$o];
my $glayerboard_misc = $f->{doinfo}{gROWcontext}[$o];
if($glayerboard eq "drill" && $glayerboard_misc eq "board"){
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$glayername,display=yes,number=1");
$f->COM("work_layer,name=$glayername");
$f->COM("sel_ref_feat,layers=$gROWname.surface+++,use=filter,mode=disjoint,
        pads_as=shape,f_types=line\;pad\;surface\;arc\;text,polarity=positive\;negative,
        include_syms=,exclude_syms=");
$f->COM("get_select_count");
my $select_yes_no6=$f->{COMANS};
if($select_yes_no6 eq "0"){
##没有发现不相连的DRL##
}else{
$f->COM("sel_copy_other,dest=layer_name,target_layer=$gROWname.surface+++,
        invert=yes,dx=0,dy=0,size=$shave_drl,x_anchor=0,y_anchor=0,rotation=0,
        mirror=none");
$f->COM("display_layer,name=$gROWname.surface+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.surface+++");
$f->COM("negative_data,mode=dim");
$f->COM("negative_data,mode=clear");
$f->COM("sel_contourize,accuracy=0.25,break_to_islands=yes,clean_hole_size=3,
        clean_hole_mode=x_and_y");
##不相连的DRL削铜完成##
}
##操作drill属性的层
}
##DRL操作完成##
$o++;
}
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@合并资料@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@合并资料@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@合并资料DRL@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname,display=yes,number=1");
$f->COM("work_layer,name=$gROWname");
$f->COM("sel_move_other,target_layer=$gROWname.surface+++,invert=no,dx=0,
        dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("display_layer,name=$gROWname.surface+++,display=yes,number=1");
$f->COM("work_layer,name=$gROWname.surface+++");
$f->COM("sel_move_other,target_layer=$gROWname,invert=no,dx=0,
        dy=0,size=0,x_anchor=0,y_anchor=0,rotation=0,mirror=none");
$f->COM("clear_highlight");
$f->COM("sel_clear_feat");
$f->COM("clear_layers");
$f->COM("display_layer,name=$gROWname,display=yes,number=1");
$f->COM("work_layer,name=$gROWname");
$f->COM("delete_layer,layer=$gROWname.surface+++");
##合并完毕##
##@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##
##发现铜皮则继续##
}
##层循环操作##
}
##是否操作##
}
if($ceok12 eq "1"){
$main -> MessageBox ("操作完成,请与原稿仔细核对!","提示", MB_ICONINFORMATION |MB_OK);
return -1;
}
if($ceok12 eq "2"){
return 0;
}
if($ceok12 eq "0"){
return 0;
}
return -1;
#&fasuo();
#$main->Show();
##测试数据可以执行##
}
##主程序结束##
}
