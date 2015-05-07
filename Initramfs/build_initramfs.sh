#!/bin/bash
ROOTFSLOC=initrdfs
mkdir $ROOTFSLOC
mkdir -p $ROOTFSLOC/{bin,dev,etc,home,lib,newroot,proc,root,sbin,sys}

cd $ROOTFSLOC/dev
sudo mknod null c 1 3
sudo mknod tty c 5 0
sudo mknod console c 5 1
sudo mknod random c 1 8
sudo mknod urandom c 1 9 

sudo mknod mmcblk0p  b 179 0
sudo mknod mmcblk0p1 b 179 1
sudo mknod mmcblk0p2 b 179 2
sudo mknod mmcblk0p3 b 179 3
sudo mknod mmcblk0p4 b 179 4

sudo mknod ttySAC0 c 204 64
sudo mknod ttySAC1 c 204 65
sudo mknod ttySAC2 c 204 66
sudo mknod ttySAC3 c 204 67

cd ../bin
cp ~/workspace/xu3/buildroot/output/target/bin/busybox .
ln -s busybox ls
ln -s busybox mkdir
ln -s busybox ln
ln -s busybox mknod
ln -s busybox mount
ln -s busybox umount
ln -s busybox sh
ln -s busybox sleep
ln -s busybox dmesg
cp ~/workspace/xu3/buildroot/output/target/usr/bin/strace .

cd ../sbin
ln -s ../bin/busybox switch_root

cd ../lib
cp ~/workspace/xu3/buildroot/output/target/lib/libc-2.19-2014.08.so .
cp ~/workspace/xu3/buildroot/output/target/lib/ld-2.19-2014.08.so .

ln -s libc-2.19-2014.08.so libc.so.6
ln -s ld-2.19-2014.08.so ld-linux-armhf.so.3
ln -s . arm-linux-gnueabihf

cd ..
cp ../init init
chmod 755 init

cd ..
sudo chown -R 0:0 $ROOTFSLOC



cd $ROOTFSLOC
find . | cpio --quiet -o -H newc > ../initrd
cd ..
gzip -9 -c initrd > initrd.gz

mkimage -A arm -T ramdisk -C none -d initrd.gz uinitrd
