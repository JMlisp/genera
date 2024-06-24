;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function NET:GET-TIME-FROM-NETWORK:  Add arg to prevent broadcast.
;;; SETQ TIME:*INITIALIZE-TIMEBASE-FROM-CALENDAR-CLOCK*:  Set T to prefer calendar clock over network.
;;; Function TIME:INITIALIZE-TIMEBASE:  Avoid asking the user for time while booting.
;;; Written by BB, 9/05/08 22:03:17
;;; while running on Venus from FEP7:>symbolics1a.ilod.1
;;; with Genera 8.3, Logical Pathnames Translation Files NEWEST, CLIM 66.5,
;;; Genera CLIM 66.0, CLX CLIM 66.0, PostScript CLIM 66.2, CLIM Documentation 66.0,
;;; Metering 439.0, Metering Substrate 439.0, Conversion Tools 430.0,
;;; NFS Server 435.0, Statice Runtime 460.4, DBFS Utilities 439.0, C 437.0,
;;; Lexer Runtime 435.0, Lexer Package 435.0, Minimal Lexer Runtime 436.0,
;;; Lalr 1 431.0, Context Free Grammar 436.0, Context Free Grammar Package 436.0,
;;; C Runtime 435.0, Compiler Tools Package 431.0, Compiler Tools Runtime 431.0,
;;; C Packages 433.0, Syntax Editor Runtime 431.0, C Library Headers 431,
;;; Compiler Tools Development 432.0, Compiler Tools Debugger 431.0,
;;; Experimental C Documentation 423.0, Syntax Editor Support 431.0,
;;; LL-1 support system 435.0, Experimental Harbison Steele Doc 425.0,
;;; Experimental Hardcopy Restriction 420.0, Statice 460.1, Statice Browser 460.0,
;;; Statice Documentation 423.0, Symbolics Concordia 439.1, Image Substrate 435.0,
;;; Essential Image Substrate 427.0, Graphic Editor 435.0, Graphic Editing 436.0,
;;; Bitmap Editor 436.0, Graphic Editing Documentation 429.0, Postscript 431.0,
;;; Concordia Documentation 429.0, Lock Simple 432.0, Joshua 237.3,
;;; Joshua Metering 206.0, Joshua Documentation 216.0,
;;; Ivory Revision 4A (FPA enabled), FEP 333, FEP7:>I333-loaders.flod(4),
;;; FEP7:>I333-info.flod(4), FEP7:>I333-debug.flod(4), FEP7:>I333-lisp.flod(4),
;;; FEP7:>I333-kernel.fep(4), Boot ROM version 316, Device PROM version 325,
;;; 1067x748 B&W Screen, Machine serial number 1061,
;;; Prepare Background VLM (from VENUS:>special>merlin-as-domino.lisp.1),
;;; Merlin II Patch 2 (from VENUS:>special>merlin-ii-patch-2.lisp.1),
;;; Genera 8 3 y2k patches (from VENUS:>special>y2k.lisp.1).


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:NETWORK;PROTOCOLS.LISP.134"
  "SYS:IO1;TIME.LISP.195")


(SCT:NOTE-PRIVATE-PATCH "Avoid asking for time")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:NETWORK;PROTOCOLS.LISP.134")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Package: NETWORK-INTERNALS; Base: 10 -*-")

