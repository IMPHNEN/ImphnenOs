#!/bin/bash

# Imphenos installer Fork dari Amelia Installer
# Source: https://gitlab.com/prism7/archery
# Version: 8.11.0

        set -euo pipefail
###################################################################################################
# COLOR FUNCTIONS
        magentabg="\e[1;45m"
        yellowbg="\e[1;43m"
        yellowl="\e[93m"
        greenbg="\e[1;42m"
        magenta="\e[35m"
        yellow="\e[33m"
        bluebg="\e[1;44m"
        cyanbg="\e[1;46m"
        bwhite="\e[0;97m"
        green="\e[32m"
        redbg="\e[1;41m"
        blue="\e[94m"
        cyan="\e[36m"
        red="\e[31m"
        nc="\e[0m"

MAGENTABG() { echo -e "${magentabg} $1${nc}" ;}
YELLOWBG()  { echo -e "${yellowbg} $1${nc}"  ;}
YELLOWL()   { echo -e "${yellowl} $1${nc}"   ;}
GREENBG()   { echo -e "${greenbg} $1${nc}"   ;}
MAGENTA()   { echo -e "${magenta} $1${nc}"   ;}
YELLOW()    { echo -e "${yellow} $1${nc}"    ;}
BLUEBG()    { echo -e "${bluebg} $1${nc}"    ;}
CYANBG()    { echo -e "${cyanbg} $1${nc}"    ;}
WHITEB()    { echo -e "${bwhite} $1${nc}"    ;}
GREEN()     { echo -e "${green} $1${nc}"     ;}
REDBG()     { echo -e "${redbg} $1${nc}"     ;}
BLUE()      { echo -e "${blue} $1${nc}"      ;}
CYAN()      { echo -e "${cyan} $1${nc}"      ;}
RED()       { echo -e "${red} $1${nc}"       ;}
NC()        { echo -e "${nc} $1${nc}"        ;}
# END COLOR FUNCTIONS
###################################################################################################
# PROMPT FUNCTIONS
skip() {
        sleep 0.2
        YELLOW "

    -->  Skipping.. "
}
reload() {
        sleep 0.2
        NC "

  --> [${green}Reloading${nc}] "
}
process() {
        sleep 0.2
        NC "

  --> [${green}Processing..${nc}] "
}
pkg_displ() {
        sleep 0.2
        NC "

${green}Aplikasi yang ingin di install${nc}:

${deskpkgs}"
}
vm() {
        sleep 0.2
        RED "
        ----------------------------------
        ###  ${yellow}Terdeteksi user Virtual Machine  ${red}###
        ----------------------------------"
}
invalid() {
        sleep 0.2
        RED "
        --------------------------
        ###  ${yellow}Skill Issue  ${red}###
        --------------------------"
        reload
}
err_try() {
        sleep 0.2
        RED "
        --------------------------------------------
        ###  ${yellow}Skill issue. Coba Lagi..  ${red}### 
        --------------------------------------------"
        reload
}
err_abort() {
        sleep 0.2
        RED "
        ------------------------
        ###  ${yellow}Alamak Error  ${red}### 
        ------------------------"
        failure
}
reboot() {
    if [[ "${luks_encrypt}" == "ok" ]]; then
        sleep 0.2
        RED "
        -------------------------------------------------------------------
        ###  ${yellow}Sistem Akan ${nc}reboot ${yellow}setelah LUKS encryption  ${red}### 
        -------------------------------------------------------------------


        "
        sleep 5
        systemctl reboot
    fi
}
force_reboot() {
        sleep 0.2
        RED "
        ----------------------------------------------------------------
        ###  ${yellow}Sistem Akan ${nc}reboot ${yellow}setelah LUKS encryption  ${red}### 
        ----------------------------------------------------------------


        "
        sleep 5
        systemctl reboot
}
line2() {
        printf '\n\n'
}
line3() {
        printf '\n\n\n'
}
unmount() {
        sleep 0.2
        line3
        REDBG "       ${yellow}------------------------- "
        REDBG "       ${yellow}[!] Unmount and Retry [!] "
        REDBG "       ${yellow}------------------------- "
        echo
        reload
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Unmount Filesystems${nc} ${magenta}]${nc}-----------------------------------${magenta}###
        "
    if umount -R /mnt > /dev/null 2>&1 ; then
        sleep 0.2
        NC "

        ------------------
        ### ${green}Unmount OK ${nc}###
        ------------------"
    else
        sleep 0.2
        RED "

        -----------------------------
        ###  ${yellow}Unmounting Gagal..  ${red}### 
        -----------------------------"
        failure
    fi
}
do_umount() {
        unmount
        reload
}
umount_manual() {
        unmount
        sleep 0.2
        NC "

  --> [Pindah Ke ${green}Mode Manual${nc}]"
}
choice() {
        sleep 0.2
        RED "
        --------------------------------------------
        ###  ${yellow}Pilih Salah satu..  ${red}###
        --------------------------------------------"
        reload
}
y_n() {
        sleep 0.2
        RED "
        ----------------------------------------------
        ###  ${yellow}Pilih 'y' or 'n' untuk melanjutkan..  ${red}###
        ----------------------------------------------"
        reload
}
yes_no() {
        sleep 0.2
        RED "
        -------------------------------------------------
        ###  ${yellow}Ketik 'yes' or 'no' untuk melanjutkan..  ${red}###
        -------------------------------------------------"
        reload
}
ok() {
        sleep 0.2
        NC "

==> [${green}${prompt} Okii :3${nc}] "
}
stage_ok() {
        sleep 0.2
        NC "
==> [${green}${stage_prompt} OK${nc}]
        "
        sleep 0.3
}
stage_fail() {
        sleep 0.2
        line2
        REDBG "       ${yellow}[!] ${stage_prompt} FAILED [!]"
        failure
}
completion_err() {
    if [[ -e /usr/bin/pv ]]; then
        sleep 0.2
        CYAN "



        (*) ${nc}Selesaikan dulu${yellowl} '${stage_prompt}' ${nc}untuk lanjut
        "| pv -qL 70
    else
        sleep 0.2
        CYAN "



        (*) ${nc}Selesaikan dulu${yellowl} '${stage_prompt}' ${nc}untuk lanjut
        "
    fi
}
amd() {
        line2
        REDBG   "       ------------------------------- "
        REDBG   "       ###  AMD Graphics detected  ### "
        REDBG   "       ------------------------------- "
        NC "


          *  ${vgacard}

        "
}
intel() {
        line2
        BLUEBG  "       --------------------------------- "
        BLUEBG  "       ###  INTEL Graphics detected  ### "
        BLUEBG  "       --------------------------------- "
        NC "


          *  ${vgacard}

        "
}
nvidia() {
        line2
        GREENBG "       ---------------------------------- "
        GREENBG "       ###  NVIDIA Graphics detected  ### "
        GREENBG "       ---------------------------------- "
        NC "


          *  ${vgacard}

        "
}
arch() {
        sleep 0.2
        line3
        BLUEBG    "************************************************************************************************* "
        BLUEBG    "                                                                                                  "
        BLUEBG    "                            #####    Installasi Imphenos      #####                               "
        BLUEBG    "                                 Fesnuk Full Os Based of Arch                                     "
        BLUEBG    "************************************************************************************************* "
        line2
}
cnfg() {
        sleep 0.2
        line3
        MAGENTABG "------------------------------------------------------------------------------------------------- "
        MAGENTABG "                                   ###     Konfigurasi     ###                                    "
        MAGENTABG "------------------------------------------------------------------------------------------------- "
        line3
}
completion() {
        sleep 0.2
        line3
        GREENBG   "************************************************************************************************* "
        GREENBG   "                                                                                                  "
        GREENBG   "                              ###     Berhasil Install     ###                                    "
        GREENBG   "                                                                                                  "
        GREENBG   "************************************************************************************************* "
        line3
}
failure() {
        sleep 0.2
        line3
        REDBG     "************************************************************************************************* "
        REDBG     "                                                                                                  "
        REDBG     "                               ###     Installasi Gagal     ###                                   "
        REDBG     "                                                                                                  "
        REDBG     "************************************************************************************************* "
        line3
        umount -R /mnt > /dev/null 2>&1
        if [[ "${luks_root}" == "ok" || "${luks_swap}" == "ok" || "${luks_home}" == "ok" ]] && [[ "${installation}" != "ok" ]]; then
            force_reboot
        fi
        exit
}
# END PROMPT FUNCTIONS
###################################################################################################
# FUNCTIONS
first_check() {

    if [[ -f /usr/share/kbd/consolefonts/ter-v18b.psf.gz && -f /usr/share/kbd/consolefonts/ter-v32b.psf.gz ]]; then
        if [[ "${tty}" == *"tty"* && "${run_as}" == "root" ]]; then
            until slct_font; do : ; done
        else
            if [[ -e /usr/bin/pv ]]; then
                MAGENTABG "      'Terminus Font' detected       ==>       Log in as 'root' in a tty & re-run to enable       "| pv -qL 70
                echo
            else
                MAGENTABG "      'Terminus Font' detected       ==>       Log in as 'root' in a tty & re-run to enable       "
                echo
            fi
        fi
    fi

    if [[ "${run_as}" == "root" ]]; then
        REDBG "                             ${yellow}----------------------------------------                             "
        REDBG "                             ${yellow}###     Installer jalan di ROOT      ###                             "
        REDBG "                             ${yellow}----------------------------------------                             "
    else
        YELLOWBG       "                             ----------------------------------------                             "
        YELLOWBG       "                             ###   Installer harus jalan di ROOT  ###                             "
        YELLOWBG       "                             ----------------------------------------                             "
    fi
}
###################################################################################################
slct_font() {

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Pemilihan Font${nc} ${magenta}]${nc}--------------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Font: "
        NC "

            [1]  Terminus Font

            [2]  HiDPI Terminus Font "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " fontselect
        echo

    if [[ "${fontselect}" == "1" ]]; then
        setfont ter-v18b
    elif [[ "${fontselect}" == "2" ]]; then
        setfont ter-v32b
    else
        invalid
        return 1
    fi
        clear
}
###################################################################################################
uefi_check() {

        bitness="$(cat /sys/firmware/efi/fw_platform_size)"
        local prompt="UEFI ${bitness}-bit Mode"
        sleep 0.2
        NC "


${magenta}###${nc}---------------------------------${magenta}[ ${bwhite}Verifikasi Mode UEFI${nc} ${magenta}]${nc}---------------------------------${magenta}###
        "
    if [[ "${bitness}" == "64" ]]; then
        uefimode="x86_64-efi"
        ok
    elif [[ "${bitness}" == "32" ]]; then
        uefimode="i386-efi"
        ok
    else
        RED "
        --------------------------
        ###  ${yellow}Bukan UEFI  ${red}###
        --------------------------"
        failure
    fi
}
###################################################################################################
connection_check() {

        local prompt="Cek Koneksi Internet"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Cek Koneksi Internet${nc} ${magenta}]${nc}--------------------------------${magenta}###
        "
    if ping -c 3 facebook.com  > /dev/null 2>&1; then
        ok
    else
        RED "


        ----------------------------------------------------------------------
        ###  ${yellow}Koneksi ke ${nc}${bwhite}facebook.com ${yellow}gagal  ${red}###
        ----------------------------------------------------------------------
        "
        failure
    fi
}
###################################################################################################
upd_clock() {

        local prompt="Jam dsw"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Update Jam${nc} ${magenta}]${nc}-----------------------------------${magenta}###


        "
        sleep 0.2
        timedatectl
        ok
}
###################################################################################################
dtct_hyper() {

        hypervisor="$(systemd-detect-virt)"
    case "${hypervisor}" in
        kvm)
            vmpkgs="spice spice-vdagent spice-protocol spice-gtk qemu-guest-agent swtpm" ;;
        vmware)
            vmpkgs="open-vm-tools"
            vm_services="vmtoolsd vmware-vmblock-fuse" ;;
        oracle)
            vmpkgs="virtualbox-guest-utils" ;;
        microsoft)
            vmpkgs="hyperv"
            vm_services="hv_kvp_daemon hv_vss_daemon" ;;
    esac
}
###################################################################################################
machine_dtct() {

        until dtct_hyper; do : ; done
        local prompt="Deteksi Perangkat"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Deteksi Perangkat${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        CPU="$(grep -E 'vendor_id' /proc/cpuinfo)"
        hardw_model="$(hostnamectl | grep -E 'Hardware Model:'| sed 's|  Hardware Model: ||')"
        hardw_model_vend="$(hostnamectl | grep -E 'Hardware Model:'| sed 's|  Hardware Model: ||' | awk "{print \$1}")"
        hardw_vendor="$(hostnamectl | grep -E 'Hardware Vendor' | awk "{print \$3}")"
        machine="$(hostnamectl | grep -E 'Chassis' | awk "{print \$2}")"

    if [[ "${hypervisor}" != "none" ]]; then
        vm
        vendor="Virtual Machine"
        vgaconf="n"
    fi

    if [[ "${CPU}" == *"GenuineIntel"* ]]; then
        microcode="intel-ucode"
        nrg_plc="x86_energy_perf_policy"
        cpu_name="Intel"
    elif [[ "${CPU}" == *"AuthenticAMD"* ]]; then
        microcode="amd-ucode"
        cpu_name="AMD"
    fi

    if [[ "${hardw_model_vend}" == "${hardw_vendor}" ]]; then
        sleep 0.2
        YELLOW "

        ###  sistem ini menggunakan  ${nc}${hardw_model} ${yellow}${machine}


        ###  program ${nc}${cpu_name} ${yellow}cpu microcode akan di install
        "
    else
        sleep 0.2
        YELLOW "

        ###  sistem ini menggunakan ${nc}${hardw_model} ${yellow}${hardw_vendor} ${machine}


        ###  program ${nc}${cpu_name} ${yellow}cpu microcode akan di install
        "
    fi
        YELLOW "

        > Matikan ${nc}Watchdogs ${yellow}di sistem ? [Y/n]


        ###  Ga penting amat sih, pilih Y ajah "
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " kill_watchdog

        echo
        kill_watchdog="${kill_watchdog:-y}"
        kill_watchdog="${kill_watchdog,,}"

    if [[ "${kill_watchdog}" == "y" ]]; then
        sleep 0.2
        YELLOW "

        ###  Watchdogs will be disabled
        "
    elif [[ "${kill_watchdog}" == "n" ]]; then
        skip
    else
        y_n
        return 1
    fi
        ok
}
###################################################################################################
main_menu() {

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------------${magenta}[ ${bwhite}Menuj Utama${nc} ${magenta}]${nc}----------------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Ngab: "
    if [[ -e /usr/bin/pv ]]; then
        CYAN "

            (*) ${nc}pilih ${bwhite}[4] ${nc}biar pake mode ${yellowl}'Malas Install' ${nc}& ${yellowl}'Langsung Jadi' ${nc}script
        " | pv -qL 70
    else
        CYAN "

            (*) ${nc}pilih ${bwhite}[4] ${nc}biar pake mode ${yellowl}'Malas Install' ${nc}& ${yellowl}'Langsung Jadi' ${nc}script
        "
    fi
        NC "

        [1]  Personalisasi Sistem (Bahasa sama akun)

            [2]  Konfigurasi Sistem

            [3]  Manajemen Disk (Mengatur Partisi Linuj)

            [4]  Omke Gass (Langsung Kesini biar Mode ${yellow}'Malas Install'${nc})"
        BLUE "


Pilih Nomornya ngab: "
        read -r -p "
==> " menu
        echo

    case "${menu}" in
        1)
            until persnl_submn; do : ; done ;;
        2)
            until sys_submn; do : ; done ;;
        3)
            until dsks_submn; do : ; done ;;
        4)
            until instl; do : ; done ;;
       "")
            sleep 0.2
            RED "
        ---------------------------------
        ###  ${yellow}Pilih Submenu  ${red}###
        ---------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
persnl_submn() {

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Personalisasi${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        YELLOW "
>  Pilih Submenu: "
        NC "

            [1]  Lokalisasi & Setup Kibot

            [2]  User, Root User & Hostname Setup

            [ ]  Return to Main Menu "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " persmenu
        echo

    case "${persmenu}" in
        1)
            until slct_locale; do : ; done
            until slct_kbd; do : ; done
            return 1 ;;
        2)
            until user_setup; do : ; done
            until rootuser_setup; do : ; done
            until slct_hostname; do : ; done
            return 1 ;;
       "")
            until main_menu; do : ; done ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
slct_locale() {

        local prompt="Locale"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Lokalisasi${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        YELLOW "

        >  Lokalisasi
        

        ###  [Enter ${nc}'l'${yellow} to list locales, then ${nc}'enter'${yellow} to search or ${nc}'q'${yellow} to quit]

        ###  Exclude ${nc}'.UTF_8' ${yellow}suffix 
        ###  Saran Abodin Biarin aja ini mah, nanti di setting lagi kecuali kalau mau pake  ja_JP (Buat Wibu)"
        BLUE "


Enter your Locale ${bwhite}(empty for 'en_US')${blue}: "
        read -r -p "
==> " LOCALESET
        echo

    if [[ -z "${LOCALESET}" ]]; then
        SETLOCALE="en_US.UTF-8"
        sleep 0.2
        YELLOW "

        ###  en_US.UTF-8 Locale has been selected
        "
    elif [[ "${LOCALESET}" == "l" ]]; then
        grep -E 'UTF-8' /usr/share/i18n/SUPPORTED | more
        return 1
    elif ! grep -q "^#\?$(sed 's/[].*[]/\\&/g' <<< "${LOCALESET}") " /usr/share/i18n/SUPPORTED; then
        invalid
        return 1
    else
        SETLOCALE="${LOCALESET}.UTF-8"
        sleep 0.2
        YELLOW "

        ###  ${SETLOCALE} Locale has been selected
        "
    fi
        ok
        lcl_slct="yes"
}
###################################################################################################
slct_kbd() {

        local prompt="Keyboard Layout"
        local stage_prompt="Setting Keyboard Layout"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Keyboard Layout Selection${nc} ${magenta}]${nc}--------------------------------${magenta}###
        "
        YELLOW "

        > Select your Keyboard Layout


        ###  [Enter ${nc}'l'${yellow} to list layouts, then ${nc}'enter'${yellow} to search or ${nc}'q'${yellow} to quit] 
        ###  Ni juga sama biarin aja, kecuali kalau kibot laptop kalian Anomali baru ganti ke yang dimiliki, abodin gatau tipe kibot kalian"
        BLUE "


Enter your keyboard layout ${bwhite}(empty for 'us')${blue}: 
"
        read -r -p "
==> " SETKBD
        echo

    if [[ -z "${SETKBD}" ]]; then
        SETKBD="us"
        sleep 0.2
        YELLOW "

        ###  us Keyboard Layout has been selected
        "
    elif [[ "${SETKBD}" == "l" ]]; then
        localectl list-keymaps | more
        return 1
    elif ! localectl list-keymaps | grep -Fxq "${SETKBD}"; then
        invalid
        return 1
    else
        sleep 0.2
        YELLOW "

        ###  ${SETKBD} Keyboard Layout has been selected
        "
        loadkeys "${SETKBD}" > /dev/null 2> install_log.txt || stage_fail
    fi
        ok
}
###################################################################################################
user_setup() {

        local prompt="User"
        sleep 0.2
        NC "


${magenta}###${nc}---------------------------------------${magenta}[ ${bwhite}User  Setup${nc} ${magenta}]${nc}---------------------------------------${magenta}###
        "
        BLUE "

        Masukan Username (yang nanti dipake Login): "
        read -r -p "
==> " USERNAME
        echo

    if [[ -z "${USERNAME}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Masukin username nya masbroo  ${red}###
        ---------------------------------------------"
        reload
        return 1
    elif [[ "${USERNAME}" =~ [[:upper:]] ]]; then
        sleep 0.2
        RED "
        ------------------------------------------------------
        ###  ${yellow}GABOLEH UPPERCASE. Mulai lagi dsw..  ${red}###
        ------------------------------------------------------"
        reload
        return 1
    fi

        BLUE "
Masukan Passwod buat${nc} ${cyan}${USERNAME}${blue}: "
        read -r -p "
==> " USERPASSWD
        echo

    if [[ -z "${USERPASSWD}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Masukin Passwordnya massbroo, nanti gabisa login nangis  ${red}###
        ---------------------------------------------"
        reload
        return 1
    fi

        BLUE "
Masukin lagi Password ${nc} ${cyan}${USERNAME}${blue}: "
        read -r -p "
==> " USERPASSWD2
        echo

    if [[ "${USERPASSWD}" != "${USERPASSWD2}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------------
        ###  ${yellow}Baru juga bikin udah lupa, mulai lagi..  ${red}###
        ---------------------------------------------------"
        reload
        return 1
    fi
        ok
}
###################################################################################################
rootuser_setup() {

        local prompt="Root User"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Root User Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        BLUE "

Masukan Password buat ${nc}${cyan} Root ${blue}user: "
        read -r -p "
==> " ROOTPASSWD
        echo

    if [[ -z "${ROOTPASSWD}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------------------------
        ###  ${yellow}Masukin Passwordnya lah masbro ${red}###
        ---------------------------------------------------------------"
        reload
        return 1
    fi
        BLUE "

Masukin ulang password ${nc} ${cyan}Root ${blue}user: "
        read -r -p "
==> " ROOTPASSWD2
        echo
        
    if [[ "${ROOTPASSWD}" != "${ROOTPASSWD2}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------------
        ###  ${yellow}Passwordnya gak ngepas bang, masa lupa. mulai ulang..  ${red}###
        ---------------------------------------------------"
        reload
        return 1
    fi
        ok
}
###################################################################################################
slct_hostname() {

        local prompt="Hostname"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Setup Hostname${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        BLUE "

Masukan nama Hostname: "
        read -r -p "
==> " HOSTNAME
        echo

    if [[ -z "${HOSTNAME}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}masukin nama hostname  ${red}###
        ---------------------------------------------"
        reload
        return 1
    elif [[ "${HOSTNAME}" =~ [[:upper:]] ]]; then
        sleep 0.2
        RED "
        ----------------------------------------------------
        ###  ${yellow}Wajib lowercase massbro. mulai ulang..  ${red}###
        ----------------------------------------------------"
        reload
        return 1
    fi
        ok
}
###################################################################################################
sys_submn() {

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Konfigurasi Sistem${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        YELLOW " TODO: Baru Sampe sini anjim

        >  Pilih Submenu: "
        NC "

            [1]  Kernel, Secureboot Signing, Bootloader & ESP Mountpoint

            [2]  Filesystem & Swap Setup

            [3]  Graphics Setup

            [4]  Desktop Setup

            [5]  EFI Boot Entries Deletion

            [6]  Wireless Regulatory Domain Setup

            [ ]  Return to Main Menu "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " sysmenu
        echo

    case "${sysmenu}" in
        1)
            until slct_krnl; do : ; done
            until ask_sign; do : ; done
            until ask_bootldr; do : ; done
            until slct_espmnt; do : ; done
            return 1 ;;
        2)
            until ask_fs; do : ; done
            until ask_swap; do : ; done
            return 1 ;;
        3)
            until dtct_vga; do : ; done
            return 1 ;;
        4)
            until slct_dsktp; do : ; done
            return 1 ;;
        5)
            until boot_entr; do : ; done
            return 1 ;;
        6)
            until wireless_rgd; do : ; done
            return 1 ;;
       "")
            until main_menu; do : ; done ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
slct_krnl() {

        local prompt="Kernel"
        sleep 0.2
        NC "
   

${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Pilih Kernel${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Kernel: "
        NC "

            [1]  Linux (Plain as Shit)

            [2]  Linux LTS (kalau malas update)

            [3]  Linux Hardened (mamang hacker)

            [4]  Linux Zen (Ini ae kalau mau Fitur waydroid (Android di linuj) "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " kernelnmbr
        echo

    case "${kernelnmbr}" in
        1)
            kernel="linux"
            kernelname="Linux" ;;
        2)
            kernel="linux-lts"
            kernelname="Linux LTS" ;;
        3)
            CYAN "
        (*) ${nc}System Hibernation is ${yellowl}NOT SUPPORTED ${nc}by kernel
            "
            kernel="linux-hardened"
            kernelname="Linux Hardened" ;;
        4)
            kernel="linux-zen"
            kernelname="Linux Zen" ;;
       "")
            sleep 0.2
            RED "
        --------------------------------
        ###  ${yellow}Pilih Kernelnya sayang  ${red}###
        --------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac

        sleep 0.2
        YELLOW "

        ###  Kernel ${kernelname} dipilih 
        "
        ok
}
###################################################################################################
ask_sign() {

        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Secure Boot${nc} ${magenta}]${nc}-----------------------------------${magenta}###
        "
        YELLOW "

        >  Sign UKI(s), Kernel & binaries for use with ${nc}Secure Boot ${yellow}? [Y/n]
        ### bikin kernelnya satu di /boot/efi (no aja ribet soalnya)"
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " sb_sign

        echo
        sb_sign="${sb_sign:-y}"
        sb_sign="${sb_sign,,}"

    if [[ "${sb_sign}" == "y" ]]; then
        local prompt="Secure Boot 'Setup' Mode Verification"
        SB_Status="$(bootctl status 2> /dev/null | grep -E 'Secure Boot' | awk "{print \$4}")"
        if [[ ${SB_Status} == "(setup)" ]]; then
            ok
        else
            sleep 0.2
            RED "
        -----------------------------------------
        ###  ${yellow}Secure Boot Not in 'Setup' Mode  ${red}###
        -----------------------------------------"
            failure
        fi
        sleep 0.2
        YELLOW "


        ###  'Secure Boot Signing' has been selected
        "
        sleep 0.2
        YELLOW "


        >  Create an additional bootloader ${nc}Rescue ${yellow}entry (for troubleshooting) ? [Y/n]"
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " setrescue

        echo
        setrescue="${setrescue:-y}"
        setrescue="${setrescue,,}"

        if [[ "${setrescue}" == "y" ]]; then
            local prompt="Rescue Entry set"
            ok
        elif [[ "${setrescue}" == "n" ]]; then
            skip
        else
            y_n
            return 1
        fi
    elif [[ "${sb_sign}" == "n" ]]; then
        skip
    else
        y_n
        return 1
    fi
        local prompt="Secure Boot Signing setup"
        ok
}
###################################################################################################
ask_bootldr() {

        local prompt="Bootloader Selection"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}pemilihan Bootloader${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Bootloader: "
        NC "

        [1]  Systemd-boot (Abodin pake ini)

        [2]  Grub (Kalau Mau ricing pake ini)"
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " bootloader
        echo

    case "${bootloader}" in
        1)
            uki="y"
            ukify="systemd-ukify"
            sleep 0.2
            YELLOW "

        ###  Systemd-boot has been selected
            " ;;
        2)
            uki="n"
            sleep 0.2
            YELLOW "

        ###  Grub has been selected
            " ;;
       "")
            sleep 0.2
            RED "
        ------------------------------------
        ###  ${yellow}Please select a Bootloader  ${red}###
        ------------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
}
###################################################################################################
slct_espmnt() {

        local prompt="ESP Mountpoint"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}ESP Mountpoint  Selection${nc} ${magenta}]${nc}--------------------------------${magenta}###
        "
        YELLOW "

        >  Lokasi Mount ESP: "
        NC "

        [1]  /mnt/efi (Disarankan buat perangkat baru, yang pake UEFI)

            [2]  /mnt/boot (Abodin Pilih ini sih) "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " espmnt
        echo

    if [[ "${espmnt}" == "1" ]]; then
        esp_mount="/mnt/efi"
        btldr_esp_mount="/efi"
        sleep 0.2
        YELLOW "

        ###  '/mnt/efi' mountpoint has been selected
        "
    elif [[ "${espmnt}" == "2" ]]; then
        esp_mount="/mnt/boot"
        btldr_esp_mount="/boot"
        sleep 0.2
        YELLOW "

        ###  '/mnt/boot' mountpoint has been selected
        "
    else
        invalid
        return 1
    fi
        ok
    if [[ "${sanity}" == "no" ]]; then
        until sanity_check; do : ; done
    fi
}
###################################################################################################
ask_fs() {

        local prompt="Filesystem Setup"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Filesystem  Selection${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        YELLOW "

        >  Select Filesystem to be used: "
        NC "

            [1]  Ext4 (Pilihan Default, nothing wrong with it)

            [2]  Btrfs . Utusan tuhan (kecuali kau ngerti ni biji buat apaan, abodin gatau)

"
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " fs
        echo

    case "${fs}" in
        1)
            fsname="Ext4"
            fs_mod="ext4"
            fstools="e2fsprogs"
            roottype="/Root"
            sleep 0.2
            YELLOW "

        ###  NOTE: Disarankan gapake partisi /Home, nanti di /root penuh nangis, pilih n aja kalau abodin

        >  Pakai partisi /Home ? [Y/n] "
            BLUE "


Enter [Y/n]: "
            read -r -p "
==> " sep_home

            echo
            sep_home="${sep_home:-y}"
            sep_home="${sep_home,,}"

                case "${sep_home}" in
                    y)
                        sleep 0.2
                        YELLOW "

        ###  A /Home Partition will be created ";;
                    n)
                        skip 
                        echo;;
                    *)
                        invalid
                        return 1 ;;
                esac
            sleep 0.2
            YELLOW "

        ###  ${fsname} has been selected
            " ;;
        2)
            fsname="Btrfs"
            fs_mod="btrfs"
            fstools="btrfs-progs"
            roottype="/@"
            btrfs_bootopts="rootflags=subvol=@"
            sleep 0.2
            YELLOW "

        ###  ${fsname} has been selected "
            sleep 0.2
            YELLOW "

        >  Label your Btrfs snapshots directory: "
            BLUE "


