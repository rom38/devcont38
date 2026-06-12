#!/usr/bin/env bash
set -e -u

PACKAGES=""

# For en_US.UTF-8 locale.
PACKAGES+=" locales"

# To build python pyenv
PACKAGES+=" build-essential" 
PACKAGES+=" libssl-dev"
PACKAGES+=" zlib1g-dev"
PACKAGES+=" libbz2-dev"
PACKAGES+=" libreadline-dev"
PACKAGES+=" libsqlite3-dev"
PACKAGES+=" curl"
PACKAGES+=" libncursesw5-dev"
PACKAGES+=" xz-utils tk-dev"
PACKAGES+=" libxml2-dev"
PACKAGES+=" libxmlsec1-dev"
PACKAGES+=" libffi-dev"
PACKAGES+=" liblzma-dev"

# Used by build-package.sh and CI/CD scripts.
PACKAGES+=" gnupg"

# Used for fetching package sources from Git repositories.
PACKAGES+=" git"

# Used for extracting package sources.
PACKAGES+=" lzip"
PACKAGES+=" tar"
PACKAGES+=" unzip"

# Used by common build systems.
PACKAGES+=" info"
PACKAGES+=" gawk"
PACKAGES+=" gettext"
PACKAGES+=" gperf"
PACKAGES+=" m4"

# Used to generate package documentation.

# Needed by python modules (e.g. asciinema) and some build systems.

# Needed by package bc.
PACKAGES+=" ed"

# Needed by gnunet.

# Provides utility hexdump which is needed by package bitcoin.

# Needed by package seafile-client.

# Needed by package libgcrypt.
PACKAGES+=" fig2dev"

# Needed by package gimp.
# PACKAGES+=" gegl"

# Needed by package libidn2.
# PACKAGES+=" gengetopt"

# Needed by package proxmark3-git.
# PACKAGES+=" swig"

# Needed by package dbus-glib.
# PACKAGES+=" libdbus-1-dev"

# Needed by package below.
# PACKAGES+=" libelf-dev"

# Needed by package ghostscript.
# PACKAGES+=" libexpat1-dev"
# PACKAGES+=" libjpeg-dev"

# Needed by package news-flash-gtk.
PACKAGES+=" libsqlite3-dev"

# Needed by package vlc.
# PACKAGES+=" lua5.2"

# Needed by package luarocks.
PACKAGES+=" lua5.3"

# Used bt host build of package mariadb.
#PACKAGES+=" libncurses5-dev"

# Needed by packages mkvtoolnix and ruby.
# PACKAGES+=" ruby"

# Needed by host build of package nodejs.
PACKAGES+=" libc-ares-dev"
PACKAGES+=" libicu-dev"

# Needed by php.
# PACKAGES+=" re2c"

# Needed by composer.
# PACKAGES+=" php"
# PACKAGES+=" composer"

# Needed by package rust.
#PACKAGES+=" libssl-dev" # Needed to build Rust
#PACKAGES+=" llvm-12-dev"
#PACKAGES+=" llvm-12-tools"
#PACKAGES+=" clang-12"

# Needed for package smalltalk.
# PACKAGES+=" libsigsegv-dev"
# PACKAGES+=" zip"

# Needed for package sqlcipher.
# PACKAGES+=" tcl"

# Needed by package swi-prolog.
PACKAGES+=" openssl"
PACKAGES+=" zlib1g-dev"
PACKAGES+=" libssl-dev"
PACKAGES+=" zlib1g-dev"

# For swift.
# PACKAGES+=" lld"
# PACKAGES+=" patchelf"

# Needed by wrk.
PACKAGES+=" luajit"

# Needed by libduktape
PACKAGES+=" bc"

# Java.
# PACKAGES+=" openjdk-8-jdk openjdk-16-jdk"

# needed by ovmf
# PACKAGES+=" libarchive-tools"

# Needed by cavif-rs
# PACKAGES+=" nasm"

# Needed by dgsh
PACKAGES+=" rsync"

# Needed by megacmd
PACKAGES+=" wget"


# utilks
PACKAGES+=" ncdu"
PACKAGES+=" tree"
PACKAGES+=" fd-find"
# script setup-fzf.sh
# PACKAGES+=" fzf"
# PACKAGES+=" readline"
PACKAGES+=" ca-certificates"
PACKAGES+=" sysbench"
PACKAGES+=" tmux"
PACKAGES+=" bat"
PACKAGES+=" mc"
PACKAGES+=" htop"

