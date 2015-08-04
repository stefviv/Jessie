=======================================================================
root@debian8:~# nano /etc/default/grub

#GRUB_CMDLINE_LINUX_DEFAULT="quiet"
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_BACKGROUND="/usr/share/images/desktop-base/splash_grub2.tga"
GRUB_GFXMODE=1024x768
=======================================================================
root@debian8:~# update-grub