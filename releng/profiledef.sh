#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="ImphnenOs"
iso_label="ImphnenOs"
iso_label="ImphnenOs"
iso_publisher="Imphnen"
iso_application="Fesnuk Distro"
iso_version="P-I-T-A" 
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
	'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito'
           )


arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:0400"
  ["/etc/sudoers"]="0:0:0440"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/root/.opening.sh"]="0:0:777"
  ["/root/.fesnuk.sh"]="0:0:777"
  ["/root/install.sh"]="0:0:777"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/share"]="0:0:755"
  ["/etc/plymouth/plymouthd.conf"]="0:0:755"
  ["/usr/share/grub/themes/IMPHNEN-GRUB"]="0:0:755"
  ["/usr/share/grub/themes/IMPHNEN-GRUB/theme.txt"]="0:0:755"
  ["/usr/local/bin/Installation_guide"]="0:0:755"
  ["/usr/local/bin/livecd-sound"]="0:0:755"
)
