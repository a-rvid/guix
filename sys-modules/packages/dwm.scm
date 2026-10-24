(define-module (sys-modules packages dwm)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages suckless)
  #:export (my-dwm))

(define my-dwm
  (package
   (inherit dwm)
   (name "my-dwm")
   (source (origin
            (inherit (package-source dwm))
            (patches (list (local-file "../../patches/dwm-attachaside-6.6.diff")))
            (snippet
             #~(copy-file #$(local-file "../../config/dwm.h") "config.h"))))
   (propagated-inputs (list font-nerd-jetbrains-mono))))