Enter a name: "
            read -r -p "
==> " snapname
            echo

            if [[ -z "${snapname}" ]]; then
                invalid
                return 1
            fi ;;
       "")
            sleep 0.2
            RED "
        ------------------------------------
        ###  ${yellow}Please select a Filesystem  ${red}###
        ------------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
}
###################################################################################################
ask_swap() {

        local prompt="Swap Setup"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Swap  Selection${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Tipe Swap: "
        NC "

            [1]  Partisi Swap (Kalau udah set partisi Swap nya)

            [2]  Swapfile (swap tapi gapake partisi, pilih kalau mau pake mode hibernasi)

            [3]  Zram Swap (Rekomended, bisa di set ukuran manual)

            [4]  nggak minaj (Kalau ram lu diatas 8 GB) "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " swapmode
        echo

    case "${swapmode}" in
        1)
            swaptype="swappart"
            sleep 0.2
            YELLOW "

        ###  Swap Partition has been selected
            " ;;
        2)
            if [[ "${fs}" == "1" ]]; then
                swaptype="swapfile"
            elif [[ "${fs}" == "2" ]]; then
                swaptype="swapfile_btrfs"
            fi
            sleep 0.2
            YELLOW "

        ###  Swapfile has been selected

            "
            until set_swapsize; do : ; done ;;
        3)
            CYAN "
        (*) ${nc}Hibernating to Swap on Zram is ${yellowl}NOT SUPPORTED
            "
            zram="zram-generator"
            YELLOW "

        ###  Zram Swap has been selected
            " ;;
        4)
            sleep 0.2
            YELLOW "

        ###  No Swap will be used "
            skip ;;
       "")
            choice
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac

    if [[ "${swapmode}" != "4" ]]; then
        sleep 0.2
        YELLOW "


        >  Enable ${nc}systemd-oomd ${yellow}for enhanced 'OOM' management ? [Y/n]
        > Pilih Y ajah"
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " oomd

        echo
        oomd="${oomd:-y}"
        oomd="${oomd,,}"

        if [[ "${oomd}" == "y" ]]; then
            YELLOW "

        ###  'Systemd-oomd' dipilih
            "
        elif [[ "${oomd}" == "n" ]]; then
            skip
        else
            y_n
            return 1
        fi

    fi
      ok
}
###################################################################################################
set_swapsize() {

        local prompt="Swapsize"
        BLUE "

Enter Swap size ${bwhite}(in GB)${blue}: "
        read -r -p "
==> " swapsize
        echo

    if [[ -z "${swapsize}" ]]; then
        sleep 0.2
        RED "
        ------------------------------------------
        ###  ${yellow}Please enter a value to continue  ${red}###
        ------------------------------------------"
        reload
        line2
        return 1
    elif [[ "${swapsize}" == [[:digit:]] ]]; then
        ok
    else
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Please use only integers as a value  ${red}###
        ---------------------------------------------"
        reload
        line2
        return 1
    fi
}
###################################################################################################
dtct_vga() {

    if [[ "${hypervisor}" != "none" ]]; then
        vm
        sleep 0.2
        YELLOW "
        	
        -->  Graphics Setup skipped
        "
        return 0
    fi
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Graphics  Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        vgacount="$(lspci | grep -E -c 'VGA|Display|3D')"
        vgacard="$(lspci | grep -E 'VGA|Display|3D' | sed 's/^.*: //g')"
        intelcount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'Intel Corporation')"
        intelcards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'Intel Corporation'| sed 's/.*Corporation //g' | cat --number | sed 's/.[0-9]//')"
        amdcount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'Advanced Micro Devices')"
        amdcards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'Advanced Micro Devices' | sed 's/.*\[AMD\/ATI\] //g' | cat --number | sed 's/.[0-9]//')"
        nvidiacount="$(lspci | grep -E 'VGA|Display|3D' | grep -E -c 'NVIDIA Corporation')"
        nvidiacards="$(lspci | grep -E 'VGA|Display|3D' | grep -E 'NVIDIA Corporation'| sed 's/.*Corporation //g' | cat --number | sed 's/.[0-9]//')"
        vga_slct="yes"

    if [[ "${vgacount}" == "1" ]]; then
        dtct_single_vga
    else
        dtct_multi_vga
    fi
}
###################################################################################################
dtct_single_vga() {

    if [[ "${intelcount}" -eq "1" ]]; then
        vendor="Intel"
        sourcetype="Open-source"
        sleep 0.2
        intel
    elif [[ "${amdcount}" -eq "1" ]]; then
        vendor="AMD"
        sourcetype="Open-source"
        sleep 0.2
        amd
    elif [[ "${nvidiacount}" -eq "1" ]]; then
        vendor="Nvidia"
        sourcetype="Proprietary"
        nvidia
    fi

    if [[ "${vendor}" == "Nvidia" ]]; then
        sleep 0.2
        RED "
        ----------------------------------------------------
        ###  ${yellow}Only for NV110 ${nc}(Maxwell) ${yellow}Graphics or newer  ${red}###
        ----------------------------------------------------"
    fi
        YELLOW "

        >  Configure the Graphics subsystem and enable HW acceleration ? [Y/n] 
        "
    if [[ "${vendor}" == "Nvidia" ]]; then
        YELLOW "

        ###  Selecting ${nc}'(n)o' ${yellow}defaults to using the open-source ${nc}'nouveau' ${yellow}driver"
    fi
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " vgaconf

        vgaconf="${vgaconf:-y}"
        vgaconf="${vgaconf,,}"

    if [[ "${vgaconf}" == "y" ]]; then
        vga_conf
    elif [[ "${vgaconf}" == "n"  ]]; then
        local prompt="Graphics Setup"
        skip
        ok
    else
        invalid
        return 1
    fi
}
###################################################################################################
dtct_multi_vga() {

    if [[ "${vgacount}" == "2" ]]; then
        vga_setup="Dual"
    elif [[ "${vgacount}" == "3" ]]; then
        vga_setup="Triple"
    fi

        sleep 0.2
        YELLOW "

        ###  ${vga_setup} Graphics setup detected, consisting of: "
        NC "

        ____________________________________________________________________"

    if [[ "${intelcount}" -ge "1" ]]; then
        vendor1="Intel"
        echo
        BLUEBG  "       ------------------------------- "
        BLUEBG  "       [${intelcount}]  Intel   Graphics device(s) "
        BLUEBG  "       ------------------------------- "
        NC "

${intelcards}

        ____________________________________________________________________"
    fi

    if [[ "${amdcount}" -ge "1" ]]; then
        vendor2="AMD"
        echo
        REDBG   "       ------------------------------- "
        REDBG   "       [${amdcount}]  AMD     Graphics device(s) "
        REDBG   "       ------------------------------- "
        NC "

${amdcards}

        ____________________________________________________________________"
    fi

    if [[ "${nvidiacount}" -ge "1" ]]; then
        vendor3="Nvidia"
        echo
        GREENBG "       ------------------------------- "
        GREENBG "       [${nvidiacount}]  Nvidia  Graphics device(s) "
        GREENBG "       ------------------------------- "
        NC "

${nvidiacards}

        ____________________________________________________________________"
    fi

        YELLOW "

        >  Configure the Graphics subsystem and enable HW acceleration for : "

    if [[ -n "${vendor1}" && -n "${vendor2}" ]]; then
        NC "

            [1]  Intel

            [2]  AMD 

            [3]  Both 

            [4]  None "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " vendor_slct

        case "${vendor_slct}" in
            1)
                vendor="Intel" ;;
            2)
                vendor="AMD" ;;
            3)
                vendors="Intel & AMD" ;;
            4)
                vendor="none" ;;
           "")
                choice
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac

    elif [[ -n "${vendor1}" && -n "${vendor3}" ]]; then
        NC "

            [1]  Intel
                         ${red}----------------------------------------------------${nc}
            [2]  Nvidia  ${red}###  ${yellow}Only for NV110 ${nc}(Maxwell) ${yellow}Graphics or newer  ${red}###${nc}
                         ${red}----------------------------------------------------${nc}
            [3]  Both 

            [4]  None "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " vendor_slct

        case "${vendor_slct}" in
            1)
                vendor="Intel" ;;
            2)
                vendor="Nvidia" ;;
            3)
                vendors="Intel & Nvidia" ;;
            4)
                vendor="none" ;;
           "")
                choice
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac

    elif [[ -n "${vendor2}" && -n "${vendor3}" ]]; then
        NC "

            [1]  Amd
                         ${red}----------------------------------------------------${nc}
            [2]  Nvidia  ${red}###  ${yellow}Only for NV110 ${nc}(Maxwell) ${yellow}Graphics or newer  ${red}###${nc}
                         ${red}----------------------------------------------------${nc}
            [3]  Both 

            [4]  None "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " vendor_slct

        case "${vendor_slct}" in
            1)
                vendor="AMD" ;;
            2)
                vendor="Nvidia" ;;
            3)
                vendors="AMD & Nvidia" ;;
            4)
                vendor="none" ;;
           "")
                choice
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac
    fi
    if [[ "${vendor}" == "Intel" || "${vendor}" == "AMD" ]]; then
        sourcetype="Open-source"
        vgaconf="y"
        vga_conf
    elif [[ "${vendor}" == "Nvidia" ]]; then
        sourcetype="Proprietary"
        vgaconf="y"
        vga_conf
    elif [[ "${vendors}" == "Intel & AMD" ]]; then
        sourcetype="Open-source"
        vgaconf="y"
        vga_conf
    elif [[ "${vendors}" == "Intel & Nvidia" ]]; then
        sourcetype="Open-source & Proprietary"
        vgaconf="y"
        vga_conf
    elif [[ "${vendors}" == "AMD & Nvidia" ]]; then
        sourcetype="Open-source & Proprietary"
        vgaconf="y"
        vga_conf
    elif [[ "${vendor}" == "none" ]]; then
        local prompt="Graphics Setup"
        vgaconf="n"
        skip
        ok
    fi
}
###################################################################################################
vga_conf() {

    if [[ "${vendor}" != "none" ]]; then
        sleep 0.2
        YELLOW "
        
        
        ###  ${sourcetype} drivers will be used
        "
    fi

    if [[ "${vendor}" == "AMD" || "${vendors}" =~ "AMD"  ]]; then
        sleep 0.2
        YELLOW "

        >  Enable 'amdgpu' driver support for: "
        NC "

            [1]  'Southern Islands' Graphics

            [2]  'Sea Islands' Graphics "
        BLUE "


Pilih Nomor ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " islands

        case "${islands}" in
            1)
                sleep 0.2
                NC "

==> [${green}Southern Islands OK${nc}]

                " ;;
            2)
                sleep 0.2
                NC "

==> [${green}Sea Islands OK${nc}]

                " ;;
           "")
                skip
                echo ;;
            *)
                invalid
                return 1 ;;
        esac
    fi

    if [[ "${vendor}" == "Nvidia" || "${vendors}" =~ "Nvidia" ]]; then
        sleep 0.2
        YELLOW "
        >  Select Nvidia architecture: "
        NC "

            [1]  Turing (NV160) Graphics or newer  [Nvidia Open]

            [2]  Maxwell (NV110) Graphics or newer  [Nvidia Proprietary / Disabling GSP Firmware available] "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " family

        case "${family}" in
            1)  # Turing+ Family
                sleep 0.2
                NC "

==> [${green}Turing+ OK${nc}]
                " ;;
            2)  # Maxwell+ Family
                sleep 0.2
                NC "

==> [${green}Maxwell+ OK${nc}]
                "
                local prompt="GSP Firmware Disabled"
                sleep 0.2
                YELLOW "

        >  Disable 'GSP' firmware (for troubleshooting) ? [y/n] "
                BLUE "


Enter [y/n]: "
                read -r -p "
==> " nogsp

                if [[ "${nogsp}" == "n" ]]; then
                   skip
                   echo
                elif [[ "${nogsp}" == "y" ]]; then
                   ok
                   echo
                else
                   y_n
                   return 1
                fi ;;
           "")
                choice
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac

        local prompt="Low Latency Display Interrupts enabled"
        sleep 0.2
        YELLOW "

        >  Enable Low Latency Display Interrupts (experimental) ? [Y/n] "
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " lowlat

        lowlat="${lowlat:-y}"
        lowlat="${lowlat,,}"

        if [[ "${lowlat}" == "n" ]]; then
           skip
           echo
        elif [[ "${lowlat}" == "y" ]]; then
           ok
           echo
        else
           y_n
           return 1
        fi
    fi
        sleep 0.2
        YELLOW "

        ###  ${vendor}${vendors} Graphics will be automatically configured
        "
        local prompt="Graphics Setup"
        ok
}
###################################################################################################
gfxpkgs_set() {

        # Graphics packages
        gfxpkgs=()

    # Configure Graphics = yes
    if [[ "${vgaconf}" == "y" ]]; then
        # Intel Graphics
        if [[ "${vendor}" == "Intel" || "${vendors}" =~ "Intel" ]]; then
            # /etc/sysctl.d/99-sysctld.conf
            perf_stream="dev.i915.perf_stream_paranoid = 0"
            gfxpkgs+=(intel-compute-runtime intel-media-driver intel-media-sdk libva-intel-driver opencl-headers vpl-gpu-rt vkd3d vulkan-intel vulkan-mesa-layers)
        fi
        # AMD Graphics
        if [[ "${vendor}" == "AMD" || "${vendors}" =~ "AMD" ]]; then
            gfxpkgs+=(libva-mesa-driver mesa-utils mesa-vdpau opencl-headers rocm-opencl-runtime vkd3d vulkan-mesa-layers vulkan-radeon)
        fi
        # Nvidia Graphics
        if [[ "${vendor}" == "Nvidia" || "${vendors}" =~ "Nvidia" ]]; then
            # Swap partition|swapfile|zram-swap = yes
            if [[ "${swapmode}" =~ ^(1|2|3)$ ]]; then
                sleep 0.2
                RED "
        ----------------------------------------------------------------
        ###  ${yellowl}INFO: ${nc}${yellow}When ${nc}Hibernating                                  ${red}###

        ###  ${yellow}Nvidia's ${nc}'Preserve Video Memory after suspend' ${yellow}feature  ${red}###

        ###  ${yellow}is incompatible with ${nc}'Early KMS' ${yellow}use                    ${red}###
        ----------------------------------------------------------------"
                NC "


                                      ${bwhite}Press any key to continue${nc}

                "
                read -r -s -n 1
            fi
            # Turing+ GPUs
            if [[ "${family}" == "1" ]]; then
                # Linux Kernel
                if [[ "${kernelnmbr}" == "1" ]]; then
                    nvname="nvidia-open"
                    gfxpkgs+=(libva-mesa-driver libva-nvidia-driver libvdpau-va-gl nvidia-open nvidia-settings nvidia-utils opencl-nvidia opencl-headers vkd3d)
                # Other Kernels
                else
                    gfxpkgs+=(libva-mesa-driver libva-nvidia-driver libvdpau-va-gl nvidia-open-dkms nvidia-settings nvidia-utils opencl-nvidia opencl-headers vkd3d)
                fi
            # Maxwell+ GPUs
            elif [[ "${family}" == "2" ]]; then
                # Linux Kernel
                if [[ "${kernelnmbr}" == "1" ]]; then
                    nvname="nvidia"
                    gfxpkgs+=(libva-mesa-driver libva-nvidia-driver libvdpau-va-gl nvidia nvidia-settings nvidia-utils opencl-nvidia opencl-headers vkd3d)
                # Linux LTS Kernel
                elif [[ "${kernelnmbr}" == "2" ]]; then
                    nvname="nvidia-lts"
                    gfxpkgs+=(libva-mesa-driver libva-nvidia-driver libvdpau-va-gl nvidia-lts nvidia-settings nvidia-utils opencl-nvidia opencl-headers vkd3d)
                # Other Kernels
                else
                    gfxpkgs+=(libva-mesa-driver libva-nvidia-driver libvdpau-va-gl nvidia-dkms nvidia-settings nvidia-utils opencl-nvidia opencl-headers vkd3d)
                fi
            fi
        fi
    # Configure Graphics = no
    elif [[ "${vgaconf}" == "n" ]]; then
        # Nvidia Graphics
        if [[ "${vendor}" == "Nvidia" || "${vendors}" =~ "Nvidia" ]]; then
            gfxpkgs+=(libva-mesa-driver vulkan-nouveau)
        fi
    fi
}
###################################################################################################
slct_dsktp() {

        local prompt="Desktop Setup"
        custompkgs=""
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------------${magenta}[ ${bwhite}Desktop Setup${nc} ${magenta}]${nc}--------------------------------------${magenta}###
        "
        YELLOW "

        >  pilih Desktop: "
        NC "

            [1]  Plasma

            [2]  Minimal Plasma + Desktop Apps + System Optimizations

            [3]  Gnome

            [4]  Minimal Gnome + Desktop Apps + System Optimizations

            [5]  Xfce

            [6]  Cinnamon

            [7]  Deepin

            [8]  Budgie

            [9]  Lxqt

           [10]  Mate

           [11]  Basic Arch Linux (No GUI)

           [12]  Custom Arch Linux
           
           [13]  Cosmic 
           
           [14]  Maomao(Default)     ${red}# ${yellow}Alpha ${red}# "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " packages
        echo

    case "${packages}" in
        1)
            desktopname="Plasma" ;;
        2)
            desktopname="Minimal Plasma (System Optimized)" ;;
        3)
            desktopname="Gnome" ;;
        4)
            desktopname="Minimal Gnome (System Optimized)" ;;
        5)
            desktopname="Xfce" ;;
        6)
            desktopname="Cinnamon"
            sleep 0.2
            YELLOW "


        ###  NOTE: Cinnamon desktop lacks a native Terminal emulator by design

        ###  You can use linux console (ctrl+alt+F3) for shell access


        >  Install ${nc}'gnome-terminal' ${yellow}for convenience ? [Y/n] "
            BLUE "


