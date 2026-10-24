(use-modules (gnu)
             (gnu system nss)
	     (sys-modules packages sanctum)
	     (sys-modules packages dwm)
	     (sys-modules services tier6)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (nongnu packages messaging) ; signal-cli and signal-desktop
             (nongnu packages nvidia)
             (nonguix transformations))

(use-service-modules desktop xorg cups networking dbus sound linux)

(use-package-modules bootloaders
		     linux
                     vim
		     security-token
		     shellutils
		     suckless
                     fonts
		     package-management
		     bittorrent
                     window-management
		     ssh
                     python-xyz
		     image
                     terminals
                     version-control
                     librewolf
		     code
                     xdisorg
		     cups
		     freedesktop
                     tor-browsers
		     file
                     emacs
                     emacs-xyz
                     rust
		     gl
		     llvm
		     commencement
		     compression
		     gcc
                     admin
                     xorg)

(define %my-os
  (operating-system
   (host-name "guix-btw")
   (timezone "Europe/Stockholm")
   (locale "en_US.utf8")
   (keyboard-layout (keyboard-layout "se"))

   (kernel linux)
   (initrd microcode-initrd)
   (firmware (list linux-firmware))

   (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets '("/boot/efi"))))

   (mapped-devices (list (mapped-device
                          (source (uuid
                                   "d4b236a1-2cbb-486a-b361-d92cd6430b78"))
                          (target "guix-crypt")
                          (type luks-device-mapping))))

   (file-systems (append (list (file-system
                                (device "/dev/mapper/guix-crypt")
                                (mount-point "/")
                                (type "ext4")
                                (dependencies mapped-devices))

                               (file-system
                                (device (uuid "ED75-AB82"
                                              'fat))
                                (mount-point "/boot/efi")
                                (type "vfat"))) %base-file-systems))

   (users (cons (user-account
                 (name "user")
                 (group "users")
                 (supplementary-groups '("wheel" "netdev" "audio" "video" "plugdev"
                                         "input"))) %base-user-accounts))

   (packages (append (list swayfx
			   cage
                           swayidle
                           swaylock
                           fuzzel
			   pay-respects
			   grim slurp
			   xdg-desktop-portal
			   xdg-desktop-portal-wlr
			   alsa-utils
			   emacs
			   emacs-exwm
			   xinit
			   xorg-server
			   xf86-input-libinput
			   my-dwm
			   st
			   dmenu
                           vim
			   hpn-ssh-sans-x
                           btop
                           font-jetbrains-mono
                           font-google-noto
                           font-google-noto-sans-cjk
			   qbittorrent
			   flatpak
			   clang
			   gcc
			   gcc-toolchain
			   rust
			   tier6
			   sanctum
			   rlq
			   libx11
			   libxi
			   libxcursor
			   libxkbcommon
			   mesa
			   file
			   unzip 
			   cloc
			   alsa-lib
                           librewolf
			   signal-desktop
			   signal-cli
                           torbrowser
                           foot
                           git
                           rust-analyzer
                           ) %base-packages))

   (services
    (cons* (service greetd-service-type
		    (greetd-configuration
		     (greeter-supplementary-groups (list "video" "input"))
		     (terminals
		      (list (greetd-terminal-configuration
			     (terminal-vt "7")
			     (terminal-switch #t)
			     (source-profile? #t)
			     (default-session-user "user")
			     (default-session-command
			       (greetd-user-session
				(command (file-append swayfx "/bin/sway"))
				(command-args '()))))))))
	    
	    (service kernel-module-loader-service-type '("tun"))
	    (service tier6-service-type
		     (tier6-configuration
		      (autoconfigure? #t)
		      (config-file
		       (plain-file "tier6.conf"
				   "runas tier6
kek-id 02
cs-id 9e4dcc5a
flock d16b99b70da45f00
tapname 9e4dcc5a
shroud yes
cathedral cathedral.reliquary.se:4469
kek-path /var/lib/tier6/kek-0x02
cs-path /var/lib/tier6/id-9e4dcc5a
cosk-path /var/lib/tier6/cosk-9e4dcc5a
remembrance /var/lib/tier6/remembrance.bin
"))))
(service xorg-server-service-type
         (xorg-configuration
          (modules (list nvidia-driver))   ; puts nvidia_drv.so on the module path
          (extra-config
           (list "Section \"Device\"
    Identifier \"nvidia\"
    Driver     \"nvidia\"
    BusID      \"PCI:1:0:0\"
EndSection

Section \"Screen\"
    Identifier \"nvidia-screen\"
    Device     \"nvidia\"
EndSection
"))))

            (service screen-locker-service-type
                     (screen-locker-configuration
                      (name "swaylock")
                      (program (file-append swaylock "/bin/swaylock"))
                      (using-setuid? #f)))

            (service dbus-root-service-type)
            (service elogind-service-type)

	    (service cups-service-type
		     (cups-configuration
		      (web-interface? #t)
		      (extensions
		       (list cups-filters hplip-minimal))))
	    
	    (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))

            (service pam-limits-service-type
                     (list (pam-limits-entry "*" 'both 'core 0)))
	    
	    
            (service polkit-service-type)
            (service network-manager-service-type)
            (service wpa-supplicant-service-type)

            %base-services))))

  ((nonguix-transformation-nvidia #:driver nvda-580)
   %my-os)
