;;; sh-utils.el --- Emacs Lisp utilities -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(provide 'sh-utils)

;; Simplify reloading my configuration
(defun reload-emacs ()
  "Reload Emacs configuration."
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "C-c r") 'reload-emacs)

;; It is the opposite of fill-paragraph
;; by: Stefan Monnier <foo at acm.org>.
(defun unfill-paragraph (&optional region)
  "Unfill the paragraph at point.
When REGION is non-nil, unfill each paragraph in the region,"
  (interactive (progn (barf-if-buffer-read-only) '(t)))
  (let ((fill-column (point-max))
        ;; This would override `fill-column' if it's an integer.
        (emacs-lisp-docstring-fill-column t))
    (fill-paragraph nil region)))

(define-key global-map "\M-Q" 'unfill-paragraph)

(leaf exec-path-from-shell
  :doc "Get environment variables such as $PATH from the shell"
  :req "emacs-24.1" "cl-lib-0.5"
  :url "https://github.com/purcell/exec-path-from-shell"
  :if (memq window-system '(mac ns x))
  :ensure t
  :init
  (exec-path-from-shell-initialize))

(leaf direnv
  :doc "direnv integration"
  :url "https://github.com/wbolster/emacs-direnv"
  :ensure t
  :init
  (direnv-mode))

(leaf undo-fu-session
  :doc "Persist undo history between sessions"
  :url "https://github.com/emacsmirror/undo-fu-session"
  :ensure t
  :hook
  (after-init . global-undo-fu-session-mode)
  :custom
  (undo-fu-session-linear . nil)
  (undo-fu-session-file-limit . nil)
  (undo-fu-session-incompatible-files . '("\\.gpg$"
                                        "/COMMIT_EDITMSG\\'"
                                        "/git-rebase-todo\\'"))
  :config
  (setq undo-fu-session-directory (sh/cache-dir "undo-fu-session"))
  (when (executable-find "zstd")
    (setq undo-fu-session-compression 'zstd))
  )

(leaf vundo
  :doc "Visualize undo history"
  :url "https://github.com/casouri/vundo"
  :ensure t
  :commands (vundo)
  :custom
  (vundo-compact-display . t)
  :bind
  ("C-c u" . vundo)
  (vundo-mode-map
        ("l" . vundo-forward)
        ("h" . vundo-backward)
        ("n" . vundo-next)
        ("p" . vundo-previous)
        ("q" . vundo-quit))
  :config
  (setq vundo-glyph-alist vundo-unicode-symbols)
  )

(leaf ace-window
  :doc "Quickly switch windows"
  :url "https://github.com/abo-abo/ace-window"
  :ensure t
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Actions"
    (("TAB" other-window "switch")
     ("d" ace-delete-window "delete" :color amaranth)
     ("m" ace-delete-other-windows "maximize")
     ("s" ace-swap-window "swap")
     ("a" ace-select-window "select"))
    "Move"
    (("h" windmove-left "←")
     ("j" windmove-down "↓")
     ("k" windmove-up "↑")
     ("l" windmove-right "→"))

    "Resize"
    (("H" move-border-left "←" :color amaranth)
     ("J" move-border-down "↓" :color amaranth)
     ("K" move-border-up "↑" :color amaranth)
     ("L" move-border-right "→" :color amaranth)
     ("n" balance-windows "balance")
     ("f" toggle-frame-fullscreen "toggle fullscreen"))

    "Split"
    (("/" split-window-right "horizontally")
     ("?" split-window-horizontally-instead "horizontally instead")
     ("-" split-window-below "vertically")
     ("_" split-window-vertically-instead "vertically instead"))

    "Zoom"
    (("i" text-scale-increase "in" :color amaranth)
     ("o" text-scale-decrease "out" :color amaranth)
     ("0" (lambda ()
            (interactive)
            (zoom-in/out 0)) "reset"))))
  )

(leaf zoxide
  :doc "Find file by zoxide"
  :url "https://github.com/emacsmirror/zoxide"
  :ensure t
  :bind
  ("C-c z" . zoxide-find-file)
  )

(leaf avy
  :doc "Jump to things in Emacs tree-style"
  :url "https://github.com/abo-abo/avy"
  :ensure t
  :bind
  ("s-." . avy-goto-word-or-subword-1)
  ("s-," . avy-goto-char)
  ("C-c ," . avy-go-to-char)
  ("M-g f" . avy-goto-line)
  )

(leaf expand-region
  :doc "Increase selected region by semantic units."
  :url "https://github.com/magnars/expand-region.el"
  :ensure t
  :bind
  ("C-=" . er/expand-region)
  )

(leaf restclient
  :doc "HTTP REST client tool for Emacs"
  :url "https://github.com/pashky/restclient.el"
  :ensure t
  :mode
  ("\\.http\\'" . restclient-mode)
  :bind (:restclient-mode-map ("C-c C-c" . restclient/body))
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Actions"
    (("S" restclient-http-send-current-stay-in-window "send")
     ("s" restclient-http-send-current "send and switch")
     ("R" restclient-http-send-current-raw-stay-in-window "send raw")
     ("r" restclient-http-send-current-raw "send raw and switch")
     ("E" restclient-http-send-current-raw-stay-in-window "send raw")
     ("E" restclient-http-send-current-raw "send raw and switch")
     ("c" restclient-copy-curl-command "copy curl command")
     ("C" restclient-copy-curl-command-as-org-link "copy curl command as org link"))
    "Navigation"
    (("n" restclient-jump-next "next")
     ("p" restclient-jump-prev "previous")
     ("N" restclient-narrow-to-current "narrow to current"))
    "Misc"
    (("t" restclient-mark-current "mark current")
     ("T" restclient-mark-current-and-copy "mark current and copy")
     ("u" restclient-unmark "unmark")
     ("U" restclient-unmark-all "unmark all"))
    )))

(leaf editorconfig
  :doc "EditorConfig Emacs Plugin"
  :url "https://github.com/editorconfig/editorconfig-emacs"
  :ensure t
  :config
  (editorconfig-mode 1))

(leaf crux
  :doc "A Collection of Ridiculously Useful eXtensions for Emacs"
  :url "https://github.com/bbatsov/crux"
  :ensure t
  :bind
  ("C-c o" . crux-open-with)
  ("M-j" . crux-smart-open-line)
  ("C-c n" . crux-cleanup-buffer-or-region)
  ("C-c f" . crux-recentf-find-file)
  ("C-M-z" . crux-indent-defun)
  ("C-c u" . crux-view-url)
  ("C-c e" . crux-eval-and-replace)
  ("C-c w" . crux-swap-windows)
  ("C-c D" . crux-delete-file-and-buffer)
  ("C-c r" . crux-rename-buffer-and-file)
  ("C-c t" . crux-visit-term-buffer)
  ("C-c k" . crux-kill-other-buffers)
  ("s-r" . crux-recentf-find-file)
  ("s-j" . crux-top-join-line)
  ("C-^" . crux-top-join-line)
  ("C-<backspace>" . crux-kill-line-backwards)
  ("s-o" . crux-smart-open-line-above)
  ([remap move-beginning-of-line] . crux-move-beginning-of-line)
  ([(shift return)] . crux-smart-open-line)
  ([(control shift return)] . crux-smart-open-line-above)
  ([remap kill-whole-line] . crux-kill-whole-line)
  ("C-c s" . crux-ispell-word-then-abbrev)
  )

(leaf eshell-toggle
  :custom
  (eshell-toggle-size-fraction . 3)
  (eshell-toggle-use-projectile-root . nil)
  (eshell-toggle-run-command . nil)
  (eshell-toggle-init-function . #'eshell-toggle-init-eshell)
  :straight
  (eshell-toggle :repo "4DA/eshell-toggle" :fetcher github :version original)
  :bind
  ("<f12>" . eshell-toggle))

(leaf ace-window
  :doc "Quickly switch windows"
  :url "https://github.com/abo-abo/ace-window"
  :ensure t
  :config
  (global-set-key (kbd "M-o") 'ace-window)
  (global-set-key [remap other-window] 'ace-window))

(leaf emacs-everywhere
  :doc "Edit text everywhere with Emacs"
  :url "https://github.com/tecosaur/emacs-everywhere"
  :ensure t)

(leaf activity-watch-mode
  :doc "Automatic time tracking and metrics"
  :url "https://github.com/pauldub/activity-watch-mode"
  :ensure t
  :config
  (global-activity-watch-mode))

(leaf gptel
  :doc "A simple LLM client for Email"
  :url "https://github.com/karthink/gptel"
  :ensure t
  :bind
  ("C-c g" . gptel-menu)
  :config
  (setq gptel-model "mistral:latest"
        gptel-backend (gptel-make-ollama "Ollama"
                                         :host "localhost:11434"
                                         :stream t
                                         :models '("mistral:latest"))))

(leaf dired
  :builtin
  :custom
  ;; show less details and list directories on top.
  (dired-listing-switches . "-agho --group-directories-first")
  ;; Safely delete files by moving them to trash
  (delete-by-moving-to-trash . t)
  :config
  ;; Enables extra functionalities on C-* like selecting by extension
  (require 'dired-x))

(leaf dired-single
  :doc "Visit a file in a single dired buffer"
  :url "https://codeberg.org/amano.kenji/dired-single"
  :ensure t
  :config
  (defun my-dired-init ()
    "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
    ;; <add other stuff here>
    (define-key dired-mode-map [remap dired-find-file]
                'dired-single-buffer)
    (define-key dired-mode-map [remap dired-mouse-find-file-other-window]
                'dired-single-buffer-mouse)
    (define-key dired-mode-map [remap dired-up-directory]
                'dired-single-up-directory))

  ;; if dired's already loaded, then the keymap will be bound
  (if (boundp 'dired-mode-map)
      ;; we're good to go; just add our bindings
      (my-dired-init)
    ;; it's not loaded yet, so add our bindings to the load-hook
    (add-hook 'dired-load-hook 'my-dired-init))
  )

(leaf all-the-icons-dired
  :doc "Shows icons in dired mode"
  :url "https://github.com/jtbm37/all-the-icons-dired"
  :ensure t
  :hook
  (dired-mode-hook . all-the-icons-dired-mode))

(leaf dired-rainbow
  :doc "Colorize filenames in dired by regex"
  :url "https://github.com/Fuco1/dired-hacks/tree/master"
  :ensure t
  :config
  (require 'dired-rainbow)
  (progn
    (dired-rainbow-define-chmod directory "#6ae4b9" "d.*")
    (dired-rainbow-define document "#b6a0ff" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx" "org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
    (dired-rainbow-define database "#ff6f8f" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
    (dired-rainbow-define log "#ff5f59" ("log"))
    (dired-rainbow-define executable "#44bc44" ("exe" "msi" "-.*x.*"))
    (dired-rainbow-define compressed "#dfaf7a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar" "dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak" "deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
    (dired-rainbow-define encrypted "#d0bc00" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
    (dired-rainbow-define vc "#00bcff" ("git" "gitignore" "gitattributes" "gitmodules"))
    )
  )

(leaf dired-subtree
  :doc "Insert subdirectories in dired"
  :url "https://github.com/Fuco1/dired-hacks/tree/master"
  :ensure t
  :bind
  (:dired-mode-map
   :package dired
   ("i" . dired-subtree-insert)
   (";" . dired-subtree-remove)))

(leaf dired-preview
  :doc "Preview files in dired"
  :url "https://protesilaos.com/emacs/dired-preview"
  :ensure t
  :custom
  (dired-preview-delay . 0.1)
  :bind
  (:dired-mode-map
   :package dired
   ("C-t" . dired-preview-mode))
  :config
  (setq dired-preview-max-size (expt 2 20)
        dired-preview-ignored-extensions-regexp (concat "\\."
                                                     "\\(gz\\|"
                                                     "zst\\|"
                                                     "tar\\|"
                                                     "xz\\|"
                                                     "rar\\|"
                                                     "zip\\|"
                                                     "iso\\|"
                                                     "epub"
                                                     "\\)"))
  )

(leaf restart-emacs
  :doc "Restart Emacs from within Emacs"
  :url "https://github.com/iqbalansari/restart-emacs"
  :ensure t)

;;; sh-utils.el ends here
