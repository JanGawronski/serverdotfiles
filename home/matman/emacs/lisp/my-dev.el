;;; my-dev.el --- Development tools -*- lexical-binding: t; -*-

;;; Commentary:
;; Development tools.

;;; Code:

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  (let* ((state-home (or (getenv "XDG_STATE_HOME")
                         (expand-file-name "~/.local/state")))
         (emacs-state (expand-file-name "emacs" state-home)))
    (unless (file-directory-p emacs-state)
      (make-directory emacs-state t))
    (setq lsp-session-file (expand-file-name "lsp-session-v1" emacs-state)))
  :custom
  (lsp-idle-delay 0.5)
  :config
  (require 'lsp-diagnostics)
  (lsp-enable-which-key-integration t)
  (setq lsp-inlay-hint-enable t))

(with-eval-after-load 'lsp-mode
  (require 'lsp-lens))

(with-eval-after-load 'lsp-mode
  (require 'lsp-modeline))

(with-eval-after-load 'lsp-mode
  (require 'lsp-headerline))

(with-eval-after-load 'lsp-headerline
  (setq lsp-headerline-breadcrumb-icons-enable nil))

(use-package lsp-ui
  :after lsp-mode
  :custom
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-delay 0.2)
  :commands lsp-ui-mode)

(use-package yasnippet
  :defer 1
  :config
  (yas-reload-all)
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet
  :defer 2)

(use-package flycheck
  :defer t
  :diminish
  :config (global-flycheck-mode))

(defun my/project-root ()
  (cond ((projectile-project-root) (projectile-project-root))
        (t default-directory)))

(defun my/run-file ()
  (interactive)
  (if (and (boundp 'my/run-file-handler) my/run-file-handler)
      (funcall my/run-file-handler)
    (user-error "No run handler set for %s" major-mode)))

(defun my/default-run-file ()
  (interactive)
  (let ((file (buffer-file-name)))
    (unless file (user-error "Buffer is not visiting a file"))
    (let* ((base (file-name-base file))
           (cmd  (format "./%s"
                         (shell-quote-argument base))))
      (compile cmd))))

(defun my/compile-file ()
  (interactive)
  (if (and (boundp 'my/compile-file-handler) my/compile-file-handler)
      (funcall my/compile-file-handler)
    (user-error "No compile handler set for %s" major-mode)))

(defun my/run-project ()
  (interactive)
  (if (and (boundp 'my/run-project-handler) my/run-project-handler)
      (funcall my/run-project-handler)
    (user-error "No run handler set for %s" major-mode)))

(defun my/compile-project ()
  (interactive)
  (if (and (boundp 'my/compile-project-handler) my/compile-project-handler)
      (funcall my/compile-project-handler)
    (user-error "No compile handler set for %s" major-mode)))

(use-package haskell-mode
  :defer t
  :mode ("\\.hs\\'" "\\.lhs\\'")
  :hook ((haskell-mode . haskell-indentation-mode)
         (haskell-mode . lsp)
         (haskell-mode . (lambda ()
                           (setq-local my/compile-file-handler #'my/haskell-compile-file)))
         (haskell-mode . (lambda ()
                           (setq-local my/run-file-handler #'my/default-run-file)))))

(use-package lsp-haskell
  :after lsp-mode)

(defun my/haskell-compile-file ()
  (interactive)
  (save-buffer)
  (let ((file (buffer-file-name)))
    (unless file (user-error "Buffer is not visiting a file"))
    (let* ((base (file-name-base file))
           (cmd  (format "ghc %s.hs && ./%s"
                         (shell-quote-argument base)
                         (shell-quote-argument base))))
      (compile cmd))))

(use-package lsp-pyright
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
        (python-mode . (lambda ()
                         (setq-local my/run-file-handler #'my/python-run-file)))
        (python-mode . (lambda ()
                         (setq-local my/run-project-handler #'my/python-run-project))))

(defun my/python-run-file ()
  (interactive)
  (save-buffer)
  (let* ((proj (file-name-as-directory (my/project-root)))
         (venv-py (expand-file-name ".venv/bin/python" proj))
         (python-cmd (cond
                      ((file-exists-p venv-py) (file-relative-name (shell-quote-argument venv-py) proj))
                      (t "python")))
         (cmd (format "%s %s" python-cmd (file-relative-name (buffer-file-name) proj)))
         (default-directory proj))
    (compile cmd)))

(defun my/python-run-project ()
  (interactive)
  (save-buffer)
  (let* ((proj (file-name-as-directory (my/project-root)))
         (venv-py (expand-file-name ".venv/bin/python" proj))
         (python-cmd (cond
                      ((file-exists-p venv-py) (file-relative-name (shell-quote-argument venv-py) proj))
                      (t "python")))
         (cmd (format "%s main.py" python-cmd))
         (default-directory proj))
    (compile cmd)))

(use-package cc-mode
  :ensure nil
  :defer t
  :config
  (setq c-default-style "k&r"
        c-basic-offset 4)
  (add-hook 'c-mode-hook (lambda () (setq-local company-backends '(company-capf company-files))))
  (add-hook 'c++-mode-hook (lambda () (setq-local company-backends '(company-capf company-files)))))

(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c-mode-hook (lambda () (setq-local my/run-file-handler #'my/default-run-file)))
(add-hook 'c-mode-hook (lambda () (setq-local my/compile-file-handler #'my/c-compile-file)))
(add-hook 'c-mode-hook (lambda () (setq-local my/run-project-handler #'my/c-run-project)))
(add-hook 'c-mode-hook (lambda () (setq-local my/compile-project-handler #'my/c-compile-project)))

(add-hook 'c++-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook (lambda () (setq-local my/run-file-handler #'my/default-run-file)))
(add-hook 'c++-mode-hook (lambda () (setq-local my/compile-file-handler #'my/c++-compile-file)))
(add-hook 'c++-mode-hook (lambda () (setq-local my/run-project-handler #'my/c-run-project)))
(add-hook 'c++-mode-hook (lambda () (setq-local my/compile-project-handler #'my/c-compile-project)))

(defun my/c-compile-file ()
  (interactive)
  (save-buffer)
  (let ((base (shell-quote-argument (file-name-base (buffer-file-name)))))
    (compile (format "gcc %s.c -o %s && ./%s" base base base))))

(defun my/c++-compile-file ()
  (interactive)
  (save-buffer)
  (let ((base (shell-quote-argument (file-name-base (buffer-file-name)))))
    (compile (format "g++ %s.cpp -o %s && ./%s" base base base))))

(defun my/c-run-project ()
  (interactive)
  (save-buffer)
  (let ((default-directory (cond
                            ((file-exists-p "Makefile") default-directory)
                            (t (file-name-as-directory (my/project-root))))))
    (compile "make run")))

(defun my/c-compile-project ()
  (interactive)
  (save-buffer)
  (let ((default-directory (cond
                            ((file-exists-p "Makefile") default-directory)
                            (t (file-name-as-directory (my/project-root))))))
    (compile "make")))

(use-package rust-mode
  :mode "\\.rs\\'"
  :hook (rust-mode . (lambda ()
                       (when (fboundp 'lsp-deferred) (lsp-deferred))))
        (rust-mode . (lambda ()
                       (setq-local my/run-file-handler #'rustic-cargo-run)))
        (rust-mode . (lambda ()
                       (setq-local my/run-file-handler #'rustic-cargo-run)))
  :config
  (setq rust-format-on-save t))

(use-package rustic
  :after rust-mode
  :config
  (setq rustic-lsp-client 'lsp)
  (setq rustic-format-on-save t))

(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust)
(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package toml-mode)

(require 'lsp-mode)
(require 'nix-mode)

(add-to-list 'lsp-language-id-configuration '(nix-mode . "nix"))

(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection '("nixd"))
  :major-modes '(nix-mode)
  :activation-fn (lsp-activate-on "nix")
  :server-id 'nixd))

(add-hook 'nix-mode-hook #'lsp-deferred)

(require 'auctex)
(use-package auctex
  :defer t
  :init
  (setq TeX-auto-save t
        TeX-parse-self t
        TeX-save-query nil)
  :config
  (require 'tex)

  (with-eval-after-load 'tex
    (unless (assoc "LatexMk" TeX-command-list)
      (add-to-list 'TeX-command-list
                   '("LatexMk"
                     "latexmk -pdf -synctex=1 -interaction=nonstopmode %s"
                     TeX-run-TeX nil t :help "Run latexmk")))

    (setq TeX-command-default "LatexMk"
          TeX-source-correlate-method 'synctex
          TeX-source-correlate-start-server t))

  (add-hook 'LaTeX-mode-hook #'turn-on-reftex)
  (add-hook 'LaTeX-mode-hook (lambda ()
                               (setq-local my/compile-file-handler #'my/latex-compile-file))))

(defun my/latex-compile-file ()
  (interactive)
  (save-buffer)
  (let ((base (shell-quote-argument (file-name-base (buffer-file-name)))))
    (compile (format "pdflatex %s.tex" base))))

(use-package reftex
  :defer t
  :config
  (setq reftex-plug-into-AUCTeX t))

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (require 'pdf-occur)
  (require 'pdf-history)
  (require 'pdf-links)
  (require 'pdf-outline)
  (require 'pdf-annot)
  (require 'pdf-sync)
  (pdf-tools-install)
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view)))
  (setq TeX-source-correlate-start-server t))

(use-package company-auctex
  :after (company auctex)
  :config
  (company-auctex-init))

(add-hook 'pdf-view-mode-hook
          (lambda ()
            (display-line-numbers-mode -1)))

(use-package vhdl-mode
  :ensure t
  :mode (("\\.vhd\\'" . vhdl-mode)
         ("\\.vhdl\\'" . vhdl-mode))
  :hook ((vhdl-mode . lsp-deferred)))

(with-eval-after-load 'lsp-mode
  (setq lsp-vhdl-server 'vhdl-ls))

(provide 'my-dev)
;;; my-dev.el ends here
