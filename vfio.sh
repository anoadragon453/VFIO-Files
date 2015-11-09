echo "Starting Samba"
sudo systemctl start smbd.service
sudo systemctl start nmbd.service

#Sound services
#echo "Exporting PulseAudio driver"
#export QEMU_AUDIO_DRV="pa"

# Qemu can use SDL sound instead of the default OSS
#export QEMU_AUDIO_DRV="sdl"
 
# Whereas SDL can play through alsa:
#export SDL_AUDIODRIVER="alsa"

#echo "$QEMU_AUDIO_DRV & $SDL_AUDIODRIVER"

#export QEMU_AUDIO_DRV=alsa QEMU_AUDIO_TIMER_PERIOD=0

# This is probably not neccesary, except when updating the OVMF bios
#echo "Removing old OVMF variables"
#rm -v ./VMs/Windows_ovmf_vars_x64.bin
#echo "Copying new OVMF variables"
#cp -v /usr/share/ovmf/x64/ovmf_vars_x64.bin ./VMs/Windows_ovmf_vars_x64.bin

echo "Starting Synergy"
/usr/bin/synergys --daemon --config /etc/synergy.conf

sudo qemu-system-x86_64 -enable-kvm -m 8192 -cpu host,kvm=off \
-smp cores=4,threads=2 \
-soundhw hda \
-smb /home/rainbow/VMs/win8.1/smb \
-vga none \
-device virtio-scsi-pci,id=scsi \
-device vfio-pci,host=02:00.0,x-vga=on \
-device vfio-pci,host=02:00.1 \
-drive file=/home/rainbow/VMs/win8.1/DVD.iso,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd \
-drive file=/dev/sdb,id=disk,format=raw,if=none -device scsi-hd,drive=disk \
-drive file=/home/rainbow/VMs/virt.iso,id=virtiocd,if=none -device ide-cd,bus=ide.1,drive=virtiocd \
-boot c \
-usb -usbdevice host:0d8c:000c -usbdevice host:05ac:1281 \
-redir udp:27031::27031 -redir tcp:27037::27037 -redir tcp:27036::27036 -redir udp:27036::27036 \
#-usb -usbdevice host:05ac:1281 -usbdevice host:0d8c:000c -usbdevice host:054c:0268 -usbdevice host:0e6f:0401 
#-usb -usbdevice host:1532:011a -usbdevice host:06a3:0ccb \-redir tcp:27036::27036 -redir tcp:27037::27037 -redir udp:27031::27031 -redir udp:27036::27036 \

echo "VM closed"

echo "Stopping Synergy"
pkill -u rainbow synergys

echo "Stopping Samba"
sudo systemctl stop smbd.service
sudo systemctl stop nmbd.service

#USB
#-device vfio-pci,host=00:1b.0 \ Intel HDA
#-usb -usbdevice host:1532:011a \ # Keyboard
#-usb -usbdevice host:06a3:0ccb \ # Mouse

#VFIO
#-device vfio-pci,host=04:00.0 \ # Intel networking

#OVMF
#-drive if=pflash,format=raw,readonly,file=/usr/share/ovmf/x64/ovmf_code_x64.bin \ -drive if=pflash,format=raw,file=./VMs/Windows_ovmf_vars_x64.bin \
#-boot c \
#-pflash /usr/share/ovmf/x64/ovmf_x64.bin \

#Sound
#-soundhw hda \

#SMB
#-smb /home/rainbow/VMs/win8.1/smb \

# optional arguments
# -nographic \
#-boot menu=on
#-drive file=/dev/sdb,id=disk,format=raw,if=none -device scsi-hd,drive=disk \ HDD
#-drive file=/home/rainbow/VMs/win8.1/DVD.iso,id=isocd,format=raw,if=none -device scsi-cd,drive=isocd \ # Setup disk
#-drive file=/dev/sda1,id=bigstorage,format=raw,if=none -device scsi-hd,drive=bigstorage \
