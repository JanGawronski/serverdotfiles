;;; my-completion.el --- Completion & minibuffer -*- lexical-binding: t; -*-

;;; Commentary:
;; Completion & minibuffer.

;;; Code:

(use-package company
  :demand t
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 1)
  (company-show-numbers t)
  (company-tooltip-align-annotations t)
  :config
  (require 'company-childframe)
  (global-company-mode 1))

(use-package ivy
  :demand t
  :bind
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-count-format "(%d/%d) ")
  (enable-recursive-minibuffers t)
  :config
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :demand t
  :diminish
  :config
  (counsel-mode 1))


(use-package ivy-rich
  :after ivy
  :demand t
  :custom
  (ivy-virtual-abbreviate 'full)
  (ivy-rich-switch-buffer-align-virtual-buffer t)
  (ivy-rich-path-style 'abbrev)
  :config
  (ivy-rich-mode 1))

(use-package nerd-icons-ivy-rich
  :after ivy-rich
  :if (locate-library "nerd-icons-ivy-rich")
  :demand t
  :config
  (nerd-icons-ivy-rich-mode 1))

(provide 'my-completion)
;;; my-completion.el ends here
