;;; packages.el --- react layer packages file for Spacemacs. -*- lexical-binding: t -*-
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Andrea Moretti <axyzxp@gmail.com>
;; URL: https://github.com/axyz
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst reactjs-packages
  '(
    add-node-modules-path
    company
    emmet-mode
    evil-matchit
    flycheck
    import-js
    js-doc
    prettier-js
    rjsx-mode
    smartparens
    web-beautify
    yasnippet
    ))

(defun reactjs/post-init-add-node-modules-path ()
  (add-hook 'rjsx-mode-hook #'add-node-modules-path))

(defun reactjs/post-init-company ()
  (add-hook 'rjsx-mode-local-vars-hook #'spacemacs//reactjs-setup-company))

(defun reactjs/post-init-emmet-mode ()
  (add-hook 'rjsx-mode-hook 'spacemacs/reactjs-emmet-mode))

(defun reactjs/post-init-evil-matchit ()
  (add-hook 'rjsx-mode-hook 'turn-on-evil-matchit-mode))

(defun reactjs/post-init-flycheck ()
  (with-eval-after-load 'flycheck
    (dolist (checker '(javascript-eslint javascript-standard))
      (flycheck-add-mode checker 'rjsx-mode)))
  (spacemacs/enable-flycheck 'rjsx-mode))

(defun reactjs/post-init-import-js ()
  (add-hook 'rjsx-mode-hook #'run-import-js)
  (spacemacs/import-js-set-key-bindings 'rjsx-mode))

(defun reactjs/post-init-js-doc ()
  (add-hook 'rjsx-mode-hook 'spacemacs/js-doc-require)
  (spacemacs/js-doc-set-key-bindings 'rjsx-mode))

(defun reactjs/init-rjsx-mode ()
  (use-package rjsx-mode
    :defer t
    :init
    ;; enable rjsx mode by using magic-mode-alist
    (defun +javascript-jsx-file-p ()
      (and buffer-file-name
           (or (equal (file-name-extension buffer-file-name) "js")
               (equal (file-name-extension buffer-file-name) "jsx"))
           (re-search-forward "\\(^\\s-*import React\\|\\( from \\|require(\\)[\"']react\\)"
                              magic-mode-regexp-match-limit t)
           (progn (goto-char (match-beginning 1))
                  (not (spacemacs//reactjs-inside-string-or-comment-q)))))

    (add-to-list 'magic-mode-alist (cons #'+javascript-jsx-file-p 'rjsx-mode))

    ;; setup rjsx backend
    (add-hook 'rjsx-mode-local-vars-hook #'spacemacs//reactjs-setup-backend)

    ;; nil next-error-function because we use flycheck
    (add-hook 'rjsx-mode-local-vars-hook #'spacemacs//reactjs-setup-next-error-fn)

    :config
    ;; declare prefix
    (spacemacs/declare-prefix-for-mode 'rjsx-mode "mr" "refactor")
    (spacemacs/declare-prefix-for-mode 'rjsx-mode "mrr" "rename")
    (spacemacs/declare-prefix-for-mode 'rjsx-mode "mh" "documentation")
    (spacemacs/declare-prefix-for-mode 'rjsx-mode "mg" "goto")

    (spacemacs/set-leader-keys-for-major-mode 'rjsx-mode "rt" 'rjsx-rename-tag-at-point)

    (with-eval-after-load 'rjsx-mode
      (define-key rjsx-mode-map (kbd "C-d") nil))))

(defun reactjs/pre-init-prettier-js ()
  (if (eq javascript-fmt-tool 'prettier)
      (add-to-list 'spacemacs--prettier-modes 'rjsx-mode)))

(defun reactjs/post-init-smartparens ()
  (if dotspacemacs-smartparens-strict-mode
      (add-hook 'react-mode-hook #'smartparens-strict-mode)
    (add-hook 'react-mode-hook #'smartparens-mode)))

(defun reactjs/pre-init-web-beautify ()
  (if (eq javascript-fmt-tool 'web-beautify)
      (add-to-list 'spacemacs--web-beautify-modes
                   (cons 'rjsx-mode 'web-beautify-js))))

(defun reactjs/post-init-yasnippet ()
  (add-hook 'rjsx-mode-hook #'spacemacs//reactjs-setup-yasnippet))
