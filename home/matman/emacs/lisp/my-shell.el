;;; my-shell.el --- Shell & terminal -*- lexical-binding: t; -*-

;;; Commentary:
;; Shell & terminal.

;;; Code:

(use-package vterm
  :config
  (setq vterm-shell "/usr/bin/env fish"
        vterm-max-scrollback 5000))

(add-hook 'vterm-mode-hook
          (lambda ()
            (display-line-numbers-mode 0)))

(use-package vterm-toggle
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 (reusable-frames . visible)
                 (window-height . 0.3))))

(provide 'my-shell)
;;; my-shell.el ends here
