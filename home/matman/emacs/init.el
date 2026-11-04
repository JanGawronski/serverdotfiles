;;; init.el --- Initialization -*- lexical-binding: t; -*-

;;; Commentary:
;; Initialization.

;;; Code:

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(let* ((state-home (or (getenv "XDG_STATE_HOME")
                       (expand-file-name "~/.local/state")))
       (custom-dir (expand-file-name "emacs" state-home))
       (custom-path (expand-file-name "custom.el" custom-dir)))
  (unless (file-directory-p custom-dir)
    (make-directory custom-dir t))
  (setq custom-file custom-path)
  (when (file-exists-p custom-file)
    (load custom-file nil t)))

(require 'my-core)
(require 'my-project)
(require 'my-completion)
(require 'my-keybindings)
(require 'my-org)
(require 'my-dev)
(require 'my-git)
(require 'my-shell)
(require 'my-ui)
(require 'my-editing)
;;; init.el ends here
