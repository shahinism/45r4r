;;; init.el --- Emacs configuration -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Add lisp folder to load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'sh-emacs)
(require 'sh-utils)
(require 'sh-ui)
(require 'sh-keys)
(require 'sh-completion)
(require 'sh-code)
(require 'sh-note)


;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((eval let
           ((project-root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq org-roam-directory
                 (expand-file-name "roam" project-root))
           (setq org-roam-db-location
                 (expand-file-name "org-roam.db" org-roam-directory))
           (setq org-hugo-base-dir (expand-file-name "." project-root))
           (setq org-hugo-front-matter-format "yaml")
           (when (fboundp 'org-roam-db-autosync-enable)
             (org-roam-db-autosync-enable))
           (org-hugo-auto-export-mode))
     (eval let
           ((project-root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq org-roam-directory
                 (expand-file-name "roam" project-root))
           (setq org-roam-db-location
                 (expand-file-name "org-roam.db" org-roam-directory))
           (setq org-hugo-base-dir (expand-file-name "." project-root))
           (org-hugo-front-matter-format "yaml")
           (when (fboundp 'org-roam-db-autosync-enable)
             (org-roam-db-autosync-enable))
           (org-hugo-auto-export-mode))
     (eval let
           ((project-root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq org-roam-directory
                 (expand-file-name "roam" project-root))
           (setq org-roam-db-location
                 (expand-file-name "org-roam.db" org-roam-directory))
           (setq org-hugo-base-dir (expand-file-name "." project-root))
           (org-hugo-front-matter-format . "yaml")
           (when (fboundp 'org-roam-db-autosync-enable)
             (org-roam-db-autosync-enable))
           (org-hugo-auto-export-mode))
     (eval let
           ((project-root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq org-roam-directory
                 (expand-file-name "roam" project-root))
           (setq org-roam-db-location
                 (expand-file-name "org-roam.db" org-roam-directory))
           (setq org-hugo-base-dir (expand-file-name "." project-root))
           (when (fboundp 'org-roam-db-autosync-enable)
             (org-roam-db-autosync-enable))
           (org-hugo-auto-export-mode))
     (eval let
           ((project-root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq org-roam-directory
                 (expand-file-name "roam" project-root))
           (setq org-roam-db-location
                 (expand-file-name "org-roam.db" org-roam-directory))
           (setq org-hugo-base-dir
                 (expand-file-name "content" project-root))
           (when (fboundp 'org-roam-db-autosync-enable)
             (org-roam-db-autosync-enable))
           (org-hugo-auto-export-mode))
     (eval let
           ((project-root
             (locate-dominating-file default-directory
                                     ".dir-locals.el")))
           (setq org-roam-directory
                 (expand-file-name "roam" project-root))
           (setq org-roam-db-location
                 (expand-file-name "org-roam.db" org-roam-directory))
           (setq org-hugo-base-dir
                 (expand-file-name "content" project-root))
           (when (fboundp 'org-roam-db-autosync-enable)
             (org-roam-db-autosync-enable)))
     (eval when (derived-mode-p 'org-mode) (org-hugo-auto-export-mode)
           (setq-local org-hugo-base-dir (expand-file-name "../"))
           (setq-local org-hugo-front-matter-format "yaml"))
     (eval when (derived-mode-p 'org-mode) (org-hugo-auto-export-mode)
           (setq-local org-hugo-base-dir
                       (expand-file-name "../content"))
           (setq-local org-hugo-front-matter-format "yaml"))
     (eval when (derived-mode-p 'org-mode) (org-hugo-auto-export-mode)
           (setq-local org-hugo-base-dir
                       (expand-file-name "./content"))
           (setq-local org-hugo-front-matter-format "yaml"))
     (org-mode (eval org-hugo-auto-export-mode)
               (eval setq-local org-hugo-base-dir
                     (expand-file-name "./content"))
               (org-hugo-front-matter-format . "yaml"))
     (eval setq-local org-roam-db-location
           (expand-file-name "org-roam.db" org-roam-directory))
     (eval setq-local org-roam-directory (expand-file-name "./roam")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