Enter [Y/n]: "
            read -r -p "
==> " console

        console="${console:-y}"
        console="${console,,}"

        case "${console}" in
            y)
                terminal="gnome-terminal"
                sleep 0.2
                NC "

==> [${green}Terminal OK${nc}] " ;;
            n)
                skip ;;
            *)
                invalid
                return 1 ;;
        esac ;;

        7)
            desktopname="Deepin" ;;
        8)
            desktopname="Budgie"
            sleep 0.2
            YELLOW "


        ###  NOTE: Budgie desktop lacks a native Terminal emulator by design

        ###  You can use linux console (ctrl+alt+F3) for shell access


        >  Install ${nc}'gnome-terminal' ${yellow}for convenience ? [Y/n] "
            BLUE "


Enter [Y/n]: "
            read -r -p "
==> " console

        console="${console:-y}"
        console="${console,,}"

        case "${console}" in
            y)
                terminal="gnome-terminal"
                sleep 0.2
                NC "

==> [${green}Terminal OK${nc}] " ;;
            n)
                skip ;;
            *)
                invalid
                return 1 ;;
        esac ;;

        9)
            desktopname="Lxqt" ;;
       10)
            desktopname="Mate" ;;
       11)
            desktopname="Basic Arch Linux" ;;
       12)
            desktopname="Custom Arch Linux"
            until cust_sys; do :; done
            return 0 ;;
       13)
            desktopname="Cosmic" ;;
       14)
            desktopname="Maomao" ;;
       "")
            choice
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        sleep 0.2
        YELLOW "


        ###  ${desktopname} has been selected


        ###  NOTE: 'base' meta-package does not include the tools needed for building packages

        >  Install ${nc}'base-devel' ${yellow}meta-package ? [Y/n] "
        BLUE "


Enter [Y/n]: "
        read -r -p "
==> " dev

        dev="${dev:-y}"
        dev="${dev,,}"

    case "${dev}" in
        y)
            devel="base-devel"
            sleep 0.2
            NC "

==> [${green}base-devel OK${nc}] " ;;
        n)
            skip ;;
        *)
            invalid
            return 1 ;;
    esac

        sleep 0.2
        YELLOW "


        ###  NOTE: Custom Kernel Parameters can be set at boot time

        >  Enter your own Kernel Parameters ? [y/N]
        >  Abodin gatau ini buat apaan, buat nambahin flags plymouth? idk, N aja dulu"
        BLUE "


Enter [y/N]: "
        read -r -p "
==> " ask_param

        ask_param="${ask_param:-n}"
        ask_param="${ask_param,,}"

        case "${ask_param}" in
            y)
                add_prmtrs ;;
            n)
                skip ;;
            *)
                invalid
                return 1 ;;
        esac
        ok
}
###################################################################################################
cust_sys() {

        local prompt="Custom Arch Linux"
        until add_pkgs; do : ; done
        until add_services; do : ; done
        until add_prmtrs; do : ; done
        echo
        ok
}
###################################################################################################
add_pkgs() {

        local prompt="Add Packages"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Add Your Packages${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        YELLOW "

        ###  'base', 'linux-firmware' (if on bare-metal), 'sudo' & your current choices are already included 
        "
        BLUE "


Enter any additional packages ${bwhite}(space-seperated)${blue}: "
        read -r -p "
==> " custompkgs

    if [[ -z "${custompkgs}" ]]; then
        sleep 0.2
        RED "
        ---------------------------------------------
        ###  ${yellow}Please enter package(s) to continue  ${red}###
        ---------------------------------------------"
        reload
        return 1
    elif [[ "${custompkgs}" =~ "lightdm" ]]; then
        sleep 0.2
        NC "



${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}LightDM Greeter Selection${nc} ${magenta}]${nc}--------------------------------${magenta}###
        "
        YELLOW "

        >  Select a Greeter: "
        NC "

            [1]  Gtk

            [2]  Slick 

            [3]  Deepin "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " greeternmbr

        case "${greeternmbr}" in
            1)
                greeter="lightdm-gtk-greeter"
                sleep 0.2
                NC "

==> [${green}Lightdm Gtk Greeter OK${nc}] " ;;
            2)
                greeter="lightdm-slick-greeter"
                sleep 0.2
                NC "

==> [${green}Lightdm Slick Greeter OK${nc}] " ;;
            3)
                greeter="lightdm-deepin-greeter"
                sleep 0.2
                NC "

==> [${green}Lightdm Deepin Greeter OK${nc}] " ;;
           "")
                choice
                return 1 ;;
            *)
                invalid
                return 1 ;;
        esac
    else
        ok
    fi
}
###################################################################################################
add_services() {

        local prompt="Add Services"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Add Your Services${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        YELLOW "

        ###  Empty to skip 
        "
        BLUE "


Enter services to be enabled ${bwhite}(space-seperated)${blue}: "
        read -r -p "
==> " customservices

    if [[ -z "${customservices}" ]]; then
        skip
    else
        ok
    fi
}
###################################################################################################
add_prmtrs() {

        local prompt="Kernel Parameters"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Add Your  Kernel Parameters${nc} ${magenta}]${nc}-------------------------------${magenta}###
        "
        YELLOW "

        ###  Empty to skip
        "
        BLUE "


Enter your Kernel parameters to be set at boot ${bwhite}(space-seperated)${blue}: "
        read -r -p "
==> " cust_bootopts

    if [[ -z "${cust_bootopts}" ]]; then
        skip
    else
        ok
    fi
}
###################################################################################################
boot_entr() {

    if [[ "${hypervisor}" != "none" ]]; then
        efi_entr_del="yes"
        vm
        sleep 0.2
        YELLOW "
        	
        -->  EFI Boot Entries Deletion skipped
        "
        return 0
    fi

        local prompt="Boot Entries"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}EFI Boot Entries Deletion${nc} ${magenta}]${nc}--------------------------------${magenta}###
        "
        YELLOW "

        >  Select an EFI Boot Entry to Delete  ${red}[!] (CAUTION) [!]

        "
        sleep 0.2
        efibootmgr --unicode
        entrnmbr="$(efibootmgr --unicode | grep -E 'BootOrder' | awk "{print \$2}")"
        boot_entry=" "

    while [[ -n "${boot_entry}" ]]; do
        BLUE "


        Pilih Entri Boot buat dihapus (Ngapain jir dihapus) ${bwhite}(Kosongkan untuk keluar  )${blue}: 
${cyan}Entries: ${yellow}${entrnmbr} "
        read -r -p "
==> " boot_entry
        echo

            if [[ -n "${boot_entry}" ]]; then
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                    reload
                    until sys_submn; do : ; done
                fi
                if efibootmgr -b "${boot_entry}" -B --unicode; then
                    sleep 0.2
                    NC "

==> [${green}Entry ${boot_entry} Deleted${nc}] "
                else
                    err_try
                    return 1
                fi
            else
                skip
                ok
            fi
    done
        efi_entr_del="yes"
}
###################################################################################################
wireless_rgd() {

    if [[ "${hypervisor}" != "none" ]]; then
        wrlss_rgd="yes"
        vm
        sleep 0.2
        YELLOW "
        	
        -->  Wireless Regulatory Domain Setup skipped
        "
        return 0
    fi

        local prompt="Wireless Regdom Setup"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------${magenta}[ ${bwhite}Wireless Regulatory  Domain Setup${nc} ${magenta}]${nc}----------------------------${magenta}###
        "

        YELLOW "

        >  Select your Country Code (e.g. US)


        ###  [Enter ${nc}'l'${yellow} to list country codes, then ${nc}'enter'${yellow} to search or ${nc}'q'${yellow} to quit] 
        ### kosongkan aja, kecuali kalau lu di amerika atau di Depok"
        BLUE "


Enter your Country Code, ie:${nc} ${cyan}US ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " REGDOM

    if [[ -z "${REGDOM}" ]]; then
        skip
    elif [[ "${REGDOM}" == "l" ]]; then
        sed 's|^#WIRELESS_REGDOM=||g' /etc/conf.d/wireless-regdom |sed 's|"||g'| more
        return 1
    elif [[ "${REGDOM}" =~ [[:lower:]] ]]; then
        sleep 0.2
        RED "
        ------------------------------------------------------
        ###  ${yellow}Lowercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
        reload
        return 1
    elif ! grep \""${REGDOM}"\" /etc/conf.d/wireless-regdom > /dev/null 2>&1 ; then
        invalid
        return 1
    else
        wireless_reg="wireless-regdb"
        sleep 0.2
        YELLOW "

        ###  ${REGDOM} Country Code has been selected
        "
    fi
        ok
        wrlss_rgd="yes"
}
###################################################################################################
dsks_submn() {

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Disk Management${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        YELLOW "

        >  Select a Submenu: "
        NC "

            [1]  Disk GPT Manager

            [2]  Partition Manager

            [ ]  Return to Main Menu "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " diskmenu
        echo

    case "${diskmenu}" in
        1)
            until gpt_mngr; do : ; done ;;
        2)
            until disk_mngr; do : ; done ;;
       "")
            until main_menu; do : ; done ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
