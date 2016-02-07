;;; module-whitespace.el --- Whitespace Module
;;
;; This file is NOT part of GNU Emacs.
;;
;;; License:
;;
;;; Commentary:
;;
(require 'core-fonts-support)
(require 'core-toggle)
(require 'module-vars)
(require 'module-common)
;; (require 'module-core)
;; (require 'module-utils)
(require 'use-package)

;;; Code:

(defun dotemacs-whitespace-style-no-long-lines ()
  "Configure `whitespace-mode' for Org.

Disable the highlighting of overlong lines."
  (setq-local whitespace-style (-difference whitespace-style
                                            '(lines lines-tail))))

(defun dotemacs//whitespace-mode-local ()
  "Enable `whitespace-mode' after local variables where set up."
  (add-hook 'hack-local-variables-hook 'whitespace-mode nil 'local))
;; Trailing whitespace
;; I don’t want to leave trailing whitespace in files I touch, so set
;; up a hook that automatically deletes trailing whitespace after
;; every line when saving a file:
; (add-hook 'write-file-hooks 'delete-trailing-whitespace)

(use-package whitespace                 ; Highlight bad whitespace
  :ensure t
  :defer t
  :init
  (progn
    ;; Use `fill-column' for overlong lines
    (setq-local whitespace-line-column nil))

    (setq dotemacs-show-trailing-whitespace t)
    (defun dotemacs//show-trailing-whitespace ()
      (when dotemacs-show-trailing-whitespace
        (set-face-attribute 'trailing-whitespace nil
                            :background
                            (face-attribute 'font-lock-comment-face
                                            :foreground))
        (setq show-trailing-whitespace 1)))
    (add-hook 'prog-mode-hook 'dotemacs//show-trailing-whitespace)


    (dotemacs-add-toggle whitespace
      :status whitespace-mode
      :on (whitespace-mode)
      :off (whitespace-mode -1)
      :documentation "Display whitespace."
      :evil-leader "tw")
    (dotemacs-add-toggle whitespace-globally
      :status global-whitespace-mode
      :on (global-whitespace-mode)
      :off (global-whitespace-mode -1)
      :documentation "Display whitespace globally"
      :evil-leader "t C-w")

    (defun dotemacs//set-whitespace-style-for-diff ()
      "Whitespace configuration for `diff-mode'"
      (setq-local whitespace-style '(face
                                     tabs
                                     tab-mark
                                     spaces
                                     space-mark
                                     trailing
                                     indentation::space
                                     indentation::tab
                                     newline
                                     newline-mark)))
    (add-hook 'diff-mode-hook 'whitespace-mode)
    (add-hook 'diff-mode-hook 'dotemacs//set-whitespace-style-for-diff)

    (defun dotemacs-set-whitespace-style-for-others ()
      "Whitespace configuration for `prog-mode, `text-mode, `conf-mode'"
      ;; Highlight tabs, empty lines at beg/end, trailing whitespaces and overlong
      ;; portions of lines via faces.  Also indicate tabs via characters
      (setq-local whitespace-style '(face
                                     indentation
                                     space-after-tab
                                     space-before-tab
                                     tab-mark
                                     empty
                                     trailing
                                     lines-tail))
    (dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
      (progn
        (add-hook hook 'dotemacs//whitespace-mode-local)
        (add-hook hook 'dotemacs-set-whitespace-style-for-others))))
  :config
  (progn
    (set-face-attribute 'whitespace-space nil
                        :background nil
                        :foreground (face-attribute 'font-lock-warning-face
                                                    :foreground))
    (set-face-attribute 'whitespace-tab nil
                        :background nil)
    (set-face-attribute 'whitespace-indentation nil
                        :background nil)
    (dotemacs-diminish whitespace-mode " ⓦ" " w")
    (dotemacs-diminish global-whitespace-mode " Ⓦ" " W")))

(use-package whitespace-cleanup-mode    ; Cleanup whitespace in buffers
  :ensure t
  :defer t
  :init
  (dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
    (add-hook hook 'whitespace-cleanup-mode))
  :diminish (whitespace-cleanup-mode . "⌫"))

(use-package ws-butler
  :if (eq 'changed dotemacs-whitespace-cleanup)
  :ensure t
  :config
  (progn
    (ws-butler-global-mode 1)
    (dotemacs-hide-lighter ws-butler-mode)))

(use-package hungry-delete
  :defer t
  :init
  (dotemacs-add-toggle hungry-delete
    :status hungry-delete-mode
    :on (hungry-delete-mode)
    :off (hungry-delete-mode -1)
    :documentation "Delete consecutive horizontal whitespace with a single key."
    :evil-leader "td")
  :config
  (progn
    (setq-default hungry-delete-chars-to-skip " \t\f\v") ; only horizontal whitespace
    (define-key hungry-delete-mode-map (kbd "DEL") 'hungry-delete-backward)
    (define-key hungry-delete-mode-map (kbd "S-DEL") 'delete-backward-char)))

(provide 'module-whitespace)
;;; module-whitespace.el ends here
