Summary: TCPWrappers Puppet Module
Name: pupmod-tcpwrappers
Version: 3.0.0
Release: 3
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: pupmod-auditd >= 2.0.0-0
Requires: pupmod-simpcat >= 2.0.0-0
Requires: pupmod-rsyslog >= 2.0.0-0
Requires: pupmod-common >= 4.2.0-0
Requires: pupmod-simplib >= 1.0.0-0
Requires: puppet >= 3.3.0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-tcpwrappers-test

Prefix:"/etc/puppet/environments/simp/modules"

%description
This Puppet module allows you to manage /etc/hosts.allow, /etc/hosts.deny is set
to ALL:ALL by default.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/tcpwrappers

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/tcpwrappers
done

mkdir -p %{buildroot}/usr/share/simp/tests/modules/tcpwrappers

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/tcpwrappers

%files
%defattr(0640,root,puppet,0750)
/etc/puppet/environments/simp/modules/tcpwrappers

%post
#!/bin/sh

if [ -d /etc/puppet/environments/simp/modules/tcpwrappers/plugins ]; then
  /bin/mv /etc/puppet/environments/simp/modules/tcpwrappers/plugins /etc/puppet/environments/simp/modules/tcpwrappers/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Mon Nov 09 2015 Chris Tessmer <chris.tessmer@onypoint.com> - 3.0.0-3
- migration to simplib and simpcat (lib/ only)

* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 3.0.0-2
- Changed puppet-server requirement to puppet

* Sun Jun 22 2014 Kendall Moore <kmoore@keywcorp.com> - 3.0.0-1
- Removed MD5 file checksums for FIPS compliance.

* Thu Jun 19 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 3.0.0-1
- Updated to not cast lpattern to an Array in tcpwrappers.allow.erb
  for compatibility with Ruby 2.

* Wed Apr 30 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 3.0.0-0
- Updated to use an array for the allow and to use the new ipaddresses function
  in common to provide all local addresses to the initial line.

* Thu Jan 09 2014 Nick Markowski <nmarkowski@keywcorp.com> - 2.1.0-0
- Updated module for puppet3/hiera compatibility, and optimized code for lint tests,
  and puppet-rspec.
- Removed tcpwrappers::tcpwrappers_allow

* Tue Oct 08 2013 Kendall Moore <kmoore@keywcorp.com> - 2.0.0-8
- Updated all erb templates to properly scope variables.

* Fri Aug 02 2013 Kendall Moore <kmoore@keywcorp.com> -2.0.0-7
- Updated the tcpwrappers.allow template because function calls require
  an argument of an array rather than allowing for single string arguments.

* Wed Apr 10 2013 Maintenance
2.0.0-6
- Added 127.0.0.1 to the list of always allowed hosts. Apparently, there was a
  bug in the way that NFS interacts with tcpwrappers that can occasionally fail
  if this isn't in place. Honestly, I can't figure out why but it works.

* Tue Jan 15 2013 Maintenance
2.0.0-5
- Created a Cucumber test which adds a tcpwrapper for nscd and checks
  /etc/hosts.allow to ensure that an entry is there to reflect the change.

* Thu Jun 07 2012 Maintenance
2.0.0-4
- Ensure that Arrays in templates are flattened.
- Call facts as instance variables.
- Moved mit-tests to /usr/share/simp...
- Converted the internal nets2ddq code to use the 'common' function.
- Updated to work properly with IPv6 addresses.
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Mar 02 2012 Maintenance
2.0.0-3
- Improved test stubs.

* Fri Dec 23 2011 Maintenance
2.0.0-2
- Updated the spec file to not require a separate file list.
- Changed all instances of 'ipaddress' to 'primary_ipaddress'.

* Fri Feb 11 2011 Maintenance
2.0.0-1
- Updated to use concat_build and concat_fragment types.

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Tue Oct 26 2010 Maintenance - 1-2
- Converting all spec files to check for directories prior to copy.

* Mon Oct 04 2010 Maintenance
1.0-1
- Support for comma separated entries on the LHS of the hosts.allow file.

* Mon May 24 2010 Maintenance
1.0-0
- Code refactoring.

* Mon Nov 02 2009 Maintenance
0.1-11
- Now remove subsequent entries from the list.
