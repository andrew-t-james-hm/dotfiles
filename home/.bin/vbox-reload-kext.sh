 #!/bin/bash

unload() {
        kextstat | grep "org.virtualbox.kext.VBoxUSB" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxUSB
        kextstat | grep "org.virtualbox.kext.VBoxNetFlt" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxNetFlt
        kextstat | grep "org.virtualbox.kext.VBoxNetAdp" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxNetAdp
        kextstat | grep "org.virtualbox.kext.VBoxDrv" > /dev/null 2>&1 && sudo kextunload -b org.virtualbox.kext.VBoxDrv
}

load() {
        sudo kextload "/Library/Application Support/VirtualBox/VBoxDrv.kext" -r "/Library/Application Support/VirtualBox/"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxNetFlt.kext" -r "/Library/Application Support/VirtualBox/"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxNetAdp.kext" -r "/Library/Application Support/VirtualBox/"
        sudo kextload "/Library/Application Support/VirtualBox/VBoxUSB.kext" -r "/Library/Application Support/VirtualBox/"
}

case "$1" in
        unload|remove)
                unload
                ;;
        load)
                load
                ;;
        *|reload)
                unload
                load
                ;;
esac
