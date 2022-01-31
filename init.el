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

