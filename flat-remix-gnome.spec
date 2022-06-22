Name:           flat-remix-gnome
Version: 20220622
Release:        1
License:        CC-BY-SA-4.0
Summary:        Flat Remix GNOME theme
Url:            https://drasite.com/flat-remix-gnome
Group:          User Interface/Desktops
Source:         https://github.com/daniruiz/%{name}/archive/%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildArch:      noarch
Requires:       glib2-devel, gnome-extensions-app, gnome-shell >= 42.0, gnome-shell-extension-user-theme, ImageMagick, make
BuildRequires:  make

%description
Flat Remix is a GNOME Shell theme inspired by material design. It is mostly flat using a colorful palette with some shadows, highlights, and gradients for some depth.

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
%doc LICENSE README.md
%{_datadir}/flat-remix-gnome

