#!/bin/sh
# Begin $rc_base/init.d/nfs-server

# Based on sysklogd script from LFS-3.1 and earlier.
# Rewritten by Gerard Beekmans  - gerard@linuxfromscratch.org

#$LastChangedBy: bdubbs $
#$Date: 2006-09-10 19:41:47 -0500 (Sun, 10 Sep 2006) $

. /etc/sysconfig/rc
. $rc_functions
. /etc/sysconfig/nfs-server
newuser=nobody
newgroup=nogroup
newid=99
getent group $newgroup || /usr/bin/groupadd -g $newid $newgroup
getent passwd $newuser || /usr/bin/useradd -c "Unprivileged Nobody" \
-g $newgroup -u $newid -d /dev/null -s /bin/false $newuser
case "$1" in
	start)
		boot_mesg "Starting NFS mountd..."
		loadproc /usr/sbin/rpc.mountd

		boot_mesg "Starting NFS nfsd..."
		loadproc /usr/sbin/rpc.nfsd -p $PORT $PROCESSES

		boot_mesg "Starting NFS statd..."
		loadproc /usr/sbin/rpc.statd

		if [ "$QUOTAS" = "yes" ]; then
			boot_mesg "Starting NFS rquotad..."
			loadproc /usr/sbin/rpc.rquotad
		fi

		# NFSD support only in 2.6 kernel
		/bin/uname -r | /bin/grep "2.6" 2>&1 > /dev/null
		if [ $? = 0 ]; then
			boot_mesg "Mounting nfsd virtual filesystem..."
			/bin/mount -t nfsd none /proc/fs/nfsd 2>&1 > /dev/null
			evaluate_retval
		fi

		# Make ceratin that the list is refreshed on
		# a restart.
		boot_mesg "Exporting NFS Filesystems..."
		/usr/sbin/exportfs -ra 2>&1 > /dev/null
		evaluate_retval
		;;

	stop)
		boot_mesg "Stopping NFS statd..."
		killproc /usr/sbin/rpc.statd

		boot_mesg "Stopping NFS nfsd..."
		# nfsd needs HUP....
		killproc nfsd HUP

		boot_mesg "Stopping NFS mountd..."
		killproc /usr/sbin/rpc.mountd

		if [ "$QUOTAS" = "yes" ]; then
			boot_mesg "Stopping NFS rquotad..."
			killproc /usr/sbin/rpc.rquotad
		fi

		boot_mesg "Refreshing NFS Exported Filesystems..."
		/usr/sbin/exportfs -au 2>&1 > /dev/null
		evaluate_retval

		# NFSD support only in 2.6 kernel
                /bin/uname -r | /bin/grep "2.6" 2>&1 > /dev/null
                if [ $? = 0 ]; then
			boot_mesg "Unmounting NFS Virtual Filesystem..."
			/bin/umount /proc/fs/nfsd 2>&1 > /dev/null
			evaluate_retval
		fi

		# Remove a pid file that isn't done automatically
		boot_mesg "Removing the rpc.statd pid file if it exists"
		if [ -f /var/run/rpc.statd.pid ]; then
		    rm -f /var/run/rpc.statd.pid
		fi
		;;

	reload)
		boot_mesg "Reloading NFS Server..."
		/usr/sbin/exportfs -ra
		evaluate_retval
		;;

	restart)
		$0 stop
		sleep 1
		$0 start
		;;

	status)
		statusproc /usr/sbin/rpc.mountd
		## Special case for nfsd with no full path
		statusproc nfsd
		statusproc /usr/sbin/rpc.statd
		if [ "$QUOTA" = "yes" ]; then
			statusproc rpc.rquotad
		fi
		;;

	*)
		echo "Usage: $0 {start|stop|reload|restart|status}"
		exit 1
		;;
esac

# End $rc_base/init.d/nfs-server
