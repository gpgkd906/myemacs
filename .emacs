;;about myself
(setq
 user-full-name "Chen Han"
 user-mail-address "gpgkd906@gmail.com"
 company-mail-address ""
 user-mybin "~/mybin/"
 github-account "gpgkd906"
 ;do we have org-mode?
 org-log-done 'time
 )
;;check link -P
(setq inferior-lisp-program "gcl")
(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path (expand-file-name "mylisp" user-emacs-directory))
;;myconfig
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(autoload 'zephir-mode "zephir-mode" "Major mode for editing zephir code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.phtml$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.zep$" . zephir-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(require 'gpgkd906-util)
;;install-elisp
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/")
;;enable sqlite support
(require 'sqlite)
;;extend my php-keyset
(add-hook 'php-mode-hook 
	  (lambda ()
	    ;;php-autocomplete
	    (require 'php-completion)
	    (php-completion-mode t)
	    (define-key php-mode-map (kbd "C-o") 'phpcmp-complete)
	    (when (require 'auto-complete nil t)
	      (make-variable-buffer-local 'ac-sources)
	      (add-to-list 'ac-sources 'ac-source-php-completion)
	      (auto-complete-mode t))
	    (require 'php-keyset)
	    (php-key-set)
	    ))
;;extend my js-keyset
(add-hook 'js-mode-hook
	  ;;keyset for jsduck
	  (lambda ()
	    (require 'auto-complete)
	    (auto-complete-mode t)
	    (require 'js-keyset)
	    (js-key-set)
	    ))

(setq tab-width 4)
(setq indent-tabs-mode t)
(setq c-basic-offset 4)
(c-set-offset 'case-label' 4)
(c-set-offset 'arglist-intro' 4)
(c-set-offset 'arglist-cont-nonempty' 4)
(set-background-color "black")
(set-foreground-color "white")
(set-face-foreground 'region "green")
(set-face-background 'region "blue")
(set-default-font "Monospace 12")
