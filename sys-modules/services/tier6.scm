(define-module (sys-modules services tier6)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system accounts)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages admin)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (ice-9 match)
  #:use-module (sys-modules packages sanctum)
  #:export (tier6-service-type
            tier6-configuration))

(define-record-type* <tier6-configuration>
  tier6-configuration make-tier6-configuration tier6-configuration?
  (package        tier6-configuration-package (default tier6))
  (config-file    tier6-configuration-config-file)
  (autoconfigure? tier6-configuration-autoconfigure? (default #f)))

(define tier6-accounts
  (list (user-group (name "tier6") (system? #t))
        (user-account
         (name "tier6")
         (group "tier6")
         (system? #t)
         (comment "tier6 daemon user")
         (home-directory "/var/empty")
         (shell (file-append shadow "/sbin/nologin")))))

(define (tier6-shepherd-service config)
  (match-record config <tier6-configuration>
                (package config-file autoconfigure?)
    (list (shepherd-service
           (provision '(tier6))
           (requirement '(networking user-processes))
           (documentation "Run the tier6 daemon.")
           (start #~(make-forkexec-constructor
                     (list #$(file-append package "/bin/tier6")
                           #$@(if autoconfigure? '("-a") '())
                           #$config-file)
                     #:log-file "/var/log/tier6.log"))
           (stop #~(make-kill-destructor))))))

(define tier6-service-type
  (service-type
   (name 'tier6)
   (extensions
    (list (service-extension shepherd-root-service-type tier6-shepherd-service)
          (service-extension account-service-type (const tier6-accounts))))
   (description "Run the tier6 global ethernet network daemon.")))
