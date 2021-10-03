#!/bin/sh

SRCDIR='/volume2/Nullpo/'
DESTDIR='/share/USB2/NullpoBackup'
# SRCDIRはスラッシュで終了させること

# SRCDIRが存在しないなら、エラーで終了
if [ ! -d "${SRCDIR}" ]; then
    echo "[ERROR] There is no source directory in ${SRCDIR}." >&2
    echo "Exit Abnormally." >&2
    exit 1
fi

# rsyncのlink-destオプションで参照する、1世代前のディレクトリ名を取得
LINKDEST=$(ls -1l ${DESTDIR} | awk '{print $7}' | tr -d '/' | sort -n | tail -1)
TODAY=$(date +%Y%m%d_%H%M%S)

# ロックファイルである"sentinel"が存在するなら、前回のバックアップが
# 正しく終了していないことを表示して、エラーで終了
if [ -e ${DESTDIR}/sentinel ]; then
    echo "[ERROR] Previous operation is abnormaly finished." >&2
    echo "It may be corrupted hardlinks in ${LINKDEST}." >&2
    echo "Please remove this folder and  ${DESTDIR}sentinel file." >&2
    exit 2
fi

## バックアップ処理 ##
touch ${DESTDIR}/sentinel

echo "rsync -av8  --link-dest=../${LINKDEST}/ ${SRCDIR} ${DESTDIR}/${TODAY}"
rsync -av8 --link-dest="../${LINKDEST}/" "${SRCDIR}" "${DESTDIR}/${TODAY}"

# rsyncの処理が終われば、sentinelファイルを削除して完了
rm ${DESTDIR}/sentinel
