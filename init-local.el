;;----------------------------------------------------------------------------
;; some details -- by misskanagi
;;----------------------------------------------------------------------------
;;个人信息
(setq user-full-name "misskanagi")

;;设置默认主模式 由于一些bug 现在暂时不将其设为主模式 2013-6-13
;;(setq default-major-mode 'org-mode)
;;时间显示设置
;;启用时间显示设置，在minibuffer上面的那个杠上
(display-time-mode 1)
;;时间使用24小时制
(setq display-time-24hr-format t)
;;时间显示包括日期和具体时间
(setq display-time-day-and-date t)
;;显示时间的格式
(setq display-time-format "%m月%d日%A%H:%M")
;fontsize 字体大小
(set-face-attribute 'default nil :height 120)
;中文字等宽、等高问题 经检测，未解决
(setq face-font-rescale-alist '(("微软雅黑" . 1.2) ("Microsoft Yahei" . 1.2) ("WenQuanYi Zen Hei" . 1.2)))
;启动emacs server
(server-mode 1)

;;改变emacs标题栏的标题
(setq frame-title-format "%b@misskanagi的E酱~")

;;允许emacs和外部其他程序的粘贴
(setq x-select-enable-clipboard t)

;;显示行号
(global-linum-mode)

;;tab缩进设置
(setq indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset 4)
(setq c-default-style "k&r")

;;指针不要闪，我得眼睛花了
(blink-cursor-mode -1)
(transient-mark-mode 1)

;;当指针到一个括号时，自动显示所匹配的另一个括号
(show-paren-mode 1)

;;鼠标自动避开指针，如当你输入的时候，指针到了鼠标的位置，鼠标有点挡住视线了
(mouse-avoidance-mode 'animate)

;;指针颜色
(add-hook 'window-setup-hook
	  '(lambda ()
	     (set-cursor-color "pink")))
(add-hook 'after-make-frame-functions
	  '(lambda (f) (with-selected-frame f (set-cursor-color "pink"))))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;C/C++
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'c++-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-hook
 (lambda ()
 (local-set-key (kbd "C-c sb") 'hs-show-block)
 (local-set-key (kbd "C-c hb") 'hs-hide-block)
 )
)
(add-hook 'c++-mode-hook
 (lambda ()
 (local-set-key (kbd "C-c sb") 'hs-show-block)
 (local-set-key (kbd "C-c hb") 'hs-hide-block)
 )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;set associated mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;My gtd config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun gtd ()
   (interactive)
   (find-file "~/.emacs.d/GTD/kanagi_gtd.org")
 )

(defun gtd-private ()
   (interactive)
   (find-file "~/.emacs.d/GTD/kanagi_private.org")
 )

;;call remember by using f12
(define-key global-map [f12] 'org-remember)

(setq org-agenda-files (list "~/.emacs.d/GTD/kanagi_gtd.org"
                             "~/.emacs.d/GTD/kanagi_private.org"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;org-mode check-box feature
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun wicked/org-update-checkbox-count (&optional all)
  "Update the checkbox statistics in the current section.
This will find all statistic cookies like [57%] and [6/12] and update
them with the current numbers.  With optional prefix argument ALL,
do this for the whole buffer."
  (interactive "P")
  (save-excursion
    (let* ((buffer-invisibility-spec (org-inhibit-invisibility))
	   (beg (condition-case nil
		    (progn (outline-back-to-heading) (point))
		  (error (point-min))))
	   (end (move-marker
		 (make-marker)
		 (progn (or (outline-get-next-sibling) ;; (1)
			    (goto-char (point-max)))
			(point))))
	   (re "\\(\\[[0-9]*%\\]\\)\\|\\(\\[[0-9]*/[0-9]*\\]\\)")
	   (re-box
	    "^[ \t]*\\(*+\\|[-+*]\\|[0-9]+[.)]\\) +\\(\\[[- X]\\]\\)")
	   b1 e1 f1 c-on c-off lim (cstat 0))
      (when all
	(goto-char (point-min))
	(or (outline-get-next-sibling) (goto-char (point-max))) ;; (2)
	(setq beg (point) end (point-max)))
      (goto-char beg)
      (while (re-search-forward re end t)
	(setq cstat (1+ cstat)
	      b1 (match-beginning 0)
	      e1 (match-end 0)
	      f1 (match-beginning 1)
	      lim (cond
		   ((org-on-heading-p)
		    (or (outline-get-next-sibling) ;; (3)
			(goto-char (point-max)))
		    (point))
		   ((org-at-item-p) (org-end-of-item) (point))
		   (t nil))
	      c-on 0 c-off 0)
	(goto-char e1)
	(when lim
	  (while (re-search-forward re-box lim t)
	    (if (member (match-string 2) '("[ ]" "[-]"))
		(setq c-off (1+ c-off))
	      (setq c-on (1+ c-on))))
	  (goto-char b1)
	  (insert (if f1
		      (format "[%d%%]" (/ (* 100 c-on)
					  (max 1 (+ c-on c-off))))
		    (format "[%d/%d]" c-on (+ c-on c-off))))
	  (and (looking-at "\\[.*?\\]")
	       (replace-match ""))))
      (when (interactive-p)
	(message "Checkbox statistics updated %s (%d places)"
		 (if all "in entire file" "in current outline entry")
		 cstat)))))
(defadvice org-update-checkbox-count (around wicked activate)
  "Fix the built-in checkbox count to understand headlines."
  (setq ad-return-value
	(wicked/org-update-checkbox-count (ad-get-arg 1))))
(global-set-key (kbd "C-c #") 'org-update-checkbox-count)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;about the remeber(notes)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "C-c r") 'remember)    ;; (1)
(add-hook 'remember-mode-hook 'org-remember-apply-template) ;; (2)
(setq org-remember-templates
      '((?n "* %U %?\n\n  %i\n  %a" "~/.emacs.d/notes/notes.org")))  ;; (3)
(setq remember-annotation-functions '(org-remember-annotation)) ;; (4)
(setq remember-handler-functions '(org-remember-handler)) ;; (5)

;;things done above
;;1: Handy keyboard shortcut for (r)emember
;;2: Creates a template for (n)otes
;;3: Create a note template which saves the note to ~/notes.org, or whichever Org file you want to use
;;4: Creates org-compatible context links
;;5: Saves remembered notes to an Org file

;;frame




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;git-emacs配置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(add-to-list 'load-path "~/.emacs.d/local-plugins/git-emacs/")
;;(require 'git-emacs)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;yasnippet配置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "~/.emacs.d/local-plugins/yasnippet"))
(require 'yasnippet)
(yas-global-mode 1)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;auctex配置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'init-auctex)
(require 'init-auto-complete-clang)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;w3m配置
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path (expand-file-name "~/.emacs.d/local-plugins/emacs-w3m"))
(require 'w3m-load)
(require 'w3m-e21)
(provide 'w3m-e23)
;;代理设置
(defvar ka-http-proxy "127.0.0.1:8087")
(defun ka-toggle-proxy (force)
  "Toggle proxy. With prefix, set proxy on."
  (interactive "P")
  (if (or force
          (not (getenv "http_proxy")))
      (progn
        (setenv "http_proxy" ka-http-proxy)
        (message "proxy set to %s" (getenv "http_proxy")))
    (setenv "http_proxy" nil)
    (message "proxy off"))) 

(setq w3m-use-favicon nil)
;;coding
 (setq w3m-coding-system 'utf-8
       w3m-file-coding-system 'utf-8
       w3m-file-name-coding-system 'utf-8
       w3m-input-coding-system 'utf-8
       w3m-output-coding-system 'utf-8
       w3m-terminal-coding-system 'utf-8)
;; 默认显示图片
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)
;; 使用cookies
(setq w3m-use-cookies t)
;;设定w3m运行的参数，分别为使用cookie和使用框架
(setq w3m-command-arguments '("-cookie" "-F"))
;; 使用w3m作为默认浏览器
(setq browse-url-browser-function 'w3m-browse-url)
(setq w3m-view-this-url-new-session-in-background t)
;;显示图标
(setq w3m-show-graphic-icons-in-header-line t)
(setq w3m-show-graphic-icons-in-mode-line t)
;;设置首页
;(setq w3m-home-page "www.google.com.hk")
;;set abbrev
;;(setq-default abbrev-mode t)
(setq save-abbrevs t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;language
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LANG
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
(set-file-name-coding-system 'utf-8)
(setq ansi-color-for-comint-mode t) ;;处理shell-mode乱码,好像没作用

;;(prefer-coding-system 'gb18030)
;;(prefer-coding-system 'utf-8)
(if (eq system-type 'windows-nt)
    (setq file-name-coding-system 'gbk))



(provide 'init-local)

