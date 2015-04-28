(require 'server)
(unless (server-running-p)
  (server-start))

; Start 120x72

(add-to-list 'default-frame-alist '(height . 72))
(add-to-list 'default-frame-alist '(width . 120))

; dtrt-indent

; Automatically determine the indentation settings used on the file that you're
; currently editting and adapt Emacs's settings to them. It's great when you're
; editing external files not created by you or that for some reason follow
; different indentation rules that the ones you've in your config file.

(require 'dtrt-indent)
(dtrt-indent-mode 1)


;; move cursor to the last position upon open
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))


;; To get rid of the start message just set the initial-scratch-message variable to ""
(setq initial-scratch-message "")

;; To start the scratch buffer in text mode you will want to initial-major-mode variable
(setq initial-major-mode 'text-mode)

;; For setting of auto-fill when you start a specific major-mode you'll want to add an event to the mode hook
(add-hook 'text-mode-hook 'turn-on-auto-fill)


;; make side by side buffers function the same as the main window
(setq truncate-partial-width-windows nil)

(load-theme 'zenburn t)

;; disable backup files
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default nil) ; stop creating #autosave# files


;; minibuffer history
(require 'savehist)
(setq savehist-file (concat dotemacs-cache-directory "savehist")
      savehist-additional-variables '(search ring regexp-search-ring)
      savehist-autosave-interval 60)


;; recent files
(require 'recentf)
(setq recentf-save-file (concat dotemacs-cache-directory "recentf"))
(setq recentf-max-menu-items 50)
(setq recentf-auto-cleanup 30)
(add-to-list 'recentf-exclude "COMMIT_EDITMSG\\'")
(run-with-timer 1800 1800 'recentf-save-list)


;; pcomplete
(setq pcomplete-ignore-case t)


;; imenu
(setq-default imenu-auto-rescan t)


;; narrowing
(put 'narrow-to-region 'disabled nil)


;; dired
(require 'dired-x)


;; comint
(after 'comint
  (defun my-toggle-comint-scroll-to-bottom-on-output ()
    (interactive)
    (if comint-scroll-to-bottom-on-output
        (setq comint-scroll-to-bottom-on-output nil)
      (setq comint-scroll-to-bottom-on-output t))))


;; compile
(setq compilation-always-kill t)
(setq compilation-ask-about-save nil)
(add-hook 'compilation-filter-hook
          (lambda ()
            (when (eq major-mode 'compilation-mode)
              (require 'ansi-color)
              (let ((inhibit-read-only t))
                (ansi-color-apply-on-region (point-min) (point-max))))))

; Vim's Marks => Evil's Marks + Emacs' Bookmarks

; Evil has marks just like Vim: m to jump to a mark, m-letter to set a mark,
; m-uppercase_letter to set a mark that works between buffers. But while marks
; are pretty useful for example to quickly jump between two or three positions
; inside some files when you're coding, Emacs also has the concept of
; "bookmarks" that are like inter-file marks that you can set with a name
; (instead of a letter) and that with the elisp bit below in your config file
; can be saved between sessions. I'm using helm-bookmarks to see and set them.
; To delete bookmarks, press TAB inside the helm sub-window to see the list of
; actions and choose "Delete Bookmark(s)".

;; bookmarks
(setq bookmark-default-file (concat dotemacs-cache-directory "bookmarks"))
(setq bookmark-save-flag 1) ;; save after every change


;; fringe
(when (display-graphic-p)
  (fringe-mode 16))


;; re-builder
(setq reb-re-syntax 'string) ;; fix backslash madness


;; clean up old buffers periodically
(require 'midnight)
(midnight-delay-set 'midnight-delay 0)


;; ibuffer
(setq ibuffer-expert t)
(setq ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-mode-hook #'ibuffer-auto-mode)


;; store most files in the cache
(setq backup-directory-alist
      `((".*" . ,(concat dotemacs-cache-directory "backups")))
      auto-save-file-name-transforms
      `((".*" ,(concat dotemacs-cache-directory "backups") t))
      auto-save-list-file-prefix
      (concat dotemacs-cache-directory "auto-save-list/saves-"))


;; better scrolling
(setq scroll-conservatively 9999
      scroll-preserve-screen-position t)

;; Buffer management

;; Burying a buffer (removing it from the current window and sending
;; it to the bottom of the stack) is very common for dismissing
;; buffers. Add a mapping for it:
(global-set-key (kbd "C-c y") 'bury-buffer)

;; Add a key combination to revert the current buffer (re-read the
;; contents from disk):
(global-set-key (kbd "C-c r") 'revert-buffer)

;; Use ibuffer instead of the feature-lacking list-buffers:
(global-set-key (kbd "C-x C-b") 'ibuffer)


(setq ring-bell-function 'ignore)
(setq mark-ring-max 64)
(setq global-mark-ring-max 128)
(setq save-interprogram-paste-before-kill t)
(setq create-lockfiles nil)

(setq initial-major-mode 'emacs-lisp-mode)


; spaces instead of tabs
(setq-default c-basic-offset 2 c-default-style "bsd")
(setq-default tab-width 2)
(setq-default highlight-tabs t)

;; some more interface-related settings
(setq inhibit-splash-screen t)
(setq inhibit-startup-echo-area-message t)
(setq inhibit-startup-message t)
(setq read-file-name-completion-ignore-case t)
(setq frame-title-format '("Emacs @ : %b %+%+ %f"))
; (setq frame-title-format
;       '("" invocation-name " - " (:eval (if (buffer-file-name)
;                                             (abbreviate-file-name (buffer-file-name))
;                                           "%b"))))
(setq mouse-yank-at-point t)


(xterm-mouse-mode t)
(which-function-mode t)
(random t) ;; seed


(defun my-find-file-check-large-file ()
  (when (> (buffer-size) (* 1024 1024))
    (setq buffer-read-only t)
    (buffer-disable-undo)
    (when (fboundp #'undo-tree-mode)
      (undo-tree-mode -1))
    (fundamental-mode)))


(add-hook 'find-file-hook (lambda ()
                            (unless (eq major-mode 'org-mode)
                              (setq show-trailing-whitespace t))))
(add-hook 'find-file-hook #'visual-line-mode)
(add-hook 'find-file-hook #'my-find-file-check-large-file)


;; flyspell-mode does spell-checking on the fly as you type
(require 'flyspell)
(setq ispell-program-name "aspell" ; use aspell instead of ispell
      ispell-extra-args '("--sug-mode=ultra"))

(defun my-enable-flyspell ()
  "Enable command `flyspell-mode'."
  (when (executable-find ispell-program-name)
    (flyspell-mode +1)))


(defun my-wrap-with (s)
  "Create a wrapper function for smartparens using S."
  `(lambda (&optional arg)
     (interactive "P")
     (sp-wrap-with-pair ,s)))


(provide 'init-core)