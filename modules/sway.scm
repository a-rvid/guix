(define-module (modules sway)
  #:use-module (gnu)
  #:use-module (gnu packages window-management)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu home services sway)
  #:export (sway-service))

(define sway-service
  (list (service home-sway-service-type
  (sway-configuration
   (packages (list swayfx))

   (extra-content
    (list
     ;; Blur
     "blur enable"
     "blur_passes 3"
     "blur_radius 5"
     "corner_radius 10"

     ;; Shadows
     "shadows disable"
     "for_window [floating] shadows enable"
     "for_window [app_id=\"foot\"] opacity 0.85"
     "for_window [app_id=\"emacs\"] opacity 0.85"
     "for_window [app_id=\"fuzzel\"] opacity 0.85"
     "shadow_blur_radius 20"
     "shadow_color #0000007F"

     "default_floating_border pixel none"
     "animation_duration_ms 100"

     ;; space
     "gaps inner 8"
     "gaps outer 2"

     ;; colors
     ;; class border background text indicator child_border
     "client.focused #88c0d0 #88c0d0 #2e3440 #88c0d0 #88c0d0"
     "client.unfocused #2e3440 #2e3440 #4c566a #4c566a #4c566a"))

   (variables
    `((mod . "Mod4") ; string
      (left . "h")
      (up . "j")
      (down . "k")
      (right . "l")
      (term ; file-append
       . ,(file-append foot "/bin/footclient"))
      (menu
       . ,(file-append fuzzel "/bin/fuzzel"))
      (Term ; G-expression
       . ,#~(string-append #$foot "/bin/footclient"))))

   (bar
    (sway-bar
     (position 'top)
     (status-command "while date +'%Y-%m-%d %X'; do sleep 1; done")
     (binding-mode-indicator #t)
     (colors
      (sway-color
       (background "#2e3440")
       (statusline "#d8dee9")
       (focused-background "#3b4252")
       (focused-statusline "#eceff4")
       (focused-workspace
        (sway-border-color
         (border "#88c0d0")
         (background "#88c0d0")
         (text "#2e3440")))
       (active-workspace
        (sway-border-color
         (border "#4c566a")
         (background "#4c566a")
         (text "#d8dee9")))
       (inactive-workspace
        (sway-border-color
         (border "#2e3440")
         (background "#2e3440")
         (text "#4c566a")))
       (urgent-workspace
        (sway-border-color
         (border "#bf616a")
         (background "#bf616a")
         (text "#2e3440")))))))

   (inputs
    (list (sway-input
           (identifier "type:keyboard")
           (layout (keyboard-layout "se")))))

   (outputs
    (list (sway-output
           (identifier '*)
           (background (file-append
                        swayfx
                        "/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png")))))
    (startup-programs
    (append %sway-default-startup-programs
	    (list (file-append foot "/bin/foot --server")
		    #~(string-append #$(file-append swaylock "/bin/swaylock")
				    " -i "
				    #$(file-append swayfx "/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png")))))))))
