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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("/home/shahin/org/engineering.org" "/home/shahin/org/learning.org" "/home/shahin/org/meetings.org" "/home/shahin/org/para.org" "/home/shahin/org/projects.org" "/home/shahin/org/todo.org"))
 '(package-selected-packages '(blackout el-get straight hydra leaf-keywords leaf)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