gpt_mngr() {

        local prompt="Disk GPT"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Disk  GPT Manager${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        gpt_dsk_nmbr=" "

    while [[ -n "${gpt_dsk_nmbr}" ]]; do
        YELLOW "

        >  Select a disk to manage its GPT:


        ###  Select disk and:

        ###  Type ${nc}'?'${yellow} for help, ${nc}'x'${yellow} for extra functionality or ${nc}'q'${yellow} to quit "
        NC "

${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " gpt_dsk_nmbr
        echo

        if [[ -n "${gpt_dsk_nmbr}" ]]; then
            gptdrive="$(echo "${disks}" | awk "\$1 == ${gpt_dsk_nmbr} {print \$2}")"
            if [[ -e "${gptdrive}" ]]; then
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                    reload
                    until dsks_submn; do : ; done
                fi
                NC "
______________________________________________
                "
                gdisk "${gptdrive}"
                sleep 0.2
                NC "

==> [${green}${gptdrive} OK${nc}] 
                "
            else
                invalid
                return 1
            fi
        else
            skip
            ok

            if [[ "${install}" == "yes" ]]; then
                until instl_dsk; do : ; done
            else
                until dsks_submn; do : ; done
            fi
        fi
    done
}
###################################################################################################
ask_multibooting() {

        local prompt="MultiBoot Status"
        sleep 0.2
        NC "

${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}MultiBoot Status${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        YELLOW "


        >  Are you ${nc}Dual/Multi-Booting ${yellow}with other OS's ? [y/n]
        ### Abodin belum tes ni fungsi, jadi N dulu banh, kalau mau dual boot imphenos
        ### ke discord Imphnen aja nanti dipandu sama abodin, takut Windows kau kehapus




        ###  If ${nc}'(y)es'${yellow} then:


           1. Your ${nc}EFI ${yellow}System Partition (ESP) will stay ${nc}intact${yellow}

           2. Only ${nc}'Manual' ${yellow}Disk Partitioning will be available in ${nc}'Disk Manager'"
        BLUE "


Enter [y/n]: "
        read -r -p "
==> " multibooting

    case "${multibooting}" in
        y)
            sleep 0.2
            YELLOW "

        ###  Dual/Multi-Boot selected
            " ;;
        n)  sleep 0.2
            YELLOW "

        ###  No Dual/Multi-Boot
            " ;;
       "")
            y_n
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
        ok
}
###################################################################################################
disk_mngr() {

        if [[ "${multibooting}" == "y" ]]; then
            until manual_part; do : ; done
            return 0
        fi

        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Partition Manager${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        YELLOW "

        >  Select a Mode: "
        NC "

            [1]  Automatic Partitioning

            [2]  Manual Partitioning "
        BLUE "


Pilih Nomor: "
        read -r -p "
==> " part_mode

    case "${part_mode}" in
        1)
            until auto_part; do : ; done ;;
        2)
            until manual_part; do : ; done ;;
       "")
            sleep 0.2
            RED "
        ------------------------------
        ###  ${yellow}Tolong Pilih Mode :3  ${red}###
        ------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac
}
###################################################################################################
man_preset() {

        sleep 0.2
        NC "

${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Pilih Preset${nc} ${magenta}]${nc}------------------------------------${magenta}###   
        "
        sleep 0.2
        line2
        REDBG "       ------------------------------------------------------------ "
        REDBG "       [!] WARNING: Data yang ada di partisi akan hilang [!] "
        REDBG "       ------------------------------------------------------------ "
        line2
        NC "



        ${bwhite}Tolong Twerking untuk Mulai (atau tekan tombol apapun, jangan tombol Power ya anjeng)${nc}


        "
        read -r -s -n 1
        YELLOW "

        >  pilih tipe Partisi: "
        NC "

          ${cyan}* Ext4${nc} tipe orang normal

          ${magenta}* Btrfs${nc} Utusan tuhan (kecuali kau ngerti ni biji buat apaan, abodin gatau)



            [1]  Create '/ESP' and '/Root'                                   (${cyan}Ext4${nc},${magenta}Btrfs${nc})

            [2]  Create '/ESP', '/Root' and '/Swap'                          (${cyan}Ext4${nc},${magenta}Btrfs${nc})

            [3]  Create '/ESP', '/Root' and '/Home'                          (${cyan}Ext4${nc})

            [4]  Create '/ESP', '/Root', '/Home' and '/Swap'                 (${cyan}Ext4${nc}) "
        BLUE "

### kalau abodin sih pilih yang 1 aja sih, kalau no 2 kalau pake swap, no 3 kalau lu gila, 4 kalau lu mau nyusahin diri
Pilih nomor ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " preset
        echo

    if [[ "${preset}" =~ ^(1|2|3|4)$ ]]; then
        presetpart="y"
    fi
}
###################################################################################################
auto_part() {

        slct_autoprt="yes"
        smartpart=""
        presetpart=""
        local prompt="Disk Partitions"
        local stage_prompt="Auto-Partitioning"
        sleep 0.2
        NC "


${magenta}###${nc}---------------------------------${magenta}[ ${bwhite}Automatic  Partitioning${nc} ${magenta}]${nc}---------------------------------${magenta}###
        "
        sleep 0.2
        line2
        REDBG "       ------------------------------------------------------------ "
        REDBG "       [!] WARNING: Data akan dihapus di partisi yang dipilih [!] "
        REDBG "       ------------------------------------------------------------ "
        line2
        NC "



                                      ${bwhite}Puress Any keiy to Sutartooo${nc}


        "
        read -r -s -n 1

        if [[ -e "${instl_drive}" && "${use_manpreset}" != "yes" ]]; then
            sleep 0.2
            NC "
        -----------------------------------------------------------
        ${cyan}>>  ${nc}Apply ${yellowl}'Smart Partitioning' ${nc}on disk ${bwhite}'${instl_drive}'${nc} ?   ${cyan}[y/n]${nc}
        -----------------------------------------------------------
            "
            read -r -p "
==> " smartpart
            echo

            if [[ "${smartpart}" == "y" ]]; then
                sgdsk_nmbr="${instl_dsk_nmbr}"
            elif [[ "${smartpart}" == "n" ]]; then
                sgdsk_nmbr="${instl_dsk_nmbr}"
                use_manpreset="yes"
                process
                until man_preset; do : ; done
            else
                y_n
                return 1
            fi
        else
            YELLOW "
        >  Pilih Hardisk untuk Auto-Partitioning: 
        >  Cek nama Hardisk yang dipakai kau, nanti salah pilih
        >  Windows kau kehapus, mampuussss"
            NC "

${disks}"
            BLUE "


Pilih Hardisk ${bwhite}(Gak pilih bapaknya hamil)${blue}: "
            read -r -p "
==> " sgdsk_nmbr
            echo
        fi

        if [[ -n "${sgdsk_nmbr}" ]]; then
            sgdrive="$(echo "${disks}" | awk "\$1 == ${sgdsk_nmbr} {print \$2}")"
            if [[ -e "${sgdrive}" ]]; then
                capacity="$(fdisk -l "${sgdrive}" | grep -E 'bytes' | grep -E 'Disk' | awk "{print \$5}")"
                cap_gib="$((capacity/1024000000))"
                rootsize="$((capacity*25/100/1024000000))"
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Wallahi, lupa mode${red}root..  ${red}, Ulangi Ngab###
        -----------------------------------"
                    reload
                    until dsks_submn; do : ; done
                fi

                if [[ -z "${use_manpreset}" ]]; then
                    if [[ "${fs}" == "2" ]]; then
                        if [[ "${swapmode}" == "1" ]]; then
                            preset="2"
                        elif [[ "${swapmode}" != "1" ]]; then
                            preset="1"
                        fi
                    elif [[ "${fs}" == "1" ]] ; then
                        if [[ "${sep_home}" == "y" && "${swapmode}" == "1" ]]; then
                            preset="4"
                        elif [[ "${sep_home}" == "y" && "${swapmode}" != "1" ]]; then
                            preset="3"
                        elif [[ "${sep_home}" == "n" && "${swapmode}" == "1" ]]; then
                            preset="2"
                        elif [[ "${sep_home}" == "n" && "${swapmode}" != "1" ]]; then
                            preset="1"
                        fi
                    else
                        until man_preset; do : ; done
                    fi
                elif [[ -z "${preset}" ]] ; then
                    process
                    until manual_part; do : ; done
                    return 0
                fi
                
                if [[ "${preset}" == "3" || "${preset}" == "4" ]] ; then
                    sleep 0.2
                    YELLOW "


        ###  total Kapasitas Hardisk ${nc}${sgdrive} ${yellow}Adalah ${nc}${cap_gib} GiB${yellow}


        ###  Partisi ${nc}/Root${yellow} Ukurannya kira kira . ${nc}25%${yellow} dari total kapasitas Hardisk  ${nc}[${rootsize} GiB]${yellow}



        >  Atur Ukuran Partisi /Root dalam Persen ? "
                    BLUE "


Masukin Berapa Persen ${nc}Contoh: 30 ${bwhite}(Kosong buat Skip)${blue}: "
                    read -r -p "
==> " prcnt
                    echo
                fi

                if [[ "${preset}" == "3" || "${preset}" == "4" ]] ; then
                    if [[ "${prcnt}" =~ [[:alpha:]] ]]; then
                        sleep 0.2
                        RED "
        -------------------------------------------
        ###  ${yellow}Pake nomor doang gapake persen  ${red}###
        -------------------------------------------"
                        reload
                        return 1
                    elif [[ -z "${prcnt}" ]]; then
                        sleep 0.2
                        YELLOW "

        ###  Ukuran /Root Default Digunakan ${nc}[${rootsize} GiB]
                        "
                    elif [[ "${prcnt}" -gt "0" && "${prcnt}" -lt "100" ]]; then
                        rootsize="$((capacity*"${prcnt}"/100/1024000000))"
                        sleep 0.2
                        YELLOW "

        ###  Ukuran /Root Custom Digunakan ${nc}[${rootsize} GiB]
                        "
                    elif [[ "${prcnt}" == "100" ]]; then
                        sleep 0.2
                        RED "
        -----------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}Ga cukup jir Hardisknya  ${red}###
        -----------------------------------------------------"
                        reload
                        return 1
                    else
                        invalid
                        return 1
                    fi
                fi

                case "${preset}" in
                    1)
                        wipefs -af "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -o "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n1:0:+512M -t1:ef00 -c1:ESP "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n2:0:0 -t2:8304 -c2:ROOT "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        partprobe -s "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        if [[ "${install}" == "yes" ]]; then
                            until sanity_check; do : ; done
                        else
                            ok
                        fi ;;
                    2)
                        until set_swapsize; do : ; done
                        wipefs -af "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -o "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n1:0:+512M -t1:ef00 -c1:ESP "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n2:0:+"${swapsize}"G -t2:8200 -c2:SWAP "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n3:0:0 -t3:8304 -c3:ROOT "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        partprobe -s "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        if [[ "${install}" == "yes" ]]; then
                            until sanity_check; do : ; done
                        else
                            ok
                        fi ;;
                    3)
                        wipefs -af "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -o "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n1:0:+512M -t1:ef00 -c1:ESP "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n2:0:+"${rootsize}"G -t2:8304 -c2:ROOT "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n3:0:0 -t3:8302 -c3:HOME "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        partprobe -s "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        if [[ "${install}" == "yes" ]]; then
                            until sanity_check; do : ; done
                        else
                            ok
                        fi ;;
                    4)
                        wipefs -af "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        until set_swapsize; do : ; done
                        sgdisk -o "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n1:0:+512M -t1:ef00 -c1:ESP "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n2:0:+"${swapsize}"G -t2:8200 -c2:SWAP "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n3:0:+"${rootsize}"G -t3:8304 -c3:ROOT "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        sgdisk -I -n4:0:0 -t4:8302 -c4:HOME "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        partprobe -s "${sgdrive}" > /dev/null 2> install_log.txt || stage_fail
                        if [[ "${install}" == "yes" ]]; then
                            until sanity_check; do : ; done
                        else
                            ok
                        fi ;;
                   "")
                        if [[ "${smartpart}" == "n"  ]]; then
                            reload
                            until disk_mngr; do : ; done
                            return 0
                        fi
                        if [[ "${slct_autoprt}" == "yes"  ]]; then
                            reload
                            until dsks_submn; do : ; done
                            return 0
                        fi
                        sleep 0.2
                        RED "
        --------------------------------
        ###  ${yellow}Pilih Preset  ${red}###
        --------------------------------"
                        reload
                        return 1 ;;
                    *)
                        invalid
                        return 1 ;;
                esac

                if [[ "${install}" == "yes" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            else
                invalid
                return 1
            fi
        else
            skip
            reload

            if [[ -z "${sanity}" ]]; then
                until dsks_submn; do : ; done
            elif [[ "${sanity}" == "no" ]]; then
                until sanity_check; do : ; done
            elif [[ "${revision}" == "yes" ]]; then
                return 0
            elif [[ "${sanity}" == "ok" ]]; then
                if [[ "${install}" == "yes" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            fi
        fi
}
###################################################################################################
manual_part() {

        local prompt="Disks"
        stage_prompt="Partitioning"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Partisi Manual${nc} ${magenta}]${nc}-----------------------------------${magenta}###
        "
        cgdsk_nmbr=" "
    while [[ -n "${cgdsk_nmbr}" ]]; do
        line3
        NC "                           SUPPORTED PARTITION TYPES & MOUNTPOINTS: "
        line2
        REDBG     "      ------------------------------------------------------------------------------------------- "
        REDBG     "      ###  Linux Root x86-64 Partition  [ GUID Code: 8304 ]            Mountpoint:  /         ### "
        REDBG     "      ------------------------------------------------------------------------------------------- "
        echo
        BLUEBG    "      ------------------------------------------------------------------------------------------- "
        BLUEBG    "      ###  EFI System Partition  [ GUID Code: ef00 ]           Mountpoint:  /efi or /boot     ### "
        BLUEBG    "      ------------------------------------------------------------------------------------------- "
        echo
        GREENBG   "      ------------------------------------------------------------------------------------------- "
        GREENBG   "      ###  Linux Home Partition  [ GUID Code: 8302 ]                   Mountpoint:  /home     ### "
        GREENBG   "      ------------------------------------------------------------------------------------------- "
        echo
        YELLOWBG  "      ------------------------------------------------------------------------------------------- "
        YELLOWBG  "      ###  Linux Swap Partition  [ GUID Code: 8200 ]                   Mountpoint:  /swap     ### "
        YELLOWBG  "      ------------------------------------------------------------------------------------------- "
        echo
        MAGENTABG "      ------------------------------------------------------------------------------------------- "
        MAGENTABG "      ###  Linux Extended Boot Partition  [ GUID Code: ea00 ]          Mountpoint:  /boot     ### "
        MAGENTABG "      ------------------------------------------------------------------------------------------- "
        YELLOW "



        >  Select a disk to Manage: "
        NC "

${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " cgdsk_nmbr

        if [[ -n "${cgdsk_nmbr}" ]]; then
            cgdrive="$(echo "${disks}" | awk "\$1 == ${cgdsk_nmbr} {print \$2}")"
            if [[ -e "${cgdrive}" ]]; then
                if [[ "${run_as}" != "root" ]]; then
                    sleep 0.2
                    RED "
        -----------------------------------
        ###  ${yellow}Root Privileges Missing..  ${red}###
        -----------------------------------"
                    reload
                    until dsks_submn; do : ; done
                fi
                cgdisk "${cgdrive}"
                clear
                sleep 0.2
                NC "


==> [${green}Disk ${cgdrive} OK${nc}] "
                partprobe -s "${cgdrive}"
                return 1
            else
                invalid
                return 1
            fi
        else
            skip

            if [[ "${partok}" == "n" ]]; then
                until sanity_check; do : ; done
            elif [[ -z "${sanity}" ]]; then
                until dsks_submn; do : ; done
            elif [[ "${sanity}" == "no" ]]; then
                until sanity_check; do : ; done
            elif [[ "${revision}" == "yes" ]]; then
                return 0
            elif [[ "${sanity}" == "ok" ]]; then
                if [[ "${install}" == "yes" ]]; then
                    return 0
                fi
                until dsks_submn; do : ; done
            fi
        fi
    done
}
###################################################################################################
instl_dsk() {

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Pemilihan Hardisk${nc} ${magenta}]${nc}-------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Hardisk buat install: 
        >  pilih yang bener, nanti kehapus window kau"
        NC "

${disks}"
        BLUE "


Enter a disk number: "
        read -r -p "
==> " instl_dsk_nmbr
        echo

    if [[ -n "${instl_dsk_nmbr}" ]]; then
        instl_drive="$(echo "${disks}" | awk "\$1 == ${instl_dsk_nmbr} {print \$2}")"
        if [[ -e "${instl_drive}" ]]; then
            if [[ "${run_as}" != "root" ]]; then
                sleep 0.2
                RED "
        -----------------------------------
        ###  ${yellow}Wallahi, lupa mode${red}root..  ${red}, Ulangi Ngab###
        -----------------------------------"
                reload
                until main_menu; do : ; done
            fi
            volumes="$(fdisk -l | grep '^/dev' | cat --number)"
            rota="$(lsblk "${instl_drive}" --nodeps --noheadings --output=rota | awk "{print \$1}")"
            if [[ "${rota}" == "0" ]]; then
                sbvl_mnt_opts="rw,noatime,compress=zstd:1"
                trim="fstrim.timer"
            else
                sbvl_mnt_opts="rw,compress=zstd"
            fi
            parttable="$(fdisk -l "${instl_drive}" | grep '^Disklabel type' | awk "{print \$3}")"
            if [[ "${parttable}" != "gpt" ]]; then
                sleep 0.2
                RED "
        ---------------------------------------
        ###  ${yellow}Tidak Terdeteksi GPT di Hardisk  ${red}###
        ---------------------------------------"
                reload
                until gpt_mngr; do : ; done
                return 0
            fi
            if [[ -z "${multibooting}" ]]; then
                until ask_multibooting; do : ; done
            fi
            until sanity_check; do : ; done
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
sanity_check() {

        sleep 0.2
        NC "

${magenta}###${nc}--------------------------------------${magenta}[ ${bwhite}Sanity  Check${nc} ${magenta}]${nc}--------------------------------------${magenta}###
        "
        rootcount="$(fdisk -l "${instl_drive}" | grep -E -c 'root' | awk "{print \$1}")"
        root_dev="$(fdisk -l "${instl_drive}" | grep -E 'root' | awk "{print \$1}")"
        multi_root="$(fdisk -l "${instl_drive}" | grep -E 'root' | awk "{print \$1}" | cat --number)"
        root_comply="$(fdisk -l "${instl_drive}" | grep -E 'root' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        espcount="$(fdisk -l "${instl_drive}" | grep -E -c 'EFI' | awk "{print \$1}")"
        esp_dev="$(fdisk -l "${instl_drive}" | grep -E 'EFI' | awk "{print \$1}")"
        multi_esp="$(fdisk -l "${instl_drive}" | grep -E 'EFI' | awk "{print \$1}" | cat --number)"
        esp_comply="$(fdisk -l "${instl_drive}" | grep -E 'EFI' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        xbootcount="$(fdisk -l "${instl_drive}" | grep -E -c 'extended' | awk "{print \$1}")"
        xboot_dev="$(fdisk -l "${instl_drive}" | grep -E 'extended' | awk "{print \$1}")"
        multi_xboot="$(fdisk -l "${instl_drive}" | grep -E 'extended' | awk "{print \$1}" | cat --number)"
        xboot_comply="$(fdisk -l "${instl_drive}" | grep -E 'extended' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        homecount="$(fdisk -l "${instl_drive}" | grep -E -c 'home' | awk "{print \$1}")"
        home_dev="$(fdisk -l "${instl_drive}" | grep -E 'home' | awk "{print \$1}")"
        multi_home="$(fdisk -l "${instl_drive}" | grep -E 'home' | awk "{print \$1}" | cat --number)"
        home_comply="$(fdisk -l "${instl_drive}" | grep -E 'home' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"
        swapcount="$(fdisk -l "${instl_drive}" | grep -E -c 'swap' | awk "{print \$1}")"
        swap_dev="$(fdisk -l "${instl_drive}" | grep -E 'swap' | awk "{print \$1}")"
        multi_swap="$(fdisk -l "${instl_drive}" | grep -E 'swap' | awk "{print \$1}" | cat --number)"
        swap_comply="$(fdisk -l "${instl_drive}" | grep -E 'swap' | awk "{print \$1}" | cat --number | grep -E '1[[:blank:]]' | awk "{print \$2}")"

    if [[ "${rootcount}" -gt "1" ]]; then
        local stage_prompt="Selecting Partition"
        sleep 0.2
        RED "
        ----------------------------------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}Multiple Linux x86-64 /Root Partitions have been detected  ${red}###
        ----------------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux x86-64 /Root Partitions:
     
     ------------------------------
${multi_root}
     ------------------------------
        "
        YELLOW "

        ###  Only the 1st Linux x86-64 /Root partition on a selected disk can be auto-assigned as a valid /Root partition


        ###  Partition ${nc}${root_comply} ${yellow}is auto-assigned as such and will be ${red}[!] ${nc}FORMATTED ${red}[!]
                "
        BLUE "


        >  Proceed ? [Y/n]"
        read -r -p "
==> " autoroot

        autoroot="${autoroot:-y}"
        autoroot="${autoroot,,}"

        if [[ "${autoroot}" == "y" ]]; then
            root_dev="${root_comply}"
            multiroot_bootopts="root=PARTUUID=$(blkid -s PARTUUID -o value "${root_dev}")"
        elif [[ "${autoroot}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi

    if [[ "${espcount}" -gt "1" ]]; then
        local stage_prompt="Selecting Partition"
        sleep 0.2
        RED "
        --------------------------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}Multiple EFI System Partitions have been detected  ${red}###
        --------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux EFI System Partitions:
     
     ----------------------------
${multi_esp}
     ----------------------------
        "
        YELLOW "

        ###  Only the 1st EFI partition on a selected disk can be auto-assigned as a valid EFI partition
        "
        if [[ "${multibooting}" == "n" ]]; then
            YELLOW "
        ###  Partition ${nc}${esp_comply} ${yellow}is auto-assigned as such and will be ${red}[!] ${nc}FORMATTED ${red}[!]
            "
        elif [[ "${multibooting}" == "y" ]]; then
            YELLOW "
        ###  Partition ${nc}${esp_comply} ${yellow}is auto-assigned as such
            "
        fi
        BLUE "


        >  Proceed ? [Y/n]"
        read -r -p "
==> " autoesp

        autoesp="${autoesp:-y}"
        autoesp="${autoesp,,}"

        if [[ "${autoesp}" == "y" ]]; then
            esp_dev="${esp_comply}"
        elif [[ "${autoesp}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi
    
    if [[ "${xbootcount}" -gt "1" ]]; then
        local stage_prompt="Selecting Partition"
        sleep 0.2
        RED "
        -----------------------------------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}Multiple Linux Extended Boot Partitions have been detected  ${red}###
        -----------------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux Extended Boot Partitions:
     
     ----------------------------
${multi_xboot}
     ----------------------------
        "
        YELLOW "

        ###  Only the 1st Linux Extended Boot partition on a selected disk can be auto-assigned as a valid XBOOTLDR partition


        ###  Partition ${nc}${xboot_comply} ${yellow}is auto-assigned as such and will be ${red}[!] ${nc}FORMATTED ${red}[!]
                "
        BLUE "


        >  Proceed ? [Y/n]"
        read -r -p "
==> " autoxboot

        autoxboot="${autoxboot:-y}"
        autoxboot="${autoxboot,,}"

        if [[ "${autoxboot}" == "y" ]]; then
            xboot_dev="${xboot_comply}"
        elif [[ "${autoxboot}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi

    if [[ ${fs} == "1" && ${sep_home} == "y" && "${homecount}" -gt "1" ]]; then
        local stage_prompt="Selecting Partition"
        sleep 0.2
        RED "
        ---------------------------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}Multiple Linux /Home Partitions have been detected  ${red}###
        ---------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
     Linux /Home Partitions:
     
     -----------------------
${multi_home}
     -----------------------
        "
        YELLOW "

        ###  Only the 1st Linux /Home partition on a selected disk can be auto-assigned as a valid /Home partition


        ###  Partition ${nc}${home_comply} ${yellow}is auto-assigned as such and will be ${red}[!] ${nc}FORMATTED ${red}[!]
        "
        BLUE "


        >  Proceed ? [Y/n]"
        read -r -p "
==> " autohome

        autohome="${autohome:-y}"
        autohome="${autohome,,}"

        if [[ "${autohome}" == "y" ]]; then
            home_dev="${home_comply}"
        elif [[ "${autohome}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi

    if [[ ${swapmode} == "1" && "${swapcount}" -gt "1" ]]; then
        local stage_prompt="Selecting Partition"
        sleep 0.2
        RED "
        ---------------------------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}Multiple Linux /Swap Partitions have been detected  ${red}###
        ---------------------------------------------------------------------
        "
        sleep 0.2
        YELLOW "
###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        NC "
      Linux /Swap Partitions:

     ------------------------
${multi_swap}
     ------------------------
        "
        YELLOW "

        ###  Only the 1st Linux /Swap partition on a selected disk can be auto-assigned as a valid /Swap partition


        ###  Partition ${nc}${swap_comply} ${yellow}is auto-assigned as such and will be ${red}[!] ${nc}FORMATTED ${red}[!]
                "
        BLUE "


        >  Proceed ? [Y/n]"
        read -r -p "
==> " autoswap

        autoswap="${autoswap:-y}"
        autoswap="${autoswap,,}"

        if [[ "${autoswap}" == "y" ]]; then
            swap_dev="${swap_comply}"
        elif [[ "${autoswap}" == "n" ]]; then
            stage_fail
        else
            y_n
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------

    if [[ -e "${root_dev}" ]]; then
        rootpartsize="$(lsblk -dno SIZE --bytes "${root_dev}")"
        if [[ "${rootpartsize}" -ge "8589934592" ]]; then
            rootprt="ok"
        else
            rootprt="ok"
            sleep 0.2
            RED "
        -----------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}/Root's size might not be adequate  ${red}###
        -----------------------------------------------------"
            sleep 0.2
            RED "
        ------------------------------------------------------------------------
        ###  ${yellow}Depending on the size of your setup, installation might fail !  ${red}###
        ------------------------------------------------------------------------"
        NC "



                                     ${bwhite}Press any key to continue${nc}


        "
        read -r -s -n 1
        fi
        if [[ "${autoroot}" == "y" ]]; then
            if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                sleep 0.2
                NC "

==> [Linux x86-64 /Root ${green}OK${nc}] "
            else
                local prompt="Confirmed /Root Partition"
                ok
            fi
        else
            sleep 0.2
            NC "

==> [Linux x86-64 /Root ${green}OK${nc}] "
        fi
    else
        rootprt="fail"
        sleep 0.2
        RED "
        ---------------------------------------------------
        ###  ${yellow}Linux x86-64 /Root Partition not detected  ${red}###
        ---------------------------------------------------"
    fi
#..................................................................................................

    if [[ ! -e "${esp_dev}" ]]; then
        espprt="fail"
        sleep 0.2
        RED "
        -------------------------------------------
        ###  ${yellow}EFI System Partition not detected  ${red}###
        -------------------------------------------"
    fi

    if [[ -e "${esp_dev}" ]]; then
        espsize="$(lsblk -dno SIZE --bytes "${esp_dev}")"
    fi

    if [[ "${espsize}" -ge "209715200" ]]; then
        espprt="ok"
        xbootloader="no"
        if [[ "${autoesp}" == "y" ]]; then
            if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                sleep 0.2
                NC "

==> [EFI System Partition ${green}OK${nc}] "
            else
                local prompt="Confirmed /EFI System Partition"
                ok
            fi
        else
            sleep 0.2
            NC "

==> [EFI System Partition ${green}OK${nc}] "
        fi
    fi

    if [[ -e "${esp_dev}" && "${espsize}" -lt "209715200" ]]; then
        if [[ "${bootloader}" == "1" ]]; then
            if [[ "${multibooting}" == "y" ]]; then
                xbootloader="yes"
                if [[ -e "${xboot_dev}" ]]; then
                    xbootprt="ok"
                    espprt="ok"
                    if [[ "${autoesp}" == "y" ]]; then
                        if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                            sleep 0.2
                            NC "

==> [EFI System Partition ${green}OK${nc}] "
                        else
                            local prompt="Confirmed EFI System Partition"
                            ok
                        fi
                    else
                        sleep 0.2
                        NC "

==> [EFI System Partition ${green}OK${nc}] "
                    fi
                    if [[ "${autoxboot}" == "y" ]]; then
                        if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                            sleep 0.2
                            NC "

==> [Linux Extended Boot Partition ${green}OK${nc}] "
                        else
                            local prompt="Confirmed /XBOOTLDR Partition"
                            ok
                        fi
                    else
                        sleep 0.2
                        NC "

==> [Linux Extended Boot Partition ${green}OK${nc}] "
                    fi
                else
                    xbootprt="fail"
                    espprt="fail"
                    sleep 0.2
                    RED "
        ---------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}ESP's size is not adequate  ${red}###
        ---------------------------------------------"
                    sleep 0.2
                    RED "
        ----------------------------------------------------
        ###  ${yellow}Linux Extended Boot Partition not detected  ${red}###
        ----------------------------------------------------"
                fi
            elif [[ "${multibooting}" == "n" ]]; then
                espprt="fail"
                xbootloader="no"
                sleep 0.2
                RED "
        ---------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}ESP's size is not adequate  ${red}###
        ---------------------------------------------"
            fi
        elif [[ "${bootloader}" == "2" ]]; then
            if [[ "${espmnt}" == "2" ]]; then
                espprt="fail"
                xbootloader="no"
                sleep 0.2
                RED "
        ---------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}ESP's size is not adequate  ${red}###
        ---------------------------------------------"
            elif [[ "${espmnt}" == "1" ]]; then
                espprt="ok"
                xbootloader="no"
                if [[ "${autoesp}" == "y" ]]; then
                    if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                        sleep 0.2
                        NC "

==> [EFI System Partition ${green}OK${nc}] "
                    else
                        local prompt="Confirmed EFI System Partition"
                        ok
                    fi
                else
                    sleep 0.2
                    NC "

==> [EFI System Partition ${green}OK${nc}] "
                fi
            fi
        fi
    fi
#..................................................................................................
    if [[ "${fs}" == "1" ]]; then
        if [[ "${sep_home}" == "y" ]]; then
            if [[ -e "${home_dev}" ]]; then
                homeprt="ok"
                if [[ "${autohome}" == "y" ]]; then
                    if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                        sleep 0.2
                        NC "

==> [Linux /Home ${green}OK${nc}] "
                    else
                        local prompt="Confirmed /Home Partition"
                        ok
                    fi
                else
                    sleep 0.2
                    NC "

==> [Linux /Home ${green}OK${nc}] "
                fi
            else
                homeprt="fail"
                sleep 0.2
                RED "
        --------------------------------------------
        ###  ${yellow}Linux /Home Partition not detected  ${red}###
        --------------------------------------------"
            fi
        fi
    fi
#..................................................................................................
    if [[ "${swapmode}" == "1" ]]; then
        if [[ -e "${swap_dev}" ]]; then
            swapprt="ok"
            if [[ "${autoswap}" == "y" ]]; then
                if [[ "${presetpart}" == "y" || "${smartpart}" == "y" ]]; then
                    sleep 0.2
                    NC "

==> [Linux /Swap ${green}OK${nc}] "
                else
                    local prompt="Confirmed /Swap Partition"
                    ok
                fi
            else
                sleep 0.2
                NC "

==> [Linux /Swap ${green}OK${nc}] "
            fi
        else
            swapprt="fail"
            sleep 0.2
            RED "
        --------------------------------------------
        ###  ${yellow}Linux /Swap Partition not detected  ${red}###
        --------------------------------------------"
        fi
    fi
#..................................................................................................
    if [[ ${rootprt} == "fail" ]] || [[ "${espprt}" == "fail" ]] || [[ "${xbootprt}" == "fail" ]] || [[ ${homeprt} == "fail" ]] || [[ ${swapprt} == "fail" ]]; then
        sanity="no"
    else
        sanity="ok"
    fi
#--------------------------------------------------------------------------------------------------    
    if [[ "${sanity}" == "ok" ]]; then
        if [[ "${smartpart}" == "y" ]]; then
            sleep 0.2
            NC "

==> [${green}Disk ${sgdrive} Smart-Partitioned OK${nc}] "
        elif [[ "${presetpart}" == "y" ]]; then
            sleep 0.2
            NC "

==> [${green}Disk ${sgdrive} Preset-Partitioned OK${nc}] "
        fi
        sleep 0.2
        NC "

        -----------------------
        ### ${green}SANITY CHECK OK${nc} ###
        -----------------------"
        sleep 0.2
        YELLOW "


###------------------------------------------------[ DISK OVERVIEW ]------------------------------------------------###

        "
        fdisk -l "${instl_drive}" | grep -E --color=no 'Dev|dev' |GREP_COLORS='mt=01;36' grep -E --color=always 'EFI System|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'Linux root|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'Linux home|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'Linux swap|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'Linux extended boot|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------### "
        BLUE "


        >  Lanjutkan pakai partisi ${nc}${cyan}sekarang ${blue} ? [Y/n]
        "
        read -r -p "
==> " partok

        echo
        partok="${partok:-y}"
        partok="${partok,,}"

        local prompt="Disk Partitioning"
        local stage_prompt="Partitioning"

        if [[ "${partok}" == "y" ]]; then
            ok
            return 0
        elif [[ "${partok}" == "n" ]]; then
            if [[ "${multibooting}" == "n" ]]; then
                if [[ "${smartpart}" == "y" ]]; then
                    process
                    until manual_part; do : ; done
                else
                    process
                    if [[ "${slct_autoprt}" != "yes" && "${xbootloader}" != "yes" ]]; then
                        until auto_part; do : ; done
                    else
                        until manual_part; do : ; done
                    fi
                fi
            elif [[ "${multibooting}" == "y" ]]; then
                process
                until manual_part; do : ; done
            fi
        else
            y_n
            return 1
        fi
#--------------------------------------------------------------------------------------------------
    elif [[ "${sanity}" == "no" ]]; then
        sleep 0.2
        RED "

        -----------------------------
        ###  ${yellow}SANITY CHECK FAILED${red}  ###
        -----------------------------"
        NC "



                                      ${bwhite}Press any key to continue${nc}


        "
        read -r -s -n 1
        
        if [[ "${multibooting}" == "y" ]]; then
            if [[ "${espprt}" == "fail" && -e "${esp_dev}" ]]; then
                sleep 0.2
                CYAN "
        ---------------------------------------------------
        ###  ${yellowl}/ESP: Not all prerequisites are satisfied  ${nc}${cyan}###
        ---------------------------------------------------"
                if [[ "${espmnt}" == "2" ]]; then
                    sleep 0.2
                    NC "

        ----------------------------------------------------
        >>>  ${cyan}Select ${yellowl}/mnt/efi ${nc}${cyan}as the mountpoint for your ${yellowl}/ESP ${nc}${nc}
        ----------------------------------------------------"
                fi
                if [[ "${xbootprt}" == "fail" ]]; then
                    sleep 0.2
                    NC "
        ------------------------------------------------------------------------------------------
        >>>  ${cyan}Systemd-boot:${nc}

        >>>  ${cyan}Create a ${yellowl}300M ${nc}${cyan}(at minimum) Linux Extended Boot Partition ${nc}(XBOOTLDR) ${yellowl}[GUID CODE: ea00] ${nc}${nc}
        ------------------------------------------------------------------------------------------"
                fi
                NC "


                                      ${bwhite}Press any key to continue${nc}
                "
                read -r -s -n 1

                if [[ "${espmnt}" == "2" ]]; then
                    until slct_espmnt; do : ; done
                fi
                if [[ "${xbootprt}" == "fail" ]]; then
                    until manual_part; do : ; done
                fi
            elif [[ "${espprt}" == "fail" && ! -e "${esp_dev}" ]]; then
                reload
                until manual_part; do : ; done
            elif [[ "${homeprt}" == "fail" || "${swapprt}" == "fail" ]]; then
                reload
                until manual_part; do : ; done
            fi
        elif [[ "${multibooting}" == "n" ]]; then
            if [[ "${smartpart}" == "n" && -z "${preset}" ]] ; then
                process
                until manual_part; do : ; done
            elif [[ "${smartpart}" == "n" && -n "${preset}" ]] ; then
                local stage_prompt="Partitioning"
                line2
                stage_fail
            else
                process
                until auto_part; do : ; done
            fi
        fi
    fi
}
###################################################################################################
ask_crypt() {

        local prompt="Encryption Setup"
        sleep 0.2
        NC "


${magenta}###${nc}------------------------------------${magenta}[ ${bwhite}Encryption  Setup${nc} ${magenta}]${nc}------------------------------------${magenta}###
        "
        BLUE "

        >  Enable${nc} ${cyan}${roottype} ${blue}Encryption? [LUKS] 
        ### Abodin ga pake enkripsi sih, jadi ketik ${cyan}No${blue} aja biar gak ribet"
        NC "

            * ketik '${cyan}no${nc}' buat ga pake enkripsi

            * ketik '${cyan}yes${nc}' buat enkripsi ${roottype}
        "
        read -r -p "
==> " encrypt
        echo

    if [[ "${encrypt}" == "no" ]]; then
        skip
        ok
        line2
        return 0
    elif [[ "${encrypt}" == "yes" ]]; then
        if [[ "${bootloader}" == "2" && "${espmnt}" == "1" ]]; then
            sleep 0.2
            RED "
        -----------------------------------------
        ###  ${yellow}Incompatible Selection detected  ${red}###
        -----------------------------------------"
            YELLOW "

        ###  ESP cannot be mounted at ${nc}'/efi' ${yellow}when using Grub on a LUKS encrypted Root partition


        >  Change ESP mountpoint to ${nc}'/boot' ${yellow}instead ? [Y/n] "
            BLUE "


Enter [Y/n]: "
            read -r -p "
==> " cng_espmnt

            echo
            cng_espmnt="${cng_espmnt:-y}"
            cng_espmnt="${cng_espmnt,,}"

            if [[ "${cng_espmnt}" == "y" ]]; then
                espmnt="2"
                esp_mount="/mnt/boot"
                btldr_esp_mount="/boot"
                sleep 0.2
                YELLOW "

        ###  '/mnt/boot' mountpoint has been selected

                "
            elif [[ "${cng_espmnt}" == "n" ]]; then
                failure
            else
                y_n
                return 1
            fi
        fi
        sleep 0.2
        YELLOW "
        >  Enter a name for your Encrypted ${roottype} Partition: "
        BLUE "


Enter a name: "
        read -r -p "
==> " ENCROOT
        echo

        if [[ -z "${ENCROOT}" ]]; then
            sleep 0.2
            RED "
        -----------------------------------------
        ###  ${yellow}Please enter a name to continue  ${red}###
        -----------------------------------------"
            reload
            return 1
        elif [[ "${ENCROOT}" =~ [[:upper:]] ]]; then
            sleep 0.2
            RED "
        ------------------------------------------------------
        ###  ${yellow}Uppercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
            reload
            return 1
        elif [[ -n "${ENCROOT}" ]]; then
            sleep 0.2
            NC "

==> [${green}Encrypted ${roottype} Label OK${nc}] "
        fi

        if [[ -e "${home_dev}" ]]; then
            if [[ "${sep_home}" == "y" ]]; then
                sleep 0.2
                YELLOW "


        ###  A /Home Partition has been detected "
                sleep 0.2
                BLUE "


        >  Encrypt${nc} ${nc}/Home ${blue}partition? [LUKS] "
                NC "

            * Type '${cyan}no${nc}' to proceed without encryption

            * Type '${cyan}yes${nc}' to encrypt your /Home
                "
                read -r -p "
==> " homecrypt
                echo

                if [[ "${homecrypt}" == "no" ]]; then
                    skip
                elif [[ "${homecrypt}" == "yes" ]]; then
                    sleep 0.2
                    YELLOW "
        >  Enter a name for your Encrypted /Home Partition: "
                    BLUE "


Enter a name: "
                    read -r -p "
==> " ENCRHOME

                    echo
                    if [[ -z "${ENCRHOME}" ]]; then
                        sleep 0.2
                        RED "
        -----------------------------------------
        ###  ${yellow}Please enter a name to continue  ${red}###
        -----------------------------------------"
                        reload
                        return 1
                    elif [[ "${ENCRHOME}" =~ [[:upper:]] ]]; then
                        sleep 0.2
                        RED "
        ------------------------------------------------------
        ###  ${yellow}Uppercase is not allowed. Please try again..  ${red}###
        ------------------------------------------------------"
                        reload
                        return 1
                    elif [[ -n "${ENCRHOME}" ]]; then
                        sleep 0.2
                        NC "

==> [${green}Encrypted /Home Label OK${nc}] "
                    fi
                else
                    yes_no
                    return 1
                fi
            fi
        fi
        ok
    else
        yes_no
        return 1
    fi
}
###################################################################################################
instl() {

        install="yes"
    if [[ -z "${lcl_slct}" ]]; then
        if [[ -e /usr/bin/pv ]]; then
            sleep 0.2
            CYAN "


        (*) ${nc}Please complete ${yellowl}'Locale & Keyboard Layout Selection'${nc} to continue
            "| pv -qL 70
        else
            sleep 0.2
            CYAN "


        (*) ${nc}Please complete ${yellowl}'Locale & Keyboard Layout Selection'${nc} to continue
            "
        fi
        until slct_locale; do : ; done
        until slct_kbd; do : ; done
    fi

    if [[ -z "${USERNAME}" ]]; then
        local stage_prompt="User, Root User & Hostname Setup"
        completion_err
        until user_setup; do : ; done
        until rootuser_setup; do : ; done
        until slct_hostname; do : ; done
    fi

    if [[ -z "${kernelnmbr}" ]]; then
        local stage_prompt="Kernel, Secureboot Signing, Bootloader & ESP Mountpoint"
        completion_err
        until slct_krnl; do : ; done
        until ask_sign; do : ; done
        until ask_bootldr; do : ; done
        until slct_espmnt; do : ; done
    fi

    if [[ -z "${fs}" ]]; then
        local stage_prompt="Filesystem & Swap Setup"
        completion_err
        until ask_fs; do : ; done
        until ask_swap; do : ; done
    fi

    if [[ "${hypervisor}" == "none" && "${vga_slct}" != "yes" ]]; then
        local stage_prompt="Graphics Setup"
        completion_err
        until dtct_vga; do : ; done
    fi

    if [[ -z "${packages}" ]]; then
        local stage_prompt="Desktop Setup"
        completion_err
        until slct_dsktp; do : ; done
    fi

    if [[ "${hypervisor}" == "none" ]]; then
        if [[ -z "${efi_entr_del}" ]]; then
            local stage_prompt="EFI Boot Entries Deletion"
            completion_err
            until boot_entr; do : ; done
        fi
    fi

    if [[ "${hypervisor}" == "none" ]]; then
        if [[ -z "${wrlss_rgd}" ]]; then
            local stage_prompt="Wireless Regulatory Domain Setup"
            completion_err
            until wireless_rgd; do : ; done
        fi
    fi

        until instl_dsk; do : ; done
        until ask_crypt; do : ; done

    if [[ "${swapmode}" == "1" ]]; then
        until "${swaptype}"; do : ; done
    fi

    if [[ "${encrypt}" == "no" ]]; then
        until set_mode; do : ; done
        until confirm_status; do : ; done
    elif [[ "${encrypt}" == "yes" ]]; then
        until sec_erase; do : ; done
        until luks; do : ; done
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
            until wireless_regdom; do : ; done
        fi
        set_vars
        chroot_conf
    fi
}
###################################################################################################
swappart() {

        local stage_prompt="Swap Partition Creation"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Swap  Partition Setup${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
    if mkswap "${swap_dev}" > /dev/null 2> install_log.txt ; then
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
set_mode() {

    if [[ "${rootcount}" -gt "1" || "${espcount}" -gt "1" || "${xbootcount}" -gt "1" || "${homecount}" -gt "1" || "${swapcount}" -gt "1" ]]; then
        until auto_mode; do : ; done
        sleep 0.2
        NC "

==> [${green}Filesystems OK${nc}]
        "
        sleep 0.2
        YELLOW "
###---------------------------------------------[ FILESYSTEM OVERVIEW ]---------------------------------------------###

       "
        lsblk -f|GREP_COLORS='mt=01;36' grep -E --color=always 'vfat|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'ext4|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'btrfs|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'ntfs|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'swap|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        echo
        sleep 0.2
        return 0
    fi

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Mode  Selection${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        YELLOW "

        >  Select a Mode to continue: "
        NC "

            [1]  Auto     (Format otomatis, jangan pake ini kalau Dual boot)

            [2]  Manual   (Format Manual, Butuh Skill, tanya abodin di Discord ae) "
        BLUE "


Pilih nomor: "
        read -r -p "
==> " setmode
        echo

    case "${setmode}" in
        1)
            until auto_mode; do : ; done ;;
        2)
            until manual_mode; do : ; done ;;
       "")
            RED "
        ------------------------------------------
        ###  ${yellow}pilih mode yang bener ngabb  ${red}###
        ------------------------------------------"
            reload
            return 1 ;;
        *)
            invalid
            return 1 ;;
    esac

        sleep 0.2
        NC "

==> [${green}Filesystems OK${nc}]
        "
        sleep 0.2
        YELLOW "
###---------------------------------------------[ FILESYSTEM OVERVIEW ]---------------------------------------------###

               "
        lsblk -f|GREP_COLORS='mt=01;36' grep -E --color=always 'vfat|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'ext4|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'btrfs|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'ntfs|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'swap|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###"
        echo
        sleep 0.2
}
###################################################################################################
auto_mode() {

        espfs="$(lsblk -dno FSTYPE "${esp_dev}")"
        sleep 0.2
        NC "
${magenta}###${nc}----------------------------------------${magenta}[ ${bwhite}Auto Mode${nc} ${magenta}]${nc}----------------------------------------${magenta}###
        "
        sleep 0.2
        YELLOW "

        >  Mode Auto Dipilih

        "
    if [[ "${fs}" == "1" ]]; then
        if mkfs.ext4 -F -L Root "${root_dev}" > /dev/null 2> install_log.txt ; then
            tune2fs -O fast_commit "${root_dev}" > /dev/null 2> install_log.txt || err_abort
            mount "${root_dev}" /mnt > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/Root OK${nc}]
            "
        else
            umount_manual
            until form_root; do : ; done
            until mount_mnt; do : ; done
        fi
#--------------------------------------------------------------------------------------------------
    elif [[ "${fs}" == "2" ]]; then
        if mkfs.btrfs -f -L Root "${root_dev}" > /dev/null 2> install_log.txt ; then
            mount "${root_dev}" /mnt > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@ > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@home > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@cache > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@log > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@tmp > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@snapshots > /dev/null 2> install_log.txt || err_abort
            if [[ "${swapmode}" == "2" ]]; then
                btrfs subvolume create /mnt/@swap > /dev/null 2> install_log.txt || err_abort
            fi
            umount /mnt > /dev/null 2> install_log.txt || err_abort
            mount -o "${sbvl_mnt_opts}",subvol=@ "${root_dev}" /mnt > /dev/null 2> install_log.txt || err_abort
            if [[ "${swapmode}" == "2" ]]; then
                mount --mkdir -o rw,nodatacow,subvol=@swap "${root_dev}" /mnt/swap > /dev/null 2> install_log.txt || err_abort
            fi
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@cache "${root_dev}" /mnt/var/cache > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@home "${root_dev}" /mnt/home > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@log "${root_dev}" /mnt/var/log > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@snapshots "${root_dev}" /mnt/"${snapname}" > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@tmp "${root_dev}" /mnt/var/tmp > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/@ OK${nc}]
            "
        else
            umount_manual
            until form_root; do : ; done
            until mount_mnt; do : ; done
        fi
    fi
        sleep 0.2
