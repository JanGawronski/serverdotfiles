;;; my-keybindings.el --- Keybindings -*- lexical-binding: t; -*-

;;; Commentary:
;; Personal keybindings (vanilla conventions + a small user prefix map).

;;; Code:

(define-prefix-command 'my/map)
(global-set-key (kbd "C-c m") #'my/map)

(global-set-key (kbd "C-S-<return>") #'vterm-toggle)
(define-key my/map (kbd "t") #'vterm-toggle)

;; Compile / run helpers
(define-prefix-command 'my/compile-map)
(define-key my/map (kbd "c") #'my/compile-map)
(define-key my/compile-map (kbd "c") #'compile)
(define-key my/compile-map (kbd "r") #'recompile)
(define-key my/compile-map (kbd "f") #'my/compile-file)
(define-key my/compile-map (kbd "p") #'my/compile-project)

(define-prefix-command 'my/run-map)
(define-key my/map (kbd "r") #'my/run-map)
(define-key my/run-map (kbd "f") #'my/run-file)
(define-key my/run-map (kbd "p") #'my/run-project)

;; Multiple cursors (package)
(define-prefix-command 'my/mc-map)
(define-key my/map (kbd "m") #'my/mc-map)
(define-key my/mc-map (kbd "n") #'mc/mark-next-like-this)
(define-key my/mc-map (kbd "a") #'mc/mark-all-like-this)
(define-key my/mc-map (kbd "q") #'mc/keyboard-quit)


(provide 'my-keybindings)
;;; my-keybindings.el ends here
