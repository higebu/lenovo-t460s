# Installing Debian 8.6 on Lenovo Thinkpad t460s

## Overall Status

This repo generates a debian NetInst `.iso` file for t460s.

1. For installation: Access to internet via eth0 interface is needed.
2. It creates a user `debian` with password `insecure`
3. User `root`has no password. Access to root via `sudo su -`
4. It creates an encrypted LVM partitioning with
	* /boot type ext4 size 250 MiB
	* / type ext4`size 10 GiB
	* /home type btrfs size rest of space

Feel free to change thinks (see [t460s.postinst](https://github.com/micressor/lenovo-t460s/blob/master/profiles/t460s.postinst) and [t460s.preseed](https://github.com/micressor/lenovo-t460s/blob/master/profiles/t460s.preseed)) before
you create the `.iso`.

**WARNING:** this is an almost fully automated installation. Once you boot
from the USB media: **!!! ALL EXISTING DATA ON THE DRIVE WILL BE LOST !!!**

*Last successful test was tag [0.1](https://github.com/micressor/lenovo-t460s/tree/0.1) with debian 8.6 (jessie).*

Have you successful tested a later version of this repo?
Open a issue and let me know. Thanks. :-)

### Core Components

* Boot Standard Kernel:	4.7
* LAN network card: OK
* Hibernation: OK with `acpitool -s`
* Sleep / Suspend: OK with `acpitool -S`
* Switch to External Screen: OK
* Built-in (Trackpoint): OK
* Built-in (Touchpad): OK
* Wireless/Wifi: OK
* Keyboard's Hotkeys: OK

## Known issues

* Sleep / Suspend doesn't work on lid close -> [Kernel Bug Tracker](https://bugzilla.kernel.org/buglist.cgi?content=t460s&no_redirect=1&order=Importance&query_format=specific)

## 1. On Windows: Update UEFI BIOS

1. The easiest way to update UEFI BIOS, do it on windows. Download and flash
the latest from [here.](https://filedownload.lenovo.com/supportdata/product.html?id=Laptops-and-netbooks/ThinkPad-T-Series-laptops/ThinkPad-T460s)

## 2. Build debian netinst CD form this repo

	apt-get update
	apt-get install -y simple-cdd git xorriso
	mkdir ~/src
	git clone https://github.com/micressor/lenovo-t460s.git
	cd lenovo-t460s
	sudo build-simple-cdd --conf profiles/t460s.conf --dist jessie --force-root

## 3. Install .iso to usb media

Copy generated `.iso` file to your usb media device `/dev/sdX`:

	dd if=images/debian-8.6-amd64-CD-1.iso of=/dev/sdX bs=1M
	sync

## 4. Prepare UEFI BIOS

Configure your BIOS like this:

* Restart -> Load Setup Defaults

* Config -> USB -> USB UEFI BIOS Support [Enabled]

* Security -> Secure Boot -> Secure Boot [Enabled]

* Security -> Secure Boot -> Reset to Setup Mode -> [Enter]

This changes Platform Mode to `Setup Mode` and Secure Boot Mode to
`Custom Mode`.

To get HDMI Port working:

* Config -> Display -> Boot Display [Display on dock]

### Optional

* Config -> Keyboard/Mouse -> F1-F12 as Primary Function [Enabled]

## 5. Install from media

**WARNING:** this is an almost fully automated installation. Once you boot
from the USB media: **!!! ALL EXISTING DATA ON THE DRIVE WILL BE LOST !!!**

Insert your usb media and boot your t460s with F12 option to select your
media. **Note**: Not all usb media's (I use a SanDisk) are recognised.

## The magic: What is necessary to get run t460s

In a nutshell (or check out [t460s.postinst](https://github.com/micressor/lenovo-t460s/blob/master/profiles/t460s.postinst) file):

* firmware-iwlwifi (>=20160824-1) from testing
* firmware-misc-nonfree (>=20160824-1) from testing
* linux-image-amd64 (>=linux-image-4.7.0-0.bpo.a.amd64) from jessie-backports
* xserver-xorg-video-intel (>=2:2.99.917+git201607) from jessie-backports

# Binary releases

64-bit installer ISO images are available at GitHub in Releases section:
https://github.com/micressor/lenovo-t460s/releases

## Errata to the binary release

1. [Enable TRIM on encrypted disk](https://wiki.ubuntuusers.de/SSD/TRIM/#TRIM-mit-Festplattenverschluesselung)

2. Verify that ssd mountoption on btrfs filesystem at /home is set:

	mount -t btrfs | grep ssd

# Contributing

Feel free to create [issues](https://github.com/micressor/lenovo-t460s/issues)
and  [pull requests](https://github.com/micressor/lenovo-t460s/pulls).

## Links

* This document is inspired by [DebianOn -> t460s](https://wiki.debian.org/InstallingDebianOn/Thinkpad/T460s/stretch).
* [partman-auto/expert_recipe findings](https://wikitech.wikimedia.org/wiki/PartMan)
* [wiki.debian.org: Preseed files](https://wiki.debian.org/DebianInstaller/Preseed)
* [Debian GNU/Linux – Installationsanleitung: Anhang B. Automatisieren der Installation mittels Voreinstellung](https://www.debian.org/releases/stable/amd64/apb.html)
* [ubuntuusers -> TRIM](https://wiki.ubuntuusers.de/SSD/TRIM/)
* [ubuntuusers -> BTRFS-Mountoptionen](https://wiki.ubuntuusers.de/Btrfs-Mountoptionen/)
* [ubuntuusers -> TRIM mit Festplattenverschlüsselung](https://wiki.ubuntuusers.de/SSD/TRIM/#TRIM-mit-Festplattenverschluesselung)

# License

lenovo-t460s is free software, available under the [GNU General Public License, Version 3](http://www.gnu.org/licenses/gpl.html).
