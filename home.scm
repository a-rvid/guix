(use-modules (gnu home)
             (gnu home services)
             (gnu home services sound)
             (gnu home services desktop)
	     (gnu packages gnome)
             (modules emacs)
             (modules fuzzel)
             (modules foot)
             (modules sway))

(home-environment
 (packages (append emacs-packages (list hicolor-icon-theme)))
 (services (append (list (service home-pipewire-service-type) (service home-dbus-service-type))
		   sway-service foot-home-services fuzzel-home-services emacs-home-services)))

