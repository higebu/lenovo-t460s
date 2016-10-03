# Installing Debian 8.6 on Lenovo Thinkpad t460s

## 1. On Windows: Update UEFI BIOS

1. Download latest UEFI BIOS from [here.](https://filedownload.lenovo.com/supportdata/product.html?id=Laptops-and-netbooks/ThinkPad-T-Series-laptops/ThinkPad-T460s)

## 2. Build debian netinst CD form this repo

	apt-get update
	apt-get install -y simple-cdd git
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

* Reset UEFI PKI and set into "Platform Custom Setup" mode.

* Secure Boot [Enabled]

* Boot Mode [UEFI]

* Fast Boot [Enabled]

* Usb Boot [Enabled]

## 5. Install from media

Insert your usb media and boot your t460s with F12 option to select your
media. **Note**: Not all usb media's (I use a SanDisk) are recognised.

## 6. Configure apt repo's

Add jessie-backports repo:

	cat << EOF >/etc/apt/sources.list.d/jessie-backports.list
	# jessie-backports
	deb http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	deb-src http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	EOF

Add testing repo:

	cat << EOF >/etc/apt/sources.list.d/testing.list
	# testing
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free
	EOF

	apt-get update

## 7. Wifi and kernel

Wifi works only with an newer kernel:

	apt-get -t jessie-backports install linux-image-4.7.0-0.bpo.1-amd64-unsigned
	apt-get -t testing install firmware-iwlwifi

## 6. Display

	apt-get -t testing xserver-xorg-video-intel

## Links

* This document is inspired by [DebianOn -> t460s](https://wiki.debian.org/InstallingDebianOn/Thinkpad/T460s/stretch).

* [partman-auto/expert_recipe findings](https://wikitech.wikimedia.org/wiki/PartMan)

* [Debian GNU/Linux 8.4 (Jessie) dynamic LVM logical volumes without boot partition with partman expert recipe](https://wiki.hiit.fi/pages/viewpage.action?pageId=34767211)

* [wiki.debian.org: Preseed files](https://wiki.debian.org/DebianInstaller/Preseed)

* [Debian GNU/Linux – Installationsanleitung: Anhang B. Automatisieren der Installation mittels Voreinstellung](https://www.debian.org/releases/stable/amd64/apb.html)

* [Automated partitioning with Ubuntu preseed](https://gist.github.com/lorin/5140029)