#--------------------------------------------------------------------------------------------------
    if [[ "${multibooting}" == "n" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2> install_log.txt ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            umount_manual
            until form_esp; do : ; done
            until mount_mnt; do : ; done
            until mount_esp; do : ; done
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" == "vfat" ]]; then
        if mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2> install_log.txt ; then
            sleep 0.2
            NC "
==> [${green}Unformatted /ESP OK${nc}]
            "
        else
            umount_manual
            until mount_mnt; do : ; done
            until mount_esp; do : ; done
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" != "vfat" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2> install_log.txt ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            umount_manual
            until form_esp; do : ; done
            until mount_mnt; do : ; done
            until mount_esp; do : ; done
        fi
    fi
            sleep 0.2
#--------------------------------------------------------------------------------------------------
        if [[ ${xbootloader} == "yes" ]]; then
            if mkfs.fat -F 32 -n XBOOTLDR "${xboot_dev}" > /dev/null 2> install_log.txt ; then
                mount --mkdir "${xboot_dev}" /mnt/boot > /dev/null 2> install_log.txt || err_abort
                sleep 0.2
                NC "
==> [${green}/XBOOTLDR OK${nc}]
                "
            else
                umount_manual
                until form_xboot; do : ; done
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                until mount_xboot; do : ; done
            fi
        fi
            sleep 0.2
#--------------------------------------------------------------------------------------------------
    if [[ ${fs} == "1" && -e "${home_dev}" && "${sep_home}" == "y" ]]; then
        if [[ "${smartpart}" == "y" ]]; then
            homeform="y"
        elif [[ "${preset}" == "3" || "${preset}" == "4" || "${preset}" == "7" || "${preset}" == "8" ]]; then
            homeform="y"
        elif [[ -z "${smartpart}" ]] || [[ -z "${preset}" ]]; then
            BLUE "


        >  A ${nc}/Home ${blue}partition has been detected. Format as ${nc}${fsname}${blue} ? [y/N]

            "
            read -r -p "
==> " homeform

            echo
            homeform="${homeform:-n}"
            homeform="${homeform,,}"
        fi
                
        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L Home "${home_dev}" > /dev/null 2> install_log.txt ; then
                tune2fs -O fast_commit "${home_dev}" > /dev/null 2> install_log.txt || err_abort
                mount --mkdir "${home_dev}" /mnt/home > /dev/null 2> install_log.txt || err_abort
                sleep 0.2
                NC "
==> [${green}/Home OK${nc}]
                "
            else
                umount_manual
                until manual_part; do : ; done
                until form_home; do : ; done
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                if [[ "${xbootloader}" == "yes" ]]; then
                    until mount_xboot; do : ; done
                fi
                until mount_home; do : ; done
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
        else
            y_n
            until ask_homepart_form; do : ; done
        fi
    fi
}
###################################################################################################
manual_mode() {

        volumes="$(fdisk -l | grep '^/dev' | cat --number)"

        until form_esp; do : ; done
        if [[ "${xbootloader}" == "yes" ]]; then
            until form_xboot; do : ; done
        fi
        until form_root; do : ; done
        if [[ -e "${home_dev}" && "${sep_home}" == "y" ]]; then
            until form_home; do : ; done
        fi
        until mount_mnt; do : ; done
        until mount_esp; do : ; done
        if [[ "${xbootloader}" == "yes" ]]; then
            until mount_xboot; do : ; done
        fi
        if [[ -e "${home_dev}" && "${sep_home}" == "y" ]]; then
            until mount_home; do : ; done
        fi
}
###################################################################################################
form_esp() {

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Format Partisi EFI${nc} ${magenta}]${nc}-------------------------------${magenta}###
        "
        form_esp_nmbr=" "

    while [[ -n "${form_esp_nmbr}" ]]; do
        YELLOW "

        >  Pilih Partisi Efi untuk diformat ke ${nc}vfat


${volumes}"
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_esp_nmbr

    if [[ -n "${form_esp_nmbr}" ]]; then
        esppart="$(echo "${volumes}" | awk "\$1 == ${form_esp_nmbr} {print \$2}")"
        manespfs="$(lsblk -dno FSTYPE "${esppart}")"
        if [[ -e "${esppart}" ]]; then
            if [[ "${multibooting}" == "n" ]]; then
                if mkfs.fat -F 32 -n ESP "${esppart}" > /dev/null 2> install_log.txt ; then
                    sleep 0.2
                    NC "

==> [${green}Format & Label /ESP OK${nc}] "
                    return 0
                else
                    do_umount
                    until manual_part; do : ; done
                    until form_esp; do : ; done
                    return 0
                fi
            elif [[ "${multibooting}" == "y" && "${manespfs}" == "vfat" ]]; then
                sleep 0.2
                NC "

==> [${green}/Unformatted ESP OK${nc}] "
                return 0
            elif [[ "${multibooting}" == "y" && "${manespfs}" != "vfat" ]]; then
                if mkfs.fat -F 32 -n ESP "${esppart}" > /dev/null 2> install_log.txt ; then
                    sleep 0.2
                    NC "

==> [${green}Format & Label /ESP OK${nc}] "
                    return 0
                else
                    do_umount
                    until manual_part; do : ; done
                    until form_esp; do : ; done
                    return 0
                fi
            fi
        else
            invalid
            return 1
        fi
    fi
        RED "
        ---------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
        sleep 2
        skip
    done
}
###################################################################################################
form_xboot() {

        sleep 0.2
        NC "


${magenta}###${nc}--------------------------${magenta}[ ${bwhite}Format  Linux Extended Boot Partition${nc} ${magenta}]${nc}--------------------------${magenta}###
        "
        form_xboot_nmbr=" "

    while [[ -n "${form_xboot_nmbr}" ]]; do
        YELLOW "

        >  Select a Linux Extended Boot Partition to format as ${nc}vfat


${volumes}"
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_xboot_nmbr

    if [[ -n "${form_xboot_nmbr}" ]]; then
        xbootpart="$(echo "${volumes}" | awk "\$1 == ${form_xboot_nmbr} {print \$2}")"
        if [[ -e "${xbootpart}" ]]; then
            if mkfs.fat -F 32 -n XBOOTLDR "${xbootpart}" > /dev/null 2> install_log.txt ; then
                sleep 0.2
                NC "

==> [${green}Format & Label /XBOOTLDR OK${nc}] "
                return 0
            else
                do_umount
                until manual_part; do : ; done
                until form_xboot; do : ; done
                return 0
            fi
        else
            invalid
            return 1
        fi
    fi
        RED "
        ---------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
        sleep 2
        skip
    done
}
###################################################################################################
form_root() {

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Format Root Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        form_root_nmbr=" "

    while [[ -n "${form_root_nmbr}" ]]; do
        YELLOW "

        >  Select a ${roottype} Partition to format as ${nc}${fsname}


${volumes}"
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_root_nmbr

    if [[ -n "${form_root_nmbr}" ]]; then
        rootpart="$(echo "${volumes}" | awk "\$1 == ${form_root_nmbr} {print \$2}")"
        if [[ -e "${rootpart}" ]]; then
#--------------------------------------------------------------------------------------------------
            if [[ "${fs}" == "1" ]]; then
                if mkfs.ext4 -F "${rootpart}" > /dev/null 2> install_log.txt ; then
                    tune2fs -O fast_commit "${rootpart}" > /dev/null 2> install_log.txt || err_abort
                    sleep 0.2
                    NC "


==> [${green}Format ${roottype} OK${nc}] "
                else
                    do_umount
                    until manual_part; do : ; done
                    until form_root; do : ; done
                    return 0
                fi
#--------------------------------------------------------------------------------------------------
            elif [[ "${fs}" == "2" ]]; then
                if mkfs.btrfs -f "${rootpart}" > /dev/null 2> install_log.txt ; then
                    mount "${rootpart}" /mnt > /dev/null 2> install_log.txt || err_abort
                    btrfs subvolume create /mnt/@ > /dev/null 2> install_log.txt || err_abort
                    btrfs subvolume create /mnt/@home > /dev/null 2> install_log.txt || err_abort
                    btrfs subvolume create /mnt/@cache > /dev/null 2> install_log.txt || err_abort
                    btrfs subvolume create /mnt/@log > /dev/null 2> install_log.txt || err_abort
                    btrfs subvolume create /mnt/@tmp > /dev/null 2> install_log.txt || err_abort
                    btrfs subvolume create /mnt/@snapshots > /dev/null 2> install_log.txt || err_abort
                    if [[ "${swapmode}" == "2" ]]; then
                        btrfs subvolume create /mnt/@swap > /dev/null 2> install_log.txt || err_abort
                    fi
                    umount /mnt > /dev/null 2> install_log.txt || err_abort
                    sleep 0.2
                    NC "


==> [${green}Format ${roottype} OK${nc}] "
                else
                    do_umount
                    until manual_part; do : ; done
                    until form_root; do : ; done
                    return 0
                fi
            fi
        else
            invalid
            return 1
        fi

            YELLOW "

        >  Label the ${roottype} Partition "
            BLUE "


Enter a name ${bwhite}(empty to skip and proceed)${blue}: "
            read -r -p "
==> " rootpartname

        if [[ -n "${rootpartname}" ]]; then
            if [[ "${fs}" == "1" ]]; then
                if e2label "${rootpart}" "${rootpartname}" > /dev/null 2> install_log.txt ; then
                    sleep 0.2
                    NC "

==> [${green}Label ${roottype} OK${nc}] "
                    return 0
                else
                    err_try
                    return 1
                fi
            elif [[ "${fs}" == "2" ]]; then
                mount "${rootpart}" /mnt || err_abort
                btrfs filesystem label /mnt "${rootpartname}" > /dev/null 2> install_log.txt || err_abort
                umount /mnt || err_abort
                sleep 0.2
                NC "

==> [${green}Label ${roottype} OK${nc}] "
                return 0
            fi
        fi
        skip
        return 0
    else
        RED "
        ---------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
        sleep 2
        skip
        return 0
    fi
    done
}
###################################################################################################
ask_homepart_form() {

    if [[ ${fs} == "1" && -e "${home_dev}" && "${sep_home}" == "y" ]]; then
        if [[ "${smartpart}" == "y" ]]; then
            homeform="y"
        elif [[ "${preset}" == "3" || "${preset}" == "4" || "${preset}" == "7" || "${preset}" == "8" ]]; then
            homeform="y"
        elif [[ -z "${smartpart}" ]] || [[ -z "${preset}" ]]; then
            BLUE "


        >  A${nc} ${cyan}/Home ${blue}partition has been detected. Format as ${nc}${fsname}${blue} ? [y/N]

            "
            read -r -p "
==> " homeform

            echo
            homeform="${homeform:-n}"
            homeform="${homeform,,}"
        fi
                
        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L Home "${home_dev}" > /dev/null 2> install_log.txt ; then
                tune2fs -O fast_commit "${home_dev}" > /dev/null 2> install_log.txt || err_abort
                mount --mkdir "${home_dev}" /mnt/home > /dev/null 2> install_log.txt || err_abort
                sleep 0.2
                NC "
==> [${green}/Home OK${nc}]
                "
            else
                umount_manual
                until manual_part; do : ; done
                until form_home; do : ; done
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                if [[ "${xbootloader}" == "yes" ]]; then
                    until mount_xboot; do : ; done
                fi
                until mount_home; do : ; done
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
        else
            y_n
            return 1
        fi
    fi
}
###################################################################################################
form_home() {

        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Format Home Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        form_home_nmbr=" "

    while [[ -n "${form_home_nmbr}" ]]; do
        YELLOW "

        >  Select a /Home Partition to format as ${nc}Ext4



${volumes} "
        BLUE "


Enter a partition number ${bwhite}(empty to skip and proceed)${blue}: "
        read -r -p "
==> " form_home_nmbr

        if [[ -n "${form_home_nmbr}" ]]; then
            homepart="$(echo "${volumes}" | awk "\$1 == ${form_home_nmbr} {print \$2}")"
            if [[ -e "${homepart}" ]]; then
                if mkfs.ext4 -F "${homepart}" > /dev/null 2> install_log.txt ; then
                    tune2fs -O fast_commit "${homepart}" > /dev/null 2> install_log.txt || err_abort
                    sleep 0.2
                    NC "


==> [${green}Format /Home OK${nc}] "
                else
                    do_umount
                    until manual_part; do : ; done
                    until form_home; do : ; done
                    return 0
                fi
            else
                invalid
                return 1
            fi
            YELLOW "

        >  Label the /Home Partition "
            BLUE "


Enter a name ${bwhite}(empty to skip and proceed)${blue}: "
            read -r -p "
==> " homepartname

            if [[ -n "${homepartname}" ]]; then
                if e2label "${homepart}" "${homepartname}" > /dev/null 2> install_log.txt ;then
                    sleep 0.2
                    NC "

==> [${green}Label /Home OK${nc}] "
                    return 0
                else
                    err_try
                    return 1
                fi
            fi
            skip
            return 0
        else
            RED "
        ---------------------------------------------------
        ###  ${yellowl}WARNING: ${nc}${yellow}PARTITION HAS NOT BEEN FORMATTED  ${red}###
        ---------------------------------------------------"
            skip
            return 0
        fi
    done
}
###################################################################################################
mount_mnt() {

        local prompt="Mount ${roottype}"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Mount  Root Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        YELLOW "

        >  Select a ${roottype} Partition to mount to ${nc}/mnt



${volumes} "
        BLUE "


Enter your${nc} ${cyan}${roottype} ${blue}partition number: "
        read -r -p "
==> " mntroot_nmbr
        echo

    if [[ -n "${mntroot_nmbr}" ]]; then
        rootpart="$(echo "${volumes}" | awk "\$1 == ${mntroot_nmbr} {print \$2}")"
        if [[ -e "${rootpart}" ]]; then
#--------------------------------------------------------------------------------------------------
            if [[ "${fs}" == "1" ]]; then
                if mount "${rootpart}" /mnt > /dev/null 2> install_log.txt ; then
                    sleep 0.2
                    ok
                    return 0
                else
                    do_umount
                    until mount_mnt; do : ; done
                fi                		
#--------------------------------------------------------------------------------------------------
            elif [[ "${fs}" == "2" ]]; then
                if mount -o "${sbvl_mnt_opts}",subvol=@ "${rootpart}" /mnt > /dev/null 2> install_log.txt ; then
                    if [[ "${swapmode}" == "2" ]]; then
                        mount --mkdir -o rw,nodatacow,subvol=@swap "${rootpart}" /mnt/swap > /dev/null 2> install_log.txt || err_abort
                    fi
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@cache "${rootpart}" /mnt/var/cache > /dev/null 2> install_log.txt || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@home "${rootpart}" /mnt/home > /dev/null 2> install_log.txt || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@log "${rootpart}" /mnt/var/log > /dev/null 2> install_log.txt || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@snapshots "${rootpart}" /mnt/"${snapname}" > /dev/null 2> install_log.txt || err_abort
                    mount --mkdir -o "${sbvl_mnt_opts}",subvol=@tmp "${rootpart}" /mnt/var/tmp > /dev/null 2> install_log.txt || err_abort
                    sleep 0.2
                    ok
                    return 0
                else
                    do_umount
                    until mount_mnt; do : ; done
                fi
            fi
#--------------------------------------------------------------------------------------------------
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
mount_esp() {

        local prompt="Mount ESP"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Mount ESP Partition${nc} ${magenta}]${nc}-----------------------------------${magenta}###
        "
        YELLOW "

        >  Select an EFI System Partition to mount to ${nc}${esp_mount}



${volumes}"
        BLUE "


Enter your${nc} ${cyan}/ESP ${blue}partition number: "
        read -r -p "
==> " mntesp_nmbr
        echo

    if [[ -n "${mntesp_nmbr}" ]]; then
        esppart="$(echo "${volumes}" | awk "\$1 == ${mntesp_nmbr} {print \$2}")"
        if [[ -e "${esppart}" ]]; then
            if mount --mkdir "${esppart}" "${esp_mount}" > /dev/null 2> install_log.txt ; then
                ok
                return 0
            else
                do_umount
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
            fi
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
mount_xboot() {

        local prompt="Mount XBOOTLDR"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Mount XBOOTLDR  Partition${nc} ${magenta}]${nc}--------------------------------${magenta}###
        "
        YELLOW "

        >  Select a Linux Extended Boot Partition to mount to ${nc}/mnt/boot



${volumes}"
        BLUE "


Enter your${nc} ${cyan}/XBOOTLDR ${blue}partition number: "
        read -r -p "
==> " mntxboot_nmbr
        echo

    if [[ -n "${mntxboot_nmbr}" ]]; then
        xbootpart="$(echo "${volumes}" | awk "\$1 == ${mntxboot_nmbr} {print \$2}")"
        if [[ -e "${xbootpart}" ]]; then
            if mount --mkdir "${xbootpart}" /mnt/boot > /dev/null 2> install_log.txt ; then
                ok
                return 0
            else
                do_umount
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                until mount_xboot; do : ; done
            fi
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
mount_home() {

        local prompt="Mount /Home"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Mount  Home Partition${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
        YELLOW "

        >  Select a /Home Partition to mount to ${nc}/mnt/home



${volumes}"
        BLUE "


Enter your${nc} ${cyan}/Home ${blue}partition number: "
        read -r -p "
==> " mnthome_nmbr
        echo

    if [[ -n "${mnthome_nmbr}" ]]; then
        homepart="$(echo "${volumes}" | awk "\$1 == ${mnthome_nmbr} {print \$2}")"
        if [[ -e "${homepart}" ]]; then
            if mount --mkdir "${homepart}" /mnt/home > /dev/null 2> install_log.txt ; then
                ok
                return 0
            else
                do_umount
                until mount_mnt; do : ; done
                until mount_esp; do : ; done
                until mount_xboot; do : ; done
                until mount_home; do : ; done
            fi
        else
            invalid
            return 1
        fi
    else
        choice
        return 1
    fi
}
###################################################################################################
confirm_status() {

        local prompt="System Ready"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------${magenta}[ ${bwhite}Konfirmasi Instalasi${nc} ${magenta}]${nc}-------------------------------${magenta}###
        "
        BLUE "

        >  Lanjut ? "
        NC "

            * Ketik '${cyan}yes${nc}' buat lanjut

            * Ketik '${cyan}no${nc}' Kembali lagi (benerin kalau ga pas)

        "
        read -r -p "
==> " agree

    if [[ "${agree}" == "yes" ]]; then
        ok
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
        until wireless_regdom; do : ; done
        fi
        set_vars
        chroot_conf
    elif [[ "${agree}" == "no" ]]; then
        unmount
        until revise; do : ; done
    else
        yes_no
        return 1
    fi
}
###################################################################################################
revise() {

        revision="yes"
        reset=(xbootloader="" vgaconf="" vendor_slct="" vendor="" packages="" custompkgs="" customservices="" cust_bootopts="" REGDOM="" preset="" autoroot="" autoxboot="" autohome="" autoswap="" vendors="" lowlat="" vendors="" nogsp="")
        export "${reset[@]}"
        gfxpkgs=()

    if [[ "${hypervisor}" != "none" ]]; then
        vm
        vendor="Virtual Machine"
        vgaconf="n"
    fi
        until slct_krnl; do : ; done
        until ask_sign; do : ; done
        until ask_bootldr; do : ; done
        until slct_espmnt; do : ; done
        until ask_fs; do : ; done
        until ask_swap; do : ; done
    if [[ "${hypervisor}" == "none" ]]; then
        until dtct_vga; do : ; done
    fi
        until slct_dsktp; do : ; done
    if [[ "${hypervisor}" == "none" ]]; then
        until boot_entr; do : ; done
        until wireless_rgd; do : ; done
    fi
        until instl_dsk; do : ; done
        until ask_crypt; do : ; done
    if [[ "${swapmode}" == "1" ]]; then 
        until "${swaptype}"; do : ; done
    fi      
    if [[ "${encrypt}" == "no" ]]; then
        until set_mode; do : ; done
        until confirm_status; do : ; done
    elif [[ "${encrypt}" == "yes" ]]; then
        until sec_erase; do : ; done
        until luks; do : ; done
        until opt_pcmn; do : ; done
        until pacstrap_system; do : ; done
        if [[ "${swapmode}" == "2" ]]; then
            until "${swaptype}"; do : ; done
        fi
        if [[ -n "${REGDOM}" ]]; then
            until wireless_regdom; do : ; done
        fi
        set_vars
        chroot_conf
    fi
}
###################################################################################################
sec_erase() {

        local prompt="Secure Erasure"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Secure Disk Erasure${nc} ${magenta}]${nc}-----------------------------------${magenta}###
        "
        erase_dsk_nmbr=" "

    while [[ -n "${erase_dsk_nmbr}" ]]; do
        YELLOW "

        >  Select a disk for Secure Erasure  ${red}[!] (CAUTION) [!]${yellow} "
        RED "
        --------------------------------------------------------------------------
        ###  ${yellow}A reboot is ${nc}mandatory ${yellow}and will take effect ${nc}immediately ${yellow}when done  ${red}###
        --------------------------------------------------------------------------"
        NC "


${disks}"
        BLUE "


Enter a disk number ${bwhite}(empty to skip)${blue}: "
        read -r -p "
==> " erase_dsk_nmbr
        echo

        if [[ -n "${erase_dsk_nmbr}" ]]; then
            erasedrive="$(echo "${disks}" | awk "\$1 == ${erase_dsk_nmbr} {print \$2}")"
            if [[ -e "${erasedrive}" ]]; then
                cryptsetup open --type plain -d /dev/urandom "${erasedrive}" temp || err_abort
                dd if=/dev/zero of=/dev/mapper/temp status=progress bs=1M oflag=direct || err_abort
                cryptsetup close temp || err_abort
                sleep 0.2
                NC "

==> [${green}Drive ${erasedrive} Erased OK${nc}] "

                sleep 0.2
                NC "

==> [${green}Rebooting${nc}] "
                sleep 1
                reboot
            else
                invalid
                return 1
            fi
        else
            skip
            ok
        fi
    done
}
###################################################################################################
luks() {

        espfs="$(lsblk -f --noheadings "${esp_dev}" | awk "{print \$2}")"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}LUKS Encryption${nc} ${magenta}]${nc}-------------------------------------${magenta}###



        "
    if cryptsetup -y -v luksFormat --label CRYPTROOT "${root_dev}"; then
        if [[ "${rota}" == "0" ]]; then
            cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${root_dev}" "${ENCROOT}" || err_abort
        else
            cryptsetup luksOpen "${root_dev}" "${ENCROOT}" || err_abort
        fi
