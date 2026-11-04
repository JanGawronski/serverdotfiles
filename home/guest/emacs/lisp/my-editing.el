;;; my-editing.el --- Editing defaults -*- lexical-binding: t; -*-

;;; Commentary:
;; Editing defaults.

;;; Code:

(use-package multiple-cursors)

(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

(use-package rainbow-mode
  :diminish
  :hook org-mode prog-mode)

(provide 'my-editing)
;;; my-editing.el ends here
