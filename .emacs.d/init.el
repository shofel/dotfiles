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
            evil))        ; If you use Evil.
    (add-hook 'clojure-mode-hook #'parinfer-mode)
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'common-lisp-mode-hook #'parinfer-mode)
    (add-hook 'scheme-mode-hook #'parinfer-mode)
    (add-hook 'lisp-mode-hook #'parinfer-mode)))

(show-paren-mode 1) ; Show matching pairs.

;; Yaml
(use-package yaml-mode
  :mode "\\.yml\\'")

;; evil
(use-package evil
  :init (evil-mode 1))

;; Helm
;; @see https://github.com/emacs-helm/helm/wiki/Fuzzy-matching
(use-package helm
  :init
  (helm-mode 1)
  (setq helm-find-files-fuzzy-match t)
  (setq helm-M-x-fuzzy-match t)
  (setq helm-mode-fuzzy-match t)
  (setq helm-completion-in-region-fuzzy-match t)
  :bind ("M-x" . helm-M-x))

(use-package helm-fuzzier
  :init
  (helm-fuzzier-mode 1)
  (helm-flx-mode 1))

;; Like ctrlp.
;; Todo: fix the binding.
(use-package helm-ls-git
  :bind ("C-p" . helm-browse-project))

;; line numbers
(use-package linum-relative
  :init
  (linum-mode)
  (linum-relative-global-mode)
  (setq linum-relative-current-symbol ""))

;; Git gutter.
;; Todo: navigate between hunks.
(use-package diff-hl
  :init
  (diff-hl-flydiff-mode +1)
  (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; modeline
(use-package telephone-line
  :init
  (setq telephone-line-primary-left-separator 'telephone-line-flat
        telephone-line-secondary-left-separator 'telephone-line-flat
        telephone-line-primary-right-separator 'telephone-line-flat
        telephone-line-secondary-right-separator 'telephone-line-flat)
  (setq telephone-line-evil-use-short-tag nil)
  (telephone-line-mode 1))

;; colors

(use-package zerodark-theme
  :init (load-theme 'zerodark t))

;;; TODO: folds
;;; TODO: vertigo

;;; TODO https://github.com/rranelli/auto-package-update.el


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-fuzzier helm-flx diff-hl helm-ls-git helm linum-relative zerodark-theme yaml-mode use-package parinfer evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.



;;;
;;; UI
;;;

;; reduce gui noize
;; TODO: fix the thick window border
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)


;; deal with trailing whitespace
(setq show-trailing-whitespace t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
