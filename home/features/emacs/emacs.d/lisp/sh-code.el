;;; sh-code.el --- Emacs Code to Infinity -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(provide 'sh-code)

;; Show the name of the current function definition in the modeline.
(require 'which-func)
(which-function-mode 1)

;; Line numbers (relative of course).
(setq display-line-numbers-type 'relative)
;; (global-display-line-numbers-mode 1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

;; Highlight the current line.
(global-hl-line-mode 1)

(leaf lsp-mode
  :doc "LSP mode"
  :url "https://emacs-lsp.github.io/lsp-mode/"
  :ensure t
  :commands (lsp-mode lsp-deferred)
  :custom
  :disabled t
  ;; Disable features that have great potential to be slow.
  (lsp-enable-folding . nil)
  (lsp-enable-text-document-color . nil)
  ;; Reduce unexpected modifications to code.
  (lsp-enable-type-formatting . nil)
  :hook
  (lsp-mode-hook . lsp-enable-which-key-integration)
  (python-mode-hook . lsp-deferred)
  (go-mode-hook . lsp-deferred)
  (rust-mode-hook . lsp-deferred)
  :bind
  ("C-c l" . lsp-mode/body)
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Buffer"
    (("f" lsp-format-buffer "format buffer")
     ("m" lsp-ui-imenu "imenu")
     ("x" lsp-execute-code-action "execute code action")
     ("r" lsp-rename "rename"))
    "Server"
    (("s" lsp-describe-session "describe session")
     ("S" lsp-shutdown-workspace "shutdown workspace")
     ("r" lsp-restart-workspace "restart workspace"))
    "Symbol"
    (("d" lsp-find-definition "find definition")
     ("D" lsp-ui-peek-find-definitions "peek definition")
     ("i" lsp-find-implementation "find implementation")
     ("I" lsp-ui-peek-find-implementation "peek implementation")
     ("r" lsp-find-references "find references")
     ("R" lsp-ui-peek-find-references "peek references"))))
  )

(leaf lsp-ui
  :doc "UI modules for lsp-mode"
  :url "https://emacs-lsp.github.io/lsp-ui/"
  :ensure t
  :disabled t
  :commands (lsp-ui-mode lsp-ui-imenu)
  :custom
  (lsp-ui-peak-enable . t)
  (lsp-ui-doc-max-height . 8)
  (lsp-ui-doc-max-width . 72)          ; 150 (default) is too wide
  (lsp-ui-doc-delay . 0.75)              ; 0.2 (default) is too naggy
  (lsp-ui-doc-show-with-cursor . nil)  ; don't dissappear on mouseover
  (lsp-ui-doc-position . 'at-point)
  (lsp-ui-sideline-ignore-duplicate . t)
  ;; Don't show symbol definitions in the sideline. They are pretty noisy,
  ;; and there is a bug preventing Flycheck errors from being shown (the
  ;; errors flash briefly and then disappear).
  (lsp-ui-sideline-show-hover . nil)
  :hook
  (lsp-mode-hook . lsp-ui-mode)
  :bind lsp-ui-mode-map
  ([remap xref-find-definitions] . lsp-ui-peek-find-definitions)
  ([remap xref-find-references] . lsp-ui-peek-find-references)
  )

(leaf eglot
  :doc "Client for Language Server Protocol servers"
  :url "https://github.com/joaotavora/eglot"
  :commands (eglot eglot-format eglot-managed-p)
  :custom
  (eglot-autoshutdown . t)
  :hook
  ((python-mode-hook
    rust-mode-hook
    go-mode-hook
    c-mode-hook
    c++-mode-hook
    elixir-mode-hook
    nix-mode-hook
    sh-mode-hook
    bash-ts-mode-hook
    json-mode-hook
    web-mode-hook) . eglot-ensure)
  :bind
  (:eglot-mode-map
   ("C-c l" . eglot/body))
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Buffer"
    (("f" eglot-format "format buffer")
     ("m" eglot-find-typeDefinition "type definition")
     ("x" eglot-code-actions "code actions")
     ("r" eglot-rename "rename"))
    "Server"
    (("s" eglot-shutdown "shutdown server")
     ("S" eglot-shutdown-all "shutdown all servers"))
    "Symbol"
    (("d" eglot-find-declaration "find declaration")
     ("i" eglot-find-implementation "find implementation"))
    )
   )
    :defer-config
  (add-to-list 'eglot-server-programs
               '(rust-mode . ("rust-analyzer"
                              :initializationOptions
                              (:checkOnSave
                               (:command "clippy")))))
  (add-to-list 'eglot-server-programs
               `((typescript-ts-mode :language-id "typescriptreact")
                 . ("typescript-language-server" "--stdio")))
  (add-to-list 'eglot-server-programs
               `(web-mode . ("biome" "lsp-proxy")))
  (add-to-list 'eglot-server-programs
               '(json-mode . ("biome" "lsp-proxy")))
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd"))))

(leaf eglot-x
  :doc "Protocol extensions for eglot"
  :url "https://github.com/nemethf/eglot-x"
  :straight (eglot-x :host github :repo "nemethf/eglot-x")
  :after eglot
  :config
  (with-eval-after-load 'eglot (require 'eglot-x)))

