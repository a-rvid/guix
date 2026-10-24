(use-modules (gnu home)
             (gnu home services)
             (gnu home services sound)
             (gnu home services desktop)
	     (gnu packages gnome)
             (guix gexp)
             (modules emacs)
             (modules fuzzel)
             (modules bash)
             (modules foot)
             (modules sway))

(home-environment
 (packages (append emacs-packages bash-packages (list hicolor-icon-theme)))
 (services (append (list (service home-pipewire-service-type) (service home-dbus-service-type))
		   sway-service foot-home-services bash-home-services fuzzel-home-services emacs-home-services
		   (list
		    (simple-service 'xinitrc home-files-service-type
				    (list `(".xinitrc"
					    ,(plain-file "xinitrc"
							 "setxkbmap se\nexec dwm\n"))))))))

