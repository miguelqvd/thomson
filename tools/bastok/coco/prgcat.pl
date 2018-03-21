#!/usr/bin/perl
# 2013-09-03 Johann E. Klasek, johann AT klasek at
#
# Untokenize a Dragon Extended Color Basic from a CBM PRG file
# and print it in ASCII to STDOUT.
#
# prgcat [-] | FILE [FILE ...]
#
# Notes:
#	The first line contains a comment with filename and starting address which
#	is compatible with petcat's output of the OpenCBM project.
#
# Revisions:
#	2013-09-06 JK
#		First version.
#	2013-09-12 JK
#		Input handling made more general.
#

### SETUP

BEGIN {
	(my $base = $0 ) =~ s|/[^/]*$||;
	# find include parts in directory of the main program
	unshift @INC, $base;
	
};

# token table (generated)
require "token.pl";

my $b;


### READ BYTE

sub getb {
	my $c;
	return ord($c) if sysread(ARGV,$c,1) == 1;
	return undef;
}


### PARAMETER PROCESSING

unshift @ARGV, "-" if ! @ARGV;


### MAIN

while(my $file = shift @ARGV) {

    open(ARGV,"<$file");
	getb(); # File type (skip)
    # load address is alway little endian!
    my $addrlo = getb();
    #printf("%02X ", $addrlo);
    my $addrhi = getb();
    #printf("%02X ", $addrhi);
    my $addr = ($addrhi << 8) + $addrlo;

    printf ";<%s> ==%04X==\n", ($file eq "-" ? "stdin" : $file), $addr;

    my $instr = 0;

    while (defined ($b = getb())) {
	#printf("%02X ", $b);

	# get link
	$link = ($b << 8) + getb();
	#printf "<Link %04X>", $link;
	last if ($link == 0);

	# get linenumber
	$line = (getb() << 8) + getb();
	printf "%5d ", $line;

	# get codeline
	while (defined ($b = getb()) && $b != 0) {
		#printf("%02X ", $b);
		# Double quote: into/out of a strin ...
		if ($b == 0x22) { $instr ^= 1; print chr($b); next; }
		if (! $instr) {
			# not inside string
			if ($b == 0xff) {
				# function token
				$b = getb();
				$tname = $fun_token{$b};
				print ($tname eq "" ? "<BAD_FUNCT>" : $tname);
				next;
			}
			elsif ($b >= 0x80) {
				# command token
				$tname = $cmd_token{$b};
				print ($tname eq "" ? "<BAD_CMD>" : $tname);
				next;
			}
		}
		# no token or inside string
		print chr($b);

		#printf("%02X ", $b);
	}
	# get EOL
	if ($b == 0) {
		# EOL
		print "\n";
		# if string constants left "open" ....
		$instr = 0;
		next;
	}
    }

}
