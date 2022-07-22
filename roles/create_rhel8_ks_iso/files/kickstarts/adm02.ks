#version=rhel8
# Use Graphical Install
graphical

# System language
lang en_US.UTF-8

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System timezone
timezone UTC --isUtc --ntpservers=192.168.20.69

# Network information
network --device=ens192 --onboot=yes --noipv6 --bootproto=static --ip=192.168.21.122 --netmask=255.255.255.0 --gateway=192.168.21.1 --nameserver=192.168.20.69
network --hostname=adm02.gpssus.com

# Use CDROM installation media
cdrom

# Repositories
repo --name="ks-AppStream" --baseurl=file:///run/install/repo/AppStream

# Packages to Install
%packages

# Groups to Install
@^gnome-desktop-environment
@base
@core
@desktop-debugging
@dial-up
@directory-client
@fonts
@gnome-desktop
@guest-agents
@guest-desktop-agents
@input-methods
@internet-browser
@java-platform
@multimedia
@network-file-system-client
@networkmanager-submodules
@print-client
@x11

# Extra packages
ipa-client

# RHEL7 Stig Required Present
openssh
policycoreutils
rsyslog
grub2-tools
grub2-tools-extra
grub2-tools-minimal
rng-tools
usbguard
libselinux-python
tmux
audit
gnutls
firewalld
nftables
fipscheck
chrony

# RHEL7 Stig Required Absent
-gssproxy
-sendmail
-iprutils
-tuned
-telnet-server
-rsh-server
-krb5-workstation
-vsftpd
-tftp-server
-postfix
-ntp

%end

# Root password
rootpw --iscrypted $6$oSvQY9tPaCZy533d$oBsZZO9SRiUX200S6rBltTSgDzDpdn8IdO/pFzFmtOXfqqfAHL453MS0fxK9RhRK0XrD8ihKudhnez4/Rk5Pu0 

# Default User Account
user --name=cyber --groups=wheel --iscrypted --password=$6$oSvQY9tPaCZy533d$oBsZZO9SRiUX200S6rBltTSgDzDpdn8IdO/pFzFmtOXfqqfAHL453MS0fxK9RhRK0XrD8ihKudhnez4/Rk5Pu0

# X Window System Configuration Information
xconfig --startxonboot

# Disk to Use
ignoredisk --only-use=sda

# Clean Partitions
clearpart --all --initlabel

# Boot Loader Confirguration Information
bootloader --location=mbr --boot-drive=sda

# Disk Partitioning Information
part /boot --size=1024 --fstype="xfs" --ondrive=sda
part /boot/efi --size=200 --fstype="efi" --ondrive=sda --fsoptions="umask=0077,shortname=winnt"
part pv.200 --size=100 --grow --fstype="lvmpv" --ondrive=sda

# Logical Volume Partitioning Information
volgroup rhel8 --pesize=4096 pv.200
logvol / --fstype="xfs" --name=root --vgname=rhel8 --percent=50
logvol /home --fstype="xfs" --name=home --vgname=rhel8 --percent=5
logvol /tmp --fstype="xfs" --name=tmp --vgname=rhel8 --percent=5
logvol /var --fstype="xfs" --name=var --vgname=rhel8 --percent=20
logvol /var/log --fstype="xfs" --name=var_log --vgname=rhel8 --percent=5
logvol /var/log/audit --fstype="xfs" --name=var_log_audit --vgname=rhel8 --percent=5
logvol /var/tmp --fstype="xfs" --name=var_tmp --vgname=rhel8 --percent=5
logvol swap --fstype="swap" --name=swap --vgname=rhel8 --percent=5

# System services
services --enabled="chronyd"

# System authorization information
auth --passalgo=sha512 --useshadow

# Disable First Boot GUI Application
firstboot --disable

# Accept Eula
eula --agreed

# Disable Kernel Dumps
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end

# Password Policy
%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end

# Reboot after Install
reboot