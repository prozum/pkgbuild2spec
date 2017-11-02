#!/usr/bin/env bash

if [[ -z "$1" ]] ; then
    echo "No argument supplied!"
    echo "Usage: pkgbuild2spec PKGBUILD-FILE"
    exit 1
fi

if [[ ! -f "$1" ]] ; then
    echo "File '$1' not found!"
    echo "Usage: pkgbuild2spec PKGBUILD-FILE"
    exit 1
fi

# Load PKGBUILD
source $1

# Gather build system commands
BUILD=$(declare -f build | sed -e '1,2d;$ d;s/^[ \t]*//')
case "$BUILD" in 
    *cmake*)
      BUILD_CMD="%cmake\n%make_build"
      INSTALL_CMD="%cmake_install"
      ;;
    *configure*)
      BUILD_CMD="%configure\n%make_build"
      INSTALL_CMD="%make_install"
      ;;
    *meson*)
      BUILD_CMD="%meson\n%meson_build"
      INSTALL_CMD="%meson_install"
      ;;
    *)
      BUILD_CMD="%make_build"
      INSTALL_CMD="%make_install"
      ;;
esac

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

for src in "${source[@]}"
do
    echo -e "Source$((n++)):\t$src"
done

echo -e "\n%prep"
echo -e "%setup"
declare -f prepare | sed -e '1,2d;$ d;s/^[ \t]*//;s/^/#/'

echo -e "\n%build"
declare -f build | sed -e '1,2d;$ d;s/^[ \t]*//;s/^/#/'
echo -e "$BUILD_CMD"

echo -e "\n%install"
declare -f package | sed -e '1,2d;$ d;s/^[ \t]*//;s/^/#/'
echo -e "$BUILD_INSTALL"

echo -e "\n%files"
echo -e "# TODO: Add files"

echo -e "\n%changelog"
echo -e "* $(date +"%a %b %d %Y") $(git config user.name) <$(git config user.email)> - $pkgver"
echo -e "- Initial version"
