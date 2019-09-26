Name: flat-remix-gnome
Version: 20190926
Release: 1
License: CC-BY-SA-4.0
Summary: Flat Remix GNOME theme
Url: https://drasite.com/flat-remix-gnome
Group: User Interface/Desktops
Source: https://github.com/daniruiz/%{name}/archive/%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-build
BuildArch: noarch

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
mv -n /usr/share/gnome-shell/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource.old
ln -sf /usr/share/themes/Flat-Remix/gnome-shell-theme.gresource /usr/share/gnome-shell/gnome-shell-theme.gresource


%postun
mv /usr/share/gnome-shell/gnome-shell-theme.gresource.old /usr/share/gnome-shell/gnome-shell-theme.gresource

%files
%defattr(-,root,root)
%doc LICENSE README.md
%{_datadir}/themes/Flat-Remix-Miami-Dark
%{_datadir}/themes/Flat-Remix-Darkest
%{_datadir}/themes/Flat-Remix-Dark
%{_datadir}/themes/Flat-Remix-Miami
%{_datadir}/themes/Flat-Remix
%{_datadir}/gnome-shell/theme/Flat-Remix-Miami-Dark
%{_datadir}/gnome-shell/theme/Flat-Remix-Darkest
%{_datadir}/gnome-shell/theme/Flat-Remix-Dark
%{_datadir}/gnome-shell/theme/Flat-Remix-Miami
%{_datadir}/gnome-shell/theme/Flat-Remix
%{_datadir}/themes/Flat-Remix-Miami-Dark-fullPanel
%{_datadir}/themes/Flat-Remix-Darkest-fullPanel
%{_datadir}/themes/Flat-Remix-Dark-fullPanel
%{_datadir}/themes/Flat-Remix-Miami-fullPanel
%{_datadir}/themes/Flat-Remix-fullPanel
%{_datadir}/gnome-shell/theme/Flat-Remix-Miami-Dark-fullPanel
%{_datadir}/gnome-shell/theme/Flat-Remix-Darkest-fullPanel
%{_datadir}/gnome-shell/theme/Flat-Remix-Dark-fullPanel
%{_datadir}/gnome-shell/theme/Flat-Remix-Miami-fullPanel
%{_datadir}/gnome-shell/theme/Flat-Remix-fullPanel
%{_datadir}/gnome-shell/theme/assets
%{_datadir}/gnome-shell/modes
%{_datadir}/xsessions
%{_datadir}/wayland-sessions

