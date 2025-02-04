#!/system/bin/sh
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2024 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
#

LOGMSG() {
	echo "I:$@" >> /tmp/recovery.log;
}

do_prep() {
	local D=/data/cache/recovery/;
	if [ ! -d $D ]; then
		LOGMSG "Creating $D ...";
		mkdir -p $D;
	fi

	D=/metadata/ota/;
	mount /metadata 2>/dev/null;
	if [ -d $D ]; then
		LOGMSG "Wiping $D ...";
		rm -rf $D 2>/dev/null;
	fi
}

backup_fox() {
	local f=$1;
	if [ -f $f ]; then
		local x=$(unzip -lq $f | grep "payload.bin");
		[ -n "$x" ] && return; # standard payload.bin - no need for a backup
	fi

	local source="/dev/block/bootdevice/by-name/recovery";
	local dest="/tmp/fox_backup.img";
	if [ ! -f $dest ]; then
		LOGMSG "Backing up OrangeFox to \"$dest\"...";
		dd bs=1048576 if=$source of=$dest &>/dev/null;
	fi
}

##
	LOGMSG "Running pre-ROM-flash script...";
	do_prep;
	backup_fox "$@";
	exit 0;
#
