(use-modules (gnu)
             (gnu system nss)
             (nongnu packages linux)
             (nongnu system linux-initrd)
             (nongnu packages nvidia)
             (nonguix transformations))

(use-service-modules desktop xorg networking dbus)

(use-package-modules bootloaders
                     vim
		     security-token
                     fonts
                     window-management
		     ssh
                     python-xyz
                     terminals
                     version-control
                     gnuzilla
                     xdisorg
                     tor-browsers
                     emacs
                     emacs-xyz
                     rust
                     admin
                     xorg)

(define %my-os
  (operating-system
   (host-name "guix-btw")
   (timezone "Europe/Stockholm")
   (locale "en_US.utf8")

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
                 (supplementary-groups '("wheel" "netdev" "audio" "video" "seat" "plugdev"
                                         "input"))) %base-user-accounts))

   (packages (append (list swayfx
                           swayidle
                           swaylock
                           fuzzel
                           vim
			   hpn-ssh-sans-x
                           btop
                           font-jetbrains-mono
                           font-google-noto
                           font-google-noto-sans-cjk
                           icecat-minimal
                           torbrowser
                           foot
                           git
                           rust-analyzer
                           ) %base-packages))

   (services
    (cons* (service greetd-service-type
		    (greetd-configuration
		     (greeter-supplementary-groups (list "video" "input" "seat"))
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

           (service screen-locker-service-type
                    (screen-locker-configuration
                     (name "swaylock")
                     (program (file-append swaylock "/bin/swaylock"))
                     (using-setuid? #f)))

           (service dbus-root-service-type)
           (service seatd-service-type)
	   
	   (udev-rules-service 'fido2 libfido2 #:groups '("plugdev"))

           (service pam-limits-service-type
                    (list (pam-limits-entry "*" 'both 'core 0)))

           (service polkit-service-type)
           (service network-manager-service-type)
           (service wpa-supplicant-service-type)

           %base-services))))

((nonguix-transformation-nvidia #:driver nvda-580)
 %my-os)
