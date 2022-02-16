;;; init-org.el --- Org Configuration File
;; This file is loaded from within the emacs init file "~/.emacs.d/init.el"
;; Attention: Some org configruations are configured in the init.el file
;; because it was not possible otherwise. 
;;  = new page; jump with C-x ] to next page and C-x [ to previous page
;; better: use outline-minor-mode (L1: ;;; L2: ;;;; etc.)
;; my prefix: C-c C-u, use with C-n, C-p etc., C-<TAB> to fold


;;; --- General Org Settings

;; Set default org directory
(setq org-directory "~/Documents/org")

;; Set variable in order that C-a/e go before the ellipses
;; ellipses are the '...' for a folded entry
(setq org-special-ctrl-a/e t)

;; Org mode global key bindings
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)
;; Org mode key bindings
;; Orig. binding M-^, now M-<Alt Gr>-ä
(define-key org-mode-map (kbd "<M-dead-circumflex>") 'org-delete-indentation) ;; M-<Alt Gr>-ä



;;; --- Org Hooks
;; Add hooks (execution if for example mode is started)
;; set org-indent-mode for all org files
(add-hook 'org-mode-hook 'org-indent-mode)
;; visual-line-mode: wrap long lines
(add-hook 'org-mode-hook 'visual-line-mode)
;; Turn on flyspell (spelling checker) if in org-mode
(add-hook 'org-mode-hook 'turn-on-flyspell)



;;; --- Org Table Settings 
;; Shrink all columns which have a shrink cookie, e.g., '<25>', at startup
(setq org-startup-shrink-all-tables t)



;;; --- Org Links Settings 
;; Create an ID if needed to make a link to the current entry
;; but only if M-x org-store-link (C-c l) is used and not in org-capture
(setq org-id-link-to-org-use-id 'create-if-interactive)



;;; --- Org TODO Settings 

;; Enable TODO dependencies; all children have to be done
;; in order that parent can be done
(setq org-enforce-todo-dependencies t)

;; Set keybinding for changing state yesterday
;; (useful for org habits)
(define-key org-mode-map (kbd "C-c t") 'org-todo-yesterday)

;; Define TODO keywords
(setq org-todo-keywords
	'((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)")
	  (sequence "ACTIVE(a/!)" "|" "DORMANT(m/!)" "FINISHED(f/!)" )
	 ) ; /! = log time when leaving state
) 

;; Change faces for todo keywords 
(setq org-todo-keyword-faces ; previous added ("UNENLIVENED" . "orange")
	'( ("WAITING" . "orange") ("ACTIVE" . "lime green") 
	   ("DORMANT" . "deep sky blue") ("FINISHED" . "forest green")
	 )
)

;; Define Priority range
;; Only default is changed but others are shown for completness
(setq org-priority-highest '?A) ; '?' means character (I guess)
(setq org-priority-lowest '?C)
(setq org-priority-default '?C)



;;; --- Org Tag Settings 

;; Define globals tags (further tags can be added per file basis)
; This variable is different from org-tag-alist. org-tag-alist tags would
; be turned of when #+TAGS are defined in a file
(setq org-tag-persistent-alist '(
				 ("FLAGGED" . ?f)  ; special tag for agendas
				 ("noexport" . ?n) ; don't export tree and subtrees
				 ("easy" . ?e)
				 ("project" . ?p)
				 ("work" . ?w)
				 ("repeated" . ?r)
))

;; Exclusion of certain tags for tag inheritance
(setq org-tags-exclude-from-inheritance '("project" "FLAGGED"))



;;; --- Properties and Column View
;; Define global properties
(setq org-global-properties
	'(("Effort_ALL" . "0 0:05 0:10 0:20 0:30 0:45 1:00 1:30 2:00 3:00")))

;; Define column view format
(setq org-columns-default-format "%24ITEM %6TODO %4PRIORITY(Prio) %TAGS %CLOCKSUM(Total) %CLOCKSUM_T(Today) %EFFORT{:}")



;;; --- Date/Time Org Settings 
;; Enable sound when countdown is finished
(setq org-clock-sound t) ; standard beep, can be changed

;; Save clock history and running clock when emacs is closed
(setq org-clock-persist t)
(org-clock-persistence-insinuate) ; is needed

;; Set clock history length from 5 to 9
(setq org-clock-history-length 20)

;; Global effort estimates are defined in the variable
;; org-global-properties above in the section Properties and Column View




;;; --- Capture Org Settings 
;; Create capture templates
(setq org-capture-templates
	'(
    ("t" "Templates for TODO entries")
        ("tg" "Todo General (without timestamp)" entry
	        (file+olp (lambda ()
                        (concat org-directory "/Org-Main.org")) "Orga" "General")
		"* TODO %?"
	)
        ("tt" "Today Todo General" entry
	        (file+olp (lambda ()
                        (concat org-directory "/Org-Main.org")) "Orga" "General")
		"* TODO %?\n SCHEDULED: %t"
	)
	("tm" "Tomorrow Todo General" entry
	 	(file+olp (lambda ()
                        (concat org-directory "/Org-Main.org")) "Orga" "General")
		"* TODO %?\n SCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"+1d\"))"
	)
    ("i" "Idea" )
        ("ia" "Academic Idea" entry
	(file+olp (lambda ()
		     (concat org-directory "/Org-Main.org")) "Ideas")
		  "* %?\n %u")
    ("p" "PhD Course Template" entry
        (file (lambda () (concat org-directory "/PhD.org")))
	(file "~/.emacs.d/org-capture-templates/phd-course-template.org")
    )
    ("j" "Journal entries")
        ("jr" "Regular Journal entry" entry 
	 (file+olp+datetree (lambda () 
			      (concat org-directory "/journal.org")))
	 "* Regular Journal entry :regular:\nEntered on %U\n\n%?\n"
	 :clock-in t
	 )
	("jd" "Dream Diary" entry
	 (file+olp+datetree (lambda ()
			      (concat org-directory "/journal.org")))
	 "* Dream Diary :dream-diary:\nEntered on %U\n\n%?\n"
	 :clock-in t
	 )
	("jj" "Joy Diary (Inspiration, Gratitude)" entry
	 (file+olp+datetree (lambda ()
			      (concat org-directory "/journal.org")))
	 "* Joy/Inspiration/Gratitude Diary :joy-diary:\nEntered on %U\n\n%?\n"
	 :clock-in t
	 )
))



;;; --- Refiling Org Settings
;; Define refile targets to move captured content to
(setq org-refile-targets '((org-agenda-files :maxlevel . 4)))



;;; --- Attachment Org Settings 
;; Load module. This is only necessary to provide a function from
;; this module for export when org-attach was not yet invoked.
;; Apparently, the module is only loaded when org-attach is used.
;; The function org-attach-expand-links is then automatically added to
;; org-export-before-parsing-hook
(require 'org-attach)

;; Change programs to use to open attachments
(setq org-file-apps
   (quote
    ((auto-mode . emacs)
     (directory . "nautilus file://%s")
     ("\\.mm\\'" . default)
     ("\\.x?html?\\'" . default)
     ("\\.pdf\\'" . "evince %s ")
     ("\\.tex\\'" . find-file-other-frame) ;; open tex in new frame
     ("\\.Rnw\\'" . find-file-other-frame) ;; open rnw in new frame
     )))

;; Change default method for attachment to directory instead of id
(setq org-attach-preferred-new-method 'ask)

;; Inherit attachments to subtrees
(setq org-attach-use-inheritance t)




;;; --- Agenda Settings 
;; Org Habit
;(setq org-habit-show-habits nil) ; don't show habits in agenda automatically
(setq org-habit-show-all-today t) ; if shown, show also not scheduled habits 

;; Set agenda span to day (default: week)
(setq org-agenda-span 'week)
;; Set default duration of an appointment to 60 minutes
(setq org-agenda-default-appointment-duration 60)

;; Show diary mode in agenda by default
(setq org-agenda-include-diary t)

;; Custom agenda commands
;; first enable org-super-agenda-mode globally in order to use org-super-agenda functions
(org-super-agenda-mode)
(setq org-agenda-custom-commands
      '(
	;; ------ Definition of org-agendas (not org-super-agendas)
	;; Deadline agenda
	("d" "Deadlines" agenda ""
	 ((org-agenda-span 'month)
	  (org-agenda-include-diary nil)        ; exclude diary entries
	  (org-agenda-entry-types '(:deadline))
	  (org-deadline-warning-days 0)         ; don't show future deadlines for today's date
	  ))
	;; ------ Definition of org-super-agenda (separate package) commands 
	;;  agenda
	("g" "Grouped Agenda" agenda ""
	 ((org-agenda-span 'day)			       
	  (org-super-agenda-groups
	   '((:name "Habits" :habit t :order 100) ; gather habits and display at last
	     (:name "Today" :time-grid t)
	     (:name "Overdue and due" :deadline past :deadline today)
	     (:name "Due in next time" :deadline future)
	     (:name "Important" :priority>= "B")
	     (:name "Scheduled Today" :scheduled today)
	     (:name "Work related tasks" :tag "work")
	     (:name "Repeated tasks" :tag "repeated" :order 26)
	     (:name "Tasks in progress" :scheduled past)
             ))
	  ))
	;; Projects 
	("p" "Projects" alltodo ""
	 ((org-super-agenda-groups
	   '(
	     (:name "Projects" :tag "project" :order 1)
	     ;; (:name "Active work projects" :and(:todo "ACTIVE" :tag "work" ) :order 2)
	     ;; (:name "Dormant work projects" :and(:todo "DORMANT" :tag "work") :order 2)
	     ;; (:name "Active non-work projects" :todo "ACTIVE" :order 0)
	     ;; (:name "Work tasks" :tag "work" :order 3)
	     ;; (:name "Prioritized tasks" :priority>= "C" :order 4)
	     ;; (:name "Waiting" :todo "WAITING")
	     (:discard (:anything t))
	     ))
	  ))
	;; Priorities (i = important)
	("i" "Super Importance" alltodo "" (
	 (org-super-agenda-groups '(
	     (:name "Very important tasks" :priority "A")
	     (:name "Important tasks" :priority  "B")
	     (:name "Not directly important tasks" :priority "C")
	     (:discard (:anything t))
	 ))
	))
	;; Log
	("l" "Today's Log" agenda "" (
	 (org-agenda-span 'day)
	 ; enable log-mode by default = in agenda press 'l'
	 (org-agenda-start-with-log-mode '(closed clock state)) 
	 (org-agenda-start-with-clockreport-mode t)
	 (org-super-agenda-groups '(
	     (:name "Items closed today" :log close)
	     (:name "Items clocked today" :log clock)
	     (:discard (:anything t))
	 ))
	))
	;; Future - only future items
	("f" "Future" alltodo "" (
	 (org-super-agenda-groups '(
	    (:discard (:habit t)) ;; exclude habits
	    (:name "Deadlines in the future" :deadline future)
	    (:name "Scheduled in the future" :scheduled future)
	    (:name "Waiting" :todo "WAITING")
 	    (:discard (:anything t))
         )) 
        ))
	;; Auto Category
	("c" "Auto-Category" alltodo "" (
         (org-super-agenda-groups '((:auto-category)))
	))
))

;; Schedule and Deadline on same day: Show only one
(setq org-agenda-skip-scheduled-if-deadline-is-shown t)

;; Only show the next future repeat
;(setq org-agenda-show-future-repeats 'next) ; default: t

;; Faces of org-agenda are set in init.el under 'custom-set-faces'
;; These settings are located there because they are customized from within
;; emacs with:  M-x customize-group RET org-faces
;; see in init.el or result of the command above in which settings are customized



;;; --- Markup Settings 

;; Make LaTeX fragments bigger
(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;; Don't show emphasis markers: *bold* becomes bold
(setq org-hide-emphasis-markers t)




;;; --- Export Settings 
;;;; ------ General Export Settings
;; make sub-tree scope the default
;; don't have to type C-s in dispatcher
(setq org-export-initial-scope 'subtree)

;; Meta export variables
;; author field: user-full-name
;; email: user-mail-address
;; These are not set here because they are set inside mu4e depending on the
;; context and setting them again would mess with the mu4e configuration

;;;; ------ Export templates
;; Actually, the export templates provided by C-c C-e # are really neat but it
;; is quite difficult to modify them or create additional ones. Therefore, I
;; created a function that inserts Org Properties and prompts for user input when
;; necessary. 
(defun my/latex-export-template ()
  (interactive)
  (org-set-property "EXPORT_AUTHOR" "Author's name")
  (org-set-property "EXPORT_DATE" "\\today")
  (org-set-property "EXPORT_FILE_NAME"
		    (concat (read-directory-name "Set export folder: " "~/Documents/")
			    (read-string "Enter filename without extension: ")
			    ))
  (org-set-property "EXPORT_OPTIONS" "toc:nil num:nil")
  (org-set-property "EXPORT_LATEX_CLASS" "article")
  (org-set-property "EXPORT_LATEX_HEADER" "\\input{~/.emacs.d/org-export-setupfiles/latex-article.tex}")
  (org-set-property "EXPORT_LATEX_HEADER_EXTRA"
		    (concat "\\fancyhead[L]{\\itshape "
			    (read-string "Enter short title for left header: ")
			    "}"))
  )

;; Bind function to kbd
(define-key org-mode-map (kbd "C-c C-#") 'my/latex-export-template)


;;;; ------ LaTeX and Beamer Export Settings
;; Set hyperref template
;; only lines after pdflang added
(setq org-latex-hyperref-template
"\\hypersetup{
 pdfauthor={%a},
 pdftitle={%t},
 pdfkeywords={%k},
 pdfsubject={%d},
 pdfcreator={%c}, 
 pdflang={%L},
 %% Color options
 colorlinks=true,
 citecolor=[rgb]{0, 0, 0.5}, %% NavyBlue
 linkcolor=[rgb]{0, 0, 0.5},
 urlcolor=[rgb]{0, 0, 0.5},
 %% Other options
 bookmarksopen=true, %% opens toc in viewer
}
")


;;;; ------ Beamer export
(require 'ox-beamer)


;;;; ------ Reveal export
(require 'ox-reveal)
;; Set location to reveal.js folger in URL form
(setq org-reveal-root "file:///home/USER/Programs/reveal.js-master") 
;; Export into a single file (with images etc.)
(setq org-reveal-single-file t)


;;;; ------ iCalendar Export Settings
;; change default location of combined ics file of all agenda files
(setq org-icalendar-combined-agenda-file "~/Documents/org/calendar-org.ics")
;; insert description for combined icalendar export
(setq org-icalendar-combined-description "Combined export of Org agenda files.")

;; Export scheduled items that have todo states (including DONE) and that have no todo state
;; Added "event-if-todo" and "event-if-not-todo"
(setq org-icalendar-use-scheduled '(todo-start event-if-todo event-if-not-todo))

;; Export deadline items that have todo states
;; Added event-if-todo
(setq org-icalendar-use-deadline '(event-if-not-todo todo-due event-if-todo))

;; Exclude habits in icalendar export
;; icalendar doesn't respect org-export-exclude-tags!
(setq org-icalendar-exclude-tags '("habit"))

;; Add hook for icalendar export (backend specific)
;; Define function and add it as a hook
(defun my-icalendar-export-addition (backend)
  "Hook for icalendar export. Disable src code execution for faster export."
    (when (org-export-derived-backend-p backend 'icalendar)
      (setq-local org-export-use-babel nil) ;; prohibit babel execution
      (setq-local org-export-with-broken-links t) ;; avoid error: link is not resolvable
      (message "Start of icalendar agenda export.")
      )
    ) 

;; Add function to export hook
(add-hook 'org-export-before-processing-hook #'my-icalendar-export-addition)
;; In addition, it is necessary that org-export-before-parsing-hook contains
;; org-attach-expand-links for attachment links. This is ensured by requiring
;; org-attach above.


;; create combined ics file every 30 minutes
;; ics file is uploaded to nextcloud an used there (see Calendar syncing via Nextcloud)
;; 300 = start after delay of 300 seconds = 5 minutes; async init has to be created before
;; (* 45 60) = repeat every X second; results in 45 minutes
(run-with-timer 300 (* 45 60) 'org-icalendar-combine-agenda-files t) ;; t for async
;; if something bad happens run M-x list-timers then choose timer and c for cancel


;;;; ------ Async Export Settings
;; Add initialization file for async export
;; must come after other export settings in order that variable definitions are used
;; Async export creates new instance of emacs with this init file
(setq org-export-async-init-file "~/.emacs.d/org-export-setupfiles/async-init.el")

;; Use next line for debugging purposes
;;(setq org-export-async-debug t)

;; Create directory for async-init file if non-existing
(make-directory (file-name-directory org-export-async-init-file) ; get dir name of async init
		t) ; creates directory if non-existing

;; Create specified async-init.el file
;; based on the variables and functions in this file here
;; I'm not truly satisfied with this solution.
;; Info: write-region should not be used with visited files. However, files are visited
;; after init, therefore it is no problem but overwrites the file everytime.
(write-region (concat 
";; Emacs initialization file for async export in org-mode
;; file is the value of org-export-async-init-file

;; Attention !!!!!!
;; Do not edit this file by hand because it is overwritten at startup
;; Edit this file in init-org.el where it is created

;;; --- General Export Settings/Copies 
(setq org-export-with-broken-links 'mark)


;;; --- iCalendar Export Copies 
(setq 
	org-icalendar-combined-agenda-file \"" org-icalendar-combined-agenda-file "\"
	org-icalendar-use-scheduled '" (prin1-to-string      ; pay attention to ' before "
					org-icalendar-use-scheduled) "
	org-icalendar-use-deadline '" (prin1-to-string       ; pay attention to ' before "
				       org-icalendar-use-deadline) "
	org-agenda-default-appointment-duration " (number-to-string
						   org-agenda-default-appointment-duration) "
	org-icalendar-exclude-tags '"(prin1-to-string        ; pay attention to ' before "
				      org-icalendar-exclude-tags)
	")

;; Hook for exports
;; this is the my-icalendar-export-addition function
(add-hook 'org-export-before-processing-hook " (prin1-to-string
						(symbol-function 'my-icalendar-export-addition)) ")"
						) ; end of concat and START argument
	      nil ; END argument which is ignored
	      org-export-async-init-file ; file argument
	      )

;; end of creation of async-init file (write-region command)




;;; --- Citation Settings

;; make different processors available
(require 'oc-biblatex)		 ; biblatex 
(require 'oc-csl) 		 ; citation syle language via citeproc

;; Define global bibliography
(setq org-cite-global-bibliography bibtex-completion-bibliography) ; see init.el
;; Define csl styles directory
;; Directory is clone of csl styles github repo
(setq org-cite-csl-styles-dir "~/.emacs.d/org-export-setupfiles/styles")


;; Make org-ref-cite processors available
;; makes org-ref functionality available using org-cite
(add-to-list 'load-path "~/.emacs.d/org-ref-cite") ; cloned github repo
(require 'org-ref-cite)				   ; load package

;; Define cite processors
(setq
 org-cite-activate-processor 'org-ref-cite
 org-cite-follow-processor 'org-ref-cite 	; opening cite links with org-ref-cite
 org-cite-insert-processor 'org-ref-cite	; insert using bibtex
 org-cite-export-processors
      '((latex biblatex "apa") 		; apa = bibstyle
	(t csl "apa.csl" "apa.csl")))   ; apa.csl file in org-cite-csl-styles-dir


;; Define keybinding for citations
(define-key org-mode-map (kbd "C-¢") 'org-cite-insert) ; C-<Alt Gr>-c




;;; --- Babel Settings 
;; Define languages that are loaded and are hence supported
(org-babel-do-load-languages
	'org-babel-load-languages
	'((emacs-lisp . t)
	  (R . t)
	  (python . t)
	  (shell . t)))


;; Redefine prompt for executing
;; For safety reasons I previously changed only file local settings instead of this global
;; one but this is also not safe since it is considered a safe local variable for every
;; file. Therefore, I wrote a function that gets the buffer name and if it is in the
;; agenda files, then don't prompt for confirmation. Inspired by org manual.
(defun my-org-confirm-babel-evaluate (lang body)
  (let		                        ; define temp variables and execute body
      ;; variable definition
      (
       ;; variable containing org agenda files with absolute paths
       (files-org-agenda (replace-regexp-in-string
			  "~"                            ; to replace
			  (expand-file-name "")          ; substitution, gives home directory
			  (format "%s" org-agenda-files) ; agenda files as string "(~/... ~/...)"
	 )
	)
       ;; variable containing buffer file name with absolute path
       (buffer-file (buffer-file-name))
       )				; end of variable definition
    
    ;; code block
    ;; match current file in agenda files. if match returns index, else nil
    ;; revert index to nil and nil to t with (null) and return
    (null (string-match buffer-file files-org-agenda))
    )
 )

;; Set confirm variable to function
;; nil = no confirmation; t = prompts for confirmation 
(setq org-confirm-babel-evaluate #'my-org-confirm-babel-evaluate)


;; Change system-wide header arguments for source blocks
;; cons function adds header arg, assq-delete-all deletes same preexisting header arg
;; Export both, code and result
(setq org-babel-default-header-args (cons '(:exports . "both")
					  (assq-delete-all :exports org-babel-default-header-args)))
;; Output column names in result
(setq org-babel-default-header-args (cons '(:colnames . "yes")
					  (assq-delete-all :colnames org-babel-default-header-args)))
