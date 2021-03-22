;; -----------------------GUI/Terminal Settings----------------------
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(if (display-graphic-p)
    (progn
      ;; GUI emacs settings
      (load-theme 'custom-dark t)
      (add-to-list 'default-frame-alist '(fullscreen . maximized))
      (global-linum-mode t))
  ;; Terminal emacs settings
  (load-theme 'custom-dark t)
  (define-key esc-map " " 'set-mark-command)
  (global-set-key (kbd "<M-delete>") 'kill-word)
  (normal-erase-is-backspace-mode 0))


;; -----------Manual configurations are saved in custom.el-----------
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file :noerror)


;; -----------Get package servers, and install use-package-----------
(require 'package)
(package-initialize)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("MELPA" . "https://melpa.org/packages/")
	("org" . "https://orgmode.org/elpa/"))
      package-archive-priorities
      '(("MELPA" . 5)
        ("gnu" . 1)
	("org" . 0))
      )
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))


;; ------------------------------------------------------------------
;; --------------------------General config--------------------------
;; ------------------------------------------------------------------

;; Sensible defaults fixes things such as weird comment behaviour
(load-file "~/.emacs.d/configFiles/sensible-defaults.el")
(sensible-defaults/use-all-settings)
(sensible-defaults/use-all-keybindings)
(sensible-defaults/backup-to-temp-directory)

;; Enable UTF-8 (unicode) support
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;; Tab inserts 5 spaces by default
(setq-default indent-tabs-mode 0)
(setq tab-width 5)

;; Do not delete selection upon backspacing or typing.
(delete-selection-mode 0)

;; Don't show menu or scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(when window-system
  (scroll-bar-mode -1))

