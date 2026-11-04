;;; my-core.el --- Core settings -*- lexical-binding: t; -*-

;;; Commentary:
;; Core settings.

;;; Code:

(eval-when-compile
  (require 'use-package))
(require 'use-package)
(setq use-package-always-ensure nil)

(put 'magit-clean 'disabled nil)

(provide 'my-core)
;;; my-core.el ends here
