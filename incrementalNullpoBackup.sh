#!/bin/sh

#THIS SCRIPT IS BUILDED FOR SKYLARK, AND IT SHOULD BE LOCATED IN SKYLARK.
#WHEN THIS SCRIPT IS LOCATED IN OTHER HOST,
#IT MEANS BACKUP.

NULLPODIR='/volume2/Nullpo/'
DESTDIR='/share/USB2/NullpoBackup'
#DESTDIR='/volume1/NullpoBackup'
#DESTDIR='/volume1/home/hayato/Backups/NullpoBackups'
# NULLPODIR MUST TERMINATED WITH SLASH.

#if [ `pwd` != ${DESTDIR} ]; then
# echo "Please locate this script into ${DESTDIR}, and exec me in ${DESTDIR}."
# echo "Exit Abnormally."
# exit 1
#fi

if [ ! -d ${NULLPODIR} ]; then
    echo "[ERROR] There is no Nullpo directory in ${NULLPODIR}." >&2
    echo "Exit Abnormally." >&2
    exit 1
fi

LINKDEST=`ls -1l ${DESTDIR} | awk '{print $7}' | tr -d '/' | sort -n | tail -1`
TODAY=`date +%Y%m%d_%H%M%S`

if [ -e ${DESTDIR}/sentinel ]; then
    echo "[ERROR] Previous operation is abnormaly finished." >&2
    echo "It may be corrupted hardlinks in ${LINKDEST}." >&2
    echo "Please remove this folder and  ${DESTDIR}sentinel file." >&2
    exit 2
fi

touch ${DESTDIR}/sentinel

echo "rsync -av8  --link-dest=../${LINKDEST}/ ${NULLPODIR} ${DESTDIR}/${TODAY}"
rsync -av8 --link-dest=../${LINKDEST}/ ${NULLPODIR} ${DESTDIR}/${TODAY}

rm ${DESTDIR}/sentinel
