#!/bin/bash
#
# Description:
# This script configures automatically:
#
#  1. daily snapshots via btrfs
#  2. logwatch weekly report
#
# You may check out this:
# https://github.com/micressor/howtos-linux/blob/master/Desktop/backup-howto.md
#
# Usage:
#   $ sudo ./configure.sh
#

# check root
if [ "${LOGNAME}" != "root" ];
then
  echo This script must run as root.
  exit 1
fi

# install btrbk
if ! dpkg -l btrbk | grep ii;
then
apt-get -y -t testing install btrbk
else
  echo Notice: btrbk is already installed.
fi

# create _SNAPSHOTS dirs
home_dirs=`find /home/ -maxdepth 1 -type d`;
for i in $home_dirs;
do
  if [ ! -d "${i}/_SNAPSHOTS" ];
  then
    mkdir ${i}/_SNAPSHOTS
  fi
done
# Directly in /home we do not need.
rm -rf /home/_SNAPSHOTS

echo Next Steps:

# install btrbk.conf
if [ ! -f /etc/btrbk/btrbk.conf ];
then
cat << EOF >/etc/btrbk/btrbk.conf
# Preserve matrix for source snapshots:
snapshot_preserve_min      14d
snapshot_preserve          14d 4w 3m

# Preserve matrix for backup targets:
target_preserve_min        14d
snapshot_preserve          14d 4w 6m

timestamp_format long

volume /home
  subvolume user1
    snapshot_dir user1/_SNAPSHOTS
  subvolume user2
    snapshot_dir user2/_SNAPSHOTS
EOF
  echo 1. Configure /etc/btrbk/btrbk.conf
else
  if grep user1 /etc/btrbk/btrbk.conf;
  then
    echo Warning: /etc/btrbk/btrbk.conf is installed but not configured
  else
    echo Notice: /etc/btrbk/btrbk.conf already installed.
  fi
fi


# install daily btrfs snapshot job
if [ ! -f /etc/cron.daily/btrfs ];
then
cat << EOF >/etc/cron.daily/btrfs
#!/bin/bash
exec 1>/dev/null
btrbk run
sync
EOF
chmod +x /etc/cron.daily/btrfs
else
  echo Notice: /etc/cron.daily/btrfs already installed.
fi

# install weekly btrfs filesystem maintenance
if [ ! -f /etc/cron.weekly/btrfs ];
then
cat << EOF >>/etc/cron.weekly/btrfs
#!/bin/bash
# Vars
BALANCE_MOUNT='/home'
BALANCE_DUSAGE=55
btrfs filesystem show
for i in $BALANCE_MOUNT;
do
  btrfs balance start -dusage=$BALANCE_DUSAGE $i;
done
btrbk stats
btrbk list latest
EOF
else
  echo Notice: /etc/cron.weekly/btrfs already installed.
fi

echo Test daily snapshots: sudo bash -x /etc/cron.daily/btrfs

# configure logwatch
if [ -f /etc/cron.daily/00logwatch ];
then
  dpkg-divert --local --rename --divert /etc/cron.weekly/00logwatch --add /etc/cron.daily/00logwatch
  sed -e "s/\/usr\/sbin\/logwatch --output mail/\/usr\/sbin\/logwatch --range \'since 7 days ago\' --output mail/g" /etc/cron.weekly/00logwatch >/tmp/00logwatch
  cp /tmp/00logwatch /etc/cron.weekly/00logwatch
fi
