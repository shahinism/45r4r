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
  :bind
  (("C-c o" . org/body))
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Org"
    (
     ("c" org-capture "capture")
     ("l" org-store-link "store link")
     ("b" org-switchb "switch buffer")
     ("r" org-refile "refile")
     ("i" org-id-get-create "id")
     ("m" org-tags-view "tags")
     ("f" org-footnote-action "footnote")
     ("e" org-export-dispatch "export")
     ("o" org-open-at-point "open")
     ("u" org-update-all-dblocks "update dblocks"))
    "Task"
    (("a" org-agenda "agenda")
     ("t" org-todo-list "todo list")
     ("s" org-schedule "schedule")
     ("d" org-deadline "deadline")
     ("p" org-priority "priority"))
    "Babel"
    (("v" org-babel-tangle "tangle")
     ("x" org-babel-execute-buffer "execute")
     ("X" org-babel-execute-subtree "execute subtree")
     ("y" org-babel-execute-src-block "execute block")
     ("z" org-babel-switch-to-session "switch session")
     ("w" org-babel-previous-src-block "previous block")
     ("W" org-babel-next-src-block "next block")
     ("q" org-babel-demarcate-block "demarcate block")
     ("j" org-babel-insert-header-arg "insert header arg")
     ("k" org-babel-remove-header-arg "remove header arg")
     ("l" org-babel-load-in-session "load in session")
     ("n" org-babel-goto-named-src-block "goto named block")
     ("N" org-babel-goto-named-result "goto named result")
     ("h" org-babel-describe-session "describe session")
     ("H" org-babel-describe-session-in-popup "describe session in popup")
     ("M" org-babel-view-src-block-info "view block info")
     ("P" org-babel-view-src-block-result "view block result")
     ("R" org-babel-view-src-block-result-in-popup "view block result in popup")
     ("S" org-babel-view-src-block-result-other-window "view block result other window")
     ("T" org-babel-tangle-jump-to-org "tangle jump to org"))))
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
          ("p" "People"           entry
           (file+headline "~/org/meetings.org" "People")
           "* %^{Name}
:PROPERTIES:
:BIRTHDAY: %^{Birthday}
:EMAIL: %^{Email}
:PHONE: %^{Phone}
:LINKEDIN: %^{Linkedin}
:END:" :empty-lines 0)
          ("l" "Engineering Log"  entry
           (file+datetree "~/org/engineering.org")
           "**** %<%H:%M:%S> %^{Title} %^g\n- %?" :empty-lines 0)))

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
    (("g" org-roam-graph "graph")
     ("z" org-roam "roam"))
    "Node"
    (("n" org-roam-node-find "find node")
     ("i" org-roam-node-insert "insert node")
     ("l" org-roam-buffer-toggle "toggle buffer")
     ("c" org-roam-capture "capture")
     ("s" org-roam-node-random "random node"))
    "Daily"
    (("d" org-roam-dailies-goto-today "today"))
    "Tags"
    (("t" org-roam-tag-add "add tag")
     ("T" org-roam-tag-remove "remove tag"))
    "References"
    (("r" org-roam-ref-add "Add reference")
     ("R" org-roam-ref-remove "Remove reference"))
    ))
  :init
  (if (not (file-directory-p org-roam-directory))
      (make-directory (expand-file-name "daily" org-roam-directory) t))
  (setq org-roam-v2-ack t)
  :config
  (setq org-roam-node-display-template
      (concat "${title:*} "
              (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-setup))

(leaf org-roam-ui
  :url "https://github.com/org-roam/org-roam-ui"
  :doc "A graphical frontend for exploring your org-roam"
  :straight
  (org-roam-ui :host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

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

  (customize-set-variable 'org-download-image-dir "images")

  (require 'org-download))

(leaf org-modern
  :url "https://github.com/minad/org-modern"
  :doc "Modern theme for org-mode"
  :ensure t
  :after org
  :hook
  (org-mode-hook . org-modern-mode))

(leaf org-super-links
  :url "https://github.com/toshism/org-super-links"
  :doc "Supercharge your org-mode links"
  :straight (org-super-links :host github :repo "toshism/org-super-links" :branch "develop")
  :bind (("C-c s" . org-super-links/body))
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Link"
    (("c" org-super-links-link "create")
     ("s" org-super-links-store-link "store")
     ("l" org-super-links-insert-link "insert")
     ("r" org-super-links-delete-link "delete"))
    "Quick"
    (("d" org-super-links-quick-insert-drawer-link "drawer")
     ("i" org-super-links-quick-insert-inline-link "inline"))
    ))
  :init
  (require 'org-id)
  :custom
  (org-super-links-related-into-drawer . t)
  (org-super-links-link-prefix . 'org-super-links-link-prefix-timestamp)
  (org-id-link-to-org-use-id . 'create-if-interactive-and-no-custom-id)
  )