;; Disable warning bell
(setq ring-bell-function 'ignore)

;; Fix Emacs' mouse scrolling behaviour
(setq scroll-conservatively 100) ;; When cursor moves outside window, don't jump erratically
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse

;; Enable disabled commands
(put 'narrow-to-region 'disabled nil)

;; Enable CamelCase recognition
(global-subword-mode)

;; Change yes/no prompts to y/n
(fset 'yes-or-no-p 'y-or-n-p)


;; --------------------------Org mode config-------------------------
(require 'org)
(autoload 'org-mode "org" "Org Mode" t)
(defun my-org-mode-hook ()
    (setq org-log-done t)
    (define-key global-map "\C-cl" 'org-store-link)
    (define-key global-map "\C-ca" 'org-agenda)
    (visual-line-mode 1)
    (org-indent-mode 1)
    (abbrev-mode 1)
    (org-bullets-mode 1)
    (flyspell-mode 1)
    (setq org-src-fontify-natively t
          org-src-tab-acts-natively t
          org-confirm-babel-evaluate nil
          org-edit-src-content-indentation 0)
    (setq org-hide-emphasis-markers t)
    )
(add-hook 'org-mode-hook 'my-org-mode-hook)


;; --------------------------f90-mode config-------------------------
(defun my-f90-mode-hook ()
  (setq f90-font-lock-keywords f90-font-lock-keywords-3)
  '(f90-comment-region "!!!$")
  '(f90-indented-comment-re "!")
  (abbrev-mode 1)                       ; turn on abbreviation mode
  (turn-on-font-lock)                   ; syntax highlighting
  (auto-fill-mode 0)                    ; turn off auto-filling
  )
(add-hook 'f90-mode-hook 'my-f90-mode-hook)


;; ----------------------Emacs-Lisp-mode config----------------------
(define-key emacs-lisp-mode-map (kbd "C-c C-a") 'eval-buffer)
(define-key emacs-lisp-mode-map (kbd "C-c C-r") 'eval-region)


;; ---------------------------Latex config---------------------------
(defun my-LaTeX-mode-hook ()
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-PDF-mode t)
  (visual-line-mode 1)
  (flyspell-mode 1)
  (LaTeX-math-mode 1)
  (TeX-source-correlate-mode 1)
  (outline-minor-mode 1)
  (electric-pair-mode 1)
  (local-set-key (kbd "C-c b") 'tex-latex-block) ; Insert a block
  (local-set-key (kbd "<C-tab>") 'outline-toggle-children) ; Collapse section/block
  )
(add-hook 'LaTeX-mode-hook 'my-LaTeX-mode-hook)

;; Ensure flyspell is installed
(use-package flyspell
  :ensure t
)

;; -------------------------Linum-mode config------------------------
;; Linum mode is laggy in some types of buffers, disable it in them
(require 'linum)
(setq linum-disabled-modes-list '(eshell-mode wl-summary-mode
					      compilation-mode text-mode dired-mode pdf-view-mode
					      doc-view-mode shell-mode pdf-view-mode image-mode
					      term-mode)
      )

;; ------------------------------------------------------------------
;; ----------------Handy custom keybindings/functions----------------
;; ------------------------------------------------------------------


;; ----------------Insert one of these comment headers---------------
(defun custom/general-comment-header (title)
  "Inserts a commented title"
  (interactive "sEnter a title: ")
  (defvar dash-len 1)
  (setq dash-len (/ (- 66 (length title)) 2))
  (dotimes (ii dash-len)
    (insert "-"))
  (if (= (mod (length title) 2) 1)
      (insert "-")
    )
  (insert title)
  (dotimes (ii dash-len)
    (insert "-"))
  (sensible-defaults/comment-or-uncomment-region-or-line)
  (indent-for-tab-command)
  )
(global-set-key (kbd "C-c h") 'custom/general-comment-header)


;; ------------Toggle horizontal/vertical window splitting-----------
(defun custom/window-split-toggle ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer)))))
    )
(global-set-key (kbd "C-c C-f") 'custom/window-split-toggle)


;; ------------------Quick access to .bashrc/init.el-----------------
(defun custom/visit-emacs-config ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "C-c e") 'custom/visit-emacs-config)

(defun custom/visit-bashrc ()
  (interactive)
  (find-file "~/.bashrc"))
(global-set-key (kbd "C-c b") 'custom/visit-bashrc)


;; ----------------------Move lines up and down----------------------
(defun abell/move-line-up ()
  (interactive)
  (transpose-lines 1)
  (previous-line 2))
(global-set-key (kbd "M-<up>") 'abell/move-line-up)

(defun abell/move-line-down ()
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (previous-line 1))
(global-set-key (kbd "M-<down>") 'abell/move-line-down)


;; ----------------------Duplicate lines/regions---------------------
(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times."
  (interactive "p")
  (let (beg end (origin (point)))
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (let ((region (buffer-substring-no-properties beg end)))
      (dotimes (i arg)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point)))
      (goto-char (+ origin (* (length region) arg) arg)))))
(global-set-key (kbd "C-c C-d") 'duplicate-current-line-or-region)


;; --------------Kill both the current buffer and frame--------------
(defun custom/kill-buffer-and-frame ()
  (interactive)
  (kill-this-buffer)
  (delete-frame))
(global-set-key (kbd "C-x 5 k") 'custom/kill-buffer-and-frame)


;; ----------------Open a terminal in the other window---------------
(defun custom/open-term-other-window ()
  (interactive)
  (let ((buf (ansi-term "/bin/bash")))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-window buf))
  )
(global-set-key (kbd "C-x 4 t") 'custom/open-term-other-window)


;; --------------------Increment/decrement numbers-------------------
(defun my-increment-number-decimal (&optional arg)
  "Increment the number forward from point by 'arg'."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))

(defun my-decrement-number-decimal (&optional arg)
  (interactive "p*")
  (my-increment-number-decimal (if arg (- arg) -1)))

(global-set-key (kbd "C-c f") 'my-increment-number-decimal)
(global-set-key (kbd "C-c d") 'my-decrement-number-decimal)


;; ----------------------Misc extra keybindings----------------------
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "C-x 4 k") 'kill-buffer-and-window)




;; ------------------------------------------------------------------
;; --------------------------Optional modes--------------------------
;; ------------------------------------------------------------------

;; -----------------------------Yasnippet----------------------------
;; Yasnippet lets you create snippets based on keywords which expand
;;    into full code snippets. Some examples are in ~/.emacs.d/snippets

;; (use-package yasnippet
;;   :ensure t
;;   :init
;;   (yas-global-mode 1)
;;   :config
;;   (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
;;   (setq yas-indent-line 'fixed)
;;   (define-key yas-minor-mode-map (kbd "TAB") yas-maybe-expand)
;;   )



;; -------------------------------Helm-------------------------------
;; Helm is a nicer expansion to the mini-buffer which shows you the
;;    directory you are searching in, commands you are entering etc.

;; (use-package helm
;;   :ensure t
;;   :bind-keymap
;;   :init
;;   (helm-mode 0)
;;   :config
;;   (require 'helm-config)
;;   (global-set-key (kbd "M-x") 'helm-M-x)
;;   (global-set-key (kbd "C-x C-f") 'helm-find-files)
;;   (global-set-key (kbd "C-x C-b") 'helm-buffers-list)
;;   (global-set-key (kbd "C-x b") 'helm-mini)
;;   )


;; ---------------------------Company mode---------------------------
;; Company provides auto-complete suggestions. Can cycle between which
;;    one you want with M-n and M-p, and select with <return>.

;; (use-package company
;;   :ensure t
;;   :config
;;   (setq company-idle-delay 0)
;;   (setq company-minimum-prefix-length 3)
;;   (global-company-mode t)
;;   )
