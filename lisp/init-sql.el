(require-package 'sql-indent)
(eval-after-load 'sql
  '(load-library "sql-indent"))

(eval-after-load 'sql
  '(when (package-installed-p 'dash-at-point)
     (defun sanityinc/maybe-set-dash-db-docset ()
        (when (eq sql-product 'postgres)
          (setq dash-at-point-docset "psql")))

     (add-hook 'sql-mode-hook 'sanityinc/maybe-set-dash-db-docset)
     (add-hook 'sql-interactive-mode-hook 'sanityinc/maybe-set-dash-db-docset)
     (defadvice sql-set-product (after set-dash-docset activate)
       (sanityinc/maybe-set-dash-db-docset))))

<<<<<<< HEAD
=======
    (add-hook 'sql-mode-hook 'sanityinc/maybe-set-dash-db-docset)
    (add-hook 'sql-interactive-mode-hook 'sanityinc/maybe-set-dash-db-docset)
    (defadvice sql-set-product (after set-dash-docset activate)
      (sanityinc/maybe-set-dash-db-docset))))

(setq-default sql-input-ring-file-name
              (expand-file-name ".sqli_history" user-emacs-directory))

;; See my answer to https://emacs.stackexchange.com/questions/657/why-do-sql-mode-and-sql-interactive-mode-not-highlight-strings-the-same-way/673
(defun sanityinc/font-lock-everything-in-sql-interactive-mode ()
  (unless (eq 'oracle sql-product)
    (sql-product-font-lock nil nil)))
(add-hook 'sql-interactive-mode-hook 'sanityinc/font-lock-everything-in-sql-interactive-mode)


(after-load 'page-break-lines
  (push 'sql-mode page-break-lines-modes))
>>>>>>> purcell/master

(provide 'init-sql)
