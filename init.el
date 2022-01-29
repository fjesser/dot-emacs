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

