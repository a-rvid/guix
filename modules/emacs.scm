(define-module (modules emacs)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages emacs-xyz)
  #:use-module (gnu home services)
  #:use-module (guix gexp)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (emacs-packages
            emacs-home-services))

(define emacs-packages
  (list emacs-next-pgtk
	emacs-next
        emacs-nord-theme
        emacs-evil
        emacs-evil-commentary
        emacs-undo-fu
        emacs-undo-fu-session
	emacs-vertico
	emacs-vertico-posframe
	emacs-marginalia
	emacs-lsp-mode
	emacs-geiser
	emacs-disproject
	emacs-orderless
        emacs-guix
        emacs-magit
	emacs-rustic
        emacs-vterm))

(define (collect-files dir)
  (let ((base (string-append (dirname (current-filename)) "/" dir)))
    (define (walk sub acc)
      (let ((full (if (string-null? sub) base (string-append base "/" sub))))
        (fold (lambda (entry acc)
                (if (member entry '("." ".."))
                    acc
                    (let* ((rel (if (string-null? sub)
                                     entry
                                     (string-append sub "/" entry)))
                           (path (string-append base "/" rel)))
                      (if (eq? (stat:type (stat path)) 'directory)
                          (walk rel acc)
                          (cons (cons rel path) acc)))))
              acc
              (scandir full))))
    (walk "" '())))

(define (emacs.d-files)
  (map (match-lambda
         ((rel . abs)
          (list (string-append ".emacs.d/" rel) (local-file abs))))
       (collect-files "../files/emacs.d")))

(define emacs-home-services
  (list (simple-service 'emacs-dotfiles
          home-files-service-type
          (emacs.d-files))))
