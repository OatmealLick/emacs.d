(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(setq make-backup-files nil)
(setq scroll-conservatively 101)
(setq scroll-step 1)

(set-face-attribute 'default nil :height 150)

(menu-bar-mode -1)

;; maximize frame
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

;; this supposedly helps with M-x shell but I do not see the difference
(setq explicit-shell-file-name "/usr/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '("--login" "--interactive"))
(defun zsh-shell-mode-setup ()
  (setq-local comint-process-echoes t))
(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)

;; this supposedly helps with M-x [term|ansi-term], yet to see the difference
;; M-p and M-n works as up and down
;;(defun mp-term-custom-settings ()
;;  (local-set-key (kbd "M-p") 'term-send-up)
;;  (local-set-key (kbd "M-n") 'term-send-down))
;;(add-hook 'term-load-hook #'mp-term-custom-settings)

;;(define-key term-raw-map (kbd "M-o") 'other-window)
;;(define-key term-raw-map (kbd "M-p") 'term-send-up)
;;(define-key term-raw-map (kbd "M-n") 'term-send-down)

(setq ring-bell-function 'ignore)

(load-theme 'tango-dark)

;; The 'package.el' is built-in, hence no use-package
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; evil configuration
;; (use-package evil
;;   :ensure t)
;; ;; TODO Figure it out Alexander, that's the order from your commander
;; either use use-package and init, or require + standard setup from evil page

(use-package vterm
  :ensure t)

(use-package projectile
  :ensure t)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
(setq projectile-project-search-path '("~/projects/" "~/workspace/"))

;; disable customize
(dolist (sym '(customize-option customize-browse customize-group customize-face
               customize-rogue customize-saved customize-apropos
               customize-changed customize-unsaved customize-variable
               customize-set-value customize-customized customize-set-variable
               customize-apropos-faces customize-save-variable
               customize-apropos-groups customize-apropos-options
               customize-changed-options customize-save-customized))
  (put sym 'disabled "Doom like removal of `customize'"))
(put 'customize-themes 'disabled "Use `load-theme'")

(defun setup-evil ()
    (setq evil-want-C-u-scroll t)
    (setq evil-undo-system 'undo-redo)
    ;;(setq evil-want-C-d-scroll t)
    ;;(setq evil-want-integration t)
    ;;(setq evil-want-keybinding nil)
    ;;(setq evil-want-C-i-jump nil)
    ;;(setq evil-respect-visual-line-mode t)

    (unless (package-installed-p 'evil)
    (package-install 'evil))
    (require 'evil)
    (evil-mode 1)
)

(setup-evil)

;; disable lockfiles starting with .# and messing up dbt
(setq create-lockfiles nil)

(unless (package-installed-p 'helm)
   (package-install 'helm))

(require 'helm)
;;(require 'helm-config)
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(define-key helm-find-files-map (kbd "C-i") 'helm-ff-TAB)
(setq helm-ff-DEL-up-one-level-maybe 1)

;; kill all buffers except the active one
(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(use-package lsp-mode
  :config
  (lsp-register-custom-settings
   '(("pyls.plugins.pyls_mypy.enabled" t t)
     ("pyls.plugins.pyls_mypy.live_mode" nil t)
     ("pyls.plugins.pyls_black.enabled" t t)
     ("pyls.plugins.pyls_isort.enabled" t t)))
  :hook
  ((python-mode . lsp)))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package pyvenv
  :config
  (pyvenv-mode t))

;; autocompletion
(unless (package-installed-p 'company)
   (package-install 'company))
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

;; syntax checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(add-hook 'after-init-hook #'global-flycheck-mode)

;; backend for company python
(use-package company-jedi)
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))
(add-hook 'python-mode-hook 'my/python-mode-hook)

;; make sure C-r in vterm works as C-r in terminal
(defun setup-vterm-mode ()
  (evil-local-set-key 'insert (kbd "C-r") 'vterm-send-C-r))

(add-hook 'vterm-mode-hook 'setup-vterm-mode)

;; open config file with shortcut
(defun find-file-config-file ()
  "Find and open config file"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(global-set-key (kbd "M-q") 'find-file-config-file)


(use-package terraform-mode
  :custom (terraform-format-on-save t)
)

(use-package which-key)
(which-key-mode)

(setenv "WORKON_HOME" "~/.pyenv/versions")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(neotree company-terraform jedi company-jedi which-key vterm use-package terraform-mode pyvenv projectile lsp-ui lsp-pyright helm flycheck evil company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package company-terraform)
(company-terraform-init)

(use-package neotree)
(global-set-key [f8] 'neotree-toggle)
