Name: flat-remix-gnome
Version: 20191116
Release: 1
License: CC-BY-SA-4.0
Summary: Flat Remix GNOME theme
Url: https://drasite.com/flat-remix-gnome
Group: User Interface/Desktops
Source: https://github.com/daniruiz/%{name}/archive/%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-build
BuildArch: noarch
Requires: gnome-shell, make, glib2-devel, ImageMagick

%description
Flat Remix GNOME theme is a pretty simple shell theme inspired on material design following a modern design using "flat" colors with high contrasts and sharp borders.

Themes:
 • Flat Remix
 • Flat Remix Dark
 • Flat Remix Darkest
 • Flat Remix Miami
 • Flat Remix Miami Dark

Variants:
 • Full Panel: No topbar spacing


%prep
%setup -q

%install
%make_install

%build


%post
cd /usr/share/flat-remix-gnome
make
make install


%preun
if [ $1 == 0 ]
then
	cd /usr/share/flat-remix-gnome
	make uninstall
fi

%files
%defattr(-,root,root)
%doc LICENSE README.md
%{_datadir}/flat-remix-gnome

