(require 'gpgkd906-util)

(defun php-key-set ()
  
  (file-get-contents var-template "~/.emacs.d/mylisp/template/php/var.php")
  (file-get-contents function-template "~/.emacs.d/mylisp/template/php/function.php")
  (file-get-contents class-template "~/.emacs.d/mylisp/template/php/class.php")
  (file-get-contents package-template "~/.emacs.d/mylisp/template/php/package.php")
  (file-get-contents dumpobj-template "~/.emacs.d/mylisp/template/php/dumpobj.php")
  (file-get-contents dumpvar-template "~/.emacs.d/mylisp/template/php/dumpvar.php")
  
  (mylisp-set-key "ESC <C-return>"
	      (setq objects (read-string "input object or class :"))
	      (insert (format dumpobj-template objects)))
	      
  (mylisp-set-key "M-RET"
	      (setq var-name (read-string "input vars :"))
	      (insert (format dumpvar-template var-name)))

  (mylisp-set-key "C-: C-p"
	      (setq var-name (read-string "auto generate var define, Input var name :"))
	      (insert (format var-template var-name var-name)))
  
  (mylisp-set-key "C-: C-o" 
	      (setq func-name (read-string "auto generate function define, Input function name :"))
	      (insert (format function-template func-name func-name)))

  (mylisp-set-key "C-: C-;"
	      (setq input (upcase-initials (read-string "class define, Input class name :")))
	      (setq extend (upcase-initials (read-string "input {ParentClassName} if Class extends from AnyClass, or enter else:")))
	      (setq class-tuple (split-string input "\\."))
	      (setq class-name (car (last class-tuple)))
	      (if (equal extend "")
		  (setq class-extend "")
		(setq class-extend (format "extends %s" extend))
		)
	      (setq class-namespace (replace-regexp-in-string (format ".%s$" class-name) "" input))
	      (insert (format package-template (upcase-initials class-namespace) (format-time-string "%Y") user-full-name (format-time-string "%Y") user-full-name))
	      (insert (format class-template class-name (format-time-string "%Y") user-full-name class-namespace class-name class-extend)))
  
  (mylisp-set-key "C-: C-:"
	      (let ((inputed-tuple (split-string (read-string "insert for (v[ar]/f[unc]/c[lass]/p[ackage])[:name]? ") ":")))
		(setq mode (car inputed-tuple))
		(setq name (cadr inputed-tuple))
		(cond ((null mode)
		       (message "nothing inputed!"))
		      ((equal mode "v")
		       (insert (format var-template name name)))
		      ((equal mode "f")
		       (insert (format function-template name name)))
		      ((equal mode "c")
		       (setq name (upcase-initials name))
		       (setq extend (read-string (format "input ParentClassName if Class:[ %s ] extends from Any Parent Class, else enter if not:" name)))
		       (setq class-tuple (split-string name "\\."))
		       (setq class-name (upcase-initials (car (last class-tuple))))
		       (if (equal extend "")
			   (setq class-extend "")
			 (setq class-extend (format "extends %s" extend))
			 )
		       (setq class-namespace (replace-regexp-in-string (format ".%s$" class-name) "" name))
		       (insert (format class-template name (format-time-string "%Y") user-full-name class-namespace class-name class-extend)))
		      ((equal mode "p")
		       (insert (format package-template (upcase-initials name) (format-time-string "%Y") user-full-name (format-time-string "%Y") user-full-name)))
		      (t nil))))

  )



(provide 'php-keyset)