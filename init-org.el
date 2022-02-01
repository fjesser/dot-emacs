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