;;; This is called by TIME:INITIALIZE-TIMEBASE.
(DEFUN GET-TIME-FROM-NETWORK (&optional dont-broadcast)
  ;; We assume that if a broadcast fails, the network is probably broken and
  ;; there is no point in slowly polling every host we might know about that
  ;; support time service.
  (BLOCK GET-TIME-FROM-NETWORK
    (LET (SERVICES MULTIPLE RESULTS)
      (COND ((and (not dont-broadcast) (SETQ SERVICES (FIND-PATHS-TO-SERVICE-USING-BROADCAST ':TIME)))
	     (LOOP FOR SERVICE IN SERVICES
		       ;; give all broadcast TIME services an optional
		       ;; argument saying they can receive multiple times
		       ;; and return a list of the times. 
		   DO (SETF (SERVICE-ACCESS-PATH-ARGS SERVICE) '(T)))
	     (SETQ MULTIPLE T))
	    ((SETQ SERVICES (SEARCHING-ONE-NAMESPACE (*NAMESPACE*)
			      (FIND-PATHS-TO-SERVICE ':TIME)))
	     ;; maybe this should try to collect some percentage of the
	     ;; length of the list and use the median from those?
	     ))
      (INVOKE-MULTIPLE-SERVICES (SERVICES (* 60. 10.) "Time") (IGNORE TIME)
	(SYS:NETWORK-ERROR
	  )
	(:NO-ERROR
	 (IF MULTIPLE
	     (SETQ RESULTS (NCONC RESULTS TIME))
	   (RETURN-FROM GET-TIME-FROM-NETWORK TIME))))
      (SETQ RESULTS (SORT RESULTS #'<))
      ;; take median, or average of two around the median
      (AND RESULTS
	   (LET* ((LENGTH (LENGTH RESULTS))
		  (L//2 (// LENGTH 2)))	    
	     (IF (ODDP LENGTH)
		 (NTH L//2 RESULTS)
	       (// (+ (NTH (1- L//2) RESULTS) (NTH L//2 RESULTS)) 2)))))))


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:IO1;TIME.LISP.195")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode:LISP; Package:TIME; Base:8 -*-")

(setq *INITIALIZE-TIMEBASE-FROM-CALENDAR-CLOCK* t)


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:IO1;TIME.LISP.195")
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode:LISP; Package:TIME; Base:8 -*-")

(DEFUN INITIALIZE-TIMEBASE (&OPTIONAL UT
			    (USE-NETWORK
			      (NOT (OR
				     *INITIALIZE-TIMEBASE-FROM-CALENDAR-CLOCK*
				     (STRING-EQUAL (SEND NET:*LOCAL-SITE* :STANDALONE)
						   "Yes")))))
  ;; Default method of getting time:  Try the network first and then the hardware clock
  (FLET ((GET-TIME ()
	  (IF USE-NETWORK 
	      (SETQ UT (OR (NET:GET-TIME-FROM-NETWORK)
			   (READ-CALENDAR-CLOCK)))
	      (SETQ UT (READ-CALENDAR-CLOCK)))))
    (LET ((INITIALIZE-CALENDAR-CLOCK NIL))
      (WHEN (NULL UT)
	;; The sequence of events is different for the various architectures
	#+IMACH
	(SYS:SYSTEM-CASE
	  ;; MacIvory, Solstice, and Zora should read from the host clock first.
	  ((Embedded Zora)
	    (SETQ UT (READ-CALENDAR-CLOCK))
	    (IF (NOT UT) (SETQ UT (NET:GET-TIME-FROM-NETWORK))))
	  ;; XL400s should read from the network first.
	  (OTHERWISE
	    (GET-TIME)
	    (when (and (NULL UT) *INITIALIZE-TIMEBASE-FROM-CALENDAR-CLOCK*)
	      (SETQ INITIALIZE-CALENDAR-CLOCK T)
	      (setq UT (NET:GET-TIME-FROM-NETWORK))
	      (when (NULL UT)
		(loop for st from 1 to 9
		      do (scl:sleep st)
		      until (setq UT (or (NET:GET-TIME-FROM-NETWORK t) (NET:GET-TIME-FROM-NETWORK))))
		(when (NULL UT)
		  (SETQ INITIALIZE-CALENDAR-CLOCK nil)
		  (setq UT 3426530400.))))))
	;; 3600s try the network first.
	#+3600
	(GET-TIME)
	;; OK, test again to see if we have a time.  The above might have failed
	;; If we don't, then we have to prompt the user.
	(WHEN (NULL UT)
	  (CL:WRITE-STRING "The current timezone is ")
	  (SCL:PRESENT *TIMEZONE* 'TIMEZONE)
	  (CL:FRESH-LINE)
	  (SETQ INITIALIZE-CALENDAR-CLOCK T)
	  (SETQ UT
		(LOOP FOR STRING = (PROMPT-AND-READ
			       :STRING
			       "Unable to get time from the network or the calendar clock.  ~&Please type the date and time:  ")
		WHILE STRING
		DO (CONDITION-CASE (ERROR)
			(RETURN (PARSE-UNIVERSAL-TIME STRING))
		      (PARSE-ERROR
			(PRINC ERROR QUERY-IO)))))))
      ;; By this time, we are assured to have a UT, so initialize the timebase.
      (setq *INITIALIZE-TIMEBASE-FROM-CALENDAR-CLOCK* nil)	; Reset for original behavior 
      (INITIALIZE-TIMEBASE-INTERNAL UT)
      ;; If we had to prompt the user, set the calendar-clock too.
      (WHEN (AND INITIALIZE-CALENDAR-CLOCK  ( SYS:FEP-VERSION-NUMBER 17.))	;Sigh
	(SET-CALENDAR-CLOCK UT)))))

