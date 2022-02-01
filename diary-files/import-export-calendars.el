;;; import-export-calendars.el --- Import calendars
;; run from shell: emacs -Q -batch -l ~/.emacs.d/diary-files/import-export-calendars.el

;;; --- Preparations

;;;; ------ Repeat important init variables
;; because  file is sourced without any init

;; Set calendar style to the style specified in init
(setq calendar-date-style 'iso)
;; Set diary file to value specified in init
(setq diary-file "~/.emacs.d/diary-files/diary-main")


;;;; ------ Definition of additional variables
;; diary folder where all diary files are stored
(setq-local diary-folder
	    "~/.emacs.d/diary-files/")

;; WebDav links of the calendars to import
;; Note, the calendar urls are later appended by "?export" which allows for downloading
;; one ics file via GET request
;; No trailing slash in link!
(setq-local calendars-webdav
	    '("https://MY-NEXTCLOUD.de/remote.php/dav/calendars/USER/CALENDAR1"
	      "https://MY-NEXTCLOUD.de/remote.php/dav/calendars/USER/CALENDAR2"
	      ))

;; Set export path for main diary file
(setq-local exported-diary-file "~/Documents/org/calendar-diary.ics")

      
;;; --- Importing icalendars
;; Loop over 
(mapcar (lambda (ics-url)
	  (let*  ; * necessary because ics-file depends diary-name in varlist
	      
	      ;; Varlist
	      (
	       (diary-name (file-name-nondirectory ics-url))
	       (ics-file (concat diary-folder diary-name ".ics"))
	       )
	    
	    ;; Body
	    ;; Create/Overwrite diary file
	    ;; Insert information that diary-mode should be used when file is opened
	    ;; Since it is intended to run this script without any init file
	    ;; The inserted ";;" correspond to my set diary-comment-start and diary-comment-end
	    (write-region ";; -*- mode: diary -*- ;;" 
			  nil
			  (concat diary-folder diary-name))

	    
	    ;; Download ics file
	    (shell-command-to-string
	     (concat
	      "curl -s -u USER:$(gpg -dq ~/.authinfo.gpg | grep nextcloud | cut -d' ' -f6) -X GET "
	      ics-url
	      "?export"
	      " -o " ics-file
	      ))
	    ;; Explanation of the fantastic curl command
	    ;; 1) s = silent, no progress bar
	    ;; 2) u = USER:PASS for authentification; PASS ist gpg command that accesses authinfo
	    ;; file and selects the password for nextcloud (grep gets line; cut gets 6th field)

	    ;; Import ics-file
	    (icalendar-import-file
	     ics-file
	     diary-name)

	    ;; Kill buffer since ics file was opened 
	    (kill-buffer (file-name-nondirectory ics-file))
	    ;; Delete ics-file
	    (delete-file ics-file)

	    ;; Output message
	    (message (concat "Imported " ics-file))

	    
	    ))
	    
	calendars-webdav)


;;; --- Cleanup birthday diary file
;; Nexcloud has some special birthdaycake symbol in the description of each entry
;; Remove this entry and replace it with "Birthday"

(setq-local birthday-diary "contact_birthdays")
;; Open diary file
(find-file (concat diary-folder birthday-diary))
;; Go to the beginning of the buffer
(goto-char (point-min))
;; Prettify Entries and Save
;; replace cake nextcloud symbol by Birthday
(replace-regexp "))  ." ")) Birthday") ; . matches crazy nextcloud symbol
(save-buffer)

;; Switch to this script again to make local variables available again
;; and kill diary buffer
(switch-to-prev-buffer)
(kill-buffer birthday-diary)



;;; --- Export main diary file to ics
;; Delete file in order to avoid duplicates
(delete-file exported-diary-file)

;; Export main diary file to ics
;; It is exported into folder which is synced with Nextcloud
(icalendar-export-file diary-file	; make use of diary file variable
		       exported-diary-file)