# fish setup-fish.sh
# PACKAGES+=" fish"
PACKAGES+=" ninja-build"
PACKAGES+=" cmake"
PACKAGES+=" lf"

# Needed by packages in unstable repository.
# PACKAGES+=" comerr-dev"
# PACKAGES+=" docbook-to-man"
# PACKAGES+=" docbook-utils"
# PACKAGES+=" erlang-nox"
# PACKAGES+=" heimdal-multidev"
# PACKAGES+=" libconfig-dev"
# PACKAGES+=" libevent-dev"
# PACKAGES+=" libgc-dev"
# PACKAGES+=" libgmp-dev"
# PACKAGES+=" libjansson-dev"
# PACKAGES+=" libparse-yapp-perl"
# PACKAGES+=" libreadline-dev"
# PACKAGES+=" libunistring-dev"
# PACKAGES+=" llvm-12-dev"
# PACKAGES+=" llvm-12-tools"

# Needed by packages in X11 repository.
# PACKAGES+=" alex"
# PACKAGES+=" docbook-xsl-ns"
# PACKAGES+=" gnome-common"
# PACKAGES+=" gobject-introspection"
# PACKAGES+=" gtk-3-examples"
# PACKAGES+=" gtk-doc-tools"
# PACKAGES+=" happy"
# PACKAGES+=" itstool"
# PACKAGES+=" libdbus-glib-1-dev-bin"
# PACKAGES+=" libgdk-pixbuf2.0-dev"
# PACKAGES+=" libwayland-dev"
# PACKAGES+=" python-setuptools"
# PACKAGES+=" python3-xcbgen"
# PACKAGES+=" sassc"
# PACKAGES+=" texlive-extra-utils"
# PACKAGES+=" wayland-scanner++"
# PACKAGES+=" xfce4-dev-tools"
# PACKAGES+=" xfonts-utils"
# PACKAGES+=" xutils-dev"

# Needed by packages in science repository
# PACKAGES+=" protobuf-c-compiler"
PACKAGES+=" sqlite3"

# Needed by packages in game repository
# PACKAGES+=" cvs"
# PACKAGES+=" python3-yaml"

# Needed by apt.
# PACKAGES+=" triehash"

# Needed by aspell dictionaries.
# PACKAGES+=" aspell"

# Needed by package kphp.
# PACKAGES+=" python3-jsonschema"

# Needed by package lilypond.
# PACKAGES+=" fontforge-nox"
# PACKAGES+=" guile-2.2"
# PACKAGES+=" python3-fontforge"
# PACKAGES+=" texlive-metapost"

# Needed by proxmark3/proxmark3-git
# PACKAGES+=" gcc-arm-none-eabi"

# Needed by pypy
# PACKAGES+=" qemu-user-static"

# For opt, llvm-link, llc not shipped by NDK.
# Required by picolisp (and maybe a few others in future)
# PACKAGES+=" llvm-12"

# Required by cava
# PACKAGES+=" xxd"

# Required for parsing repo.json
PACKAGES+=" jq"

# Do not require sudo if already running as root.
if [ "$(id -u)" = "0" ]; then
	SUDO=""
else
	SUDO="sudo"
fi

# Allow 32-bit packages.
# $SUDO dpkg --add-architecture i386
$SUDO apt-get -yq update

PACKAGES_FILT=
pkg=
for pkg in $PACKAGES; do
    # echo $pkg
    if [ $(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    PACKAGES_FILT+="$pkg " 
    fi
done
# echo $PACKAGES_FILT
$SUDO env DEBIAN_FRONTEND=noninteractive \
	apt-get install -yq --no-install-recommends $PACKAGES_FILT

# Pip for python2.
# curl -L --output /tmp/py2-get-pip.py https://bootstrap.pypa.io/pip/2.7/get-pip.py
# $SUDO python2 /tmp/py2-get-pip.py
# rm -f /tmp/py2-get-pip.py

# $SUDO locale-gen --purge en_US.UTF-8
# echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' | $SUDO tee -a /etc/default/locale

#. $(dirname "$(realpath "$0")")/properties.sh
# $SUDO mkdir -p $TERMUX_PREFIX
# $SUDO chown -R $(whoami) /data
