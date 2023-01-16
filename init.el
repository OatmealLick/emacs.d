(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

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

(use-package evil
  :ensure t)

(use-package vterm
  :ensure t)

(use-package projectile
  :ensure t)

(projectile-mode 1)
(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(f lsp-mode lsp-pyright projectile helm elpy which-key evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; TODO Figure it out Alexander, that's an order from your commander

(require 'evil)
(evil-mode 1)
;;(setq evil-want-integration t)
;;(setq evil-want-keybinding nil)
(setq evil-want-C-u-scroll t)
;;(setq evil-want-C-i-jump nil)
;;(setq evil-respect-visual-line-mode t)
;;(setq evil-undo-system 'undo-tree)

;;(use-package elpy
;;  :ensure t
;;  :init
;;  (elpy-enable))

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
  :ensure t)

;; python lsp
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
    (require 'lsp-pyright)
    (lsp))))  ; or lsp-deferred
