(message "LOADING .emacs")
(package-initialize)


;; Instructions:
;;
;; This requires emacs 29 or later
;;
;; If you have a lot of old stuff delete your .emacs.d directory
;; and merge this file with your current .emacs init file.
;;
;; Download and unpack/install (your machine specific) elp to a bin
;; directory in your path, from:
;; https://github.com/WhatsApp/erlang-language-platform/releases
;;
;; First time starting emacs install the erlang grammer with:
;; M-x treesit-install-language-grammar
;;  Select Language: erlang
;;  And everything else is default

;; Settings

;; Workaround emacs snap issues when started from shell
;; The emacs in snap seems to be patched and needs at least
;; these env variables
(if (not (getenv "EMACS_SNAP_DIR"))
    (progn (setenv "EMACS_SNAP_DIR" "/snap/emacs/current/")
           (setenv "EMACS_SNAP_USER_COMMON"
                   (concat (expand-file-name "~/") "snap/emacs/common"))
           ))

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; (my-packages
;; '(column-enforce-mode company erlang-ts hungry-delete lsp-mode
;;    lsp-origami magit multiple-cursors which-key xref yasnippet))

(unless (package-installed-p 'column-enforce-mode)
  (message "Installing and configuring packages")
  (package-refresh-contents))

(use-package column-enforce-mode
    :config (setq column-enforce-column 100)
    :hook (prog-mode . column-enforce-mode))

(use-package company
    :hook (after-init . global-company-mode))

(use-package hungry-delete
    :bind (("C-DEL" . hungry-delete-backward)
           ("<C-delete>" . 'hungry-delete-forward)))

(use-package magit
    :bind ("C-x g" . magit-status)
    :config
    (define-key magit-mode-map (kbd "<C-tab>") nil)
    (define-key magit-mode-map (kbd "RET") 'magit-diff-visit-file-other-window))

;;(with-eval-after-load 'magit-mode
;;  (define-key magit-mode-map (kbd "<C-tab>") nil)
;;  (define-key magit-mode-map (kbd "RET") 'magit-diff-visit-file-other-window))

(use-package multiple-cursors
    :bind
  ;; Consecutive lines
  ("C-S-c C-S-c" . 'mc/edit-lines)
  ;; When you want to add multiple cursors not based on continuous lines,
  ;; but based on keywords in the buffer, use:
  ("C->" . 'mc/mark-next-like-this)
  ("C-<" . 'mc/mark-previous-like-this)
  ("C-c C-<" . 'mc/mark-all-like-this)
  )

(require 'uniquify)
(use-package which-key)

(use-package yasnippet
    :config (yas-global-mode 1))

(use-package origami
    :bind ("<backtab>" . origami-toggle-node))

(global-unset-key (kbd "C-l"))

(use-package flymake
    :config
  (define-key flymake-mode-map (kbd "<f5>") 'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "<f6>") 'flymake-goto-prev-error)
  (setq flycheck-erlang-include-path '("../include" "/home/dgud/src/wings/e3d"))
  (setq flycheck-erlang-library-path '("/home/dgud/src/wings/intl_tools")))

;; Use flyspell
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

(use-package lsp-mode
    :config
  (add-to-list 'lsp-language-id-configuration '(erlang-ts-mode . "erlang"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection '("elp" "server"))
                      :major-modes '(erlang-mode erlang-ts-mode)
                      :priority 0
                      :server-id 'erlang-language-platform))
  (setq lsp-enable-file-watchers nil)
  (setq lsp-keymap-prefix "C-l")
  (use-package lsp-ui
      :config
    (setq lsp-ui-doc-delay 1.0)
    (setq lsp-ui-doc-enable t)
    (setq lsp-ui-doc-show-with-cursor t)
    (setq lsp-ui-peek-enable t)
    (setq lsp-ui-sideline-delay 1.0)
    (setq lsp-ui-sideline-enable nil)
    (setq lsp-ui-sideline-ignore-duplicate nil)
    (setq lsp-ui-sideline-show-code-actions t)
    (setq lsp-ui-sideline-show-diagnostics t)
    (setq lsp-ui-sideline-show-hover nil)
    (setq lsp-ui-sideline-show-symbol nil)
    (setq lsp-ui-sideline-update-mode 'point))
  (use-package lsp-origami
      :hook (lsp-after-open . lsp-origami-try-enable)
      :hook (origami-mode . lsp-origami-mode))
  :hook (lsp-mode . lsp-enable-which-key-integration))


(require 'treesit)
(add-to-list 'treesit-language-source-alist
             '(erlang . ("https://github.com/WhatsApp/tree-sitter-erlang")))

(add-to-list 'load-path "~/src/emacs-erlang-ts")

(use-package erlang-ts
    :mode ("\\.erl\\'" . erlang-ts-mode)
    :config (setq treesit-font-lock-level 4)
    (local-set-key "\C-cs" 'tempo-template-erlang-spec)
    :hook (erlang-mode . lsp)
    :hook (erlang-mode . origami-mode)
    :hook (erlang-mode . which-key-mode))

(setq show-trailing-whitespace t)
(transient-mark-mode t)
(show-paren-mode t)
(setq indent-tabs-mode nil)
(setq line-number-mode t)
(column-number-mode t)
(ido-mode)

;; Some keyboard-shortcuts that should be default :-)
(global-set-key [(meta g)] 'goto-line)
(global-set-key [(control next)] 'end-of-buffer)
(global-set-key [(control prior)] 'beginning-of-buffer)
(global-set-key [(control G)] 'compile)
(global-set-key [(meta +)] 'dabbrev-expand) ;; Windows keyboards
(global-set-key [(meta -)] 'dabbrev-expand)

(setq compile-command "make")

(setq font-lock-maximum-decoration t)
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode t))

;; Turn off DOS mode
(setq-default inhibit-eol-conversion t)
(setq-default indent-tabs-mode nil)

;; Windows special to make 'make' work in wsl
(setq process-connection-type nil)

;; For windows with synergy which maps ALT-GR to C-M {[]}
(global-set-key (kbd "C-M-7") "{")
(global-set-key (kbd "C-|") "{")
(global-set-key (kbd "C-z") 'undo)  ;; Causes emacs to hang on windows

;; C-mode indentions, fixed the way i like them and Ericsson
(setq c-basic-offset 4)
;;(c-set-offset 'substatement-open 0)
(add-hook 'c-mode-hook (lambda () (setq c-basic-offset 4)))

(put 'eval-expression 'disabled nil)

;; Always show diagnostics at the bottom, using 1/3 of the available space
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (side            . bottom)
               (reusable-frames . visible)
               (window-height   . 0.33)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(inhibit-startup-screen t)
 '(lsp-enable-file-watchers nil)
 '(lsp-ui-doc-delay 1.0)
 '(lsp-ui-doc-enable t)
 '(lsp-ui-doc-show-with-cursor t)
 '(lsp-ui-peek-enable t)
 '(lsp-ui-sideline-delay 1.0)
 '(lsp-ui-sideline-enable nil)
 '(lsp-ui-sideline-ignore-duplicate nil)
 '(lsp-ui-sideline-show-code-actions t)
 '(lsp-ui-sideline-show-diagnostics t)
 '(lsp-ui-sideline-show-hover nil)
 '(lsp-ui-sideline-show-symbol nil)
 '(lsp-ui-sideline-update-mode 'point)
 '(package-selected-packages
   '(buttercup column-enforce-mode company erlang
               flymake-diagnostic-at-point hungry-delete lsp-mode
               lsp-origami magit multiple-cursors package-lint
               which-key xref yasnippet))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(treesit-font-lock-level 4)
 '(visible-bell t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "DAMA" :family "Ubuntu Mono"))))
 '(lsp-ui-sideline-symbol ((t (:foreground "grey" :box (:line-width (1 . -1) :color "grey") :height 0.99))))
 '(region ((t (:extend t :background "navajo white" :distant-foreground "gtk_selection_fg_color"))))
 '(trailing-whitespace ((t (:background "khaki")))))
(message "LOADING .emacs done")
