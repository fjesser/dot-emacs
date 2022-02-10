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
; first enable org-super-agenda-mode globally in order to use org-super-agenda functions
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

