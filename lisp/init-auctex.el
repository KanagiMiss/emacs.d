;(add-to-list 'load-path "~/.emacs.d/local-plugins/auctex-11.87/")
;(add-to-list 'load-path "~/.emacs.d/local-plugins/auctex-11.87/preview")
;(add-to-list 'load-path "~/.emacs.d/local-plugins/auto-complete-auctex/")
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)
(require-package 'auctex)
(require-package 'auto-complete-auctex)
(load "auctex.el" nil t t)
(require 'preview)
(if (string-equal system-type "windows-nt")
     (require 'tex-mik))
;;auto-completion
(require 'auto-complete-auctex)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(mapc (lambda (mode)
        (add-hook 'LaTeX-mode-hook mode))
      (list 'auto-fill-mode
            'LaTeX-math-mode
            'turn-on-reftex
;;          'visual-line-mode
            'flyspell-mode))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq TeX-auto-untabify t     ; remove all tabs before saving
                  TeX-engine 'xetex       ; use xelatex default
                  TeX-show-compilation t) ; display compilation windows
            (TeX-global-PDF-mode t)       ; PDF mode enable, not plain
            (setq TeX-save-query nil)
            (imenu-add-menubar-index)
            (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)))




(provide 'init-auctex)
