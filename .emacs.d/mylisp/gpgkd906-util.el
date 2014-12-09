(defmacro file-get-contents (var file)
  `(setq ,var 
	 (with-temp-buffer
	   (insert-file-contents ,file)
	   (buffer-string))))

(defmacro file-put-contents (content file)
  `(with-temp-file ,file (insert ,content)))

(defmacro mylisp-set-key (key-set &rest lambdas)
  `(global-set-key (kbd ,key-set) 
		   (lambda ()
		     (interactive)
		     ,@lambdas
		     )))

(defmacro package (target pname class-define)
  `(cond ((string= (symbol-name ,target) "php")
	  (require 'php-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines ""))
	 ((string= (symbol-name ,target) "js")
	  (require 'js-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines ""))
	 ((string= (symbol-name ,target) "python")
	  (require 'python-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines ""))
	 ((string= (symbol-name ,target) "ruby")
	  (require 'ruby-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines ""))
	 ((string= (symbol-name ,target) "cpp")
	  (require 'cpp-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines ""))
	 ((string= (symbol-name ,target) "golang")
	  (require 'golang-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines ""))
	 (t 
	  (require 'lisp-keyset)
	  (setq defines (list "<?php\n" (definePackage ,pname) (eval ,class-define)))
	  (mapconcat 'identity defines "")))
  )

(defun class (cname extend &rest rst)
  (setq body (mapconcat 'identity rst ""))
  (if (not extend)
      (setq extend ""))
  (defineClass cname extend body))

(defun vars (&rest names) (mapconcat 'defineProperty names ""))
(defun accessors (&rest names) (mapconcat 'defineAccessor names ""))
(defun methods (&rest names) (mapconcat 'defineFunction names ""))


(mylisp-set-key "C-: <C-return>" 
		(setq file (car (find-file-read-args "Expand to which file : /" nil)))
		(setq current-content (buffer-string))
		(with-temp-file file
		  (defun reload (begin end length) (find-file file))
		  (if (fboundp 'make-local-hook)
		      (make-local-hook 'after-change-functions))
		  (add-hook 'after-change-functions 'reload nil t)
		  (insert (eval (read current-content)))))

(provide 'gpgkd906-util)
