# Installing Lenovo t460s

## 1. Update UEFI BIOS (still) on Windows

1. Download BIOS from [here.](https://filedownload.lenovo.com/supportdata/product.html?id=Laptops-and-netbooks/ThinkPad-T-Series-laptops/ThinkPad-T460s)

## 2. Build Debian CD for Lenovo Thinkpad t460s

	apt-get update
	apt-get install -y simple-cdd git
	mkdir ~/src
	git clone https://github.com/micressor/lenovo-t460s.git
	cd lenovo-t460s
	sudo build-simple-cdd --conf profiles/t460s.conf --dist jessie --force-root

## 3. Install .iso to usb media

	dd if=images/debian-8.6-amd64-CD-1.iso of=/dev/sdX bs=1M
	sync

And install Debian from usb media.

## 4. Configure apt repos

Add jessie-backports and testing repo:

	cat << EOF >/etc/apt/sources.list.d/testing.list
	# jessie-backports
	deb http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	deb-src http://ftp.ch.debian.org/debian/ jessie-backports main contrib
	# testing
	deb http://ftp.ch.debian.org/debian testing main contrib non-free
	deb-src http://ftp.ch.debian.org/debian testing main contrib non-free
	EOF

	apt-get update


## 5. Wifi and kernel

Wifi works only with an newer kernel:

	apt-get -t jessie-backports install linux-image-4.7.0-0.bpo.1-amd64-unsigned
	apt-get -t testing install firmware-iwlwifi


## 6. Display

	apt-get -t testing xserver-xorg-video-intel

## Links

* [LVM recipe hints](https://wikitech.wikimedia.org/wiki/PartMan)
* [LVM recipe hints #2](https://wiki.hiit.fi/pages/viewpage.action?pageId=34767211)
* [Preseed files](https://wiki.debian.org/DebianInstaller/Preseed)
* [Preseed details](https://www.debian.org/releases/stable/amd64/apb.html)
* [gist lvm hint](https://gist.github.com/lorin/5140029)
