#!/bin/sh
#
# creates backups of essential files
#

BKDIR="${HOME}/BackUps"
DATA="${HOME}/printer_data"
PRINTER="${HOME}/printer_data/config/BackUps"
EXCLUDE="--exclude=*tgz --exclude=*sock --exclude=*bkp"

DATE=`date +"%Y-%m-%d"`

if [ ! -d $BKDIR/work/db ]; then
	mkdir -p $BKDIR/work/db
fi

if [ -e "${HOME}/printer_data/backup/MOONRAKER.DATA" ]; then
	rm "${HOME}/printer_data/backup/MOONRAKER.DATA"
fi
#$HOME/moonraker/scripts/backup-database.sh -o "${HOME}/printer_data/backup/MOONRAKER.DATA"

tar -czf "${BKDIR}/work/${DATE}_KLIPPER_FULL.tgz" $EXCLUDE $DATA
if [ -f "${BKDIR}/work/${DATE}_KLIPPER_FULL.tgz" ] ; then
	if [ -e "${PRINTER}/${DATE}_KLIPPER_FULL.tgz" ]; then
		rm "$PRINTER/${DATE}_KLIPPER_FULL.tgz"
	fi
	mv "${BKDIR}/work/${DATE}_KLIPPER_FULL.tgz" "${PRINTER}/${DATE}_KLIPPER_FULL.tgz"
	sudo chown pi:pi $PRINTER/*
fi

rm -rf $BKDIR/work

if [ $? -eq 0 ]; then
	MSG="Printer config backup was successfull."
	echo "VALUE_UPDATE:status=${MSG}"
	exit 0
else
	MSG="Printer config backup failed!"
	echo "VALUE_UPDATE:status=${MSG}"
    exit 1
fi