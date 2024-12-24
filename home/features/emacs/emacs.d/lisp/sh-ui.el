;;; sh-ui.el --- Emacs look -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:
(provide 'sh-ui)

;(load-theme 'modus-operandi t)
(leaf doom-themes
  :url "https://github.com/doomemacs/themes"
  :ensure t
  :custom
  (doom-themes-enable-bold . t)
  (doom-themes-enable-italic . t)
  :config
  (load-theme 'doom-tokyo-night t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config)
  )

(leaf all-the-icons
  :url "https://github.com/domtronn/all-the-icons.el"
  :ensure t
  :if (display-graphic-p))

(leaf lambda-line
  :url "https://github.com/Lambda-Emacs/lambda-line"
  :straight (lambda-line :host github :repo "Lambda-Emacs/lambda-line")
  :custom
  ;; Having it on top, will interfer with Hydra, moving window too
  ;; much down, which makes it impossible to use.
  (lambda-line-position . 'bottom)                ;; Set position of status-line
  (lambda-line-abbrev . t)                        ;; abbreviate major modes
  (lambda-line-hspace . "  ")                     ;; add some cushion
  (lambda-line-prefix . t)                        ;; use a prefix symbol
  (lambda-line-prefix-padding . nil)              ;; no extra space for prefix
  (lambda-line-status-invert . nil)               ;; no invert colors
  (lambda-line-gui-ro-symbol . " ⨂")             ;; symbols
  (lambda-line-gui-mod-symbol . " ⬤")
  (lambda-line-gui-rw-symbol . " ◯")
  :config
  (lambda-line-mode)
  (when (eq lambda-line-position 'top)
    (setq-default mode-line-format (list "%_"))
    (setq mode-line-format (list "%_")))
  )

;; Set font
(defun font-existsp (font)
  "Check to see if the named FONT is available."
  (if (null (x-list-fonts font))
      nil t))

;; Set default font.
(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font-13.5"))

(leaf highlight-indent-guides
  :url "https://github.com/DarthFennec/highlight-indent-guides"
  :doc "Minor mode to highlight indentation"
  :ensure t
  :hook (prog-mode-hook . highlight-indent-guides-mode))
;;; sh-ui.el ends here
