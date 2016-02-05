;;; module-ruby.el --- Ruby Module
;;
;; This file is NOT part of GNU Emacs.
;;
;;; License:
;;
;;; Commentary:
;;
;; (require 'core-vars)
;; (require 'core-funcs)
;; (require 'core-keybindings)
;; (require 'core-display-init)
(require 'module-vars)
(require 'module-common)
;; (require 'module-core)
;; (require 'module-utils)

;;; Code:
(dotemacs-defvar-company-backends enh-ruby-mode)
(dotemacs-defvar-company-backends ruby-mode)

(defvar ruby-enable-enh-ruby-mode nil
  "If non-nil, use `enh-ruby-mode' package insted of the built-in Ruby Mode.

Otherwise use Enh Ruby Mode, which is the default.")

(defvar ruby-version-manager 'rbenv
  "If non nil, defines the Ruby version manager.
Possible values are `rbenv', `rvm' or `chruby'.)")

(defvar ruby-test-runner 'ruby-test
  "Test runner to use. Possible values are `ruby-test' or `rspec'.")

;; Command prefixes

(dotemacs-declare-prefix-for-mode 'ruby-mode "mt" "ruby/test")

(defvar dotemacs-ruby-enable-ruby-on-rails-support nil
  "If non nil we'll load support for Rails (haml, features, navigation)")

(use-package rbenv
  :if (equal ruby-version-manager 'rbenv)
  :ensure t
  :defer t
  :init
  (progn
    (defun dotemacs//enable-rbenv ()
      "Enable rbenv, use .ruby-version if exists."
      (require 'rbenv)
      (let ((version-file-path (rbenv--locate-file ".ruby-version")))
        (global-rbenv-mode)
        ;; try to use the ruby defined in .ruby-version
        (if version-file-path
            (progn
              (rbenv-use (rbenv--read-version-from-file
                          version-file-path))
              (message (concat "[rbenv] Using ruby version "
                               "from .ruby-version file.")))
          (message "[rbenv] Using the currently activated ruby."))))
    (dotemacs/add-to-hooks 'dotemacs//enable-rbenv
                            '(ruby-mode-hook enh-ruby-mode-hook))))

(use-package rvm
  :ensure t
  :defer t
  :if (equal ruby-version-manager 'rvm)
  :init
  (progn
    (setq rspec-use-rvm t)
    (dotemacs/add-to-hooks 'rvm-activate-corresponding-ruby
                           '(ruby-mode-hook enh-ruby-mode-hook))))

(use-package chruby
  :ensure t
  :if (equal ruby-version-manager 'chruby)
  :defer t
  :init
  (progn
    (defun dotemacs//enable-chruby ()
      "Enable chruby, use .ruby-version if exists."
      (let ((version-file-path (chruby--locate-file ".ruby-version")))
        (chruby)
        ;; try to use the ruby defined in .ruby-version
        (if version-file-path
            (progn
              (chruby-use (chruby--read-version-from-file
                           version-file-path))
              (message (concat "[chruby] Using ruby version "
                               "from .ruby-version file.")))
          (message "[chruby] Using the currently activated ruby."))))
    (dotemacs/add-to-hooks 'dotemacs//enable-chruby
                            '(ruby-mode-hook enh-ruby-mode-hook))))

(use-package enh-ruby-mode
  :if (when ruby-enable-enh-ruby-mode)
  :ensure t
  :mode (("\\(Rake\\|Thor\\|Guard\\|Gem\\|Cap\\|Vagrant\\|Berks\\|Pod\\|Puppet\\)file\\'" . enh-ruby-mode)
         ("\\.\\(rb\\|rabl\\|ru\\|builder\\|rake\\|thor\\|gemspec\\|jbuilder\\)\\'" . enh-ruby-mode))
  :interpreter "ruby"
  :config
  (progn
    (setq enh-ruby-deep-indent-paren nil
          enh-ruby-hanging-paren-deep-indent-level 2)))

(use-package ruby-mode
  :defer t
  :ensure t
  :mode "Puppetfile"
  :config
  (progn
    (dotemacs-set-leader-keys-for-major-mode 'ruby-mode
      "'" 'ruby-toggle-string-quotes
      "{" 'ruby-toggle-block)))

(use-package ruby-tools
  :defer t
  :ensure t
  :init
  (dolist (hook '(ruby-mode-hook enh-ruby-mode-hook))
    (add-hook hook 'ruby-tools-mode))
  :config
  (progn
    (dotemacs-hide-lighter ruby-tools-mode)
    (dolist (mode '(ruby-mode enh-ruby-mode))
      (dotemacs-declare-prefix-for-mode mode "mx" "ruby/text")
      (dotemacs-set-leader-keys-for-major-mode mode
        "x\'" 'ruby-tools-to-single-quote-string
        "x\"" 'ruby-tools-to-double-quote-string
        "x:" 'ruby-tools-to-symbol))))

(use-package bundler
  :defer t
  :ensure t
  :init
  (dolist (mode '(ruby-mode enh-ruby-mode))
    (dotemacs-declare-prefix-for-mode mode "mb" "ruby/bundle")
    (dotemacs-set-leader-keys-for-major-mode mode
      "bc" 'bundle-check
      "bi" 'bundle-install
      "bs" 'bundle-console
      "bu" 'bundle-update
      "bx" 'bundle-exec)))

(use-package projectile-rails
  :if (when dotemacs-ruby-enable-ruby-on-rails-support)
  :ensure t
  :defer t
  :init
  (progn
    (add-hook 'projectile-mode-hook 'projectile-rails-on))
  :config
  (progn
    (dotemacs-diminish projectile-rails-mode " ⇋" " RoR")
    ;; Find files
    (dolist (mode '(ruby-mode enh-ruby-mode))
      (dotemacs-set-leader-keys-for-major-mode mode
        "rfa" 'projectile-rails-find-locale
        "rfc" 'projectile-rails-find-controller
        "rfe" 'projectile-rails-find-environment
        "rff" 'projectile-rails-find-feature
        "rfh" 'projectile-rails-find-helper
        "rfi" 'projectile-rails-find-initializer
        "rfj" 'projectile-rails-find-javascript
        "rfl" 'projectile-rails-find-lib
        "rfm" 'projectile-rails-find-model
        "rfn" 'projectile-rails-find-migration
        "rfo" 'projectile-rails-find-log
        "rfp" 'projectile-rails-find-spec
        "rfr" 'projectile-rails-find-rake-task
        "rfs" 'projectile-rails-find-stylesheet
        "rft" 'projectile-rails-find-test
        "rfu" 'projectile-rails-find-fixture
        "rfv" 'projectile-rails-find-view
        "rfy" 'projectile-rails-find-layout
        "rf@" 'projectile-rails-find-mailer
        ;; Goto file
        "rgc" 'projectile-rails-find-current-controller
        "rgd" 'projectile-rails-goto-schema
        "rge" 'projectile-rails-goto-seeds
        "rgh" 'projectile-rails-find-current-helper
        "rgj" 'projectile-rails-find-current-javascript
        "rgg" 'projectile-rails-goto-gemfile
        "rgm" 'projectile-rails-find-current-model
        "rgn" 'projectile-rails-find-current-migration
        "rgp" 'projectile-rails-find-current-spec
        "rgr" 'projectile-rails-goto-routes
        "rgs" 'projectile-rails-find-current-stylesheet
        "rgt" 'projectile-rails-find-current-test
        "rgu" 'projectile-rails-find-current-fixture
        "rgv" 'projectile-rails-find-current-view
        "rgz" 'projectile-rails-goto-spec-helper
        "rg." 'projectile-rails-goto-file-at-point
        ;; Rails external commands
        "r:" 'projectile-rails-rake
        "rcc" 'projectile-rails-generate
        "ri" 'projectile-rails-console
        "rxs" 'projectile-rails-server
        ;; Refactoring 'projectile-rails-mode
        "rRx" 'projectile-rails-extract-region))
    ;; Ex-commands
    (evil-ex-define-cmd "A" 'projectile-toggle-between-implementation-and-test)))

(use-package robe                       ; Ruby backend for Emacs
  :defer t
  :ensure t
  :init
  (progn
    (dotemacs-register-repl 'robe 'robe-start "robe")
    (dolist (hook '(ruby-mode-hook enh-ruby-mode-hook))
      (add-hook hook 'robe-mode))
    (when (eq dotemacs-completion-engine 'company)
      (push 'company-robe company-backends-enh-ruby-mode)
      (push 'company-robe company-backends-ruby-mode)))
  :config
  (progn
    (dotemacs-hide-lighter robe-mode)
    (dolist (mode '(ruby-mode enh-ruby-mode))
      (dotemacs-declare-prefix-for-mode mode "mg" "ruby/goto")
      (dotemacs-declare-prefix-for-mode mode "mh" "ruby/docs")
      (dotemacs-declare-prefix-for-mode mode "ms" "ruby/repl")
      (dotemacs-set-leader-keys-for-major-mode mode
        "'" 'robe-start
        ;; robe mode specific
        "gg" 'robe-jump
        "hd" 'robe-doc
        "rsr" 'robe-rails-refresh
        ;; inf-enh-ruby-mode
        "sf" 'ruby-send-definition
        "sF" 'ruby-send-definition-and-go
        "si" 'robe-start
        "sr" 'ruby-send-region
        "sR" 'ruby-send-region-and-go
        "ss" 'ruby-switch-to-inf))))

(use-package yaml-mode                  ; YAML
  :ensure t
  :mode (("\\.\\(yml\\|yaml\\)\\'" . yaml-mode)
         ("Procfile\\'" . yaml-mode))
  :config (add-hook 'yaml-mode-hook
                    '(lambda ()
                       ; (electric-indent-local-mode -1)
                       (run-hooks 'prog-mode-hook)
                       (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

(when (eq dotemacs-completion-engine 'company)
  (dotemacs-use-package-add-hook company
    :post-init
    (add-hook 'yaml-mode-hook 'company-mode)))

(use-package feature-mode               ; Feature files for ecukes/cucumber
  :ensure t
  :if (when dotemacs-ruby-enable-ruby-on-rails-support)
  :mode ("\\.feature\\'" . feature-mode)
  :config
  (progn
    ;; Add standard hooks for Feature Mode, since it is no derived mode
    (add-hook 'feature-mode-hook #'whitespace-mode)
    (add-hook 'feature-mode-hook #'whitespace-cleanup-mode)
    (spell-checking/add-flyspell-hook 'feature-mode)))

(use-package rspec-mode
  :defer t
  :ensure t
  ;; there is no :init block to add the hooks since rspec-mode
  ;; setup the hook via an autoload
  :config
  (progn
    (dotemacs-hide-lighter rspec-mode)
    (dolist (mode '(ruby-mode enh-ruby-mode))
      (dotemacs-set-leader-keys-for-major-mode mode
        "ta" 'rspec-verify-all
        "tb" 'rspec-verify
        "tc" 'rspec-verify-continue
        "te" 'rspec-toggle-example-pendingness
        "tf" 'rspec-verify-method
        "tl" 'rspec-run-last-failed
        "tm" 'rspec-verify-matching
        "tr" 'rspec-rerun
        "tt" 'rspec-verify-single))))

(use-package rubocop
  :defer t
  :ensure t
  :init (dotemacs/add-to-hooks 'rubocop-mode '(ruby-mode-hook
                                               enh-ruby-mode-hook))
  :config
  (progn
    (dolist (mode '(ruby-mode enh-ruby-mode))
      (dotemacs-declare-prefix-for-mode mode "mrr" "ruby/RuboCop")
      (dotemacs-set-leader-keys-for-major-mode mode
        "rrd" 'rubocop-check-directory
        "rrD" 'rubocop-autocorrect-directory
        "rrf" 'rubocop-check-current-file
        "rrF" 'rubocop-autocorrect-current-file
        "rrp" 'rubocop-check-project
        "rrP" 'rubocop-autocorrect-project))))

(use-package ruby-test-mode
  :defer t
  :init
  (progn
    (defun dotemacs//ruby-enable-ruby-test-mode ()
      "Conditionally enable `ruby-test-mode'"
      (when (eq 'ruby-test ruby-test-runner)
        (ruby-test-mode)))
    (dotemacs/add-to-hooks
     'dotemacs//ruby-enable-ruby-test-mode '(ruby-mode-hook
                                              enh-ruby-mode-hook)))
  :config
  (progn
    (dotemacs-hide-lighter ruby-test-mode)
    (dolist (mode '(ruby-mode enh-ruby-mode))
      (dotemacs-set-leader-keys-for-major-mode mode
        "tb" 'ruby-test-run
        "tt" 'ruby-test-run-at-point))))

(use-package evil-matchit-ruby
  :ensure evil-matchit
  :config
  (progn
    (plist-put evilmi-plugins 'enh-ruby-mode '((evilmi-simple-get-tag evilmi-simple-jump)
                                               (evilmi-ruby-get-tag evilmi-ruby-jump)))))
(dotemacs-use-package-add-hook evil-matchit
  :post-init
  (dolist (hook '(ruby-mode-hook enh-ruby-mode-hook))
    (add-hook hook `turn-on-evil-matchit-mode)))

(dotemacs-use-package-add-hook flycheck
  :post-init
  (dolist (mode '(ruby-mode enh-ruby-mode))
    (dotemacs/add-flycheck-hook mode)))

(dotemacs-use-package-add-hook popwin
  :post-config
  (push '("*rspec-compilation*"    :dedicated t :position bottom :stick t :noselect t   :height 0.4)
        popwin:special-display-config))

(when (eq dotemacs-completion-engine 'company)
  (dotemacs-use-package-add-hook company
    :post-init
    (progn
      (dotemacs-add-company-hook enh-ruby-mode)
      (dotemacs-add-company-hook ruby-mode)

      (with-eval-after-load 'company-dabbrev-code
        (dolist (mode '(ruby-mode enh-ruby-mode))
          (push mode company-dabbrev-code-modes))))))

(dotemacs-use-package-add-hook smartparens
  :post-config
  (sp-with-modes (if ruby-enable-enh-ruby-mode 'enh-ruby-mode 'ruby-mode)
    (sp-local-pair
     "{" "}"
     :pre-handlers '(sp-ruby-pre-handler)
     :post-handlers '(sp-ruby-post-handler
                      (dotemacs-smartparens-pair-newline-and-indent "RET"))
     :suffix "")))

(provide 'module-ruby)
;;; module-ruby.el ends here