#------------------------------------------------------------------------------------------
        if [[ "${fs}" == "1" ]]; then
            mkfs.ext4 -F -L Root /dev/mapper/"${ENCROOT}" > /dev/null 2> install_log.txt || err_abort
            tune2fs -O fast_commit /dev/mapper/"${ENCROOT}" > /dev/null 2> install_log.txt || err_abort
            mount /dev/mapper/"${ENCROOT}" /mnt > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /Root OK${nc}]
            "
            luks_root="ok"
#------------------------------------------------------------------------------------------
        elif [[ "${fs}" == "2" ]]; then
            mkfs.btrfs -f -L Root /dev/mapper/"${ENCROOT}" > /dev/null 2> install_log.txt || err_abort
            mount /dev/mapper/"${ENCROOT}" /mnt > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@ > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@home > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@cache > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@log > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@snapshots > /dev/null 2> install_log.txt || err_abort
            btrfs subvolume create /mnt/@tmp > /dev/null 2> install_log.txt || err_abort
            if [[ "${swapmode}" == "2" ]]; then
                btrfs subvolume create /mnt/@swap > /dev/null 2> install_log.txt || err_abort
            fi
            umount /mnt > /dev/null 2> install_log.txt || err_abort
            mount -o "${sbvl_mnt_opts}",subvol=@ /dev/mapper/"${ENCROOT}" /mnt > /dev/null 2> install_log.txt || err_abort
            if [[ "${swapmode}" == "2" ]]; then
                mount --mkdir -o rw,nodatacow,subvol=@swap /dev/mapper/"${ENCROOT}" /mnt/swap > /dev/null 2> install_log.txt || err_abort
            fi
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@cache /dev/mapper/"${ENCROOT}" /mnt/var/cache > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@home /dev/mapper/"${ENCROOT}" /mnt/home > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@log /dev/mapper/"${ENCROOT}" /mnt/var/log > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@snapshots /dev/mapper/"${ENCROOT}" /mnt/"${snapname}" > /dev/null 2> install_log.txt || err_abort
            mount --mkdir -o "${sbvl_mnt_opts}",subvol=@tmp /dev/mapper/"${ENCROOT}" /mnt/var/tmp > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /@ OK${nc}]
            "
            luks_root="ok"
        fi
    else
        line2
        err_try
        do_umount
        return 1
    fi
#--------------------------------------------------------------------------------------------------
    if [[ -e "${swap_dev}" && "${swapmode}" == "1" ]]; then
        line2
        if cryptsetup -y -v luksFormat --label CRYPTSWAP "${swap_dev}"; then
            if [[ "${rota}" == "0" ]]; then
                cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${swap_dev}" swap || err_abort
            else
                cryptsetup luksOpen "${swap_dev}" swap || err_abort
            fi
            mkswap /dev/mapper/swap > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /Swap OK${nc}]
            "
            luks_swap="ok"
        else
            line2
            err_try
            do_umount
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
    if [[ "${homecrypt}" == "yes" ]]; then
        line2
        if cryptsetup -y -v luksFormat --label CRYPTHOME "${home_dev}"; then
            if [[ "${rota}" == "0" ]]; then
                cryptsetup --perf-no_read_workqueue --perf-no_write_workqueue --persistent luksOpen "${home_dev}" "${ENCRHOME}" || err_abort
            else
                cryptsetup luksOpen "${home_dev}" "${ENCRHOME}" || err_abort
            fi
            mkfs.ext4 -F -L Home /dev/mapper/"${ENCRHOME}" > /dev/null 2> install_log.txt || err_abort
            tune2fs -O fast_commit /dev/mapper/"${ENCRHOME}" > /dev/null 2> install_log.txt || err_abort
            mount --mkdir /dev/mapper/"${ENCRHOME}" /mnt/home > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}Encrypted /Home OK${nc}]
            "
            luks_home="ok"
        else
            line2
            err_try
            do_umount
            return 1
        fi
    elif [[ "${homecrypt}" == "no" ]]; then
        BLUE "

        >  A ${nc}/Home ${blue}partition has been detected. Format as${nc} ${fsname}${blue}? [y/N]

        "
        read -r -p "
==> " homeform

        echo
        homeform="${homeform:-n}"
        homeform="${homeform,,}"

        if [[ "${homeform}" == "y" ]]; then
            if mkfs.ext4 -F -L Home "${home_dev}" > /dev/null 2> install_log.txt ; then
                tune2fs -O fast_commit "${home_dev}" > /dev/null 2> install_log.txt || err_abort
                mount --mkdir "${home_dev}" /mnt/home > /dev/null 2> install_log.txt || err_abort
                sleep 0.2
                NC "
==> [${green}/Home OK${nc}]
                "
            else
                line2
                err_try
                do_umount
                return 1
            fi
        elif [[ "${homeform}" == "n" ]]; then
            skip
        else
            y_n
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
    if [[ "${multibooting}" == "n" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2> install_log.txt ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            do_umount
            until luks; do : ; done
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" == "vfat" ]]; then
        if mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2> install_log.txt ; then
            sleep 0.2
            NC "
==> [${green}Unformatted /ESP OK${nc}]
            "
        else
            line2
            err_try
            do_umount
            return 1
        fi
    elif [[ "${multibooting}" == "y" && "${espfs}" != "vfat" ]]; then
        if mkfs.fat -F 32 -n ESP "${esp_dev}" > /dev/null 2> install_log.txt ; then
            mount --mkdir "${esp_dev}" "${esp_mount}" > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/ESP OK${nc}]
            "
        else
            do_umount
            until luks; do : ; done
        fi
    fi
#--------------------------------------------------------------------------------------------------    
    if [[ "${xbootloader}" == "yes" ]] ; then
        if mkfs.fat -F 32 -n XBOOTLDR "${xboot_dev}" > /dev/null 2> install_log.txt ; then
            mount --mkdir "${xboot_dev}" /mnt/boot > /dev/null 2> install_log.txt || err_abort
            sleep 0.2
            NC "
==> [${green}/XBOOTLDR OK${nc}]
            "
        else
            line2
            err_try
            do_umount
            return 1
        fi
    fi
#--------------------------------------------------------------------------------------------------
        sleep 0.2
        NC "
==> [${green}Encryption OK${nc}]"
        luks_encrypt="ok"
        sleep 0.2
        NC "

==> [${green}Filesystems OK${nc}]
        "
        sleep 0.2
        YELLOW "
###---------------------------------------------[ FILESYSTEM OVERVIEW ]---------------------------------------------###

        "
        lsblk -f|GREP_COLORS='mt=01;36' grep -E --color=always 'vfat|$'|GREP_COLORS='mt=01;32' grep -E --color=always 'ext4|$'|GREP_COLORS='mt=01;35' grep -E --color=always 'btrfs|$'|GREP_COLORS='mt=01;31' grep -E --color=always 'ntfs|$'|GREP_COLORS='mt=01;33' grep -E --color=always 'swap|$'
        YELLOW "

###-----------------------------------------------------------------------------------------------------------------###
        "
        sleep 0.2
}
###################################################################################################
opt_pcmn() {

        local prompt="PacMan"
        sleep 0.2
        NC "


${magenta}###${nc}-----------------------------------${magenta}[ ${bwhite}Pacman Optimization${nc} ${magenta}]${nc}-----------------------------------${magenta}###
        "
        YELLOW "

        >  Pilih Lokasi Negara untuk Mirror Pacman:
        > Ketik Singapore kalau mau cepet, tapi kalau error default aja



        ###  [Tekan ${nc}'l' ${yellow}untuk daftar negara, kemudian ${nc}'enter' ${yellow}buat cari atau ${nc}'q' ${yellow}buat keluar] "
        BLUE "


Pilih Negara ${bwhite}(Kosongkan untuk  Defaults)${blue}: "
        read -r -p "
==> " COUNTRY
        echo

    if [[ -z "${COUNTRY}" ]] ; then
        sleep 0.2
        NC "

==> [${green}Default Mirrors OK${nc}] "
    elif [[ "${COUNTRY}" == "l" ]]; then
        reflector --list-countries | more
        return 1
    elif [[ -n "${COUNTRY}" ]]; then
        line2
        if reflector --verbose -c "${COUNTRY}" -l 10 -p https -f 10 --sort rate --save /etc/pacman.d/mirrorlist ; then
            sleep 0.2
            NC "

==> [${green}${COUNTRY}'s Mirrors OK${nc}] "
        else
            err_try
            return 1
        fi
    fi
        YELLOW "



        >  Aktifkan Repo ${nc}'Multilib' ${yellow}di sistem (buat jalanin app 32bit), yes aja ?  [Y/n] "
        BLUE "


Pilih [Y/n]: "
        read -r -p "
==> " multilib

        echo
        multilib="${multilib:-y}"
        multilib="${multilib,,}"

    if [[ "${multilib}" == "y" ]]; then
        sleep 0.2
        NC "

==> [${green}Multilib repository OK${nc}]"
    elif [[ "${multilib}" == "n" ]]; then
        skip
    else
        y_n
        return 1
    fi
        ok
}
###################################################################################################
pacstrap_system() {

        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Pacstrap System${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
        cnfg
        gfxpkgs_set

    if [[ "${bootloader}" == "2" ]]; then
        if [[ "${fs}" == "1" ]]; then
            bootldr_pkgs="grub os-prober"
        elif [[ "${fs}" == "2" ]]; then
            bootldr_pkgs="grub-btrfs os-prober"
        fi
    fi

        basepkgs=(base efibootmgr nano pkgstats sudo vim mkinitcpio fish "${fstools}" "${kernel}" "${microcode}")

    if [[ "${vendor}" == "Virtual Machine" ]]; then
        basepkgs+=("${vmpkgs}")
    else
        basepkgs+=(linux-firmware sof-firmware)
    fi
    if [[ -n "${bootldr_pkgs}" ]]; then
        basepkgs+=("${bootldr_pkgs}")
    fi
    if [[ -n "${ukify}" ]]; then
        basepkgs+=("${ukify}")
    fi
    if [[ -n "${zram}" ]]; then
        basepkgs+=("${zram}")
    fi
    if [[ -n "${gfxpkgs[*]}" ]]; then
        basepkgs+=("${gfxpkgs[*]}")
    fi
    if [[ "${vendor}" == "Nvidia" ]]; then
        basepkgs+=("${kernel}-headers")
    fi
    if [[ -n "${devel}" ]]; then
        basepkgs+=("${devel}")
    fi
    if [[ -n "${wireless_reg}" ]]; then
        basepkgs+=("${wireless_reg}")
    fi

    case "${packages}" in

        1)  # Plasma Desktop:
            deskpkgs="${basepkgs[*]} plasma dolphin-plugins konsole"
            displaymanager="sddm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

        2)  # Minimal Plasma + Apps:
            deskpkgs="${basepkgs[*]} alsa-firmware alsa-utils arj ark bluedevil breeze-gtk ccache cups-pdf cups-pk-helper dolphin-plugins exfatprogs fdkaac ffmpegthumbs git glibc-locales gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb kamera kamoso kate kcalc kde-gtk-config kdegraphics-mobipocket kdegraphics-thumbnailers kdenetwork-filesharing kdeplasma-addons kdesdk-kio kdesdk-thumbnailers kdialog keditbookmarks kget kimageformats kinit kio-admin kio-gdrive kio-zeroconf kompare konsole kscreen kvantum kwrited libappimage libfido2 libktorrent libmms libnfs libva-utils lirc lrzip lua52-socket lzop mac man-db man-pages mesa-demos mesa-utils mold nano-syntax-highlighting nss-mdns ntfs-3g okular opus-tools p7zip packagekit-qt6 pacman-contrib partitionmanager pbzip2 pigz pipewire-alsa pipewire-jack pipewire-pulse plasma-browser-integration plasma-desktop plasma-disks plasma-firewall plasma-nm plasma-pa plasma-wayland-protocols power-profiles-daemon powerdevil powerline powerline-fonts print-manager python-pyqt6 python-reportlab qbittorrent qt6-imageformats qt6-scxml qt6-virtualkeyboard realtime-privileges reflector rng-tools sddm-kcm skanlite sof-firmware sox spectacle sshfs system-config-printer terminus-font timidity++ ttf-ubuntu-font-family unarchiver unrar unzip usb_modeswitch usbutils vdpauinfo vlc vorbis-tools wget xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-kde zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting ${nrg_plc}" ;;

        3)  # Gnome Desktop:
            deskpkgs="${basepkgs[*]} gnome networkmanager"
            displaymanager="gdm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

        4)  # Minimal Gnome + Apps:
            deskpkgs="${basepkgs[*]} dconf-editor evince file-roller gdm gnome-calculator gnome-clocks gnome-connections gnome-console gnome-control-center gnome-disk-utility gnome-keyring gnome-menus gnome-remote-desktop gnome-session gnome-shell-extensions gnome-system-monitor gnome-text-editor gnome-tweaks gnome-user-share gvfs gvfs-afc gvfs-mtp loupe malcontent nautilus networkmanager power-profiles-daemon simple-scan sushi system-config-printer xdg-desktop-portal-gnome xdg-user-dirs-gtk alsa-firmware alsa-utils ccache cups-pdf exfatprogs fdkaac git glib2-devel glibc-locales gnome-browser-connector gparted gst-libav gst-plugin-libcamera gst-plugin-msdk gst-plugin-opencv gst-plugin-pipewire gst-plugin-qmlgl gst-plugin-va gst-plugin-wpe gst-plugins-ugly gstreamer-vaapi htop icoutils ipp-usb libfido2 libva-utils lrzip mac man-db man-pages meld mesa-utils nano-syntax-highlighting nss-mdns ntfs-3g p7zip pacman-contrib pbzip2 pigz pipewire-alsa pipewire-jack pipewire-pulse powerline powerline-fonts qbittorrent realtime-privileges reflector rng-tools sof-firmware sox terminus-font ttf-ubuntu-font-family unrar unzip usb_modeswitch usbutils vdpauinfo vlc wget zip zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting ${nrg_plc}" ;;
            
        5)  # Xfce Desktop:
            deskpkgs="${basepkgs[*]} xfce4 xdg-user-dirs lightdm-gtk-greeter network-manager-applet"
            displaymanager="lightdm"
            network="NetworkManager" ;;

        6)  # Cinnamon Desktop:
            deskpkgs="${basepkgs[*]} cinnamon blueberry lightdm-slick-greeter system-config-printer gnome-keyring xdg-user-dirs ${terminal}"
            displaymanager="lightdm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

        7)  # Deepin Desktop:
            deskpkgs="${basepkgs[*]} deepin deepin-terminal deepin-kwin networkmanager"
            displaymanager="lightdm"
            network="NetworkManager" ;;

        8)  # Budgie Desktop:
            deskpkgs="${basepkgs[*]} budgie lightdm-gtk-greeter arc-gtk-theme papirus-icon-theme nautilus network-manager-applet xdg-user-dirs ${terminal}"
            displaymanager="lightdm"
            network="NetworkManager" ;;

        9)  # Lxqt Desktop:
            deskpkgs="${basepkgs[*]} lxqt lxqt-wayland-session breeze-icons network-manager-applet sddm xscreensaver"
            displaymanager="sddm"
            network="NetworkManager" ;;

       10)  # Mate Desktop:
            deskpkgs="${basepkgs[*]} mate mate-terminal mate-media blueman network-manager-applet mate-power-manager system-config-printer lightdm-gtk-greeter xdg-user-dirs"
            displaymanager="lightdm"
            bluetooth="bluetooth"
            network="NetworkManager" ;;

       11)  # Base System:
            deskpkgs="${basepkgs[*]} networkmanager"
            network="NetworkManager" ;;

       12)  # Custom System:
            custarray=(base sudo "${custompkgs}" "${fstools}" "${kernel}" "${microcode}")

            if [[ "${vendor}" == "Virtual Machine" ]]; then
                custarray+=("${vmpkgs}")
            else
                custarray+=(linux-firmware)
            fi
            if [[ -n "${bootldr_pkgs}" ]]; then
                custarray+=("${bootldr_pkgs}")
            fi
            if [[ -n "${ukify}" ]]; then
                custarray+=("${ukify}")
            fi
            if [[ -n "${zram}" ]]; then
                custarray+=("${zram}")
            fi
            if [[ -n "${gfxpkgs[*]}" ]]; then
                custarray+=("${gfxpkgs[*]}")
            fi
            if [[ "${greeternmbr}" =~ ^(1|2|3|)$ ]]; then
                custarray+=("${greeter}")
            fi
            if [[ -n "${wireless_reg}" ]]; then
                custarray+=("${wireless_reg}")
            fi
            deskpkgs="${custarray[*]}" ;;

       13)  # Cosmic Desktop:
            deskpkgs="${basepkgs[*]} cosmic networkmanager"
            displaymanager="cosmic-greeter"
            network="NetworkManager" ;;
       14)  # Maomao:
            deskpkgs="${basepkgs[*]} networkmanager"
            displaymanager="ly"
            network="NetworkManager" ;;
    esac
    # TODO: tambahin opsi buat custom uhhh, yes, Hyprland paling, atau Dwm
    # ajah??. idk

        pkg_displ
        NC "



                                     ${bwhite}Tekan Tombol manapun buat lanjut${nc}


        "
        read -r -s -n 1

    if pacstrap -K /mnt ${deskpkgs} ; then
        if [[ "${fs}" == "2"  ]]; then
            genfstab -t PARTUUID /mnt >> /mnt/etc/fstab || err_abort
            sleep 0.2
            NC "

