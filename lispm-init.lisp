;;; -*- Mode: LISP; Syntax: Common-lisp; Package: COMMON-LISP-USER; Base: 10 -*-

(in-package :cl-user)

(cond ((fboundp 'mbb-fs-init)
       (mbb-fs-init))
      (t
       (login-forms
	 (setq cp:*prompt* 'si:arrow-prompt))))

(login-forms
  ;; (setq cp:*prompt* 'si:arrow-prompt)		; done in HOME-SITE
  (setf (sys:standard-value '*print-structure-contents*) nil)
  (setq *print-structure-contents* nil)
  (setf (sys:standard-value '*print-level*) 8)
  (setq *print-level* 8)
  (setf (sys:standard-value '*print-length*) 15)
  (setq *print-length* 15)
  (setq RPC::*UNIX-CHECK-PASSWORDS-FOR-SHOW* nil))

(mapcar 'load '(#P"SYS:SITE;SYS.TRANSLATIONS" #P"SYS:SITE;LMFS.TRANSLATIONS"))

(si:turn-on-lisp-syntax :ansi-common-lisp)
