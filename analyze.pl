#!/usr/bin/perl -w

use strict;
my $min;
my $cnt = 0;

my $page_bits = 12; # 4096

my $ofile = "/dev/stdout";
my $gnuplot;

while (@ARGV) {
	last if $ARGV[0] eq '--';
	if ($ARGV[0] eq '--out') {
		shift @ARGV;
		$ofile = shift @ARGV || die "missing argument";
		next;
	}
	if ($ARGV[0] eq '--gnuplot') {
		shift @ARGV;
		$gnuplot = shift @ARGV || die "missing argument";
		next;
	}
	if ($ARGV[0] eq '--shift') {
		shift @ARGV;
		$page_bits = shift @ARGV;
		die "missing argument" unless defined $page_bits;
		next;
	}
	last;
}

die "Usage: $0 file" unless @ARGV && -e $ARGV[0];

my $file = shift @ARGV;
open(F, '<', $file) or die "$!\n";
while(<F>)
{
	chomp;
	$_ >>= $page_bits;
	$min = $_ unless defined $min; 
	$min = $_ if $_ < $min;
	++$cnt;
}
seek(F, 0, 0) or die "$!\n";
my %a;
while(<F>)
{
	chomp;
	$_ >>= $page_bits;
	my $v = $_-$min;
	$a{$v} ||= 0;
	++$a{$v};
}
close F;

die "$!" unless open(O, '>', $ofile);
my $na = keys %a;
print O "# samples: $cnt\n";
print O "# addresses: $na\n";
print O "# base address: $min\n";
print O "# address count share\n";
for my $k (sort {$a{$a} <=> $a{$b}} keys %a) {
	my $v = $a{$k};
	my $p = $v/$cnt;
	print O "$k\t$v\t$p\n";
}
close O;

if ($gnuplot) {
	die "$!" unless open(O, '>', $gnuplot);
	my $exp = 1/$na * 100;
	my $title = sprintf ("%d samples, %d addresses", $cnt, $na);
	my $img = $ofile;
	$img =~ s/\..*$/.png/;
	while (<DATA>) {
		s/\$img/$img/g;
		s/\$title/$title/g;
		s/\$data/$ofile/g;
		s/\$exp/$exp/g;
		print O;
	}
	close O;
}

__END__
set terminal png
set output "$img"
set title "$title"
set xlabel "Address"
set ylabel "Probability in %"
set yrange [0:*]
set xrange [0:*]
plot "$data" using ($3*100) with steps title "actual", $exp title "ideal"
