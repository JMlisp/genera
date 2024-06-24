;;; -*- Mode: LISP; Syntax: Common-Lisp; Package: USER; Base: 10; Patch-File: T -*-
;;; Patch file for Private version 0.0
;;; Reason: Function CLI::82586-ETHERNET-CONTROLLER-INTERRUPT:  ...
;;; Function CLI::82586-ETHERNET-CONTROLLER-INTERRUPT:  ...
;;; Written by BB, 7/30/93 12:53:03
;;; while running on EPSILON from FEP0:>hlin3-36-18.ilod.1
;;; with Genera 8.3, Logical Pathnames Translation Files NEWEST, CLIM 52.7,
;;; Genera CLIM 52.3, CLX CLIM 52.1, PostScript CLIM 52.1, CLIM Documentation 52.1,
;;; Metering 439.0, Metering Substrate 439.0, Conversion Tools 430.0,
;;; NFS Server 435.0, Statice Runtime 460.4, DBFS Utilities 439.0, C 437.0,
;;; Lexer Runtime 435.0, Lexer Package 435.0, Minimal Lexer Runtime 436.0,
;;; Lalr 1 431.0, Context Free Grammar 436.0, Context Free Grammar Package 436.0,
;;; C Runtime 435.0, Compiler Tools Package 431.0, Compiler Tools Runtime 431.0,
;;; C Packages 433.0, Syntax Editor Runtime 431.0, C Library Headers 431,
;;; Compiler Tools Development 432.0, Compiler Tools Debugger 431.0,
;;; Experimental C Documentation 423.0, Syntax Editor Support 431.0,
;;; LL-1 support system 435.0, Fortran 431.0, Fortran Runtime 431.0,
;;; Fortran Package 431.0, Fortran Doc 425.0, Harbison Steele Doc 425.0,
;;; Hardcopy Restriction 420.0, DNA 434.0, Statice 460.1, Statice Browser 460.0,
;;; Statice Documentation 423.0, Symbolics Concordia 439.1, Image Substrate 435.0,
;;; Essential Image Substrate 427.0, Graphic Editor 435.0, Graphic Editing 436.0,
;;; Bitmap Editor 436.0, Graphic Editing Documentation 429.0, Postscript 431.0,
;;; Concordia Documentation 429.0, Lock Simple 432.0, Joshua 237.3,
;;; Joshua Metering 206.0, Joshua Documentation 216.0, Macsyma 418.85, DASA-SITE 4.0,
;;; Experimental DASA-TOOLS 7.0, Experimental TMS-DOC 28.1,
;;; Experimental BDEX-DOC 17.0, Experimental CLOS-BDEX 20.1,
;;; Experimental MTRAN-DOC 25.0, Experimental MTRAN 46.0, Experimental CLOS-TMS 21.4,
;;; Experimental MTRAN-MDB 19.0, Experimental CBDEX 31.0,
;;; Experimental MTRAN-HLIN3 36.18, Experimental MTRAN-HLIN2 21.3,
;;; Experimental MTRAN-VORONOI 36.2, Experimental Hlin3 Doc Sys 24.0,
;;; Ivory Revision 4A (FPA enabled), FEP 328, FEP0:>i328-loaders.flod(24),
;;; FEP0:>i328-debug.flod(24), FEP0:>i328-info.flod(24), FEP0:>i328-lisp.flod(25),
;;; FEP0:>i328-kernel.fep(44), Boot ROM version 316, Device PROM version 325,
;;; 1067x748 B&W Screen, Machine serial number 1061,
;;; Clos arglist (from DASA:SITE;CLOS-ARGLIST.LISP.1),
;;; Avoid infinite loops of GRAPHICS:DRAW-TRIANGLE-DRIVER. (from DASA:SITE;DRAW-TRIANGLE-DRIVER.LISP.1),
;;; The Add Patch Changed Definitions Commands now ignore the SAVE-TICK (from DASA:SITE;PATCH-CHANGED.LISP.1),
;;; Avoid errors when DBG:COMPILED-FUNCTION-SPEC-P gets a symbols that is not FBOUNDP. (from DASA:SITE;COMPILED-FUNCTION-SPEC-P.LISP.1),
;;; Namespace (from DASA:SITE;NAMESPACE.LISP.1),
;;; DEFLOCF for SI:CTS-READ-LOCATION (from DASA:SITE;DEFLOCF.LISP.1),
;;; Do not destructively modify a class when it is examined. (from DASA:SITE;CLOS-EXAMINE.LISP.1),
;;; Also handle FLOAT indentation. (from DASA:SITE;FLOAT-INDENTATION.LISP.1),
;;; Avoid NCONC on list constants. (from DASA:SITE;I-COMPILER.LISP.1),
;;; Pass a Function Spec Object instead of a CLOS Method Object to ZWEI:EDIT-DEFINITION. (from DASA:SITE;EDIT-CLOS-METHOD.LISP.2),
;;; Experiment with Statice Indexes (from DASA:SITE;STATICE-INDEX.LISP.1),
;;; Improve VIEW-ENTITY Handler applicability (from DASA:SITE;VIEW-ENTITY.LISP.1),
;;; Avoid loosing Concordia Callers (from DASA:SITE;CONCORDIA-CALLERS.LISP.1).


