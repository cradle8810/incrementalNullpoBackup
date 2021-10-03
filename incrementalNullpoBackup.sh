#!/bin/sh

SRCDIR='/volume2/Nullpo/'
DESTDIR='/share/USB2/NullpoBackup'
# SRCDIRはスラッシュで終了させること

if [ ! -d "${SRCDIR}" ]; then
    echo "[ERROR] There is no source directory in ${SRCDIR}." >&2
    echo "Exit Abnormally." >&2
    exit 1
fi

LINKDEST=$(ls -1l ${DESTDIR} | awk '{print $7}' | tr -d '/' | sort -n | tail -1)
TODAY=$(date +%Y%m%d_%H%M%S)

if [ -e ${DESTDIR}/sentinel ]; then
    echo "[ERROR] Previous operation is abnormaly finished." >&2
    echo "It may be corrupted hardlinks in ${LINKDEST}." >&2
    echo "Please remove this folder and  ${DESTDIR}sentinel file." >&2
    exit 2
fi

touch ${DESTDIR}/sentinel

echo "rsync -av8  --link-dest=../${LINKDEST}/ ${SRCDIR} ${DESTDIR}/${TODAY}"
rsync -av8 --link-dest="../${LINKDEST}/" "${SRCDIR}" "${DESTDIR}/${TODAY}"

rm ${DESTDIR}/sentinel
