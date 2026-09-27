(use-modules (gnu home)
             (gnu home services)
	     (gnu packages gnome)
             (modules emacs)
             (modules fuzzel)
             (modules foot)
             (modules sway))

(home-environment
 (packages (append emacs-packages (list hicolor-icon-theme)))
  (services (append sway-service foot-home-services fuzzel-home-services emacs-home-services)))

