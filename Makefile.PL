use 5.006;
use strict;
use ExtUtils::MakeMaker;
use Config;

my @scripts = qw(mp3info);
my $usrbin = "/usr/bin";
my $installscript = $Config{installscript};

print STDERR <<EOD unless $installscript eq $usrbin;

WARNING: This Makefile will install user accessible scripts.
The location for these scripts is $installscript.
You may consider to pass INSTALLSCRIPT=$usrbin (or some other
convenient location) to "make install".

EOD

my $x =
WriteMakefile(
    NAME		=> 'mp3info',
    VERSION_FROM	=> 'script/mp3info',
    PREREQ_PM		=> { 'Getopt::Long' => 2.33,
			     'Test::More' => 0.00,
			     'MP3::Info' => 1.02,
			   },
   EXE_FILES		=> [ map { "script/$_" } @scripts ],
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'script/mp3info', # retrieve abstract from module
       AUTHOR        => 'Johan Vromans <jv@cpan.org>') : ()),
   PL_FILES		=> {},
);

my $name    = $x->{NAME};
my $version = $x->{VERSION};

my $fh;
if ( open ($fh, "$name.spec.in") ) {
    print "Writing RPM spec file...\n";
    my $newfh;
    open ($newfh, ">$name.spec");
    while ( <$fh> ) {
	s/%define modname \w+/%define modname $name/;
	s/%define modversion \d+\.\d+/%define modversion $version/;
	print $newfh $_;
    }
    close($newfh);
}

