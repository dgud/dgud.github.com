;; Turn on font-lock in all modes that support it
(if (fboundp 'global-font-lock-mode)
    (global-font-lock-mode t))

;; Maximum colors
(setq font-lock-maximum-decoration t)
;; Turn on colors on marked text
(transient-mark-mode t)
(show-paren-mode t)

(require 'uniquify)
(setq show-trailing-whitespace 't)

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

(setq erlang-root-dir "C:/Program Files (x86)/erl5.10/")
(setq load-path (cons  "C:/Program Files (x86)/erl5.10/lib/tools-???/emacs" load-path))
(setq exec-path (cons "C:/Program/erl5.10/bin" exec-path))
(require 'erlang-start)
(require 'erlang-flymake)

(defun wings-paths () 
  (append (list "/home/dgud/src/wings/intl_tools") 
	  (erlang-flymake-get-code-path-dirs)))
(setq erlang-flymake-get-code-path-dirs-function 'wings-paths)

(defun wings-includes () 
  (append (list "/home/dgud/src/wings/src" "/home/dgud/src/wings/e3d") 
	  (erlang-flymake-get-include-dirs)))
(setq erlang-flymake-get-include-dirs-function 'wings-includes)

(add-hook 'erlang-mode-hook 'my-erlang-mode-hook)
(defun my-erlang-mode-hook ()
  (setq indent-tabs-mode nil)
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; SHELL with git completion
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Make sure that the bash executable can be found
(setq explicit-shell-file-name "c:/MinGW/msys/1.0/bin/bash.exe")
(setq shell-file-name explicit-shell-file-name)
(setq explicit-bash.exe-args '("--noediting" "-i"))
;(add-to-list 'exec-path "C:/cygwin/bin")

(defun pcmpl-git-commands ()
  "Return the most common git commands by parsing the git output."
  (with-temp-buffer
    (call-process-shell-command "git" nil (current-buffer) nil "help" "--all")
    (goto-char 0)
    (search-forward "available git commands in")
    (let (commands)
      (while (re-search-forward
	      "^[[:blank:]]+\\([[:word:]-.]+\\)[[:blank:]]*\\([[:word:]-.]+\\)?"
	      nil t)
	(push (match-string 1) commands)
	(when (match-string 2)
	  (push (match-string 2) commands)))
      (sort commands #'string<))))

(defconst pcmpl-git-commands (pcmpl-git-commands)
  "List of `git' commands.")

(defvar pcmpl-git-ref-list-cmd "git for-each-ref refs/ --format='%(refname)'"
  "The `git' command to run to get a list of refs.")

(defun pcmpl-git-get-refs (type)
  "Return a list of `git' refs filtered by TYPE."
  (with-temp-buffer
    (insert (shell-command-to-string pcmpl-git-ref-list-cmd))
    (goto-char (point-min))
    (let (refs)
      (while (re-search-forward (concat "^refs/" type "/\\(.+\\)$") nil t)
	(push (match-string 1) refs))
      (nreverse refs))))

(defun pcmpl-git-remotes ()
  "Return a list of remote repositories."
  (split-string (shell-command-to-string "git remote")))

(defun pcomplete/git ()
  "Completion for `git'."
  ;; Completion for the command argument.
  (pcomplete-here* pcmpl-git-commands)
  (cond
   ((pcomplete-match "help" 1)
    (pcomplete-here* pcmpl-git-commands))
   ((pcomplete-match (regexp-opt '("pull" "push")) 1)
    (pcomplete-here (pcmpl-git-remotes)))
   ;; provide branch completion for the command `checkout'.
   ((pcomplete-match "checkout" 1)
    (pcomplete-here* (append (pcmpl-git-get-refs "heads")
			     (pcmpl-git-get-refs "tags"))))
   (t
    (while (pcomplete-here (pcomplete-entries))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
