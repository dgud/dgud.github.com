;; Turn on font-lock in all modes that support it
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode t))

;; Maximum colors
(setq font-lock-maximum-decoration t)
;; Turn on colors on marked text
(transient-mark-mode t)
(show-paren-mode t)

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

;;;********************* ERLANG mode ******************

(setq erlang-root-dir "C:/Program Files (x86)/erl5.8/")
(setq load-path (cons  "C:/Program Files (x86)/erl5.8/lib/tools-2.6.6/emacs" load-path))
(setq exec-path (cons "C:/Program/erl5.7/bin" exec-path))
(require 'erlang-start)
(require 'erlang-flymake)

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(defun my-erlang-mode-hook ()
  (local-set-key "\C-cm" 'erlang-man-function))

;; Tell emacs that files with the extension .erl are erlang mode 
(setq auto-mode-alist
      (cons '("\\.hrl$" . erlang-mode)
	    (cons '("\\.erl$" . erlang-mode)
		  auto-mode-alist)))

;;;; ******************** ERLANG ends *****************

(autoload 'glsl-mode "glsl-mode" nil t)
(setq auto-mode-alist (cons '("\\.vs$" . glsl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.fs$" . glsl-mode) auto-mode-alist))

(setq cse-startup-message-11-1 nil)
(setq mpuz-silent t)
(setq cse-startup-message-12-1 3)
(setq minibuffer-max-depth nil)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(column-number-mode t)
 '(current-language-environment "Latin-1")
 '(default-input-method "latin-1-prefix")
 '(global-font-lock-mode t nil (font-lock))
 '(inhibit-startup-screen t)
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil)
 '(transient-mark-mode t)
 '(use-file-dialog nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
