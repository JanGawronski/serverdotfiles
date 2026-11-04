;;; my-ui.el --- UI tweaks -*- lexical-binding: t; -*-

;;; Commentary:
;; UI tweaks.

;;; Code:

(use-package nerd-icons
  :if (locate-library "nerd-icons"))

(use-package nerd-icons-dired
  :if (locate-library "nerd-icons-dired")
  :hook (dired-mode . nerd-icons-dired-mode))

(when (display-graphic-p)
  (let ((nf "FiraCode Nerd Font Mono"))
    (when (member nf (font-family-list))
      (set-fontset-font t 'symbol (font-spec :family nf) nil 'append)
      (dolist (r '((#xE000 . #xF8FF)
                   (#xF0000 . #xFFFFD)
                   (#x100000 . #x10FFFD)))
        (set-fontset-font t r (font-spec :family nf) nil 'append)))))

(use-package dashboard
  :config
  (setq dashboard-projects-backend 'projectile)
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (setq dashboard-items '((recents   . 10)
                          (projects  . 10)))
  (dashboard-setup-startup-hook))

(use-package diminish)

(setq ring-bell-function #'ignore)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(setq display-line-numbers-type 'relative
      display-line-numbers-current-absolute t)
(column-number-mode t)

(setq mode-line-position '("Line %l Column %c " (-3 "%p")))

(electric-pair-mode 1)

(let* ((state-home (or (getenv "XDG_STATE_HOME")
                       (expand-file-name "~/.local/state")))
       (emacs-state (expand-file-name "emacs" state-home))
       (autosave-dir (expand-file-name "auto-save" emacs-state))
       (backup-dir (expand-file-name "backup" emacs-state)))
  (dolist (dir (list autosave-dir backup-dir))
    (unless (file-directory-p dir)
      (make-directory dir t)))

  (setq auto-save-file-name-transforms `((".*" ,(file-name-as-directory autosave-dir) t))
        auto-save-list-file-prefix (expand-file-name ".saves-" (file-name-as-directory autosave-dir))
        tramp-auto-save-directory autosave-dir)

  (setq backup-directory-alist `(("." . ,backup-dir))
        backup-by-copying t
        delete-old-versions t
        kept-new-versions 6
        kept-old-versions 2
        version-control t))

(setq create-lockfiles nil)

(use-package doom-themes
  :demand t
  :custom
  (doom-themes-enable-bold t)
  (doom-themes-enable-italic t)
  (doom-themes-treemacs-theme "doom-atom")
  :config
  (load-theme 'doom-dark+ t)

  (require 'doom-themes-ext-visual-bell nil t)
  (when (fboundp 'doom-themes-visual-bell-config)
    (doom-themes-visual-bell-config))

  (when (fboundp 'doom-themes-treemacs-config)
    (doom-themes-treemacs-config))
  (when (fboundp 'doom-themes-org-config)
    (doom-themes-org-config)))

(use-package which-key
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " → "))

(provide 'my-ui)
;;; my-ui.el ends here
