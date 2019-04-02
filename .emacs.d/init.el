;;; -*- indent-tabs-mode: nil; tab-width: 2 -*- */

;;; Cyrillic dvorak.
(load-file "~/.emacs.d/opt/mk-dvorak-russian.el")
(set-input-method "mk-dvorak-russian")
(toggle-input-method)

;;;
;;; Setup package management.
;;; @see package.el
;;; @see https://melpa.org/#/getting-started
;;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
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

;; Surround

(show-paren-mode 1) ; Show matching pairs.
(electric-pair-mode) ; Insert pairs at once.

;; Yaml
(use-package yaml-mode
  :mode "\\.yml\\'")

;;
;; Clojure
;;
(use-package cider)

;; evil

(use-package evil
  :init (evil-mode 1))

(use-package evil-commentary
  :init (evil-commentary-mode))

;; General for key bindings.
;; @see https://github.com/noctuid/general.el/blob/master/README.org#general-examples
(use-package general
  :init

  ;;;
  ;;; Backport some of the keys from init.vim
  ;;;

  (setq shofel-leader "SPC")

  ;; <Leader>s for write file
  (general-def
    'normal
    :prefix shofel-leader
    "s" 'save-buffer)

  ;; / for swiper
  (general-def
    'normal
    "/" 'swiper)

  ;; Up and Down for { and }
  (general-def
    'normal
    "<down>" 'evil-forward-paragraph
    "<up>" 'evil-backward-paragraph)
  )

(use-package evil-commentary
  :init (evil-commentary-mode))

;; Ivy
;; @see http://oremacs.com/swiper/
;; todo helm-ls-git: helm-browse-project
(use-package ivy
  :ensure flx :ensure counsel :ensure swiper
  :init
  ;; Basic customization (for new Ivy users).
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  ;; Fuzzy matching somewhere.
  (setq ivy-re-builders-alist
        '((ivy-switch-buffer . ivy--regex-plus)
          (swiper . ivy--regex-plus)
          (t . ivy--regex-fuzzy)))
  (ivy-mode 1)
  (use-package amx
    :config (amx-mode 1))

  ;; Commented keys are the defaults.
  :bind
  ("C-s" . swiper)
  ;; Keys for help.
  ;; ("<f1> f" . counsel-describe-function)
  ;; ("<f1> v" . counsel-describe-variable)
  ;; ("<f1> l" . counsel-find-library)
  ;; ("<f2> i" . counsel-info-lookup-symbol)
  ;; ("<f2> u" . counsel-unicode-char)
  ;; Ivy-based interface to shell and system tools.
  ("C-c g" . counsel-git)
  ("C-c j" . counsel-git-grep)
  ("C-c k" . counsel-ag)
  ("C-x l" . counsel-locate)
  ;; Ivy-resume.
  ;; ("C-c C-r" . ivy-resume)
  )

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
    (cider amx general counsel swiper hydra flx ivy diff-hl linum-relative zerodark-theme yaml-mode use-package evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;;
;;; UI
;;;

;; Reduce gui noize.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Store all backup and autosave files in the tmp dir.
;; @see http://emacsredux.com/blog/2013/05/09/keep-backup-and-auto-save-files-out-of-the-way/
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; deal with trailing whitespace
(setq show-trailing-whitespace t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
