;;; init-org-additions.el --- Configuration File for additional org packages
;; This file is loaded from the emacs init file "~/.emacs.d/init.el"
;; use outline-minor-mode (L1: ;;; L2: ;;;; etc.)
;; my prefix: C-c C-u, use with C-n, C-p etc., C-<TAB> to fold


;;; --- Org-Roam Ecosystem

;;;; ------ General Org-Roam Settings
;; Set default org-roam directory
(setq org-roam-directory
      (file-truename "~/Documents/org/org-roam"))

;; Resync database when files change
(org-roam-db-autosync-mode)

;; Set org-roam buffer display as a regular window
(add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-direction)
               (direction . right)
               (window-width . 0.33)
               (window-height . fit-window-to-buffer)))


;; Change display formatting when searching for org-roam-nodes
;; more space for tags
(setq org-roam-node-display-template "${title:125} ${tags:75}")



;;;;; --------- Org-Roam keybindings
;; Org mode ID function
(global-set-key (kbd "C-c M-i") 'org-id-get-create)                ; actually not org-roam
;; All org-roam functions have the prefix C-ö
(global-set-key (kbd "C-ö f") 'org-roam-node-find)                 ; find/create org-roam file
(global-set-key (kbd "C-ö i") 'org-roam-node-insert)               ; insert link
(global-set-key (kbd "C-ö c") 'org-roam-capture)                   ; create org-roam file
(global-set-key (kbd "C-ö b") 'org-roam-buffer-toggle)             ; toggle roam buffer
(global-set-key (kbd "C-ö d") 'org-roam-buffer-display-dedicated)  ; choose roam buffer
(global-set-key (kbd "C-ö a") '(lambda () ; C-ö a = add alias; with C-u remove alias
				 (interactive)			    
				 (if (equal current-prefix-arg nil)            ; if no C-u
				     (call-interactively 'org-roam-alias-add)  ; add alias
				   (call-interactively 'org-roam-alias-remove) ; else remove alias
				     )))
(global-set-key (kbd "C-ö r") '(lambda () ; C-ö r = add ref; with C-u remove ref
				 (interactive)			    
				 (if (equal current-prefix-arg nil)          ; if no C-u
				     (call-interactively 'org-roam-ref-add)  ; add ref
				   (call-interactively 'org-roam-ref-remove) ; else remove ref
				     )))
(global-set-key (kbd "C-ö g") 'org-roam-graph)


;;;;; --------- Org-Roam Templates 
;; Define org-roam templates - called by org-roam-capture (C-ö c)
;; Note: (1) Several templates prompt for a directory to save the file in. This
;; works by providing an elisp %(sexp) within the target file string. See
;; variable-help for information. (2) Org-roam-bibtex templates are also set
;; here. For further package config see below.
(setq org-roam-capture-templates
      '(
	;; Default template
	("d" "Default Roam Template" plain "%?"
	 :target (file+head "%(read-directory-name \"Dir: \" 
				org-roam-directory)/%<%Y%m%d%H%M%S>-${slug}.org"
			    "#+title: ${title}\n")
	 :unnarrowed t
	 )
	;; Ideas template 
	("i" "Ideas Roam Template" plain "%?"
	 :target (file+head "ideas/%<%Y%m%d%H%M%S>-${slug}.org"
			    "#+title: ${title}\n")
	 :unnarrowed t
	 )
       ;; ------ Org-roam-bibtex templates
       ;; Reference template 
       ("r" "Bibliographic Reference (Prompt for dir)" plain
	(file "~/.emacs.d/org-capture-templates/orb-template.org")
        :target (file "%(read-directory-name \"Dir: \" 
			org-roam-directory)/${citekey}.org")
	:unnarrowed t)
       ;; Psychology template (same as reference but different dir start)
       ("p" "Psychology - Bibliography Reference (Prompt for dir)" plain
	(file "~/.emacs.d/org-capture-templates/orb-template.org")
        :target (file "%(read-directory-name \"Dir: \" 
                  (concat org-roam-directory \"/psychology\"))/${citekey}.org")
	:unnarrowed t)
       ;; Reference template with noter (org-roam-bibtex)
       ("n" "Bibliographic Reference With Noter (Prompt for Dir)" plain
	(file "~/.emacs.d/org-capture-templates/orb-noter-template.org")
       :target (file "%(read-directory-name \"Dir: \" 
                  (concat org-roam-directory \"/psychology\"))/${citekey}.org")
	:unnarrowed t)
       
       ))



;;;;; --------- Org-roam Graphing Options 
;; Note, these options influence the behavior
;; of M-x org-roam-graph which creates an image (svg). 
;; See additional configuration options on the website of graphviz.
;; Graphviz is a program which is used by org-roam to graph the network. 

;; Use graphviz program neato which is more compact than dot
(setq org-roam-graph-executable "neato")

;; Open produced graph with Emacs view file instead of firefox
(setq org-roam-graph-viewer nil)


;; Options for Graph (G) attributes
(setq org-roam-graph-extra-config '(
				    ("rankdir" . "TB")
				    ("center" . "true")
				    ("overlap" . "false") ; no overlap with neato
				    ;; ("bgcolor" . "red") ; background color of everything
))

;; Options for the Node (N) attributes
(setq org-roam-graph-node-extra-config
      '(("id"
	 ("style" . "bold,rounded,filled")
	 ("fillcolor" . "#FFFFFF")	; white
	 ("color" . "#C9C9C9")
	 ("fontcolor" . "#111111"))
	("http"
	 ("style" . "rounded,filled")
	 ("fillcolor" . "#FFFFFF")	; white
	 ("color" . "#C9C9C9")
	 ("fontcolor" . "#0A97A6"))
	("https"
	 ("style" . "rounded,filled")
	 ("fillcolor" . "#FFFFFF")	; white
	 ("color" . "#C9C9C9")
	 ("fontcolor" . "#0A97A6"))
	))

;; Options for the Edges (E) attributes
(setq org-roam-graph-edge-extra-config
      '(("decorate" . "true")
	;("dir" . "back") ; direction of arrow
	))


;; Define long title after 25 characters
(setq org-roam-graph-max-title-length 25) ; default: 100
;; Wrap long titles
(setq org-roam-graph-shorten-titles 'wrap) ; default: truncate



;;;; ------ Org Roam Bibtex Settings 
;; Templates of org-roam-bibtex are specified in the org-roam-capture-template

;; load package
(require 'org-roam-bibtex)

;; Enable org-roam-bibtex minor mode when org-roam-mode is activated
;; assures that correct notes are selected when using ivy-bibtex
(add-hook 'org-roam-mode-hook #'org-roam-bibtex-mode)

;; org-roam-bibtex key-bindings
(global-set-key (kbd "C-ö C-i") 'orb-insert-link)  
(global-set-key (kbd "C-ö C-a") 'orb-note-actions) 

;; It's possible to set the interface when using M-x orb-insert-link
;; (e.g, to 'ivy-bibtex) with the variable orb-insert-interface.
;; However, this is only possible with the Customize interface. Sine I
;; don't use this function often I skipped it.

;; Citation key format for ROAM_REFS property
(setq orb-roam-ref-format 'org-cite)	; use native org citation support


;; Default link description inserted by M-x orb-insert-link
;; if citation link is of interest use org-cite-insert
(setq orb-insert-link-description 'title)

;; Set preformat keywords in order that bibtex-fields can be expanded in orb-templates
(setq orb-preformat-keywords
      '("citekey" "entry-type" "date" "year" "pdf?" "note?" "file"
	"author" "editor" "author-abbrev" "editor-abbrev"
	"author-or-editor-abbrev" "title" "keywords"))

;; Change autogenerated citation key
;; used for ORB PDF Scrapper
(setq orb-autokey-format "%A%y")


;;;; ------ Org-Roam-UI Settings
;; Set key bindings
(global-set-key (kbd "C-ö C-m") 'org-roam-ui-mode)         ; m for mode
(global-set-key (kbd "C-ö C-f") 'org-roam-ui-follow-mode)  ; f for follow
(global-set-key (kbd "C-ö C-o") 'org-roam-ui-open)         ; open ui when in node

;; When killing emacs, disable org-roam-ui-mode
;; Otherwise, when starting emacs an error can occur:
;; "websocket-server: Cannot bind server socket: Address already in use"
;; meaning that orui is already running. This interferes with initialization;
;; desktop session is not fully rebuilded.
;; kill-emacs hook wants function; if orui enabled, disable it
(add-hook 'kill-emacs-hook '(lambda () (if org-roam-ui-mode (org-roam-ui-mode -1))))

;; Do not open orui on startup
(setq org-roam-ui-open-on-start nil)

;; Do not sync emacs with with orui
(setq org-roam-ui-sync-theme nil)

;; Do not use ref title for citations
;; use of orb expand templates
(setq org-roam-ui-ref-title-template "%^{citekey}: %^{title}")


