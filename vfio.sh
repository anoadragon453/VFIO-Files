sudo vfio-bind 0000:0a:00.0 0000:0a:00.1 0000:00:1b.0

#echo "Starting Samba"
#sudo systemctl start smbd.service
#sudo systemctl start nmbd.service

echo "Starting Synergy"
/usr/bin/synergys --daemon --config /home/rainbow/.synergy/synergy.conf

sudo qemu-system-x86_64 -enable-kvm -m 8192 -cpu host,kvm=off \
-smp cores=4,threads=2 \
-vga none \
-device virtio-scsi-pci,id=scsi \
-device vfio-pci,host=0a:00.0,x-vga=on \
-device vfio-pci,host=0a:00.1 \
-device vfio-pci,host=00:1b.0 \
-drive file=/home/rainbow/VMs/win8.1/DVD.iso,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd \
-drive file=/dev/sdb,id=disk,format=raw,if=none -device scsi-hd,drive=disk \
-drive file=/home/rainbow/VMs/virt.iso,id=virtiocd,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
-nographic \
-boot menu=on

echo "VM closed"

echo "Stopping Synergy"
pkill -u rainbow synergys

#echo "Stopping Samba"
#sudo systemctl stop smbd.service
#sudo systemctl stop nmbd.service

# optional arguments
#-drive file=/dev/sda1,id=bigstorage,format=raw,if=none -device scsi-hd,drive=bigstorage \
#-pflash /usr/share/ovmf/x64/ovmf_x64.bin \
#-usb -usbdevice host:06a3:0ccb -usbdevice host:1532:011a \
# -soundhw hda \
