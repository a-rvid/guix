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

(electric-indent-mode 1)
(toggle-scroll-bar -1)

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
