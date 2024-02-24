#!/bin/sh
#
# creates backups of essential files
#
BKDIR="${HOME}/BackUps"
DATA="${HOME}/printer_data"
PRINTER="${HOME}/printer_data/config/BackUps"
EXCLUDE="--exclude=*tgz --exclude=*sock --exclude=*bkp"

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

if [ -e "${HOME}/printer_data/backup/MOONRAKER.DATA" ]; then
	$RM "${HOME}/printer_data/backup/MOONRAKER.DATA"
fi
$HOME/moonraker/scripts/backup-database.sh -o "${HOME}/printer_data/backup/MOONRAKER.DATA"

$TAR -czf "${BKDIR}/work/${DATE}_KLIPPER_FULL.tgz" $EXCLUDE $DATA
if [ -f "${BKDIR}/work/${DATE}_KLIPPER_FULL.tgz" ] ; then
	if [ -e $PRINTER/*tgz ]; then
		$RM $PRINTER/*tgz
	fi
	$MV "${BKDIR}/work/${DATE}_KLIPPER_FULL.tgz" "${PRINTER}/${DATE}_KLIPPER_FULL.tgz"
	$SUDO $CHOWN pi:pi $PRINTER/*
fi

$RM -rf $BKDIR/work


if [ $? -eq 0 ]; then
	MSG="Printer config backup was successfull."
	echo "VALUE_UPDATE:status=${MSG}"
	exit 0
else
	MSG="Printer config backup failed!"
	echo "VALUE_UPDATE:status=${MSG}"
    exit 1
fi