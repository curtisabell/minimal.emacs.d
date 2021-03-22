(deftheme custom-dark
  "custom-dark theme")

(custom-theme-set-faces
 'custom-dark

 ;;; Normal Text
 '(default ((t (:background "black" :foreground "White"))))
 '(mouse ((t (:foreground "grey85"))))
 '(cursor ((t (:background "grey85"))))

 ;;; Comment colour
 '(font-lock-comment-face ((t (:italic t :foreground "grey60"))))
 ;;; String colour
 '(font-lock-string-face ((t (:foreground "firebrick1"))))
 ;;; Keywords such as: call, write, allocate, open, do, for, if, with, return etc
 '(font-lock-keyword-face ((t (:bold t :foreground "Cyan"))))
 ;;; Keywords such as: True, False, None, NULL
 '(font-lock-constant-face ((t (:foreground "magenta1"))))
 ;;; Static Variable types (real, int, boolean, character etc)
 '(font-lock-type-face ((t (:foreground "green3"))))
 ;;; Variable names
 '(font-lock-variable-name-face ((t (:foreground "goldenrod1"))));;;"DarkGoldenrod"))))
 ;;; Name of programs, functions, subroutines etc
 '(font-lock-function-name-face ((t (:foreground "SpringGreen"))))
 ;;; Very rare, autoload in this file
 '(font-lock-warning-face ((t (:bold t :foreground "Pink"))))
 ;;; Only keywords in lisp such as :foreground, :init etc
 '(font-lock-builtin-face ((t (:foreground "SkyBlue"))))
 ;;; other stuff i couldnt be bothered figuring out
 '(highline-face ((t (:background "grey12"))))
 '(setnu-line-number-face ((t (:background "Grey15" :foreground "White" :bold t))))
 '(show-paren-match-face ((t (:background "grey30"))))
 '(region ((t (:background "grey15"))))
 '(highlight ((t (:background "blue"))))
 '(secondary-selection ((t (:background "navy"))))
 '(widget-field-face ((t (:background "navy"))))
 '(widget-single-line-field-face ((t (:background "royalblue")))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'custom-dark)
