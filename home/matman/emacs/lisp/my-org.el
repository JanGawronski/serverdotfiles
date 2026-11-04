;;; my-org.el --- Org mode -*- lexical-binding: t; -*-

;;; Commentary:
;; Org mode.

;;; Code:

(setq org-return-follows-link t)

(use-package toc-org
  :commands toc-org-enable
  :init (add-hook 'org-mode-hook 'toc-org-enable))

(add-hook 'org-mode-hook 'org-indent-mode)

(use-package org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(add-hook 'org-mode-hook
          (lambda () (set (make-local-variable 'electric-indent-mode) nil)))

(provide 'my-org)
;;; my-org.el ends here
