use Test::More tests => 2;

-d "t" && chdir "t";

require "differ.pl";
ok(1);

my @dels = qw(x1.out);

unlink(@dels);
system("../blib/script/mp3info x1.mp3 > x1.out");

ok(!differ("x1.out", "basic.ref"));

#unlink(@dels);



