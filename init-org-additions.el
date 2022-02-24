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
