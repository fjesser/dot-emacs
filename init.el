;; My Emacs Initialization File
;;  = new page; jump with C-x ] and C-x [ to next/previous page
;; better: use outline-minor-mode (L1: ;;; L2: ;;;; etc.), my prefix: C-< 
;; use with C-n, C-p etc., fold/unfold all C-q/a, C-<TAB> to fold on point
;; Get overview with C-u C-u C-c C-u C-q


;;; --- Emacs Meta Settings and Within Setting 

;;;; ------ Make Emacs use melpa repository 
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;;; ------ Within settings - changed from within Emacs
;; Don't change them here!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/Documents/org/PhD.org" "/home/felix/Documents/org/Work-and-Projects.org" "/home/felix/Documents/org/Org-Main.org"))
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-eww ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m))
 '(package-selected-packages
   '(bbdb-vcard bbdb calfw-org calfw helm org-msg mu4e-alert org-roam-ui flycheck-languagetool ivy-avy yasnippet poly-R polymode ox-reveal avy flyspell-correct-ivy ess outline-magic auctex pdf-view-restore org-noter image+ org-mind-map org-super-agenda org-roam-server org-roam-bibtex ivy-bibtex counsel org-ref sqlite3 multi-web-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diary ((t (:background "deep sky blue"))))
 '(fixed-pitch ((t nil)))
 '(font-latex-slide-title-face ((t (:inherit font-lock-type-face :weight bold))))
 '(org-agenda-date-weekend ((t (:inherit org-agenda-date))))
 '(org-agenda-dimmed-todo-face ((t nil))))




;;; --- General Emacs Settings 
;;;; ------ General appearance
(setq tool-bar-mode nil) ;; Disable tool-bar


;;;; ------ Mode Line
;; Set variables to change mode line appearance
(setq column-number-mode t     ; Enable column number
      size-indication-mode nil ; Disable size of file
      )


;;;; ------ General behavior
;; Change number of lines of continuity when scrolling (default: 2)
;; C-v behavior is changed
(setq next-screen-context-lines 25)

;; Set width of line to 80 characters (default 70)
;;(setq-default fill-column 80)

;; Allow sentences to end with a single space after period (for M-e command)
(setq sentence-end-double-space nil)
;; Allow that sentence can end without period (e.g., in lists)
(setq sentence-end-without-period t)

;; Show matching parentheses
(show-paren-mode 1)

;; Split windows horizontally by default
;; (setq window-divider-default-places 'right-only)
;; this command seems not necessary although in earlier days it seems to do the trick

;; Automatically save desktop sessions and restore last saved session
(desktop-save-mode t)


;; Set backup-directory for backup files "name~"
;; #xy# are autosaved files that are removed when emacs quits normally
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq backup-by-copying t)

;; start emacs as a server
;; invoke emacs without starting new emacs process; really important
; necessary for org-protocol
(server-start)
;; Don't request confirmation to kill processes when emacs quits (C-x C-c)
;; In this way it is not necessary to type "yes" when quitting and a server was started
(setq confirm-kill-processes nil)



;;; --- Emacs Lisp Settings 

;; make outline-minor-mode available in elisp mode
(add-hook 'emacs-lisp-mode-hook 'outline-minor-mode)



;;; --- Outline
;;;; ------ Outline-minor-mode
;; Used for elisp and AUCTeX
;; It is configured here so that setting the prefix works.
;; It would not work if it was loaded before setting the prefix
;; which would happen if loaded after AUCTeX

;; Change prefix key for outline-minor-mode from C-c @ to C-c C-u
;; C-u because C-ö is not possible
(setq outline-minor-mode-prefix "")
(require 'outline)

;;;; ------ Outline-magic
;; Package used for collapsing headlines
;; C-tab functionality for folding
(eval-after-load 'outline '(progn
                (require 'outline-magic)
                (define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)))
;; Somehow outline-magic binds globally to <tab> (case-sensitive) and
;; overwrites org-cycle; disable keymapping in outline-magic
(define-key outline-mode-map [(tab)] nil)



;;; --- Dired Settings 
;; Deletion moves files/folders to trash
(setq delete-by-moving-to-trash t)

;; Automatically update buffer when revisiting it
(setq dired-auto-revert-buffer t)

;; Don't show hidden files by default
;; use C-u l on directory to change
;;(setq dired-listing-switches "-l")

;; Enable gnus-dired-mode in dired-mode
;; Attach files to mails from dired (C-c C-m C-a)
(add-hook 'dired-mode-hook 'turn-on-gnus-dired-mode)



;;; --- Ibuffer 
;; Overwrite list-buffer default keybinding with ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Set filter groups
;; organize buffer list
(setq ibuffer-saved-filter-groups
      '(
	("Default Groups"
	 ("Org" (and (mode . org-mode)
		     (not filename . "org/org-roam")))
	 ("Org-Roam" (and (mode . org-mode)
			  (filename . "org/org-roam")))
	 ("PDF" (or (mode . pdf-view-mode)
		    (mode . doc-view-mode)))
	 ("LaTeX" (or (mode . latex-mode)
		      (mode . tex-mode)
		      (name . "Rnw")
		      (mode . bibtex-mode)))
	 ("R" (mode . ess-r-mode))
	 ("Dired" (mode . dired-mode))
       	 ("Emacs" (mode . emacs-lisp-mode))
	 ("Help" (or (name . "\*Help\*")
		     (name . "\*Apropos\*")
		     (name . "\*info\*")))
	 )
	)
)



;; Set hooks for when entering ibuffer
;; 1. Automatically keep buffer up to date
;; 2. Apply filter groups by default (see above) 
(add-hook 'ibuffer-mode-hook
	  '(lambda ()
	     (ibuffer-auto-mode 1)
	     (ibuffer-switch-to-saved-filter-groups "Default Groups")))


