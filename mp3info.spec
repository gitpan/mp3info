%define modname mp3info
%define modversion 1.06
%define modpath authors/id/J/JV/JV/%{modname}-%{modversion}.tar.gz
%define modreq perl perl-MP3-Info
%define buildreq perl perl-Module-Build perl-Test-More

Name: %{modname}
Version: %{modversion}
Release: 1
Source: ftp://ftp.cpan.org/pub/CPAN/%{modpath}
URL: http://www.cpan.org/
BuildArch: noarch
BuildRoot: %{_tmppath}/rpm-buildroot-%{name}-%{version}-%{release}
Summary: Perl module %{modname}
License: Perl Artistic or GPL
Group: Applications/Multimedia
Requires: %{modreq}
BuildPrereq: %{buildreq}
Prefix: %{_prefix}

%description
mp3info prints information from MP3 audio files.

%define __find_provides /usr/lib/rpm/find-provides.perl
%define __find_requires /usr/lib/rpm/find-requires.perl

%prep
%setup -q -n %{modname}-%{modversion}

%build
RPM_NOQUERY=1 perl Build.PL
./Build
./Build test

%install
rm -rf %buildroot
./Build install \
	install_path=script=%{_bindir} \
	install_path=bindoc=%{_mandir}/man1 \
	install_path=libdoc=%{_mandir}/man3 \
	destdir=%{buildroot}

[ ! -x /usr/lib/rpm/brp-compress ] || /usr/lib/rpm/brp-compress

find %buildroot \( -name perllocal.pod -o -name .packlist \) -exec rm -vf {} \;
find %{buildroot} -type f -printf "/%P\n" > rpm-files
[ -s rpm-files ] || exit 1

%clean
#rm -rf %buildroot

%files -f rpm-files
%defattr(-,root,root)

%pre
perl -MMP3::Info -e 1

%changelog
* Sun Oct 12 2003 Johan Vromans <jv@cpan.org>
- Adjusted to Module::Build.
* Thu Jul 31 2003 Johan Vromans <jv@cpan.org>
- Initial version.
