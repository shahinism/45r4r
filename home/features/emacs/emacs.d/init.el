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
