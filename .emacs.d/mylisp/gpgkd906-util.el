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

(defmacro package (pname class-define)
  (setq defines (list "<?php\n" (defPackage pname) (eval class-define)))
  (insert (mapconcat 'identity defines "")))

(defun class (cname extend &rest rst)
  (setq body (mapconcat 'identity rst ""))
  (if (not extend)
      (setq extend ""))
  (defClass cname extend body))

(defun vars (&rest names) (mapconcat 'defVar names ""))
(defun accessors (&rest names) (mapconcat 'defAccessor names ""))
(defun methods (&rest names) (mapconcat 'defFunc names ""))


(mylisp-set-key "C-: <C-return>" 
		(setq mode (read-string "expand to which program-language?[php/js] :"))
		(setq file (car (find-file-read-args "Expand to which file : /" nil)))
		(setq current-content (buffer-string))
		(with-temp-file file
		  (defun reload (begin end length) (find-file file))
		  (make-local-hook 'after-change-functions)
		  (add-hook 'after-change-functions 'reload nil t)
		  (cond ((string= mode "php")
			 (require 'php-keyset)
			 (eval (read current-content)))
			((string= mode "js")
			 (insert "js-mode"))
			(t nil))))

(provide 'gpgkd906-util)
