#!/bin/sh
#
# creates backups of essential files
#
BKDIR="${HOME}/BackUps"
DATA="/home/pi"
PRINTER="/home/pi/printer_data/config/BackUps"
EXCLUDE="--exclude=/home/pi/BackUps --exclude=/home/pi/NoBackUp --exclude=*tgz --exclude=*sock"

BASENAME=/usr/bin/basename
CAT=/bin/cat
CHMOD=/bin/chmod
CHOWN=/bin/chown
DATE=/bin/date
ECHO=/bin/echo
MKDIR=/bin/mkdir
MV=/bin/mv
RM=/bin/rm
SUDO=/usr/bin/sudo
TAR=/usr/bin/tar

DOW=`$DATE +%a`
DOM=`$DATE +%d`
DATE=`$DATE +"%Y-%m-%d"`
NOW=`$DATE +"%Y-%m-%d %X"`

if [ ! -d $BKDIR/work/db ]; then
	$MKDIR -p $BKDIR/work/db
fi

$TAR -czf $BKDIR/work/${DATE}_KLIPPER_FULL.tgz $EXCLUDE $DATA
if [ -f $BKDIR/work/${DATE}_KLIPPER_FULL.tgz ] ; then
	$MV $BKDIR/work/${DATE}_KLIPPER_FULL.tgz $BKDIR/${DATE}_KLIPPER_FULL.tgz
    $ECHO "$NOW" > $PRINTER/last_full
    $CHMOD 640 $PRINTER/last_full
fi

$SUDO $CHOWN pi:pi $BKDIR/*
$RM -rf $BKDIR/work

if [ -e $PRINTER/*tgz ]; then
	$RM $PRINTER/*tgz
fi

if [ -f $BKDIR/${DATE}_* ] ; then
    for f in $BKDIR/${DATE}_*
    do
        BNAME=`$BASENAME $f`
        $MV $BKDIR/$BNAME $PRINTER/$BNAME
    done
fi
