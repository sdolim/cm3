#!/bin/sh
# $Id: create-skel.sh,v 1.2 2009-06-07 16:03:50 wagner Exp $

if [ -n "$ROOT" -a -d "$ROOT" ] ; then
  sysinfo="$ROOT/scripts/sysinfo.sh"
  root="${ROOT}"; export root
else
  root=`pwd`
  while [ -n "$root" -a ! -f "$root/scripts/sysinfo.sh" ] ; do
    root=`dirname $root`
  done
  sysinfo="$root/scripts/sysinfo.sh"
  if [ ! -f "$sysinfo" ] ; then
    echo "scripts/sysinfo.sh not found" 1>&2
    exit 1
  fi
  export root
fi
. "$sysinfo"

md() {
  if [ ! -d "${1}" ] ; then
    if mkdir "${1}" ; then
      debug "${1} created"
    else
      echo "cannot create ${1} 1>&2"
      exit 1
    fi
  else
    debug "$1 already exists"
  fi
}

md "${INSTALLROOT}"
md "${INSTALLROOT}/bin"
md "${INSTALLROOT}/doc"
md "${INSTALLROOT}/elisp"
md "${INSTALLROOT}/examples"
md "${INSTALLROOT}/lib"
md "${INSTALLROOT}/man"
md "${INSTALLROOT}/pkg"
