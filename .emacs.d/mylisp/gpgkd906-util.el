(defmacro join (sperate lst)
  `(mapconcat 'identity ,lst ,sperate))

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

(defmacro ml-package (target pname &rest body-define)
  `(let ((name (symbol-name ,target))
	 (defines nil))
     (cond ((string= name "php") 
	    (require 'php-keyset) (setq defines (cons "<?php\n" (list (definePackage ,pname)))))
	   ((string= name "js") (require 'js-keyset))
	   ((string= name "py") (require 'python-keyset))
	   ((string= name "rb") (require 'ruby-keyset))
	   ((string= name "cpp") (require 'cpp-keyset))
	   ((string= name "go") (require 'golang-keyset))
	   (t (require 'lisp-keyset)))
     (setq defines (append defines (mapcar #'(lambda (define) (eval define)) ',body-define)))
     (join "" defines)))

(defun ml-class (cname extend &rest rst)
  (setq body (join "" rst))
  (if (not extend)
      (setq extend ""))
  (defineClass cname extend body))

(defun ml-properties (&rest names) (mapconcat 'defineProperty names ""))
(defun ml-accessors (&rest names) (mapconcat 'defineAccessor names ""))
(defun ml-methods (&rest names) (mapconcat 'defineFunction names ""))
(defun ml-cruds (&rest names) (mapconcat 'defineCrud names ""))
(defun ml-use-package (&rest names) (mapconcat 'defineUsePackage names ""))
(defun ml-require (&rest names) (mapconcat 'defineRequire names ""))
(defun ml-injections (&rest injections) 
  (mapconcat 
   '(lambda (injection) (apply 'defineInjection injection)) injections ""))
  
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
