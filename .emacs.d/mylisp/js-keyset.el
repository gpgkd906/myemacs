(require 'gpgkd906-util)

(defun js-key-set () 

  (file-get-contents var-template "~/.emacs.d/mylisp/template/js/var.js")
  (file-get-contents function-template "~/.emacs.d/mylisp/template/js/function.js")
  (file-get-contents module-template "~/.emacs.d/mylisp/template/js/module.js")
  (file-get-contents dumpobj-template "~/.emacs.d/mylisp/template/js/dumpobj.js")
  (file-get-contents dumpvar-template "~/.emacs.d/mylisp/template/js/dumpvar.js")
  
  (mylisp-set-key "ESC <C-return>"
		  (setq object-name (read-string "input object name :"))
		  (insert (format dumpobj-template object-name object-name object-name object-name)))
  
  (mylisp-set-key "M-RET"
		  (setq objects (read-string "input objects :"))
		  (insert (format dumpvar-template objects)))

  (mylisp-set-key "C-: C-p"
		  (setq var-name (read-string "auto generate var define, Input var name :"))
		  (insert (format var-template var-name var-name)))

  (mylisp-set-key "C-: C-o"
		  (setq func-name (read-string "auto generate function define, Input function name :"))
		  (insert (format function-template func-name func-name)))

  (mylisp-set-key "C-: C-;"
		  (setq name (read-string "module define, Input module name :"))
		  (setq extend (upcase-initials (read-string "input {ParentModuleName} if Class extends from AnyModule, or enter else:")))
		  (if (equal extend "")
		      (setq extend "//extend = null")
		    (setq extend (format "extend: %s" extend)))
		  (insert (format module-template name (format-time-string "%Y") user-full-name (upcase-initials name) extend (upcase-initials name) (upcase-initials name))))

  (mylisp-set-key "C-: C-:"
		  (let ((inputed-tuple (split-string (read-string "insert for (v[ar]/f[unc]/m[odule])[:name]? ") ":")))
		    (setq mode (car inputed-tuple))
		    (setq name (cadr inputed-tuple))
		    (cond ((null mode)
			   (print "error: undefined mode"))
			  ((equal mode "v")
			   (insert (format var-template name name)))
			  ((equal mode "f")
			   (insert (format function-template name name)))
			  ((equal mode "m")
			   (setq extend (upcase-initials (read-string "input {ParentModuleName} if Class extends from AnyModule, or enter else:")))
			   (if (equal extend "")
			       (setq extend "//extend = null")
			     (setq extend (format "extend: %s" extend)))
			   (insert (format module-template name (format-time-string "%Y") user-full-name (upcase-initials name) extend (upcase-initials name) (upcase-initials name))))
			  (t nil))))
  )

(provide 'js-keyset)