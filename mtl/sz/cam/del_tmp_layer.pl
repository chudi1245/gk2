#! /usr/bin/perl
#**************************************************************
# �������ƣ�ɾ����ʱ��
# ����汾��v1.0
# ����������: �������Ӱ���͹�����
# ������Ա��Ī־��
# ����ʱ�䣺2012-3-16
#**************************************************************
use strict;
use Tk;
use Genesis;
use FBI;
our $host = shift;
our $f = new Genesis($host);
our $JOB = $ENV{JOB};
our $STEP = $ENV{STEP};
###__________________________
kysy();

my @gROWname=@{info("matrix","$JOB/matrix","row")->{gROWname}};
foreach  (0..$#gROWname) {  delete_layer($gROWname[$_])  if  
	(($gROWname[$_] =~ /orig/) or ($gROWname[$_] =~ /\+/) or ($gROWname[$_] =~ /\.gbr/)
	
or ($gROWname[$_] =~ /\.drl/)or ($gROWname[$_] =~ /org/) or ($gROWname[$_] =~ /comp/) 
	
or ($gROWname[$_] eq'c') or ($gROWname[$_] eq 's') or ($gROWname[$_] eq 'pmt')  );

}





=h

@re_row = reverse @{info("matrix","$JOB/matrix","row")->{gROWrow}};
@name=@{info("matrix","$JOB/matrix","row")->{gROWname}};
###________________________________________
clear();
foreach (@re_row) {
    delete_row($_) if (  ($name[$_-1] =~ /orig/) or ($name[$_-1] =~ /\+/) or ($name[$_-1] =~ /org/)  )
}  





