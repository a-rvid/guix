;; -*- lexical-binding: t; -*-
(menu-bar-mode -1)
(tool-bar-mode -1)
(setq select-enable-keyboard 1)
(setq byte-compile-warnings nil)

(defun my/load-theme-on-frame (frame)
  (with-selected-frame frame
    (disable-theme 'nord)
    (load-theme 'nord t)))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/load-theme-on-frame)
  (load-theme 'nord t))

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backups/" user-emacs-directory))))

(setq auto-save-file-name-transforms
      `((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))
(use-package undo-fu
  :ensure nil  ; Guix-provided, already on load-path
  :config
  (global-set-key (kbd "C-z") #'undo-fu-only-undo)
  (global-set-key (kbd "C-S-z") #'undo-fu-only-redo))

(use-package undo-fu-session
  :ensure nil
  :config
  (global-undo-fu-session-mode))

(use-package evil
  :ensure nil
  :init
  (setq evil-undo-system 'undo-fu)  ; must be set BEFORE evil loads
  :config
  (evil-mode 1))

(setq indent-tabs-mode nil)
(prettify-symbols-mode)
(electric-indent-mode 1)
(toggle-scroll-bar -1)
(use-package rustic
  :ensure t
  :config
  (setq rustic-format-on-save nil)
  :custom
  (rustic-cargo-use-last-stored-arguments t))
(push 'rustic-clippy flycheck-checkers)

(global-set-key (kbd "C-c r") (lambda ()
			       (interactive)
                               (load-file user-init-file)))
(use-package vertico
  :init
  (vertico-mode))

(use-package vertico-posframe
  :after vertico
  :init
  (vertico-posframe-mode 1)
  :config
  (setq vertico-posframe-poshandler #'posframe-poshandler-frame-bottom-left-corner)
  (setq vertico-posframe-width 80
        vertico-posframe-height 15
        vertico-posframe-border-width 2))

(use-package vertico-directory
  :after vertico
  :ensure nil ; bundled with vertico
  :bind (:map vertico-map
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word)))
(use-package vterm
  :config
  (evil-set-initial-state 'vterm-mode 'emacs))

(use-package disproject
  :custom
  (disproject-find-special-file-suffixes
   '(["Other options"
      ;; This switch enables using the Customize interface to edit files.  This
      ;; is /not/ implemented by `disproject-find-special-file'; it has to be
      ;; implemented per-command.  The provided dir-locals suffix commands
      ;; implement this using `customize-dirlocals' (for Emacs 30.1+).
      (disproject-infix-customize-switch)]
     ["Special files"
(use-package disproject
  :custom
  (disproject-find-special-file-suffixes
   '(["Other options"
      ;; This switch enables using the Customize interface to edit files.  This
      ;; is /not/ implemented by `disproject-find-special-file'; it has to be
      ;; implemented per-command.  The provided dir-locals suffix commands
      ;; implement this using `customize-dirlocals' (for Emacs 30.1+).
      (disproject-infix-customize-switch)]
     ["Special files"
      ("c" disproject-find-special-file :file "CHANGELOG")
      ("g g" disproject-find-special-file :file "guix.scm")
      ("g m" disproject-find-special-file :file "manifest.scm")
      ;; Suffix commands for finding dir-locals files are already provided by
      ;; Disproject, so we can just use them here.
      (disproject-find-dir-locals-file)
      (disproject-find-dir-locals-2-file)
      ;; Prefer creating Makefile, if none of these files are found.
      ("m" disproject-find-special-file :file ("Makefile" "makefile"
                                               "GNUmakefile"))
      ;; Prefer creating README.org, if none of these files are found.
      ("r" disproject-find-special-file :file ("README.org" "README"
                                               "README.md"))])))
      ("c" disproject-find-special-file :file "CHANGELOG")
      ("g g" disproject-find-special-file :file "guix.scm")
      ("g m" disproject-find-special-file :file "manifest.scm")
      ;; Suffix commands for finding dir-locals files are already provided by
      ;; Disproject, so we can just use them here.
      (disproject-find-dir-locals-file)
      (disproject-find-dir-locals-2-file)
      ;; Prefer creating Makefile, if none of these files are found.
      ("m" disproject-find-special-file :file ("Makefile" "makefile"
                                               "GNUmakefile"))
      ;; Prefer creating README.org, if none of these files are found.
      ("r" disproject-find-special-file :file ("README.org" "README"
                                               "README.md"))])))

(when (getenv "EXWM")
  (require 'exwm)
  (add-hook 'exwm-update-class-hook
            (lambda () (exwm-workspace-rename-buffer exwm-class-name)))
  (setq exwm-input-global-keys
        `(([?\s-r] . exwm-reset)
          ([?\s-&] . (lambda (cmd)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command cmd nil cmd)))))
  (exwm-enable))
