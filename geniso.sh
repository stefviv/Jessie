#==== Generation d'une ISO avec son preseed.cfg =============
# cat /etc/apt/sources.list
## jessie - ftp.fr.debian.org/debian
#deb http://ftp.fr.debian.org/debian/ jessie main contrib non-free
#deb-src http://ftp.fr.debian.org/debian/ jessie main contrib non-free
## jessie/updates - security.debian.org
#deb http://security.debian.org/ jessie/updates main contrib non-free
#deb-src http://security.debian.org/ jessie/updates main contrib non-free
## jessie-updates - ftp.fr.debian.org
#deb http://ftp.fr.debian.org/debian/ jessie-updates main contrib non-free
#deb-src http://ftp.fr.debian.org/debian/ jessie-updates main contrib non-free
## jessie-backports - ftp.fr.debian.org
#deb http://ftp.fr.debian.org/debian/ jessie-backports main contrib non-free
## Jessie - download.virtualbox.org
#deb http://download.virtualbox.org/virtualbox/debian/ jessie contrib
#===========================================================
#!/bin/bash
DATE=_`date "+%Y%m%d-%Hh%Mm"`
apt-get update -y && apt-get upgrade -y
apt-get install wget unzip bsdtar genisoimage
cd /root
wget http://cdimage.debian.org/debian-cd/8.1.0/amd64/iso-cd/debian-8.1.0-amd64-CD-1.iso
mkdir /root/debian-8.1.0-amd64-preseed
mkdir /root/initrd-preseed
bsdtar -C debian-8.1.0-amd64-preseed/ -xf debian-8.1.0-amd64-CD-1.iso
mv debian-8.1.0-amd64-preseed/install.amd/initrd.gz initrd-preseed/
cd /root/initrd-preseed/
gunzip -c initrd.gz | cpio -id
rm /root/initrd-preseed/initrd.gz
wget https://github.com/stefviv/Jessie/blob/master/preseed.cfg
chmod 755 /root/initrd-preseed/preseed.cfg
find . | cpio -H newc --create --verbose | gzip -9 > /root/debian-8.1.0-amd64-preseed/install.amd/initrd.gz
cd /root/debian-8.1.0-amd64-preseed/
### lrwxrwxrwx  1 root root 1 fevr.  8 14:46 debian -> .
unlink /root/debian-8.1.0-amd64-preseed/debian
genisoimage -o ../debian-8.1.0-amd64-preseed"$DATE".iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat .