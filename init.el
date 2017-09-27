(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (cyberpunk)))
 '(custom-safe-themes
   (quote
    ("235dc2dd925f492667232ead701c450d5c6fce978d5676e54ef9ca6dd37f6ceb" default)))
 '(package-selected-packages
   (quote
    (company yasnippet omnisharp csharp-mode arduino-mode markdown-mode+ markdown-mode restclient auto-complete elnode json-rpc cyberpunk-theme clojure-mode-extra-font-locking cider paredit helm evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'after-init-hook 'global-company-mode)

;;Basic Init
(show-paren-mode 1)
(scroll-bar-mode -1)

;;EVIL
(require 'evil)
(evil-mode 1)

;;HELM
(require 'helm)
(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "C-x C-f") 'helm-find-files)

;;PAREDIT
(defun init-paredit ()
  (paredit-mode)
  (local-set-key (kbd "C-c [") 'paredit-wrap-square)
  (local-set-key (kbd "C-c {") 'paredit-wrap-curly))

(defun init-csharp ()
  (local-set-key (kbd "C-c i") 'imenu)
  (omnisharp-mode))


(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'init-paredit)
(add-hook 'lisp-mode-hook             #'init-paredit)
;;(add-hook 'org-mode-hook             #'init-paredit)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'init-paredit)
(add-hook 'clojure-mode-hook          #'init-paredit)
(add-hook 'clojurescript-mode-hook    #'init-paredit)
(add-hook 'cider-repl-mode-hook #'init-paredit)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
(add-hook 'csharp-mode-hook #'init-csharp)

;;CLOJURE
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(add-hook 'clojure-mode-hook          #'enable-paredit-mode)

(require 'org)
(require 'ob-clojure)
(setq org-babel-clojure-backend 'cider)
(setq org-babel-lisp-eval-fn 'slime-eval-last-expression)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((lisp .t)))
;;AUTOCOMPLETE
(ac-config-default)

;;REMOTE EVAL
;;(load "~/.emacs.d/remote-eval/remote-eval.el")
;;(remote-eval-start 3333)


;;Lisp
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")
(add-to-list 'slime-contribs 'slime-autodoc)

(put 'if 'lisp-indent-function nil)
(put 'case 'lisp-indent-function 2)



;; Various fns

(defun dired-dotfiles-toggle ()
  "Show/hide dot-files"
  (interactive)
  (when (equal major-mode 'dired-mode)
    (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
	(progn 
	  (set (make-local-variable 'dired-dotfiles-show-p) nil)
	  (message "h")
	  (dired-mark-files-regexp "^\\\.")
	  (dired-do-kill-lines))
	(progn (revert-buffer) ; otherwise just revert to re-show
	       (set (make-local-variable 'dired-dotfiles-show-p) t)))))


(eval-after-load
 'company
 '(add-to-list 'company-backends 'company-omnisharp))