(leaf eldoc-box
  :doc "childframe doc for eglot and anything that uses eldoc"
  :url "https://github.com/casouri/eldoc-box"
  :ensure t
  :hook
  (eglot-managed-mode-hook . eldoc-box-hover-mode))

(leaf devdocs
  :doc "Search the local devdocs."
  :url "https://github.com/astoff/devdocs.el"
  :ensure t
  ;; TODO extract a function instead of this lambda
  :hook ((python-mode . (lambda () (setq-local devdocs-current-docs '("python-3.11"))))
         (emacs-lisp-mode . (lambda () (setq-local devdocs-current-docs '("elisp"))))
         (sh-mode . (lambda () (setq-local devdocs-current-docs '("bash"))))
         (nix-mode . (lambda () (setq-local devdocs-current-docs '("nix"))))
         (rust-mode . (lambda () (setq-local devdocs-current-docs '("rust"))))
         (go-mode . (lambda () (setq-local devdocs-current-docs '("go")))))
  :bind
  ("C-c d" . devdocs-lookup))

(leaf major-mode-hydra
  :doc "Spacemacs-inspired major mode leader key powered by Hydra"
  :url "https://github.com/jerrypnz/major-mode-hydra.el"
  :ensure t)

(leaf project
  :doc "Manage and navigate projects in Emacs easily"
  :tag "builtin"
  :bind
  ("C-x p" . project/body)
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Project"
    (("f" project-find-file "find file")
     ("d" project-dired "dired")
     ("b" consult-project-buffer "switch to buffer")
     ("p" project-switch-project "switch project")
     ("k" project-kill-buffers "kill buffers"))
    "Find"
    (("g" project-find-regexp "find regexp")
     ("r" project-query-replace-regexp "query replace regexp"))
    "Action"
    (("s" project-shell "shell")
     ("e" project-eshell "eshell")
     ("c" project-compile "compile")
     ;; ("x" project-execute-extended-command "execute extended command")
     ("x" compile "compile in current directory")
     ("a" consult-ag "ag")
     ("v" project-vc-dir "vc dir"))
    ))
  )

(leaf magit
  :doc "A Git porcelain inside Emacs."
  :url "https://github.com/magit/magit"
  :ensure t
  :commands magit-status)

(leaf magit-todos
  :doc "Show source files with TODO/fixme/NOTE keywords in Magit status buffer"
  :url "https://github.com/alphapapa/magit-todos"
  :ensure t
  :after magit
  :config
  (magit-todos-mode 1))

(leaf git-timemachine
    :doc "Walk through git revisions of a file"
    :url "https://github.com/emacsmirror/git-timemachine"
    :ensure t
    :bind
    ("s-g" . git-timemachine))

(leaf git-gutter
  :doc "Port of Sublime Text plugin GitGutter"
  :url "https://github.com/emacsorphanage/git-gutter"
  :ensure t
  :hook
  (prog-mode-hook . git-gutter-mode)
  :bind
  ("C-x g" . git-gutter/body)
  :pretty-hydra
  ((:color red :hint nil :quit-key "q")
   ("Jump"
   (("n" git-gutter:next-hunk "next hunk")
    ("p" git-gutter:previous-hunk "previous hunk"))
   "Action"
   (("s" git-gutter:stage-hunk "stage hunk" :color blue)
    ("r" git-gutter:revert-hunk "revert hunk" :color blue)
    ("d" git-gutter:popup-hunk "popup hunk" :color blue)
    ("R" git-gutter:set-start-revision "set start revision" :color blue))
   ))
  )

;; TODO git-gutter

(leaf markdown-mode
  :doc "Major mode for Markdown-formatted text"
  :url "http://jblevins.org/projects/markdown-mode/"
  :ensure t)

(leaf markdown-toc
  :doc "Generate a table of contents for markdown files"
  :url "https://github.com/ardumont/markdown-toc"
  :ensure t)

(leaf grip-mode
  :doc "Instant Github-flavored Markdown/Org preview using grip"
  :url "https://github.com/seagle0128/grip-mode"
  :ensure t
  :bind (:markdown-mode-command-map
         ("p" . grip-mode))
  :config
  (require 'auth-source)
    (let ((credential (auth-source-user-and-password "api.github.com")))
    (setq grip-github-user (car credential)
          grip-github-password (cadr credential)))
  )

(leaf ox-gfm
  :doc "Github Flavored Markdown Back-End for Org Export Engine. Suggested by ~grip-mode~."
  :url "https://github.com/larstvei/ox-gfm"
  :after org
  :ensure t
  :config
  (require 'ox-gfm nil t))

(leaf hl-todo
  :doc "Highlight TODO keywords"
  :url "https://github.com/tarsius/hl-todo"
  :ensure t
  :config
  (require 'hl-todo)
  (global-hl-todo-mode 1))

;; TODO dumb-jump
(leaf terraform-mode
  :doc "Major mode for terraform configuration files"
  :url "https://github.com/hcl-emacs/terraform-mode"
  :ensure t)

(leaf nix-mode
  :doc "Major mode for editing Nix expressions"
  :url "https://github.com/NixOS/nix-mode"
  :ensure t)

(leaf dockerfile-mode
  :doc "Major mode for editing Docker's Dockerfiles"
  :url "https://github.com/spotify/dockerfile-mode"
  :ensure t)

(leaf docker-compose-mode
  :doc "Major mode for editing Docker Compose files"
  :url "https://github.com/meqif/docker-compose-mode"
  :ensure t)

;; TODO check me out
(leaf docker
  :doc "Emacs Docker client"
  :url "https://github.com/Silex/docker.el"
  :ensure t)

;; TODO check TRAMP

(leaf rainbow-mode
  :doc "Colorize color names in buffers"
  :url "https://elpa.gnu.org/packages/rainbow-mode.html"
  :ensure t
  :hook
  (prog-mode-hook . rainbow-mode))

(leaf rainbow-delimiters
  :doc "Highlight delimiters such as parentheses, brackets or braces according to their depth."
  :url "https://github.com/Fanael/rainbow-delimiters"
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode))

(leaf ws-butler
  :doc "Unobtrusively trim extraneous white-space *ONLY* in lines edited"
  :url "https://github.com/lewang/ws-butler"
  :ensure t
  :hook
  (prog-mode-hook . ws-butler-mode))

(leaf yaml-mode
  :doc "Major mode for editing YAML files"
  :url "https://github.com/yoshiki/yaml-mode"
  :ensure t)

(leaf indent-guide
  :doc "Show vertical lines to guide indentation"
  :url "https://github.com/zk-phi/indent-guide"
  :ensure t
  :hook
  (prog-mode-hook . indent-guide-mode))

;; TODO enable code folding
(leaf sql
  :doc "SQL mode"
  :tag "builtin"
  :mode ("\\.sql\\'" "\\.ksql\\'"))

(leaf typescript-mode
  :doc "Major mode for editing typescript"
  :url "https://github.com/emacs-typescript/typescript.el"
  :ensure t
  :mode "\\.ts\\'"
  :custom
  (typescript-indent-level . 2)
  :config

  ;; use our derived mode for tsx files
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  )

(leaf go-mode
  :doc "Major mode for the Go programming language"
  :url "https://github.com/dominikh/go-mode.el"
  :ensure t
  :mode "\\.go\\'"
  :custom
  (gofmt-command . "goimports")
  :hook
  (before-save-hook . gofmt-before-save))

;; (leaf treesit-auto
;;   :doc "Automatic installation, usage, and fallback for tree-sitter major modes in Emacs 29"
;;   :url "https://github.com/renzmann/treesit-auto"
;;   :ensure t
;;   :custom ((treesit-auto-install quote prompt)
;;            (treesit-auto-add-to-auto-mode-alist quote all))
;;   :global-minor-mode global-treesit-auto-mode)

(leaf plantuml-mode
  :doc "Major mode for PlantUML"
  :url "https://github.com/skuro/plantuml-mode"
  :ensure t
  )

(leaf rust-mode                ;; NOTE this requires rustfmt to be installed.
  :doc "A major emacs mode for editing Rust source code"
  :url "https://github.com/rust-lang/rust-mode"
  :ensure t
  :mode "\\.rs\\'"
  :custom
  (rust-format-on-save . t)
  :hook
  (rust-mode-hook . prettify-symbols-mode))

(leaf rustic
  :doc "Rust development environment"
  :url "https://github.com/brotzeit/rustic"
  :ensure t
  :config
  ;; (bind-rust-snippets rustic-mode-map)
  (advice-add 'rustic-recompile :before #'save-current-buffer-if-modified)
  (advice-add 'rustic-cargo-current-test :before #'save-current-buffer-if-modified)
  (advice-add 'rustic-cargo-test :before #'save-current-buffer-if-modified))

(leaf flycheck-rust
  :doc "Flycheck: Rust additions and Cargo support"
  :url "https://github.com/flycheck/flycheck-rust"
  :after (flycheck rust-mode)
  :ensure t
  :hook
  (flycheck-mode-hook . flycheck-rust-setup))
;; TODO setup keybindings
(leaf cargo-mode
  :doc "Minor mode for Cargo, Rust's package manager."
  :url "https://github.com/ayrat555/cargo-mode"
  :ensure t
  :hook
  (rust-mode-hook . cargo-minor-mode))

;; TODO setup keybindings
(leaf anaconda-mode
  :doc "Code navigation, documentation lookup and completion for Python"
  :url "https://github.com/pythonic-emacs/anaconda-mode"
  :ensure t
  :hook
  (python-mode-hook . anaconda-mode)
  :config
    ;;  Move anaconda python installation directory to user var/
  (customize-set-variable
   'anaconda-mode-installation-directory
   (expand-file-name "anaconda-mode" sh/var-dir))
  )

(leaf blacken
  :doc "Blacken Python source code"
  :url "https://github.com/pythonic-emacs/blacken"
  :ensure t
  :hook
  (python-mode-hook . blacken-mode))

(leaf pyimport
  :doc "Import completion for Python"
  :url "https://github.com/Wilfred/pyimport"
  :ensure t
  :pretty-hydra
  ;; TODO bind this hydra
  ((:color teal :quit-key "q")
   ("Imports"
    (("r" pyimport-remove-unused "remove unused imports")
     ("i" pyimport-insert-missing "insert missing dependencies"))
    ))
  )

(leaf hs-minor-mode
  :doc "Hide and show blocks of text"
  :tag "builtin"
  :hook
  (prog-mode-hook . hs-minor-mode)
  :bind
  ("C-c h" . hs-minor-mode/body)
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Block"
    (("h" hs-hide-block "hide block")
     ("s" hs-show-block "show block")
     ("t" hs-toggle-hiding "toggle hiding"))
    "All"
    (("H" hs-hide-all "hide all")
     ("S" hs-show-all "show all"))
    "Level"
    (("l" hs-hide-level "hide level")
    ))
   )
  )

(leaf feature-mode
  :doc "Major mode for editing Gherkin files"
  :url "https://github.com/emacsmirror/feature-mode"
  :ensure t
  :config
  (defun turn-on-orgtbl ()
    "Turn on orgtbl-mode."
    ;; NOTE this is a workaround for a bug in feature-mode
    ))

(leaf flycheck
  :doc "On-the-fly syntax checking"
  :url "https://www.flycheck.org/en/latest/"
  :ensure t
  :hook
  (prog-mode-hook . flycheck-mode)
  :bind
  ("C-c e" . flycheck/body)
  :custom
  (flycheck-check-syntax-automatically . '(save mode-enabled))
  (flycheck-idle-change-delay . 0.5)
  (flycheck-display-errors-delay . 0.5)
  :pretty-hydra
  ((:color teal :quit-key "q")
   ("Errors"
    (("n" flycheck-next-error "next error")
     ("p" flycheck-previous-error "previous error")
     ("l" flycheck-list-errors "list errors"))
    "Checker"
     (("d" flycheck-describe-checker "describe checker")
     ("m" flycheck-mode "toggle mode")
     ("s" flycheck-select-checker "select checker")
     ("c" flycheck-clear "clear")
     ("C" flycheck-buffer "check buffer")
     ("v" flycheck-verify-setup "verify setup"))
    ))
  )

(leaf emmet-mode
  :doc "The essential toolkit for web developer"
  :url "https://github.com/smihica/emmet-mode"
  :ensure t
  :hook
  (sgml-mode-hook . emmet-mode)
  (css-mode-hook . emmet-mode))

(leaf smartparens
  :doc "Automatic insertion, wrapping and paredit-like navigation with user defined pairs."
  :url "https://github.com/Fuco1/smartparens"
  :ensure t
  :hook
  ;; TODO do I need it in all modes?
  (elixir-mode-hook . smartparens-mode)
  :config
  (require 'smartparens-config)

  ;; ruby-end-mode for elixir-mode
  ;; source: https://github.com/elixir-editors/emacs-elixir
  (add-to-list 'elixir-mode-hook
             (defun auto-activate-ruby-end-mode-for-elixir-mode ()
               (set (make-variable-buffer-local 'ruby-end-expand-keywords-before-re)
                    "\\(?:^\\|\\s-+\\)\\(?:do\\)")
               (set (make-variable-buffer-local 'ruby-end-check-statement-modifiers) nil)
               (ruby-end-mode +1)))
  )

(leaf elixir-mode
  :doc "Major mode for editing Elixir files"
  :url "https://github.com/elixir-editors/emacs-elixir"
  :ensure t)
;;; sh-code.el ends here
