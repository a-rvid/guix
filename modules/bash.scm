(define-module (modules bash)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (gnu home services shells)
  #:use-module (gnu packages shellutils)
  #:export (bash-home-services bash-packages))

(define bash-packages 
  (list pay-respects))

(define bash-home-services
  (list 
   (service home-bash-service-type
            (home-bash-configuration
             (bashrc
              (list
               (plain-file "pay-respects-init"
                           "eval \"$(pay-respects bash --alias)\"\n")))))))
