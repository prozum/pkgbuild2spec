#!/usr/bin/env bash
source $1

echo -e "Name:\t\t$pkgname"
echo -e "Version:\t$pkgver"
echo -e "Release:\t%{?dist}"
echo -e "Summary:\t$pkgdesc"
echo -e "License:\t$license"
echo -e "URL:\t\t$url"

for dep in "${makedepends[@]}"
do
	echo -e "BuildRequires:\t$dep"
done

for dep in "${depends[@]}"
do
	echo -e "Requires:\t$dep"
done

n=0
for src in "${source[@]}"
do
	echo -e "Source$n:\t$src"
	((n++))
done

echo -e "\n%prep"
echo -e "%setup"
declare -f prepare | sed -e '1,2d;$ d;s/^[ \t]*//'

echo -e "\n%build"
declare -f build | sed -e '1,2d;$ d;s/^[ \t]*//'

echo -e "\n%install"
declare -f package | sed -e '1,2d;$ d;s/^[ \t]*//'

echo -e "\n%files"
echo -e "# TODO: Add files"

echo -e "\n%changelog"
echo -e "* $(date +"%a %b %d %Y") $(git config user.name) <$(git config user.email)> - $pkgver"
echo -e "- Initial version"
