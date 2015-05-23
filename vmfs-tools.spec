%define _commit %(git rev-parse --short HEAD)
Name: vmfs-tools
Version:    %{_ver}
Release:    2_%{_commit}%{?dist}
Summary:    VMFS tools for linux

Group: tbd
License: GPLv2
URL:        https://github.com/glandium/vmfs-tools
Source0:    %{name}-%{version}.tar.gz
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-build

BuildRequires: gcc
BuildRequires: make
BuildRequires: libuuid-devel

%description
Mount VMFS via fuse

%prep
%setup -q

%build
%configure
make %{?_smp_mflags}

%install
rm -rf %{buildroot}
make install DESTDIR=%{buildroot}

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
/usr/sbin/*
/usr/share/*
%doc

%changelog
* Tue May 26 2015 Marcus Sorensen <marcus@electron14.com> 0.2.5-2
   Fix > 1TB pointer lookups
   Fix RPM to post build # before commit for cleaner version increment
* Tue May 26 2015 Marcus Sorensen <marcus@electron14.com> 0.2.5-1
   Initial specfile 
   Contains > 256G file read fix (double indirect pointers)
