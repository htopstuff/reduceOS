#!/bin/bash
# Author: HtopStuff

# Script is used to reduce Debian based OSs like Debian, Ubuntu etc.
# This 

# Unusable example list - get the list from lsmod # on a running system.
# TODO - it's worth adding a function which deduces the actual module
# file based on the name - these are often not quite the same.
MODULES="
xenfs
xen_privcmd
binfmt_misc
intel_rapl_msr
intel_rapl_common
intel_pmc_core
kvm_intel
kvm
irqbypass
ghash_clmulni_intel
sha512_ssse3
sha512_generic
aesni_intel
crypto_simd
cryptd
ppdev
joydev
hid_generic
usbhid
hid
pcspkr
parport_pc
parport
button
serio_raw
sg
evdev
fuse
loop
efi_pstore
dm_mod
configfs
ip_tables
x_tables
autofs4
ext4
crc16
mbcache
jbd2
crc32c_generic
sr_mod
bochs
cdrom
ata_generic
drm_vram_helper
drm_kms_helper
drm_ttm_helper
ttm
ata_piix
uhci_hcd
ehci_hcd
libata
crct10dif_pclmul
crct10dif_common
xen_netfront
drm
xen_blkfront
crc32_pclmul
crc32c_intel
psmouse
scsi_mod
i2c_piix4
usbcore
usb_common
scsi_common
floppy
"

# Now, remove modules that aren't in this list

cleanout_modules()
{
	dir=$1/kernel
	umask 0022
	mkdir ${dir}.new
	for f in $MODULES; do
		path=`find ${dir} -type f -name $f.ko | tail -1`
		if [ "x${path}" = "x" ]; then
			continue
		fi
		d=`dirname ${path}`
		newd=`echo $d | sed 's/kernel/kernel.new/'`
		mkdir -p ${newd}
		mv ${path} ${newd}/
	done
	rm -rf ${dir}
	mv ${dir}.new ${dir}
}

for f in /lib/modules/*; do
	cleanout_modules $f
done
