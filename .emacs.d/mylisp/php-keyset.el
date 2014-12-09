(require 'gpgkd906-util)

(defun defineProperty (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate var define, Input var name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/var.php"))
  (setq tuple (split-string name))
  (mapconcat 'identity 
	     (mapcar '(lambda (var) (format template var var)) tuple) ""))

(defun defineAccessor (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate accessor define, Input accessor name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/accessor.php"))
  (setq tuple (split-string name))
  (mapconcat 'identity 
	     (mapcar '(lambda (name) 
			(setq upname (upcase-initials name))
			(format template name name name name upname name name name name upname name)) tuple) ""))

(defun defineFunction (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate function define, Input function name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/function.php"))
  (setq tuple (split-string name))
  (mapconcat 'identity 
	     (mapcar '(lambda (func) (format template func func)) tuple) ""))

(defun defineClass (&rest args)
  (if (not (setq name (car args)))
      (setq name (upcase-initials (read-string "class define, Input class name :"))))
  (if (not (setq extend (cadr args)))
      (setq extend (upcase-initials (read-string "input {ParentClassName} if Class extends from AnyClass, or enter else:"))))
  (if (not (setq classbody (caddr args)))
      (setq classbody " "))
  (if (not (setq template (cadddr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/class.php"))
  (if (not (setq packTemplate (cadddr (cdr args))))
      (file-get-contents packTemplate "~/.emacs.d/mylisp/template/php/package.php"))  
  (setq class-tuple (split-string name "\\."))
  (setq class-name (car (last class-tuple)))
  (if (equal extend "")
      (setq class-extend "")
    (setq class-extend (format "extends %s" extend)))
  (setq class-namespace (replace-regexp-in-string (format ".%s$" class-name) "" name))
  (format template class-name (format-time-string "%Y") user-full-name class-namespace class-name class-extend classbody))

(defun definePackage (&rest args) 
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate package define, Input package name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/package.php"))
  (format template (upcase-initials name) (format-time-string "%Y") user-full-name (format-time-string "%Y") user-full-name))

(defun php-key-set ()
  
  (file-get-contents var-template "~/.emacs.d/mylisp/template/php/var.php")
  (file-get-contents function-template "~/.emacs.d/mylisp/template/php/function.php")
  (file-get-contents class-template "~/.emacs.d/mylisp/template/php/class.php")
  (file-get-contents package-template "~/.emacs.d/mylisp/template/php/package.php")
  (file-get-contents dumpobj-template "~/.emacs.d/mylisp/template/php/dumpobj.php")
  (file-get-contents dumpvar-template "~/.emacs.d/mylisp/template/php/dumpvar.php")
  (file-get-contents accessor-template "~/.emacs.d/mylisp/template/php/accessor.php")
  
  (mylisp-set-key "ESC <C-return>"
	      (setq objects (read-string "input object or class :"))
	      (insert (format dumpobj-template objects)))
	      
  (mylisp-set-key "M-RET"
	      (setq var-name (read-string "input vars :"))
	      (insert (format dumpvar-template var-name)))
  
  (mylisp-set-key "C-: C-p" (insert (defineProperty nil var-template)))
  
  (mylisp-set-key "C-: C-o" (insert (defineFunction nil function-template)))

  (mylisp-set-key "C-: C-a" (insert (defineAccessor nil accessor-template)))
  
  (mylisp-set-key "C-: C-;" (insert (defineClass nil nil nil class-template package-template)))
  
  (mylisp-set-key "C-: C-:"
	      (let ((inputed-tuple (split-string (read-string "insert for (v[ar]/a[ccessor]/f[unc]/c[lass]/p[ackage])[:name]? ") ":")))
		(setq mode (car inputed-tuple))
		(setq name (cadr inputed-tuple))
		(cond ((null name)
		       ;default: defClass
		       (setq name mode)
		       (insert (definePackage name package-template))
		       (insert (defineClass name nil nil class-template package-template)))
		      ((equal mode "v")
		       (insert (defineProperty name var-template)))
		      ((equal mode "f")
		       (insert (defineFunction name function-template)))		       
		      ((equal mode "a")
		       (insert (defineAccessor name accessor-template)))
		      ((equal mode "c")
		       (insert (definePackage name package-template))
		       (insert (defineClass name nil nil class-template package-template)))
		      ((equal mode "p")
		       (insert (definePackage name package-template)))
		      (t nil))))
  
  )

(provide 'php-keyset)
