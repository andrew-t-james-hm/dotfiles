(require 'ido)
(setq ido-enable-prefix nil)
(setq ido-use-virtual-buffers t)
;; disable ido faces to see flx highlights.
;; https://github.com/lewang/flx
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(setq ido-create-new-buffer 'always)
(setq ido-use-filename-at-point 'guess)
(setq ido-save-directory-list-file (concat dotemacs-cache-directory "ido.last"))

(ido-mode t)
(ido-everywhere t)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode t)

(require 'flx-ido)
(flx-ido-mode t)

(require 'ido-vertical-mode)
(ido-vertical-mode)

(provide 'init-ido)