;; Change Display
(setq ibuffer-formats '(
       ;; First display format
       (mark modified read-only locked " "
       (name 40 40 :left :elide)
       " "
       (mode 16 16 :left :elide)
       " " filename-and-process)
       ;; Second display
       (mark
	  (size 9 -1 :right)
           " "
          (name 40 -1)
           " " filename)))



;;; --- Avy Settings 
;; Package for jumping to visible text
(global-set-key (kbd "M-ĸ") 'avy-goto-char-timer) ; M-<Alt Gr>-k 
(global-set-key (kbd "M-ł") 'avy-goto-word-1)     ; M-<Alt Gr>-w (also works with l)
(global-set-key (kbd "M-æ") 'avy-goto-line)       ; M-<Alt Gr>-a
(global-set-key (kbd "<M-dead-belowdot>") 'avy-goto-char-in-line) ; M-<Alt Gr>-




;;; --- Counsel, Ivy, and Swiper Settings
;; The counsel package incorporates the ivy package

;; Globally enable ivy and counsel mode
(ivy-mode 1)
(counsel-mode 1) ; overwrites common kbd with counsel counterpart

;; Enable ivy-avy
;; use avy inside ivy with C-'
(require 'ivy-avy)

;; Set height of ivy minibuffer
; (setq ivy-height 7) ; default: 10

;; Add recent files and bookmarks to ivy-switch buffer
(setq ivy-use-virtual-buffers t)
;; Display index and count in ivy-read (= ivy minibuffer)
(setq ivy-count-format "(%d/%d) ")

;;;; ------ Keybindings
;; set kbd for recursive file finding (fuzzy)
;; needs fzf to be installed
(global-set-key (kbd "C-x C-M-f") 'counsel-file-jump)

;; Use swiper-isearch instead of default search function
(global-set-key (kbd "C-s") 'swiper-isearch)

;; completion for kill-ring (M-y after C-y)
(global-set-key (kbd "M-y") #'counsel-yank-pop)
;; next entry with M-y when in kill-ring-completion
(define-key ivy-minibuffer-map (kbd "M-y") #'ivy-next-line)

;; Set kbd for entering mark ring
(global-set-key (kbd "C-c SPC") 'counsel-mark-ring)



;;; --- Ivy-Bibtex Settings 
;; Load ivy-bibtex
(autoload 'ivy-bibtex "ivy-bibtex" "" t)

;; Set global key-binding for M-x ivy-bibtex
(global-set-key (kbd "C-ß") 'ivy-bibtex)
(global-set-key (kbd "C-c ß") 'ivy-bibtex-with-local-bibliography)

;; ivy-bibtex requires ivy's `ivy--regex-ignore-order` regex builder, which
;; ignores the order of regexp tokens when searching for matching candidates.
(setq ivy-re-builders-alist
      '((ivy-bibtex . ivy--regex-ignore-order)
        (t . ivy--regex-plus)))

;; Set paths to bibliographies
(setq bibtex-completion-bibliography '("~/Documents/org/bibliography.bib"))
;; also possible to specy org-mode bibliography files:
;;      '("/path/to/bibtex-file-1.bib"
;;          ("/path/to/org-bibtex-file2.org" . "/path/to/bibtex-file.bib")))

;; Retrieve path to PDF from File entry in BibTex file
;; File entry is set by JabRef
(setq bibtex-completion-pdf-field "File")
;; Use specified directory paths as a fallback searching for BibtexKey.pdf
(setq bibtex-completion-library-path '("~/Documents/org/bibliography_pdf")) ; second entry possible

;; Set notes directory
(setq bibtex-completion-notes-path "~/Documents/org/org-roam")

;; Set default action of ivy-bibtex to cite (not ivy-bibtex-open-any)
(setq ivy-bibtex-default-action 'ivy-bibtex-insert-citation)

;; Set default citation command
(setq bibtex-completion-cite-default-command "autocite")

;; Don't prompt for pre- and postnotes when citing
(setq bibtex-completion-cite-prompt-for-optional-arguments nil)

;; Open pdf via bibtex-completion in other window
; This setting also effects M-x orb-note-actions behaviour!
(setq bibtex-completion-pdf-open-function 'find-file-other-window)

;; Change display of ivy-bibtex interface
(setq bibtex-completion-display-formats
    '((article       . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${journal:40}")
      (inbook        . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
      (incollection  . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
      (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
      (t             . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*}")))

;; Additional fields for searching
(setq bibtex-completion-additional-search-fields '(keywords))

;; Overwrite default function to find local bibliography in Rnw files
;; A new entry is added in the function bibtex-completion-find-local-bibliography
;; This is done at the end of this file because apparently somewhere in between
;; ivy-bibtex is loaded again (maybe from org-roam-bibtex) and the defined
;; function is overwritten again. So look at the bottom



;;; --- Yasnippet Settings
;; template expansion package

;; Set yasnippet dirs
(setq yas-snippet-dirs '("~/.emacs.d/yasnippet-templates/"))
;; Globally enable yasnippet minor mode
(yas-global-mode 1)

;; Disable default keybinding for yasnippet commands in order that org C-c & works
(define-key yas-minor-mode-map (kbd "\C-c&\C-n") nil) ; yas-new-snippet
(define-key yas-minor-mode-map (kbd "\C-c&\C-s") nil) ; yas-insert-snippet
(define-key yas-minor-mode-map (kbd "\C-c&\C-v") nil) ; yas-visit-snippet-file
(define-key yas-minor-mode-map (kbd "\C-c") nil)      ; C-c prefix key
(define-key yas-minor-mode-map (kbd "\C-c&") nil)     ; C-c & prefix key


;;; --- Mail Settings 
;;;; ------ Mu4e settings
;; mu4e makes mu (mail indexer) available in emacs

;; Since Ubuntu has only mu v1.2, I compiled 1.6 and
;; must set certain paths
(add-to-list 'load-path "~/Programs/mu-1.6.10/mu4e")
(require 'mu4e)

(setq mu4e-mu-binary "~/Programs/mu-1.6.10/mu/mu") ; set correct mu binary
(setq mu4e-doc-dir "~/Programs/mu-1.6.10/")        ; set documentation directory

;; Set retrieval of mails and reindexing
(setq mu4e-get-mail-command "mbsync -a")
(setq mu4e-update-interval 300) ; update every 5 minutes
;; Rename files when moved into another folder
;; otherwise mbsync throws an error
(setq mu4e-change-filenames-when-moving t)

;; use mu4e for e-mail in emacs
;; use standard kbd C-x m for composing new mail from anywhere
(setq mail-user-agent 'mu4e-user-agent)
(set-variable 'read-mail-command 'mu4e) ; also for reading mail


;; Mu4e Key Bindings
(global-set-key (kbd "C-ü m") 'mu4e)
(global-set-key (kbd "C-ü u") 'mu4e-update-mail-and-index)
(global-set-key (kbd "C-ü c") 'mu4e-compose-new)
(global-set-key (kbd "C-ü h") 'mu4e-hide-other-mu4e-buffers)
(global-set-key (kbd "C-ü b") 'mu4e-headers-search-bookmark)
(global-set-key (kbd "C-ü s") 'mu4e-headers-search)
(global-set-key (kbd "C-ü j") 'mu4e~headers-jump-to-maildir)

;; Remap "q" in main-view to kill buffer and not to kill session
(define-key mu4e-main-mode-map (kbd "q") (lambda () (interactive) (kill-buffer nil)))
;; Map "Q" to quit mu4e (kill session); originally bound to "q"
(define-key mu4e-main-mode-map (kbd "Q") 'mu4e-quit)


;; Special stuff: Disable TRASH flag when message is deleted in mu4e
;; It is only moved. This prevents some problems when syncing.
(setf (alist-get 'trash mu4e-marks)
      (list :char '("d" . "▼")
            :prompt "dtrash"
            :dyn-target (lambda (target msg)
                          (mu4e-get-trash-folder msg))
            :action (lambda (docid msg target)
                      ;; Here's the main difference to the regular trash mark,
                      ;; no +T before -N so the message is not marked as
                      ;; IMAP-deleted:
                      (mu4e~proc-move docid (mu4e~mark-check-target target) "-N"))))

;; Set bookmarks
;; shortcut for searches with prefix b
(setq mu4e-bookmarks '(
		       (:name "Unread messages" :query "flag:unread AND NOT flag:trashed" :key ?u)
		       (:name "flagged" :query "flag:flagged" :key ?f)
		       (:name "Today's messages" :query "date:today..now" :key ?t)
		       (:name "Last 7 days" :query "date:7d..now" :key ?l)
			))


;; Define attachment directory
(setq mu4e-attachment-dir "~/Downloads") ;; prompt for dir use: C-u e

;; In mu4e it is only possible to save multiple attachments with helm.
;; Here is a workaroung that uses helm only in this situation (from SO)
;; Define own function
(defun my-mu4e-save-all-attachments (orig-fun &rest args)
  "Temporarily turn on helm-mode for selecting files when saving attachments in mu4e."
  (helm-mode)
  (apply orig-fun args)
  (helm-mode -1))
;; ;; Advise the original function with own function
(advice-add 'mu4e-view-save-attachments :around #'my-mu4e-save-all-attachments)



(setq mu4e-save-multiple-attachments-without-asking nil)

;; Add action to mime-part actions
;; attention, this is something different than attachment actions!
;; but mime-part actions are available by "A" in view mode
(add-to-list 'mu4e-view-mime-part-actions
	     '(:name "import to diary"
	       :handler (lambda (temp)
			  ;;(interactive) ;; in order to kill buffer automatically
			  (icalendar-import-file temp diary-file) ; import
			  (kill-buffer ; kill buffer of ics file
			   (file-name-nondirectory temp)) ; remove dir from name
			  ) 
	       :receives temp ; full path to mime part in temp file
	       )
	     t ; append to list
	     )


;; Define contexts (multiple accounts)
;; note: the special folders (trash, sent, drafts, refile -> mu4e-X-folder)
;; are set automatically as long as a good match function is given that
;; determines the current context for the message
(setq mu4e-contexts
      `(
       ;; gmail context
       ,(make-mu4e-context
	:name "gmail"
	:vars '((user-mail-address . "mail@gmail.com")
		(user-full-name . "Mail Name")
		(mu4e-sent-folder . "/gmail/[Google Mail]/Sent Mail")
		(mu4e-drafts-folder . "/gmail/[Google Mail]/Drafts")
		(mu4e-refile-folder . "/gmail/[Google Mail]/Important")
		(mu4e-trash-folder . "/gmail/[Google Mail]/Trash")
		;; within making contexts syntax for shortcuts is different
		(mu4e-maildir-shortcuts . ( ("/gmail/inbox" . ?i)
					    ("/gmail/[Google Mail]/Trash" . ?t)
					    ("/gmail/[Google Mail]/Sent Mail" . ?s)
					    ("/gmail/[Google Mail]/Drafts" . ?d)
					    ("/gmail/[Google Mail]/Important" . ?a)
					    ))
		;; Sending mail
		(smtpmail-smtp-server . "smtp.gmail.com")
		(smtpmail-smtp-service . 587)
		(smtpmail-stream-type . starttls)
		)
	:match-func (lambda (msg)
		      (when msg
			(string-match-p "^/gmail" (mu4e-message-field msg :maildir))
			)
		      )
	)
       ;; cuny context
       ,(make-mu4e-context
	:name "work"
	:vars '((user-mail-address . "work@workmail.work")
		(user-full-name . "Work Name")
		(mu4e-sent-folder . "/work/sent")
		(mu4e-drafts-folder . "/work/drafts")
		(mu4e-refile-folder . "/work/archive")
		(mu4e-trash-folder . "/work/trash")
		;; within making contexts syntax for shortcuts is different
		(mu4e-maildir-shortcuts . ( ("/work/inbox" . ?i)
					    ("/work/trash" . ?t)
					    ("/work/sent" . ?s)
					    ("/work/drafts" . ?d)
					    ("/work/archive" . ?a)
					    ))
		;; Sending mail using Davmail
		(smtpmail-smtp-server . "localhost")
		(smtpmail-smtp-service . 1025)
		(smtpmail-stream-type . nil) ;; use plain smtp connection to localhost
		;(mu4e-sent-messages-behavior . delete) 
		)
	:match-func  (lambda (msg)
		       (if after-init-time
			   (when msg
			     (string-match-p "^/work" (mu4e-message-field msg :maildir))
			     )
			 t ;; if after-init-time is nil (=in initialization) match
			 )
		       )
	)
       ))


;; Writing Mail
;; Use spellchecker when composing
(add-hook 'mu4e-compose-mode-hook 'turn-on-flyspell)

;; Define signature
;; However, this is somewhat obsolete due to org-msg package
(setq mu4e-compose-signature "Name \n Position or other information")
(setq mu4e-compose-signature-auto-include nil) ;; don't insert signature by default

;; Sending Mail
;; sending mail using built-in smtp library
(require 'smtpmail)
(setq message-send-mail-function 'smtpmail-send-it)

;; Compose context policy
(setq mu4e-compose-context-policy 'ask-if-none)
;; Confirm Send
(setq message-confirm-send t)
;; Don't reply to self (e.g., in threads)
(setq mu4e-compose-dont-reply-to-self t)

;; Disable default showing of related messages (use W for it)
(setq mu4e-headers-include-related nil)

;; Start mu4e in background
(mu4e t) ;; t is optional argument for background


;;;; ------ mu4e-alert
;; Enable mode line notification for new mails
(mu4e-alert-enable-mode-line-display)


;;;; ------ org-msg
;; Commented out because set above but written here in order to show that org-msg wants it
;; (setq mail-user-agent 'mu4e-user-agent)

;; Require org-msg-mode and activate it
;;(require 'org-msg) ; doesn't seem necessary
(org-msg-mode)
;; Set MIME alternatived depending on type of mail (new, reply-*)
;; (text html): send both alternatives to your message
(setq org-msg-default-alternatives '((new            . (text html))
				     (reply-to-html  . (text html))
				     (reply-to-text  . (text))))
;; Set org-msg HTML export options
;; org OPTIONS: for HTML export
(setq org-msg-options "html-postamble:nil H:5 ^:{} toc:nil author:nil email:nil \\n:t")

;; convert citations starting with ">" into quote blocks
(setq org-msg-convert-citation t)
;; Signature
(setq org-msg-signature "

 Regards,

 /Name/
")

;; Provide original mu4e text email mode 
(global-set-key (kbd "C-ü C-c") (lambda ()
				  (interactive)
				  (org-msg-mode -1)
				  (mu4e-compose-new)
				  (org-msg-mode)
				  ))


;; Define CSS style for HTML mail
;; default value of org-msg-enforce is org-msg-default-style
;; The current value is a copy of this default value with minor changes
(setq org-msg-enforce-css
  (let* ((font-family '(font-family . "\"Arial\""))
	 (font-size '(font-size . "12pt")) ;; replaced 10pt
	 (font `(,font-family ,font-size))
	 (line-height '(line-height . "16pt")) ;; replaced 10pt
	 (bold '(font-weight . "bold"))
	 (theme-color "#0071c5")
	 (color `(color . ,theme-color))
	 (table `(,@font (margin-top . "0px")))
	 (ftl-number `(,@font ,color ,bold (text-align . "left")))
	 (inline-modes '(asl c c++ conf cpp csv diff ditaa emacs-lisp
			     fundamental ini json makefile man org plantuml
			     python sh xml R))                                ;; added R
	 (inline-src `((color . ,(face-foreground 'default))
		       (background-color . "#F5F5F5")))    ;; change bg color of src
	 (code-src
	  (mapcar (lambda (mode)
		    `(code ,(intern (concat "src src-" (symbol-name mode)))
			   ,inline-src))
		  inline-modes))
	 (base-quote '((padding-left . "5px") (margin-left . "10px")
		       (margin-top . "10px") (margin-bottom . "0")
		       (font-style . "italic") (background . "#f9f9f9")))
	 (quote-palette '("#324e72" "#6a3a4c" "#7a4900" "#ff34ff"
			  "#ff4a46" "#008941" "#006fa6" "#a30059"
			  "#ffdbe5" "#000000" "#0000a6" "#63ffac"))
	 (quotes
	  (mapcar (lambda (x)
		    (let ((c (nth x quote-palette)))
		      `(blockquote ,(intern (format "quote%d" (1+ x)))
				   (,@base-quote
				    (color . ,c)
				    (border-left . ,(concat "3px solid "
						      (org-msg-lighten c)))))))
		  (number-sequence 0 (1- (length quote-palette))))))
  `((del nil (,@font (color . "grey") (border-left . "none")
	      (text-decoration . "line-through") (margin-bottom . "0px")
	      (margin-top . "10px") (line-height . "11pt")))
    (a nil (,color))
    (a reply-header ((color . "black") (text-decoration . "none")))
    (div reply-header ((padding . "3.0pt 0in 0in 0in")
		       (border-top . "solid #e1e1e1 1.0pt")
		       (margin-bottom . "20px")))
    (span underline ((text-decoration . "underline")))
    (li nil (,@font ,line-height (margin-bottom . "0px")
	     (margin-top . "2px")))
    (nil org-ul ((list-style-type . "disc"))) 			; replaced "square"
    (nil org-ol (,@font ,line-height (margin-bottom . "0px")
		 (margin-top . "0px") (margin-left . "30px")
		 (padding-top . "0px") (padding-left . "5px")))
    (nil signature (,@font (margin-bottom . "20px")))
    (blockquote quote0 ,(append base-quote '((border-left . "3px solid #ccc"))))
    ,@quotes
    (code nil (,font-size (font-family . "monospace") (background . "#f9f9f9")))
    ,@code-src
    (nil linenr ((padding-right . "1em")
		 (color . "black")
		 (background-color . "#aaaaaa")))
    (pre nil ((line-height . "12pt")
	      ,@inline-src
	      (margin . "0px")
	      (font-size . "9pt")
	      (font-family . "monospace")))
    (div org-src-container ((margin-top . "10px")))
    (nil figure-number ,ftl-number)
    (nil table-number)
    (caption nil ((text-align . "left")
		  (background . ,theme-color)
		  (color . "white")
		  ,bold))
    (nil t-above ((caption-side . "top")))
    (nil t-bottom ((caption-side . "bottom")))
    (nil listing-number ,ftl-number)
    (nil figure ,ftl-number)
    (nil org-src-name ,ftl-number)

    (table nil (,@table ,line-height (border-collapse . "collapse")
			(margin-top . "20px") (margin-bottom . "20px") ; Added table margins
			))
    (th nil ((border . "1px solid white")
	     (background-color . ,theme-color)
	     (color . "white")
	     (padding-left . "10px") (padding-right . "10px")))
    (td nil (,@table (padding-left . "10px") (padding-right . "10px")
		     (padding-bottom . "5px") (padding-top . "5px") ; Added vertical cell padding
		     (background-color . "#f9f9f9") (border . "1px solid white")
		     (vertical-align . "top")))                 ; Added vertical alignment in table
    (td org-left ((text-align . "left")))
    (td org-right ((text-align . "right")))
    (td org-center ((text-align . "center")))

    (div outline-text-4 ((margin-left . "15px")))
    (div outline-4 ((margin-left . "10px")))
    (h4 nil ((margin-bottom . "0px") (font-size . "11pt")
	     ,font-family))
    (h3 nil ((margin-bottom . "0px")                           ; removed underline
	     ,color (font-size . "12pt")
	     ,font-family))
    (h2 nil ((margin-top . "32px") (margin-bottom . "20px")    ; h2 is used as h1, top was 20px
	     (font-style . "bold") ,color (font-size . "14pt") ; changed "italic" to "bold"
	     ,font-family))
    (h1 nil ((margin-top . "20px")
	     (margin-bottom . "0px") ,color (font-size . "12pt")
	     ,font-family))
    (p nil ((text-decoration . "none") (margin-bottom . "12px") ; replaced (margin-bottom . "0px")
	    (margin-top . "16px") (line-height . "16pt") ,font-size ; replaced (margin-top . "10px") and (line-height . "11pt")
	    ,font-family))
    (div nil (,@font (line-height . "11pt"))))))


;;; --- Calendar and Diary

;;;; ------ Calendar
;; Keybinding to open calendar
(global-set-key (kbd "M-ü M-c") 'calendar)
;; Set calendar date style to ISO
(setq calendar-date-style 'iso)
;; Begin calendar with Monday
(setq calendar-week-start-day 1)
;; Set geographical location to retrieve sunrise/sunset
(setq calendar-latitude XX) ; insert appropriate numbers
(setq calendar-longitude XX)
(setq calendar-location-name "XX") ; insert appropriate name

;; Change format of inserted date in calendar
;; I think there is a bug. When I export a diary file
;; to ics, dates in the form "year-month-day" are skipped.
;; However, using the form "year/month/day" works.
;; This code changes the format. 
(setq calendar-date-display-form
      '((format "%s/%.2d/%.2d" year	; changed "-" to "/"
	 (string-to-number month)
	 (string-to-number day))))


;;;; ------ Diary

;; Main diary file in diary-files folder
(setq diary-file "~/.emacs.d/diary-files/diary-main")

;; Diary comment characters
(setq diary-comment-start ";;"
      diary-comment-end ";;")


(add-hook 'diary-display-hook 'fancy-diary-display)
;; Hooks for fancy diary display
;; fancy diary display is used by default
;; enable inclusion of other diary files specified by #include "FILE"
(add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
(add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)
;; sort diary entries (should be the last hook!)
(add-hook 'diary-list-entries-hook 'diary-sort-entries t)

;; Import nextcloud calendars into diary files
;; start asynchronous process to source elisp code
(start-process "import-export-calendars" nil  
	       "emacs" "-Q" "-batch" "-l" "~/.emacs.d/diary-files/import-export-calendars.el")


;;; --- calfw
;; calfw depends on cl which is a deprecated package
;; Suppress the warning that this package is deprecated
;; must be executed before requiring calfw
(setq byte-compile-warnings '(cl-functions))

;; require calfw
(require 'calfw)

;; calfw is not really actively developed (last commit on 2018 [2022-01-21])
;; when calfw buffer is burried the cursor of the previous buffer is moved
;; which is quite annoying (actually it is moved before)
;; There is a fix suggested by a user on github changing an internal function
;; https://github.com/kiwanami/emacs-calfw/issues/61
;; in short: instead of the current-buffer the *cfw-calendar* buffer is chosen
(defun cfw:cp-move-cursor (dest date)
  "[internal] Just move the cursor onto the date. This function
is called by `cfw:cp-set-selected-date'."
  (let ((pos (cfw:find-by-date dest date)))
    (when pos
      (goto-char pos)
      (when ;; from this line on the original code is changed
          (and
            (get-buffer-window cfw:calendar-buffer-name)
            (not (eql (selected-window) (get-buffer-window cfw:calendar-buffer-name))))
        (set-window-point (get-buffer-window cfw:calendar-buffer-name) pos)))))



;;;; ------ calfw-org
;; different package; provides integration of calfw with org
(require 'calfw-org) 
;; Keybinding
(global-set-key (kbd "M-ü c") 'cfw:open-org-calendar) ;; is not cfw:open-calendar-buffer

;; make org agenda bindings available in calendar view
(setq cfw:org-overwrite-default-keybinding t) ;; 



;;; --- DocView Settings 
;; Enable continuous scrolling
(setq doc-view-continuous t)



;;; --- PDF-Tools Settings 
;; pdf-tools a substitute for docview 

;; enable pdf-tools
(require 'pdf-tools)
(pdf-tools-install)

;; Disable continuous mode = next page when reaching edge
; continuous scrolling is not possible in pdf-tools
; therefore it is annoying to get to the next page with C-n
(setq pdf-view-continuous nil)

;; Set C-s to isearch and overwrite default swiper
;; to search within pdf files
(define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)

;; Display full page with newly opened pdf
(setq pdf-view-display-size "fit-page")


;;;; ------ PDF-View-Restore Settings 
;; Support for opening last known pdf position in pdf-view-mode provided by pdf-tools.

;; Add hook for pdf-view-mode (pdf-tools)
(add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode)

;; Save positions in folder (not relative to pdf files)
(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")


;;;; ------ PDF-Continuous-Scroll-Mode 
;; toggle mode with c in pdf-view
;; Extra mode loaded from Github (not Melpa!; has to be updated manually!)
;; .el-file is placed in ~/.emacs.d
(eval-after-load "pdf-view"
  '(load "~/.emacs.d/pdf-continuous-scroll-mode.el"))

;; add hook to pdf-view to load mode
(add-hook 'pdf-view-mode-hook 'pdf-continuous-scroll-mode)



;;; --- Flyspell and Flycheck Settings
;;;; ------ Flyspell
;; Turn off flyspell C-keybinding because they overwrite other bindings
;; especially org-mode
(with-eval-after-load "flyspell"
  (progn
    (define-key flyspell-mode-map (kbd "C-.") 'flyspell-auto-correct-previous-word)
    (define-key flyspell-mode-map (kbd "C-,") nil)
    (define-key flyspell-mode-map (kbd "C-M-i") nil)
    (define-key flyspell-mode-map (kbd "C-;") nil)
    ))

;; Flyspell-correct
;; flyspell-correct is a minor mode that provides an ivy interface for flyspell
;; Seems to be superfluous because flyspell is sufficient with C-.
;; (require 'flyspell-correct-ivy)
;; (define-key flyspell-mode-map (kbd "INSERT NEW KBD") 'flyspell-correct-wrapper)


;;;; ------ Flycheck-languagetool

;; load package
(require 'flycheck-languagetool)
;; set path to language tool
(setq flycheck-languagetool-server-jar "/home/felix/Programs/LanguageTool-5.5-stable/languagetool.jar")



;;; --- AUCTeX Settings
;; LaTeX inside Emacs

;; Save style information when saving a buffer
(setq TeX-auto-save t)
;; Parse file after loading, if no style hook is found
(setq TeX-parse-self t)

;; Rename directory where style/parsing information is saved
(setq TeX-auto-local ".auctex")

;; Ask for Master file
;; inserts file variable at end of file indicating where master is
;; (setq-default TeX-master nil)

;; Don't ask whether file should be saved before compilation
;; Saves source automatically
(setq TeX-save-query nil)

;; Insert \( \) when pressing $
(setq TeX-electric-math (cons "\\(" "\\)"))

;; Insert right brace when left brace macro is inserted
(setq LaTeX-electric-left-right-brace t)


;; Activate folding features on default
(add-hook 'LaTeX-mode-hook (lambda ()
                             (TeX-fold-mode 1)
			     (visual-line-mode 1)
			     (flyspell-mode 1)
			     (flycheck-mode 1)))

;; Change default pdf-viewer from Evince to pdf-tools: "PDF Tools"
;; Everything is default value except output-pdf
(setq TeX-view-program-selection '(((output-dvi has-no-display-manager)
				    "dvi2tty")
				   ((output-dvi style-pstricks)
				    "dvips and gv")
				   (output-dvi "xdvi")
				   (output-pdf "PDF Tools")
				   (output-html "xdg-open")))

;; Refresh buffer after compilation
(add-hook 'TeX-after-compilation-finished-functions
        #'TeX-revert-document-buffer)

;; Show warnings after compilation (in addition to errors) - C-c C-t C-w
(setq TeX-debug-warnings t)

;; Activate correlate mode - sync source and viewer
;; toggle with C-c C-t C-s
(setq TeX-source-correlate-mode t)

;; Start server to enable inverse search
;; necessary for jump from view to source
(setq TeX-source-correlate-start-server t)

;; Disable fontification of section titles
;; don't give them larger font
(setq font-latex-fontify-sectioning 1.0)
;; via easy-customization: don't give frametitle larger font
;; font-latex-slide-title-face

;; Add environments to fold
(setq TeX-fold-env-spec-list '(("[comment]" ("comment"))
			       ("[frame]" ("frame"))))


;; Indentation
(setq TeX-newline-function 'reindent-then-newline-and-indent) ;; indent when <RET>
;;(setq TeX-newline-function 'newline)
(setq LaTeX-indent-level 2)
(setq LaTeX-item-indent -1)


;;;; ------ Minor Mode Settings for AUCTeX
;; Note, outline minor mode is also used by AUCTeX but is configured
;; at the top because the prefix variable has to be set early in order
;; that it is loaded correctly.

;;;;; --------- Outline mode
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)

;;;;; --------- Flymake 
;; Activate flymake-mode on default in AUCTeX
;; Stylechecker with chktex
(add-hook 'LaTeX-mode-hook #'flymake-mode)

;; Define keybindings for flymake-mode
(require 'flymake) ;; necessary in order to specify define-key below
(global-set-key (kbd "C-ü C-f") 'flymake-mode)
(define-key flymake-mode-map (kbd "C-ü C-n") 'flymake-goto-next-error)
(define-key flymake-mode-map (kbd "C-ü C-p") 'flymake-goto-prev-error)
(define-key flymake-mode-map (kbd "C-ü C-b") 'flymake-show-diagnostics-buffer)


;;;;; --------- RefTeX
;; Turn on RefTeX in AUCTeX
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
;; Full cooperation between RefTeX and AUCTeX
(setq reftex-plug-into-AUCTeX t)
;; RefTeX searches for bib-files (disables default paths)
(setq reftex-use-exernal-file-finders t)

;; make beamer frametitle available in C-c =
;; original variable + frametitle
(setq reftex-section-levels '(
		  ("part" . 0)
                  ("chapter" . 1)
                  ("section" . 2)
                  ("subsection" . 3)
                  ("subsubsection" . 4)
 		  ("frametitle" . 4)
                  ("paragraph" . 5)
                  ("subparagraph" . 6)
                  ("addchap" . -1)
                  ("addsec" . -2)
;;                  ("frametitle" . -2) ;; this is new, - means no numbering
		  ))


;;; --- ESS Settings 
;; require R features (doesn't include "S" features)
(require 'ess-r-mode) ;; necessary for further config

;; ---------- Keybindings
;; Kbd for assignment operator
(define-key ess-r-mode-map (kbd "M-_") #'ess-insert-assign)
;; Kbd for magrittr pipe
(define-key ess-r-mode-map (kbd "C-S-m") (lambda ()
					   (interactive)
					   (just-one-space 1)
					   (insert "%>%")
					   (reindent-then-newline-and-indent)
					   ))


;;; --- Polymode Settings 
;; installed polymode and poly-R

;; disable woven and exported file extension of files
;; in order that biber works
(setq polymode-weaver-output-file-format "%s") ;; disable -woven.tex
(setq polymode-exporter-output-file-format "%s") ;; disable -woven-exported.pdf

;; compile even if nothing changed
(setq polymode-skip-processing-when-unmodified nil)
;;; --- Org Mode Settings 

;; Settings of org mode are loaded from the following file
(load "~/.emacs.d/init-org.el")

;; Note 1: Additionally, org-super-agenda settings and org-ref-cite
;; settings are also set in this file.
;; Note 2: The variable org-agenda-files (specifying the agenda files)
;; is defined from within Emacs and is therefore set above under custom 
;; variables. Because: org kbd C-c [ changes the custom variable

