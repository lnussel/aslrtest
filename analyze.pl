#!/usr/bin/perl -w

use strict;
my $min;
my $cnt = 0;

die "Usage: $0 file" unless @ARGV;

open(F, '<', $ARGV[0]) or die "$!\n";
while(<F>)
{
	chomp;
	$min = $_ unless $min; 
	$min = $_ if $_ < $min;
	++$cnt;
}
seek(F, 0, 0) or die "$!\n";
my %a;
while(<F>)
{
	chomp;
	my $v = $_-$min;
	$a{$v} ||= 0;
	++$a{$v};
}

my $na = keys %a;
print "# samples: $cnt\n";
print "# addresses: $na\n";
print "# base address: $min\n";
print "# address count share\n";
while (my ($k, $v) = each %a) {
	my $p = $v/$cnt;
	print "$k\t$v\t$p\n";
}
