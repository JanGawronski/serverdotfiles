;;; my-git.el --- Git integration -*- lexical-binding: t; -*-

;;; Commentary:
;; Git integration.

;;; Code:

(use-package git-timemachine
  :config
  (define-key git-timemachine-mode-map (kbd "C-j") #'git-timemachine-show-previous-revision)
  (define-key git-timemachine-mode-map (kbd "C-k") #'git-timemachine-show-next-revision))

(use-package magit)
(use-package transient)

(provide 'my-git)
;;; my-git.el ends here
