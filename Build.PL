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
      { 'Getopt::Long' => 2.33,
	'MP3::Info' => 1.02,
      },
    build_requires =>
      { 'Test::More' => 0,
      },
    installdirs => "site",	# default
  );

# Check whether there were any prereq failures.
my $fatal = "";
my $pf = $build->prereq_failures;
while ( my ($type, $list) = each(%$pf) ) {
    while ( my ($name, $hash) = each(%$list) ) {
	$fatal .= "FATAL: $hash->{message}\n";
    }
}
die($fatal) if $fatal;

unless ( $ENV{RPM_NOQUERY} ) {
    my $installscript = $build->install_destination("script");
    print STDERR <<EOD unless $installscript eq $usrbin;

WARNING: This Build file will install user accessible scripts.
The location for these scripts is $installscript.
You may consider to pass install_path=script=$usrbin (or some other
convenient location) to "Build install".

EOD
}

$build->create_build_script;

my $name = $build->dist_name;
my $version = $build->dist_version;

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

