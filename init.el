(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(set-face-attribute 'default nil :height 150)

(menu-bar-mode -1)

;; maximize frame
(add-hook 'window-setup-hook 'toggle-frame-maximized t)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(helm elpy which-key evil use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; TODO Figure it out Alexander, that's an order from your commander

;;(setq evil-want-integration t)
;;(setq evil-want-keybinding nil)
(setq evil-want-C-u-scroll t)
;;(setq evil-want-C-i-jump nil)
;;(setq evil-respect-visual-line-mode t)
;;(setq evil-undo-system 'undo-tree)
(require 'evil)

(evil-mode 1)

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
