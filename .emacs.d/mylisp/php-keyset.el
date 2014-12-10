(require 'gpgkd906-util)

(defun defineProperty (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate var define, Input var name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/var.php"))
  (setq tuple (split-string name))
  (join "" (mapcar '(lambda (var) (format template var var)) tuple)))

(defun defineAccessor (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate accessor define, Input accessor name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/accessor.php"))
  (setq tuple (split-string name))
  (join ""  (mapcar '(lambda (name) 
		       (setq upname (upcase-initials name))
		       (format template name name name name upname name name name name upname name)) tuple)))

(defun defineFunction (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate function define, Input function name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/function.php"))
  (setq tuple (split-string name))
  (join "" (mapcar '(lambda (func) (format template func func)) tuple)))

(defun defineInjection (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate injection define, Input injector name :")))
  (if (not (setq actions (cadr args)))
      (setq actions (read-string "auto generate injection define, Input actions:")))
  (if (not (setq template (caddr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/injection.php"))
  (if (not (setq accessor-template (cadddr args)))
      (file-get-contents accessor-template "~/.emacs.d/mylisp/template/php/accessor.php"))
  (setq uname (upcase-initials name))
  (setq injection-list (mapcar 
			'(lambda (action) (format template action uname action))
			(split-string actions)))
  (join "" (append (list (defineAccessor name accessor-template)) injection-list)))

(defun defineCrud (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate crud-function define, Input function name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/crud.php"))
  (setq tuple (split-string name))
  (join "" (mapcar '(lambda (func) 
		      (setq func (upcase-initials func)) 
		      (format template func func func func)) tuple)))

(defun defineClass (&rest args)
  (if (not (setq name (car args)))
      (setq name (upcase-initials (read-string "class define, Input class name :"))))
  (if (not (setq extend (cadr args)))
      (setq extend (upcase-initials (read-string "input {ParentClassName} if Class extends from AnyClass, or enter else:"))))
  (if (not (setq classbody (caddr args)))
      (setq classbody " "))
  (if (not (setq template (cadddr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/class.php"))
  (setq class-tuple (split-string name "\\."))
  (setq class-name (car (last class-tuple)))
  (if (equal extend "")
      (setq class-extend "")
    (setq class-extend (format "extends %s" extend)))
  (format template class-name (format-time-string "%Y") user-full-name class-name class-extend classbody))

(defun defineRequire (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate require define, Input require name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/require.php"))
  (setq tuple (split-string name))
  (join "" (mapcar '(lambda (var) (format template var)) tuple)))

(defun defineUsePackage (&rest args)
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate use-package define, Input package name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/use.php"))
  (setq name (replace-regexp-in-string "\s*>\s*" ">" name))
  (setq name (replace-regexp-in-string "\s*as\s*" ">" name))
  (setq tuple (split-string name))
  (join "" (mapcar '(lambda (var) (format template (replace-regexp-in-string ">" " as " var))) tuple)))

(defun definePackage (&rest args) 
  (if (not (setq name (car args)))
      (setq name (read-string "auto generate package define, Input package name :")))
  (if (not (setq template (cadr args)))
      (file-get-contents template "~/.emacs.d/mylisp/template/php/package.php"))
  (setq name (upcase-initials name))
  (setq year (format-time-string "%Y"))
  (format template name year user-full-name year user-full-name name))

(defun php-key-set ()
  
  (file-get-contents var-template "~/.emacs.d/mylisp/template/php/var.php")
  (file-get-contents function-template "~/.emacs.d/mylisp/template/php/function.php")
  (file-get-contents class-template "~/.emacs.d/mylisp/template/php/class.php")
  (file-get-contents package-template "~/.emacs.d/mylisp/template/php/package.php")
  (file-get-contents dumpobj-template "~/.emacs.d/mylisp/template/php/dumpobj.php")
  (file-get-contents dumpvar-template "~/.emacs.d/mylisp/template/php/dumpvar.php")
  (file-get-contents accessor-template "~/.emacs.d/mylisp/template/php/accessor.php")
  (file-get-contents crud-template "~/.emacs.d/mylisp/template/php/crud.php")
  (file-get-contents injection-template "~/.emacs.d/mylisp/template/php/injection.php")
  
  (mylisp-set-key "ESC <C-return>"
	      (setq objects (read-string "input object or class :"))
	      (insert (format dumpobj-template objects)))
	      
  (mylisp-set-key "M-RET"
	      (setq var-name (read-string "input vars :"))
	      (insert (format dumpvar-template var-name)))
  
  (mylisp-set-key "C-: C-p" (insert (defineProperty nil var-template)))
  
  (mylisp-set-key "C-: C-o" (insert (defineFunction nil function-template)))
  
  (mylisp-set-key "C-: C-u" (insert (defineCrud nil crud-template)))

  (mylisp-set-key "C-: C-a" (insert (defineAccessor nil accessor-template)))
  
  (mylisp-set-key "C-: C-;" (insert (defineClass nil nil nil class-template)))

  (mylisp-set-key "C-: C-s" (insert (defineInjection nil nil injection-template accessor-template)))
  
  (mylisp-set-key "C-: C-:"
	      (let ((inputed-tuple (split-string (read-string "insert for (v[ar]/a[ccessor]/f[unc]/c[lass]/p[ackage]/crud/inject)[:name]? ") ":")))
		(setq mode (car inputed-tuple))
		(setq name (cadr inputed-tuple))
		(cond ((null name)
		       ;default: defClass
		       (setq name mode)
		       (insert (definePackage name package-template))
		       (insert (defineClass name nil nil class-template)))
		      ((equal mode "v")
		       (insert (defineProperty name var-template)))
		      ((equal mode "f")
		       (insert (defineFunction name function-template)))		       
		      ((equal mode "crud")
		       (insert (defineCrud name crud-template)))
		      ((equal mode "a")
		       (insert (defineAccessor name accessor-template)))
		      ((equal mode "inject")
		       (insert (defineInjection name nil injection-template accessor-template)))
		      ((equal mode "c")
		       (insert (definePackage name package-template))
		       (insert (defineClass name nil nil class-template)))
		      ((equal mode "p")
		       (insert (definePackage name package-template)))
		      (t nil))))
  
  )

(provide 'php-keyset)
