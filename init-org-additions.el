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
