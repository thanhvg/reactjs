;;; funcs.el --- react layer funcs file for Spacemacs. -*- lexical-binding: t -*-
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Muneeb Shaikh <muneeb@reversehack.in>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3


;; backend
(defun spacemacs//reactjs-setup-backend ()
  "Conditionally setup react backend."
  (pcase reactjs-backend
    (`dumb (spacemacs//reactjs-setup-dumb))
    (`lsp (spacemacs//reactjs-setup-lsp))))

(defun spacemacs//reactjs-setup-company ()
  "Conditionally setup company based on backend."
  (pcase reactjs-backend
    (`dumb (spacemacs//reactjs-setup-dumb-company))
    (`lsp (spacemacs//reactjs-setup-lsp-company))))


;; lsp
(defun spacemacs//reactjs-setup-lsp ()
  "Setup lsp backend."
  (if (configuration-layer/layer-used-p 'lsp)
      (progn
        ;; error checking from lsp langserver sucks, turn it off so eslint won't
        ;; be overriden
        (setq-local lsp-prefer-flymake :none)
        (lsp))
    (message (concat "`lsp' layer is not installed, "
                     "please add `lsp' layer to your dotfile."))))

(defun spacemacs//reactjs-setup-lsp-company ()
  "Setup lsp auto-completion."
  (if (configuration-layer/layer-used-p 'lsp)
      (progn
        (spacemacs|add-company-backends
          :backends company-lsp
          :modes rjsx-mode
          :variables company-minimum-prefix-length 2
          :append-hooks nil
          :call-hooks t)
        (company-mode)
        (fix-lsp-company-prefix))
    (message "`lsp' layer is not installed, please add `lsp' layer to your dotfile.")))


;; dumb
(defun spacemacs//reactjs-setup-dumb-company ()
  (spacemacs|add-company-backends :backends company-capf :modes rjsx-mode)
  (company-mode))
(defun spacemacs//reactjs-setup-dumb ()
  (add-to-list 'spacemacs-jump-handlers-rjsx-mode 'dumb-jump-go))

;; Emmet
(defun spacemacs/reactjs-emmet-mode ()
  "Activate `emmet-mode' and configure it for local buffer."
  (emmet-mode)
  (setq-local emmet-expand-jsx-className? t))


;; Others
(defun spacemacs//reactjs-inside-string-q ()
  "Returns non-nil if inside string, else nil.
Result depends on syntax table's string quote character."
  (let ((result (nth 3 (syntax-ppss))))
    result))

(defun spacemacs//reactjs-inside-comment-q ()
  "Returns non-nil if inside comment, else nil.
Result depends on syntax table's comment character."
  (let ((result (nth 4 (syntax-ppss))))
    result))

(defun spacemacs//reactjs-inside-string-or-comment-q ()
  "Return non-nil if point is inside string, documentation string or a comment.
If optional argument P is present, test this instead of point."
  (or (spacemacs//reactjs-inside-string-q)
      (spacemacs//reactjs-inside-comment-q)))

(defun spacemacs//reactjs-setup-yasnippet ()
  (yas-activate-extra-mode 'js-mode))

(defun spacemacs//reactjs-setup-next-error-fn ()
  (setq-local next-error-function nil))
