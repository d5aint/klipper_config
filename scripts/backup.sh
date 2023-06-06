#!/bin/sh
#
# creates backups of essential files
#
BKDIR="/home/pi/printer_data/config/BackUps"
DATA="/home/pi"
EXCLUDE="--exclude=/home/pi/BackUps --exclude=/home/pi/NoBackUp --exclude=/home/pi/printer_data/config/BackUps --exclude=*tgz --exclude=*sock"

BASENAME=/usr/bin/basename
CAT=/bin/cat
CHMOD=/bin/chmod
CHOWN=/bin/chown
DATE=/bin/date
ECHO=/bin/echo
MKDIR=/bin/mkdir
MV=/bin/mv
RM=/bin/rm
TAR=/usr/bin/tar

DOW=`$DATE +%a`
DOM=`$DATE +%d`
DATE=`date +"%Y-%m-%d"`
NOW=`date +"%Y-%m-%d %X"`

$MKDIR -p $BKDIR/work/db

if [ -z $1 ] ; then
    DOFULL="false"
else
    if [ $1 = "full" ] ; then
        DOFULL="true"
    else
        DOFULL="false"
    fi
fi

if [ "$DOM" = "01" -o $DOFULL = "true" ] ; then
    ## Full Backup
   $TAR -czf $BKDIR/work/${DATE}_FULL.tgz $EXCLUDE $DATA
   if [ -f $BKDIR/work/${DATE}_FULL.tgz ] ; then
      $MV $BKDIR/work/${DATE}_FULL.tgz $BKDIR/${DATE}_FULL.tgz
      $ECHO "$NOW" > $BKDIR/last_full
      $CHMOD 640 $BKDIR/last_full
      $RM -f $BKDIR/*DIFF.tgz*
   fi
else
   ## Differential Backup
   NEWER=`$CAT $BKDIR/last_full`
   $TAR --newer="$NEWER" -czf $BKDIR/work/${DATE}_DIFF.tgz $EXCLUDE $DATA
   if [ -f $BKDIR/work/${DATE}_DIFF.tgz ] ; then
      $RM -f $BKDIR/*DIFF.tgz*
      $MV $BKDIR/work/${DATE}_DIFF.tgz $BKDIR/${DATE}_DIFF.tgz
   fi
fi

$RM -rf $BKDIR/work
