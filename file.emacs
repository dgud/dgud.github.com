(message "LOADING .emacs")
(package-initialize)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode t))

;; Maximum colors
(setq font-lock-maximum-decoration t)
;; Turn on colors on marked text
(transient-mark-mode t)
(show-paren-mode t)
(setq show-trailing-whitespace t)
(require 'uniquify)
(require 'hungry-delete)
(ido-mode)

;; Windows special to make 'make' work in wsl
(setq process-connection-type nil)

(add-to-list 'default-frame-alist '(background-color . "grey90"))

;; Own key def's
(global-set-key [(meta g)] 'goto-line)
(global-set-key [(control left)] 'backward-word)
(global-set-key [(control right)] 'forward-word)
(global-set-key [(control up)] 'backward-paragraph)
(global-set-key [(control down)] 'forward-paragraph)
(global-set-key [(next)] 'scroll-up)
(global-set-key [(prior)] 'scroll-down)
(global-set-key [(control next)] 'end-of-buffer)
(global-set-key [(control prior)] 'beginning-of-buffer)
(global-set-key [(meta +)] 'dabbrev-expand)
(global-set-key [(meta -)] 'dabbrev-expand)
(global-set-key [(home)] 'beginning-of-line)
(global-set-key [(end)] 'end-of-line)
(global-set-key [(control tab)] 'other-window)

;; GDB break-key
(global-set-key [(control B)] 'gdb-break)
;; C-command compile
(global-set-key [(control G)] 'compile)
(setq compile-command "make")

;; Yes we want to see line number when editing
(setq line-number-mode t)

;; C-mode indentions, fixed the way i like them and Ericsson
(setq c-basic-offset 4)
;;(c-set-offset 'substatement-open 0)
(add-hook 'c-mode-hook (lambda () (setq c-basic-offset 4)))

(put 'eval-expression 'disabled nil)

;; (global-flycheck-mode)
;; (global-eldoc-mode)

;; Always show diagnostics at the bottom, using 1/3 of the available space
(add-to-list 'display-buffer-alist
             `(,(rx bos "*Flycheck errors*" eos)
               (display-buffer-reuse-window
                display-buffer-in-side-window)
               (side            . bottom)
               (reusable-frames . visible)
               (window-height   . 0.33)))

;; Display Column limitations
(require 'column-enforce-mode)
(add-hook 'prog-mode-hook 'column-enforce-mode)
(setq column-enforce-column 100)

;; Enable LSP for Erlang files
(global-unset-key (kbd "C-l"))
(setq lsp-keymap-prefix "C-l")

(require 'lsp-mode)

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("elp" "server"))
                  :major-modes '(erlang-mode)
                  :priority 0
                  :server-id 'erlang-language-platform))
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection '("elp" "server"))
                  :major-modes '(erlang-ts-mode)
                  :priority 0
                  :server-id 'erlang-language-platform))

  ;; (setq lsp-log-io t)
  ;; (setq lsp-log-io-allowlist-methods '("initialize"
  ;;                                      "workspace/didChangeWatchedFiles"
  ;;                                      "workspace/configuration"
  ;;                                      ;; "textDocument/codeLens"
  ;;                                      ;; "textDocument/semanticTokens/full"
  ;;                                      ;; "textDocument/semanticTokens/full/delta"
  ;;                                      ;; "textDocument/semanticTokens/range"
  ;;                                      ))
  ;; (setq lsp-io-messages-max 1000)

;; Enable code completion
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; Enable and configure the LSP UI Package
(require 'lsp-ui)
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-doc-enable t)
;;(setq lsp-ui-doc-position 'bottom)
(setq lsp-ui-doc-show-with-cursor nil)
(setq lsp-enable-file-watchers nil)

;; Require and enable the Yasnippet templating system
(require 'yasnippet)
(yas-global-mode 1)

;; Enable LSP Origami Mode (for folding ranges)
(require 'lsp-origami)
(add-hook 'lsp-after-open-hook #'lsp-origami-try-enable)
(add-hook 'origami-mode-hook #'lsp-origami-mode)
(add-hook 'erlang-mode-hook #'origami-mode)

;; (defun my-erl-fold ()
;;   (save-excursion
;;     (while (not (eobp))
;;       (if (re-search-forward "-doc" nil 'move)
;;           (progn
;;             (forward-char 1)
;;             (origami-toggle-node (current-buffer) (point)))))))

;; Enable logging for lsp-mode
;(setq lsp-log-io t)

;; Which-key integration
(require 'which-key)
(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))

;;;********************* ERLANG mode ******************

(setq load-path (cons "/home/dgud/src/emacs-erlang-ts" load-path))
(require 'erlang-ts)
;; (require 'erlang)

(add-hook 'erlang-mode-hook #'lsp)
(add-hook 'erlang-mode-hook 'which-key-mode)

(setq flycheck-erlang-include-path '("../include" "/home/dgud/src/wings/e3d"))
(setq flycheck-erlang-library-path '("/home/dgud/src/wings/intl_tools"))

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(defun my-erlang-mode-hook ()
  (local-set-key "\C-cm" 'erlang-man-function)
  (local-set-key "\C-cs" 'tempo-template-erlang-spec)
  (setq indent-tabs-mode nil)
;; (company-erlang-init)
  )

;; Tell emacs that files with the extension .erl are erlang mode 
(setq auto-mode-alist
      (cons '("\\.hrl$" . erlang-ts-mode)
	    (cons '("\\.erl$" . erlang-ts-mode)
		  auto-mode-alist)))
;;;; ******************** ERLANG ends *****************

(autoload 'glsl-mode "glsl-mode" nil t)
(setq auto-mode-alist (cons '("\\.vs$" . glsl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.fs$" . glsl-mode) auto-mode-alist))

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
 '(lsp-ui-sideline-ignore-duplicate t)
 '(lsp-ui-sideline-show-code-actions t)
 '(lsp-ui-sideline-show-diagnostics t)
 '(lsp-ui-sideline-show-hover nil)
 '(lsp-ui-sideline-show-symbol nil)
 '(lsp-ui-sideline-update-mode 'point)
 '(package-selected-packages
   '(multiple-cursors flymake-diagnostic-at-point xref gnu-elpa-keyring-update lsp-mode hungry-delete column-enforce-mode yasnippet which-key magit lsp-ui lsp-origami erlang company))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(treesit-font-lock-level 4)
 '(visible-bell t)
 '(warning-suppress-types '((comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "DAMA" :family "Ubuntu Mono"))))
 '(region ((t (:extend t :background "navajo white" :distant-foreground "gtk_selection_fg_color"))))
 '(trailing-whitespace ((t (:background "khaki")))))
(message "LOADING .emacs done")
