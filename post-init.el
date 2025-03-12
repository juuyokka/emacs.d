(use-package org
  :straight (:type built-in)
  :bind (:map org-mode-map
	   ("C-c C-'" . org-edit-special)
	   ("C-c '"   . nil)
	   :map org-src-mode-map
	   ("C-c C-'" . org-edit-src-exit)
	   ("C-c '"   . nil)))

(use-package org-tree-slide
  :straight t
  :after org
  :custom
  (org-tree-slide-slide-in-effect nil))

(use-package org-auto-tangle
  :straight t
  :hook (org-mode . org-auto-tangle-mode))

(use-package dired
  :straight (:type built-in)
  :custom
  (dired-listing-switches "-alGh --group-directories-first"))

(use-package dired-x
  :straight (:type built-in)
  :after dired)

(use-package perspective-exwm
  :straight t
  :after perspective)

(use-package exwm
  :straight t
  :after perspective-exwm
  :hook
  (exwm-update-title . (lambda () (exwm-workspace-rename-buffer exwm-title)))
  :config
  (setq exwm-input-global-keys
        `(([?\M-r] . exwm-reset)
          ([?\M-d] . (lambda (cmd)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command cmd nil cmd)))))
  (perspective-exwm-mode)
  (exwm-enable))

(use-package perspective
  :straight t
  :defer t
  :custom (persp-mode-prefix-key (kbd "C-x C-x"))
  :bind
  ("C-x b" . persp-list-buffers)
  :init (persp-mode))

(use-package modus-themes
  :straight (:type built-in)
  :custom
  (modus-vivendi-palette-overrides
   '((bg-main               "#1e1e2e")
     (bg-mode-line-active   "#313244")
     (bg-mode-line-inactive "#181825")))
  :init
  (load-theme 'modus-vivendi :no-confirm))

(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-bar-width 10)
  :custom-face
  (doom-modeline-bar       ((t :background "#cba6f7")))
  (doom-modeline-highlight ((t (:background "#b4befe"
                                :foreground "#313244")))))

(use-package vertico
  :straight t
  :defer t
  :commands vertico-mode
  :hook (after-init . vertico-mode))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (orderless-matching-styles '(orderless-literal
                               orderless-regexp
                               orderless-flex))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :straight t
  :defer t
  :commands (marginalia-mode marginalia-cycle)
  :hook (after-init . marginalia-mode))

(use-package nix-mode
  :straight t
  :mode "\\.nix\\'")

(use-package magit
  :straight t
  :defer t)

(use-package embark
  :straight t
  :defer t
  :commands (embark-act
             embark-dwim
             embark-export
             embark-collect
             embark-bindings
             embark-prefix-help-command)
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult
  :straight t
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)
         ("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("C-x t b" . consult-buffer-other-tab)
         ("C-x r b" . consult-bookmark)
         ("C-x p b" . consult-project-buffer)
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g o" . consult-outline)
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)
         ("M-s c" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)
         ("M-s e" . consult-isearch-history)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)
         ("M-r" . consult-history))

  ;; Enable automatic preview at point in the *Completions* buffer.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  :init
  ;; Optionally configure the register formatting. This improves the register
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.4 any))
  (setq consult-narrow-key "<"))

(set-face-attribute 'default nil :height 160)

(global-visual-line-mode 1)

(setq display-line-numbers 'relative)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(start-process-shell-command "xsetroot" nil "xsetroot -cursor_name left_ptr")