(SCT:FILES-PATCHED-IN-THIS-PATCH-FILE 
  "SYS:NETWORK;82586-ETHERNET-DRIVER.LISP.15")


(SCT:NOTE-PRIVATE-PATCH "Merlin II Patch 2")


;========================
(SCT:BEGIN-PATCH-SECTION)
(SCT:PATCH-SECTION-SOURCE-FILE "SYS:NETWORK;82586-ETHERNET-DRIVER.LISP.15")
#+IMACH
(SCT:PATCH-SECTION-ATTRIBUTES
  "-*- Mode: LISP; Syntax: Zetalisp; Package: NETWORK-INTERNALS; Base: 10 -*-")

#+IMACH
(DEFWIREDFUN CLI::82586-ETHERNET-CONTROLLER-INTERRUPT (&OPTIONAL (UNIT 0))
  (LET ((INTERFACE (SELECTQ UNIT
		     (0 *82586-ETHERNET-INTERFACE-0*)
		     (1 *82586-ETHERNET-INTERFACE-1*)
		     (2 *82586-ETHERNET-INTERFACE-2*))))
    (WHEN INTERFACE
      ;; Figure out who is responsible
      (LET* ((SCB (82586-EI-SCB INTERFACE))
	     (STATUS (82586-SCB-STATUS-WORD SCB)))
	;; Acknowledge the interrupt.
	(82586-SET-SCB-COMMAND INTERFACE
			       (%LOGDPB (%LOGLDB 82586-SCB-STAT STATUS) 82586-SCB-ACK 0))
	(WHEN (AND (CL:LOGTEST STATUS (%LOGDPBS -1 82586-SCB-CX -1 82586-SCB-CNA 0))
		   (NOT (82586-EI-TRANSMITTER-ACTIVE INTERFACE)))
	  (SETF (82586-EI-TRANSMITTER-ACTIVE INTERFACE) T)
	  (CLI::ENQUEUE-INTERRUPT-TASK #'82586-DO-TRANSMIT-WORK INTERFACE 2))
	(WHEN (AND (CL:LOGTEST STATUS (%LOGDPBS -1 82586-SCB-FR -1 82586-SCB-RNR 0))
		   (NOT (82586-EI-RECEIVER-ACTIVE INTERFACE)))
	  (SETF (82586-EI-RECEIVER-ACTIVE INTERFACE) T)
	  (CLI::ENQUEUE-INTERRUPT-TASK #'82586-CHECK-FOR-RECEIVED-PACKETS INTERFACE 2))
	;; Wait for the command to complete, so we know the interrupt has gone away.
	;; We really do have to wait here because otherwise we'll take another
	;; interrupt.  With Sherman's ECO, we could turn off interrupts from the 82586
	;; at this point and queue a task to wait for it to go to 0 (and then turn the
	;; interrupts back on).
	(BLOCK WAIT-FOR-IT-TO-BE-SAFE
	  (loop for count from 20. by 20. to 200.
		do (LOOP REPEAT count DOING
		     (LOOP REPEAT count DOING
		       (WHEN (= (82586-SCB-COMMAND-WORD SCB) 0)
			 (RETURN-FROM WAIT-FOR-IT-TO-BE-SAFE))
		       ;; Maybe it missed the channel attention
		       (82586-CHANNEL-ATTENTION INTERFACE)))
		   (incf neti:*count-net-microcode-hangs*))
	  ;; Looks like things are seriously broken, so reset the chip
	  (82586-RESET-CHIP INTERFACE)
	  (WIRED-FERROR NIL "82586//82596 appears to be hung [BB]"))))))

