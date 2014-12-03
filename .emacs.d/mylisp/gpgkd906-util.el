(defmacro file-get-contents (var file)
  `(setq ,var 
	 (with-temp-buffer
	   (insert-file-contents ,file)
	   (buffer-string))))

(defmacro mylisp-set-key (key-set &rest lambdas)
  `(global-set-key (kbd ,key-set) 
		   (lambda ()
		     (interactive)
		     ,@lambdas
		     )))

(provide 'gpgkd906-util)