;;; -*- Mode: LISP; Syntax: Common-lisp; Package: USER; Base: 10 -*-

(defun wload (&optional load-translations)
  (declare (arglist &optional load-translations))
  ;; (check-type host (member :beta :delta :eps :phi :eta))
  (setq si:*debug-info-mode* :COMPRESS)
  (setq rpc::*unix-check-passwords-for-show* nil)	; Do not ask for NFS Passwords
  (net:remote-login-on)
  (when (< si:*incremental-disk-save-extra-pages* 320)	; Symbolics Default of 200 is too small !!!
    (setq si:*incremental-disk-save-extra-pages* 320))
  (sys:gc-on :ephemeral t :dynamic nil)
  (fs:force-user-to-login)
  (when load-translations (load #P"SYS:SITE;SYS.TRANSLATIONS" :verbose nil))
  (load-patches nil :query nil :silent t)
  (macrolet ((ls (&rest systems)
	       (cons 'progn
		     (loop for system in systems
			   collect `(unless (sct:find-system-named ,system nil t)
				      (load-system ,system :query nil :silent t))))))
    ;; (select host ((:beta) (ls :mailer)))	; BETA is the MAIL server
    (ls :clx :clim :genera-clim :postscript-clim :clx-clim :clim-doc)	; Omit :CLIM-DEMO
    (ls :metering)
    (ls :conversion-tools)
    (ls :nfs-server)				; NFS-CLIENT, NFS-DOCUMENTATION are in 8.3 worlds
    (ls :x-remote-screen :x-documentation)	; already in Ivory world, never load X-SERVER 
    (ls :ux-support)				; :macivory-support 
    (ls :rpc-development :ux-development)	; :macivory-development 
    (ls :statice-runtime #-VLM :dbfs-utilities)	; Part of Genera distribution
    (ls :c :fortran :pascal)
    ;; Left from the time where Symbolics C was not free
    (load-system :harbison-steele-doc :query nil :silent t :component-version :released)
    ;; (select host ((:delta :phi :beta) (ls :pascal)))
    ;; DNA no longer used
    ;; (select host ((:delta :eps :phi) (ls :dna)))	; we have now 3 licenses
    ;; STATICE
    (ls :statice :statice-documentation)
    ;; CONCORDIA
    (progn
      (ls :concordia)				; contains LOCK-SIMPLE
      (setq si:gc-warning-threshold 4000000)
      (funcall (intern "LOAD-DOC-DATABASE-FOR-WRITER" (find-package "SAGE"))))
    ;; JOSHUA no longer used
    ;; (select host ((:eps) (ls :joshua :joshua-metering :joshua-doc)))	; omit JERICHO
    (ls :joshua :joshua-metering :joshua-doc)
    ;; MACSYMA will always be in an incremental world
    ;; other cleanups
    (si:enable-who-calls :all-no-make t)
    (values)))

(defun wform (&optional ltr)
  (declare (scl:arglist &optional load-translations))
  (let ((wform `(progn 
		  (wload  ,ltr)
		  (fundefine 'wload)
		  (fundefine 'wform)
		  (si:run-gc-cleanups)
		  (si:full-gc))))		; do not use SI:REORDER-MEMORY
    (fresh-line)
    (present wform 'sys:form)
    (values)))