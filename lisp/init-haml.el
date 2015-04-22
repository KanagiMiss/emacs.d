<<<<<<< HEAD
(add-hook 'haml-mode-hook 'flymake-haml-load)
=======
(require-package 'haml-mode)

(after-load 'haml-mode
  (define-key haml-mode-map (kbd "C-o") 'open-line))
>>>>>>> purcell/master

(provide 'init-haml)
