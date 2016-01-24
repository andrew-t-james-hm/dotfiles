(defun dotemacs-fold-overlay (ov)
  (when (eq 'code (overlay-get ov 'hs))
    (let ((col (save-excursion
                 (move-end-of-line 0)
                 (current-column)))
          (count (count-lines (overlay-start ov) (overlay-end ov))))
      (overlay-put ov 'after-string
                   (format "%s [ %d ] … "
                           (make-string (- (window-width) col 32) (string-to-char "."))
                           count)))))

(defun dotemacs-local-comment-auto-fill ()
  (set (make-local-variable 'comment-auto-fill-only-comments) t))

;; required for evil folding
(defun dotemacs-enable-hs-minor-mode ()
  "Enable hs-minor-mode for code folding."
  (ignore-errors
    (hs-minor-mode)
    (dotemacs-hide-lighter hs-minor-mode)))

(defun dotemacs-highlight-TODO-words ()
  "Highlight keywords in comments."
  (interactive)
  (font-lock-add-keywords
   nil '(("\\<\\(\\(FIX\\(ME\\)?\\|BUG\\|CHECK\\|DONE\\|TODO\\|OPTIMIZE\\|HACK\\|REFACTOR\\):?\\)"
          1 font-lock-warning-face t))))

;; To augment and/or counteract these defaults your own function
;; to dotemacs-prog-mode-hook, using:
;;
;; (add-hook 'dotemacs-prog-mode-hook 'dotemacs-prog-mode-defaults t)
;;
;; (the final optional t sets the *append* argument)

(defun dotemacs-prog-mode-defaults ()
  "Default coding hook, useful with any programming language."

  (when spell-checking-enable-by-default
    (flyspell-prog-mode))

  ;; Underscore "_" is now a word character in programming mode
  (modify-syntax-entry ?_ "w")
  (unless (bound-and-true-p my-pmh-ran)
    ;; add buffer-local indicator for whether prog-mode-hook has run.
    (set (make-local-variable 'my-pmh-ran) t)

    (when dotemacs-show-trailing-whitespace
      (set-face-attribute 'trailing-whitespace nil
                          :background (face-attribute 'font-lock-comment-face
                                                      :foreground))
      (setq show-trailing-whitespace 1))

    ;; disable line wrap
    (unless (bound-and-true-p truncate-lines)
      ; (set (make-local-variable 'truncate-lines) t)
      (setq truncate-lines t))

    ;; enable line number-mode
    (when dotemacs-line-numbers
      (unless (bound-and-true-p linum-mode)
        (linum-mode)))

    (when (bound-and-true-p visual-line-mode)
      (setq visual-line-mode nil))

    ; TODO: Check and disable visual-fill-column-mode
    ; (when (bound-and-true-p visual-fill-column-mode)
    ;   (visual-fill-column-mode--disable))

    ; (smartparens-mode +1)

    ; how-to-check-whether-a-minor-mode-e-g-flymake-mode-is-on
    ; http://stackoverflow.com/questions/10088168/
    ; however, hs-minor-mode already set in `init.el`
    ; (unless (bound-and-true-p hs-minor-mode)
    ;   (hs-minor-mode t))
    (dotemacs-enable-hs-minor-mode)
    (dotemacs-local-comment-auto-fill)
    (dotemacs-highlight-TODO-words)))

(provide 'init-programming)
;;; init-programming.el ends here
