(defun locale-is-utf8-p ()
  "Return t iff the \"locale\" command or environment variables prefer UTF-8."
  (flet ((is-utf8 (v) (and v (string-match "UTF-8" v))))
    (or (is-utf8 (and (executable-find "locale") (shell-command-to-string "locale")))
        (is-utf8 (getenv "LC_ALL"))
        (is-utf8 (getenv "LC_CTYPE"))
        (is-utf8 (getenv "LANG")))))

(when (or window-system (locale-is-utf8-p))
  (setq utf-translate-cjk-mode nil) ; disable CJK coding/encoding (Chinese/Japanese/Korean characters)
  (set-language-environment 'utf-8)
  (when *is-carbon-emacs*
    (set-keyboard-coding-system 'utf-8-mac))
  (setq locale-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (unless (eq system-type 'windows-nt)
    (set-selection-coding-system 'utf-8))
  (prefer-coding-system 'utf-8))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;language
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LANG
(if (eq system-type 'windows-nt)
    (progn
      (set-language-environment 'chinese-gbk)
      (set-keyboard-coding-system 'utf-8)
      (set-clipboard-coding-system 'chinese-gbk)
      (set-terminal-coding-system 'utf-8)
      (set-buffer-file-coding-system 'chinese-gbk)
      (set-default-coding-systems 'chinese-gbk)
      (set-selection-coding-system 'chinese-gbk)
      (modify-coding-system-alist 'process "*" 'utf-8)
      (setq default-process-coding-system '(utf-8 . utf-8))
      (setq-default pathname-coding-system 'utf-8)
      (setq file-name-coding-system 'gbk)
      (setq ansi-color-for-comint-mode t) ;;处理shell-mode乱码,好像没作用
      ;;(prefer-coding-system 'gb18030)
      ;;(prefer-coding-system 'utf-8)
      )
  )


(provide 'init-locales)
