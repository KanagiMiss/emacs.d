;;;init pyflakes
(require-package 'flycheck-pyflakes)

(require 'flycheck-pyflakes)
(add-hook 'python-mode-hook 'flycheck-mode)
;;;disable other checkers
(add-to-list 'flycheck-disabled-checkers 'python-flake8)
(add-to-list 'flycheck-disabled-checkers 'python-pylint)

(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
		("SConscript\\'" . python-mode))
              auto-mode-alist))

<<<<<<< HEAD
=======
(require-package 'pip-requirements)


>>>>>>> purcell/master
(provide 'init-python-mode)
