;;; sh-notes.el --- Note taking in Emacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(provide 'sh-note)

(leaf org
  :url "https://orgmode.org/"
  :ensure t
  ;; :tag "builtin"
  :preface
  ;; customize electric pairing behaviour
  (defvar sh/org-electric-pair-pairs
    '((?~ . ?~) (?= . ?=))
    "Pairs for `sh/org-electric-pair'.")

  (defun sh/org-electric-pair-inhibit-p (char)
    "Do not insert closing `>' if CHARis part of a pair."
    (if (char-equal char ?<)
        t
      (electric-pair-default-inhibit char)))

  (defun sh/org-electric-pair-mode ()
    "Enable electric pair mode for org-mode."
    (electric-pair-mode t)
    (setq-local electric-pair-pairs (append electric-pair-pairs sh/org-electric-pair-pairs))
    (setq-local electric-pair-text-pairs (append electric-pair-text-pairs sh/org-electric-pair-pairs))
    (setq-local electric-pair-inhibit-predicate #'sh/org-electric-pair-inhibit-p)
    )
  :hook
  (org-mode-hook . sh/org-electric-pair-mode)
  :config
  (require 'org-tempo) ;; enable org templates; by default it's disabled
  ;; on Org > 9.2, more info:
  ;; https://emacs.stackexchange.com/a/46992

  (setq org-startup-indented t
        org-startup-folded t
        org-todo-keywords '((sequence "TODO(t)" "ACTIVE(a)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c@)"))
        org-use-speed-commands t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-directory "~/org"
        org-agenda-files (list "~/org" "~/org/roam/daily")
        org-log-refile t
        org-refile-use-outline-path t
        org-outline-path-complete-in-steps nil
        org-refile-targets
        '((org-agenda-files . (:maxlevel . 2)))
        org-capture-templates
        '(("t" "Task Entry"        entry
           (file+headline "~/org/todo.org" "Inbox")
           "* [ ] %?
:PROPERTIES:
:Added:     %U
:END:" :empty-lines 0)
          ))

  ;; Return or left-click with mouse should follow links
  (customize-set-variable 'org-return-follows-link t)
  (customize-set-variable 'org-mouse-1-follows-link t)

  ;; Display links as the description provided
  (customize-set-variable 'org-descriptive-links t)

  ;; Hide markup markers
  ;; disable auto-pairing of "<" in org mode
  (customize-set-variable 'org-hide-emphasis-markers t)

  (with-eval-after-load 'org
    (org-indent-mode t)
    (require 'org-id))
  )

(leaf org-appear
  :url "https://github.com/awth13/org-appear"
  :doc "Toggle visibility of hidden org-mode elements"
  :ensure t
  :after org
  :hook
  (org-mode-hook . org-appear-mode))

(leaf org-bullets
  :url "https://github.com/sabof/org-bullets"
  :doc "utf-8 bullets for org-mode"
  :ensure t
  :after org
  :hook
  (org-mode-hook . org-bullets-mode))

(leaf org-roam
  :url "https://www.orgroam.com/"
  :ensure t
  :custom
  (org-roam-directory . "~/org/roam")
  (org-roam-completion-everywhere . t)
  :bind
  (("C-c n" . org-roam/body)
   (:org-mode-map
    ("C-M-i" . completion-at-point)))
  :pretty-hydra
  ((:color teal :quick-key "q")
   ("Roam"
    (("f" org-roam-find-file "find file")
     ("g" org-roam-graph "graph")
     ("i" org-roam-insert "insert")
     ("r" org-roam "roam")
     ("u" org-roam-update "update"))
    "Node"
    (("n" org-roam-node-find "find node")
     ("N" org-roam-node-insert "insert node")
     ("l" org-roam-buffer-toggle "toggle buffer")
     ("c" org-roam-capture "capture")
     ("s" org-roam-node-random "random node"))
    "Daily"
    (("t" org-roam-today "today"))
    "Backlinks"
    (("b" org-roam-backlinks "backlinks")
     ("B" org-roam-backlinks-insert "insert backlinks"))
    ))
  :init
  (setq org-roam-v2-ack t)
  :config
  (org-roam-setup))

(leaf org-download
  :url "https://github.com/abo-abo/org-download"
  :doc "Drag and drop images to Emacs org-mode"
  :ensure t
  :after org
  :config
  (setq org-download-method 'directory
        org-download-heading-lvl nil
        org-download-timestamp "_%Y%m%d-%H%M%S"
        org-image-actual-width t
        org-download-screenshot-method "flameshot gui --raw > %s")

  (customize-set-variable 'org-download-image-dir "images"))

(leaf org-modern
  :url "https://github.com/minad/org-modern"
  :doc "Modern theme for org-mode"
  :ensure t
  :after org
  :hook
  (org-mode-hook . org-modern-mode))
