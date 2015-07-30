#!/usr/bin/perl

@x=qw(a.rar bb.rar);

$_='b.rar';

$res=grep m/^$_$/,@x;

print $res;


