use Test::More tests => 2;

-d "t" && chdir "t";

require "differ.pl";
ok(1);

my @dels = qw(x1.out);

unlink(@dels);
system("../blib/script/mp3info --id3tag x1.mp3 > x1.out");

ok(!differ("x1.out", "id3tags.ref"));

unlink(@dels);



