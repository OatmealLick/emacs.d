(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(setq make-backup-files nil)
(setq scroll-conservatively 101)
(setq scroll-step 1)

(setq font "JetBrainsMono NF Regular")
(set-face-attribute 'default nil :font font :height 128)

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

(use-package all-the-icons)
(use-package doom-themes
  :config (doom-themes-org-config)
  :init (load-theme 'doom-challenger-deep t)
)

;;(load-theme 'wombat)
;;(load-theme 'doom-challenger-deep)

(use-package projectile
  :ensure t)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "M-p") 'projectile-command-map)
;; (setq projectile-project-search-path '("~/projects/" "~/workspace/"))



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
    (setq evil-want-keybinding nil)
    ;;(setq evil-want-C-i-jump nil)
    ;;(setq evil-respect-visual-line-mode t)

    (unless (package-installed-p 'evil)
    (package-install 'evil))
    (require 'evil)
    (evil-mode 1)
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
)

(setup-evil)
(use-package evil-collection
  :after evil
  ;; :init
  ;; ;; (setq evil-collection-mode-list (remove 'neotree evil-collection-mode-list))
  ;; (setq evil-collection-mode-list nil)
  :config
  (evil-collection-init))

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

;;(use-package helm-flx)
;;(helm-flx-mode 1)

;; kill all buffers except the active one
(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))


(use-package yasnippet
  :config
  (yas-global-mode 1)
)

;; open config file with shortcut
(defun find-file-config-file ()
  "Find and open config file"
  (interactive)
  (find-file "~/.emacs.d/init.el"))


(global-set-key (kbd "M-q") 'find-file-config-file)


(use-package terraform-mode
  :custom (terraform-format-on-save t)
)

(use-package which-key
  :init
  (setq whick-key-idle-delay 0.5)
  :config
  (which-key-mode)
  :diminish which-key-mode
)

;; (setenv "WORKON_HOME" "~/.pyenv/versions")

;; (use-package company-terraform)
;; (company-terraform-init)

;; (use-package neotree
;;   :config
;;   ;; (evil-collection-define-key 'normal 'neotree-mode-map
;;   ;; "TAB" 'neotree-enter
;;   ;; "SPC" 'neotree-quick-look
;;   ;; "q" 'neotree-hide
;;   ;; "RET" 'neotree-enter
;;   ;; "g" 'neotree-refresh
;;   ;; "n" 'neotree-next-line
;;   ;; "p" 'neotree-previous-line
;;   ;; "A" 'neotree-stretch-toggle
;;   ;; "H" 'neotree-hidden-file-toggle)

;;   )
;; (global-set-key [f8] 'neotree-toggle)

;; kill emacs
(global-set-key (kbd "M-<f4>") 'kill-emacs)


;; overwrite split window right to focus as well
(defun split-window-right-and-other-window ()
  "Find and open config file"
  (interactive)
  (split-window-right)
  (other-window 1)
)

(global-set-key (kbd "C-x 3") 'split-window-right-and-other-window)

(use-package nerd-icons
  ;; :custom
  ;; The Nerd Font you want to use in GUI
  ;; "Symbols Nerd Font Mono" is the default and is recommended
  ;; but you can use any other Nerd Font if you want
  ;; (nerd-icons-font-family "Symbols Nerd Font Mono")
  :custom
  (nerd-icons-font-family font)
)

(use-package doom-modeline
  :init
  (setq doom-modeline-height 36)
  (doom-modeline-mode 1)
)

;; Line numbers
;; this causes line to flicker when you go jjjjjjjjj
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
		grep-mode-hook
		help-mode-hook
                eshell-mode-hook
		dired-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key helpful-function helpful-variable)
  :bind
  ([remap describe-function] . helpful-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-key] . helpful-key))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages
   '(yasnippet all-the-icons-dired dired-single evil-collection helm-lsp company-box which-key vterm use-package terraform-mode rainbow-delimiters pyvenv projectile neotree lsp-ui lsp-pyright helpful helm-fuzzy helm-flx evil doom-themes doom-modeline company all-the-icons)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package dired
  :ensure nil
  :config
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;; All the non-LSP stuff goes before LSP shit

(use-package lsp-mode
  ;; :commands (lsp lsp-deferred)
  :commands (lsp)
  :init
  (setq lsp-document-sync-method 'lsp--sync-full)
  (setq lsp-keymap-prefix "C-SPC")
  (setq lsp-log-io t)
  (setq lsp-log-max t)
  :config
  ;; (lsp-register-custom-settings
  ;;  '(("pyls.plugins.pyls_mypy.enabled" t t)
  ;;    ("pyls.plugins.pyls_mypy.live_mode" nil t)
  ;;    ("pyls.plugins.pyls_black.enabled" t t)
  ;;    ("pyls.plugins.pyls_isort.enabled" t t)))
  (lsp-enable-which-key-integration t)
  ;; :hook
  ;; ((python-mode . lsp-deferred))
)

(use-package lsp-pyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package pyvenv
  :config
  (pyvenv-mode t))

;; ;; autocompletion
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package helm-lsp
  :after lsp-mode)
(define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)

;; (unless (package-installed-p 'company)
;;    (package-install 'company))
;; (require 'company)
;; (add-hook 'after-init-hook 'global-company-mode)

;; make sure C-r in vterm works as C-r in terminal
(defun setup-vterm-mode ()
  (evil-local-set-key 'insert (kbd "C-r") 'vterm-send-C-r))

(add-hook 'vterm-mode-hook 'setup-vterm-mode)



;; Alexander, figure it out, it will be your Magnum Opus, JAI LSP client
(load "~/.emacs.d/jai-mode.el")

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration '(jai-mode . "jai"))
)


(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection "jails")
                  :activation-fn (lsp-activate-on "jai")
                  :server-id 'jails))

(add-hook 'jai-mode-hook 'lsp-mode)
(add-hook 'lsp-before-open-hook (lambda () (message "Eat cake")))
(add-hook 'lsp-after-open-hook (lambda () (message "Ate cake")))
;; (add-hook 'jai-mode-hook lsp)
;; Alexander end
