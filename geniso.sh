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
DATE=_`date "+%Y%m%d-%Hh%M"`
VER=8.6.0
apt-get update -y && apt-get upgrade -y
clear
apt-get install wget unzip bsdtar genisoimage git -y
sleep 30
cd /root
wget http://cdimage.debian.org/debian-cd/"$VER"/amd64/iso-cd/debian-"$VER"-amd64-CD-1.iso
mkdir /root/debian-"$VER"-amd64-preseed
mkdir /root/initrd-preseed
bsdtar -C debian-"$VER"-amd64-preseed/ -xf debian-"$VER"-amd64-CD-1.iso
mv debian-"$VER"-amd64-preseed/install.amd/initrd.gz initrd-preseed/
cd /root/initrd-preseed/
gunzip -c initrd.gz | cpio -id
rm /root/initrd-preseed/initrd.gz
cd /root
git clone https://github.com/stefviv/Jessie;
cp /root/Jessie/preseed.cfg /root/initrd-preseed/
chmod 755 /root/initrd-preseed/preseed.cfg
cd /root/initrd-preseed/
find . | cpio -H newc --create --verbose | gzip -9 > /root/debian-"$VER"-amd64-preseed/install.amd/initrd.gz
cd /root/debian-"$VER"-amd64-preseed/
### lrwxrwxrwx  1 root root 1 fevr.  8 14:46 debian -> .
unlink /root/debian-"$VER"-amd64-preseed/debian
genisoimage -o ../debian-"$VER"-amd64-preseed"$DATE".iso -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -b isolinux/isolinux.bin -c isolinux/boot.cat .
ls -lh /root/debian-"$VER"-amd64-preseed*.iso
