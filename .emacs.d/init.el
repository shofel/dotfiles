;;; -*- indent-tabs-mode: nil; tab-width: 2 -*- */

;;;
;;; MELPA
;;; @see https://melpa.org/#/getting-started
;;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

;;;
;;; use-package
;;;

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))

;;;
;;; Packages
;;;

;; Parinfer
;; @see https://github.com/DogLooksGood/parinfer-mode
(use-package parinfer
  :bind
  (("C-," . parinfer-toggle-mode))
  :init
  (progn
    (setq parinfer-extensions
          '(defaults       ; should be included.
            smart-yank
            evil))         ; If you use Evil.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

;; Yaml
(use-package yaml-mode
  :mode "\\.yml\\'")

;; evil
(use-package evil
  :init (evil-mode 1))

;; line numbers
(use-package linum-relative
  :init
  (linum-mode)
  (linum-relative-global-mode)
  (setq linum-relative-current-symbol ""))

;; colors

(use-package zerodark-theme
  :init (load-theme 'zerodark t))

;;; TODO: helm
;;; TODO: magit
;;; TODO: folds
;;; @see https://github.com/rranelli/auto-package-update.el


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (linum-relative zerodark-theme dracula-theme yaml-mode use-package solarized-theme parinfer evil atom-dark-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;
;;; UI
;;;

;; reduce gui noize
;; TODO: fix the thick window border
(menu-bar-mode -1)
(tool-bar-mode -1)


;; deal with trailing whitespace
(setq show-trailing-whitespace t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
