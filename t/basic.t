#! perl

use Test::More tests => 2;
use strict;
use warnings;

-d "t" && chdir "t";

our $prog;

require_ok("common.pl");

my @dels = qw(x1.out);

unlink(@dels);
system("$prog x1.mp3 > x1.out");

ok(!differ("x1.out", "basic.ref"));

unlink(@dels);



