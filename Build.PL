use 5.006;
use strict;
use Module::Build;

my @scripts = qw(mp3info);
my $usrbin = "/usr/bin";

my $build = Module::Build->new
  ( module_name => 'mp3info',
    dist_version_from => 'script/mp3info',
    script_files => [ map { "script/$_" } @scripts ],
    license => 'perl',
    requires =>
      { Getopt::Long => 2.33,
	MP3::Info => 1.02,
      },
    build_requires =>
      { Test::More => 0,
      },
  );

my $installscript = $build->{properties}{install_sets}{$build->{properties}{installdirs}}{script};

print STDERR <<EOD unless $installscript eq $usrbin;

WARNING: This Makefile will install user accessible scripts.
The location for these scripts is $installscript.
You may consider to pass INSTALLSCRIPT=$usrbin (or some other
convenient location) to "make install".

EOD

$build->create_build_script;

