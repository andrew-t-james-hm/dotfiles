;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'set-fringe-mode) (set-fringe-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

(defvar current-user
      (getenv
       (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Emacs is powering up… Be patient, Master %s!" current-user)

;;________________________________________________________________
;;    Determine where we are
;;________________________________________________________________

(defvar system-type-as-string (prin1-to-string system-type))

(defvar on_windows_nt (string-match "windows-nt" system-type-as-string))
(defvar on_darwin     (string-match "darwin" system-type-as-string))
(defvar on_gnu_linux  (string-match "gnu/linux" system-type-as-string))
(defvar on_cygwin     (string-match "cygwin" system-type-as-string))
(defvar on_solaris    (string-match "usg-unix-v" system-type-as-string))

(require 'cask "~/.cask/cask.el")
(cask-initialize)

;; Set path to dependencies
(defgroup dotemacs nil
  "Custom configuration for dotemacs."
  :group 'local)

(defcustom dotemacs-cache-directory (concat user-emacs-directory ".cache/")
  "The storage location for various persistent files."
  :group 'dotemacs)

(defcustom dotemacs-completion-engine
  'company
  "The completion engine the use."
  :type '(radio
          (const :tag "company-mode" company)
          (const :tag "auto-complete-mode" auto-complete))
  :group 'dotemacs)

(defcustom dotemacs-elisp-dir (expand-file-name "elisp" user-emacs-directory)
  "The storage location lisp."
  :group 'dotemacs)

(defcustom dotemacs-settings-dir (expand-file-name "settings" user-emacs-directory)
  "The storage location for settings."
  :group 'dotemacs)

(defcustom dotemacs-user-settings-dir (concat user-emacs-directory "users/" user-login-name)
  "The currently logged in user's storage location for settings."
  :group 'dotemacs)

(defcustom dotemacs-buffer-keymap-prefix (kbd "C-c b")
  "dotemacs buffer keymap prefix."
  :group 'dotemacs
  :type 'string)

;;; Minor mode
(defvar dotemacs-buffer-command-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "p") 'previous-buffer)
    (define-key map (kbd "n") 'next-buffer)
    map)
  "Keymap for dotemacs buffer commands after `dotemacs-buffer-keymap-prefix'.")
(fset 'dotemacs-buffer-command-map dotemacs-buffer-command-map)

(defvar dotemacs-buffer-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map dotemacs-buffer-keymap-prefix 'dotemacs-buffer-command-map)
    map)
  "Keymap for dotemacs buffer mode.")

(define-minor-mode dotemacs-buffer-mode
  "Minor mode for dotemacs buffer mode"
  :keymap dotemacs-buffer-mode-map)

(define-globalized-minor-mode dotemacs-buffer-global-mode
  dotemacs-buffer-mode
  dotemacs-buffer-mode)

;; Set up load path
(add-to-list 'load-path dotemacs-settings-dir)
(add-to-list 'load-path dotemacs-elisp-dir)
(add-to-list 'load-path (concat user-emacs-directory "/settings"))
(add-to-list 'load-path (concat user-emacs-directory "/config"))

(setq custom-file (concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

;; Set up appearance early
(require 'appearance)

;; Settings for currently logged in user
(add-to-list 'load-path dotemacs-user-settings-dir)

;; Add external projects to load path
; (let ((base (concat user-emacs-directory "/elisp")))
(let ((base (concat user-emacs-directory "/elisp")))
  (add-to-list 'load-path base)
  (dolist (dir (directory-files base t "^[^.]"))
    (when (file-directory-p dir)
      (add-to-list 'load-path dir))))

(require 'cl)

;;; Package management

;; Please don't load outdated byte code
(setq load-prefer-newer t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '(("melpa" . "http://melpa.org/packages/")
                                 ("org" . "http://orgmode.org/elpa/")
                                 ;; ("marmalade" . "http://marmalade-repo.org/packages/")
                                 ("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Requires

(eval-when-compile
  (require 'use-package))

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup environment variables from the user's shell.
(when on_darwin
  (require 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

(let ((debug-on-error t))
  (require 'init-util)
  (require 'init-core)

  (require 'init-eshell)
  (require 'init-erc)

  (if (eq dotemacs-completion-engine 'company)
      (require 'init-company)
    (require 'init-auto-complete))

  (require 'init-ido)
  (require 'init-org)
  (require 'init-dired)
  (require 'init-magit)
  (require 'init-vcs)
  (require 'init-rgrep)
  (require 'init-shell)
  (require 'init-perspective)
  (require 'init-ffip)

  (require 'init-programming)
  (require 'init-lisp)
  (require 'init-vim)
  (require 'init-stylus)
  (require 'init-js)
  (require 'init-clojure)
  (require 'init-go)
  (require 'init-web)
  (require 'init-markup)

  (require 'init-projectile)
  (require 'init-helm)
  (require 'init-flycheck)
  ; (require 'init-yasnippet)
  (require 'init-smartparens)
  (require 'init-mustache)
  (require 'init-hbs)
  (require 'init-misc)

  (require 'init-evil)
  (require 'init-macros)
  (require 'init-eyecandy)
  (require 'init-overrides)

  (require 'init-bindings))

(autoload 'skewer-start "init-skewer" nil t)
(autoload 'skewer-demo "init-skewer" nil t)

(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

(use-package mac-osx              ; Personal OS X tools
  :if (eq system-type 'darwin)
  :load-path "settings/"
  :defer t)

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))
