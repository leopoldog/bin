#!/bin/bash
# $Id: make.leo,v 1.1.1.1 2014-07-17 20:34:05 lghi Exp $
# $Author: lghi $
# $Locker:  $
# $Log: make.leo,v $
# Revision 1.1.1.1  2014-07-17 20:34:05  lghi
#
#
# Revision 2.0.1.1  2000/06/28 17:21:13  lghi
# Namespace version, no modifications made
#
# Revision 2.0  2000/04/26 13:33:03  rcom_vs
# Modifications pour Valais
#
# Revision 1.2  2000/04/10 14:25:40  LGHI
# Added support for Linux
#
# Revision 1.1  2000/03/09 15:16:54  rcom_dev
# Initial revision
#

if [ -f .makelock ]
then
  \echo the makefile is locked
else
  trap '\rm -f .makelock' 2 3

  \touch .makelock

  case "`uname -s`" in
    Linux)
	/usr/bin/make $@
	;;
    SunOS)
	/usr/local/bin/make $@
	;;
    *)
	echo Unknown system `uname -s`
	;;
  esac

  \rm -f .makelock
fi
