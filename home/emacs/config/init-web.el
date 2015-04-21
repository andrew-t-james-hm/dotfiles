(lazy-major-mode "\\.coffee\\'" coffee-mode)
(lazy-major-mode "\\.jade$" jade-mode)


(after "js2-mode-autoloads"
  (require 'skewer-mode)
  (skewer-setup))


(require 'rainbow-mode)
(add-hook 'js2-mode-hook 'rainbow-mode)
(add-hook 'html-mode-hook 'rainbow-mode)
(add-hook 'web-mode-hook 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)
(add-hook 'stylus-mode-hook 'rainbow-mode)
(add-hook 'mustache-mode-hook 'rainbow-mode)
(add-hook 'handlebars-mode-hook 'rainbow-mode)


(defun my-emmet-mode ()
  (require 'emmet-mode)
  (emmet-mode))

(add-hook 'css-mode-hook 'my-emmet-mode)
(add-hook 'sgml-mode-hook 'my-emmet-mode)
(add-hook 'web-mode-hook 'my-emmet-mode)


(lazy-major-mode "\\.html?$" web-mode)


(after 'web-mode
  (after 'yasnippet
    (require 'angular-snippets)
    (angular-snippets-initialize)))


;; indent after deleting a tag
(defadvice sgml-delete-tag (after reindent activate)
  (indent-region (point-min) (point-max)))

(provide 'init-web)