==> [${green}Fstab OK${nc}] "
        fi
        local prompt="Pacstrap System"
        ok
    else
        failure
    fi

    if [[ "${swapmode}" != "2" ]]; then
        line2
    fi
}
###################################################################################################
swapfile() {

        local stage_prompt="Swapfile Creation"
        sleep 0.2
        NC "


${magenta}###${nc}-------------------------------------${magenta}[ ${bwhite}Swapfile  Setup${nc} ${magenta}]${nc}-------------------------------------${magenta}###
        "
    if arch-chroot /mnt <<-SWAPFILE > /dev/null 2>&1 2> install_log.txt ; then
        mkswap -U clear --size ${swapsize}G --file /swapfile || exit
SWAPFILE
        cat >> /mnt/etc/fstab <<-FSTAB || err_abort
			/swapfile none swap defaults 0 0
FSTAB
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
swapfile_btrfs() {

        local stage_prompt="Btrfs Swapfile Creation"
        sleep 0.2
        NC "


${magenta}###${nc}----------------------------------${magenta}[ ${bwhite}Btrfs Swapfile  Setup${nc} ${magenta}]${nc}----------------------------------${magenta}###
        "
    if arch-chroot /mnt <<-SWAPFILE > /dev/null 2>&1 2> install_log.txt ; then
        btrfs filesystem mkswapfile --size ${swapsize}g --uuid clear /swap/swapfile || exit
SWAPFILE
        cat >> /mnt/etc/fstab <<-FSTAB || err_abort
			/swap/swapfile none swap defaults 0 0
FSTAB
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
wireless_regdom() {

        local stage_prompt="Wireless Regulatory Domain"
        sleep 0.2
        NC "


${magenta}###${nc}--------------------------${magenta}[ ${bwhite}Setting Up Wireless Regulatory Domain${nc} ${magenta}]${nc}--------------------------${magenta}###
        "
    if sed -i "/^#WIRELESS_REGDOM=\"${REGDOM}\"/s/^#//" /mnt/etc/conf.d/wireless-regdom ; then
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
main_chroot() {

        local stage_prompt="Base System Configuration"
    if arch-chroot /mnt <<-CONF > /dev/null 2>&1 2> install_log.txt ; then
        sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen || exit
        locale-gen || exit
        echo LANG=${SETLOCALE} > /etc/locale.conf || exit
        export LANG=${SETLOCALE} || exit
        echo KEYMAP=${SETKBD} > /etc/vconsole.conf || exit
        mkdir -p /etc/mkinitcpio.conf.d/
        cat <<-MKINITCPIO > /etc/mkinitcpio.conf.d/mkinitcpiod.conf || exit
			${mkinitcpio_mods}
			${mkinitcpio_hooks}
        MKINITCPIO
        mkinitcpio -P || exit
        ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime || exit
        hwclock --systohc || exit
        echo ${HOSTNAME} > /etc/hostname || exit
        cat <<-HOSTS > /etc/hosts || exit
			127.0.0.1 localhost
			::1 localhost
			127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS
        echo root:${ROOTPASSWD2} | chpasswd || exit
        useradd -m -G wheel -s /bin/bash ${USERNAME} || exit
        echo ${USERNAME}:${USERPASSWD2} | chpasswd || exit
        echo "%wheel ALL=(ALL) ALL" | tee /etc/sudoers.d/sudoersd || exit
        visudo -c /etc/sudoers.d/sudoersd || exit
        chsh --shell /usr/bin/fish ${USERNAME} || exit
CONF
        stage_ok
    else
        stage_fail
    fi
}
###################################################################################################
btldrcfg() {

    if [[ "${bootloader}" == "1" ]]; then
        local stage_prompt="Systemd-boot Configuration"
        if [[ "${xbootloader}" == "no" ]]; then
            if arch-chroot /mnt <<-BOOTCTL > /dev/null 2>&1 2> install_log.txt ; then
                bootctl install || exit
                sed -i "/^#timeout 3/s/^#//" ${btldr_esp_mount}/loader/loader.conf || exit
                systemctl enable systemd-boot-update || exit
BOOTCTL
                stage_ok
            else
                stage_fail
            fi
        elif [[ "${xbootloader}" == "yes" ]]; then
            if arch-chroot /mnt <<-XBOOTCTL > /dev/null 2>&1 2> install_log.txt ; then
                bootctl --esp-path=/efi --boot-path=/boot install || exit
                sed -i "/^#timeout 3/s/^#//" ${btldr_esp_mount}/loader/loader.conf || exit
                systemctl enable systemd-boot-update || exit
XBOOTCTL
                stage_ok
            else
                stage_fail
            fi
        fi
    elif [[ "${bootloader}" == "2" ]]; then
        local stage_prompt="Grub Configuration"
        if arch-chroot /mnt <<-GRUB > /dev/null 2>&1 2> install_log.txt ; then
            cp /etc/default/grub /etc/default/grub.bak || exit
            cat <<-CFG > /etc/default/grub || exit
				GRUB_DEFAULT=0
				GRUB_TIMEOUT=5
				GRUB_DISTRIBUTOR="Arch"
				GRUB_CMDLINE_LINUX_DEFAULT="${boot_opts[*]}"
				GRUB_CMDLINE_LINUX=""
				GRUB_PRELOAD_MODULES="part_gpt part_msdos"
				GRUB_TIMEOUT_STYLE=menu
				GRUB_TERMINAL_INPUT=console
				GRUB_GFXMODE=auto
				GRUB_GFXPAYLOAD_LINUX=keep
				GRUB_DISABLE_RECOVERY=true
				GRUB_DISABLE_OS_PROBER=false
				#GRUB_TERMINAL_OUTPUT=console
CFG
GRUB
            stage_ok
        else
            stage_fail
        fi

        local stage_prompt="Grub Installation"
        if [[ "${sb_sign}" == "y" ]]; then
            if arch-chroot /mnt <<-SBGRUBINST > /dev/null 2>&1 2> install_log.txt ; then
                grub-install --target=${uefimode} --efi-directory=${btldr_esp_mount} --bootloader-id=GRUB --modules="tpm" --disable-shim-lock --recheck || exit
                sed -i 's/SecureBoot/SecureB00t/' ${btldr_esp_mount}/EFI/GRUB/grubx64.efi || exit
                grub-mkconfig -o /boot/grub/grub.cfg || exit
SBGRUBINST
                stage_ok
            else
                stage_fail
            fi
        elif [[ "${sb_sign}" == "n" ]]; then
            if arch-chroot /mnt <<-GRUBINST > /dev/null 2>&1 2> install_log.txt ; then
                grub-install --target=${uefimode} --efi-directory=${btldr_esp_mount} --bootloader-id=GRUB --recheck || exit
                grub-mkconfig -o /boot/grub/grub.cfg || exit
GRUBINST
                stage_ok
            else
                stage_fail
            fi
        fi

        if [[ "${fs}" == "2" ]]; then
            local stage_prompt="Grub-Btrfsd Service Activation"
            if arch-chroot /mnt <<-GRUB_BTRFSD > /dev/null 2>&1 2> install_log.txt ; then
                systemctl enable grub-btrfsd || exit
GRUB_BTRFSD
                stage_ok
            else
                stage_fail
            fi
        fi

        if [[ "${vgaconf}" == "y" && "${vendor}" == "Nvidia" ]]; then
            local stage_prompt="Grub/Nvidia Configuration"
            if arch-chroot /mnt <<-NVGRUB > /dev/null 2>&1 2> install_log.txt ; then
                sed -i "/^#GRUB_TERMINAL_OUTPUT=console/s/^#//" /etc/default/grub || exit
                grub-mkconfig -o /boot/grub/grub.cfg || exit
NVGRUB
                stage_ok
            else
                stage_fail
            fi
        fi
    fi
}
###################################################################################################
trimcfg() {

    if [[ -n "${trim}" ]]; then
        local stage_prompt="Trim Service Activation"
        if arch-chroot /mnt <<-TRIM > /dev/null 2>&1 2> install_log.txt ; then
            systemctl enable ${trim} || exit
TRIM
            stage_ok
        else
            stage_fail
        fi
    fi
}
###################################################################################################
vm_serv() {

    if [[ -n "${vm_services}" ]]; then
        local stage_prompt="VM Service(s) Activation"
        if arch-chroot /mnt <<-VM > /dev/null 2>&1 2> install_log.txt ; then
            systemctl enable ${vm_services} || exit
VM
            stage_ok
        else
            stage_fail
        fi
    fi
}
###################################################################################################
zramcfg() {

    if [[ -n "${zram}" ]]; then
        local stage_prompt="Zram Swap Activation"
        zram_service="systemd-zram-setup@zram0.service"
        if arch-chroot /mnt <<-ZRAMCONF > /dev/null 2>&1 2> install_log.txt ; then
            mkdir -p /etc/systemd/zram-generator.conf.d || exit
            cat <<-ZCONF > /etc/systemd/zram-generator.conf.d/zram.conf || exit
				[zram0]
				zram-size = ram / 2
				compression-algorithm = zstd
ZCONF
            cat <<-VMZCONF > /etc/sysctl.d/99-vm-zram-parameters.conf || exit
				vm.swappiness = 180
				vm.watermark_boost_factor = 0
				vm.watermark_scale_factor = 125
				vm.page-cluster = 0
VMZCONF
            systemctl daemon-reload || exit
            systemctl start ${zram_service} || exit
ZRAMCONF
            stage_ok
        else
            stage_fail
        fi
    fi
}
###################################################################################################
nvidia_hook() {

    if [[ "${vgaconf}" == "y" && "${vendor}" == "Nvidia" ]] || [[ "${vgaconf}" == "y" && "${vendors}" =~ "Nvidia" ]]; then
        if [[ "${nvname}" == "nvidia-open" ]] || [[ "${nvname}" == "nvidia" ]] || [[ "${nvname}" == "nvidia-lts" ]]; then
            local stage_prompt="Nvidia Hook Creation"
            if arch-chroot /mnt <<-NVIDIAHOOK > /dev/null 2>&1 2> install_log.txt ; then
                mkdir -p /etc/pacman.d/hooks/ || exit
                cat <<-HOOK > /etc/pacman.d/hooks/nvidia.hook || exit
					[Trigger]
					Operation=Install
					Operation=Upgrade
					Operation=Remove
					Type=Package
					Target=${nvname}
					Target=${kernel}
					
					[Action]
					Description=Update NVIDIA module in initcpio
					Depends=mkinitcpio
					When=PostTransaction
					NeedsTargets
					Exec=/bin/sh -c 'while read -r trg; do case $trg in linux*) exit 0; esac; done; /usr/bin/mkinitcpio -P'
HOOK
NVIDIAHOOK
                stage_ok
            else
                stage_fail
            fi
        fi
    fi
}
###################################################################################################
mkinitcpio_preset() {

        local stage_prompt="Mkinitcpio Kernel Presets Configuration"

    if [[ "${uki}" == "y" ]]; then
        if [[ ! -e "${esp_mount}"/EFI/Linux ]]; then
            mkdir -p "${esp_mount}"/EFI/Linux || exit
        fi
        if arch-chroot /mnt <<-UKI > /dev/null 2>&1 2> install_log.txt ; then
            mkdir /etc/cmdline.d || exit
            echo "rw ${boot_opts[*]}" | tee /etc/cmdline.d/cmdlined.conf || exit
            cp /etc/mkinitcpio.d/${kernel}.preset /etc/mkinitcpio.d/${kernel}.preset.bak || exit
            cat <<-MKINITPRESET > /etc/mkinitcpio.d/${kernel}.preset || exit
				ALL_config="/etc/mkinitcpio.conf.d/mkinitcpiod.conf"
				ALL_kver="/boot/vmlinuz-${kernel}"
				PRESETS=('default')
				default_uki="${btldr_esp_mount}/EFI/Linux/arch-${kernel}.efi"
MKINITPRESET
           mkinitcpio -P || exit
UKI
            stage_ok
        else
            stage_fail
        fi

        if [[ -e /mnt/boot/initramfs-"${kernel}".img ]]; then
            rm /mnt/boot/initramfs-"${kernel}".img || exit
        fi
        if [[ -e /mnt/boot/initramfs-"${kernel}"-fallback.img ]]; then
            rm /mnt/boot/initramfs-"${kernel}"-fallback.img || exit
        fi

    elif [[ "${uki}" == "n" ]]; then
        if arch-chroot /mnt <<-NOUKI > /dev/null 2>&1 2> install_log.txt ; then
            cp /etc/mkinitcpio.d/${kernel}.preset /etc/mkinitcpio.d/${kernel}.preset.bak || exit
            cat <<-MKINITPRESET > /etc/mkinitcpio.d/${kernel}.preset || exit
				ALL_config="/etc/mkinitcpio.conf.d/mkinitcpiod.conf"
				ALL_kver="/boot/vmlinuz-${kernel}"
				PRESETS=('default')
				default_image="/boot/initramfs-${kernel}.img"
MKINITPRESET
            mkinitcpio -P || exit
NOUKI
            stage_ok
        else
            stage_fail
        fi
    fi
}
###################################################################################################
var_opts() {

    if [[ "${setrescue}" == "y" ]]; then
        local stage_prompt="Rescue Entry Creation"
        if [[ "${bootloader}" == "1" ]]; then
            if arch-chroot /mnt <<-RESCUE > /dev/null 2>&1 2> install_log.txt ; then
                echo "systemd.unit=rescue.target rw ${boot_opts[*]}" | tee /etc/cmdline.d/rescue.conf || exit
                cat <<-PRESET > /etc/mkinitcpio.d/${kernel}.preset || exit
					ALL_config="/etc/mkinitcpio.conf.d/mkinitcpiod.conf"
					ALL_kver="/boot/vmlinuz-${kernel}"
					PRESETS=('default' 'rescue')
					default_uki="${btldr_esp_mount}/EFI/Linux/arch-${kernel}.efi"
					default_options="--cmdline /etc/cmdline.d/cmdlined.conf"
					rescue_uki="${btldr_esp_mount}/EFI/Linux/rescue.efi"
					rescue_options="--cmdline /etc/cmdline.d/rescue.conf"
PRESET
                mkinitcpio -P || exit
RESCUE
                stage_ok
            else
                stage_fail
            fi
        elif [[ "${bootloader}" == "2" ]]; then
            if arch-chroot /mnt <<-RESCUE > /dev/null 2>&1 2> install_log.txt ; then
                touch /boot/grub/custom.cfg
                grep -E -A 11 "'Arch Linux'" /boot/grub/grub.cfg > /boot/grub/custom.cfg || exit
                sed -i 's/Arch Linux/Rescue Environment/' /boot/grub/custom.cfg || exit
                sed -i '/vmlinuz/ s/$/ systemd.unit=rescue.target/' /boot/grub/custom.cfg || exit
RESCUE
                stage_ok
            else
                stage_fail
            fi
        fi
    fi

    if [[ "${multilib}" == "y" ]]; then
        local stage_prompt="Multilib Configuration"
        if arch-chroot /mnt <<-MULTILIB > /dev/null 2>&1 2> install_log.txt ; then
            sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf || exit
            pacman -Syy || exit
MULTILIB
            stage_ok
        else
            stage_fail
        fi
    fi

    if [[ "${CPU}" == *"GenuineIntel"* && "${kill_watchdog}" == "y" ]]; then
        local stage_prompt="Intel Watchdog Configuration"
        if arch-chroot /mnt <<-INTEL_WATCHDOG > /dev/null 2>&1 2> install_log.txt ; then
            echo "blacklist iTCO_wdt" | tee /etc/modprobe.d/blacklist.conf || exit
INTEL_WATCHDOG
            stage_ok
        else
            stage_fail
        fi
    elif [[ "${CPU}" == *"AuthenticAMD"* && "${kill_watchdog}" == "y" ]]; then
        local stage_prompt="AMD Watchdog Configuration"
        if arch-chroot /mnt <<-AMD_WATCHDOG > /dev/null 2>&1 2> install_log.txt ; then
            echo "blacklist sp5100_tco" | tee /etc/modprobe.d/blacklist.conf || exit
AMD_WATCHDOG
            stage_ok
        else
            stage_fail
        fi
    fi

    if [[ "${oomd}" == "y" ]]; then
        local stage_prompt="Systemd-oomd Service Activation"
        if arch-chroot /mnt <<-SYSTEMD_OOMD > /dev/null 2>&1 2> install_log.txt ; then
            mkdir -p /etc/systemd/system.conf.d > /dev/null 2>&1 || exit
            cat <<-SET_OOMD > /etc/systemd/system.conf.d/00-oomd.conf || exit
				[Manager]
				DefaultMemoryAccounting=yes
SET_OOMD
            systemctl enable systemd-oomd || exit
SYSTEMD_OOMD
            stage_ok
        else
            stage_fail
        fi
    fi
}
###################################################################################################
secboot_sign() {

    if [[ ${sb_sign} == "y" ]]; then
        local stage_prompt="Secure-Boot Signing"
        if [[ ${bootloader} == "1" ]]; then
            if arch-chroot /mnt <<-SECSIGN > /dev/null 2>&1 2> install_log.txt ; then
                systemctl disable systemd-boot-update || exit
                pacman -S --noconfirm sbctl || exit
                sbctl create-keys || exit
                sbctl enroll-keys -m || exit
                sbctl sign -s /boot/vmlinuz-${kernel} || exit
                sbctl sign -s ${btldr_esp_mount}/EFI/BOOT/BOOTX64.EFI || exit
                sbctl sign -s ${btldr_esp_mount}/EFI/Linux/arch-${kernel}.efi || exit
                sbctl sign -s ${btldr_esp_mount}/EFI/systemd/systemd-bootx64.efi || exit
                sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi || exit
SECSIGN
                stage_ok
            else
                stage_fail
            fi
            if [[ ${setrescue} == "y" ]]; then
                local stage_prompt="Rescue Entry Secure-Boot Signing"
                if arch-chroot /mnt <<-SECSIGN > /dev/null 2>&1 2> install_log.txt ; then
                    sbctl sign -s ${btldr_esp_mount}/EFI/Linux/rescue.efi || exit
SECSIGN
                    stage_ok
                else
                    stage_fail
                fi
            fi
        elif [[ ${bootloader} == "2" ]]; then
            if arch-chroot /mnt <<-SECSIGN > /dev/null 2>&1 2> install_log.txt ; then
                pacman -S --noconfirm sbctl || exit
                sbctl create-keys || exit
                sbctl enroll-keys -m || exit
                sbctl sign -s /boot/vmlinuz-${kernel} || exit
                sbctl sign -s ${btldr_esp_mount}/EFI/GRUB/grubx64.efi || exit
SECSIGN
                stage_ok
            else
                stage_fail
            fi
        fi
    fi
}
###################################################################################################
set_vars() {

    #### Encryption = yes
    if [[ "${encrypt}" == "yes" ]]; then
        ### Encrypted Root Device
        encr_root_dev="/dev/mapper/${ENCROOT}"
        ### Encrypted Root Options
        encr_root_opts="rd.luks.name=$(blkid -s UUID -o value "${root_dev}")=${ENCROOT}"
        ### Encryption_Kernel Parameters
        encr_root_bootopts="${encr_root_opts} root=${encr_root_dev}"
#---------------------------------------------------------------------------------------------------------
        ### Swap Setup (Encryption)
        ## Encrypted Swap Partition
        if [[ "${swapmode}" == "1" ]]; then
            # Encrypted Swap Partition Options
            encr_swap_opts="rd.luks.name=$(blkid -s UUID -o value "${swap_dev}")=swap"
            # Encrypted Swap Partition Kernel Parameters
            encr_swap_bootopts="resume=/dev/mapper/swap ${encr_swap_opts}"
        ## Encrypted Swapfile
        elif [[ "${swapmode}" == "2" ]]; then
            # Ext4 Offset calculation
            if [[ "${fs}" == "1" ]]; then
                offst="$(filefrag -v /mnt/swapfile | awk '$1=="0:" {print substr($4, 1, length($4)-2)}')"
            # Btrfs Offset calculation
            elif [[ "${fs}" == "2" ]]; then
                offst="$(btrfs inspect-internal map-swapfile -r /mnt/swap/swapfile)"
            fi
            # Encrypted Swapfile Kernel Parameters
            encr_swap_bootopts="resume=${encr_root_dev} resume_offset=${offst}"
        ## Zram Swap
        elif [[ "${swapmode}" == "3" ]]; then
            # Zram Swap Kernel Parameters
            zram_bootopts="zswap.enabled=0"
        fi
#---------------------------------------------------------------------------------------------------------
        ### Graphics Setup (Encryption)
        ## Mkinitcpio Modules (Encryption)
        MODULES=("${fs_mod}")
        ## Mkinitcpio Hooks (Encryption)
        HOOKS=()
        ## Graphics Kernel Parameters
        vga_bootopts=()

        # Nvidia Only
        if [[ "${vendor}" == "Nvidia" ]]; then
            HOOKS+=(systemd keyboard autodetect microcode modconf sd-vconsole block sd-encrypt filesystems fsck)
        # Other Vendors/Multi-Vendors
        else
            HOOKS+=(systemd keyboard autodetect microcode modconf kms sd-vconsole block sd-encrypt filesystems fsck)
        fi

        ## Configuration = 'Yes'
        if [[ "${vgaconf}" == "y" ]]; then
            # Nvidia
            if [[ "${vendor}" == "Nvidia" || "${vendors}" =~ "Nvidia"  ]]; then
                MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
                vga_bootopts+=(nvidia.NVreg_UsePageAttributeTable=1)

                # Disable GSP Firmware
                if [[ "${nogsp}" == "y" ]]; then
                    vga_bootopts+=(nvidia.NVreg_EnableGpuFirmware=0)
                fi

                # Enable Experimental Low Latency Interrupts
                if [[ "${lowlat}" == "y" ]]; then
                    vga_bootopts+=(nvidia.NVreg_RegistryDwords=RMIntrLockingMode=1)
                fi
            fi

            # AMD
            if [[ "${vendor}" == "AMD" || "${vendors}" =~ "AMD" ]]; then
                if [[ -n "${islands}" ]]; then
                    MODULES+=(amdgpu)
                fi
                # 'Southern Islands' support
                if [[ "${islands}" == "1" ]]; then
                    vga_bootopts+=(amdgpu.dc=1 radeon.si_support=0 amdgpu.si_support=1)
                # 'Sea Islands' support
                elif [[ "${islands}" == "2" ]]; then
                    vga_bootopts+=(amdgpu.dc=1 radeon.cik_support=0 amdgpu.cik_support=1)
                fi
            fi
        fi
        #### Main Mkinitcpio Modules (Encryption)
        mkinitcpio_mods="MODULES=(${MODULES[*]})"
        #### Main Mkinitcpio Hooks (Encryption)
        mkinitcpio_hooks="HOOKS=(${HOOKS[*]})"
        #### Main Kernel Parameters (Encryption)
        boot_opts=("${encr_root_bootopts}")
        
        if [[ -n "${encr_swap_bootopts}" ]]; then
            boot_opts+=("${encr_swap_bootopts}")
        fi
        if [[ "${kill_watchdog}" == "y" ]]; then
            boot_opts+=(nowatchdog)
        fi
        if [[ -n "${vga_bootopts[*]}" ]]; then
            boot_opts+=("${vga_bootopts[*]}")
        fi
        if [[ -n "${cust_bootopts}" ]]; then
            boot_opts+=("${cust_bootopts}")
        fi
        if [[ -n "${btrfs_bootopts}" ]]; then
            boot_opts+=("${btrfs_bootopts}")
        fi
        if [[ -n "${zram_bootopts}" ]]; then
            boot_opts+=("${zram_bootopts}")
        fi
#-------------------------------------------------------------------------------------------------------------
    #### No Encryption
    elif [[ "${encrypt}" == "no" ]]; then

        ### Swap Setup
        ## Zram Swap
        if [[ "${swapmode}" == "3" ]]; then
            # Zram Swap Kernel Parameters
            zram_bootopts="zswap.enabled=0"
        fi
#---------------------------------------------------------------------------------------------------------
        ### Graphics Setup
        ## Mkinitcpio Modules
        MODULES=()
        ## Mkinitcpio Hooks
        HOOKS=()
        ## Graphics Kernel Parameters
        vga_bootopts=()

        # Nvidia Only
        if [[ "${vendor}" == "Nvidia" ]]; then
            HOOKS+=(systemd autodetect microcode modconf keyboard sd-vconsole block filesystems fsck)
        # Other Vendors/Multi-Vendors
        else
            HOOKS+=(systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)
        fi
        ## Configuration = 'Yes'
        if [[ "${vgaconf}" == "y" ]]; then
            # Nvidia
            if [[ "${vendor}" == "Nvidia" || "${vendors}" =~ "Nvidia"  ]]; then
                MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
                vga_bootopts+=(nvidia.NVreg_UsePageAttributeTable=1)

                # Disable GSP Firmware
                if [[ "${nogsp}" == "y" ]]; then
                    vga_bootopts+=(nvidia.NVreg_EnableGpuFirmware=0)
                fi

                # Enable Experimental Low Latency Interrupts
                if [[ "${lowlat}" == "y" ]]; then
                    vga_bootopts+=(nvidia.NVreg_RegistryDwords=RMIntrLockingMode=1)
                fi
            fi

            # AMD
            if [[ "${vendor}" == "AMD" || "${vendors}" =~ "AMD" ]]; then
                if [[ -n "${islands}" ]]; then
                    MODULES+=(amdgpu)
                fi
                # 'Southern Islands' support
                if [[ "${islands}" == "1" ]]; then
                    vga_bootopts+=(amdgpu.dc=1 radeon.si_support=0 amdgpu.si_support=1)
                # 'Sea Islands' support
                elif [[ "${islands}" == "2" ]]; then
                    vga_bootopts+=(amdgpu.dc=1 radeon.cik_support=0 amdgpu.cik_support=1)
                fi
            fi
        fi
        #### Main Mkinitcpio Modules
        mkinitcpio_mods="MODULES=(${MODULES[*]})"
        #### Main Mkinitcpio Hooks
        mkinitcpio_hooks="HOOKS=(${HOOKS[*]})"
        #### Main Kernel Parameters
        boot_opts=()

        if [[ "${autoroot}" == "y" ]]; then
            boot_opts+=("${multiroot_bootopts}")
        fi
        if [[ "${kill_watchdog}" == "y" ]]; then
            boot_opts+=(nowatchdog)
        fi
        if [[ -n "${vga_bootopts[*]}" ]]; then
            boot_opts+=("${vga_bootopts[*]}")
        fi
        if [[ -n "${cust_bootopts}" ]]; then
            boot_opts+=("${cust_bootopts}")
        fi
        if [[ -n "${btrfs_bootopts}" ]]; then
            boot_opts+=("${btrfs_bootopts}")
        fi
        if [[ -n "${zram_bootopts}" ]]; then
            boot_opts+=("${zram_bootopts}")
        fi
    fi
}
###################################################################################################
chroot_conf() {

        sleep 0.2
        NC "
${magenta}###${nc}--------------------------------${magenta}[ ${bwhite}Chroot & Configure System${nc} ${magenta}]${nc}--------------------------------${magenta}###${nc}
        "

    # 'Vanilla' Setups Configuration:
    if [[ "${packages}" =~ ^(1|3|5|6|7|8|9|10|11|13|14)$ ]]; then
        cnfg
        main_chroot

        if [[ -f /mnt/etc/lightdm/lightdm.conf ]]; then
            if [[ "${packages}" == "7" ]]; then 
                local stage_prompt="Deepin Greeter Configuration"
                if arch-chroot /mnt <<-DEEPIN > /dev/null 2>&1 2> install_log.txt ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-deepin-greeter|g' /etc/lightdm/lightdm.conf || exit
DEEPIN
                    stage_ok
                else
                    stage_fail
                fi
            elif [[ "${packages}" == "5" || "${packages}" == "8" || "${packages}" == "10" ]]; then
                local stage_prompt="GTK Greeter Configuration"
                if arch-chroot /mnt <<-GTK > /dev/null 2>&1 2> install_log.txt ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-gtk-greeter|g' /etc/lightdm/lightdm.conf || exit
GTK
                    stage_ok
                else
                    stage_fail
                fi
            elif [[ "${packages}" == "6" ]]; then
                local stage_prompt="Slick Greeter Configuration"
                if arch-chroot /mnt <<-SLICK > /dev/null 2>&1 2> install_log.txt ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-slick-greeter|g' /etc/lightdm/lightdm.conf || exit
SLICK
                    stage_ok
                else
                    stage_fail
                fi
            fi
        fi

        if [[ "${vendor}" != "Virtual Machine" ]]; then
            if [[ -n "${bluetooth}" ]]; then
                local stage_prompt="Bluetooth Service Activation"
                if arch-chroot /mnt <<-BLUETOOTH > /dev/null 2>&1 2> install_log.txt ; then
                    systemctl enable ${bluetooth} || exit
BLUETOOTH
                    stage_ok
                else
                    stage_fail
                fi
            fi
        fi

        if [[ -n "${displaymanager}" ]]; then
            local stage_prompt="Display Manager Service Activation"
            if arch-chroot /mnt <<-DMSERVICE > /dev/null 2>&1 2> install_log.txt ; then
                systemctl enable ${displaymanager} || exit
DMSERVICE
                stage_ok
            else
                stage_fail
            fi
        fi

        if [[ -n "${network}" ]]; then
            local stage_prompt="Network Manager Service Activation"
            if arch-chroot /mnt <<-NETWORK > /dev/null 2>&1 2> install_log.txt ; then
                systemctl enable ${network} || exit
NETWORK
                stage_ok
            else
                stage_fail
            fi
        fi

        btldrcfg
        trimcfg
        vm_serv
        zramcfg
        nvidia_hook
        mkinitcpio_preset
        var_opts
        secboot_sign
        completion
        installation="ok"
    fi
#--------------------------------------------------------------------------------------------------
    # 'Custom System' Configuration:
    if [[ "${packages}" == "12" ]]; then
        cnfg
        main_chroot

        if [[ -f /mnt/etc/lightdm/lightdm.conf ]]; then
            if [[ "${greeternmbr}" == "1" ]]; then
                local stage_prompt="GTK Greeter Configuration"
                if arch-chroot /mnt <<-GTK > /dev/null 2>&1 2> install_log.txt ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-gtk-greeter|g' /etc/lightdm/lightdm.conf || exit
GTK
                    stage_ok
                else
                    stage_fail
                fi
            elif [[ "${greeternmbr}" == "2" ]]; then
                local stage_prompt="Slick Greeter Configuration"
                if arch-chroot /mnt <<-SLICK > /dev/null 2>&1 2> install_log.txt ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-slick-greeter|g' /etc/lightdm/lightdm.conf || exit
SLICK
                    stage_ok
                else
                    stage_fail
                fi
            elif [[ "${greeternmbr}" == "3" ]]; then
                local stage_prompt="Deepin Greeter Configuration"
                if arch-chroot /mnt <<-DEEPIN > /dev/null 2>&1 2> install_log.txt ; then
                    sed -i 's|^#greeter-session=example-gtk-gnome|greeter-session=lightdm-deepin-greeter|g' /etc/lightdm/lightdm.conf || exit
DEEPIN
                    stage_ok
                else
                    stage_fail
                fi
            fi
        fi

        if [[ -n "${customservices}" ]]; then
            local stage_prompt="Custom Service(s) Activation"
            if arch-chroot /mnt <<-CUSTOMSERV > /dev/null 2>&1 2> install_log.txt ; then
                systemctl enable ${customservices} || exit
CUSTOMSERV
                stage_ok
            else
                stage_fail
            fi
        fi

        btldrcfg
        trimcfg
        vm_serv
        zramcfg
        nvidia_hook
        mkinitcpio_preset
        var_opts
        secboot_sign
        completion
        installation="ok"
    fi
#--------------------------------------------------------------------------------------------------
    # Minimal Plasma/Gnome Optimized-System Configuration:
    if [[ "${packages}" == "2" || "${packages}" == "4" ]]; then
        local stage_prompt="Optimized System Configuration"
        cnfg

        if [[ "${packages}" == "2" ]]; then
            displaymanager="sddm"
        elif [[ "${packages}" == "4" ]]; then
            displaymanager="gdm"
        fi

        if arch-chroot /mnt <<-OPTIMIZED > /dev/null 2>&1 2> install_log.txt ; then
            sed -i "/^#${SETLOCALE}/s/^#//" /etc/locale.gen || exit
            locale-gen || exit
            echo LANG=${SETLOCALE} > /etc/locale.conf || exit
            export LANG=${SETLOCALE} || exit
            echo KEYMAP=${SETKBD} > /etc/vconsole.conf || exit
            sed -i 's/^#Color/Color\nILoveCandy/' /etc/pacman.conf || exit
            update-pciids || exit
            cat <<-MKINITCPIO > /etc/mkinitcpio.conf.d/mkinitcpiod.conf || exit
				${mkinitcpio_mods}
				${mkinitcpio_hooks}
				COMPRESSION="zstd"
				COMPRESSION_OPTIONS=(-c -T$(nproc) --auto-threads=logical -)
				MODULES_DECOMPRESS="yes"
MKINITCPIO
            mkinitcpio -P || exit
            cat <<-MAKEPKG > /etc/makepkg.conf.d/makepkgd.conf || exit
				#!/hint/bash
				CFLAGS="-march=native -O2 -pipe -fno-plt -fexceptions \
				-Wp,-D_FORTIFY_SOURCE=3 -Wformat -Werror=format-security \
				-fstack-clash-protection -fcf-protection \
				-fno-omit-frame-pointer -mno-omit-leaf-frame-pointer"
				MAKEFLAGS="-j$(nproc)"
				BUILDENV=(!distcc color ccache check !sign)
				OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)
				COMPRESSGZ=(pigz -c -f -n)
				COMPRESSBZ2=(pbzip2 -c -f)
				COMPRESSZST=(zstd -c -T0 --auto-threads=logical -)
MAKEPKG
            ln -sf /usr/share/zoneinfo/$(curl -s http://ip-api.com/line?fields=timezone) /etc/localtime || exit
            hwclock --systohc || exit
            echo ${HOSTNAME} > /etc/hostname || exit
            cat <<-HOSTS >> /etc/hosts || exit
				127.0.0.1 localhost
				::1 localhost
				127.0.1.1 ${HOSTNAME}.localdomain ${HOSTNAME}
HOSTS
            cat <<-SYSCTL > /etc/sysctl.d/99-sysctld.conf || exit
				net.core.netdev_max_backlog = 16384
				net.core.somaxconn = 8192
				net.core.rmem_default = 1048576
				net.core.rmem_max = 16777216
				net.core.wmem_default = 1048576
				net.core.wmem_max = 16777216
				net.core.optmem_max = 65536
				net.ipv4.tcp_rmem = 4096 1048576 2097152
				net.ipv4.tcp_wmem = 4096 65536 16777216
				net.ipv4.udp_rmem_min = 8192
				net.ipv4.udp_wmem_min = 8192
				net.ipv4.tcp_fastopen = 3
				net.ipv4.tcp_max_syn_backlog = 8192
				net.ipv4.tcp_max_tw_buckets = 2000000
				net.ipv4.tcp_tw_reuse = 1
				net.ipv4.tcp_fin_timeout = 10
				net.ipv4.tcp_slow_start_after_idle = 0
				net.ipv4.tcp_keepalive_time = 60
				net.ipv4.tcp_keepalive_intvl = 10
				net.ipv4.tcp_keepalive_probes = 6
				net.ipv4.tcp_mtu_probing = 1
				net.ipv4.tcp_sack = 1
				net.core.default_qdisc = cake
				net.ipv4.tcp_congestion_control = bbr
				net.ipv4.ip_local_port_range = 30000 65535
				net.ipv4.conf.default.rp_filter = 1
				net.ipv4.conf.all.rp_filter = 1
				vm.vfs_cache_pressure = 50
				vm.mmap_min_addr = 65536
				vm.max_map_count = 1048576
				kernel.printk = 0 0 0 0
				${perf_stream}
SYSCTL
            cat <<-UDISKS2 > /etc/udisks2/mount_options.conf || exit
				[defaults]
				ntfs_drivers=ntfs,ntfs3
				ntfs:ntfs_defaults=windows_names
				ntfs:ntfs3_defaults=windows_names
UDISKS2
            cat <<-POLKIT > /etc/polkit-1/rules.d/99-udisks2.rules || exit    
				// Original rules: https://github.com/coldfix/udiskie/wiki/Permissions
				// Changes: Added org.freedesktop.udisks2.filesystem-mount-system, as this is used by Dolphin.
				polkit.addRule(function(action, subject) {
				var YES = polkit.Result.YES;
				var permission = {
				// required for udisks1:
				"org.freedesktop.udisks.filesystem-mount": YES,
				"org.freedesktop.udisks.luks-unlock": YES,
				"org.freedesktop.udisks.drive-eject": YES,
				"org.freedesktop.udisks.drive-detach": YES,
				// required for udisks2:
				"org.freedesktop.udisks2.filesystem-mount": YES,
				"org.freedesktop.udisks2.encrypted-unlock": YES,
				"org.freedesktop.udisks2.eject-media": YES,
				"org.freedesktop.udisks2.power-off-drive": YES,
				// Dolphin specific:
				"org.freedesktop.udisks2.filesystem-mount-system": YES,
				// required for udisks2 if using udiskie from another seat (e.g. systemd):
				"org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
				"org.freedesktop.udisks2.filesystem-unmount-others": YES,
				"org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
				"org.freedesktop.udisks2.encrypted-unlock-system": YES,
				"org.freedesktop.udisks2.eject-media-other-seat": YES,
				"org.freedesktop.udisks2.power-off-drive-other-seat": YES
				};
					if (subject.isInGroup("wheel")) {
						return permission[action.id];
					}
				});
POLKIT
            mkdir -p /etc/systemd/journald.conf.d > /dev/null 2>&1 || exit
            cat <<-JOURNAL > /etc/systemd/journald.conf.d/00-journald.conf || exit
				[Journal]
				SystemMaxUse=100M
JOURNAL
            mkdir -p /etc/systemd/user.conf.d > /dev/null 2>&1 || exit
            cat <<-TIMEOUT > /etc/systemd/user.conf.d/00-timeout.conf || exit
				[Manager]
				DefaultTimeoutStopSec=5s
				DefaultTimeoutAbortSec=5s
TIMEOUT
            sed -i 's|^hosts.*|hosts: mymachines mdns_minimal resolve [!UNAVAIL=return] files myhostname dns|g' /etc/nsswitch.conf || exit
            sed -i 's/ interface = [^ ]*/ interface = all/g' /etc/ipp-usb/ipp-usb.conf || exit
            sed -i "/# set linenumbers/"'s/^#//' /etc/nanorc || exit
            sed -i "/# set minibar/"'s/^#//' /etc/nanorc || exit
            sed -i "/# set mouse/"'s/^#//' /etc/nanorc || exit
            echo " include /usr/share/nano/*.nanorc" | tee -a /etc/nanorc || exit
            echo tcp_bbr | tee /etc/modules-load.d/modulesd.conf || exit
            cat <<-SUPPLICANT > /etc/wpa_supplicant/wpa_supplicant.conf || exit
				country=${REGDOM}
				wps_cred_add_sae=1
				pmf=2
SUPPLICANT
            echo root:${ROOTPASSWD2} | chpasswd || exit
            chsh -s /bin/zsh || exit
            useradd -m -G wheel,realtime -s /bin/zsh ${USERNAME} || exit
            echo ${USERNAME}:${USERPASSWD2} | chpasswd || exit
            cat <<-SUDOERS > /etc/sudoers.d/sudoersd || exit
				Defaults pwfeedback
				Defaults editor=/usr/bin/nano
				%wheel ALL=(ALL) ALL
SUDOERS
            visudo -c /etc/sudoers.d/sudoersd || exit
            systemctl enable avahi-daemon bluetooth cups ipp-usb NetworkManager rngd rtkit-daemon ${displaymanager} ${trim} ${vm_services} || exit
OPTIMIZED
            stage_ok
        else
            stage_fail
        fi

        btldrcfg
        zramcfg
        nvidia_hook
        mkinitcpio_preset
        var_opts
        secboot_sign
        completion
        installation="ok"
    fi
        umount -R /mnt
        reboot
        exit
}
# END FUNCTIONS
###################################################################################################

        run_as="$(whoami)"
        tty="$(tty)"
        disks="$(lsblk --nodeps --paths --noheadings --output=name,size,model | cat --number)"
        trg=""
        vars=(LOCALESET="" SETLOCALE="" lcl_slct="" USERNAME="" kernelnmbr="" fs="" vgacount="" vgacard="" intelcount="" intelcards="" nvidiacount="" nvidiacards="" amdcount="" amdcards="" vgaconf="" vga_conf="" vga_setup="" vendor="" vendor1="" vendor2="" vendor3="" vendor_slct="" packages="" efi_entr_del="" wrlss_rgd="" sanity="" install="" bootldr_pkgs="" devel="" REGDOM="" vga_bootopts="" btrfs_bootopts="" trim="" swapmode="" homecrypt="" greeter="" revision="" greeternmbr="" cust_bootopts="" bluetooth="" vmpkgs="" vm_services="" perf_stream="" displaymanager="" wireless_reg="" bitness="" bootloader="" vga_slct="" espsize="" autoroot="" autoesp="" autoxboot="" autohome="" autoswap="" rootprt="" espprt="" xbootprt="" homeprt="" swapprt="" partok="" use_manpreset="" instl_drive="" sgdsk_nmbr="" part_mode="" preset="" capacity="" cap_gib="" rootsize="" sgdrive="" cgdrive="" smartpart="" presetpart="" prcnt="" roottype="" stage_prompt="" zram="" zram_bootopts="" xbootloader="" multibooting="" hypervisor="" mkinitcpio_mods="" uki="" ukify="" slct_autoprt="" cng_espmnt="" sep_home="" encr_swap_bootopts="" uefimode="" luks_encrypt="" nrg_plc="" multilib="" nvname="" nogsp="" luks_root="" luks_swap="" luks_home="" installation="" kill_watchdog="" oomd="" setrescue="" lowlat="" vendors="")
        export "${vars[@]}"
        clear
        first_check
        sleep 0.2
        line3
        CYANBG "************************************************************************************************* "
        CYANBG "                                                                                                  "
        CYANBG "                                 ###     ImphenOs Installer     ###                                 "
        CYANBG "                                                                                                  "
        CYANBG "************************************************************************************************* "
        NC "








                                        ${bwhite}Tekan Tombol apapun buat Menggulingkan Pemerintah${nc} "
        read -r -s -n 1
        clear
        arch
        uefi_check
        connection_check
        upd_clock
        until machine_dtct; do : ; done
        until main_menu; do : ; done
